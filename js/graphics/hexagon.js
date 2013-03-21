(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['underscore', 'three', 'tween'], function(_, THREE, TWEEN) {
    var Hexagon;
    return Hexagon = (function(_super) {
      var tween;

      __extends(Hexagon, _super);

      function Hexagon(depth, sideLength, materials) {
        var extrudeSettings, material, shape2d, shape3d;
        materials = _.flatten([materials]);
        extrudeSettings = {
          amount: depth,
          bevelEnabled: false,
          steps: 1
        };
        shape2d = new THREE.Shape();
        this.height = sideLength * Math.sqrt(3);
        shape2d.moveTo(0, 0);
        shape2d.lineTo(sideLength, 0);
        shape2d.lineTo(sideLength * 1.5, -this.height * .5);
        shape2d.lineTo(sideLength, -this.height);
        shape2d.lineTo(0, -this.height);
        shape2d.lineTo(-sideLength * .5, -this.height * .5);
        shape3d = shape2d.extrude(extrudeSettings);
        material = new THREE.MeshFaceMaterial(materials);
        THREE.Mesh.apply(this, [shape3d, material]);
        THREE.GeometryUtils.center(shape3d);
      }

      tween = function(obj, prop, to, time, onUpdate) {
        var options;
        options = {};
        options[prop] = to;
        return (new TWEEN.Tween(obj)).to(options, time).easing(TWEEN.Easing.Quadratic.In).onUpdate(onUpdate || function() {}).start();
      };

      Hexagon.prototype.animateHeight = function(h) {
        var animate, geo, update, vertex, _i, _len, _ref, _results;
        geo = this.geometry;
        update = function() {
          return geo.verticesNeedUpdate = true;
        };
        animate = function(v) {
          return tween(v, 'z', v.z + h, 50, update);
        };
        _ref = _.last(geo.vertices, 6);
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          vertex = _ref[_i];
          _results.push(animate(vertex));
        }
        return _results;
      };

      Hexagon.prototype.animateRotation = function(r) {
        return tween(this.rotation, 'z', r, 100);
      };

      Hexagon.prototype.setSidesMaterialIndex = function(i) {
        var face, _i, _len, _ref, _results;
        _ref = _.last(this.geometry.faces, 6);
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          face = _ref[_i];
          _results.push(face.materialIndex = i);
        }
        return _results;
      };

      return Hexagon;

    })(THREE.Mesh);
  });

}).call(this);
