(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['./component'], function(Component) {
    return (function(_super) {

      __extends(_Class, _super);

      function _Class() {
        return _Class.__super__.constructor.apply(this, arguments);
      }

      _Class.prototype.tagName = 'select';

      _Class.prototype.render = function() {
        var defaultVal, name, option, options, _i, _len;
        options = this.options.options;
        defaultVal = this.model.get(this.options.property);
        this.$el.empty();
        for (_i = 0, _len = options.length; _i < _len; _i++) {
          name = options[_i];
          option = document.createElement('option');
          option.innerHTML = name;
          option.setAttribute('value', name);
          this.$el.append(option);
          if (name === defaultVal) {
            option.selected = true;
          }
        }
        return Component.prototype.render.apply(this, arguments);
      };

      return _Class;

    })(Component);
  });

}).call(this);
