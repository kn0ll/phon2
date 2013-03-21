(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['three', 'graphics/hexagon'], function(THREE, Hexagon) {
    var materials;
    materials = {
      grey_wire: new THREE.MeshBasicMaterial({
        color: 0x707C80,
        wireframe: true,
        wireframeLinewidth: 1
      }),
      blue_face: new THREE.MeshBasicMaterial({
        color: 0x77D5D8
      }),
      yellow_face: new THREE.MeshBasicMaterial({
        color: 0xFDC648
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
    return (function(_super) {

      __extends(_Class, _super);

      function _Class(cell, sideLength) {
        Hexagon.apply(this, [10, sideLength, this.skins[cell.get('type')]]);
        this.cell = cell;
        this.cell.on('change:occupied', this.onOccupiedChange, this);
        this.cell.on('change:selected', this.onSelectedChange, this);
        this.cell.on('change:type', this.onTypeChange, this);
      }

      _Class.prototype.skins = {
        cell: [materials.grey_wire, materials.yellow_face],
        occupied: [materials.blue_face, materials.yellow_face],
        emitter: [materials.beige_face, materials.yellow_face],
        note: [materials.pink_face, materials.yellow_face],
        redirector: [materials.green_face, materials.yellow_face]
      };

      _Class.prototype.onOccupiedChange = function(cell, occupied) {
        var type;
        type = cell.get('type');
        return this.material.materials = occupied ? this.skins.occupied : this.skins[type];
      };

      _Class.prototype.onSelectedChange = function(cell, selected) {
        return this.animateHeight((selected ? 20 : -20));
      };

      _Class.prototype.onTypeChange = function(cell, type) {
        type = cell.get('type');
        return this.material.materials = this.skins[type];
      };

      return _Class;

    })(Hexagon);
  });

}).call(this);
