'use strict'

class Drawer
  constructor: ->
    @chip_length = 10
    @border      = 30

  draw: (caption, code, panel, position = 0) ->
    values = code.values
    @text(caption, panel, 0, position + 5)
    @grid(values, panel, position + 20)
    @code(values, panel, position + 20)

  code: (code, paper, position) ->
    chip_offset = @border

    paths = []
    minimum_value = _.min(code)
    maximum_value = _.max(code)
    occurring_values = [minimum_value..maximum_value].reverse()

    for value in code
      y = 10 + occurring_values.indexOf(value) * 20
      paths.push "L#{chip_offset},#{position + y} L#{chip_offset + @chip_length},#{position + y}"
      chip_offset += @chip_length

    paper.path("M#{@border},#{position + 50} #{paths.join(' ')}").attr(stroke: 'red')


  grid: (code, panel, position) ->
    chip_offset = @border

    minimum_value = _.min(code)
    maximum_value = _.max(code)
    occurring_values = [minimum_value..maximum_value].reverse()
    height = minimum_value * -1 + maximum_value + 1

    offset = 10
    for i in occurring_values by 1
      @text(i, panel, 5, position + offset)
      offset += 20

    for i in [0..(code.length * @chip_length)] by @chip_length
      path = panel.path("M#{chip_offset + i},#{position + 0} L#{chip_offset + i},#{position + (height * 20)}")
      if (i/@chip_length % 8) == 0
        path.attr(stroke: '#ccc', 'stroke-width': "2")
      else
        path.attr(stroke: '#ccc', 'stroke-width': "1", opacity: '0.5')


  text: (text, panel, x, y) ->
    panel.text(x, y, text).attr('font-size': 14, 'font-family': 'monospace', 'text-anchor': 'start')


angular.module('cdmaSimulatorApp').service('DrawerService', Drawer)

