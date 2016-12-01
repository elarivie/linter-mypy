{CompositeDisposable} = require 'atom'
helpers = require 'atom-linter'

module.exports =
  config:
    executablePath:
      title: 'Executable Path'
      type: 'string'
      default: 'pydocstyle'
      description: "Path to executable pydocstyle cmd."
      order: 1
    addSelectCodes:
      type: 'string'
      default: ''
      description: ('Comma separated list of error codes to amend. ' +
        'Available codes: http://www.pydocstyle.org/en/latest/error_codes.html')
      order: 2
    ignoreCodes:
      type: 'string'
      default: ''
      description: ('Comma separated list of error codes to ignore. ' +
        'Available codes: http://www.pydocstyle.org/en/latest/error_codes.html')
      order: 3
    ignoreFiles:
      type: 'string'
      default: ''
      description: 'Filename pattern to ignore, e.g.: test_; Restart Atom to activate/deactivate.'
      order: 4

  activate: ->
    require('atom-package-deps').install('linter-pydocstyle')
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.config.observe 'linter-pydocstyle.executablePath',
      (executablePath) =>
        @executablePath = executablePath
    @subscriptions.add atom.config.observe 'linter-pydocstyle.addSelectCodes',
      (addSelectCodes) =>
        @addSelectCodes = addSelectCodes
    @subscriptions.add atom.config.observe 'linter-pydocstyle.ignoreCodes',
      (ignoreCodes) =>
        @ignoreCodes = ignoreCodes
    @subscriptions.add atom.config.observe 'linter-pydocstyle.ignoreFiles',
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
