define [
  'jquery',
  'backbone',
  'views/matrix/column',
  'models/matrix/cells/cell',
  'models/matrix/cells/emitter',
  'models/matrix/cells/note',
  'models/matrix/cells/redirector',
  'views/matrix/cells/cell',
  'views/matrix/cells/emitter',
  'views/matrix/cells/note',
  'views/matrix/cells/redirector'
], ($, Backbone, ColumnView,
  Cell, EmitterCell, NoteCell, RedirectorCell,
  CellView, EmitterCellView, NoteCellView, RedirectorCellView) ->

  # a matrix view is responsible for creating a 3js group
  # which manages `column` views (each column can render itself).
  # ultimately, a group of columns makes up the full matrix
  class extends Backbone.View

    options:
      padding: 5

    constructor: ->
      super
      @group = new THREE.Object3D
      window.group = @group
      @columnViews = []
      @collection.on 'add', @addColumn, @

    # accepts a column model and adds
    # a new column to the matrix
    addColumn: (column) ->
      columns = column.collection
      x = columns.indexOf(column)
      columnView = new ColumnView
        collection: column.cells
        padding: @options.padding
      @columnViews[x] = columnView
      @group.add columnView.render()

    findCellByMesh: (mesh) ->
      model = false
      _.each @columnViews, (columnView) ->
        for cellView in columnView.cellViews
          model = cellView.model if mesh is cellView.mesh
      model

    # render should add each collection to
    # the group
    render: ->
      @collection.each (column) =>
        @addColumn(column)
      @