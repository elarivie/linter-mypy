# This file contains all the logic of the linter-mypy.

# Import every required libraries.

{CompositeDisposable} = require 'atom'
helpers = require 'atom-linter'
os = require 'os'
path = require 'path'
NamedRegexp = require('named-js-regexp')

# Define every available settings.
## Those settings are also documented in the README file.

module.exports =
  config:
    executablePath:
      title: 'Executable Path'
      type: 'string'
      default: 'python3'
      description: '''Path to the executable of python.
      The optionals `$PROJECT_PATH` and `$PROJECT_NAME` variables can be used to resolve the path
      dynamically depending of the current project. For example:
      `/home/user/.virtualenvs/$PROJECT_NAME/bin/python`.
      '''
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
    warnReturnAny:
      type: 'boolean'
      default: true
      description: 'warn about returning values of type Any from non-Any typed functions'
      order: 11
    warnUnusedIgnores:
      type: 'boolean'
      default: true
      description: "warn about unneeded '# type: ignore' comments"
      order: 12
    warnMissingImports:
      type: 'boolean'
      default: true
      description: "warn about imports of missing modules"
      order: 13
    strictBoolean:
      type: 'boolean'
      default: true
      description: "enable strict boolean checks in conditions"
      order: 14
    strictOptional:
      type: 'boolean'
      default: true
      description: "enable experimental strict Optional checks"
      order: 15

  activate: ->
    require('atom-package-deps').install('linter-mypy')

    #Listen and reload any settings changes to prevent having to restart Atom.

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
    @subscriptions.add atom.config.observe 'linter-mypy.warnReturnAny',
      (warnReturnAny) =>
        @warnReturnAny = warnReturnAny
    @subscriptions.add atom.config.observe 'linter-mypy.warnUnusedIgnores',
      (warnUnusedIgnores) =>
        @warnUnusedIgnores = warnUnusedIgnores
    @subscriptions.add atom.config.observe 'linter-mypy.fastParser',
      (fastParser) =>
        @fastParser = fastParser
    @subscriptions.add atom.config.observe 'linter-mypy.warnMissingImports',
      (warnMissingImports) =>
        @warnMissingImports = warnMissingImports
    @subscriptions.add atom.config.observe 'linter-mypy.strictBoolean',
      (strictBoolean) =>
        @strictBoolean = strictBoolean
    @subscriptions.add atom.config.observe 'linter-mypy.strictOptional',
      (strictOptional) =>
        @strictOptional = strictOptional

  deactivate: ->
    @subscriptions.dispose()

  lintPath: (filePath)->
    # This is the entry point for Lint requests for a given file.

    rootPath = path.dirname(filePath)
    baseNamePath = path.basename(filePath)

    # Prepare the command line parameteres.
    params = []

    ## Use the python module mypy
    params.push("-m")
    params.push("mypy")
    params.push("--hide-error-context")

    ## We want column number so that we can know where to underline.
    ## Note: It was found that the reported column numbers are affected by the setting --fast-parser.
    params.push("--show-column-numbers")

    ## We only want to report warnings about the requested file and not about its dependencies
    ## Note: This silencing of the warnings external to the current file is not perfect, it will still report warnings about *.pyi files which will need to be filtered later.
    params.push("--follow-imports")
    params.push("silent")

    # Add the parameters base on user selected settings.
    if (@disallowUntypedCalls)
      params.push("--disallow-untyped-calls")
    else
      params.push("--allow-untyped-calls")

    if (@disallowUntypedDefs)
      params.push("--disallow-untyped-defs")
    else
      params.push("--allow-untyped-defs")

    if (@checkUntypedDefs)
      params.push("--check-untyped-defs")
    else
      params.push("--no-check-untyped-defs")

    if (@disallowSubclassingAny)
      params.push("--disallow-subclassing-any")
    else
      params.push("--allow-subclassing-any")

    if (@warnIncompleteStub)
      params.push("--warn-incomplete-stub")
    else
      params.push("--no-warn-incomplete-stub")

    if (@warnRedundantCasts)
      params.push("--warn-redundant-casts")
    else
      params.push("--no-warn-redundant-casts")

    if (@warnNoReturn)
      params.push("--warn-no-return")
    else
      params.push("--no-warn-no-return")

    if (@warnReturnAny)
      params.push("--warn-return-any")
    else
      params.push("--no-warn-return-any")

    if (@warnUnusedIgnores)
      params.push("--warn-unused-ignores")
    else
      params.push("--no-warn-unused-ignores")

    if (!@warnMissingImports)#Note: the boolean flag value is inversed since the parameter meaning is inversed.
      params.push("--ignore-missing-imports")

    if (@fastParser)
      params.push("--fast-parser")
    else
      params.push("--no-fast-parser")

    if (@strictBoolean)
      params.push("--strict-boolean")
    else
      params.push("--no-strict-boolean")

    if (@strictOptional)
      params.push("--strict-optional")
    else
      params.push("--no-strict-optional")

    # Provide the filename to lint.
    params.push(baseNamePath)

    # Run the command from the folder of the file being linted folder.
    # This has the advantage that:
    # * It allows mypy to find dependencies (import) of the file being linted.
    # This should also make the warnings to be reported using relative path to the file but for an unknown reason this is not always the case.
    options = { stream: 'stdout', ignoreExitCode: true, cwd: rootPath }

    # Load the fast parser flag in a local variable so that the next scope can access it.
    fastParser = @fastParser
    executablePath = @resolvePath @executablePath, filePath
    # We call the mypy process and parse its output.
    ## For debug: ## alert(executablePath + " " + params.join(" "))
    return helpers.exec(executablePath, params, options).then ((file) ->
      # The "file" variable contains the raw mypy output.
      # The goal of this method is to return a string where each line is a valid warning in the format: "FILEPATH:LINENO:COLNO:MESSAGE"
      result = ""

      # Each line of the mypy output may be a potential warning so we create an array of string containing each line of the output.
      # We split the text using the new line as a separator and handle any OS kind of new lines.
      lines = file.split(/\r\n|\r|\n/g)

      # For each line (aka warnings) we filter out those which are not wanted else we append it to the final list of warnings to reports.
      # Note: The final report must contain the full path to the file so that Atom can find the file.
      for key, val of lines
        if 0 == val.indexOf(filePath + ":")
          # Warning was reported using an absolute path to the file.
          result = result + val + os.EOL
        else if 0 == val.indexOf(baseNamePath + ":")
          # Warning was reported using a relative path to the file.
          # Note: We use "path.join" even though "val" does not contain only the file name, but it creates the correct output nevertheless
          result = result + path.join(rootPath, val) + os.EOL
        else
          #Ignore, we only want warnings within the file being linted.
          ## This filters out warnings about *.pyi files
          ## This would also filter out warnings of imported file but they were already filtered out since the mypy process was called with the parameter "--follow-imports silent"

      # Return fast parser flag and the result.
      return [fastParser, result]

    ), (err) ->
      # Well, Well, Well... something went wrong.
      # Instead of crashing or giving cryptic error message, let's try to be user friendly.
      if err.message.match /^Failed\sto\sspawn\scommand\s.+\.\sMake\ssure\s.+\sis\sinstalled\sand\son\syour\sPATH$/gi
        ###
        The Problem: The error is about a process spawn which failed

        The Context: At this point the only process we launched was Python using the provided path in the setting @executablePath

        The Conclusion: The provided executable path is therefore probably incorrect

        The Solution: Let's:
          1- Inform the user about the situation with a pop-up.
          2- Offer him a link to change the setting.
        ###
        notification = atom.notifications.addWarning(
          "The executable of <strong>" + executablePath + "</strong> was not found.<br />Either install <a href='https://www.python.org/downloads/'>python</a> or adjust the executable path setting of linter-mypy.",
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
        ###
        The Problem: The error is about an incorrect usage of mypy parameters.

        The Context: At this point a call to mypy was effectively done, there are three options
          1- The mypy command line interface has change and the project should be updated accordingly
            - But We have a spec to detect mypy command line interface change, so this option is probably not what is the real cause of the problem, anyway the user would not have much possibility to recover anyway.
          2- The executablePath provided in the settings is not pointing to python but directly to the mypy executable as it was required prior to mypy-linter v2.0.0
          3- The version of mypy is older than the one linter-mypy expect.

        The Conclusion: It may be the executablePath which is pointing to mypy instead of Python but it is most likely an outdated mypy installation.

        The Solution: Let's:
          1- Inform the user about the situation with a pop-up.
          2- Display the command line to update mypy.
          3- Offer him a link to change the setting.
        ###
        notification = atom.notifications.addWarning(
          "MyPy does not understand the provided parameters.  Make sure the latest mypy version is installed using the following command line:<br/><br/><em>" + executablePath + " -m pip install -U mypy</em>",
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
        ###
        The Problem: The error is about the absence of the mypy module in the python installation.

        The Context: Mypy has to be installed manually and it is base on the error message not installed in the python installation provided in the executable path setting.

        The Conclusion: It is most likely the user which haven't installed the module, but it is also possible that the user has more than one python installation on his system and didn't provide the good one in the settings.

        The Solution: Let's:
          1- Inform the user about the situation with a pop-up
          2- Show him an example of command line to install mypy
            * Using the resolved executablePath to build the example will highlight to the user which python installation is being used for users which may have more than one on their system.
        ###
        atom.notifications.addWarning("The python package <strong>mypy</strong> does not seem to be installed.  Install it with:<br /><br /><em>" + executablePath + " -m pip install mypy</em>")
      else if (0 <= err.message.indexOf("must install the typed_ast package before you can run mypy with"))
        ###
        The Problem: The error is about the absence of the typed_ast module in the python installation.

        The Context: typed_ast is an optional module which need to be manually installed and is only needed for the settings fast-parser.

        The Conclusion: It is most likely the user which haven't installed the module, but it is also possible that the user has more than one python installation on his system and didn't provide the good one in the settings.

        The Solution: Since it is an optional requirement let's not bother too much the user.
          1- Inform the user about the situation with a pop-up
          2- Offer him to disable the setting which needs this dependencies.
        ###
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
        ###
        The Problem: Something unknown went wrong.

        The Context: Many known possible error were managed in a user friendly manner, but this error is not.

        The Conclusion: Not much can be done.

        The Solution: Since it is an unknown error let't keep the error message intact
          1- Inform the user about the situation with an error pop-up containing the full error message, hopefully he will provide a bug report with this information so that it can be better handle.
        ###
        atom.notifications.addError(err.message)

      #Something went wrong there is therefore no mypy warnings to report.
      return [fastParser, ""]

  parseMessages: (output) ->
    # Parse the pre-processed mypy warnings output and isolate:
    # - file = The file path to the file being linted.
    # - line = The line number where the warning is.
    # - col = The column where the warning is within the line.
    # - message = The warning text.
    messages = helpers.parse(output[1],
                             "^(?<file>([A-Z]:)?[^:]+)[:](?<line>\\d+):(?:(?<col>\\d+):)? error: (?<message>.+)",
                             {flags: 'gm'})

    # Prepare an array of all the warnings to report.
    result = []
    messages.forEach (msg) ->
      @fastParser = output[0]
      # At this point every messages will be reported, we won't filter them
      # But we will improve them a little to make them more helpful.

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
        if (@fastParser)
          warnEndCol += rawMatch[1].length
        else
          warnStartCol -= rawMatch[1].length
        if 0 < warnOrigStartCol
          warnEndCol -= 1

      #TODO: Put more heuristic

      msg.range = [[warnStartLine, warnStartCol], [warnEndLine, warnEndCol]]

      # The messages will be displayed as "Warning" to the user.
      msg.type = "Warning"

      #Append the current warning to the final result.
      result.push(msg)

    #The job is over, let's return the result so it can be displayed to the user.
    return result

  provideLinter: ->
    provider =
      name: 'linter-mypy'
      grammarScopes: ['source.python']
      scope: 'file'
      lintOnFly: false
      lint: (textEditor) =>
        if (@ignoreFiles == '' || !textEditor.getPath().match(@ignoreFiles))
          # The file is not to be ignored, let's lint it and returns the mypy warnings...
          return @lintPath textEditor.getPath()
            .then @parseMessages
        else
          # The file is to be ignored, we therefore return an empty set of warning.
          return []

  resolvePath: (targetPath, filepath) ->
    resolvedPath = targetPath

    if not filepath
      return resolvedPath

    [projectPath, ...] = atom.project.relativizePath(filepath)
    if not projectPath
      return resolvedPath
    projectName = path.parse(projectPath).name
    resolvedPath = resolvedPath.replace(/\$PROJECT_NAME/g, projectName)
    resolvedPath = resolvedPath.replace(/\$PROJECT_PATH/g, projectPath)
    return resolvedPath
