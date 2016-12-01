{CompositeDisposable} = require 'atom'
helpers = require 'atom-linter'

module.exports =
  config:
    executablePath:
      title: 'Executable Path'
      type: 'string'
      default: 'mypy'
      description: "Path to executable mypy cmd."
      order: 1
    ignoreFiles:
      type: 'string'
      default: ''
      description: 'Filename pattern to ignore, e.g.: test_; Restart Atom to activate/deactivate.'
      order: 2

  activate: ->
    require('atom-package-deps').install('linter-mypy')
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.config.observe 'linter-mypy.executablePath',
      (executablePath) =>
        @executablePath = executablePath
    @subscriptions.add atom.config.observe 'linter-mypy.ignoreFiles',
      (ignoreFiles) =>
        @ignoreFiles = ignoreFiles

  deactivate: ->
    @subscriptions.dispose()

  lintPath: (filePath)->
    params = [filePath]
    if @addSelectCodes
      params.push("--add-select=" + @addSelectCodes)
    if @ignoreCodes
      params.push("--add-ignore=" + @ignoreCodes)
    options = { stream: 'stderr', allowEmptyStderr: true }
    return helpers.exec(@executablePath, params, options)

  parseMessages: (output) ->
    # parse lint output
    output = output.replace(/:[\r\n]\s+/mg, " | ") # combine multiline output
    messages = helpers.parse(output,
                             "^(?<file>.+):(?<line>\\d+).+ \\| (?<message>.+)",
                             {flags: 'gm'})
    messages.forEach (msg) ->
      msg.type = "Info"
    return messages

  provideLinter: ->
    provider =
      grammarScopes: ['source.python']
      scope: 'file'
      lintOnFly: false
      lint: (textEditor) =>
        if (@ignoreFiles == '' || textEditor.getPath().indexOf(@ignoreFiles) == -1)
          return @lintPath textEditor.getPath()
            .then @parseMessages
