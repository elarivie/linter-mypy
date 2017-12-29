#!/usr/bin/env coffee
#
# This spec file validates:
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

goodExternalPath = path.join(__dirname, 'fixtures', 'smoke', 'good', 'goodexternal.py')
badExternalPath = path.join(__dirname, 'fixtures', 'smoke', 'bad', 'badexternal.py')

describe "linter-mypy ... import", ->
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

  describe "lints good external", ->
    editor = null
    beforeEach ->
      waitsForPromise ->
        atom.workspace.open(goodExternalPath).then (e) ->
          editor = e

    it 'finds nothing to complain about', ->
      atom.config.set("linter-mypy.followImports", 'normal')
      messages = null
      waitsForPromise ->
        lint(editor).then (msgs) -> messages = msgs
      runs ->
        expect(messages.length).toEqual 0

  describe "lints bad external", ->
    editor = null
    beforeEach ->
      waitsForPromise ->
        atom.workspace.open(badExternalPath).then (e) ->
          editor = e

    it 'finds something to complain about', ->
      atom.config.set("linter-mypy.followImports", 'normal')
      messages = null
      waitsForPromise ->
        lint(editor).then (msgs) ->
          messages = msgs
      runs ->
        expect(messages.length).toBeGreaterThan 0

  describe "lints bad external (silent)", ->
    editor = null
    beforeEach ->
      waitsForPromise ->
        atom.workspace.open(badExternalPath).then (e) ->
          editor = e

    it 'finds nothing to complain about', ->
      atom.config.set("linter-mypy.followImports", 'silent')
      messages = null
      waitsForPromise ->
        lint(editor).then (msgs) ->
          messages = msgs
      runs ->
        expect(messages.length).toBe 0
