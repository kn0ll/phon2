(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['three', 'views/matrix/column'], function(THREE, ColumnView) {
    return (function(_super) {

      __extends(_Class, _super);

      function _Class(matrix, padding, sideLength) {
        if (padding == null) {
          padding = 10;
        }
        if (sideLength == null) {
          sideLength = 30;
        }
        THREE.Object3D.apply(this);
        this.columns = matrix;
        this.padding = padding;
        this.sideLength = sideLength;
        this.columns.on('add', this.addColumnView, this);
        this.columns.on('remove', this.removeColumnView, this);
      }

      _Class.prototype.addColumnView = function(column) {
        var columnView, height, narrowWidth, offset, x;
        x = this.columns.indexOf(column);
        height = this.sideLength * Math.sqrt(3);
        narrowWidth = this.sideLength * 1.5;
        offset = x % 2 ? (-height - this.padding) * 0.5 : 0;
        columnView = new ColumnView(column, this.padding, this.sideLength);
        columnView.position.x = (narrowWidth + this.padding) * x;
        columnView.position.y = offset;
        return this.add(columnView.render());
      };

      _Class.prototype.removeColumnView = function(column) {
        var child, mesh, meshes, _i, _j, _len, _len1, _ref, _results;
        meshes = [];
        _ref = this.children;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          child = _ref[_i];
          if (child.column === column) {
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
        this.columns.each(this.addColumnView, this);
        return this;
      };

      _Class.prototype.onMousedown = function(e, mesh) {
        if (!mesh) {
          return this.columns.changeSelected(null, true);
        }
      };

      return _Class;

    })(THREE.Object3D);
  });

}).call(this);
