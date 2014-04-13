'use strict'

angular.module('cdmaSimulatorApp')
  .factory 'Panel', (Code) ->
    class Panel

      performSpreading: ->
        return if !@code
        @data_signal = new Code(@code)
        @data_signal = @data_signal.shift().stretch()

        return if !@spread
        @spreading_code = new Code(@spread)
        @spreading_code = @spreading_code.shift().repeat(@code.length)

        return if @spread.length < 8
        @spreaded_code = @data_signal.spread(@spreading_code)
