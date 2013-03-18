define [
  'underscore',
  'backbone'
], (_, Backbone) ->

  # a `cell` view is the hexagon representing
  # a single `cell` model. it's responsible for creating
  # a 3d shape and changing the mesh to reflect it's
  # current `cell` state when it's updated.
  class extends Backbone.View

    # it has a general size and color,
    # and blongs to a mesh `group`.
    options:
      top: 0
      left: 0
      sideLength: 30
      depth: 10
      group: null
      color: 0x707C80

    # on setup, create the mesh based on the view options
    # and bind the color change to the models `occupied` change.
    constructor: ->
      super
      depth = @options.depth
      sideLength = @options.sideLength
      extrudeSettings = { amount: depth, bevelEnabled: false, steps: 1 }
      shape = new THREE.Shape()
      height = sideLength * Math.sqrt(3)
      cell = @model
      color = @options.color
      type = cell.get('type')

      # create 2d hexagon
      shape.moveTo 0, 0
      shape.lineTo sideLength, 0
      shape.lineTo sideLength * 1.5, -height * .5
      shape.lineTo sideLength, -height
      shape.lineTo 0, -height
      shape.lineTo -sideLength * .5, -height * .5

      # create and center the 3d mesh
      shape3d = shape.extrude(extrudeSettings)
      @mesh = new THREE.Mesh(shape3d, @material())
      THREE.GeometryUtils.center shape3d

      # bind state changes to view changes
      cell.on 'change:occupied', @onOccupiedChange, @
      cell.on 'change:selected', @onSelectedChange, @

    material: ->
      color = @options.color
      new THREE.MeshBasicMaterial({ color: color, wireframe: true, wireframeLinewidth: 1 })

    # render sets the position and scale
    # and returns the mesh
    render: ->
      x = @options.left
      y = @options.top
      z = 0
      @mesh.position.set x, y, z
      @mesh.rotation.set 0, 0, 0
      @mesh.scale.set 1, 1, 1
      @mesh

    # remove returns the mesh from it's group
    remove: ->
      @options.group.remove @mesh

    # set occupied cell to blue
    onOccupiedChange: (cell, occupied) ->
      return if cell.get('selected')
      if occupied
        material = new THREE.MeshLambertMaterial({ color: 0x77D5D8 })
      else
        material = @material()
      @mesh.material = material

    # set selected cell to yellow
    onSelectedChange: (cell, occupied) ->
      if occupied
        material = new THREE.MeshLambertMaterial({ color: 0xFDC648, wireframe: true, wireframeLinewidth: 1 })
      else
        material = @material()
      @mesh.material = material