(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['backbone'], function(Backbone) {
    return window.Boid = (function(_super) {

      __extends(_Class, _super);

      function _Class() {
        return _Class.__super__.constructor.apply(this, arguments);
      }

      _Class.prototype.defaults = {
        x: 0,
        y: 0,
        direction: null,
        steps: 0
      };

      _Class.prototype.set = function(attrs, options) {
        if (attrs.x || attrs.y) {
          attrs.steps = (this.get('steps') || 0) + 1;
        }
        return _Class.__super__.set.call(this, attrs, options);
      };

      return _Class;

    })(Backbone.Model);
  });

}).call(this);
