{CompositeDisposable} = require 'atom'
helpers = require 'atom-linter'
os = require 'os'
path = require 'path'
NamedRegexp = require('named-js-regexp')

module.exports =
  config:
    executablePath:
      title: 'Executable Path'
      type: 'string'
      default: 'python3'
      description: "Path to the executable of python."
      order: 1
    ignoreFiles:
      type: 'string'
      default: ''
      description: 'Regex pattern of filenames to ignore, e.g.: "test.+"'
      order: 2
    fastParser:
      type: 'boolean'
      default: true
      description: 'enable experimental fast parser, this options requires the presence of the typed_ast package.'
      order: 3
    disallowUntypedCalls:
      type: 'boolean'
      default: true
      description: 'disallow calling functions without type annotations from functions with type annotations'
      order: 4
    disallowUntypedDefs:
      type: 'boolean'
      default: true
      description: 'disallow defining functions without type annotations or with incomplete type annotations'
      order: 5
    checkUntypedDefs:
      type: 'boolean'
      default: true
      description: 'type check the interior of functions without type annotations'
      order: 6
    disallowSubclassingAny:
      type: 'boolean'
      default: true
      description: 'disallow subclassing values of type "Any" when defining classes'
      order: 7
    warnIncompleteStub:
      type: 'boolean'
      default: true
      description: 'warn if missing type annotation in typeshed, only relevant with --check-untyped-defs enabled'
      order: 8
    warnRedundantCasts:
      type: 'boolean'
      default: true
      description: 'warn about casting an expression to its inferred type'
      order: 9
    warnNoReturn:
      type: 'boolean'
      default: true
      description: 'warn about functions that end without returning'
      order: 10
    warnUnusedIgnores:
      type: 'boolean'
      default: true
      description: "warn about unneeded '# type: ignore' comments"
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
    params.push("-m")
    params.push("mypy")
    params.push("--show-column-numbers")

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
      result = ""
      for key, val of lines
        if 0 == val.indexOf("/")

          #The following line works fine but is commented because it would create issues to file outside of the opened workspace.
          #Being commented also prevent hundreds of issues related to incomplete *.pyi files part of mypy installation.

          #result = result + val + os.EOL

        else
          result = result + path.join(rootPath, val) + os.EOL
      return result
    ), (err) =>
      if err.message.match /^spawn\s.+\sENOENT$/gi
        notification = atom.notifications.addWarning(
          "The executable of <strong>" + @executablePath + "</strong> was not found.<br />Either install <a href='https://www.python.org/downloads/'>python</a> or adjust the executable path setting of linter-mypy.",
          {
            buttons: [
              {
                text: "Adjust the linter-mypy setting",
                onDidClick: ->
                  atom.workspace.open("atom://config/packages/linter-mypy")
                  notification.dismiss()
              }
            ],
            dismissable: true,
          }
        )
      else if (0 <= err.message.indexOf("usage: mypy"))
        notification = atom.notifications.addWarning(
          "The executable of <strong>" + @executablePath + "</strong> seems to point to mypy instead of python, please adjust the executable path setting of linter-mypy.",
          {
            buttons: [
              {
                text: "Adjust the linter-mypy setting",
                onDidClick: ->
                  atom.workspace.open("atom://config/packages/linter-mypy")
                  notification.dismiss()
              }
            ],
            dismissable: true,
          }
        )
      else if (0 <= err.message.indexOf("No module named mypy"))
        atom.notifications.addWarning("The python package <strong>mypy</strong> does not seem to be installed.  Install it with <br /><em>" + @executablePath + " -m pip install mypy</em>")
      else if (0 <= err.message.indexOf("must install the typed_ast package before you can run mypy with"))
        notification = atom.notifications.addWarning(
          err.message,
          {
            buttons: [
              {
                text: "Change the linter-mypy setting to not use 'Fast Parser'",
                onDidClick: ->
                  atom.config.set('linter-mypy.fastParser', false)
                  notification.dismiss()
              }
            ],
            dismissable: true,
          }
        )
      else
        atom.notifications.addError(err.message)
      return ""

  parseMessages: (output) ->
    # parse lint output
    messages = helpers.parse(output,
                             "^(?<file>[^:]+)[:](?<line>\\d+):(?:(?<col>\\d+):)? error: (?<message>.+)",
                             {flags: 'gm'})
    result = []
    messages.forEach (msg) ->
      #HACK: Work around since mypy only provide the start column of the error, we have to use heuristics for the end column of the warning, without this workaround the warning would not be underline.
      warnOrigStartLine = msg.range[0][0]
      warnOrigStartCol = msg.range[0][1]
      warnOrigEndLine = msg.range[1][0]
      warnOrigEndCol = msg.range[1][1]

      warnStartLine = warnOrigStartLine
      warnStartCol = warnOrigStartCol
      warnEndLine = warnOrigEndLine
      warnEndCol = warnOrigEndCol

      if 0 < warnOrigStartCol
        #Rational: The underline is off by one character
        warnStartCol += 1
        warnEndCol += 1
        if warnOrigStartCol == warnOrigEndCol
          #Rational: Since mypy points to something it must at least be one character long.
          warnEndCol += 1

      #Rational: Since we know the method name we can underline its length
      compiledRegexp = new NamedRegexp("^Argument . to .(?<name>.+). has incompatible type ..+.; expected ..+.$", "g")
      rawMatch = compiledRegexp.exec(msg.text)
      if rawMatch
        warnEndCol += rawMatch[1].length
        if 0 < warnOrigStartCol
          warnEndCol -= 1

      #TODO: Put more heuristic

      msg.range = [[warnStartLine, warnStartCol], [warnEndLine, warnEndCol]]
      msg.type = "Warning"

      result.push(msg)
    return result

  provideLinter: ->
    provider =
      name: 'linter-mypy'
      grammarScopes: ['source.python']
      scope: 'file'
      lintOnFly: true
      lint: (textEditor) =>
        if (@ignoreFiles == '' || !textEditor.getPath().match(@ignoreFiles))
          return @lintPath textEditor.getPath()
            .then @parseMessages
        else
          return []
