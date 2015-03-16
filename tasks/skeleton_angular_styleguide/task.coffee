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
        componentsMetadata.push(componentData)

    return componentsMetadata

  createComponentsDataFile = (components, dest) ->
    grunt.file.write(dest + 'data/components.json', JSON.stringify(components, undefined, 2))


  generateStyleguideComponentPreview = (components, dest) ->
    jadeTemplate = _.map(components, (component) ->
      attrs = ' '
      _.each component.data, (dataValue, dataKey) ->
        attrs += changeCase.paramCase(dataKey) + "=" + '"' +  'data.' + dataKey + '", '
        console.log('dataKey', dataKey, 'dataValue', dataValue)
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
      baseFolder: options.baseFolder

    grunt.log.writeln('locals', locals)




    grunt.config.merge(config)
    grunt.task.run(['copy:styleguideTemplate'])
    grunt.file.glob.sync(base + '**/*.jade').forEach  (path) ->
      destFile = dest + path.replace(base, '').replace('.jade', '.html')
      templateContentFn = jade.compileFile(path, { pretty: true })
      grunt.file.write(destFile, templateContentFn(locals))
      grunt.log.writeln('file', destFile)


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
    return config


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

      grunt.log.writeln('pages path', options.pagesDir)
      pages = []
      grunt.file.glob.sync(options.pagesDir + '/*.html').forEach  (path) ->
        pageName = path.replace(options.pagesDir + '/', '').replace('.html', '')
        pages.push(pageName)
        grunt.log.writeln('page', pageName);
      grunt.file.write(options.dest + 'data/pages.json', JSON.stringify(pages, undefined, 2));
      # grunt.log.writeln('pages path', options.pagesDir)
      grunt.task.run(['copy:pagesExample', 'copy:dataFiles'])
  }
