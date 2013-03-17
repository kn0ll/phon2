require [
  'core/context',
  'models/boids/controller',
  'models/matrix/matrix',
  'models/matrix/cells/emitter',
  'models/matrix/cells/note',
  'models/matrix/cells/redirector',
  'models/phon/phon',
  'views/matrix/matrix',
  'views/phon/phon',
  'views/scene'
], (context, BoidController, Matrix,
  EmitterCell, NoteCell, RedirectorCell,
  Phon, MatrixView, PhonView, SceneView) ->

  # create matrix / boids
  matrix = new Matrix(5, 5)
  boidController = new BoidController
    matrix: matrix
  boidController.start()

  # create instrument
  phon = new Phon(context, boidController)
  #phon.connect(context.output)

  # create scene
  sceneView = new SceneView
  matrixView = new MatrixView
    collection: matrix
  phonView = new PhonView
    camera: sceneView.camera
    el: sceneView.el
    group: matrixView.render().group
    collection: matrix
    matrixView: matrixView
  sceneView.add(matrixView.group)
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