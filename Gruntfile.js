/*
 * grunt-skeleton-angular-styleguide
 * https://github.com/ginetta/grunt-skeleton-angular-styleguide
 *
 * Copyright (c) 2015 Ginetta
 * Licensed under the MIT license.
 */

"use strict";

module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({

    // Before generating any new files, remove any previously-created files.
    clean: {
      tests: ["tmp"]
    },

    // Configuration to be run (and then tested).
    "skeleton_angular_styleguide": {
      "default_options": {
        options: {
        },
        files: {
          "tmp/default_options": ["test/fixtures/testing", "test/fixtures/123"]
        }
      },
      "custom_options": {
        options: {
          separator: ": ",
          punctuation: " !!!"
        },
        files: {
          "tmp/custom_options": ["test/fixtures/testing", "test/fixtures/123"]
        }
      }
    },

    // Unit tests.
    nodeunit: {
      tests: ["test/*_test.js"]
    },

    eslint: {
      options: {
        configFile: ".eslintrc"
      },
      target: ["Gruntfile.js", "tasks/*.js", "<%= nodeunit.tests %>"]
    }

  });

  require("load-grunt-tasks")(grunt);
  // Actually load this plugin"s task(s).
  grunt.loadTasks("tasks");


  // Whenever the "test" task is run, first clean the "tmp" dir, then run this
  // plugin"s task(s), then test the result.
  grunt.registerTask("test", ["clean", "skeleton_angular_styleguide", "nodeunit"]);

  // By default, lint and run all tests.
  grunt.registerTask("default", ["eslint", "test"]);

};
