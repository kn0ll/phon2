define [
  'backbone'
], (Backbone) ->

  # a `cell` represents a single node in a matrix.
  class extends Backbone.Model

    defaults:

      # for all types
      occupied: null

      # for type `emitter`, `redirector`
      direction: 'ne'

      # for type `note`
      key: 71
      velocity: 255

      type: 'cell'