'use strict'

angular.module('cdmaSimulatorApp')
  .controller 'MainCtrl', ($scope, Code, DrawerService, Panel) ->

    $scope.panel1       = new Panel()
    $scope.panel1.paper = Raphael(document.getElementById('panel1'), 400, 300)

    $scope.panel2       = new Panel()
    $scope.panel2.paper = Raphael(document.getElementById('panel2'), 400, 300)

    $scope.panel3       = new Panel()
    $scope.panel3.paper = Raphael(document.getElementById('panel3'), 400, 300)


    $scope.updateCode = (panel) ->

      panel.paper.clear()

      panel.performSpreading()

      DrawerService.draw('Data signal', panel.data_signal, panel.paper)
      DrawerService.draw('Spreading code', panel.spreading_code, panel.paper, 100)
      DrawerService.draw('Spreaded code', panel.spreaded_code, panel.paper, 200)

      if $scope.panel1.spreaded_code && $scope.panel2.spreaded_code
        $scope.panel3.paper.clear()
        overlayed_code = $scope.panel1.spreaded_code.overlay($scope.panel2.spreaded_code)
        DrawerService.draw('Overlayed code', overlayed_code, $scope.panel3.paper)

      # despreaded_code = overlayed_code.despread(spreading_code)

      # DrawerService.draw('Despreaded code', despreaded_code, panel, 450)

    $scope.randomSpread = (panel) ->
      rest   = _.without($scope.possible_spreads, $scope.panel1.spread, $scope.panel2.spread)
      random = rest[_.random(0, rest.length-1)]
      panel.spread = random
      $scope.updateCode panel

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
