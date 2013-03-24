(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['./component'], function(Component) {
    return (function(_super) {

      __extends(_Class, _super);

      _Class.prototype.tagName = 'input';

      _Class.prototype.attributes = {
        type: 'range'
      };

      function _Class(options) {
        if (options == null) {
          options = {};
        }
        this.attributes.min = options.min;
        this.attributes.max = options.max;
        this.attributes.step = options.step;
        Component.prototype.constructor.apply(this, arguments);
      }

      return _Class;

    })(Component);
  });

}).call(this);
