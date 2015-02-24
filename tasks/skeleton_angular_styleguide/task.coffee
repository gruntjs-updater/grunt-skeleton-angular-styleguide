jade = require('jade')
_    = require('lodash')

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

  createStylesDataFile = (dest) ->
    baseStylesPath = srcDir + '/css/styles/'

    config =
      copy:
        typographyConfig:
          cwd: baseStylesPath + 'typography'
          expand: true
          src: '*.json'
          dest: dest + 'data'
        colorsConfig:
          cwd: baseStylesPath + 'colors'
          expand: true
          src: '*.json'
          dest: dest + 'data'

    grunt.config.merge(config)
    grunt.task.run(['copy:typographyConfig', 'copy:colorsConfig'])

  generateStyleguideComponentPreview = (components, dest) ->
    jadeTemplate = _.map(components, (component) ->
      return component.name + '(data="data", options="options", ng-if="component.name === ' + "'" + component.name + "'" + '")'
    ).join('\n')
    htmlresult = jade.render(jadeTemplate, { pretty: true })
    previewTemplateDest = dest + 'component/component-preview.html'
    grunt.file.write(previewTemplateDest, htmlresult)


  compileStyleguideTemplates = (dest) ->
    config =
      copy:
        styleguideTemplate:
          src: '**/*.js'
          dest: dest
          expand: true
          cwd: base

    grunt.config.merge(config)
    grunt.task.run(['copy:styleguideTemplate'])
    grunt.file.glob.sync(base + '**/*.jade').forEach  (path) ->
      destFile = dest + path.replace(base, '').replace('.jade', '.html')
      templateContent = jade.renderFile(path, { pretty: true })
      grunt.file.write(destFile, templateContent)


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
  return {
    generateStyleguide: (options) ->
      dest   = options.dest
      srcDir = options.srcDir
      # Parse widgets metadata
      components = parseAngularComponentsMetadata()

      # create artifacts into styleguide/dist folder
      createComponentsDataFile(components, dest)
      createStylesDataFile(dest)


      compileStyleguideTemplates(dest)
      compileStyleguideStyles(dest)
      generateStyleguideComponentPreview(components, dest)
  }
