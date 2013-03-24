(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['underscore', 'backbone', 'gui/range'], function(_, Backbone, RangeView) {
    return (function(_super) {
      var createInputBlock,
        _this = this;

      __extends(_Class, _super);

      createInputBlock = function(label, view) {
        var $div;
        $div = $('<div class="input" />');
        $div.append($("<label>" + label + "</label>"));
        return $div.append(view.render().el);
      };

      _Class.prototype.tagName = 'form';

      _Class.prototype.className = 'hud-phon';

      function _Class(scheduler) {
        Backbone.View.apply(this);
        this.scheduler = scheduler;
      }

      _Class.prototype.render = function() {
        var $fieldset, tempo_view;
        $fieldset = $('<fieldset />');
        tempo_view = new RangeView({
          model: this.scheduler,
          property: 'tempo',
          min: 1,
          max: 400
        });
        this.$el.empty();
        $fieldset.append($("<legend>phon</legend>"));
        $fieldset.append(createInputBlock('tempo', tempo_view));
        this.$el.append($fieldset);
        return this;
      };

      return _Class;

    }).call(this, Backbone.View);
  });

}).call(this);
