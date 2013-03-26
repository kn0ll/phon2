define [
  'backbone'
], (Backbone) ->

  # a `boid` is a moving thing around a `matrix`
  class extends Backbone.Model
    
    # a position and a sense of direction
    defaults:
      x: 0
      y: 0
      direction: null
      steps: 0

    set: (attrs) ->
      super
      if attrs.x or attrs.y
        # some error gets thrown without defer..?
        _.defer => @set('steps', @get('steps') + 1)