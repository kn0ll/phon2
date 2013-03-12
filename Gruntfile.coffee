module.exports = (grunt) ->

  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-livereload'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-open'
  grunt.loadNpmTasks 'grunt-regarde'

  grunt.initConfig

    # empty dirs for builds
    clean:
      dist: ['dist/*']

    # compiles all .coffee files in coffee/* and moves them into js/*
    coffee:
      
      compile:
        files: grunt.file.expandMapping(['src/coffee/**/*.coffee'], 'dist/js/',
          rename: (destBase, destPath) ->
            destBase + destPath.replace(/\.coffee$/, '.js').replace(/src\/coffee\//, ''))
        options:
          bare: true

    # copies all .js files in coffee/* and moves them into js/*
    # this allows us to put js sources directly inside the coffee
    # directory and use them as normal dependencies
    copy:
      
      html:
        files: grunt.file.expandMapping(['src/*.html'], 'dist/',
          rename: (destBase, destPath) ->
            destBase + destPath.replace(/\.html$/, '.html').replace(/src\//, ''))
      
      js:
        files: grunt.file.expandMapping(['src/coffee/**/*.js'], 'dist/js/',
          rename: (destBase, destPath) ->
            destBase + destPath.replace(/\.js$/, '.js').replace(/src\/coffee\//, ''))

    # watch for changes to any source files
    # and recompile them or copy them accordingly
    regarde:

      coffee:
        files: 'src/coffee/**/*.coffee'
        tasks: ['coffee']

      js:
        files: 'src/coffee/**/*.js'
        tasks: ['copy:js']

      html:
        files: 'src/**/*.html'
        tasks: ['copy:html']

      livereload:
        files: ['dist/**/*']
        tasks: ['livereload']

    open:

      server:
        url: 'http://localhost:8000'

  grunt.registerTask 'server', ->
    fs = require('fs')
    express = require('express')
    app = express()
    directories = ['js']

    for directory in directories
      app.get '/' + [directory, '*?'].join('/'), (req, res, next) ->
        path = req.url.split('?')[0]
        res.sendfile 'dist' + path, {}, (err) ->
          res.send(404) if err

    app.get /(.+)?/, (req, res) ->
      index = fs.readFileSync(['dist', 'index.html'].join('/'), 'utf8')
      res.send(index)

    app.listen(8000)
  
  # compile all source files in src/coffee/
  grunt.registerTask 'compile-coffee', [
    'coffee',
    'copy:js']

  # compile/copy all sources into dist/
  grunt.registerTask 'build-dist', [
    'clean:dist',
    'compile-coffee',
    'copy:html']

  # default
  grunt.registerTask 'default', [
    'build-dist',
    'server',
    'livereload-start',
    'open',
    'regarde']