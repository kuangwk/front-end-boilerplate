module.exports = (grunt)->

    coffeeify = require 'coffeeify'
    stringify = require 'stringify'

    grunt.initConfig
        browserify: 
            dev: 
                options: 
                    preBundleCB: (b)->
                        b.transform coffeeify
                        b.transform(stringify({extensions: ['.hbs', '.html', '.tpl', '.txt']}))
                expand: true
                flatten: true
                src: ['src/js/main.coffee']
                dest: 'bin/js/'
                ext: '.js'

        less:
            dev: 
                files:
                    'bin/css/style.css': ['src/**/*.less']

        connect: 
            server: 
                options:
                    port: 3000
                    base: '.'

        clean: 
            bin: ['bin']
            dist: ['dist']

        watch: 
            compile: 
                files: [
                    'src/**/*.coffee'
                    'src/**/*.less'
                    'src/**/*.html'
                    'index.html'
                ]
                tasks: ['clean', 'browserify', 'less']

        cssmin: 
            build:
                files:
                    'dist/css/style.min.css': ['bin/css/style.css']

        uglify: 
            build:
                files:
                    'dist/js/main.min.js': ['lib/**/*.js', 'bin/js/main.js']

        copy: 
            build:
                files:
                    'dist/index.html': ['_index-dist.html']


    grunt.loadNpmTasks 'grunt-browserify'
    grunt.loadNpmTasks 'grunt-contrib-clean'
    grunt.loadNpmTasks 'grunt-contrib-less'
    grunt.loadNpmTasks 'grunt-contrib-connect'
    grunt.loadNpmTasks 'grunt-contrib-watch'
    grunt.loadNpmTasks 'grunt-contrib-cssmin'
    grunt.loadNpmTasks 'grunt-contrib-uglify'
    grunt.loadNpmTasks 'grunt-contrib-copy'

    grunt.registerTask 'default', ->
        grunt.task.run [
            'connect'
            'clean:bin'
            'browserify'
            'less'
            'watch'
        ]

    grunt.registerTask 'build', ->
        grunt.task.run [
            'clean:dist'        
            'browserify'
            'less'
            'uglify'
            'cssmin'
            'copy'
        ]