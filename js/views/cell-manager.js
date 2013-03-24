(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['underscore', 'backbone', 'graphics/utils'], function(_, Backbone, ThreeUtils) {
    return (function(_super) {

      __extends(_Class, _super);

      function _Class() {
        return _Class.__super__.constructor.apply(this, arguments);
      }

      _Class.prototype.onDblclick = function(e) {
        var cell, cur_index, mesh, next_option_name, option_names, options, type;
        mesh = this.getClickedMesh(e);
        cell = mesh.cell;
        if (cell) {
          type = cell.get('type');
          options = this.cell_parameters[type];
          option_names = Object.keys(options);
          cur_index = option_names.indexOf(this._selected_parameter);
          next_option_name = option_names[cur_index + 1];
          return this._selected_parameter = next_option_name || 'type';
        }
      };

      return _Class;

    })(Backbone.View);
  });

}).call(this);
