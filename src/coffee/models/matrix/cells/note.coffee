define [
  'models/matrix/cells/cell'
], (Cell) ->

  # a `note` is a cell which additionally
  # has `key`, `velocity`.
  class extends Cell

    defaults:
      x: 0
      y: 0
      key: 71
      velocity: 255

    toString: ->
      'Note Cell'