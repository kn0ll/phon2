define [
  'underscore',
  'backbone',
  'gui/range'
], (_, Backbone, RangeView) ->

  class extends Backbone.View

    #
    # view helpers
    #

    # create a block section for an attribute view
    createInputBlock = (label, view) =>
      $div = $('<div class="input" />')
      $div.append $("<label>#{label}</label>")
      $div.append view.render().el

    #
    # main view logic
    #

    tagName: 'form'
    className: 'hud-phon'

    constructor: (scheduler) ->
      Backbone.View.apply @
      @scheduler = scheduler

    render: ->
      $fieldset = $('<fieldset />')
      tempo_view = new RangeView
        model: @scheduler
        property: 'tempo'
        min: 1
        max: 400

      @$el.empty()
      $fieldset.append $("<legend>phon</legend>")
      $fieldset.append createInputBlock('tempo', tempo_view)
      @$el.append $fieldset
      @