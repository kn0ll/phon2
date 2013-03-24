(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['underscore', 'backbone', 'graphics/utils', 'gui/select', 'gui/range'], function(_, Backbone, ThreeUtils, SelectView, RangeView) {
    return (function(_super) {
      var createInputBlock,
        _this = this;

      __extends(_Class, _super);

      createInputBlock = function(label, view) {
        var $div;
        $div = $('<div class="input" />');
        $div.append($("<label>" + label + "</label>"));
        return $div.append(view.render().el);
      };

      _Class.prototype.tagName = 'form';

      _Class.prototype.className = 'hud-cell';

      function _Class(matrix) {
        var cell, _i, _len, _ref;
        Backbone.View.apply(this);
        this.matrix = matrix;
        _ref = this.matrix.get();
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          cell = _ref[_i];
          cell.on('change:selected', this.render, this);
        }
      }

      _Class.prototype.render = function(cell, selected) {
        var $fieldset, direction_view, key_view, type_view, velocity_view, x, y, _ref;
        this.$el.empty();
        if (!selected) {
          return this;
        }
        _ref = this.matrix.getCellCoords(cell), x = _ref.x, y = _ref.y;
        $fieldset = $('<fieldset />');
        type_view = new SelectView({
          model: cell,
          property: 'type',
          options: ['cell', 'note', 'emitter', 'redirector']
        });
        direction_view = new SelectView({
          model: cell,
          property: 'direction',
          options: ['n', 'ne', 'se', 's', 'sw', 'nw']
        });
        key_view = new RangeView({
          model: cell,
          property: 'key',
          min: 0,
          max: 127
        });
        velocity_view = new RangeView({
          model: cell,
          property: 'velocity',
          min: 0,
          max: 127
        });
        $fieldset.append($("<legend>cell (" + x + ", " + y + ")</legend>"));
        $fieldset.append(createInputBlock('type', type_view));
        $fieldset.append(createInputBlock('direction', direction_view));
        $fieldset.append(createInputBlock('key', key_view));
        this.$el.append($fieldset);
        return this;
      };

      return _Class;

    }).call(this, Backbone.View);
  });

}).call(this);
