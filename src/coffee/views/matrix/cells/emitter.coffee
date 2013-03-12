define [
  'underscore',
  'views/matrix/cells/cell'
], (_, CellView) ->

  # an `emitter` view is a `cell` view
  # with a beige color.
  class extends CellView

    options: _.extend({}, CellView::options, {
      color: 0xCFCBA9
    })