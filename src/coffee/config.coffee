require.config

  deps: ['main']
  
  paths:
    jquery: 'lib/jquery'
    underscore: 'lib/underscore'
    backbone: 'lib/backbone'
    three: 'lib/three'
    tween: 'lib/tween'
    audiolet: 'lib/Audiolet'

  shim:

    underscore:
      exports: '_'

    jquery:
      exports: 'jQuery'

    backbone:
      deps: ['underscore', 'jquery']
      exports: 'Backbone'

    three:
      exports: 'THREE'

    tween:
      exports: 'TWEEN'

    audiolet:
      exports: 'Audiolet'