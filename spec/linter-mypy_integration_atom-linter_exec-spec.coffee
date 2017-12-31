#!/usr/bin/env coffee
#
# This spec file validates:
#  * The integration with atom-linter exec method.
#
#  If it fails:
#  * Validate everywhere in the code where the problematic method is used and validate that linter-mypy still works.

{CompositeDisposable} = require 'atom'
describe "atom-linter ... (integration)", ->
  helpers = require 'atom-linter'
  path = require 'path'
  describe "The `exec` method", ->
    it 'returns the expected error message when launching a non-existing executable', ->
      dummyExecName = "aNonExistingExecutable"
      return helpers.exec(dummyExecName, [], {}).then ((outputStream) ->
        #'This promise is not expected to be successful
        expect(true).toBe(false)
      ), (err) ->
        expect(err.message).toBe('Failed to spawn command `' + dummyExecName + '`. Make sure `' + dummyExecName + '` is installed and on your PATH')

    it 'Stores stdout, stderr and exitcode', ->
      scriptPath = path.join(__dirname, 'fixtures', 'integration', 'echo_stderrout_hello123.sh')
      options = { stream: 'both', ignoreExitCode: true, timeout: Infinity }
      waitsForPromise ->
        helpers.exec(scriptPath, [], options).then (({stdout, stderr, exitCode}) ->
          expect(stdout).toBe("Hello")
          expect(stderr).toBe("World!")
          expect(exitCode).toBe(123)
        )

    it 'Sends arguments', ->
      scriptPath = path.join(__dirname, 'fixtures', 'integration', 'echo_stdout_args.sh')
      options = { stream: 'both', ignoreExitCode: true, timeout: Infinity }
      waitsForPromise ->
        helpers.exec(scriptPath, ["ABC", "DEF"], options).then (({stdout, stderr, exitCode}) ->
          expect(stdout).toBe("ABC DEF")
          expect(stderr).toBe("")
          expect(exitCode).toBe(0)
        )

    it 'Sends Environment variable', ->
      scriptPath = path.join(__dirname, 'fixtures', 'integration', 'echo_stdout_env.sh')
      options = { stream: 'both', ignoreExitCode: true, timeout: Infinity, env: Object.create(process.env)}
      options.env["HELLO"] = "WORLD!"
      waitsForPromise ->
        helpers.exec(scriptPath, ["HELLO"], options).then (({stdout, stderr, exitCode}) ->
          expect(stdout).toBe("WORLD!")
          expect(stderr).toBe("")
          expect(exitCode).toBe(0)
        )
