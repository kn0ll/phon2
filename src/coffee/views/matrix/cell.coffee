define [
  'underscore',
  'three',
  'graphics/hexagon'
], (_, THREE, Hexagon) ->

  # a `cell` view is the base hexagon mesh. it is responsible for
  # changing it's `skin` based on it's property changes, and allowing
  # the user to change cell paramters through the view.
  class extends Hexagon

    #
    # face materials
    #

    materials =
      grey_wire: new THREE.MeshBasicMaterial(
        color: 0x707C80
        wireframe: true
        wireframeLinewidth: 1)
      blue_face: new THREE.MeshBasicMaterial(
        color: 0x77D5D8)
      beige_face: new THREE.MeshBasicMaterial(
        color: 0xCFCBA9)
      pink_face: new THREE.MeshBasicMaterial(
        color: 0xEC4CB5)
      green_face: new THREE.MeshBasicMaterial(
        color: 0x02A797)

    skins =
      cell: [materials.grey_wire]
      occupied: [materials.blue_face]
      emitter: [materials.beige_face]
      note: [materials.pink_face]
      redirector: [materials.green_face]

    #
    # rotation logic
    #

    $doc = $(document)
    sixty = 60 * Math.PI / 180

    round = (from, to) ->
      rest = from % to
      if rest <= (to / 2) then (from - rest) else (from + to - rest)

    onRotate = (e, mesh, setVal) ->
      start_y = e.clientY
      start_z_rotation = mesh.rotation.z
      (move_e) =>
        diff_y = move_e.clientY - start_y
        mesh.rotation.z = start_z_rotation + diff_y * .02
        rounded = sixty * Math.round(mesh.rotation.z / sixty)
        val = rounded / -sixty
        setVal val

    stopRotate = (e, mesh, rotateHandler) ->
      (up_e) =>
        rounded = sixty * Math.round(mesh.rotation.z / sixty)
        mesh.animateRotation rounded
        $doc.off 'mousemove', rotateHandler

    startRotate = (e, mesh, setVal) ->
      rotateHandler = onRotate(e, mesh, setVal)
      $doc.on 'mousemove', rotateHandler
      $doc.one 'mouseup', stopRotate(e, mesh, rotateHandler)

    #
    # view logic
    #

    cell_parameters =
      cell:
        type: ['cell', 'note', 'emitter', 'redirector']
      note:
        type: ['cell', 'note', 'emitter', 'redirector']
        key: [0..127]
        velocity: [0..127]
      emitter:
        type: ['cell', 'note', 'emitter', 'redirector']
        direction: ['n', 'ne', 'se', 's', 'sw', 'nw']
      redirector: 
        type: ['cell', 'note', 'emitter', 'redirector']
        direction: ['n', 'ne', 'se', 's', 'sw', 'nw']

    #
    # main view logic
    #

    # stores properties and binds add/remove to render methods
    constructor: (cell, sideLength) ->
      Hexagon.apply @, [10, sideLength, skins[cell.get('type')]]
      @cell = cell

      @cell.on 'change:occupied', @onOccupiedChange, @
      @cell.on 'change:selected', @onSelectedChange, @
      @cell.on 'change:type', @onTypeChange, @

    onOccupiedChange: (cell, occupied) ->
      type = cell.get('type')
      @material.materials = if occupied then skins.occupied else skins[type]

    onSelectedChange: (cell, selected) ->
      @animateHeight (if selected then 20 else -20)

    onTypeChange: (cell, type) ->
      type = cell.get('type')
      @material.materials = skins[type]

    # todo: 0. dblclick
    # todo: 1. instead of cycling forever, it should have min and max
    # todo: 2. setCurrentParameter here is only set from rotation values
    #          but the other UI view can use same cell models and have sliders
    #          set cell attributes.
    setCurrentParameter: (val) ->
      @_selected_parameter ?= 'type'
      type = @cell.get('type')
      options = cell_parameters[type]
      parameters = options[@_selected_parameter]
      parameter_count = parameters.length
      # todo: going backwards from 0 starts from beginning of options
      # instead it should start at the end of the cycle
      # (so its a true loop, not a mirror at 0)
      cur_parameter_index = Math.abs(val % parameter_count)
      cur_parameter_value = parameters[cur_parameter_index]
      @cell.set @_selected_parameter, cur_parameter_value

    onMousedown: (e) ->
      cell = @cell
      if cell.get 'selected'
        startRotate e, @, _.bind(@setCurrentParameter, @)
      else
        cell.set 'selected', true