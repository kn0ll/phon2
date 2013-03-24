(function() {

  require.config({
    name: 'backbone.gui'
  });

  define(['./gui/button', './gui/checkbox', './gui/range', './gui/select', './gui/text'], function(Button, Checkbox, Range, Select, Text) {
    return {
      Button: Button,
      Checkbox: Checkbox,
      Range: Range,
      Select: Select,
      Text: Text
    };
  });

}).call(this);
