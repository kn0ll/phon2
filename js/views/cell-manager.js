(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['underscore', 'backbone', 'graphics/utils'], function(_, Backbone, ThreeUtils) {
    var $doc;
    $doc = $(document);
    return (function(_super) {
      var round, _i, _j, _results, _results1;

      __extends(_Class, _super);

      _Class.prototype._selected_cell = null;

      _Class.prototype._selected_parameter = null;

      _Class.prototype._on_rotate_handler = null;

      _Class.prototype.events = {
        'mousedown': 'onMousedown',
        'dblclick': 'onDblclick'
      };

      _Class.prototype.cell_parameters = {
        cell: {
          type: ['cell', 'note', 'emitter', 'redirector']
        },
        note: {
          type: ['cell', 'note', 'emitter', 'redirector'],
          key: (function() {
            _results = [];
            for (_i = 0; _i <= 127; _i++){ _results.push(_i); }
            return _results;
          }).apply(this),
          velocity: (function() {
            _results1 = [];
            for (_j = 0; _j <= 127; _j++){ _results1.push(_j); }
            return _results1;
          }).apply(this)
        },
        emitter: {
          type: ['cell', 'note', 'emitter', 'redirector'],
          direction: ['n', 'ne', 'se', 's', 'sw', 'nw']
        },
        redirector: {
          type: ['cell', 'note', 'emitter', 'redirector'],
          direction: ['n', 'ne', 'se', 's', 'sw', 'nw']
        }
      };

      function _Class(sceneView) {
        Backbone.View.apply(this);
        this.sceneView = sceneView;
        this.setElement(sceneView.el);
      }

      _Class.prototype.setCurrentParameter = function(val) {
        var cur_parameter_index, cur_parameter_value, options, parameter_count, parameters, type, _ref;
        if ((_ref = this._selected_parameter) == null) {
          this._selected_parameter = 'type';
        }
        type = this._selected_cell.get('type');
        options = this.cell_parameters[type];
        parameters = options[this._selected_parameter];
        parameter_count = parameters.length;
        cur_parameter_index = Math.abs(val % parameter_count);
        cur_parameter_value = parameters[cur_parameter_index];
        this._selected_cell.set(this._selected_parameter, cur_parameter_value);
        return console.log('setting', this._selected_parameter, cur_parameter_value);
      };

      round = function(from, to) {
        var resto;
        resto = from % to;
        if (resto <= (to / 2)) {
          return from - resto;
        } else {
          return from + to - resto;
        }
      };

      _Class.prototype.startRotate = function(e, mesh) {
        this._on_rotate_handler = this.onRotate(e, mesh);
        $doc.on('mousemove', this._on_rotate_handler);
        return $doc.one('mouseup', this.stopRotate(e, mesh));
      };

      _Class.prototype.onRotate = function(e, mesh) {
        var start_y, start_z_rotation;
        start_y = e.clientY;
        start_z_rotation = mesh.rotation.z;
        return function(move_e) {
          var diff_y;
          diff_y = move_e.clientY - start_y;
          return mesh.rotation.z = start_z_rotation + diff_y * .02;
        };
      };

      _Class.prototype.stopRotate = function(e, mesh) {
        var _this = this;
        return function(up_e) {
          var rounded, sixty, val;
          sixty = 60 * Math.PI / 180;
          rounded = sixty * Math.round(mesh.rotation.z / sixty);
          val = rounded / -sixty;
          mesh.animateRotation(rounded);
          _this.setCurrentParameter(val);
          return $doc.off('mousemove', _this._on_rotate_handler);
        };
      };

      _Class.prototype.selectCell = function(cell) {
        var _ref;
        if ((_ref = this._selected_cell) != null) {
          _ref.set('selected', false);
        }
        cell.set('selected', true);
        return this._selected_cell = cell;
      };

      _Class.prototype.deselectCell = function() {
        var _ref;
        if ((_ref = this._selected_cell) != null) {
          _ref.set('selected', false);
        }
        return this._selected_cell = void 0;
      };

      _Class.prototype.getClickedMesh = function(e) {
        var camera, el, matrixView, _ref;
        _ref = this.sceneView, el = _ref.el, camera = _ref.camera, matrixView = _ref.matrixView;
        return ThreeUtils.computeClickedMesh($(el), e, camera, matrixView);
      };

      _Class.prototype.onMousedown = function(e) {
        var cell, mesh;
        mesh = this.getClickedMesh(e);
        cell = mesh != null ? mesh.cell : void 0;
        if (cell) {
          if (cell !== this._selected_cell) {
            this.selectCell(cell);
          } else {
            this.startRotate(e, mesh);
          }
        } else {
          this.deselectCell();
        }
        return e.preventDefault();
      };

      _Class.prototype.onDblclick = function(e) {
        var cell, cur_index, mesh, option_names, options, type, _ref;
        if ((_ref = this._selected_parameter) == null) {
          this._selected_parameter = 'type';
        }
        mesh = this.getClickedMesh(e);
        cell = this._selected_cell;
        if (cell) {
          type = cell.get('type');
          options = this.cell_parameters[type];
          option_names = Object.keys(options);
          return cur_index = option_names.indexOf(this._selected_parameter);
        }
      };

      return _Class;

    })(Backbone.View);
  });

}).call(this);
