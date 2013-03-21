(function() {

  require(['audio/output', 'models/boids/controller', 'models/matrix/matrix', 'audio/phon', 'views/matrix/matrix', 'views/tools', 'views/scene', 'views/cell-manager'], function(output, BoidController, Matrix, Phon, MatrixView, ToolsView, SceneView, CellManager) {
    var boidController, cellManager, matrix, matrixView, phon, sceneView;
    matrix = new Matrix(8, 5);
    boidController = new BoidController(matrix);
    phon = new Phon(boidController);
    matrixView = new MatrixView(matrix);
    sceneView = new SceneView(matrixView);
    cellManager = new CellManager(sceneView);
    boidController.start();
    phon.connect(output);
    return $('body').append(sceneView.el);
  });

}).call(this);
