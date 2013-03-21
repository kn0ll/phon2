define [
  'three',
  'views/matrix/column'
], (THREE, ColumnView) ->

  # a `matrix` view is a 3js group responsible for managing `column` groups.
  class extends THREE.Object3D

    # stores properties and binds add/remove to render methods
    constructor: (matrix, padding = 10, sideLength = 30) ->
      THREE.Object3D.apply @
      @columns = matrix
      @padding = padding
      @sideLength = sideLength

      @columns.on 'add', @addColumnView, @
      @columns.on 'remove', @removeColumnView, @

    # adds and positions a single column in the group
    addColumnView: (column) ->
      x = @columns.indexOf(column)
      height = @sideLength * Math.sqrt(3)
      narrowWidth = @sideLength * 1.5
      offset = if (x % 2) then (-height - @padding) * 0.5 else 0
      columnView = new ColumnView(column, @padding, @sideLength)

      columnView.position.x = (narrowWidth + @padding) * x
      columnView.position.y = offset
      @add columnView.render()

    # removes a single column from the group
    removeColumnView: (column) ->
      meshes = []
      for child in @children
        if child.column is column
          meshes.push child
      for mesh in meshes
        @remove mesh

    # add each column to main group
    render: ->
      @columns.each @addColumnView, @
      @

    round = (from, to) ->
      resto = from % to
      if resto <= (to / 2) then (from - resto) else (from + to - resto)

    # manages "selected" state of cells on click
    onMousedown: (e, mesh) ->

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
            mesh.animateRotation rounded
            $(document).off 'mousemove', onmove

      # no cell clicked, deactivate all cells
      else
        @selected_cell?.set 'selected', false
        @selected_cell = undefined