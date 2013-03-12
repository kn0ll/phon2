define [
  'backbone'
], (Backbone) ->

  # a `cell` represents a single cell in a matrix.
  # it's aware ot it's position and when a `boid` enters
  # and leaves it.
  class extends Backbone.Model

    defaults:
      x: 0
      y: 0
      occupied: null

    toString: ->
      'Cell'