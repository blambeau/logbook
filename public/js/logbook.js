$(document).ready(function(){

  var Log = Backbone.Model.extend({});
  var LogStore = Backbone.Collection.extend({
   model: Log,
     url: '/logs'
  });

  var LogTableView = Backbone.View.extend({

    offset: 0,

    howManyShown: 15,

    events: {
      "click .arrow-left  img": "swapLeft",
      "click .arrow-right img": "swapRight"
    },

    swapLeft: function(){
      this.offset = Math.max(this.offset - this.howManyShown, 0);
      this.render();
    },

    swapRight: function(){
      this.offset = Math.min(this.offset + this.howManyShown, logs.size()-1);
      this.render();
    },

    logsToShow: function(){
      var l = logs.map(function(x){ return x.toJSON(); });
      return l.slice(this.offset, this.offset + this.howManyShown);
    },

    render: function() {
      view = this;
      $.get('views/log-table.mustache', function(tpl){
        var shownlogs = view.logsToShow();
        var htmlText = Mustache.render(tpl, {logs: shownlogs});
        view.$el.html(htmlText);
      })
    }

  });

  var logs = new LogStore;
  var logTableView = new LogTableView({el: '#log-table'});

  logs.fetch({success: function(){ logTableView.render(); }});
})
