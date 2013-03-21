(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', 'underscore', 'three', 'tween', 'graphics/utils'], function($, _, THREE, TWEEN, ThreeUtils) {
    return (function(_super) {

      __extends(_Class, _super);

      function _Class(matrixView) {
        var center,
          _this = this;
        THREE.Scene.apply(this);
        this.matrixView = matrixView;
        this.renderer = new THREE.CanvasRenderer();
        this.camera = new THREE.PerspectiveCamera(100, 1, 1, 1000);
        this.el = this.renderer.domElement;
        $(window).on('resize', (function() {
          var height, width;
          width = window.innerWidth;
          height = window.innerHeight;
          _this.camera.aspect = width / height;
          _this.camera.updateProjectionMatrix();
          _this.renderer.setSize(width, height);
          return arguments.callee;
        })());
        this.add(matrixView.render());
        (function() {
          TWEEN.update();
          _this.renderer.render(_this, _this.camera);
          return webkitRequestAnimationFrame(arguments.callee);
        })();
        center = ThreeUtils.computeObject3DCenter(matrixView);
        this.camera.position.x = center.x;
        this.camera.position.y = center.y;
        this.camera.position.z = 300;
      }

      return _Class;

    })(THREE.Scene);
  });

}).call(this);
