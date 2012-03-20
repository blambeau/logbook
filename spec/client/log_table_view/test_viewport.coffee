_ = require('underscore')
{Log, Logs, LogTableView} = require('logbook.coffee')

describe "LogTableView.Viewport", ->

  beforeEach ->
    logs = _.map [1..73], (i)->
      {id: i}
    this.logs = new Logs(logs)
    this.viewport = new LogTableView.Viewport(logs: this.logs)

  it 'is exported by the LogTableView', ->
    expect(LogTableView.Viewport).toBeDefined()

  it 'installs the logs provided at construction', ->
    expect(this.viewport.logs).toEqual(this.logs)

  it 'has defaults', ->
    expect(this.viewport.get('offset')).toEqual(0)
    expect(this.viewport.get('limit')).toEqual(15)
    expect(this.viewport.get('filter')).toEqual({})

  it 'allows setting attributes', ->
    this.viewport.set('offset', 12)
    expect(this.viewport.get('offset')).toEqual(12)

  it 'has a reset for getting back to defaults', ->
    this.viewport.set('offset', 12)
    this.viewport.reset()
    expect(this.viewport.get('offset')).toEqual(0)

  describe 'setFilter', ->

    it 'allows setting a filter', ->
      this.viewport.setFilter(name: "bla")
      expect(this.viewport.get('filter')).toEqual(name: "bla")

  describe 'filterProc', ->

    it 'returns a function', ->
      proc = this.viewport.filterProc()
      expect(typeof proc).toEqual('function')

    it 'returns true function on empty filer', ->
      proc = this.viewport.filterProc()
      expect(proc {}).toBeTrue
      expect(proc {name: "gisele"}).toBeTrue

    it 'returns a correct filer when singleton', ->
      this.viewport.set(filter: {name: "gis"})
      proc = this.viewport.filterProc()
      expect(proc {name: "gasele"}).toBeFalse
      expect(proc {name: "gisele"}).toBeTrue
      expect(proc {name: "egisele"}).toBeFalse

    it 'uses lowercase comparisons', ->
      this.viewport.set(filter: {name: "gis"})
      proc = this.viewport.filterProc()
      expect(proc {name: "Gisele"}).toBeTrue

    it 'returns a AND filer when not singleton', ->
      this.viewport.set(filter: {name: "gis", age: "10"})
      proc = this.viewport.filterProc()
      expect(proc {name: "gisele", age: "101"}).toBeTrue
      expect(proc {name: "gisele", age: "99"}).toBeFalse
      expect(proc {name: "gasele", age: "102"}).toBeFalse

    it 'supports backbone models as well as pojo', ->
      proc = this.viewport.filterProc()
      log = new Log(name: "gisele")
      expect(proc log).toBeTrue
      log = new Log(name: "gasele")
      expect(proc log).toBeFalse

  describe 'sliceIt', ->

    it 'slices as expected', ->
      this.viewport.set(offset: 10, limit: 5)
      ids = this.viewport.sliceIt(this.logs.toArray()).map (t)->
        t['id']
      expect(ids).toEqual([11, 12, 13, 14, 15])

  describe 'filterIt', ->

    beforeEach ->
      this.viewport.set(filter: {id: "1"})

    it 'filters an Array as expected', ->
      ids = this.viewport.filterIt(this.logs.toArray()).map (t)->
        t['id']
      expect(ids).toEqual([1, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19])

  describe 'logsToShow', ->

    beforeEach ->
      this.viewport.set(filter: {id: "2"})

    it 'returns expected logs', ->
      this.viewport.set(offset: 2, limit: 5)
      ids = this.viewport.logsToShow().map (log)->
        log['id']
      expect(ids).toEqual([21, 22, 23, 24, 25])

    it 'supports a window that is too large', ->
      this.viewport.set(offset: 10, limit: 15)
      ids = this.viewport.logsToShow().map (log)->
        log['id']
      expect(ids).toEqual([29])

    it 'supports an empty selection window that is too large', ->
      this.viewport.set(offset: 15, limit: 15)
      ids = this.viewport.logsToShow().map (log)->
        log['id']
      expect(ids).toEqual([])

  describe 'normalizeOffset', ->

    it 'bounds on last window if too big', ->
      n = this.viewport.normalizeOffset(100)
      expect(n).toEqual(73 - 15 + 1)

    it 'bounds on zero is less than 0', ->
      n = this.viewport.normalizeOffset(-1)
      expect(n).toEqual(0)

  describe 'swapLeft', ->

    it 'removes limit to the offset', ->
      this.viewport.set(offset: 43, limit: 20)
      this.viewport.swapLeft()
      expect(this.viewport.get('offset')).toEqual(23)

    it 'does not go below zero by default', ->
      this.viewport.set(offset: 13, limit: 20)
      this.viewport.swapLeft()
      expect(this.viewport.get('offset')).toEqual(0)

  describe 'swapRight', ->

    it 'adds limit to the offset', ->
      this.viewport.set(offset: 23, limit: 20)
      this.viewport.swapRight()
      expect(this.viewport.get('offset')).toEqual(43)

    it 'does not go above the number of logs minus limit', ->
      this.viewport.set(offset: 62, limit: 20)
      this.viewport.swapRight()
      expect(this.viewport.get('offset')).toEqual(54)

    it 'takes filtered logs into account', ->
      this.viewport.set(filter: {id: "2"})
      this.viewport.set(offset: 2, limit: 20)
      this.viewport.swapRight()
      expect(this.viewport.get('offset')).toEqual(0)
