#!/usr/bin/env coffee
#
# This spec file validates:
#  * The atom-linter method used by linter-mypy.
#    * Make sure that over time the behavior is as expected.
#
#  If it fails:
#  * Validate everywhere in the code where the problematic method is used and validate that linter-mypy still works.

{CompositeDisposable} = require 'atom'
helpers = require 'atom-linter'

describe "The Helpers `exec` method", ->
  dummyExecName = "aNonExistingExecutable"
  describe "When is launching a non-existing executable", ->
    it 'returns the expected error message', ->
      return helpers.exec(dummyExecName, [], {}).then ((outputStream) ->
        #'This promise is not expected to be successful
        expect(true).toBe(false)
      ), (err) ->
        expect(err.message).toBe 'Failed to spawn command `' + dummyExecName + '`. Make sure `' + dummyExecName + '` is installed and on your PATH'
