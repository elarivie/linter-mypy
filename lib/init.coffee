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
      description: 'Regex pattern of filenames to ignore, e.g.: "test.+"'
      order: 2
    disallowUntypedCalls:
      type: 'boolean'
      default: false
      description: 'disallow calling functions without type annotations from functions with type annotations'
      order: 3
    disallowUntypedDefs:
      type: 'boolean'
      default: false
      description: 'disallow defining functions without type annotations or with incomplete type annotations'
      order: 4
    checkUntypedDefs:
      type: 'boolean'
      default: false
      description: 'type check the interior of functions without type annotations'
      order: 5
    disallowSubclassingAny:
      type: 'boolean'
      default: false
      description: 'disallow subclassing values of type "Any" when defining classes'
      order: 6
    warnIncompleteStub:
      type: 'boolean'
      default: false
      description: 'warn if missing type annotation in typeshed, only relevant with --check-untyped-defs enabled'
      order: 7
    warnRedundantCasts:
      type: 'boolean'
      default: false
      description: 'warn about casting an expression to its inferred type'
      order: 8
    warnNoReturn:
      type: 'boolean'
      default: false
      description: 'warn about functions that end without returning'
      order: 9
    warnUnusedIgnores:
      type: 'boolean'
      default: false
      description: "warn about unneeded '# type: ignore' comments"
      order: 10
    fastParser:
      type: 'boolean'
      default: false
      description: 'enable experimental fast parser, this options requires the presence of the typed_ast package.'
      order: 11

  activate: ->
    require('atom-package-deps').install('linter-mypy')
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.config.observe 'linter-mypy.executablePath',
      (executablePath) =>
        @executablePath = executablePath
    @subscriptions.add atom.config.observe 'linter-mypy.ignoreFiles',
      (ignoreFiles) =>
        @ignoreFiles = ignoreFiles
    @subscriptions.add atom.config.observe 'linter-mypy.disallowUntypedCalls',
      (disallowUntypedCalls) =>
        @disallowUntypedCalls = disallowUntypedCalls
    @subscriptions.add atom.config.observe 'linter-mypy.disallowUntypedDefs',
      (disallowUntypedDefs) =>
        @disallowUntypedDefs = disallowUntypedDefs
    @subscriptions.add atom.config.observe 'linter-mypy.checkUntypedDefs',
      (checkUntypedDefs) =>
        @checkUntypedDefs = checkUntypedDefs
    @subscriptions.add atom.config.observe 'linter-mypy.disallowSubclassingAny',
      (disallowSubclassingAny) =>
        @disallowSubclassingAny = disallowSubclassingAny
    @subscriptions.add atom.config.observe 'linter-mypy.warnIncompleteStub',
      (warnIncompleteStub) =>
        @warnIncompleteStub = warnIncompleteStub
    @subscriptions.add atom.config.observe 'linter-mypy.warnRedundantCasts',
      (warnRedundantCasts) =>
        @warnRedundantCasts = warnRedundantCasts
    @subscriptions.add atom.config.observe 'linter-mypy.warnNoReturn',
      (warnNoReturn) =>
        @warnNoReturn = warnNoReturn
    @subscriptions.add atom.config.observe 'linter-mypy.warnUnusedIgnores',
      (warnUnusedIgnores) =>
        @warnUnusedIgnores = warnUnusedIgnores
    @subscriptions.add atom.config.observe 'linter-mypy.fastParser',
      (fastParser) =>
        @fastParser = fastParser

  deactivate: ->
    @subscriptions.dispose()

  lintPath: (filePath)->
    params = []
    params.push("--show-column-numbers")
    params.push("--hide-error-context")

    if (@disallowUntypedCalls)
      params.push("--disallow-untyped-calls")
    if (@disallowUntypedDefs)
      params.push("--disallow-untyped-defs")
    if (@checkUntypedDefs)
      params.push("--check-untyped-defs")
    if (@disallowSubclassingAny)
      params.push("--disallow-subclassing-any")
    if (@warnIncompleteStub)
      params.push("--warn-incomplete-stub")
    if (@warnRedundantCasts)
      params.push("--warn-redundant-casts")
    if (@warnNoReturn)
      params.push("--warn-no-return")
    if (@warnUnusedIgnores)
      params.push("--warn-unused-ignores")
    if (@fastParser)
      params.push("--fast-parser")
    params.push(filePath)
    rootPath = path.dirname(filePath)
    options = { stream: 'stdout', ignoreExitCode: true, cwd: rootPath }
    return helpers.exec(@executablePath, params, options).then ((file) ->
      lines = file.split(/\r\n|\r|\n/g)
      for key, val of lines
        result = result + path.join(rootPath, val) + os.EOL
      return result
    ), (err) ->
      if err.message.match /^spawn\s.+\sENOENT$/gi
        atom.notifications.addWarning("The executable of <strong>mypy</strong> was not found.<br />Either install <a href='http://mypy.readthedocs.io/en/latest/getting_started.html#installation'>mypy</a> or adjust the executable path setting of linter.mypy.")
      else if (0 <= err.message.indexOf("must install the typed_ast package before you can run mypy with"))
        atom.notifications.addWarning(err.message)
      else
        atom.notifications.addError(err.message)
      return ""

  parseMessages: (output) ->
    # parse lint output
    messages = helpers.parse(output,
                             "^(?<file>[^:]+)[:](?<line>\\d+):(?:(?<col>\\d+):)? error: (?<message>.+)",
                             {flags: 'gm'})
    messages.forEach (msg) ->
      msg.type = "Warning"
    return messages

  provideLinter: ->
    provider =
      name: 'linter-mypy'
      grammarScopes: ['source.python']
      scope: 'file'
      lintOnFly: false
      lint: (textEditor) =>
        if (@ignoreFiles == '' || !textEditor.getPath().match(@ignoreFiles))
          return @lintPath textEditor.getPath()
            .then @parseMessages
        else
          return []
