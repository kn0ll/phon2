define [
  'backbone'
], (Backbone) ->

  # a `scene` model represents the 3js scene
  class extends Backbone.Model
    
    defaults:
      width: window.innerWidth
      height: window.innerHeight