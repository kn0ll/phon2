define [
  'models/matrix/cells/cell'
], (Cell) ->

  # a `redirector` is a cell with an additional `direction`
  # parameter and is responsible for changing a
  # the direction of a `boid`.
  class extends Cell

    defaults:
      x: 0
      y: 0
      direction: 'n'

    toString: ->
      'Redirector Cell'