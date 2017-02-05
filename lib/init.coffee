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

    #Listen for any settings changes to prevent having to restart Atom.

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
    # This is entry point for Lint requests.

    # Prepare the command line parameteres.
    params = []

    ## Use the python module mypy
    params.push("-m")
    params.push("mypy")

    ## We want column number so that we can know where to underline.
    params.push("--show-column-numbers")

    ## We only want to report warnings about the requested file and not about its dependencies
    ## Note: This silencing of the warnings external to the current file is not perfect, it will still report warnings about *.pyi files which will need to be filtered later.
    params.push("--follow-imports")
    params.push("silent")

    # Add the parameters base on user selected settings.
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

    # Provide the file to lint.
    params.push(filePath)

    # Make sure to run the command relative to the file being linted folder.
    # This has the advantage that:
    # * The warnings output format won't be poluted by long paths which would have to be filtered anyway.
    # * It allows mypy to find dependencies (import) of the file being linted.
    rootPath = path.dirname(filePath)
    options = { stream: 'stdout', ignoreExitCode: true, cwd: rootPath }

    # We call the mypy process and parse its output.
    return helpers.exec(@executablePath, params, options).then ((file) ->
      # The "file" variable contains the raw mypy output.

      # The goal of this method is to return a string where each line is a valid warning in the format: "FILEPATH:LINENO:COLNO:MESSAGE"
      result = ""

      # Each line of the mypy output may be a potential warning so we create an array of string containing each line of the output.
      # We split the text using the new line as a separator and handle any OS kind of new lines.
      lines = file.split(/\r\n|\r|\n/g)

      # For each line (aka warnings) we filter out those which are not wanted.
      for key, val of lines
        if 0 != val.indexOf(path.basename(filePath) + ":")
          #Ignore, we only want warnings within the file being linted.
          ## This filters out warning about *.pyi files
          ## This would also filter out warnings of imported file but they were already filtered out since the mypy process was called with the parameter "--follow-imports silent"
        else
          # No filter rejected the warning so we append it to the final list of warnings to reports.
          # We also make sure to provide the full path to the file by prepending the root path so that Atom can find the file.
          # Note: We use "path.join" even though "val" does not contain only the file name, but it creates the correct output nevertheless
          result = result + path.join(rootPath, val) + os.EOL
      return result
    ), (err) =>
      # Well, Well, Well... something went wrong.
      # Instead of crashing or giving cryptic error message, let's try to be user friendly.

      if err.message.match /^spawn\s.+\sENOENT$/gi
        ###
        The Problem: The error is about a process spawn which failed

        The Context: At this point the only process we launched was Python using the provided path in the setting @executablePath

        The Conclusion: The provided executable path is therefore probably incorrect

        The Solution: Let's:
          1- Inform the user about the situation with a pop-up.
          2- Offer him a link to change the setting.
        ###
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
        ###
        The Problem: The error is about an incorrect usage of mypy parameters.

        The Context: At this point a call to mypy was effectively done, there are two options
          1- The mypy command line interface has change and the project should be updated accordingly
            - But We have a spec to detect mypy command line interface change, so this option is probably not what is the real cause of the problem, anyway the user would not have much possibility to recover anyway.
          2- The executablePath provided in the settings is not pointing to python but directly to the mypy executable as it was required prior to mypy-linter v2.0.0

        The Conclusion: It is most likely the executablePath which is pointing to mypy instead of Python.

        The Solution: Let's:
          1- Inform the user about the situation with a pop-up
          2- Offer him a link to change the setting.

          *- Another solution would have been to relaunch the command adapted to a direct call to mypy, but on the long run this would create a support nightmare, this would also mean that for those users two process spawn would be required at every lint, therefore this solution was not implemented.
        ###
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
        ###
        The Problem: The error is about the absence of the mypy module in the python installation.

        The Context: Mypy has to be installed manually and it is base on the error message not installed in the python installation provided in the executable path setting.

        The Conclusion: It is most likely the user which haven't installed the module, but it is also possible that the user has more than one python installation on his system and didn't provide the good one in the settings.

        The Solution: Let's:
          1- Inform the user about the situation with a pop-up
          2- Show him an example of command line to install mypy
            * Using to executablePath provided in the settings to build the example will highlight to the user which python installation is being used for users which may have more than one on their system.
        ###
        atom.notifications.addWarning("The python package <strong>mypy</strong> does not seem to be installed.  Install it with <br /><em>" + @executablePath + " -m pip install mypy</em>")
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
      return ""

  parseMessages: (output) ->
    # Parse the pre-processed mypy warnings output and isolate:
    # - file = The file path to the file being linted.
    # - line = The line number where the warning is.
    # - col = The column where the warning is within the line.
    # - message = The warning text.
    messages = helpers.parse(output,
                             "^(?<file>[^:]+)[:](?<line>\\d+):(?:(?<col>\\d+):)? error: (?<message>.+)",
                             {flags: 'gm'})

    # Prepare an array of all the warnings to report.
    result = []
    messages.forEach (msg) ->
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
        warnEndCol += rawMatch[1].length
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
      lintOnFly: true
      lint: (textEditor) =>
        if (@ignoreFiles == '' || !textEditor.getPath().match(@ignoreFiles))
          # The file is not to be ignored, let's lint it and returns the mypy warnings...
          return @lintPath textEditor.getPath()
            .then @parseMessages
        else
          # The file is to be ignored, we therefore return an empty set of warning.
          return []
