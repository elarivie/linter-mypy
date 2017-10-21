# This file contains all the logic of the linter-mypy.

# Import every required libraries.

{CompositeDisposable} = require 'atom'
helpers = require 'atom-linter'
fs = require 'fs'
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
    mypyIniFile:
      type: 'string'
      default: ''
      description: '''Path to a <a href="http://mypy.readthedocs.io/en/latest/config_file.html">mypy.ini</a> file.
      The optionals `$PROJECT_PATH` and `$PROJECT_NAME` variables can be used to resolve the path
      dynamically depending of the current project. For example:
      `$PROJECT_PATH/mypy.ini`. <strong>If a mypy.ini file is being found at the given path then all the below settings will be ignore.</strong>
      '''
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
    disallowIncompleteDefs:
      type: 'boolean'
      default: true
      description: 'disallow defining functions with incomplete type annotations'
      order: 6
    checkUntypedDefs:
      type: 'boolean'
      default: true
      description: 'type check the interior of functions without type annotations'
      order: 7
    warnIncompleteStub:
      type: 'boolean'
      default: true
      description: 'warn if missing type annotation in typeshed, only relevant with --check-untyped-defs enabled'
      order: 8
    disallowUntypedDecorators:
      type: 'boolean'
      default: true
      description: 'disallow decorating typed functions with untyped decorators'
      order: 9
    warnRedundantCasts:
      type: 'boolean'
      default: true
      description: 'warn about casting an expression to its inferred type'
      order: 10
    warnNoReturn:
      type: 'boolean'
      default: true
      description: 'warn about functions that end without returning'
      order: 11
    warnReturnAny:
      type: 'boolean'
      default: true
      description: 'warn about returning values of type Any from non-Any typed functions'
      order: 12
    disallowSubclassingAny:
      type: 'boolean'
      default: true
      description: 'disallow subclassing values of type "Any" when defining classes'
      order: 13
    disallowAnyUnimported:
      type: 'boolean'
      default: true
      description: 'disallows usage of types that come from unfollowed imports'
      order: 14
    disallowAnyExpr:
      type: 'boolean'
      default: true
      description: 'disallows all expressions in the module that have type Any'
      order: 15
    disallowAnyUnannotated:
      type: 'boolean'
      default: true
      description: 'disallows function definitions that are not fully typed'
      order: 16
    disallowAnyDecorated:
      type: 'boolean'
      default: true
      description: 'disallows functions that have Any in their signature after decorator transformation'
      order: 17
    disallowAnyExplicit:
      type: 'boolean'
      default: true
      description: 'disallows explicit Any in type positions'
      order: 18
    disallowAnyGenerics:
      type: 'boolean'
      default: true
      description: 'disallows usage of generic types that do not specify explicit type parameters'
      order: 19
    warnUnusedIgnores:
      type: 'boolean'
      default: true
      description: "warn about unneeded '# type: ignore' comments"
      order: 20
    warnUnusedConfigs:
      type: 'boolean'
      default: true
      description: "warn about unnused '[mypy-<pattern>]' config sections"
      order: 21
    warnMissingImports:
      type: 'boolean'
      default: true
      description: "warn about imports of missing modules"
      order: 22
    strictOptional:
      type: 'boolean'
      default: true
      description: "enable experimental strict Optional checks"
      order: 23
    noImplicitOptional:
      type: 'boolean'
      default: true
      description: "don't assume arguments with default values of None are Optional"
      order: 24
    followImports:
      type: 'string'
      default: 'silent'
      enum: [
        {value: 'normal', description: 'Normal. Follow imports normally and type check all top level code'}
        {value: 'silent', description: 'Silent. Follow imports normally, but suppress any error messages.'}
        {value: 'skip', description: 'Skip. Don’t follow imports.'}
        {value: 'error', description: 'Error. The same behavior as skip but not quite as silent.'}
      ]
      description: "how to treat imports"
      order: 25
    mypyPath:
      type: 'string'
      default: ''
      description: '''<a href="http://mypy.readthedocs.io/en/latest/command_line.html#how-imports-are-found">MYPYPATH</a> to use, is a colon-separated list of directories
      <br /><strong>Note:</strong> Use a dot to add the directory containing the file being linted
      '''
      order: 26

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
    @subscriptions.add atom.config.observe 'linter-mypy.mypyIniFile',
      (mypyIniFile) =>
        @mypyIniFile = mypyIniFile
    @subscriptions.add atom.config.observe 'linter-mypy.disallowUntypedCalls',
      (disallowUntypedCalls) =>
        @disallowUntypedCalls = disallowUntypedCalls
    @subscriptions.add atom.config.observe 'linter-mypy.disallowUntypedDefs',
      (disallowUntypedDefs) =>
        @disallowUntypedDefs = disallowUntypedDefs
    @subscriptions.add atom.config.observe 'linter-mypy.checkUntypedDefs',
      (checkUntypedDefs) =>
        @checkUntypedDefs = checkUntypedDefs
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
    @subscriptions.add atom.config.observe 'linter-mypy.disallowSubclassingAny',
      (disallowSubclassingAny) =>
        @disallowSubclassingAny = disallowSubclassingAny
    @subscriptions.add atom.config.observe 'linter-mypy.disallowAnyUnimported',
      (disallowAnyUnimported) =>
        @disallowAnyUnimported = disallowAnyUnimported
    @subscriptions.add atom.config.observe 'linter-mypy.disallowAnyExpr',
      (disallowAnyExpr) =>
        @disallowAnyExpr = disallowAnyExpr
    @subscriptions.add atom.config.observe 'linter-mypy.disallowAnyUnannotated',
      (disallowAnyUnannotated) =>
        @disallowAnyUnannotated = disallowAnyUnannotated
    @subscriptions.add atom.config.observe 'linter-mypy.disallowAnyDecorated',
      (disallowAnyDecorated) =>
        @disallowAnyDecorated = disallowAnyDecorated
    @subscriptions.add atom.config.observe 'linter-mypy.disallowAnyExplicit',
      (disallowAnyExplicit) =>
        @disallowAnyExplicit = disallowAnyExplicit
    @subscriptions.add atom.config.observe 'linter-mypy.disallowAnyGenerics',
      (disallowAnyGenerics) =>
        @disallowAnyGenerics = disallowAnyGenerics
    @subscriptions.add atom.config.observe 'linter-mypy.warnUnusedIgnores',
      (warnUnusedIgnores) =>
        @warnUnusedIgnores = warnUnusedIgnores
    @subscriptions.add atom.config.observe 'linter-mypy.warnMissingImports',
      (warnMissingImports) =>
        @warnMissingImports = warnMissingImports
    @subscriptions.add atom.config.observe 'linter-mypy.strictOptional',
      (strictOptional) =>
        @strictOptional = strictOptional
    @subscriptions.add atom.config.observe 'linter-mypy.warnUnusedConfigs',
      (warnUnusedConfigs) =>
        @warnUnusedConfigs = warnUnusedConfigs
    @subscriptions.add atom.config.observe 'linter-mypy.disallowIncompleteDefs',
      (disallowIncompleteDefs) =>
        @disallowIncompleteDefs = disallowIncompleteDefs
    @subscriptions.add atom.config.observe 'linter-mypy.disallowUntypedDecorators',
      (disallowUntypedDecorators) =>
        @disallowUntypedDecorators = disallowUntypedDecorators
    @subscriptions.add atom.config.observe 'linter-mypy.followImports',
      (followImports) =>
        @followImports = followImports
    @subscriptions.add atom.config.observe 'linter-mypy.mypyPath',
      (mypyPath) =>
        @mypyPath = mypyPath

  deactivate: ->
    @subscriptions.dispose()

  lintPath: (filePath)->
    rootPath = path.dirname(filePath)
    # This is the entry point for Lint requests for a given file.

    # Prepare the command line parameters.
    params = []

    ## Use the python module mypy
    params.push("-m")
    params.push("mypy")
    params.push("--hide-error-context")

    ## We want column number so that we can know where to underline.
    params.push("--show-column-numbers")

    iniPath = @resolvePath(@mypyIniFile, filePath)

    if (fs.existsSync iniPath)
      # Use the provided mypy configuration file.
      params.push("--config-file")
      params.push(iniPath)
    else
      # Add the parameters base on user selected settings.
      params.push("--follow-imports")
      params.push(@followImports)

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

      if (@disallowSubclassingAny)
        params.push("--disallow-subclassing-any")
      else
        params.push("--allow-subclassing-any")

      c_disallowAnyArgs = []
      if (@disallowAnyUnimported)
        c_disallowAnyArgs.push("unimported")
      if (@disallowAnyExpr)
        c_disallowAnyArgs.push("expr")
      if (@disallowAnyUnannotated)
        c_disallowAnyArgs.push("unannotated")
      if (@disallowAnyDecorated)
        c_disallowAnyArgs.push("decorated")
      if (@disallowAnyExplicit)
        c_disallowAnyArgs.push("explicit")
      if (@disallowAnyGenerics)
        c_disallowAnyArgs.push("generics")
      if 0 < (c_disallowAnyArgs.length)
        params.push("--disallow-any")
        params.push(c_disallowAnyArgs.join())

      if (@warnUnusedIgnores)
        params.push("--warn-unused-ignores")
      else
        params.push("--no-warn-unused-ignores")

      if (!@warnMissingImports)#Note: the boolean flag value is inversed since the parameter meaning is inversed.
        params.push("--ignore-missing-imports")

      if (@strictOptional)
        params.push("--strict-optional")
      else
        params.push("--no-strict-optional")

      if (@noImplicitOptional)
        params.push("--no-implicit-optional")
      else
        params.push("--implicit-optional")

      if (@warnUnusedConfigs)
        params.push("--warn-unused-configs")
      else
        params.push("--no-warn-unused-configs")

      if (@disallowIncompleteDefs)
        params.push("--disallow-incomplete-defs")
      else
        params.push("--allow-incomplete-defs")

      if (@disallowUntypedDecorators)
        params.push("--disallow-untyped-decorators")
      else
        params.push("--allow-untyped-decorators")

    # Provide the filename to lint.
    params.push(filePath)

    # Extract the file system root.
    c_RootRoot = path.parse(filePath).root

    # Run the command giving the full file path and running from the file system root folder where the file being linted is located.
    # This has the advantage that:
    # * It allows mypy to find dependencies (import) of the file being linted.
    # * It always works fine, it is not affected by the mypy bug #2974 (should therefore never run with cwd set to the directory of the file being linted)
    options = { stream: 'stdout', ignoreExitCode: true, cwd: c_RootRoot, env: Object.create(process.env), timeout: Infinity }

    # Set the MYPYPATH as requested
    ##Initialize the environment variable MYPYPATH
    if !(options.env["MYPYPATH"])?
      options.env["MYPYPATH"] = ''
    ##Prepend user setting defined MYPYPATH to current system env MYPYPATH
    if @mypyPath?
      options.env["MYPYPATH"] = ':' + @mypyPath + ':' + options.env["MYPYPATH"] + ':'
    ##Add current folder of the file being linted to MYPYPATH
    options.env["MYPYPATH"] = options.env["MYPYPATH"].replace(/:\.:/g, ':' + rootPath + ':')
    ##Clean all repeated path separator
    options.env["MYPYPATH"] = options.env["MYPYPATH"].replace(/:+/g, ':')
    ##Strip not necessary separator
    options.env["MYPYPATH"] = options.env["MYPYPATH"].replace(/^:+|:+$/g, '')

    executablePath = @resolvePath @executablePath, filePath
    # We call the mypy process and parse its output.
    ## For debug: ## alert(executablePath + " " + params.join(" "))
    return helpers.exec(executablePath, params, options).then ((mypyOutput) ->
      # The goal of this method is to return an array of string where each string is a valid warning in the format: "FILEPATH:LINENO:COLNO:MESSAGE"
      result = []

      # Each line of the mypy output may be a potential warning so we create an array of string containing each line of the output.
      # We split the text using the new line as a separator and handle any OS kind of new lines.
      lines = mypyOutput.split(/\r\n|\r|\n/g)

      # For each line (aka warnings) we filter out those which are not wanted else we append it to the final list of warnings to reports.
      # Note: The final report must contain the full path to the file so that Atom can find the file.
      for key, val of lines
        result.push(c_RootRoot + val)

      # Return the result.
      return [result]

    ), (err) ->
      # Well, Well, Well... something went wrong.
      # Instead of crashing or giving cryptic error message, let's try to be user friendly.
      if err.message.match /^Failed\sto\sspawn\scommand\s.+\.\sMake\ssure\s.+\sis\sinstalled\sand\son\syour\sPATH$/gi || err.message.match /^The\ssystem\scannot\sfind\sthe\spath\sspecified\.$/gi
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
      else if err.message.match /^.+\:\sNo\s\[mypy\]\ssection\sin\sconfig\sfile$/gi
        ###
        The Problem: The error is about a mypy.ini file not in the good format.

        The Context: At this point everything is fine a valid mypy launch was done using a found mypy.ini file.

        The Conclusion: the user must only make sure to either not use mypy configuration file or have it in the good format.

        The Solution: Let's:
          1- Inform the user about the situation with a pop-up.
          2- Offer him a link to change the setting.
        ###
        notification = atom.notifications.addWarning(
          "The mypy configuration file <strong>" + iniPath + "</strong> does not contains a [mypy] section as it should.<br />Either correct the configuration file or adjust the mypy ini configuration path setting of linter-mypy.",
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
          2- The executablePath provided in the settings is not pointing to python but directly to the mypy executable as it was required prior to linter-mypy v2.0.0
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
      else if (0 <= err.message.indexOf("AssertionError: Neither id, path nor source given"))
        ###
        The Problem: When Mypy encouters a relative import from a toplevel, it crashes with an assert Stacktrace.

        The Context: Mypy has a recorded bug #2974.

        The Conclusion: We can't do much, other than not crashing ourself with annoying pop-ups.

        The Solution: Let's:
          1- Inform the user about the situation with a lint error
        ###
        return [[filePath + ":0:0: error: MypyBug2974"]]
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
      return [""]

  parseMessages: (output) ->
    # Parse the pre-processed mypy warnings output and isolate:
    # - file = The file path to the file being linted.
    # - line = The line number where the warning is.
    # - col = The column where the warning is within the line.
    # - message = The warning text.
    regexLine = new NamedRegexp("^(?<file>([A-Z]:)?[^:]+)[:](?<line>\\d+):(?:(?<col>\\d+):)? error: (?<message>.+)")
    regexHeuristic01 = new NamedRegexp("^Argument . to .(?<name>.+). has incompatible type ..+.; expected ..+.$")

    # Prepare an array of all the warnings to report.
    result = []
    for msg, idx in output[0]
      v_CurrMessageRaw = regexLine.execGroups(msg)
      if v_CurrMessageRaw
      else
        #Ignore this output line, it is not in the expected warning format.
        continue

      [projectPath, ...] = atom.project.relativizePath(v_CurrMessageRaw.file)
      if not projectPath
        #Ignore this warning since it is about a file which is not part of any currently opened projects.
        continue

      # At this point every messages will be reported, we won't filter them
      # But we will improve them a little to make them more helpful.

      #Prepare the warn characteristics.
      theSeverity = 'warning'
      theDescription = ""
      theMessage = v_CurrMessageRaw.message
      theUrl = ""
      theStartLine = parseInt(v_CurrMessageRaw.line, 10) - 1
      theStartCol = parseInt(v_CurrMessageRaw.col, 10)

      if theStartLine
        if theStartLine < 0
          theStartLine = 0
      else
        # Can this occur?
        theStartLine = 0

      if 0 == theStartCol
        theStartCol += 1
      else if theStartCol
        theStartCol += 1
      else
        # May occur if the start column is not provided by Mypy
        theStartCol = 0

      #HACK: Work around since mypy only provide the start column of the error, we have to use heuristics for the end column of the warning, without this workaround the warning would not be underline.
      theEndLine = theStartLine
      theEndCol = theStartCol

      if 0 < theStartCol
        #Rational: The underline is off by one character.
        theStartCol -= 1
        theEndCol -= 1

        #Rational: Since mypy points to something it must at least be one character long.
        theEndCol += 1

      #Rational: Since we know the method name we can underline its length.
      rawMatch = regexHeuristic01.execGroups(v_CurrMessageRaw.message)
      if rawMatch
        theEndCol += rawMatch.name.length - 1

      #Rational: Since we know the method name is "reveal_type", we can underline its length.
      if ("Revealed type is '" == theMessage.substr(0, 18))
        theEndCol += 10
        theSeverity = 'info'

      #Rational: Mypy Bug #2974
      if "MypyBug2974" == theMessage
        theSeverity = 'error'
        theMessage = "Top-level module cannot use a relative import"
        theDescription = "Mypy does not support relative import in top-level module, mypy process aborted for this file"
        theUrl = "https://github.com/python/mypy/issues/2974"

      #TODO: Put more heuristic

      #Append the current warning to the final result.
      result.push(
        {
          severity: theSeverity,
          location: {
            file: v_CurrMessageRaw.file,
            position: [[theStartLine, theStartCol], [theEndLine, theEndCol]]
          },
          excerpt: theMessage,
          description: theDescription,
          url: theUrl
        }
      )
    #The job is over, let's return the result so it can be displayed to the user.
    return result

  provideLinter: ->
    provider =
      name: 'linter-mypy'
      grammarScopes: ['source.python']
      scope: 'file'
      lintsOnChange: false
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
    projectName = path.parse(projectPath).base
    resolvedPath = resolvedPath.replace(/\$PROJECT_NAME/g, projectName)
    resolvedPath = resolvedPath.replace(/\$PROJECT_PATH/g, projectPath)
    return resolvedPath
