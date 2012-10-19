// This is the main application configuration file.  It is a Grunt
// configuration file, which you can learn more about here:
// https://github.com/cowboy/grunt/blob/master/docs/configuring.md
module.exports = function(grunt) {
  'use strict';

  grunt.initConfig({

    // Compass compilation
    compass: {
      dev: {
        src: 'app/styles',
        dest: 'public/app/styles',
        linecomments: true,
        forcecompile: false,
        images: 'public/assets/images',
        relativeassets: true
      },
      prod: {
        src: 'app/styles',
        dest: 'public/app/styles',
        outputstyle: 'compressed',
        linecomments: false,
        forcecompile: true,
        images: 'public/assets/images',
        relativeassets: true
      }
    },

    // Reload configuration
    reload: {
      port: 35729, // LR default
      liveReload: true
    },

    // default watch configuration
    watch: {
      compass: {
        files: [
          'app/styles/**/*.{scss,sass}'
        ],
        tasks: 'compass:dev'
      },
      reload: {
        files: [
          'public/app/styles/**/*.css'
        ],
        tasks: 'reload'
      }
    }

  });

  // plugin tasks
  grunt.loadNpmTasks('grunt-compass');
  grunt.loadNpmTasks('grunt-reload');

  // default
  grunt.registerTask('default', 'reload watch');

};
