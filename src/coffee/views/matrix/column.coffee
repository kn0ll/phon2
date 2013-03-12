define [
  'jquery',
  'backbone',
  'models/matrix/cells/cell',
  'models/matrix/cells/emitter',
  'models/matrix/cells/note',
  'models/matrix/cells/redirector',
  'views/matrix/cells/cell',
  'views/matrix/cells/emitter',
  'views/matrix/cells/note',
  'views/matrix/cells/redirector'
], ($, Backbone,
  Cell, EmitterCell, NoteCell, RedirectorCell,
  CellView, EmitterCellView, NoteCellView, RedirectorCellView) ->

  # a `column` view accepts a `cells` collection
  # and is responsible for creating a 3js group which
  # adds all the cells.
  class extends Backbone.View

    constructor: ->
      super
      @group = new THREE.Object3D()
      @cellViews = []
      @collection.on 'add', @addCell, @
      @collection.on 'remove', @removeCell, @
      @

    # takes a `cell` model and creates a new cell view,
    # adding it to the column group.
    addCell: (cell) ->
      self = this
      x = cell.get('x')
      y = cell.get('y')
      padding = @options.padding
      sideLength = CellView::options.sideLength
      height = sideLength * Math.sqrt(3)
      narrowWidth = sideLength * 1.5
      offset = if (x % 2) then (-height - padding) * 0.5 else 0
      group = @group
      View = CellView

      if cell instanceof EmitterCell
        View = EmitterCellView
      else if cell instanceof NoteCell
        View = NoteCellView
      else if cell instanceof RedirectorCell
        View = RedirectorCellView

      cellView = new View
        model: cell
        top: (-height - padding) * y + offset
        left: (narrowWidth + padding) * x
        group: group
      @cellViews[y] = cellView
      group.add cellView.render()

    # remove a cell from the view
    removeCell: (cell) ->
      y = cell.get('y')
      @cellViews[y].remove()
      delete @cellViews[y]

    # add each cell to the group
    render: ->
      @collection.each (cell) =>
        @addCell(cell)
      @group