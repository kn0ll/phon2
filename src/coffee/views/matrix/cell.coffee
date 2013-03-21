define [
  'three',
  'graphics/hexagon'
], (THREE, Hexagon) ->

  materials =
    grey_wire: new THREE.MeshBasicMaterial(
      color: 0x707C80
      wireframe: true
      wireframeLinewidth: 1)
    blue_face: new THREE.MeshBasicMaterial(
      color: 0x77D5D8)
    yellow_face: new THREE.MeshBasicMaterial(
      color: 0xFDC648)
    beige_face: new THREE.MeshBasicMaterial(
      color: 0xCFCBA9)
    pink_face: new THREE.MeshBasicMaterial(
      color: 0xEC4CB5)
    green_face: new THREE.MeshBasicMaterial(
      color: 0x02A797)

  # a `cell` view is the base hexagon mesh. it is responsible for
  # changing it's `skin` based on it's property changes.
  class extends Hexagon

    # stores properties and binds add/remove to render methods
    constructor: (cell, sideLength) ->
      Hexagon.apply @, [10, sideLength, @skins[cell.get('type')]]
      @cell = cell

      @cell.on 'change:occupied', @onOccupiedChange, @
      @cell.on 'change:selected', @onSelectedChange, @
      @cell.on 'change:type', @onTypeChange, @

    # different materials for different states
    skins:
      cell: [materials.grey_wire, materials.yellow_face]
      occupied: [materials.blue_face, materials.yellow_face]
      emitter: [materials.beige_face, materials.yellow_face]
      note: [materials.pink_face, materials.yellow_face]
      redirector: [materials.green_face, materials.yellow_face]

    onOccupiedChange: (cell, occupied) ->
      type = cell.get('type')
      @material.materials = if occupied then @skins.occupied else @skins[type]

    onSelectedChange: (cell, selected) ->
      # @setSidesMaterialIndex (if selected then 1 else 0)
      @animateHeight (if selected then 20 else -20)

    onTypeChange: (cell, type) ->
      type = cell.get('type')
      @material.materials = @skins[type]