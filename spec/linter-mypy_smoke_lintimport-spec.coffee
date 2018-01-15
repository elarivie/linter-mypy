# This spec file quickly validates:
#  * Base on the followImports setting...
#  ** That either
#        - no warnings are reported which are outside of the file being linted.
#        OR
#        - warnings are reported about imported files content.
#
#  If it fails:
#  * Visually validate the underline of the related fixtures file.
#  * Adjust the related heuristic/regex.

LinterMyPystyle = require '../lib/init'
path = require 'path'
{CompositeDisposable} = require 'atom'
helpers = require 'atom-linter'

badimportPath = path.join(__dirname, 'fixtures', 'smoke', 'bad', 'badimport.py')

describe "linter-mypy ... Linting + follow imports", ->
  lint = undefined
  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage('linter-mypy')
    waitsForPromise ->
      atom.packages.activatePackage('language-python')
  beforeEach ->
    lint = require('../lib/init').provideLinter().lint

  it 'should be in the package list', ->
    expect(atom.packages.isPackageLoaded('linter-mypy')).toBe true

  it 'should have activated the package', ->
    expect(atom.packages.isPackageActive('linter-mypy')).toBe true

  describe "lints bad import (silent)", ->
    editor = null
    beforeEach ->
      waitsForPromise ->
        atom.workspace.open(badimportPath).then (e) ->
          editor = e

    it 'finds local message only', ->
      atom.config.set("linter-mypy.followImports", 'silent')
      messages = null
      waitsForPromise ->
        lint(editor).then (msgs) -> messages = msgs
      runs ->
        expect(messages.length).toEqual 1

  describe "lints bad import (normal)", ->
    editor = null
    beforeEach ->
      waitsForPromise ->
        atom.workspace.open(badimportPath).then (e) ->
          editor = e

    it 'finds something to complain about', ->
      atom.config.set("linter-mypy.followImports", 'normal')
      messages = null
      waitsForPromise ->
        lint(editor).then (msgs) ->
          messages = msgs
      runs ->
        expect(messages.length).toBeGreaterThan 1
