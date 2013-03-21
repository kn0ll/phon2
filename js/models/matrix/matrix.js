(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['underscore', 'backbone', 'models/matrix/column'], function(_, Backbone, Column) {
    return (function(_super) {

      __extends(_Class, _super);

      _Class.prototype.model = Column;

      function _Class(width, height) {
        var x, _i;
        Backbone.Collection.apply(this);
        for (x = _i = 0; 0 <= width ? _i <= width : _i >= width; x = 0 <= width ? ++_i : --_i) {
          this.add({
            height: height
          });
        }
      }

      _Class.prototype.get = function(x, y) {
        if (x !== void 0 && y !== void 0) {
          if (this.at(x)) {
            return this.at(x).cells.at(y);
          } else {
            return null;
          }
        } else {
          return _.flatten(this.map(function(col) {
            return col.cells.map(function(cell) {
              return cell;
            });
          }));
        }
      };

      _Class.prototype.set = function(cell) {
        var attrs, x, y, _i, _len, _ref, _results;
        _ref = _.flatten([cell]);
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          attrs = _ref[_i];
          x = attrs.x, y = attrs.y;
          delete attrs.x;
          delete attrs.y;
          _results.push(this.get(x, y).set(attrs));
        }
        return _results;
      };

      _Class.prototype.getCellCoords = function(cell) {
        var coords;
        coords = {};
        this.each(function(column, x) {
          return column.cells.each(function(c_cell, y) {
            if (cell === c_cell) {
              return coords = {
                x: x,
                y: y
              };
            }
          });
        });
        return coords;
      };

      _Class.prototype.getAdjacent = function(x, y, direction) {
        var odd;
        odd = x % 2;
        switch (direction) {
          case 'ne':
            return this.get(x + 1, odd ? y : y - 1);
          case 'n':
            return this.get(x, y - 1);
          case 'se':
            return this.get(x + 1, odd ? y + 1 : y);
          case 's':
            return this.get(x, y + 1);
          case 'sw':
            return this.get(x - 1, odd ? y + 1 : y);
          case 'nw':
            return this.get(x - 1, odd ? y : y - 1);
        }
      };

      return _Class;

    })(Backbone.Collection);
  });

}).call(this);
