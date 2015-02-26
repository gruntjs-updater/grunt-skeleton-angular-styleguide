/*
 * grunt-skeleton-angular-styleguide
 * https://github.com/ginetta/grunt-skeleton-angular-styleguide
 *
 * Copyright (c) 2015 Ginetta
 * Licensed under the MIT license.
 */

"use strict";

module.exports = function(grunt) {

  var task = require("./skeleton_angular_styleguide/task")(grunt);

  // Please see the Grunt documentation for more information regarding task
  // creation: http://gruntjs.com/creating-tasks

  grunt.registerMultiTask("skeleton_angular_styleguide", "Grunt task that generates an angular styleguide using skeleton modules.", function() {
    // Merge task-specific and/or target-specific options with these defaults.

    var options = this.options({
      baseFolder: '/',
      bowerFolder: 'lib/',
      dest: this.files[0].dest,
      srcDir: 'app'
    });

    task.generateStyleguide(options);
  });



};
