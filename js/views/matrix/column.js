(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['three', 'views/matrix/cell'], function(THREE, CellView) {
    return (function(_super) {

      __extends(_Class, _super);

      function _Class(column, padding, sideLength) {
        var cells;
        THREE.Object3D.apply(this);
        this.padding = padding;
        this.sideLength = sideLength;
        this.column = column;
        cells = this.column.cells;
        cells.on('add', this.addCellView, this);
        cells.on('remove', this.removeCellView, this);
      }

      _Class.prototype.addCellView = function(cell) {
        var cellView, height, y;
        height = this.sideLength * Math.sqrt(3);
        y = (-height - this.padding) * this.column.cells.indexOf(cell);
        cellView = new CellView(cell, this.sideLength);
        cellView.position.y = y;
        return this.add(cellView);
      };

      _Class.prototype.removeCellView = function(cell) {
        var child, mesh, meshes, _i, _j, _len, _len1, _ref, _results;
        meshes = [];
        _ref = this.children;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          child = _ref[_i];
          if (child.cell === cell) {
            meshes.push(child);
          }
        }
        _results = [];
        for (_j = 0, _len1 = meshes.length; _j < _len1; _j++) {
          mesh = meshes[_j];
          _results.push(this.remove(mesh));
        }
        return _results;
      };

      _Class.prototype.render = function() {
        this.column.cells.each(this.addCellView, this);
        return this;
      };

      return _Class;

    })(THREE.Object3D);
  });

}).call(this);
