define [
  'underscore',
  'backbone',
  'graphics/utils'
], (_, Backbone, ThreeUtils) ->

  $doc = $(document)

  class extends Backbone.View

    _selected_cell: null
    _selected_parameter: null
    _on_rotate_handler: null

    events:
      'mousedown': 'onMousedown'
      'dblclick': 'onDblclick'

    cell_parameters:
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

    constructor: (sceneView) ->
      Backbone.View.apply @
      @sceneView = sceneView
      
      @setElement sceneView.el

    setCurrentParameter: (val) ->
      @_selected_parameter ?= 'type'
      type = @_selected_cell.get('type')
      options = @cell_parameters[type]
      parameters = options[@_selected_parameter]
      parameter_count = parameters.length
      # todo: going backwards from 0 starts from beginning of options
      # instead it should start at the end of the cycle
      # (so its a true loop, not a mirror at 0)
      cur_parameter_index = Math.abs(val % parameter_count)
      cur_parameter_value = parameters[cur_parameter_index]
      @_selected_cell.set @_selected_parameter, cur_parameter_value
      console.log 'setting', @_selected_parameter, cur_parameter_value

    round = (from, to) ->
      resto = from % to
      if resto <= (to / 2) then (from - resto) else (from + to - resto)

    startRotate: (e, mesh) ->
      @_on_rotate_handler = @onRotate(e, mesh)
      $doc.on 'mousemove', @_on_rotate_handler
      $doc.one 'mouseup', @stopRotate(e, mesh)

    onRotate: (e, mesh) ->
      start_y = e.clientY
      start_z_rotation = mesh.rotation.z
      (move_e) ->
        diff_y = move_e.clientY - start_y
        mesh.rotation.z = start_z_rotation + diff_y * .02

    stopRotate: (e, mesh) ->
      (up_e) =>
        sixty = 60 * Math.PI / 180
        rounded = sixty * Math.round(mesh.rotation.z / sixty)
        val = rounded / -sixty
        mesh.animateRotation rounded
        @setCurrentParameter val
        $doc.off 'mousemove', @_on_rotate_handler

    selectCell: (cell) ->
      @_selected_cell?.set 'selected', false
      cell.set 'selected', true
      @_selected_cell = cell

    deselectCell: ->
      @_selected_cell?.set 'selected', false
      @_selected_cell = undefined

    getClickedMesh: (e) ->
      { el, camera, matrixView } = @sceneView
      ThreeUtils.computeClickedMesh($(el), e, camera, matrixView)

    onMousedown: (e) ->
      mesh = @getClickedMesh(e)
      cell = mesh?.cell

      # clicked a cell
      if cell

        # clicked new cell
        if cell isnt @_selected_cell
          @selectCell cell

        # clicked same cell
        else
          @startRotate e, mesh

      # clicked no cell
      else
        @deselectCell()

      e.preventDefault()

    onDblclick: (e) ->
      @_selected_parameter ?= 'type'
      mesh = @getClickedMesh(e)
      cell = @_selected_cell

      if cell
        type = cell.get('type')
        options = @cell_parameters[type]
        option_names = Object.keys(options)
        cur_index = option_names.indexOf(@_selected_parameter)