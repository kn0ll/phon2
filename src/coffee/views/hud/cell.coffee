define [
  'underscore',
  'backbone',
  'graphics/utils',
  'gui/select',
  'gui/range'
], (_, Backbone, ThreeUtils, SelectView, RangeView) ->

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
    className: 'hud-cell'

    # binds rerendering to cell selected states
    constructor: (matrix) ->
      Backbone.View.apply @
      @matrix = matrix
      for cell in @matrix.get()
        cell.on 'change:selected', @render, @

    # populate the form
    render: (cell, selected) ->
      @$el.empty()
      return @ if not selected
      { x, y } = @matrix.getCellCoords(cell)
      $fieldset = $('<fieldset />')
      type_view = new SelectView
        model: cell
        property: 'type'
        options: ['cell', 'note', 'emitter', 'redirector']
      direction_view = new SelectView
        model: cell
        property: 'direction'
        options: ['n', 'ne', 'se', 's', 'sw', 'nw']
      key_view = new RangeView
        model: cell
        property: 'key'
        min: 0
        max: 127
      velocity_view = new RangeView
        model: cell
        property: 'velocity'
        min: 0
        max: 127

      # build form
      $fieldset.append $("<legend>cell (#{x}, #{y})</legend>")
      $fieldset.append createInputBlock('type', type_view)
      $fieldset.append createInputBlock('direction', direction_view)
      $fieldset.append createInputBlock('key', key_view)
      $fieldset.append createInputBlock('velocity', velocity_view)
      @$el.append $fieldset

      @