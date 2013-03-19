define [
  'underscore',
  'audio/scheduler',
  'models/boids/boid'
], (_, scheduler, Boid) ->

  class Boids extends Backbone.Collection
    
    model: Boid

  # a boid controller is responsible for navigating
  # boids around a matrix as well as providing an external
  # interface to listen to different cells being occupied.
  class extends Backbone.Model

    initialize: (matrix) ->
      Backbone.Model::initialize.apply @
      @matrix = matrix
      @boids = new Boids()

      # when a boid changes movement,
      # set the appropriate `cell` occupied states.
      @boids.on 'change', (boid) =>
        oldX = boid.previous('x')
        oldY = boid.previous('y')
        old_cell = @matrix.get(oldX, oldY)
        x = boid.get('x')
        y = boid.get('y')
        cell = @matrix.get(x, y)

        # set the occupied attribute of the cells
        old_cell.set('occupied', false)
        cell.set('occupied', true)

        # trigger noteOn and noteOff on the controller
        # if the new / old cell were `note` cells
        # todo: this should be bound to occupied, not triggered
        #       adjacent to
        @trigger('move', old_cell, false)
        @trigger('move', cell, true)

      # when a new boid is created, set it's cells occupied
      @boids.on 'add', (boid) =>
        x = boid.get('x')
        y = boid.get('y')
        cell = @matrix.get(x, y)
        cell.set('occupied', true)
        @trigger('move', cell, true)

      # when a new boid is removed, set it's cells occupied
      @boids.on 'remove', (boid) =>
        x = boid.get('x')
        y = boid.get('y')
        cell = @matrix.get(x, y)
        cell.set('occupied', false)
        @trigger('move', cell, false)

    # bind tick to the audiolet scheduler
    start: ->
      sequence = new PSequence([true], Infinity)
      scheduler.play sequence, 1, =>
        @tick scheduler.beatInBar

    # tick is the main logic responsible
    # for moving boids around (todo: maybe this should be logic
    # of boids themselves)
    tick: (beat) ->
      matrix = @matrix
      cells = matrix.get()
      boids = @boids
      deadBoids = []

      # move each boid currently on the matrix
      boids.each (boid) ->
        x = boid.get('x')
        y = boid.get('y')
        direction = boid.get('direction')
        adjacent = matrix.getAdjacent(x, y, direction)

        # if there is a cell to move into,
        # move there
        if adjacent
          coords = matrix.getCellCoords(adjacent)
          boid.set
            x: coords.x
            y: coords.y

        # otherwise it's hit the end of the board
        else
          deadBoids.push(boid)

      # remove all dead boids
      for i in [0..deadBoids.length - 1]
        boids.remove(deadBoids[i])

      # on each beat, emitters should spawn
      # a boid next to it
      if beat is 0
        emitters = _(cells).filter (cell) ->
          cell.get('type') is 'emitter'
        _(emitters).each (emitter) ->
          direction = emitter.get('direction')
          coords = matrix.getCellCoords(emitter)
          adjacent = matrix.getAdjacent(coords.x, coords.y, direction)
          new_coords = matrix.getCellCoords(adjacent)
          boids.add
            x: new_coords.x
            y: new_coords.y
            direction: direction