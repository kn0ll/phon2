define [
  'underscore',
  'backbone',
  'models/matrix/column',
], (_, Backbone, Column) ->

  # a `matrix` is a collection of `columns`.
  class extends Backbone.Collection

    # a matrix is a collection of columns
    model: Column

    # create all of the columns and cells
    constructor: (width, height) ->
      Backbone.Collection.apply @
      for x in [0..width]
        @add height: height

    # add should make sure to manage cell selected state
    # kind of hacky, just rebinds and binds on every single
    # add instead of adding only on new columns
    add: ->
      super
      for cell in @get()
        cell.off 'change:selected', @changeSelected, @
        cell.on 'change:selected', @changeSelected, @

    # when a cell sets it's selected, make sure to deselect any others
    changeSelected: (selected_cell, selected) ->
      if selected
        for cell in @get()
          selected = cell.get('selected')
          if cell isnt selected_cell
            cell.set 'selected', undefined 

    # get a specific (or all) cells in the matrix
    get: (x, y) ->
      if x isnt undefined and y isnt undefined
        if @at(x) then @at(x).cells.at(y) else null
      else
        _.flatten this.map (col) ->
          col.cells.map (cell) ->
            cell

    # sets cell values based on an object
    set: (cell) ->
      for attrs in _.flatten([cell])
        {x, y} = attrs
        delete attrs.x
        delete attrs.y
        @get(x, y).set attrs

    # get the x, y of a particular cell
    getCellCoords: (cell) ->
      coords = {}
      @each (column, x) ->
        column.cells.each (c_cell, y) ->
          if cell is c_cell
            coords = x: x, y: y
      coords

    # return the "following" cell based on a cells direction
    getAdjacent: (x, y, direction) ->
      odd = x % 2
      switch direction
        when 'ne' then @get(x + 1, if odd then y else y - 1)
        when 'n' then @get(x, y - 1)
        when 'se' then @get(x + 1, if odd then y + 1 else y)
        when 's' then @get(x, y + 1)
        when 'sw' then @get(x - 1, if odd then y + 1 else y)
        when 'nw' then @get(x - 1, if odd then y else y - 1)