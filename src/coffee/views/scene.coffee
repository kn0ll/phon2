define [
  'backbone',
  'three',
  'models/scene'
], (Backbone, THREE, Scene) ->

  # the `scene` view is responsible for setting up
  # the 3js stage and camera and re-rendering the scene.
  # it's element is the 3js canvas.
  class extends Backbone.View

    constructor: ->
      super
      @model = new Scene
      width = @model.get('width')
      height = @model.get('height')

      # create scene
      @renderer = new THREE.CanvasRenderer()
      @scene = new THREE.Scene()
      @camera = new THREE.PerspectiveCamera(100, 1, 1, 1000)
      @camera.position.z = 300
      @camera.position.x = 70
      @camera.position.y = -110

      $(window).on 'resize', _.bind(@onResize, @)
      @onResize()

      # set canvas as el
      @setElement @renderer.domElement
      
      # keep rerendering the canvas
      do =>
        @render()
        webkitRequestAnimationFrame arguments.callee

    onResize: ->
      width = window.innerWidth
      height = window.innerHeight

      @camera.aspect = width / height
      @camera.updateProjectionMatrix()
      @renderer.setSize width, height
      @model.set
        width: width
        height: height

    # create a proxy view for accessing
    # the 3js scene's add method.
    add: ->
      scene = @scene
      scene.add.apply scene, arguments

    # render rerenders the 3js scene
    render: ->
      @renderer.render @scene, @camera
      @