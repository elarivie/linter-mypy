#!/usr/bin/env coffee
#
# This spec file validates:
#  * The very basic integration with mypy.
#    * Make sure nothing is detected when the file is valid.
#    * Make sure warnings are detecteds when the file is invalid.
#
#  If it fails:
#  * Adjust the mypy output parsing logic and regexes.

LinterMyPystyle = require '../lib/init'
path = require 'path'
{CompositeDisposable} = require 'atom'
helpers = require 'atom-linter'

goodPath = path.join(__dirname, 'fixtures', 'good.py')
badPath = path.join(__dirname, 'fixtures', 'bad.py')
badPathRegex = /.+bad\.py/

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

  describe "lints good.py and", ->
    editor = null
    beforeEach ->
      waitsForPromise ->
        atom.workspace.open(goodPath).then (e) ->
          atom.config.set('linter-mypy.fastParser', false)
          editor = e

    it 'finds nothing to complain about', ->
      messages = null
      waitsForPromise ->
        lint(editor).then (msgs) -> messages = msgs
      runs ->
        expect(messages.length).toEqual 0

  describe "lints bad.py and", ->
    editor = null
    beforeEach ->
      waitsForPromise ->
        atom.workspace.open(badPath).then (e) ->
          atom.config.set('linter-mypy.fastParser', false)
          editor = e

    it 'finds something to complain about', ->
      messages = null
      waitsForPromise ->
        lint(editor).then (msgs) -> messages = msgs
      runs ->
        expect(messages.length).toBeGreaterThan 0
