module.exports = (grunt)->

  ############################################################
  # Project configuration
  ############################################################

  grunt.initConfig
    
    clean:
      tmp: [
        '.tmp/*'
      ]
      public: [
        'public/*'
      ]
      # build: [
      #   'public/**/*', 
      #   '!public/assets', 
      #   '!public/assets/*'
      # ]
      # buildStyles: [
      #   'public/css/**/*.css', 
      #   '!public/css/application.css'
      # ]
      # buildScripts: [
      #   'public\\js\\**\\*.js', 
      #   '!public\\js\\application.js'
      #   '!public\\js\\vendor.js'
      # ]
      # watchStyles: [
      #   'public/css/**/*.css'
      # ]
      # watchScripts: [
      #   'public/js/**/*.js'
      # ]

    concat:
      server:
        files: [
          {
            dest: 'public/js/application.js'
            src: '.tmp/**/*.js'
          }
          {
            dest: 'public/css/application.css'
            src: '.tmp/**/*.css'
          }
        ]
    #   generated:
    #     files: [ 
    #       {
    #         dest: '.tmp\\concat\\css\\vendor.css',
    #         src: [ 'bower_components\\normalize-css\\normalize.css' ] 
    #       }
    #       { 
    #         dest: '.tmp\\concat\\js\\vendor.js',
    #         src: [ 'bower_components\\jquery\\dist\\jquery.js' ] 
    #       } 
    #     ]


    # bower_concat:
    #   all:
    #     dest: 'public/js/vendor.js'
    #     exclude: ['normalize-css']

    coffee:
      build:
        files: [
          expand: true
          cwd: 'app/js'
          src: ['**/*.coffee']
          dest: '.tmp/js/'
          ext: '.js'
        ]

    uglify:
      build:
        options:
          mangle: true
        files: [
          {
            dest: 'public/js/application.js'
            src: ['public/**/*.js', '!public/js/vendor.js']
          }
          {
            dest: 'public/js/vendor.js'
            src: ['public/js/vendor.js']
          }
        ]

    jade:
      build:
        options:
          pretty: true
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
          src: ['index.styl']
          dest: '.tmp/css'
          ext: '.css'
        ]
      server:
        options:
          compress: false
          linenos: false
        files: [
          expand: true
          cwd: 'app/css'
          src: ['index.styl']
          dest: '.tmp/css'
          ext: '.css'
        ]

    # autoprefixer:
    #   build:
    #     expand: true
    #     cwd: 'public'
    #     src: ['**/*.css']
    #     dest: 'public'

    cssmin:
      build:
        files:
          'public/css/application.css': ['.tmp/**/*.css']

    watch:
      options:
        livereload: 3810
      styles:
        files: 'app/**/*.styl'
        tasks: ['watchStyles']
      scripts: 
        files: 'app/**/*.coffee'
        tasks: ['watchScripts']
      templates:
        files: 'app/**/*.jade'
        tasks: ['watchTemplates']

    connect:
      options:
        port: '8010'
        hostname: 'localhost'
        livereload: '3810'
        base: 'public'
      server:
        options:
          open: true
          base: ['.tmp', 'bower_components', '.', 'public']
          
    # process index file
    useminPrepare:
      html: 'public/index.html'
      options:
        dest: 'public'
        # flow: { steps: { 'js': [], 'css': []}, post: {}}

    usemin:
      html: ['public/index.html']


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
  grunt.loadNpmTasks('grunt-usemin')

  ############################################################
  # Alias tasks
  ############################################################

  grunt.registerTask('buildTemplates', ['jade'])
  grunt.registerTask('buildStyles', ['stylus', 'autoprefixer', 'cssmin', 'clean:buildStyles'])
  grunt.registerTask('buildScripts', ['coffee', 'uglify', 'clean:buildScripts'])
  

  grunt.registerTask('build', ['clean:build', 'buildTemplates', 'buildStyles', 'buildScripts'])

  grunt.registerTask('watchScripts', ['clean:watchScripts', 'buildScripts'])
  grunt.registerTask('watchStyles', ['clean:watchStyles', 'buildStyles'])
  grunt.registerTask('watchTemplates', ['jade'])

  grunt.registerTask('default', ['build'])

  grunt.registerTask('use', ['jade', 'useminPrepare','usemin', 'concat'])


  grunt.registerTask('server', 
    [
      'clean:public'
      'jade'

      'stylus:server'

      'coffee'

      'concat' #js and css from .tmp to public

      'clean:tmp'

      'connect:server'
      'watch'
    ]
  )

