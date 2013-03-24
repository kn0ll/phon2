(function() {

  require(['audio/output', 'audio/scheduler', 'models/boids/controller', 'models/matrix/matrix', 'audio/phon', 'views/matrix/matrix', 'views/hud/hud', 'views/tools', 'views/scene'], function(output, scheduler, BoidController, Matrix, Phon, MatrixView, HUDView, ToolsView, SceneView) {
    var boidController, hudView, matrix, matrixView, phon, sceneView;
    matrix = new Matrix(8, 5);
    boidController = new BoidController(matrix);
    phon = new Phon(boidController);
    matrixView = new MatrixView(matrix);
    sceneView = new SceneView(matrixView);
    hudView = new HUDView(matrix, scheduler);
    boidController.start();
    phon.connect(output);
    $('body').append(sceneView.el);
    return $('body').append(hudView.render().el);
  });

}).call(this);
