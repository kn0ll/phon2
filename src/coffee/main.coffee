require [
  'audio/output',
  'models/boids/controller',
  'models/matrix/matrix',
  'audio/phon',
  'views/matrix/matrix',
  'views/tools',
  'views/scene'
], (output, BoidController, Matrix, Phon,
  MatrixView, ToolsView, SceneView) ->

  # create matrix / boids
  matrix = new Matrix(8, 5)
  boidController = new BoidController(matrix)

  # create instrument
  phon = new Phon(boidController)

  # create scene
  matrixView = new MatrixView(matrix)
  sceneView = new SceneView(matrixView)
  toolsView = new ToolsView(matrixView)

  # create board
  matrix.set [{
    x: 1,
    y: 0,
    direction: 'se',
    type: 'redirector'
  }, {
    x: 1,
    y: 1,
    type: 'note'
  }, {
    x: 1,
    y: 5,
    direction: 'n',
    type: 'emitter'
  }]

  # start moving boids around board
  boidController.start()

  # connect the phon instrument to the speakers
  phon.connect(output)

  # render the interface
  $('body').append(sceneView.el)
  $('body').append(toolsView.render().el)