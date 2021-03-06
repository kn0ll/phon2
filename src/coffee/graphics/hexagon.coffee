define [
  'underscore',
  'three',
  'tween'
], (_, THREE, TWEEN) ->

  class Hexagon extends THREE.Mesh

    constructor: (depth, sideLength, materials) ->
      materials = _.flatten([materials])
      extrudeSettings = { amount: depth, bevelEnabled: false, steps: 1 }
      shape2d = new THREE.Shape()
      @height = sideLength * Math.sqrt(3)

      # create 2d hexagon
      shape2d.moveTo 0, 0
      shape2d.lineTo sideLength, 0
      shape2d.lineTo sideLength * 1.5, -@height * .5
      shape2d.lineTo sideLength, -@height
      shape2d.lineTo 0, -@height
      shape2d.lineTo -sideLength * .5, -@height * .5

      # create and center the 3d mesh
      shape3d = shape2d.extrude(extrudeSettings)
      material = new THREE.MeshFaceMaterial(materials)
      THREE.Mesh.apply @, [shape3d, material]

      THREE.GeometryUtils.center shape3d

    tween = (obj, prop, to, time, onUpdate) ->
      options = {}
      options[prop] = to
      (new TWEEN.Tween(obj))
        .to(options, time)
        .easing(TWEEN.Easing.Quadratic.In)
        .onUpdate(onUpdate or ->)
        .start()

    animateHeight: (h) ->
      geo = @geometry
      update = -> geo.verticesNeedUpdate = true
      animate = (v) -> tween v, 'z', v.z + h, 50, update
      animate vertex for vertex in _.last(geo.vertices, 6)

    animateRotation: (r) ->
      tween @rotation, 'z', r, 100

    setSidesMaterialIndex: (i) ->
      for face in _.last(@geometry.faces, 6)
        face.materialIndex = i