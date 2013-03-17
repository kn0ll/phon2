define [
  'underscore',
  'core/context',
  'models/matrix/matrix',
  'models/boids/boids',
  'models/matrix/cells/emitter'
], (_, context, PhonMatrix, Boids, EmitterCell) ->

  # a boid controller is responsible for navigating
  # boids around a matrix as well as providing an external
  # interface to listen to different cells being occupied.
  class extends Backbone.Model
    
    defaults:
      cols: 5
      rows: 5

    initialize: (attrs, options) ->
      super
      scheduler = context.scheduler
      # todo: matrix should not be attr
      @matrix = attrs.matrix
      @boids = new Boids()
      scheduler.beatsPerBar = 4

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
      scheduler = context.scheduler
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
        adjacent = matrix.getAdjacent(boid)

        # if there is a cell to move into,
        # move there
        if adjacent
          x = adjacent.get('x')
          y = adjacent.get('y')
          boid.set
            x: x,
            y: y

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
          cell instanceof EmitterCell
        _(emitters).each (emitter) ->
          adjacent = matrix.getAdjacent(emitter)
          x = adjacent.get('x')
          y = adjacent.get('y')
          boids.add
            x: x,
            y: y,
            direction: emitter.get('direction')

    # sets a cell on the matrix
    setCell: (cell) ->
      @matrix.set cell