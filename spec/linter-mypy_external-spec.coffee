#!/usr/bin/env coffee
#
# This spec file validates:
#  * That no warnings are reported which are outside of the file being linted.
#
#  If it fails:
#  * Adjust the ignore logic within the parsing logic.

LinterMyPystyle = require '../lib/init'
path = require 'path'
{CompositeDisposable} = require 'atom'
helpers = require 'atom-linter'

goodExternalPath = path.join(__dirname, 'fixtures', 'goodexternal.py')

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

  describe "lints goodexternal.py and", ->
    editor = null
    beforeEach ->
      waitsForPromise ->
        atom.workspace.open(goodExternalPath).then (e) ->
          atom.config.set('linter-mypy.fastParser', false)
          editor = e

    it 'finds nothing to complain about', ->
      messages = null
      waitsForPromise ->
        lint(editor).then (msgs) -> messages = msgs
      runs ->
        expect(messages.length).toEqual 0
