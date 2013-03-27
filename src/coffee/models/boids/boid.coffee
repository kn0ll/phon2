define [
  'backbone'
], (Backbone) ->

  # a `boid` is a moving thing around a `matrix`
  window.Boid = class extends Backbone.Model
    
    # a position and a sense of direction
    defaults:
      x: 0
      y: 0
      direction: null
      steps: 0

    set: (attrs, options) ->
      if attrs.x or attrs.y
        attrs.steps = (@get('steps') or 0) + 1
      super attrs, options