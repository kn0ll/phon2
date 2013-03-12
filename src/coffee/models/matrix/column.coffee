define [
  'backbone',
  'models/matrix/cells'
], (Backbone, Cells) ->

  # a column contains reference to a `cells` collection.
  # this `column` class acts as a necessary proxy because
  # a Backbone collection (Matrix) must only contain a collection
  # of models (Columns), not a collection of collections (cells)
  class extends Backbone.Model

    # proxy note events from all cells to the column
    constructor: ->
      super
      @cells = new Cells()