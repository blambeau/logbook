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

    initialize: function(options) {
      var model = this.model;

      this.State = Backbone.Model.extend({
        offset:   function(){ return this.get('offset'); },
        limit:    function(){ return this.get('limit');  },
        swapLeft: function(){
          this.set({offset: Math.max(this.offset() - this.limit(), 0)});
        },
        swapRight: function(){
          this.set({offset: Math.min(this.offset() + this.limit(), this.filteredLogs().length-1)});
        },
        filteredLogs: function(){
          var logs;
          logs = model.toArray();
          logs = _.map(logs, function(x){ return x.toJSON(); });
          logs = this._filterLogs(logs);
          return logs;
        },
        logs: function(){
          logs = this._sliceLogs(this.filteredLogs());
          return logs;
        },
        _sliceLogs: function(logs){
          var offset = this.offset();
          var limit  = this.limit();
          return logs.slice(offset, offset + limit);
        },
        _filterLogs: function(logs){
          var filter = this.get('filter');
          return _.filter(logs, function(t){
            return _.all(filter, function(value, field){
              return (value == "" || t[field].toString().substr(0, value.length) == value);
            });
          });
        },
      });
      this.state = new this.State({ offset: 0, limit:  15, filter: {} });
      this.state.on('change', this.refresh, this);

      model.on('all', this.render, this);
    },

    // filtering controller
    setFilter: function(f){
      var filter = $.extend({}, this.state.get('filter'), f);
      this.state.set({offset: 0, filter: filter});
    },

    // event binding
    events: {
      "click .arrow-left  img": "swapLeft",
      "click .arrow-right img": "swapRight"
    },
    swapLeft:  function(){ this.state.swapLeft();  },
    swapRight: function(){ this.state.swapRight(); },

    // rendering
    render: function() {
      var view = this;
      $.get('views/log-table.mustache', function(tpl){
        view.$el.html(tpl);
        view.refresh();
      })
    },

    // refresh data
    refresh: function(){
      var view  = this;
      var state = this.state;
      $.get('views/log-table/tbody.mustache', function(tpl){
        var htmlText = Mustache.render(tpl, {logs: state.logs()});
        view.$el.find("tbody").html(htmlText);
      });
    }

  });

  exports.AppView = Backbone.View.extend({
    initialize: function(){
      this.logs = new LogBook.Logs;
      this.logTableView = new LogBook.LogTableView({
        model: this.logs,
        el: '#log-table'
      });
    },
    load: function(){
      this.logs.fetch();
    }
  });

})(LogBook);

var logBook;
$(document).ready(function(){
  logBook = new LogBook.AppView;
  logBook.load();
});