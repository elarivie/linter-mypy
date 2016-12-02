{CompositeDisposable} = require 'atom'
helpers = require 'atom-linter'
os = require 'os'
path = require 'path'

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
    params = []
    params.push("--show-column-numbers")
    params.push("--hide-error-context")
    params.push(filePath)
    rootPath = path.dirname(filePath)
    options = { stream: 'stdout', ignoreExitCode: true, cwd: rootPath }
    return helpers.exec(@executablePath, params, options).then ((file) ->
      lines = file.split(/\r\n|\r|\n/g);
      for key, val of lines
        result = result + path.join(rootPath, val) + os.EOL
      return result
    ), (err) ->
      alert("err")

  parseMessages: (output) ->
    # parse lint output
    messages = helpers.parse(output,
                             "^(?<file>[^:]+)[:](?<line>\\d+):(?:(?<col>\\d+):)? error: (?<message>.+)",
                             {flags: 'gm'})
    messages.forEach (msg) ->
      msg.type = "Info"
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
