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
          _this.trigger('move', old_cell, false, boid);
          return _this.trigger('move', cell, true, boid);
        });
        this.boids.on('add', function(boid) {
          var cell, x, y;
          x = boid.get('x');
          y = boid.get('y');
          cell = _this.matrix.get(x, y);
          cell.set('occupied', true);
          return _this.trigger('move', cell, true, boid);
        });
        return this.boids.on('remove', function(boid) {
          var cell, x, y;
          x = boid.get('x');
          y = boid.get('y');
          cell = _this.matrix.get(x, y);
          cell.set('occupied', false);
          return _this.trigger('move', cell, false, boid);
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
          var adjacent, coords, direction, n, nw, se, sw, x, y;
          x = boid.get('x');
          y = boid.get('y');
          direction = boid.get('direction');
          adjacent = matrix.getAdjacent(x, y, direction);
          if (adjacent) {
            coords = matrix.getCellCoords(adjacent);
            boid.set({
              x: coords.x,
              y: coords.y
            });
          } else {
            if (direction === 'ne') {
              if (nw = matrix.getAdjacent(x, y, 'nw')) {
                coords = matrix.getCellCoords(nw);
                boid.set({
                  x: coords.x,
                  y: coords.y,
                  direction: 'nw'
                });
              } else if (se = matrix.getAdjacent(x, y, 'se')) {
                coords = matrix.getCellCoords(se);
                boid.set({
                  x: coords.x,
                  y: coords.y,
                  direction: 'se'
                });
              } else if (sw = matrix.getAdjacent(x, y, 'sw')) {
                coords = matrix.getCellCoords(sw);
                boid.set({
                  x: coords.x,
                  y: coords.y,
                  direction: 'sw'
                });
              }
            } else if (direction === 'se') {
              if (nw = matrix.getAdjacent(x, y, 'sw')) {
                coords = matrix.getCellCoords(nw);
                boid.set({
                  x: coords.x,
                  y: coords.y,
                  direction: 'sw'
                });
              } else if (se = matrix.getAdjacent(x, y, 'ne')) {
                coords = matrix.getCellCoords(se);
                boid.set({
                  x: coords.x,
                  y: coords.y,
                  direction: 'ne'
                });
              } else if (sw = matrix.getAdjacent(x, y, 'nw')) {
                coords = matrix.getCellCoords(sw);
                boid.set({
                  x: coords.x,
                  y: coords.y,
                  direction: 'nw'
                });
              }
            } else if (direction === 's') {
              if (n = matrix.getAdjacent(x, y, 'n')) {
                coords = matrix.getCellCoords(n);
                boid.set({
                  x: coords.x,
                  y: coords.y,
                  direction: 'n'
                });
              }
            } else if (direction === 'sw') {
              if (nw = matrix.getAdjacent(x, y, 'se')) {
                coords = matrix.getCellCoords(nw);
                boid.set({
                  x: coords.x,
                  y: coords.y,
                  direction: 'se'
                });
              } else if (se = matrix.getAdjacent(x, y, 'nw')) {
                coords = matrix.getCellCoords(se);
                boid.set({
                  x: coords.x,
                  y: coords.y,
                  direction: 'nw'
                });
              } else if (sw = matrix.getAdjacent(x, y, 'ne')) {
                coords = matrix.getCellCoords(sw);
                boid.set({
                  x: coords.x,
                  y: coords.y,
                  direction: 'ne'
                });
              }
            } else if (direction === 'nw') {
              if (nw = matrix.getAdjacent(x, y, 'ne')) {
                coords = matrix.getCellCoords(nw);
                boid.set({
                  x: coords.x,
                  y: coords.y,
                  direction: 'ne'
                });
              } else if (se = matrix.getAdjacent(x, y, 'sw')) {
                coords = matrix.getCellCoords(se);
                boid.set({
                  x: coords.x,
                  y: coords.y,
                  direction: 'sw'
                });
              } else if (sw = matrix.getAdjacent(x, y, 'se')) {
                coords = matrix.getCellCoords(sw);
                boid.set({
                  x: coords.x,
                  y: coords.y,
                  direction: 'se'
                });
              }
            } else if (direction === 'n') {
              if (n = matrix.getAdjacent(x, y, 's')) {
                coords = matrix.getCellCoords(n);
                boid.set({
                  x: coords.x,
                  y: coords.y,
                  direction: 's'
                });
              }
            }
          }
          if (boid.get('steps') === 10) {
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
