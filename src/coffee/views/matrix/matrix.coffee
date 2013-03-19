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

    # manages "selected" state of cells on click
    meshClicked: (mesh) ->
      cell = mesh.cell
      if cell is @selected_cell
        selected = cell.get('selected')
        cell.set 'selected', not selected
      else
        @selected_cell?.set 'selected', false
        cell.set 'selected', true
      @selected_cell = cell