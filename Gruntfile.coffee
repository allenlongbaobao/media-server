module.exports = (grunt)->

  grunt.initConfig {
    clean:
      bin: ['bin/']
    livescript:
      src: {
        files: [
          {expand: true, flatten: true, src: ['src/**/*.ls'], dest: 'bin/', ext: '.js'}
        ]
      }
    watch:
      src:
        files: ['src/**/*.ls']
        tasks: ['livescript']
        options:
          spawn: true
    nodemon:
      all:
        options:
          file: 'bin/app.js'
          watchedFolders: ['bin']
    concurrent:
      target:
        tasks: ['nodemon', 'watch']
        options:
          logConcurrentOutput: true
  }
  
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-jshint'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-livescript'
  grunt.loadNpmTasks 'grunt-nodemon'
  grunt.loadNpmTasks 'grunt-concurrent'
  
  grunt.registerTask 'default', ['clean', 'livescript', 'concurrent']
