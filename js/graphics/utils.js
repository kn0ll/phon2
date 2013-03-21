(function() {

  define(function() {
    var Utils;
    Utils = (function() {
      var getRelativeMouse,
        _this = this;

      function Utils() {}

      getRelativeMouse = function($canvas, e) {
        var offset, rel_x, rel_y;
        offset = $canvas.offset();
        rel_x = e.clientX - offset.left;
        rel_y = e.clientY - offset.top;
        return {
          x: (rel_x / $canvas.width()) * 2 - 1,
          y: -(rel_y / $canvas.height()) * 2 + 1
        };
      };

      Utils.prototype.computeObject3DBoundingBox = function(object3d) {
        var bounds;
        bounds = {
          min: new THREE.Vector3(Infinity, Infinity, Infinity),
          max: new THREE.Vector3(-Infinity, -Infinity, -Infinity)
        };
        object3d.traverse(function(child) {
          var world_max, world_min;
          if (child instanceof THREE.Mesh) {
            world_min = child.localToWorld(child.geometry.boundingBox.min);
            world_max = child.localToWorld(child.geometry.boundingBox.max);
            bounds.min.x = Math.min(bounds.min.x, world_min.x);
            bounds.min.y = Math.min(bounds.min.y, world_min.y);
            bounds.min.z = Math.min(bounds.min.z, world_min.z);
            bounds.max.x = Math.max(bounds.max.x, world_max.x);
            bounds.max.y = Math.max(bounds.max.y, world_max.y);
            return bounds.max.z = Math.max(bounds.max.z, world_max.z);
          }
        });
        return bounds;
      };

      Utils.prototype.computeObject3DCenter = function(object3d) {
        var bounds, center;
        bounds = this.computeObject3DBoundingBox(object3d);
        center = function(prop) {
          var diff;
          diff = bounds.max[prop] - bounds.min[prop];
          return bounds.min[prop] + (diff / 2);
        };
        return new THREE.Vector3(center('x'), center('y'), center('z'));
      };

      Utils.prototype.computeClickedMesh = function($canvas, e, camera, object3d) {
        var intersects, mouse, projector, raycaster, vector, _ref;
        projector = new THREE.Projector();
        mouse = getRelativeMouse($canvas, e);
        vector = new THREE.Vector3(mouse.x, mouse.y, 0.5);
        projector.unprojectVector(vector, camera);
        raycaster = new THREE.Raycaster(camera.position, vector.sub(camera.position).normalize());
        intersects = raycaster.intersectObjects(object3d.children, true);
        return (_ref = intersects[0]) != null ? _ref.object : void 0;
      };

      return Utils;

    }).call(this);
    return new Utils;
  });

}).call(this);
