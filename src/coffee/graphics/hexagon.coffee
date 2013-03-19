define [
  'three'
], (THREE) ->

  class Hexagon extends THREE.Mesh

    constructor: (depth, sideLength, material) ->
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
      THREE.Mesh.apply @, [shape3d, material]

      THREE.GeometryUtils.center shape3d