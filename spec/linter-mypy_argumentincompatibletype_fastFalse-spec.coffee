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
        expect(messages.length).toBe(47)
      it 'should have put the good attributes in each warnings', ->
        msg0 = 'Argument 1 to "add" has incompatible type "str"; expected "int"'
        msg1 = 'Argument 2 to "add" has incompatible type "str"; expected "int"'
        msg2 = 'Unsupported operand types for + ("int" and "str")'
        msg = [msg0, msg1, msg2]
        messages.forEach (item, index) ->
          expect(item.location.file).toMatch(badPath0Regex)
          expect(item.severity).toBe('warning')
          if index <= 43
            expect(item.excerpt).toBe(msg[index %% 3])
          else
            expect(item.excerpt).toBe(msg[2])
      it 'should have put the good range base on heuristic', ->
        #Before setting those expected location.position, visually make sure that the underlines of bad0.py make sens.
        expect(messages[0].location.position).toEqual([[3,0],[3,3]])
        expect(messages[1].location.position).toEqual([[3,0],[3,3]])
        expect(messages[2].location.position).toEqual([[3,22],[3,23]])
        expect(messages[3].location.position).toEqual([[4,8],[4,11]])
        expect(messages[4].location.position).toEqual([[4,8],[4,11]])
        expect(messages[5].location.position).toEqual([[4,30],[4,31]])
        expect(messages[6].location.position).toEqual([[5,8],[5,11]])
        expect(messages[7].location.position).toEqual([[5,8],[5,11]])
        expect(messages[8].location.position).toEqual([[5,30],[5,31]])
        expect(messages[9].location.position).toEqual([[6,9],[6,12]])
        expect(messages[10].location.position).toEqual([[6,9],[6,12]])
        expect(messages[11].location.position).toEqual([[6,31],[6,32]])
        expect(messages[12].location.position).toEqual([[7,3],[7,6]])
        expect(messages[13].location.position).toEqual([[7,3],[7,6]])
        expect(messages[14].location.position).toEqual([[7,25],[7,26]])
        expect(messages[15].location.position).toEqual([[10,1],[10,4]])
        expect(messages[16].location.position).toEqual([[10,1],[10,4]])
        expect(messages[17].location.position).toEqual([[10,23],[10,24]])
        expect(messages[18].location.position).toEqual([[11,9],[11,12]])
        expect(messages[19].location.position).toEqual([[11,9],[11,12]])
        expect(messages[20].location.position).toEqual([[11,31],[11,32]])
        expect(messages[21].location.position).toEqual([[12,9],[12,12]])
        expect(messages[22].location.position).toEqual([[12,9],[12,12]])
        expect(messages[23].location.position).toEqual([[12,31],[12,32]])
        expect(messages[24].location.position).toEqual([[13,10],[13,13]])
        expect(messages[25].location.position).toEqual([[13,10],[13,13]])
        expect(messages[26].location.position).toEqual([[13,32],[13,33]])
        expect(messages[27].location.position).toEqual([[14,4],[14,7]])
        expect(messages[28].location.position).toEqual([[14,4],[14,7]])
        expect(messages[29].location.position).toEqual([[14,26],[14,27]])
        expect(messages[30].location.position).toEqual([[17,2],[17,5]])
        expect(messages[31].location.position).toEqual([[17,2],[17,5]])
        expect(messages[32].location.position).toEqual([[17,24],[17,25]])
        expect(messages[33].location.position).toEqual([[18,10],[18,13]])
        expect(messages[34].location.position).toEqual([[18,10],[18,13]])
        expect(messages[35].location.position).toEqual([[18,32],[18,33]])
        expect(messages[36].location.position).toEqual([[19,10],[19,13]])
        expect(messages[37].location.position).toEqual([[19,10],[19,13]])
        expect(messages[38].location.position).toEqual([[19,32],[19,33]])
        expect(messages[39].location.position).toEqual([[20,11],[20,14]])
        expect(messages[40].location.position).toEqual([[20,11],[20,14]])
        expect(messages[41].location.position).toEqual([[20,33],[20,34]])
        expect(messages[42].location.position).toEqual([[21,5],[21,8]])
        expect(messages[43].location.position).toEqual([[21,5],[21,8]])
        expect(messages[44].location.position).toEqual([[21,27],[21,28]])
        expect(messages[45].location.position).toEqual([[22,15],[22,16]])
        expect(messages[46].location.position).toEqual([[24,14],[24,15]])
