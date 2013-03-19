define [
  'three',
  'graphics/hexagon'
], (THREE, Hexagon) ->

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

      cell: new THREE.MeshBasicMaterial
        color: 0x707C80
        wireframe: true
        wireframeLinewidth: 1

      occupied: new THREE.MeshLambertMaterial
        color: 0x77D5D8

      selected: new THREE.MeshLambertMaterial
        color: 0xFDC648
        wireframe: true
        wireframeLinewidth: 1

      emitter: new THREE.MeshBasicMaterial
        color: 0xCFCBA9

      note: new THREE.MeshBasicMaterial
        color: 0xEC4CB5

      redirector: new THREE.MeshBasicMaterial
        color: 0x02A797

    onOccupiedChange: (cell, occupied) ->
      return if cell.get('selected')
      type = cell.get('type')
      @material = if occupied then @skins.occupied else @skins[type]

    onSelectedChange: (cell, selected) ->
      type = cell.get('type')
      @material = if selected then @skins.selected else @skins[type]

    onTypeChange: (cell, type) ->
      @material = @skins[type]