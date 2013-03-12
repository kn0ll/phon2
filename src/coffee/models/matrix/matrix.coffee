define [
  'underscore',
  'backbone',
  'models/matrix/column',
], (_, Backbone, Column) ->

  # a `matrix` is a collection of `columns` (which are 
  # collections of `cells`). instead of accepting default
  # models, it accepts a width and a height, and creates
  # it's columns and cells accordingly.
  class extends Backbone.Collection

    model: Column

    # for each column create each cell
    constructor: (width, height) ->
      Backbone.Collection.apply @
      for x in [0..width]
        col = new Column
        @add(col)
        for y in [0..height]
          col.cells.add
            x: x
            y: y

    # < - >
    getWidth: ->
      @length

    # ^ - v
    getHeight: ->
      @at(0).length

    # because the collection and model layer is hard to access
    # we provide a simple `get` method to return a cell
    # from a column based on it's x y coordinate.
    get: (x, y) ->
      if x isnt undefined and y isnt undefined
        if @at(x) then @at(x).cells.at(y) else null
      else
        _.flatten this.map (col) ->
          col.cells.map (cell) ->
            cell 

    # replace an existing cell with a new cell in the graph
    # using the x and y coords of the new cell
    set: (cell) ->
      x = cell.get('x')
      y = cell.get('y')
      currentCell = @get(x, y)
      col = currentCell.collection
      currentIndex = col.indexOf(currentCell)
      col.remove(currentCell)
      col.add cell, 
        at: currentIndex

    # based on a cells direction,
    # return the "following" cell
    getAdjacent: (cell) ->
      direction = cell.get('direction')
      x = cell.get('x')
      y = cell.get('y')
      odd = x % 2
      switch direction
        when 'ne' then @get(x + 1, if odd then y else y - 1)
        when 'n' then @get(x, y - 1)
        when 'se' then @get(x + 1, if odd then y + 1 else y)
        when 's' then @get(x, y + 1)
        when 'sw' then @get(x - 1, if odd then y + 1 else y)
        when 'nw' then @get(x - 1, if odd then y else y - 1)