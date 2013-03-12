require [
  'core/context',
  'models/boids/controller',
  'models/matrix/matrix',
  'models/matrix/cells/emitter',
  'models/matrix/cells/note',
  'models/matrix/cells/redirector',
  'models/phon/phon',
  'views/matrix/matrix',
  'views/scene'
], (context, BoidController, Matrix,
  EmitterCell, NoteCell, RedirectorCell,
  Phon, MatrixView, SceneView) ->

  # create matrix / boids
  matrix = new Matrix(5, 5)
  boidController = new BoidController
    matrix: matrix

  # create instrument
  phon = new Phon(context, boidController)
  phon.connect(context.output)

  # create scene
  sceneView = new SceneView
  matrixView = new MatrixView(collection: matrix)
  matrixGroup = matrixView.render()

  # position scene
  sceneView.camera.position.z = 300
  matrixGroup.rotation.x = -1.2
  do =>
    matrixGroup.rotation.z += .002
    webkitRequestAnimationFrame(arguments.callee)

  # render scene
  sceneView.add(matrixGroup)
  $('body').append(sceneView.render().el)

  # create board

  boidController.setCell new NoteCell
    x: 1
    y: 1

  boidController.setCell new RedirectorCell
    x: 1
    y: 0
    direction: 'se'

  boidController.setCell new EmitterCell
    x: 1
    y: 4
    direction: 'n'

  # start game
  boidController.start()