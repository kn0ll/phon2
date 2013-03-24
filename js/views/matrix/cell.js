(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['underscore', 'three', 'graphics/hexagon'], function(_, THREE, Hexagon) {
    return (function(_super) {
      var $doc, cell_parameters, materials, onRotate, round, sixty, skins, startRotate, stopRotate, _i, _j, _results, _results1;

      __extends(_Class, _super);

      materials = {
        grey_wire: new THREE.MeshBasicMaterial({
          color: 0x707C80,
          wireframe: true,
          wireframeLinewidth: 1
        }),
        blue_face: new THREE.MeshBasicMaterial({
          color: 0x77D5D8
        }),
        beige_face: new THREE.MeshBasicMaterial({
          color: 0xCFCBA9
        }),
        pink_face: new THREE.MeshBasicMaterial({
          color: 0xEC4CB5
        }),
        green_face: new THREE.MeshBasicMaterial({
          color: 0x02A797
        })
      };

      skins = {
        cell: [materials.grey_wire],
        occupied: [materials.blue_face],
        emitter: [materials.beige_face],
        note: [materials.pink_face],
        redirector: [materials.green_face]
      };

      $doc = $(document);

      sixty = 60 * Math.PI / 180;

      round = function(from, to) {
        var rest;
        rest = from % to;
        if (rest <= (to / 2)) {
          return from - rest;
        } else {
          return from + to - rest;
        }
      };

      onRotate = function(e, mesh, setVal) {
        var start_y, start_z_rotation,
          _this = this;
        start_y = e.clientY;
        start_z_rotation = mesh.rotation.z;
        return function(move_e) {
          var diff_y, rounded, val;
          diff_y = move_e.clientY - start_y;
          mesh.rotation.z = start_z_rotation + diff_y * .02;
          rounded = sixty * Math.round(mesh.rotation.z / sixty);
          val = rounded / -sixty;
          return setVal(val);
        };
      };

      stopRotate = function(e, mesh, rotateHandler) {
        var _this = this;
        return function(up_e) {
          var rounded;
          rounded = sixty * Math.round(mesh.rotation.z / sixty);
          mesh.animateRotation(rounded);
          return $doc.off('mousemove', rotateHandler);
        };
      };

      startRotate = function(e, mesh, setVal) {
        var rotateHandler;
        rotateHandler = onRotate(e, mesh, setVal);
        $doc.on('mousemove', rotateHandler);
        return $doc.one('mouseup', stopRotate(e, mesh, rotateHandler));
      };

      cell_parameters = {
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

      function _Class(cell, sideLength) {
        Hexagon.apply(this, [10, sideLength, skins[cell.get('type')]]);
        this.cell = cell;
        this.cell.on('change:occupied', this.onOccupiedChange, this);
        this.cell.on('change:selected', this.onSelectedChange, this);
        this.cell.on('change:type', this.onTypeChange, this);
      }

      _Class.prototype.onOccupiedChange = function(cell, occupied) {
        var type;
        type = cell.get('type');
        return this.material.materials = occupied ? skins.occupied : skins[type];
      };

      _Class.prototype.onSelectedChange = function(cell, selected) {
        return this.animateHeight((selected ? 20 : -20));
      };

      _Class.prototype.onTypeChange = function(cell, type) {
        type = cell.get('type');
        return this.material.materials = skins[type];
      };

      _Class.prototype.setCurrentParameter = function(val) {
        var cur_parameter_index, cur_parameter_value, options, parameter_count, parameters, type, _ref;
        if ((_ref = this._selected_parameter) == null) {
          this._selected_parameter = 'type';
        }
        type = this.cell.get('type');
        options = cell_parameters[type];
        parameters = options[this._selected_parameter];
        parameter_count = parameters.length;
        cur_parameter_index = Math.abs(val % parameter_count);
        cur_parameter_value = parameters[cur_parameter_index];
        return this.cell.set(this._selected_parameter, cur_parameter_value);
      };

      _Class.prototype.onMousedown = function(e) {
        var cell;
        cell = this.cell;
        if (cell.get('selected')) {
          return startRotate(e, this, _.bind(this.setCurrentParameter, this));
        } else {
          return cell.set('selected', true);
        }
      };

      return _Class;

    })(Hexagon);
  });

}).call(this);
