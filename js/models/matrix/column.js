(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['backbone', 'models/matrix/cell'], function(Backbone, Cell) {
    var Cells;
    Cells = (function(_super) {

      __extends(Cells, _super);

      function Cells() {
        return Cells.__super__.constructor.apply(this, arguments);
      }

      Cells.prototype.model = Cell;

      return Cells;

    })(Backbone.Collection);
    return (function(_super) {

      __extends(_Class, _super);

      function _Class() {
        var y, _i, _ref;
        _Class.__super__.constructor.apply(this, arguments);
        this.cells = new Cells();
        for (y = _i = 0, _ref = this.get('height'); 0 <= _ref ? _i <= _ref : _i >= _ref; y = 0 <= _ref ? ++_i : --_i) {
          this.cells.add();
        }
      }

      return _Class;

    })(Backbone.Model);
  });

}).call(this);
