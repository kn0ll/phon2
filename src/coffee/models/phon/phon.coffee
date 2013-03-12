define [
  'audiolet'
], (Audiolet) ->

  # a phon is an audioletgroup which plays things based
  # on the events of a boidController
  class extends AudioletGroup

    constructor: (audiolet, boidController) ->
      super audiolet, 0, 1
      @instrument = new Instrument(audiolet)
      @gain = new Gain(audiolet, 0.05)

      # proxy boidController events to midi notes
      doNote = (note) =>
        (cell) =>
          @instrument.midi note, cell.get('key'), cell.get('velocity')

      boidController.on 'noteOn', doNote(144)
      boidController.on 'noteOff', doNote(128)

      # route instrument
      @instrument.connect(@gain)
      @gain.connect(@outputs[0])