_        = require('underscore')
Backbone = require('backbone')

# A single log tuple as a Backbone model.
class Log extends Backbone.Model

# Collection of logs as a Backbone collection.
class Logs extends Backbone.Collection
  model: Log,
  url: '/logs'

#
# Logs view as a filterable and navigable table.
#
# This view displays a Logs collection passed under a `model` attribute at construction.
# It internally maintains a filtered and navigable viewport on that specific collection.
#
class LogTableView extends Backbone.View

  #
  # Table Viewport.
  #
  # This class encapsulates the table viewport, that is, it computes and provides access
  # to the logs that need to be displayed show at every moment. It takes into account the
  # current offset, limit and filtering constraints.
  #
  class Viewport extends Backbone.Model

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

    # Returns an array with the logs to show
    logsToShow: ->
      this.sliceIt(this.filterIt(this.logs.toArray()))

    # Swaps the table at left
    swapLeft: ->
      [limit, offset] = [this.get('limit'), this.get('offset')]
      newOffset = this.normalizeOffset(offset - limit)
      this.set(offset: newOffset);

    # Swaps the table at right
    swapRight: ->
      [limit, offset] = [this.get('limit'), this.get('offset')]
      newOffset = this.normalizeOffset(offset + limit)
      this.set(offset: newOffset);

    # Sets a specific filter
    setFilter: (filter)->
      this.set(filter: filter)

    ### PRIVATE ###

    normalizeOffset: (offset)->
      limit  = this.get('limit')
      wSize  = this.windowSize()
      offset = wSize-limit+1 if offset>wSize
      offset = 0 if offset<0
      offset

    windowSize: ->
      logs = this.filterIt(this.logs.toArray())
      logs.length

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

  # Export the Viewport class on the LogTableView
  LogTableView.Viewport = Viewport

  initialize: (options)->
    this.viewport = new Viewport(logs: this.model)
    this.viewport.on('change', this.refresh, this);

exports.Log          = Log
exports.Logs         = Logs
exports.LogTableView = LogTableView
