'use strict'

describe 'Service: Drawer', () ->

  # load the service's module
  beforeEach module 'cdmaSimulatorApp'

  # instantiate service
  Drawer = {}
  beforeEach inject (_Drawer_) ->
    Drawer = _Drawer_

  it 'should do something', () ->
    expect(!!Drawer).toBe true
