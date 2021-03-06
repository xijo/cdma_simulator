'use strict'

class Drawer
  constructor: ->
    @chip_length = 10
    @border      = 30

  draw: (caption, code, paper, position = 0) ->
    return if !code
    values = code.values
    @text(caption, paper, 0, position + 5)
    @grid(values, paper, position + 20)
    @code(values, paper, position + 20)

  range: (code) ->
    maximum_value = _.max(code)
    if maximum_value == 0
      maximum_value = Math.abs _.min(code)
    minimum_value = maximum_value * -1
    occurring_values = [minimum_value..maximum_value].reverse()

  code: (code, paper, position) ->
    chip_offset      = @border
    paths            = []
    occurring_values = @range(code)

    for value in code
      y = 10 + occurring_values.indexOf(value) * 20
      paths.push "L#{chip_offset},#{position + y} L#{chip_offset + @chip_length},#{position + y}"
      chip_offset += @chip_length

    paper.path("M#{@border},#{position + 50} #{paths.join(' ')}").attr(stroke: 'red')

  grid: (code, paper, position) ->
    chip_offset      = @border
    occurring_values = @range(code)
    height           = _.max(occurring_values) * 2 + 1

    offset = 10
    for i in occurring_values by 1
      @text(i, paper, 5, position + offset)
      offset += 20

    for i in [0..(code.length * @chip_length)] by @chip_length
      path = paper.path("M#{chip_offset + i},#{position + 0} L#{chip_offset + i},#{position + (height * 20)}")
      if (i/@chip_length % 8) == 0
        path.attr(stroke: '#ccc', 'stroke-width': "2")
      else
        path.attr(stroke: '#ccc', 'stroke-width': "1", opacity: '0.5')

  text: (text, paper, x, y) ->
    paper.text(x, y, text).attr('font-size': 14, 'font-family': 'monospace', 'text-anchor': 'start')


angular.module('cdmaSimulatorApp').service('DrawerService', Drawer)

