define [
  'models/matrix/cells/cell'
], (Cell) ->

  # an `emitter` is a cell with an
  # additional `direction` attribute
  class extends Cell

    defaults:
      x: 0
      y: 0
      direction: 'n'

    toString: ->
      'Emitter Cell'