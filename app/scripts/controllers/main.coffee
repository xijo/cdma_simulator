'use strict'

angular.module('cdmaSimulatorApp')
  .controller 'MainCtrl', ($scope, Code, DrawerService) ->

    $scope.panel1 = Raphael(document.getElementById('panel1'), 400, 300)
    $scope.panel2 = Raphael(document.getElementById('panel2'), 400, 300)
    $scope.panel3 = Raphael(document.getElementById('panel3'), 400, 300)

    $scope.updateCode = (code, spread, panel) ->

      panel.clear()

      return if !code
      input = new Code(code)
      input = input.shift().stretch()
      DrawerService.draw('Data signal', input, panel)

      return if !spread
      spreading_code = new Code(spread)
      spreading_code = spreading_code.shift().repeat(code.length)
      DrawerService.draw('Spreading code', spreading_code, panel, 100)

      return if spread.length < 8
      spreaded_code = input.spread(spreading_code)
      DrawerService.draw('Spreaded code', spreaded_code, panel, 200)

      other_code1 = new Code([1, -1, 1, 1, -1, 1, -1, 1, -1, -1, -1, -1, 1, 1, -1, 1, 1, -1, 1, 1, -1, 1, -1, 1, -1, -1, -1, -1, 1, 1, -1, 1])
      other_code2 = new Code([1, -1, 1, -1, 1, -1, -1, 1, -1, -1, -1, -1, 1, -1, 1, -1, 1, -1, 1, 1, 1, -1, 1, 1, 1, -1, -1, 1, -1, 1, -1, 1])
      overlayed_code = spreaded_code.overlay(other_code1).overlay(other_code2)

      despreaded_code = overlayed_code.despread(spreading_code)

      DrawerService.draw('Overlayed code', overlayed_code, panel, 300)
      DrawerService.draw('Despreaded code', despreaded_code, panel, 450)

    $scope.randomSpread = (spread_number) ->
      rest   = _.without($scope.possible_spreads, $scope.spread1, $scope.spread2)
      random = rest[_.random(0, rest.length-1)]
      if spread_number == 1
        $scope.spread1 = random
        $scope.updateCode $scope.code1, $scope.spread1, $scope.panel1
      else
        $scope.spread2 = random
        $scope.updateCode $scope.code2, $scope.spread2, $scope.panel2

    $scope.possible_spreads = [
      '11111111',
      '10101010',
      '11001100',
      '10011001',
      '11110000',
      '10100101',
      '11000011',
      '10010110'
    ]
