_ = require('underscore')
{Log, Logs, LogTableView} = require('logbook.coffee')

describe "LogTableView.State", ->

  beforeEach ->
    logs = _.map [1..73], (i)->
      {id: i}
    this.logs = new Logs(logs)
    this.state = new LogTableView.State(logs: this.logs)

  it 'should exist', ->
    expect(LogTableView.State).toBeDefined()

  it 'installs the logs provided at construction', ->
    expect(this.state.logs).toEqual(this.logs)

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

    it 'does not go below zero by default', ->
      this.state.set(offset: 13, limit: 20)
      this.state.swapLeft()
      expect(this.state.get('offset')).toEqual(0)

  describe 'swapRight', ->

    it 'adds limit to the offset', ->
      this.state.set(offset: 23, limit: 20)
      this.state.swapRight()
      expect(this.state.get('offset')).toEqual(43)

    it 'does not go above the number of logs minus limit', ->
      this.state.set(offset: 62, limit: 20)
      this.state.swapRight()
      expect(this.state.get('offset')).toEqual(54)

  describe 'filterProc', ->

    it 'returns a function', ->
      proc = this.state.filterProc()
      expect(typeof proc).toEqual('function')

    it 'returns true function on empty filer', ->
      proc = this.state.filterProc()
      expect(proc {}).toBeTrue
      expect(proc {name: "gisele"}).toBeTrue

    it 'returns a correct filer when singleton', ->
      this.state.set(filter: {name: "gis"})
      proc = this.state.filterProc()
      expect(proc {name: "gasele"}).toBeFalse
      expect(proc {name: "gisele"}).toBeTrue
      expect(proc {name: "egisele"}).toBeFalse

    it 'uses lowercase comparisons', ->
      this.state.set(filter: {name: "gis"})
      proc = this.state.filterProc()
      expect(proc {name: "Gisele"}).toBeTrue

    it 'returns a AND filer when not singleton', ->
      this.state.set(filter: {name: "gis", age: "10"})
      proc = this.state.filterProc()
      expect(proc {name: "gisele", age: "101"}).toBeTrue
      expect(proc {name: "gisele", age: "99"}).toBeFalse
      expect(proc {name: "gasele", age: "102"}).toBeFalse

    it 'supports backbone models as well as pojo', ->
      proc = this.state.filterProc()
      log = new Log(name: "gisele")
      expect(proc log).toBeTrue
      log = new Log(name: "gasele")
      expect(proc log).toBeFalse

  describe 'sliceIt', ->

    it 'slices as expected', ->
      this.state.set(offset: 10, limit: 5)
      ids = this.state.sliceIt(this.logs.toArray()).map (t)->
        t['id']
      expect(ids).toEqual([11, 12, 13, 14, 15])

  describe 'filterIt', ->

    beforeEach ->
      this.state.set(filter: {id: "1"})

    it 'filters an Array as expected', ->
      ids = this.state.filterIt(this.logs.toArray()).map (t)->
        t['id']
      expect(ids).toEqual([1, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19])
