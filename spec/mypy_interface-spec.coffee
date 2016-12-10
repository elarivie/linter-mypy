#!/usr/bin/env coffee
#
#  This spec file validates:
#  * That the mypy command line interface does not change.
#
#  If it fails:
#  * run "mypy --help" and do a diff with spec/fixtures/mypy.help
#    1- Adapt linter-mypy to the new interface
#    2- run "mypy --help > spec/fixtures/mypy.help"

LinterMyPystyle = require '../lib/init'
path = require 'path'
{CompositeDisposable} = require 'atom'
helpers = require 'atom-linter'

helpPath = path.join(__dirname, 'fixtures', 'mypy.help')

describe "The MyPy provider for Linter", ->
  lint = require('../lib/init').provideLinter().lint
  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage('linter-mypy')
    waitsForPromise ->
      atom.packages.activatePackage('language-python')

  it 'should be in the package list', ->
    expect(atom.packages.isPackageLoaded('linter-mypy')).toBe true

  it 'should have activated the package', ->
    expect(atom.packages.isPackageActive('linter-mypy')).toBe true

  describe "reads mypy.help and fetch mypy --help", ->
    supportedHelp = null
    mypyHelp = null

    beforeEach ->
      waitsForPromise ->
        atom.workspace.open(helpPath).then (e) ->
          supportedHelp = e.getText().trim()
          expect(supportedHelp).not.toBe("")

    beforeEach ->
      waitsForPromise ->
        mypyPath = atom.config.get('linter-mypy.executablePath')
        helpers.exec(mypyPath, ["--help"], { stream: 'stdout', ignoreExitCode: true}).then (helpMsg) ->
          mypyHelp = helpMsg.trim()
          expect(mypyHelp).not.toBe("")

    it 'Makes sure the supported "mypy" command interface has not change.', ->
      expect(mypyHelp).toBe(supportedHelp)
