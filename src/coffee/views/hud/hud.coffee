define [
  'underscore',
  'backbone',
  'views/hud/phon',
  'views/hud/cell'
], (_, Backbone, PhonHUDView, CellHUDView) ->

  class extends Backbone.View

    id: 'hud'

    constructor: (matrix, scheduler) ->
      Backbone.View.apply @
      @matrix = matrix
      @scheduler = scheduler

    render: ->
      phonView = new PhonHUDView(@scheduler)
      cellView = new CellHUDView(@matrix)
      @$el.empty()
      @$el.append cellView.render().el
      @$el.append phonView.render().el
      @