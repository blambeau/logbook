var LogBook = (typeof module !== "undefined" && module.exports) || {};

(function (exports) {

  // One single log tuple as a Backbone model
  exports.Log  = Backbone.Model.extend({});

  // All log tuples (as seen by the client) as a Backbone collection
  exports.Logs = Backbone.Collection.extend({
   model: exports.Log,
     url: '/logs'
  });

  // The table view
  exports.LogTableView = Backbone.View.extend({

    events: {
      "click .arrow-left  img": "swapLeft",
      "click .arrow-right img": "swapRight"
    },

    initialize: function(options) {
      this.model.on('all', this.render, this);
      this.State = Backbone.Model.extend({});
      this.state = new this.State({
        offset: 0,
        limit: 15
      });
      this.state.on('all', this.render, this);
    },

    offset: function(){ return this.state.get('offset'); },
    limit:  function(){ return this.state.get('limit');  },

    getLogs: function() {
      offset = this.offset();
      limit  = this.limit();
      return this.model
                 .map(function(x){ return x.toJSON(); })
                 .slice(offset, offset + limit);
    },

    swapLeft: function(){
      this.state.set({offset: Math.max(this.offset() - this.limit(), 0)});
    },

    swapRight: function(){
      this.state.set({offset: Math.min(this.offset() + this.limit(), this.model.size()-1)});
    },

    render: function() {
      var view = this;
      $.get('views/log-table.mustache', function(tpl){
        var shownlogs = view.getLogs(view.state);
        var htmlText = Mustache.render(tpl, {logs: shownlogs});
        view.$el.html(htmlText);
      })
    }

  });

})(LogBook);

$(document).ready(function(){
  var logs = new LogBook.Logs;
  var logTableView = new LogBook.LogTableView({model: logs, el: '#log-table'});
  logs.fetch();
})
