module.exports = (grunt)->

  ############################################################
  # Project configuration
  ############################################################

  grunt.initConfig

    cfg: 
      # http:
      #   port: 8010 # http server port
      #   host: '*' # listen on all interfaces
      #   livereloadport: 3810 #livereload port      
      # tmp: '.tmp'
      # dist: 'public'
      # coffeeFiles: [
      #   'app/js/app.coffee' # first app coffee
      #   'app/*.coffee'
      #   'app/**/*.coffee'
      # ]
      coffeeFiles: [
        'app/js/app.coffee' # first app js
        'app/js/*.coffee'
        'app/js/**/*.coffee'
      ] 
    
    clean:
      all:[
        '.tmp/**/*'
        'public/**/*',
      ]
      stylus: [
        '.tmp/css/index.css'
      ]

    coffee:
      options:
        bare: true
        sourceMap: true      
      build:
        files:
          '.tmp/js/application.js': '<%= cfg.coffeeFiles %>'

    uglify:
      build:
        options:
          mangle: true
        files: [
          {
            dest: 'public/js/application.js'
            src: '.tmp/js/application.js'
          },
          {
            dest: 'public/js/vendor.js'
            src: '.tmp/concat/js/vendor.js'
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
      tmp:
        options:
          compress: false
          linenos: false
        files: [
          expand: true
          cwd: 'app/css/'
          src: ['index.styl']
          dest: '.tmp/css'
          ext: '.css'
        ]

    cssmin:
      build:
        files: [
          {
            dest: 'public/css/application.css'
            src: '.tmp/css/application.css'
          },
          {
            dest: 'public/css/vendor.css'
            src: '.tmp/concat/css/vendor.css'
          }
        ]

    watch:
      options:
        spawn: false
        livereload: 3810
      styles:
        files: 'app/**/*.styl'
        tasks: ['stylus', 'copy:stylus','clean:stylus']
      scripts: 
        files: 'app/**/*.coffee'
        tasks: ['coffee']
      templates:
        files: 'app/**/*.jade'
        tasks: ['jade']
      assets:
        files: 'app/assets/**/*'
        tasks: ['copy:assets']

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

    usemin:
      html: ['public/index.html']

    copy:
      assets:
        files: [
          expand: true
          cwd: 'app/assets'
          # src: ['**', '!**/*.png', '!**/*.jpg', '!**/*.gif']
          src: ['**']
          dest: 'public/'
        ]
      stylus: 
        files: '.tmp/css/application.css': '.tmp/css/index.css'

    # concat:
    #   build:
    #     files: [
    #       # {
    #       #   dest: '.tmp/concat/js/application.js'
    #       #   src: ['<%= cfg.coffeeFiles %>']
    #       # }
    #       {
    #         dest: '.tmp/concat/css/application.css'
    #         src: ['.tmp/stylus/index.css']            
    #       }
    #     ]

    # concat:
    #   vendor:
    #     options:
    #       separator: ';\n'
    #     src: ['app/**/*.js', '!app/assets/**/*.js', '!app/assets/test/**']
    #     dest: '<%= cfg.tmp %>/vendor.js'
    #   css:
    #     options:
    #       separator: '\n\n'
    #     src: ['app/**/*.css']
    #     dest: '<%= cfg.tmp %>/vendor.css'

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
  grunt.loadNpmTasks('grunt-contrib-cssmin')
  grunt.loadNpmTasks('grunt-usemin')

  ############################################################
  # Alias tasks
  ############################################################

  grunt.registerTask('server', [
    'clean:all' # public and tmp
    'copy:assets' # public
    'coffee' # tmp
    'jade' # public
    'stylus' # tmp
    'copy:stylus' # tmp
    'clean:stylus' # tmp
    # 'useminPrepare'
    # 'concat:build' # tmp
    # 'cssmin' # public
    'connect:server'
    'watch'
  ])

  grunt.registerTask('build', [
    'clean:all' # public and tmp
    'copy:assets' # public
    'coffee' # tmp
    'jade' # public
    'stylus' # tmp
    'copy:stylus' # tmp
    'clean:stylus' # tmp
    'useminPrepare'
    'usemin'
    'concat' # tmp
    'cssmin:build' # public
    'uglify:build' # public
  ])
