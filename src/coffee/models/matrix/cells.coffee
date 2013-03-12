define [
  'backbone',
  'models/matrix/cells/cell'
], (Backbone, Cell) ->

  # a collection of `cell` models.
  class extends Backbone.Collection
    
    model: Cell