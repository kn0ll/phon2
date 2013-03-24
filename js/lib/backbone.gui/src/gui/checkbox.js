(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['./component'], function(Component) {
    return (function(_super) {

      __extends(_Class, _super);

      function _Class() {
        return _Class.__super__.constructor.apply(this, arguments);
      }

      _Class.prototype.tagName = 'input';

      _Class.prototype.attributes = {
        type: 'checkbox'
      };

      _Class.prototype.setVal = function(e) {
        var new_val;
        new_val = this.$el.prop('checked');
        this.model.set(this.options.property, new_val, {
          setting_view: this
        });
        return e.preventDefault();
      };

      _Class.prototype.render = function() {
        var default_val;
        default_val = this.model.get(this.options.property);
        this.$el.prop('checked', default_val);
        return Component.prototype.render.apply(this, arguments);
      };

      return _Class;

    })(Component);
  });

}).call(this);
