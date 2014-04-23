'use strict'

angular.module('cdmaSimulatorApp')
  .controller 'MainCtrl', ($scope, Code, DrawerService, Panel) ->

    $scope.panel1       = new Panel()
    $scope.panel1.paper = Raphael(document.getElementById('panel1'), 400, 300)

    $scope.panel2       = new Panel()
    $scope.panel2.paper = Raphael(document.getElementById('panel2'), 400, 300)

    $scope.panel3       = new Panel()
    $scope.panel3.paper = Raphael(document.getElementById('panel3'), 400, 300)

    $scope.panel4       = new Panel()
    $scope.panel4.paper = Raphael(document.getElementById('panel4'), 400, 300)

    $scope.panel5       = new Panel()
    $scope.panel5.paper = Raphael(document.getElementById('panel5'), 400, 300)


    $scope.updateCode = (panel) ->

      panel.paper.clear()

      panel.performSpreading()

      DrawerService.draw('Data signal', panel.data_signal, panel.paper)
      DrawerService.draw('Spreading code', panel.spreading_code, panel.paper, 100)
      DrawerService.draw('Transmitted (single)', panel.spreaded_code, panel.paper, 200)

      if $scope.panel1.spreaded_code && $scope.panel2.spreaded_code
        $scope.panel3.paper.clear()
        overlayed_code = $scope.panel1.spreaded_code.overlay($scope.panel2.spreaded_code)
        DrawerService.draw('Transmitted (overlayed)', overlayed_code, $scope.panel3.paper)

        $scope.panel4.paper.clear()
        despreaded_code = overlayed_code.despread($scope.panel1.spreading_code)
        DrawerService.draw('Despreaded code', despreaded_code, $scope.panel4.paper)

        $scope.panel5.paper.clear()
        despreaded_code = overlayed_code.despread($scope.panel2.spreading_code)
        DrawerService.draw('Despreaded code', despreaded_code, $scope.panel5.paper)


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
