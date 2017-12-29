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
  describe "The `exec` method", ->
    it 'returns the expected error message when launching a non-existing executable', ->
      dummyExecName = "aNonExistingExecutable"
      return helpers.exec(dummyExecName, [], {}).then ((outputStream) ->
        #'This promise is not expected to be successful
        expect(true).toBe(false)
      ), (err) ->
        expect(err.message).toBe 'Failed to spawn command `' + dummyExecName + '`. Make sure `' + dummyExecName + '` is installed and on your PATH'
