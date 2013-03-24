(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['underscore', 'backbone', 'views/hud/phon', 'views/hud/cell'], function(_, Backbone, PhonHUDView, CellHUDView) {
    return (function(_super) {

      __extends(_Class, _super);

      _Class.prototype.id = 'hud';

      function _Class(matrix, scheduler) {
        Backbone.View.apply(this);
        this.matrix = matrix;
        this.scheduler = scheduler;
      }

      _Class.prototype.render = function() {
        var cellView, phonView;
        phonView = new PhonHUDView(this.scheduler);
        cellView = new CellHUDView(this.matrix);
        this.$el.empty();
        this.$el.append(cellView.render().el);
        this.$el.append(phonView.render().el);
        return this;
      };

      return _Class;

    })(Backbone.View);
  });

}).call(this);
