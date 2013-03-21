require [
  'audio/output',
  'models/boids/controller',
  'models/matrix/matrix',
  'audio/phon',
  'views/matrix/matrix',
  'views/tools',
  'views/scene',
  'views/cell-manager'
], (output, BoidController, Matrix, Phon,
  MatrixView, ToolsView, SceneView, CellManager) ->

  # create matrix / boids
  matrix = new Matrix(8, 5)
  boidController = new BoidController(matrix)

  # create instrument
  phon = new Phon(boidController)

  # create scene
  matrixView = new MatrixView(matrix)
  sceneView = new SceneView(matrixView)
  cellManager = new CellManager(sceneView)
  toolsView = new ToolsView(matrixView)

  # start moving boids around board
  boidController.start()

  # connect the phon instrument to the speakers
  phon.connect(output)

  # render the interface
  $('body').append(sceneView.el)
  $('body').append(toolsView.render().el)