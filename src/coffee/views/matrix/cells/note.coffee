define [
  'underscore',
  'views/matrix/cells/cell'
], (_, CellView) ->

  # an `note` view is a `cell` view
  # with a pink color.
  class extends CellView

    options: _.extend({}, CellView::options, {
      color: 0xEC4CB5
    })

    material: ->
      color = @options.color
      new THREE.MeshBasicMaterial({ color: color, wireframeLinewidth: 2 })