jade       = require('jade')
_          = require('lodash')
changeCase = require('change-case')

module.exports = (grunt, options)  ->
  # Config Variables
  srcDir     = null
  base     = 'node_modules/grunt-skeleton-angular-styleguide/tasks/skeleton_angular_styleguide/styleguide-template/'

  parseAngularComponentsMetadata = ->
    componentsMetadata = []
    grunt.file.glob.sync(srcDir + '/components/**/package.yml').forEach  (path) ->
      componentData = grunt.file.readYAML(path)
      name = componentData.name
      if componentData.type && componentData.type == "angular"
        componentData.basePath = path.replace('package.yml', '')
        componentData.nameCC   = changeCase.camelCase(name)
        componentsMetadata.push(componentData)

    return componentsMetadata

  createComponentsDataFile = (components, dest) ->
    grunt.file.write(dest + 'data/components.json', JSON.stringify(components, undefined, 2))


  generateStyleguideComponentPreview = (components, dest) ->
    jadeTemplate = _.map(components, (component) ->
      attrs = ' '
      _.each component.data, (dataValue, dataKey) ->
        attrs += changeCase.paramCase(dataKey) + "=" + '"' +  'data.' + dataKey + '", '
      return component.name + '(' + attrs + 'options="options", ng-if="component.name === ' + "'" + component.name + "'" + '")'
    ).join('\n')
    htmlresult = jade.render(jadeTemplate, { pretty: true })
    previewTemplateDest = dest + 'component/component-preview.html'
    grunt.file.write(previewTemplateDest, htmlresult)


  compileStyleguideTemplates = (dest, options) ->
    config =
      copy:
        styleguideTemplate:
          src: '**/*.js'
          dest: dest
          expand: true
          cwd: base

    locals =
      baseFolder         : options.baseFolder
      exampleControllers : getExampleControllers(options)
      widgetsMainPaths   : getWidgetsMainPaths(options)


    grunt.config.merge(config)
    grunt.task.run(['copy:styleguideTemplate'])
    grunt.file.glob.sync(base + '**/*.jade').forEach  (path) ->
      destFile = dest + path.replace(base, '').replace('.jade', '.html')
      templateContentFn = jade.compileFile(path, { pretty: true })
      grunt.file.write(destFile, templateContentFn(locals))


  compileStyleguideStyles = (dest) ->
    config =
      sass:
        styleguideAngular:
          expand: true
          cwd: base
          src: ['styleguide.scss']
          dest: dest + 'css/'
          ext: '.css'

    grunt.config.merge(config)
    grunt.task.run(['sass:styleguideAngular'])


  copyBowerComponents = (dest, bowerFolder) ->
    config =
      copy:
        bowerToStyleguide:
            cwd: bowerFolder
            expand: true
            src: 'bower_components/**/*'
            dest: dest
    grunt.config.merge(config)
    grunt.task.run(['copy:bowerToStyleguide'])


  copyColorsFile = (options) ->
    grunt.config.merge(getAllConfigs(options))
    grunt.task.run ['copy:colorsFile']
  copyTypographyFile = ->
      grunt.task.run ['copy:typographyFile']

  getAllConfigs = (options) ->
    dest           = options.dest
    srcDir         = options.srcDir
    baseStylesPath = srcDir + '/css/styles/'

    config =
      copy:
        typographyFile:
          cwd: baseStylesPath + 'typography'
          expand: true
          src: '*.json'
          dest: dest + 'data'
        colorsFile:
          cwd: baseStylesPath + 'colors'
          expand: true
          src: '*.json'
          dest: dest + 'data'
        dataFiles:
          cwd: srcDir + '/data'
          expand: true
          src: '*.json'
          dest: dest + 'data'
        pagesExample:
          cwd: options.pagesDir
          expand: true
          src: '*.html'
          dest: dest + 'pages'
        controllersExample:
          cwd: options.pagesDir
          expand: true
          src: '*.js'
          dest: dest + 'pages'
    return config

  getExampleControllers = (options) ->
    controllers = []
    grunt.file.glob.sync(options.pagesDir + '/*.js').forEach  (path) ->
      controllerName = path.replace(options.pagesDir + '/', '').replace('.js', '')
      controllers.push(controllerName)
    return controllers

  getWidgetsMainPaths = (options) ->
    DEPENDENCIES_TO_SKIP = ['jquery']
    bowerConf = grunt.file.readJSON('bower.json')
    widgetsDepsMainPath = _.map bowerConf.dependencies, (version, name) ->
      depConf = grunt.file.readJSON(options.bowerFolder + 'bower_components/' + name + '/bower.json')

      # we do not want to keep this dependency
      # because either the styleguide also uses it or it doesn't have a file
      if _.contains(DEPENDENCIES_TO_SKIP, name) || !depConf.main
        return []


      isJsFile = (filename) -> return filename.indexOf('.js') != -1

      # if main is not an array (i.e. it has only one file) convert it to array
      if !_.isArray(depConf.main)
        depConf.main = [depConf.main]

      javascriptOnlyFiles = _.filter(depConf.main, isJsFile)



      return _.map javascriptOnlyFiles, (jsMainPath) ->
        return name + '/' + jsMainPath


    return _.flatten(widgetsDepsMainPath)

  createWidgetsDocumentation = (components, options) ->
    config =
      ngdocs:
        options:
          dest: options.dest + '/docs'
        styleguideWidgetsDocs:
          src: [options.srcDir + '/components/**/*.js']
          title: 'Widgets Documentation'
    grunt.config.merge(config)
    grunt.task.run(['ngdocs:styleguideWidgetsDocs'])



  copyExamplePages = (options) ->
    pages = []

    grunt.file.glob.sync(options.pagesDir + '/*.html').forEach  (path) ->
      pageName = path.replace(options.pagesDir + '/', '').replace('.html', '')
      pages.push(pageName)
    grunt.file.write(options.dest + 'data/pages.json', JSON.stringify(pages, undefined, 2));
    grunt.task.run(['copy:pagesExample', 'copy:controllersExample'])



  return {
    getAllConfigs      : getAllConfigs
    copyColorsFile     : copyColorsFile
    copyTypographyFile : copyTypographyFile

    generateStyleguide : (options) ->

      dest           = options.dest
      srcDir         = options.srcDir
      baseStylesPath = srcDir + '/css/styles/'

      config = getAllConfigs(options)
      grunt.config.merge(config)


      # Parse widgets metadata
      components = parseAngularComponentsMetadata()

      # create artifacts into styleguide/dist folder
      createComponentsDataFile(components, dest)
      copyColorsFile(options)
      copyTypographyFile()


      compileStyleguideTemplates(dest, options)
      compileStyleguideStyles(dest)
      generateStyleguideComponentPreview(components, dest)

      copyBowerComponents(dest, options.bowerFolder)
      copyExamplePages(options)


      createWidgetsDocumentation(components, options)


      grunt.task.run(['copy:dataFiles'])
  }
