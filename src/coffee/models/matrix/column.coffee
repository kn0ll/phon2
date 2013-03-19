define [
  'backbone',
  'models/matrix/cell'
], (Backbone, Cell) ->

  # a collection of `cell` models.
  class Cells extends Backbone.Collection
    
    model: Cell

  # a `column` is a model which contains reference to a collection of cells.
  class extends Backbone.Model

    # proxy note events from all cells to the column
    constructor: ->
      super
      @cells = new Cells()
      for y in [0..@get('height')]
        @cells.add()