fs            = require('fs')
{spawn, exec} = require('child_process')

module.exports = (grunt) ->
  grunt.initConfig
    pkg:         grunt.file.readJSON "package.json"
    tmpDir:      "tmp/build/"
    packageDir:  "polychartPackaged/"

    #### Task to compile less files
    less:
      main:
        files: [
          { src: [ "src/main.less" ]
          , dest: "target/main.css" }
        ]

    jade:
      main:
        files: [
          { src: [ "src/index.jade" ]
          , dest: "target/index.html" }
        ]

    #### Task to watch files
    watch:
      files: ["src/*"]
      tasks: ["less", "jade"]

    #### Task to clean destination dir
    clean: [
      "target/"
    ]

  #### Load third party tasks
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-contrib-less'
  grunt.loadNpmTasks 'grunt-contrib-watch'

  grunt.registerTask 'server', "Run server", () ->
    done = @async()
    server = spawn("python", ["-m", "SimpleHTTPServer", "8181"])
    done(true)

    server.stdout.on 'data', (data) ->
      grunt.log.writeln data
    server.stderr.on 'data', (data) ->
      grunt.log.writeln "[Log]: #{data}"
    server.on 'close', (code) ->
      grunt.log.writeln "Server exited with code #{code}."

  #### Define tasks
  grunt.registerTask 'default', [
    'clean'
    'less'
    'jade'
    'server'
    'watch'
  ]
