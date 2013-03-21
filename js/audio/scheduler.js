(function() {

  define(['audio/context'], function(context) {
    context.scheduler.beatsPerBar = 4;
    return context.scheduler;
  });

}).call(this);
