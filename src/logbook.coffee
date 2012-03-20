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

    # Resets model attributes to the default values
    reset: ->
      this.set(this.defaults)

    # Swaps the table at left
    swapLeft: (min = 0) ->
      offset = this.get('offset') - this.get('limit')
      this.set(offset: Math.max(offset, min))

    # Swaps the table at right
    swapRight: (max = 100) ->
      offset = this.get('offset') + this.get('limit')
      this.set(offset: Math.min(offset, max));

  LogTableView.State = State

exports.Log          = Log
exports.Logs         = Logs
exports.LogTableView = LogTableView