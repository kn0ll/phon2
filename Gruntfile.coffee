nconf = require('nconf')

defaults =
  src: 'src'      # --src=www
  www: 'dist/dev' # --www=dist/dev
  port: 8888      # --port=8888

nconf
  .argv()
  .env()
  .defaults(defaults)

module.exports = (grunt) ->
  src = nconf.get('src')
  www = nconf.get('www')
  port = nconf.get('port')

  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-livereload'
  grunt.loadNpmTasks 'grunt-contrib-sass'
  grunt.loadNpmTasks 'grunt-open'
  grunt.loadNpmTasks 'grunt-regarde'

  grunt.initConfig

    clean:
      www: ["#{www}/*"]

    coffee: 
      compile: 
        expand: true
        cwd: "#{src}/coffee"
        src: ["**/*.coffee"]
        dest: "#{www}/js"
        ext: '.js'

    sass: 
      compile: 
        expand: true
        cwd: "#{src}/sass"
        src: ["**/*.sass"]
        dest: "#{www}/css"
        ext: '.css'

    copy:
      js:
        expand: true
        cwd: "#{src}/coffee"
        src: ["**/*.js"]
        dest: "#{www}/js"
      misc:
        expand: true
        cwd: "#{src}"
        src: ["*.*"]
        dest: "#{www}"

    regarde: 
      coffee: 
        files: ["#{src}/coffee/**/*.coffee"]
        tasks: ["coffee:change"]
      sass: 
        files: ["#{src}/sass/**/*.sass"]
        tasks: ["sass:change"]
      js: 
        files: ["#{src}/coffee/**/*.js"]
        tasks: ["copy:js"]
      misc: 
        files: ["#{src}/*.*"]
        tasks: ["copy:misc"]
      livereload: 
        files: ["#{www}/**/*"]
        tasks: ["livereload"]

    connect:
      www:
        options:
          hostname: '0.0.0.0'
          port: port
          base: www

    open:
      www:
        url: "http://localhost:#{port}"

  # wrapper to rerun a grunt task. checks regards
  # changed files, updates the task configuration,
  # and reruns the task.
  createChangeTask = (task) ->
    grunt.registerTask "#{task}:change", ->
      conf = grunt.config
      cwd = conf.get "#{task}.compile.cwd"
      files = grunt.regarde.changed

      conf.set "#{task}.compile.src", files.map (changed) ->
        changed.split(cwd)[1].slice(1)
      grunt.task.run "#{task}:compile"

  grunt.registerTask createChangeTask('coffee')
  grunt.registerTask createChangeTask('sass')

  grunt.registerTask 'build', [
    'clean',
    'copy',
    'coffee:compile',
    'sass:compile']

  grunt.registerTask 'develop', [
    'livereload-start',
    'connect',
    'open',
    'regarde']

  grunt.registerTask 'default', [
    'build',
    'develop']