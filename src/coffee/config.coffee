require.config

  deps: ['main']
  
  paths:
    jquery: 'lib/jquery'
    underscore: 'lib/underscore'
    backbone: 'lib/backbone'
    three: 'lib/three'
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

    audiolet:
      exports: 'Audiolet'