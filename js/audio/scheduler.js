(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['backbone', 'audio/context'], function(Backbone, context) {
    var Scheduler;
    Scheduler = (function(_super) {

      __extends(Scheduler, _super);

      Scheduler.prototype.defaults = {
        beatsPerBar: 4,
        tempo: 120
      };

      function Scheduler(scheduler) {
        Backbone.Model.apply(this);
        this.scheduler = scheduler;
        this.on('change:beatsPerBar', this.changeBeatsPerBar);
        this.on('change:tempo', this.changeTempo);
        this.changeBeatsPerBar(this, 4);
      }

      Scheduler.prototype.changeBeatsPerBar = function(scheduler, beatsPerBar) {
        return this.scheduler.beatsPerBar = beatsPerBar;
      };

      Scheduler.prototype.changeTempo = function(scheduler, bpm) {
        return this.scheduler.setTempo(bpm);
      };

      Scheduler.prototype.play = function() {
        return this.scheduler.play.apply(this.scheduler, arguments);
      };

      return Scheduler;

    })(Backbone.Model);
    return new Scheduler(context.scheduler);
  });

}).call(this);
