define [
  'three',
  'views/matrix/cell'
], (THREE, CellView) ->

  # a `column` view is a 3js group responsible for managing `cell` meshes.
  class extends THREE.Object3D

    # stores properties and binds add/remove to render methods
    constructor: (column, padding, sideLength) ->
      THREE.Object3D.apply @
      @padding = padding
      @sideLength = sideLength
      @column = column
      cells = @column.cells

      cells.on 'add', @addCellView, @
      cells.on 'remove', @removeCellView, @

    # adds and positions single cell in the group
    addCellView: (cell) ->
      height = @sideLength * Math.sqrt(3)
      y = (- height - @padding) * @column.cells.indexOf(cell)
      cellView = new CellView(cell, @sideLength)

      cellView.position.y = y
      @add cellView

    # removes a single cell from the group
    removeCellView: (cell) ->
      meshes = []
      for child in @children
        if child.cell is cell
          meshes.push child
      for mesh in meshes
        @remove mesh

    # add each cell to main group
    render: ->
      @column.cells.each @addCellView, @
      @