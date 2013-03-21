(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['underscore', 'backbone'], function(_, Backbone) {
    return (function(_super) {

      __extends(_Class, _super);

      _Class.prototype.attributes = {
        "class": 'tools'
      };

      _Class.prototype.events = {
        'click .move-camera': 'toggleMoveCamera'
      };

      function _Class(matrixView) {
        this.initMoveCamera = __bind(this.initMoveCamera, this);
        Backbone.View.apply(this);
        this.matrixView = matrixView;
      }

      _Class.prototype.toggleMoveCamera = function() {
        var method;
        method = this._toggleMoveCamera ? 'off' : 'on';
        $(document)[method]('mousedown', this.initMoveCamera);
        return this._toggleMoveCamera = !this._toggleMoveCamera;
      };

      _Class.prototype.initMoveCamera = function(e) {
        var $doc, matrix_view, move, start_x, start_x_rotation, start_y, start_y_rotation;
        $doc = $(document);
        matrix_view = this.matrixView;
        start_x = e.clientX;
        start_y = e.clientY;
        start_y_rotation = matrix_view.rotation.y;
        start_x_rotation = matrix_view.rotation.x;
        move = function(move_e) {
          var diff_x, diff_y;
          diff_x = move_e.clientX - start_x;
          diff_y = move_e.clientY - start_y;
          matrix_view.rotation.y = start_y_rotation + diff_x * .002;
          return matrix_view.rotation.x = start_x_rotation + diff_y * .002;
        };
        $doc.on('mousemove', move);
        return $doc.on('mouseup', function() {
          $doc.off('mouseup', arguments.callee);
          return $doc.off('mousemove', move);
        });
      };

      _Class.prototype.render = function() {
        this.$el.append('<button class="move-camera">move camera</button>');
        return this;
      };

      return _Class;

    })(Backbone.View);
  });

}).call(this);
