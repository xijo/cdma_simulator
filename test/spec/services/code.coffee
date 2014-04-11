'use strict'

describe 'Service: Code', ->

  # load the service's module
  beforeEach module 'cdmaSimulatorApp'

  # instantiate service
  Code = {}
  beforeEach inject (_Code_) ->
    Code = _Code_
    @code = new Code([1, -1, -1])

  describe 'instantiation', ->
    it 'works with a string', ->
      code = new Code('101')
      expect(code.values).toEqual([1, 0, 1])

    it 'works with an array', ->
      code = new Code([1, 0, 0])
      expect(code.values).toEqual([1, 0, 0])

  describe '#shift', ->
    it 'shifts all zeros to minus one', ->
      values = new Code([1, 0, 0]).shift().values
      expect(values).toEqual([1, -1, -1])

  describe '#stretch', ->
    it 'stretches the code to a given length', ->
      values = @code.stretch(2).values
      expect(values).toEqual([1, 1, -1, -1, -1, -1])

  describe '#repeat', ->
    it 'repeats the given code n times', ->
      values = @code.repeat(2).values
      expect(values).toEqual([1, -1, -1, 1, -1, -1])

  describe '#spread', ->
    it 'spreads one code with another and returns a new one', ->
      spreading_code = new Code([-1, -1, 1])
      values = @code.spread(spreading_code).values
      expect(values).toEqual([-1, 1, -1])

  describe '#despread', ->
    it 'despreads one code with another and returns the resulting', ->
      code           = new Code([-1, 1, -1])
      spreading_code = new Code([-1, -1, 1])
      values = code.despread(spreading_code).values
      expect(values).toEqual(@code.values)

  describe '#overlay', ->
    it 'overlays one code with another and returns the resulting code', ->
      other_code = new Code([-1, -1, 1])
      values = @code.overlay(other_code).values
      expect(values).toEqual([0, -2, 0])

