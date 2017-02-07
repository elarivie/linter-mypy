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
          atom.config.set('linter-mypy.fastParser', true)
          editor = e

    describe "validates reported warnings", ->
      messages = null
      beforeEach ->
        waitsForPromise ->
          lint(editor).then (msgs) -> messages = msgs
      it 'should have detected all the errors', ->
        expect(messages.length).toBe(47)
      it 'should have put the good attributes in each warnings', ->
        msg0 = 'Argument 1 to "add" has incompatible type "str"; expected "int"'
        msg1 = 'Argument 2 to "add" has incompatible type "str"; expected "int"'
        msg2 = 'Unsupported operand types for + ("int" and "str")'
        msg = [msg0, msg1, msg2]
        messages.forEach (item, index) ->
          expect(item.filePath).toMatch(badPath0Regex)
          expect(item.type).toBe('Warning')
          if index <= 43
            expect(item.text).toBe(msg[index %% 3])
          else
            expect(item.text).toBe(msg[2])
      it 'should have put the good range base on heuristic', ->
        #Before setting those expected range, visually make sure that the underlines of bad0.py make sens.
        expect(messages[0].range).toEqual([[3,0],[3,3]])
        expect(messages[1].range).toEqual([[3,0],[3,3]])
        expect(messages[2].range).toEqual([[3,0],[3,0]])
        expect(messages[3].range).toEqual([[4,8],[4,11]])
        expect(messages[4].range).toEqual([[4,8],[4,11]])
        expect(messages[5].range).toEqual([[4,8],[4,9]])
        expect(messages[6].range).toEqual([[5,8],[5,11]])
        expect(messages[7].range).toEqual([[5,8],[5,11]])
        expect(messages[8].range).toEqual([[5,8],[5,9]])
        expect(messages[9].range).toEqual([[6,9],[6,12]])
        expect(messages[10].range).toEqual([[6,9],[6,12]])
        expect(messages[11].range).toEqual([[6,9],[6,10]])
        expect(messages[12].range).toEqual([[7,3],[7,6]])
        expect(messages[13].range).toEqual([[7,3],[7,6]])
        expect(messages[14].range).toEqual([[7,3],[7,4]])
        expect(messages[15].range).toEqual([[10,0],[10,3]])
        expect(messages[16].range).toEqual([[10,0],[10,3]])
        expect(messages[17].range).toEqual([[10,0],[10,0]])
        expect(messages[18].range).toEqual([[11,9],[11,12]])
        expect(messages[19].range).toEqual([[11,9],[11,12]])
        expect(messages[20].range).toEqual([[11,9],[11,10]])
        expect(messages[21].range).toEqual([[12,9],[12,12]])
        expect(messages[22].range).toEqual([[12,9],[12,12]])
        expect(messages[23].range).toEqual([[12,9],[12,10]])
        expect(messages[24].range).toEqual([[13,10],[13,13]])
        expect(messages[25].range).toEqual([[13,10],[13,13]])
        expect(messages[26].range).toEqual([[13,10],[13,11]])
        expect(messages[27].range).toEqual([[14,4],[14,7]])
        expect(messages[28].range).toEqual([[14,4],[14,7]])
        expect(messages[29].range).toEqual([[14,4],[14,5]])
        expect(messages[30].range).toEqual([[17,2],[17,5]])
        expect(messages[31].range).toEqual([[17,2],[17,5]])
        expect(messages[32].range).toEqual([[17,2],[17,3]])
        expect(messages[33].range).toEqual([[18,10],[18,13]])
        expect(messages[34].range).toEqual([[18,10],[18,13]])
        expect(messages[35].range).toEqual([[18,10],[18,11]])
        expect(messages[36].range).toEqual([[19,10],[19,13]])
        expect(messages[37].range).toEqual([[19,10],[19,13]])
        expect(messages[38].range).toEqual([[19,10],[19,11]])
        expect(messages[39].range).toEqual([[20,11],[20,14]])
        expect(messages[40].range).toEqual([[20,11],[20,14]])
        expect(messages[41].range).toEqual([[20,11],[20,12]])
        expect(messages[42].range).toEqual([[21,5],[21,8]])
        expect(messages[43].range).toEqual([[21,5],[21,8]])
        expect(messages[44].range).toEqual([[21,5],[21,6]])
        expect(messages[45].range).toEqual([[22,15],[22,16]])
        expect(messages[46].range).toEqual([[24,14],[24,15]])
