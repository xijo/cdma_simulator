'use strict'

angular.module('cdmaSimulatorApp')
  .factory 'Code', () ->

    class Code
      constructor: (@input) ->
        @values = if typeof(@input) == 'string'
          @split(@input)
        else
          @input

      split: (input) ->
        input.split('').map (v) -> parseInt(v)

      shift: ->
        values = @values.map (value) -> if value == 0 then -1 else value
        new Code(values)

      # Stretches all chips to the given length
      stretch: (length = 8) ->
        result = []
        for value in @values
          result.push value for i in [1..length] by 1
        new Code(result)

      # Repeat the existing values given times
      repeat: (times = 4) ->
        result = []
        for i in [1..times] by 1
          result.push value for value in @values
        new Code(result)

      # Spread this code with given other one
      spread: (other_code) ->
        result = []
        for i in [0..(@values.length-1)] by 1
          result.push @values[i] * other_code.values[i]
        new Code(result)

      overlay: (other_code) ->
        result = []
        for i in [0..(@values.length-1)] by 1
          result.push @values[i] + other_code.values[i]
        new Code(result)

      despread: (spreading_code) ->
        result = []
        for i in [0..(@values.length-1)] by 1
          result.push @values[i] * spreading_code.values[i]
        new Code(result)
