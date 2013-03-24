(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['./component'], function(Component) {
    return (function(_super) {

      __extends(_Class, _super);

      _Class.prototype.tagName = 'input';

      _Class.prototype.attributes = {
        type: 'button'
      };

      _Class.prototype.events = {
        'click': 'click'
      };

      function _Class(options) {
        if (options == null) {
          options = {};
        }
        this.attributes.value = options.method;
        Component.prototype.constructor.apply(this, arguments);
      }

      _Class.prototype.click = function() {
        return this.model[this.options.method]();
      };

      return _Class;

    })(Component);
  });

}).call(this);
