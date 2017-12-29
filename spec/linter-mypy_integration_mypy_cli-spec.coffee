#!/usr/bin/env coffee
#
#  This spec file validates:
#  * That the mypy command line interface of Mypy.
#
#  If it fails:
#  * run "mypy --help" and do a diff with spec/fixtures/mypy.help
#    1- Adapt linter-mypy to the new interface
#    2- run "mypy --help > spec/fixtures/mypy.help"

LinterMyPystyle = require '../lib/init'
path = require 'path'
{CompositeDisposable} = require 'atom'
helpers = require 'atom-linter'

helpPath = path.join(__dirname, 'fixtures', 'integration', 'mypy.help')

describe "MyPy ... (integration) Command Line Interface", ->
  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage('linter-mypy')
    waitsForPromise ->
      atom.packages.activatePackage('language-python')

  describe "CLI", ->
    supportedHelp = "A"
    mypyHelp = "B"
    mypyInvalidMsg = ""
    beforeEach ->
      mypyPath = atom.config.get('linter-mypy.executablePath')
      waitsForPromise ->
        atom.workspace.open(helpPath).then (e) ->
          supportedHelp = e.getText().trim()
      waitsForPromise ->
        helpers.exec(mypyPath, ["-m", "mypy", "--help"], { stream: 'stdout', ignoreExitCode: true}).then (helpMsg) ->
          mypyHelp = helpMsg.trim()
      waitsForPromise ->
        helpers.exec(mypyPath, ["-m", "mypy", "--ABCXXXDEFNONEXISTINGARGUMENT"], { stream: 'stderr', ignoreExitCode: true}).then (invalidMsg) ->
          mypyInvalidMsg = invalidMsg.trim()

    it 'Matches the supported "mypy" CLI.', ->
      expect(mypyHelp).not.toBe("")
      expect(mypyHelp).toBe(supportedHelp)

    it 'Provides the expected error message when provided with unknown arguments.', ->
      expect(mypyInvalidMsg).not.toBe("")
      expect(0 <= mypyInvalidMsg.indexOf("usage: mypy")).toBe(true)
