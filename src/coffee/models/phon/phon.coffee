define [
  'audiolet',
  'models/matrix/cells/note'
], (Audiolet, NoteCell) ->

  # a phon is an audioletgroup which plays things based
  # on the events of a boidController
  class extends AudioletGroup

    constructor: (audiolet, boidController) ->
      super audiolet, 0, 1
      @instrument = new Instrument(audiolet)
      @gain = new Gain(audiolet, 0.05)

      # when a boid moves in or out of a cell
      # play things based on type of cell
      boidController.on 'move', (cell, occupied) =>
        key = cell.get('key')
        velocity = cell.get('velocity')
        if cell instanceof NoteCell
          note = if occupied then 144 else 128
          @instrument.midi note, key, velocity

      # route instrument
      @instrument.connect(@gain)
      @gain.connect(@outputs[0])