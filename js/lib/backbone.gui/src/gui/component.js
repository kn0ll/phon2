(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['backbone'], function(Backbone) {
    return (function(_super) {

      __extends(_Class, _super);

      function _Class() {
        return _Class.__super__.constructor.apply(this, arguments);
      }

      _Class.prototype.events = {
        'change': 'setVal'
      };

      _Class.prototype.initialize = function() {
        var event_name;
        Backbone.View.prototype.initialize.apply(this, arguments);
        event_name = 'change:' + this.options.property;
        return this.listenTo(this.model, event_name, this.render);
      };

      _Class.prototype.setVal = function(e) {
        var new_val;
        new_val = this.$el.val();
        this.model.set(this.options.property, new_val, {
          setting_view: this
        });
        return e.preventDefault();
      };

      _Class.prototype.render = function(model, val, options) {
        var current_val;
        if (options == null) {
          options = {};
        }
        if (this === options.setting_view) {
          return this;
        }
        Backbone.View.prototype.render.apply(this, arguments);
        current_val = this.model.get(this.options.property);
        this.$el.val(current_val);
        return this;
      };

      return _Class;

    })(Backbone.View);
  });

}).call(this);
