(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['underscore', 'audio/scheduler', 'models/boids/boid'], function(_, scheduler, Boid) {
    var Boids;
    Boids = (function(_super) {

      __extends(Boids, _super);

      function Boids() {
        return Boids.__super__.constructor.apply(this, arguments);
      }

      Boids.prototype.model = Boid;

      return Boids;

    })(Backbone.Collection);
    return (function(_super) {

      __extends(_Class, _super);

      function _Class() {
        return _Class.__super__.constructor.apply(this, arguments);
      }

      _Class.prototype.initialize = function(matrix) {
        var _this = this;
        Backbone.Model.prototype.initialize.apply(this);
        this.matrix = matrix;
        this.boids = new Boids();
        this.boids.on('change', function(boid) {
          var cell, oldX, oldY, old_cell, x, y;
          oldX = boid.previous('x');
          oldY = boid.previous('y');
          old_cell = _this.matrix.get(oldX, oldY);
          x = boid.get('x');
          y = boid.get('y');
          cell = _this.matrix.get(x, y);
          old_cell.set('occupied', false);
          cell.set('occupied', true);
          _this.trigger('move', old_cell, false);
          return _this.trigger('move', cell, true);
        });
        this.boids.on('add', function(boid) {
          var cell, x, y;
          x = boid.get('x');
          y = boid.get('y');
          cell = _this.matrix.get(x, y);
          cell.set('occupied', true);
          return _this.trigger('move', cell, true);
        });
        return this.boids.on('remove', function(boid) {
          var cell, x, y;
          x = boid.get('x');
          y = boid.get('y');
          cell = _this.matrix.get(x, y);
          cell.set('occupied', false);
          return _this.trigger('move', cell, false);
        });
      };

      _Class.prototype.start = function() {
        var sequence,
          _this = this;
        sequence = new PSequence([true], Infinity);
        return scheduler.play(sequence, 1, function() {
          return _this.tick(scheduler.scheduler.beatInBar);
        });
      };

      _Class.prototype.tick = function(beat) {
        var boids, cells, deadBoids, emitters, i, matrix, _i, _ref;
        matrix = this.matrix;
        cells = matrix.get();
        boids = this.boids;
        deadBoids = [];
        boids.each(function(boid) {
          var adjacent, coords, direction, x, y;
          x = boid.get('x');
          y = boid.get('y');
          direction = boid.get('direction');
          adjacent = matrix.getAdjacent(x, y, direction);
          if (adjacent) {
            coords = matrix.getCellCoords(adjacent);
            return boid.set({
              x: coords.x,
              y: coords.y
            });
          } else {
            return deadBoids.push(boid);
          }
        });
        for (i = _i = 0, _ref = deadBoids.length - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
          boids.remove(deadBoids[i]);
        }
        if (beat === 0) {
          emitters = _(cells).filter(function(cell) {
            return cell.get('type') === 'emitter';
          });
          _(emitters).each(function(emitter) {
            var adjacent, coords, direction, new_coords;
            direction = emitter.get('direction');
            coords = matrix.getCellCoords(emitter);
            adjacent = matrix.getAdjacent(coords.x, coords.y, direction);
            if (adjacent) {
              new_coords = matrix.getCellCoords(adjacent);
              return boids.add({
                x: new_coords.x,
                y: new_coords.y,
                direction: direction
              });
            }
          });
        }
        return boids.each(function(boid) {
          var cell, x, y;
          x = boid.get('x');
          y = boid.get('y');
          cell = matrix.get(x, y);
          if (cell && cell.get('type') === 'redirector') {
            return boid.set('direction', cell.get('direction'));
          }
        });
      };

      return _Class;

    })(Backbone.Model);
  });

}).call(this);
