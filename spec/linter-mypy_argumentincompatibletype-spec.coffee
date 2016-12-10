#!/usr/bin/env coffee
#
# This spec file validates:
#  * The heuristic related ot the warning "Argument A to "B" has incompatible type "C"; expected "D""
#    * Make sure the range and the attributes are correctly set.
#
#  If it fails:
#  * Visually validate the underline of the file "bad0.py"
#  * Adjust the related heuristic/regex.

LinterMyPystyle = require '../lib/init'
path = require 'path'
{CompositeDisposable} = require 'atom'
helpers = require 'atom-linter'

badPath0 = path.join(__dirname, 'fixtures', 'bad0.py')
badPath0Regex = /.+bad0\.py/

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

  describe "reads bad0.py and", ->
    editor = null
    beforeEach ->
      waitsForPromise ->
        atom.workspace.open(badPath0).then (e) ->
          atom.config.set('linter-mypy.fastParser', false)
          editor = e

    describe "validates reported warnings", ->
      messages = null
      beforeEach ->
        waitsForPromise ->
          lint(editor).then (msgs) -> messages = msgs
      it 'should have detected all the errors', ->
        expect(messages.length).toBe(30)
      it 'should have put the good attributes in each warnings', ->
        msg0 = 'Argument 1 to "add" has incompatible type "str"; expected "int"'
        msg1 = 'Argument 2 to "add" has incompatible type "str"; expected "int"'
        msg = [msg0, msg1]
        messages.forEach (item, index) ->
          expect(item.filePath).toMatch(badPath0Regex)
          expect(item.type).toBe('Warning')
          expect(item.text).toBe(msg[index %% 2])
      it 'should have put the good range base on heuristic', ->
        #Before setting those expected range, visually make sure that the underlines of bad0.py make sens.
        expect(messages[0].range).toEqual([[3,3],[3,6]])
        expect(messages[1].range).toEqual([[3,3],[3,6]])
        expect(messages[2].range).toEqual([[4,11],[4,14]])
        expect(messages[3].range).toEqual([[4,11],[4,14]])
        expect(messages[4].range).toEqual([[5,11],[5,14]])
        expect(messages[5].range).toEqual([[5,11],[5,14]])
        expect(messages[6].range).toEqual([[6,12],[6,15]])
        expect(messages[7].range).toEqual([[6,12],[6,15]])
        expect(messages[8].range).toEqual([[7,6],[7,9]])
        expect(messages[9].range).toEqual([[7,6],[7,9]])
        expect(messages[10].range).toEqual([[10,4],[10,7]])
        expect(messages[11].range).toEqual([[10,4],[10,7]])
        expect(messages[12].range).toEqual([[11,12],[11,15]])
        expect(messages[13].range).toEqual([[11,12],[11,15]])
        expect(messages[14].range).toEqual([[12,12],[12,15]])
        expect(messages[15].range).toEqual([[12,12],[12,15]])
        expect(messages[16].range).toEqual([[13,13],[13,16]])
        expect(messages[17].range).toEqual([[13,13],[13,16]])
        expect(messages[18].range).toEqual([[14,7],[14,10]])
        expect(messages[19].range).toEqual([[14,7],[14,10]])
        expect(messages[20].range).toEqual([[17,5],[17,8]])
        expect(messages[21].range).toEqual([[17,5],[17,8]])
        expect(messages[22].range).toEqual([[18,13],[18,16]])
        expect(messages[23].range).toEqual([[18,13],[18,16]])
        expect(messages[24].range).toEqual([[19,13],[19,16]])
        expect(messages[25].range).toEqual([[19,13],[19,16]])
        expect(messages[26].range).toEqual([[20,14],[20,17]])
        expect(messages[27].range).toEqual([[20,14],[20,17]])
        expect(messages[28].range).toEqual([[21,8],[21,11]])
        expect(messages[29].range).toEqual([[21,8],[21,11]])
