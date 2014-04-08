'use strict'

angular.module('cdmaSimulatorApp')
  .controller 'MainCtrl', ($scope) ->
    $scope.awesomeThings = [
      'HTML5 Boilerplate'
      'AngularJS'
      'Karma'
    ]

    $scope.splitCode = (input) ->
      input.split('').map (v) -> parseInt(v)

    $scope.shiftCode = (code) ->
      code.map (c) -> if c == 0 then -1 else 1

    $scope.stretchCode = (code) ->
      result = []
      for c in code
        result.push c for i in [0..7] by 1
      result

    $scope.repeatCode = (code, times = 4) ->
      result = []
      for i in [0..(times-1)] by 1
        result.push c for c in code
      result

    $scope.spreadCode = (input, spreading_code) ->
      result = []
      for i in [0..(input.length-1)] by 1
        result.push input[i] * spreading_code[i]
      result

    $scope.overlayCode = (code1, code2) ->
      result = []
      for i in [0..(code1.length-1)] by 1
        result.push code1[i] + code2[i]
      result

    $scope.despreadCode = (overlayed_code, spreading_code) ->
      result = []
      for i in [0..(overlayed_code.length-1)] by 1
        result.push overlayed_code[i] * spreading_code[i]
      result

    $scope.drawCode = (code, paper, position = 0) ->
      chip_offset = 30
      chip_length = 10

      paths = []
      minimum_value = _.min(code)
      maximum_value = _.max(code)
      occurring_values = [minimum_value..maximum_value].reverse()

      for value in code
        y = 10 + occurring_values.indexOf(value) * 20
        paths.push "L#{chip_offset},#{position + y} L#{chip_offset + chip_length},#{position + y}"
        chip_offset += chip_length

      paper.path("M30,#{position + 50} #{paths.join(' ')}").attr(stroke: 'red')

    $scope.drawGrid = (code, paper, position = 0) ->
      chip_offset = 30
      chip_length = 10

      minimum_value = _.min(code)
      maximum_value = _.max(code)
      occurring_values = [minimum_value..maximum_value].reverse()
      height = minimum_value * -1 + maximum_value + 1

      offset = 10
      for i in occurring_values by 1
        $scope.drawText(i, paper, 10, position + offset)
        offset += 20

      for i in [0..(code.length * chip_length)] by chip_length
        path = paper.path("M#{chip_offset + i},#{position + 0} L#{chip_offset + i},#{position + (height * 20)}")
        if (i/chip_length % 8) == 0
          path.attr(stroke: '#ccc', 'stroke-width': "2")
        else
          path.attr(stroke: '#ccc', 'stroke-width': "1", opacity: '0.5')

    $scope.drawText = (text, paper, x, y) ->
      paper.text(x, y, text).attr('font-size': 14, 'font-family': 'monospace')

    # # # # # # # # # # # # # # # # # # # # # #

    $scope.paper = Raphael(10, 50, 800, 800)

    input          = $scope.splitCode('1110')
    input          = $scope.shiftCode(input)
    input          = $scope.stretchCode(input)
    spreading_code = $scope.splitCode('11011011')
    spreading_code = $scope.shiftCode(spreading_code)
    spreading_code = $scope.repeatCode(spreading_code)

    spreaded_code  = $scope.spreadCode(input, spreading_code)

    other_code1 = [1, -1, 1, 1, -1, 1, -1, 1, -1, -1, -1, -1, 1, 1, -1, 1, 1, -1, 1, 1, -1, 1, -1, 1, -1, -1, -1, -1, 1, 1, -1, 1]
    other_code2 = [1, -1, 1, -1, 1, -1, -1, 1, -1, -1, -1, -1, 1, -1, 1, -1, 1, -1, 1, 1, 1, -1, 1, 1, 1, -1, -1, 1, -1, 1, -1, 1]
    overlayed_code = $scope.overlayCode(spreaded_code, other_code1)
    overlayed_code = $scope.overlayCode(overlayed_code, other_code2)

    despreaded_code = $scope.despreadCode(overlayed_code, spreading_code)

    $scope.drawGrid(input, $scope.paper)
    $scope.drawCode(input, $scope.paper)

    $scope.drawGrid(spreading_code, $scope.paper, 100)
    $scope.drawCode(spreading_code, $scope.paper, 100)

    $scope.drawGrid(spreaded_code, $scope.paper, 200)
    $scope.drawCode(spreaded_code, $scope.paper, 200)

    $scope.drawGrid(overlayed_code, $scope.paper, 300)
    $scope.drawCode(overlayed_code, $scope.paper, 300)

    $scope.drawGrid(despreaded_code, $scope.paper, 450)
    $scope.drawCode(despreaded_code, $scope.paper, 450)
