define ->

  class Utils

    # gets the mouse offset based on the canvas offset
    getRelativeMouse = ($canvas, e) =>
      offset = $canvas.offset()
      rel_x = e.clientX - offset.left
      rel_y = e.clientY - offset.top
      x: (rel_x / $canvas.width()) * 2 - 1
      y: - (rel_y / $canvas.height()) * 2 + 1

    # returns bounding box of an Object3D group
    computeObject3DBoundingBox: (object3d) ->
      bounds =
        min: new THREE.Vector3(Infinity, Infinity, Infinity)
        max: new THREE.Vector3(-Infinity, -Infinity, -Infinity)

      object3d.traverse (child) ->
        if child instanceof THREE.Mesh
          world_min = child.localToWorld(child.geometry.boundingBox.min)
          world_max = child.localToWorld(child.geometry.boundingBox.max)

          bounds.min.x = Math.min(bounds.min.x, world_min.x)
          bounds.min.y = Math.min(bounds.min.y, world_min.y)
          bounds.min.z = Math.min(bounds.min.z, world_min.z)

          bounds.max.x = Math.max(bounds.max.x, world_max.x)
          bounds.max.y = Math.max(bounds.max.y, world_max.y)
          bounds.max.z = Math.max(bounds.max.z, world_max.z)

      bounds

    # returns a vector containing the center point of an object
    computeObject3DCenter: (object3d) ->
      bounds = @computeObject3DBoundingBox(object3d)
      center = (prop) ->
        diff = bounds.max[prop] - bounds.min[prop]
        bounds.min[prop] + (diff / 2)
      new THREE.Vector3(center('x'), center('y'), center('z'))

    # returns the mesh that a user clicked on in an object
    computeClickedMesh: ($canvas, e, camera, object3d) ->
      projector = new THREE.Projector()
      mouse = getRelativeMouse($canvas, e) 

      vector = new THREE.Vector3 mouse.x, mouse.y, 0.5
      projector.unprojectVector(vector, camera)
      raycaster = new THREE.Raycaster(camera.position, vector.sub(camera.position).normalize())
      intersects = raycaster.intersectObjects(object3d.children, true)
      intersects[0]?.object

  new Utils