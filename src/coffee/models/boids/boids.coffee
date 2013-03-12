define [
  'backbone',
  'models/boids/boid'
], (Backbone, Boid) ->

  # a collection of boids
  class extends Backbone.Collection
    
    model: Boid