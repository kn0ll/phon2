define [
  'backbone'
], (Backbone) ->

  # a `scene` model represents the 3js scene
  class extends Backbone.Model
    
    defaults:
      width: 500
      height: 500