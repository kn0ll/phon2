define [
  'backbone',
  'audio/context'
], (Backbone, context) ->

  class Scheduler extends Backbone.Model
    
    defaults:
      beatsPerBar: 4
      tempo: 120

    constructor: (scheduler) ->
      Backbone.Model.apply @
      @scheduler = scheduler

      @on 'change:beatsPerBar', @changeBeatsPerBar
      @on 'change:tempo', @changeTempo

      @changeBeatsPerBar(@, 4)

    changeBeatsPerBar: (scheduler, beatsPerBar) ->
      @scheduler.beatsPerBar = beatsPerBar

    changeTempo: (scheduler, bpm) ->
      @scheduler.setTempo(bpm)

    play: ->
      @scheduler.play.apply @scheduler, arguments

  new Scheduler(context.scheduler)