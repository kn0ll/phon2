define [
  'underscore',
  'backbone',
  'graphics/utils'
], (_, Backbone, ThreeUtils) ->

  class extends Backbone.View

    onDblclick: (e) ->
      mesh = @getClickedMesh(e)
      cell = mesh.cell

      if cell
        type = cell.get('type')
        options = @cell_parameters[type]
        option_names = Object.keys(options)
        cur_index = option_names.indexOf(@_selected_parameter)
        next_option_name = option_names[cur_index + 1]
        @_selected_parameter = next_option_name or 'type'