#!/usr/bin/env coffee
#
# This spec file validates:
#  * The heuristic related ot the error "invalid syntax"
#    * Make sure the range and the attributes are correctly set.
#
#  If it fails:
#  * Visually validate the underline of the file "invalidsyntax.py"
#  * Adjust the related heuristic/regex.

LinterMyPystyle = require '../lib/init'
path = require 'path'
{CompositeDisposable} = require 'atom'
helpers = require 'atom-linter'

pyPath = path.join(__dirname, 'fixtures', 'runtimeerror', 'invalidsyntax.py')
pyPathRegex = /.+invalidsyntax\.py/

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

  describe "reads inconsistentuseoftabsandspacesinindentation.py and", ->
    editor = null
    beforeEach ->
      waitsForPromise ->
        atom.workspace.open(pyPath).then (e) ->
          editor = e

    describe "validates reported warnings", ->
      messages = null
      beforeEach ->
        waitsForPromise ->
          lint(editor).then (msgs) -> messages = msgs
      it 'should have detected all the errors', ->
        expect(messages.length).toBe(1)
      it 'should have put the good message in the lint', ->
        messages.forEach (item, index) ->
          expect(item.location.file).toMatch(pyPathRegex)
          expect(item.severity).toBe('error')
          expect(item.excerpt).toBe('invalid syntax')
      it 'should have put the good range base on heuristic', ->
        #Before setting those expected location.position, visually make sure that the underlines make sens.
        expect(messages[0].location.position).toEqual([[4,0],[4,10]])
