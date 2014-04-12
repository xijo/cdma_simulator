'use strict'

angular.module('cdmaSimulatorApp')
  .controller 'MainCtrl', ($scope, Code) ->
    $scope.awesomeThings = [
      'HTML5 Boilerplate'
      'AngularJS'
      'Karma'
    ]

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

    $scope.panel1 = Raphael(document.getElementById('panel1'), 400, 800)
    $scope.panel2 = Raphael(document.getElementById('panel2'), 400, 800)

    $scope.updateCode = (code, spread, panel) ->

      panel.clear()

      return if !code || !spread

      length = code.length

      input          = new Code(code)
      input          = input.shift().stretch()

      spreading_code = new Code(spread)
      spreading_code = spreading_code.shift().repeat(length)

      spreaded_code  = input.spread(spreading_code)

      other_code1 = new Code([1, -1, 1, 1, -1, 1, -1, 1, -1, -1, -1, -1, 1, 1, -1, 1, 1, -1, 1, 1, -1, 1, -1, 1, -1, -1, -1, -1, 1, 1, -1, 1])
      other_code2 = new Code([1, -1, 1, -1, 1, -1, -1, 1, -1, -1, -1, -1, 1, -1, 1, -1, 1, -1, 1, 1, 1, -1, 1, 1, 1, -1, -1, 1, -1, 1, -1, 1])
      overlayed_code = spreaded_code.overlay(other_code1).overlay(other_code2)

      despreaded_code = overlayed_code.despread(spreading_code)

      $scope.drawGrid(input.values, panel)
      $scope.drawCode(input.values, panel)

      $scope.drawGrid(spreading_code.values, panel, 100)
      $scope.drawCode(spreading_code.values, panel, 100)

      $scope.drawGrid(spreaded_code.values, panel, 200)
      $scope.drawCode(spreaded_code.values, panel, 200)

      $scope.drawGrid(overlayed_code.values, panel, 300)
      $scope.drawCode(overlayed_code.values, panel, 300)

      $scope.drawGrid(despreaded_code.values, panel, 450)
      $scope.drawCode(despreaded_code.values, panel, 450)
