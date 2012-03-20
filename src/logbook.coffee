_        = require('underscore')
Backbone = require('backbone')

class Log extends Backbone.Model

class Logs extends Backbone.Collection
  model: Log,
  url: '/logs'

class LogTableView extends Backbone.View

  # This class encapsulates the state of the table view itself.
  class State extends Backbone.Model

    # Default state values (no offset, show 15 logs, unfiltered)
    defaults: {
      offset: 0,
      limit : 15,
      filter: {}
    }

    initialize: (options)->
      this.logs = options.logs || new Logs

    # Resets model attributes to the default values
    reset: ->
      this.set(this.defaults)

    # Swaps the table at left
    swapLeft: ->
      [limit, offset] = [this.get('limit'), this.get('offset')]
      newOffset = offset - limit
      this.set(offset: Math.max(newOffset, 0))

    # Swaps the table at right
    swapRight: ->
      [limit, offset] = [this.get('limit'), this.get('offset')]
      newOffset = offset + limit
      max = this.logs.size() - limit + 1
      this.set(offset: Math.min(newOffset, max));

    ### PRIVATE ###

    sliceIt: (logs)->
      [limit, offset] = [this.get('limit'), this.get('offset')]
      logs[offset...offset+limit]

    filterProc: ->
      filter  = this.get('filter')
      (tuple)->
        _.all filter, (value, field)->
          search = value.toString().toLowerCase()
          source = tuple[field].toString().toLowerCase()
          source.indexOf(search) == 0

    filterIt: (logs)->
      _.filter logs, this.filterProc()

  LogTableView.State = State

exports.Log          = Log
exports.Logs         = Logs
exports.LogTableView = LogTableView
