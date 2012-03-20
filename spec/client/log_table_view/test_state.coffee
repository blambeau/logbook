{LogTableView} = require('logbook.coffee')

describe "LogTableView.State", ->

  beforeEach ->
    this.state = new LogTableView.State

  it 'should exist', ->
    expect(LogTableView.State).toBeDefined()

  it 'has defaults', ->
    expect(this.state.get('offset')).toEqual(0)
    expect(this.state.get('limit')).toEqual(15)
    expect(this.state.get('filter')).toEqual({})

  it 'allows setting attributes', ->
    this.state.set('offset', 12)
    expect(this.state.get('offset')).toEqual(12)

  it 'has a reset for getting back to defaults', ->
    this.state.set('offset', 12)
    this.state.reset()
    expect(this.state.get('offset')).toEqual(0)

  describe 'swapLeft', ->

    it 'removes limit to the offset', ->
      this.state.set(offset: 43, limit: 20)
      this.state.swapLeft()
      expect(this.state.get('offset')).toEqual(23)

    it 'does not go below the specified min', ->
      this.state.set(offset: 43, limit: 20)
      this.state.swapLeft(25)
      expect(this.state.get('offset')).toEqual(25)

    it 'does not go below zero by default', ->
      this.state.set(offset: 13, limit: 20)
      this.state.swapLeft()
      expect(this.state.get('offset')).toEqual(0)

  describe 'swapRight', ->

    it 'adds limit to the offset', ->
      this.state.set(offset: 43, limit: 20)
      this.state.swapRight()
      expect(this.state.get('offset')).toEqual(63)

    it 'does not go above the specified max', ->
      this.state.set(offset: 43, limit: 20)
      this.state.swapRight(50)
      expect(this.state.get('offset')).toEqual(50)

    it 'does not go above 100 by default', ->
      this.state.set(offset: 98, limit: 20)
      this.state.swapRight()
      expect(this.state.get('offset')).toEqual(100)
