module.exports = (grunt)->

  ############################################################
  # Project configuration
  ############################################################

  grunt.initConfig
    
    clean:
      build: [
        'public/**/*', 
        '!public/assets', 
        '!public/assets/*'
      ]
      buildStyles: [
        'public/css/**/*.css', 
        '!public/css/application.css'
      ]
      buildScripts: [
        'public/js/**/*.js', 
        '!public/js/application.js'
        '!public/js/vendor.js'
      ]
      watchStyles: [
        'public/css/**/*.css'
      ]
      watchScripts: [
        'public/js/**/*.js'
      ]

    bower_concat:
      all:
        dest: 'public/js/vendor.js'

    coffee:
      build:
        files: [
          expand: true
          cwd: 'app/js'
          src: ['**/*.coffee']
          dest: 'public/js'
          ext: '.js'
        ]

    uglify:
      build:
        options:
          mangle: true
        files:
          'public/js/application.js': ['public/**/*.js', '!public/js/vendor.js']
          'public/js/vendor.js': ['public/js/vendor.js']

    jade:
      build:
        files: [
          expand: true
          cwd: 'app'
          src: ['**/*.jade']
          dest: 'public'
          ext: '.html'
        ]

    stylus:
      build:
        options:
          compress: true
          linenos: false
        files: [
          expand: true
          cwd: 'app/css'
          src: ['**/*.styl']
          dest: 'public/css'
          ext: '.css'
        ]

    autoprefixer:
      build:
        expand: true
        cwd: 'public'
        src: ['**/*.css']
        dest: 'public'

    cssmin:
      build:
        files:
          'public/css/application.css': ['public/**/*.css']

    watch:
      styles:
        files: 'app/**/*.styl'
        tasks: ['watchStyles']
        options:
          livereload: true
      scripts: 
        files: 'app/**/*.coffee'
        tasks: ['watchScripts']
        options:
          livereload: true
      templates:
        files: 'app/**/*.jade'
        tasks: ['watchTemplates']
        options:
          livereload: true

    connect:
      server:
        options:
          base: 'public'



  ##############################################################
  # Dependencies
  ###############################################################
  
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-copy')
  grunt.loadNpmTasks('grunt-contrib-clean')
  grunt.loadNpmTasks('grunt-contrib-concat')
  grunt.loadNpmTasks('grunt-contrib-uglify')
  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-contrib-jade')
  grunt.loadNpmTasks('grunt-contrib-connect')
  grunt.loadNpmTasks('grunt-contrib-stylus')
  grunt.loadNpmTasks('grunt-autoprefixer')
  grunt.loadNpmTasks('grunt-contrib-cssmin')
  grunt.loadNpmTasks('grunt-bower-concat')

  ############################################################
  # Alias tasks
  ############################################################

  grunt.registerTask('buildTemplates', ['jade'])
  grunt.registerTask('buildStyles', ['stylus', 'autoprefixer', 'cssmin', 'clean:buildStyles'])
  grunt.registerTask('buildScripts', ['bower_concat', 'coffee', 'uglify', 'clean:buildScripts'])
  

  grunt.registerTask('build', ['clean:build', 'buildTemplates', 'buildStyles', 'buildScripts'])
  grunt.registerTask('server', ['build', 'connect', 'watch'])

  grunt.registerTask('watchScripts', ['clean:watchScripts', 'buildScripts'])
  grunt.registerTask('watchStyles', ['clean:watchStyles', 'buildStyles'])
  grunt.registerTask('watchTemplates', ['jade'])

  grunt.registerTask('default', ['build']);

