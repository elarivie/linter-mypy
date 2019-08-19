# This file contains all the logic of the linter-mypy.

# Import every required libraries.

{CompositeDisposable} = require 'atom'
helpers = require 'atom-linter'
fs = require 'fs'
os = require 'os'
path = require 'path'
NamedRegexp = require('named-js-regexp')
md5 = require('md5')

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
    mypyNotifyInternalError:
      type: 'boolean'
      default: true
      description: 'Pop-up a detailed error if a Mypy Internal error occurs'
      order: 2
    ignoreFiles:
      type: 'string'
      default: ''
      description: 'Regex pattern of filenames to ignore, e.g.: "test.+"'
      order: 3
    lintTrigger:
      title: 'Lint Trigger'
      type: 'string'
      default: 'LintOnFileSave'
      enum: [
        {value: 'LintOnFileSave', description: 'Lint on file save'}
        {value: 'LintAsYouType', description: 'Lint as you type'}
      ]
      description: "Specify the lint trigger"
      order: 4
    mypyIncremental:
      type: 'boolean'
      default: true
      description: 'Use <a href="http://mypy.readthedocs.io/en/latest/command_line.html#incremental">Mypy experimental incremental analysis</a> to improve lint process time.'
      order: 5
    mypyIncrementalCacheFolderPath:
      title: 'Mypy Incremental Cache Folder Path'
      type: 'string'
      default: ''
      description: '''Path to an existing folder where Mypy can use to cache data.
      The optionals `$PROJECT_PATH` and `$PROJECT_NAME` variables can be used to resolve the path
      dynamically depending of the current project.<br />For example: `$PROJECT_PATH/mypy_cache`.
      <br/><strong>Note:</strong><ul>
          <li>If `/dev/null` is provided, no cache will be use.</li>
          <li>If no path is provided, folders under the OS temp folder will be use.</li>
          <li>If a path is provided, and the folder exists, then it will be use.</li>
          <li>If a dot is provided, the default behavior of MyPy will be use (a .mypy_cache folder next to the file being linted)</li>
      </ul>
      '''
      order: 6
    mypyPath:
      type: 'string'
      default: ''
      description: '''<a href="http://mypy.readthedocs.io/en/latest/command_line.html#how-imports-are-found">MYPYPATH</a> to use, is a colon-separated list of directories
      <br /><strong>Note:</strong> Use a dot to add the directory containing the file being linted.
      The optionals `$PROJECT_PATH` and `$PROJECT_NAME` variables can be used to resolve the path
      dynamically depending of the current project. For example:
      `$PROJECT_PATH/stubs`.
      '''
      order: 7
    mypyIniFile:
      type: 'string'
      default: ''
      description: '''Path to a <a href="http://mypy.readthedocs.io/en/latest/config_file.html">mypy.ini</a> file.
      The optionals `$PROJECT_PATH` and `$PROJECT_NAME` variables can be used to resolve the path
      dynamically depending of the current project. For example:
      `$PROJECT_PATH/mypy.ini`. <strong>If a mypy.ini file is being found at the given path then all the below settings will be ignore.</strong>
      '''
      order: 8
    warnUnreachable:
      type: 'boolean'
      default: true
      description: 'Warn about statements or expressions inferred to be unreachable or redundant'
      order: 9
    noImplicitReexport:
      type: 'boolean'
      default: true
      description: 'Treat imports as private unless aliased'
      order: 10
    followImports:
      type: 'string'
      default: 'silent'
      enum: [
        {value: 'normal', description: 'Normal. Follow imports normally and type check all top level code'}
        {value: 'silent', description: 'Silent. Follow imports normally, but suppress any error messages.'}
        {value: 'skip', description: 'Skip. Don’t follow imports.'}
        {value: 'error', description: 'Error. The same behavior as skip but not quite as silent.'}
      ]
      description: '''Should mypy analysis <a href="http://mypy.readthedocs.io/en/latest/command_line.html#follow-imports">follow imports</a>'''
      order: 11
    namespacePackages:
      type: 'boolean'
      default: true
      description: 'Support namespace packages (PEP 420, __init__.py-less'
      order: 12
    disallowUntypedCalls:
      type: 'boolean'
      default: true
      description: 'Disallow calling functions without type annotations from functions with type annotations'
      order: 13
    disallowUntypedDefs:
      type: 'boolean'
      default: true
      description: 'Disallow defining functions without type annotations or with incomplete type annotations'
      order: 14
    disallowUntypedGlobals:
      type: 'boolean'
      default: true
      description: 'toplevel errors about missing annotations'
      order: 15
    disallowRedefinition:
      type: 'boolean'
      default: true
      description: 'Disallow unconditional variable redefinition with a new type'
      order: 16
    strictEquality:
      type: 'boolean'
      default: true
      description: 'Prohibit equality, identity, and container checks for non-overlapping types'
      order: 17
    disallowIncompleteDefs:
      type: 'boolean'
      default: true
      description: 'Disallow defining functions with incomplete type annotations'
      order: 18
    checkUntypedDefs:
      type: 'boolean'
      default: true
      description: 'Type check the interior of functions without type annotations'
      order: 19
    warnIncompleteStub:
      type: 'boolean'
      default: true
      description: 'Warn if missing type annotation in typeshed, only relevant with --check-untyped-defs enabled'
      order: 20
    disallowUntypedDecorators:
      type: 'boolean'
      default: true
      description: 'Disallow decorating typed functions with untyped decorators'
      order: 21
    warnRedundantCasts:
      type: 'boolean'
      default: true
      description: 'Warn about casting an expression to its inferred type'
      order: 22
    warnNoReturn:
      type: 'boolean'
      default: true
      description: 'Warn about functions that end without returning'
      order: 23
    warnReturnAny:
      type: 'boolean'
      default: true
      description: 'Warn about returning values of type Any from non-Any typed functions'
      order: 24
    disallowSubclassingAny:
      type: 'boolean'
      default: true
      description: 'Disallow subclassing values of type "Any" when defining classes'
      order: 25
    disallowAnyUnimported:
      type: 'boolean'
      default: true
      description: 'Disallows usage of types that come from unfollowed imports'
      order: 26
    disallowAnyExpr:
      type: 'boolean'
      default: true
      description: 'Disallows all expressions in the module that have type Any'
      order: 27
    disallowAnyDecorated:
      type: 'boolean'
      default: true
      description: 'Disallows functions that have Any in their signature after decorator transformation'
      order: 28
    disallowAnyExplicit:
      type: 'boolean'
      default: true
      description: 'Disallows explicit Any in type positions'
      order: 29
    disallowAnyGenerics:
      type: 'boolean'
      default: true
      description: 'Disallows usage of generic types that do not specify explicit type parameters'
      order: 30
    warnUnusedIgnores:
      type: 'boolean'
      default: true
      description: "Warn about unneeded '# type: ignore' comments"
      order: 31
    warnUnusedConfigs:
      type: 'boolean'
      default: true
      description: "Warn about unnused '[mypy-<pattern>]' config sections"
      order: 32
    warnMissingImports:
      type: 'boolean'
      default: true
      description: "Warn about imports of missing modules"
      order: 33
    strictOptional:
      type: 'boolean'
      default: true
      description: "Enable experimental strict Optional checks"
      order: 34
    noImplicitOptional:
      type: 'boolean'
      default: true
      description: "Don't assume arguments with default values of None are Optional"
      order: 35

  theOSTempFolder: undefined

  removeFromDisk: (p_path) ->
    if p_path
      if fs.existsSync(p_path)
        stat = fs.statSync p_path

        if stat.isDirectory()
          # Remove Directory content
          for item in fs.readdirSync p_path
            @removeFromDisk path.join(p_path, item)
          fs.rmdirSync p_path
        else
          # Remove File
          fs.unlinkSync p_path

  activate: ->
    require('atom-package-deps').install('linter-mypy')

    # Create a temporary folder which will exists for the lifetime of the linter-mypy session.
    fs.mkdtemp path.join(os.tmpdir(), "atom_linter-mypy_"), (err, folder) =>
      if err
        # Bah it's not that bad... it will just not use incremental analysis even if requested by the user in the settings.
      else
        @theOSTempFolder = folder

    #Listen and reload any settings changes to prevent having to restart Atom.
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.config.observe 'linter-mypy.executablePath',
      (executablePath) =>
        @executablePath = executablePath
    @subscriptions.add atom.config.observe 'linter-mypy.mypyIncremental',
      (mypyIncremental) =>
        @mypyIncremental = mypyIncremental
    @subscriptions.add atom.config.observe 'linter-mypy.mypyIncrementalCacheFolderPath',
      (mypyIncrementalCacheFolderPath) =>
        @mypyIncrementalCacheFolderPath = mypyIncrementalCacheFolderPath
    @subscriptions.add atom.config.observe 'linter-mypy.mypyNotifyInternalError',
      (mypyNotifyInternalError) =>
        @mypyNotifyInternalError = mypyNotifyInternalError
    @subscriptions.add atom.config.observe 'linter-mypy.ignoreFiles',
      (ignoreFiles) =>
        @ignoreFiles = ignoreFiles
    @subscriptions.add atom.config.observe 'linter-mypy.mypyIniFile',
      (mypyIniFile) =>
        @mypyIniFile = mypyIniFile
    @subscriptions.add atom.config.observe 'linter-mypy.disallowUntypedCalls',
      (disallowUntypedCalls) =>
        @disallowUntypedCalls = disallowUntypedCalls
    @subscriptions.add atom.config.observe 'linter-mypy.disallowUntypedGlobals',
      (disallowUntypedGlobals) =>
        @disallowUntypedGlobals = disallowUntypedGlobals
    @subscriptions.add atom.config.observe 'linter-mypy.disallowRedefinition',
      (disallowRedefinition) =>
        @disallowRedefinition = disallowRedefinition
    @subscriptions.add atom.config.observe 'linter-mypy.strictEquality',
      (strictEquality) =>
        @strictEquality = strictEquality
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
    @subscriptions.add atom.config.observe 'linter-mypy.warnUnreachable',
      (warnUnreachable) =>
        @warnUnreachable = warnUnreachable
    @subscriptions.add atom.config.observe 'linter-mypy.noImplicitReexport',
      (noImplicitReexport) =>
        @noImplicitReexport = noImplicitReexport
    @subscriptions.add atom.config.observe 'linter-mypy.warnMissingImports',
      (warnMissingImports) =>
        @warnMissingImports = warnMissingImports
    @subscriptions.add atom.config.observe 'linter-mypy.strictOptional',
      (strictOptional) =>
        @strictOptional = strictOptional
    @subscriptions.add atom.config.observe 'linter-mypy.noImplicitOptional',
      (noImplicitOptional) =>
        @noImplicitOptional = noImplicitOptional
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
    @subscriptions.add atom.config.observe 'linter-mypy.namespacePackages',
      (namespacePackages) =>
        @namespacePackages = namespacePackages
    @subscriptions.add atom.config.observe 'linter-mypy.mypyPath',
      (mypyPath) =>
        @mypyPath = mypyPath

  deactivate: ->
    # Clean up the OS temp files created on the hard drive
    @removeFromDisk(@theOSTempFolder)

    # Unsubscribe any registered atom's event.
    if @subscriptions
      @subscriptions.dispose()

  getMypyCommandLine: (filePath, filePathShadow)->
    # Get the command line arguments to lint a given file path.
    params = []

    ## Use the python module mypy
    params.push("-m")
    params.push("mypy")
    params.push("--hide-error-context")

    ## We want column number so that we can know where to underline.
    params.push("--show-column-numbers")

    ## In case a Mypy INTERNAL ERROR is encountered, print the stacktrace to ease bug reporting.
    params.push("--show-traceback")

    if filePath != filePathShadow
      params.push("--shadow-file")
      params.push(filePath)
      params.push(filePathShadow)

    # Cache Strategy #0: Do not use cache folder at all
    # Cache Strategy #1: Use a unique cache folder for each file under OS temp
    # Cache Strategy #2: Use default MyPy behavior of creating a ".mypy_cache" folder next to the file
    # Cache Strategy #3: Use the user provided cache folder
    #
    # Fallback hierarchy:
    #   (#2|#3) -> #1 -> #0
    v_cacheFolder = undefined

    if @mypyIncremental
      # Use mypy incremental
      params.push("--incremental")

      v_cacheFolder = @resolvePath @mypyIncrementalCacheFolderPath, filePath
      if ("/dev/null" == v_cacheFolder) || ("nul" == v_cacheFolder)
        v_cacheFolder = undefined
      else
        if "" == v_cacheFolder
        else if "." == v_cacheFolder
          # We need to explicitely compute the .mypy_cache folder path next to the file being linted
          #     since by default mypy creates it in the CWD
          #         but linter-mypy sets CWD to the root of the hard drive... (due to a bug in Mypy)
          #            Therefore it would either pollute the root or mostly silently fail to create the folder.
          v_cacheFolder = path.join path.dirname(filePath), ".mypy_cache"
          # Make sure the cache folder exists & create it if needed
          try
            fs.mkdirSync(v_cacheFolder)
          catch err
            if "EEXIST" == err.code
            else
              # Bah it's not that bad... We fallback to Strategy #1.
              v_cacheFolder = ""

        # Make sure the cache folder exists
        if fs.existsSync(v_cacheFolder)
          stat = fs.statSync v_cacheFolder
          if stat.isDirectory()
          else
            #We fallback to Strategy #1 if the directory does not already exist
            v_cacheFolder = ""
        else
          #We fallback to Strategy #1 if the directory does not already exist
          v_cacheFolder = ""

        if "" == v_cacheFolder
          if @theOSTempFolder
            v_cacheFolder = path.join(@theOSTempFolder, md5(filePath))
            try
              fs.mkdirSync(v_cacheFolder)
            catch err
              if "EEXIST" == err.code then
              else
                # Bah it's not that bad... We fallback to Strategy #0.
                v_cacheFolder = undefined
          else
            # Bah it's not that bad... We fallback to Strategy #0.
            v_cacheFolder = undefined
    else
      params.push("--no-incremental")
    # Note: At this point, v_cacheFolder is either a path to an existing folder or undefined
    if v_cacheFolder
    else
      # Do not create any cache file anywhere.
      switch os.platform()
        when "win32"
          v_cacheFolder = "nul"
        #when "linux"
        #when "darwin"
        else
          v_cacheFolder = "/dev/null"

    params.push("--cache-dir")
    params.push(v_cacheFolder)

    iniPath = @resolvePath @mypyIniFile, filePath

    if (fs.existsSync iniPath)
      # Use the provided mypy configuration file.
      params.push("--config-file")
      params.push(iniPath)
    else
      # Add the parameters base on user selected settings.
      params.push("--follow-imports")
      params.push(@followImports)

      if (@unreachable)
        params.push("--no-implicit-reexport")
      else
        params.push("--warn-unreachable")

      if (@noImplicitReexport)
        params.push("--implicit-reexport")
      else
        params.push("--no-implicit-reexport")

      if (@namespacePackages)
        params.push("--namespace-packages")
      else
        params.push("--no-namespace-packages")

      if (@disallowUntypedGlobals)
        params.push("--disallow-untyped-globals")
      else
        params.push("--allow-untyped-globals")

      if (@disallowRedefinition)
        params.push("--disallow-redefinition")
      else
        params.push("--allow-redefinition")

      if (@strictEquality)
        params.push("--strict-equality")
      else
        params.push("--no-strict-equality")

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

      if (@disallowAnyUnimported)
        params.push("--disallow-any-unimported")
      if (@disallowAnyExpr)
        params.push("--disallow-any-expr")
      if (@disallowAnyDecorated)
        params.push("--disallow-any-decorated")
      if (@disallowAnyExplicit)
        params.push("--disallow-any-explicit")

      if (@disallowAnyGenerics)
        params.push("--disallow-any-generics")
      else
        params.push("--allow-any-generics")

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

    return params

  lintPath: (filePath, filePathShadow) ->
    # This is the entry point for Lint requests for a given file.

    rootPath = path.dirname(filePath)

    # Extract the file system root.
    c_RootRoot = path.parse(filePath).root

    # Run the command giving the full file path and running from the file system root folder where the file being linted is located.
    # This has the advantage that:
    # * It allows mypy to find dependencies (import) of the file being linted.
    # * It always works fine, it is not affected by the mypy bug #2974 (should therefore never run with cwd set to the directory of the file being linted)
    options = { stream: 'both', ignoreExitCode: true, cwd: c_RootRoot, env: Object.create(process.env), timeout: Infinity }

    # Set the MYPYPATH as requested
    ##Initialize the environment variable MYPYPATH
    if !(options.env["MYPYPATH"])?
      options.env["MYPYPATH"] = ''
    ##Prepend user setting defined MYPYPATH to current system env MYPYPATH
    if @mypyPath?
      mypyPathResolved = @resolvePath @mypyPath, filePath
      options.env["MYPYPATH"] = ':' + mypyPathResolved + ':' + options.env["MYPYPATH"] + ':'
    ##Add current folder of the file being linted to MYPYPATH
    options.env["MYPYPATH"] = options.env["MYPYPATH"].replace(/:\.:/g, ':' + rootPath + ':')
    ##Clean all repeated path separator
    options.env["MYPYPATH"] = options.env["MYPYPATH"].replace(/:+/g, ':')
    ##Strip not necessary separator
    options.env["MYPYPATH"] = options.env["MYPYPATH"].replace(/^:+|:+$/g, '')

    executablePath = @resolvePath @executablePath, filePath
    params = @getMypyCommandLine(filePath, filePathShadow)
    mypyNotifyInternalError = @mypyNotifyInternalError
    # We call the mypy process and parse its output.
    ## For debug: ## alert(executablePath + " " + params.join(" "))
    # https://github.com/steelbrain/exec
    return helpers.exec(executablePath, params, options).then (({stdout, stderr, exitCode}) ->
      # The goal of this method is to return an array of string where each string is a valid warning in the format: "FILEPATH:LINENO:COLNO:MESSAGE"
      result = []

      # Each line of the mypy output may be a potential warning so we create an array of string containing each line of the output.
      # We split the text using the new line as a separator and handle any OS kind of new lines.
      lines = stdout.split(/\r\n|\r|\n/g)

      # For each line (aka warnings) we filter out those which are not wanted else we append it to the final list of warnings to reports.
      # Note: The final report must contain the full path to the file so that Atom can find the file.
      for key, val of lines
        result.push(c_RootRoot + val)

      if "" != stderr
        # Well, Well, Well... something went wrong.
        # Instead of crashing or giving cryptic error message, let's try to be user friendly.
        if stderr.match /^.+\:\sNo\s\[mypy\]\ssection\sin\sconfig\sfile$/gi
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
        else if (0 <= stderr.indexOf("usage: mypy"))
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
        else if (0 <= stderr.indexOf("No module named mypy"))
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
        else if (0 <= stderr.indexOf("AssertionError: Neither id, path nor source given"))
          ###
          The Problem: When Mypy encouters a relative import from a toplevel, it crashes with an assert Stacktrace.

          The Context: Mypy has a recorded bug #2974.

          The Conclusion: We can't do much, other than not crashing ourself with annoying pop-ups.

          The Solution: Let's:
            1- Inform the user about the situation with a lint error
          ###
          return [[filePath + ":0:0: error: MypyBug2974"]]
        else if (0 <= stderr.indexOf(": error: INTERNAL ERROR -- please report a bug at https://github.com/python/mypy/issues"))
          ###
          The Problem: Mypy has an internal bug.

          The Context: linter-mypy did a good job but Mypy has a bug.

          The Conclusion: We can't do much, other than not crashing ourself with annoying pop-ups.

          The Solution: Let's:
            1- Inform the user about the situation with a lint error
            2- Display the stacktrace in the pop-up to help bug reporting
            3- Offer to deactivate internal error related pop-up to at least allow the user to keep linter-mypy activated so other files which are not affected by the bug can still be linted.
          ###
          if (mypyNotifyInternalError)
            notification = atom.notifications.addError("Mypy version " + /.*version: (.*)/.exec(stderr)[1] + " INTERNAL ERROR",
            {
              detail: stdout,
              description: "Please report a bug at https://github.com/python/mypy/issues",
              dismissable: true,
              buttons: [
                {
                  text: "Deactivate Mypy INTERNAL ERROR pop-ups",
                  onDidClick: ->
                    atom.config.set('linter-mypy.mypyNotifyInternalError', false)
                    notification.dismiss()
                },
                {
                  text: "Close",
                  onDidClick: ->
                    notification.dismiss()
                }
              ],
            })
          return [[filePath + ":0:0: error: INTERNAL MYPY ERROR"]]

        else
          ###
          The Problem: Something unknown went wrong.

          The Context: Many known possible error were managed in a user friendly manner, but this error is not.

          The Conclusion: Not much can be done.

          The Solution: Since it is an unknown error let's keep the error message intact
            1- Inform the user about the situation with an error pop-up containing the full error message, hopefully he will provide a bug report with this information so that it can be better handle.
          ###
          atom.notifications.addError(stderr)

      # Return the result.
      return [result]
    ), (err) ->
      if ('ENOENT' == err.code)
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
      else
        # An unknown bad thing occured.
        atom.notifications.addError(err.message)
      #Something went wrong there is therefore no mypy warnings to report.
      return [""]

  parseMessages: (output) ->
    # Parse the pre-processed mypy warnings output and isolate:
    # - file = The file path to the file being linted.
    # - line = The line number where the warning is.
    # - col = The column where the warning is within the line.
    # - message = The warning text.

    # Declare regex which extract information about the lint details.
    regexLine = new NamedRegexp("^(?<file>([A-Z]:)?[^:]+)[:](?<line>\\d+):(?:(?<col>\\d+):)? (?<severity>[a-z]+): (?<message>.+)")

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

      #Prepare the lint characteristics.
      theSeverity = 'warning'
      if v_CurrMessageRaw.severity == "error"
        theSeverity = 'warning'
      else if v_CurrMessageRaw.severity == "note"
        theSeverity = "info"

      theDescription = ""
      theMessage = v_CurrMessageRaw.message
      theUrl = ""
      theStartLine = parseInt(v_CurrMessageRaw.line, 10) - 1
      theStartCol = parseInt(v_CurrMessageRaw.col, 10) - 1

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

      # Use specialized heuristic base on the lint message...
      if ("Revealed type is '" == theMessage.substr(0, 18))
        #Rational: Since we know the method name is "reveal_type", we can underline its length.
        theEndCol += 10
        theSeverity = 'info'
      else if "MypyBug2974" == theMessage#Rational: Mypy Internal Bug
        theSeverity = 'error'
        theMessage = "Top-level module cannot use a relative import"
        theDescription = "Mypy does not support relative import in top-level module, mypy process aborted for this file"
        theUrl = "https://github.com/python/mypy/issues/2974"
      else if "INTERNAL MYPY ERROR" == theMessage
        theSeverity = 'error'
        theMessage = "INTERNAL MYPY ERROR"
        theDescription = "Mypy crashed"
        theUrl = "https://github.com/python/mypy/issues/"
      else if "invalid syntax" == theMessage
        theSeverity = 'error'
        #Rational: We can't really know where in the line the invalid syntax is, so let's underline the whole line.
        theStartCol = 0
      else if "inconsistent use of tabs and spaces in indentation" == theMessage
        theSeverity = 'error'
        #Rational: Indentation is obviously at the start of the line.
        theStartCol = 0
      else if "unindent does not match any outer indentation level" == theMessage
        theSeverity = 'error'
        #Rational: Indentation is obviously at the start of the line.
        theStartCol = 0
      else if "unexpected unindent" == theMessage
        theSeverity = 'error'
        #Rational: Indentation is obviously at the start of the line.
        theStartCol = 0
      else
        # Use regex...
        regexHeuristic = new NamedRegexp("^Argument . to .(?<name>.+). has incompatible type ..+.; expected ..+.$")
        rawMatch = regexHeuristic.execGroups(v_CurrMessageRaw.message)
        if rawMatch
          #Rational: Since we know the method name we can underline its length.
          theEndCol += rawMatch.name.length - 1
        else
          regexHeuristic = new NamedRegexp("^Name '(?<name>.+)' is not defined$")
          rawMatch = regexHeuristic.execGroups(v_CurrMessageRaw.message)
          if rawMatch
            theSeverity = 'error'
            #Rational: Since we know the method name we can underline its length.
            theEndCol += rawMatch.name.length - 1

      #TODO: Put more heuristic

      #Append the current lint to the final result.
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
        filePath = textEditor.getPath()
        if !filePath?
          return null
        if (@ignoreFiles != '') && filePath.match(@ignoreFiles)
          # The file is to be ignored, we therefore return an empty set of warning.
          return []

        # Let's lint it and returns the Mypy warnings...
        if provider.lintsOnChange && textEditor.isModified()
          return helpers.tempFile path.basename(filePath), textEditor.getBuffer().getText(), (filePathShadow) =>
            return @lintPath(filePath, filePathShadow).then @parseMessages
        else
          return @lintPath(filePath, filePath).then @parseMessages

    @subscriptions.add atom.config.observe 'linter-mypy.lintTrigger',
      (lintTrigger) =>
        @lintTrigger = lintTrigger
        provider.lintsOnChange = "LintAsYouType" == lintTrigger
    return provider

  resolvePath: (targetPath, filepath) ->
    # Replace variables ($PROJECT_PATH, $PROJECT_NAME) from the targetPath string base on the filepath location.
    resolvedPath = targetPath
    if filepath
      [projectPath, ...] = atom.project.relativizePath(filepath)
      if projectPath
        projectName = path.parse(projectPath).base
        resolvedPath = resolvedPath.replace(/\$PROJECT_NAME/g, projectName)
        resolvedPath = resolvedPath.replace(/\$PROJECT_PATH/g, projectPath)
    return resolvedPath
