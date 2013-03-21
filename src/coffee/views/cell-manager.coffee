define [
  'underscore',
  'backbone',
  'graphics/utils'
], (_, Backbone, ThreeUtils) ->

  class extends Backbone.View

    events:
      'mousedown': 'onMousedown'

    constructor: (sceneView) ->
      Backbone.View.apply @
      @sceneView = sceneView
      
      @setElement sceneView.el

    round = (from, to) ->
      resto = from % to
      if resto <= (to / 2) then (from - resto) else (from + to - resto)

    # manages "selected" state of cells on click
    onMousedown: (e) ->
      { el, camera, matrixView } = @sceneView
      mesh = ThreeUtils.computeClickedMesh($(el), e, camera, matrixView)

      # select a new cell and deactivate the old cell
      if cell = mesh?.cell

        # new cell is selected
        if cell isnt @selected_cell
          @selected_cell?.set 'selected', false
          cell.set 'selected', true
          @selected_cell = cell

        # current cell is selected, manage option state
        # todo: should be bound to cells "selected" state
        else
          start_y = e.clientY
          start_z_rotation = mesh.rotation.z
          onmove = (move_e) ->
            diff_y = move_e.clientY - start_y
            mesh.rotation.z = start_z_rotation + diff_y * .02
          $(document).on 'mousemove', onmove
          $(document).on 'mouseup', ->
            sixty = 60 * Math.PI / 180
            rounded = sixty * Math.round(mesh.rotation.z / sixty)
            val = rounded / -sixty
            console.log val
            mesh.animateRotation rounded
            $(document).off 'mouseup', arguments.callee
            $(document).off 'mousemove', onmove

      # no cell clicked, deactivate all cells
      else
        @selected_cell?.set 'selected', false
        @selected_cell = undefined
        
      e.preventDefault()