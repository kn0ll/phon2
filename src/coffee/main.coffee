require [
  'audio/output',
  'audio/scheduler',
  'models/boids/controller',
  'models/matrix/matrix',
  'audio/phon',
  'views/matrix/matrix',
  'views/hud/hud',
  'views/tools',
  'views/scene'
], (output, scheduler, BoidController, Matrix, Phon,
  MatrixView, HUDView, ToolsView, SceneView) ->

  # create matrix / boids
  matrix = new Matrix(8, 5)
  boidController = new BoidController(matrix)

  # create instrument
  phon = new Phon(boidController)

  # create scene
  matrixView = new MatrixView(matrix)
  sceneView = new SceneView(matrixView)
  hudView = new HUDView(matrix, scheduler)
  # toolsView = new ToolsView(matrixView)

  # start moving boids around board
  boidController.start()

  # connect the phon instrument to the speakers
  phon.connect(output)

  # render the interface
  $('body').append(sceneView.el)
  $('body').append(hudView.render().el)
  # $('body').append(toolsView.render().el)