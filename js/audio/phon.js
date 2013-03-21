(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['audiolet', 'audio/context'], function(Audiolet, context) {
    return (function(_super) {

      __extends(_Class, _super);

      function _Class(boidController) {
        var _this = this;
        _Class.__super__.constructor.call(this, context, 0, 1);
        this.instrument = new Instrument(context);
        this.gain = new Gain(context, 0.05);
        boidController.on('move', function(cell, occupied) {
          var key, note, velocity;
          key = cell.get('key');
          velocity = cell.get('velocity');
          if (cell.get('type') === 'note') {
            note = occupied ? 144 : 128;
            return _this.instrument.midi(note, key, velocity);
          }
        });
        this.instrument.connect(this.gain);
        this.gain.connect(this.outputs[0]);
      }

      return _Class;

    })(AudioletGroup);
  });

}).call(this);
