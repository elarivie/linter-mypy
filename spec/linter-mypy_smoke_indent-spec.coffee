#!/usr/bin/env coffee
#
# This spec file validates:
#  * That warnings are correctly reported mainly about the underline location.
#
#  If it fails:
#  * Visually validate the underline of the related fixtures file.
#  * Adjust the related heuristic/regex.

LinterMyPystyle = require '../lib/init'
path = require 'path'
{CompositeDisposable} = require 'atom'
helpers = require 'atom-linter'

badPath0 = path.join(__dirname, 'fixtures', 'smoke', 'bad', 'badIndent0.py')
badPath0Regex = /.+badIndent0\.py/

badPath1 = path.join(__dirname, 'fixtures', 'smoke', 'bad', 'badIndent1.py')
badPath1Regex = /.+badIndent1\.py/

describe "linter-mypy ... Linting smoke test (indentation)", ->
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

  describe "reads badindent0.py", ->
    editor = null
    beforeEach ->
      waitsForPromise ->
        atom.workspace.open(badPath0).then (e) ->
          editor = e

    describe "validates reported warnings", ->
      messages = null
      beforeEach ->
        waitsForPromise ->
          lint(editor).then (msgs) ->
            messages = msgs
      it 'should have detected all the errors', ->
        expect(messages.length).toBe(18)
      it 'should have put the good attributes in each warnings', ->
        msg0 = 'Incompatible types in assignment (expression has type "str", variable has type "int")  [assignment]'
        msg1 = 'Function is missing a return type annotation  [no-untyped-def]'
        msg2 = 'Use "-> None" if function does not return a value'
        msg = [msg0, msg1, msg2]
        severities = ['warning', 'warning', 'info']
        messages.forEach (item, index) ->
          expect(item.location.file).toMatch(badPath0Regex)
          expect(item.severity).toBe(severities[index %% 3])
          expect(item.excerpt).toBe(msg[index %% 3])
      it 'should have put the good range base on heuristic', ->
        #Before setting those expected location.position, visually make sure that the underlines of badindent1.py make sens.
        expect(messages[0].location.position).toEqual([[1,6],[1,7]])
        expect(messages[1].location.position).toEqual([[2,0],[2,1]])
        expect(messages[2].location.position).toEqual([[2,0],[2,1]])
        expect(messages[3].location.position).toEqual([[4,7],[4,8]])
        expect(messages[4].location.position).toEqual([[5,1],[5,2]])
        expect(messages[5].location.position).toEqual([[5,1],[5,2]])
        expect(messages[6].location.position).toEqual([[7,8],[7,9]])
        expect(messages[7].location.position).toEqual([[8,2],[8,3]])
        expect(messages[8].location.position).toEqual([[8,2],[8,3]])
        expect(messages[9].location.position).toEqual([[10,9],[10,10]])
        expect(messages[10].location.position).toEqual([[11,3],[11,4]])

  describe "reads badindent1.py", ->
    editor = null
    beforeEach ->
      waitsForPromise ->
        atom.workspace.open(badPath1).then (e) ->
          editor = e

    describe "validates reported warnings", ->
      messages = null
      beforeEach ->
        waitsForPromise ->
          lint(editor).then (msgs) -> messages = msgs
      it 'should have detected all the errors', ->
        expect(messages.length).toBe(47)
      it 'should have put the good attributes in each warnings', ->
        msg0 = 'Argument 1 to "add" has incompatible type "str"; expected "int"  [arg-type]'
        msg1 = 'Argument 2 to "add" has incompatible type "str"; expected "int"  [arg-type]'
        msg2 = 'Unsupported operand types for + ("int" and "str")  [operator]'
        msg = [msg0, msg1, msg2]
        messages.forEach (item, index) ->
          expect(item.location.file).toMatch(badPath1Regex)
          expect(item.severity).toBe('warning')
          if index <= 44
            expect(item.excerpt).toBe(msg[index %% 3])
          else
            expect(item.excerpt).toBe(msg[2])
      it 'should have put the good range base on heuristic', ->
        #Before setting those expected location.position, visually make sure that the underlines of badindent1.py make sens.
        expect(messages[0].location.position).toEqual([[3,4],[3,5]])
        expect(messages[1].location.position).toEqual([[3,13],[3,14]])
        expect(messages[2].location.position).toEqual([[3,24],[3,25]])
        expect(messages[3].location.position).toEqual([[4,12],[4,13]])
        expect(messages[4].location.position).toEqual([[4,21],[4,22]])
        expect(messages[5].location.position).toEqual([[4,32],[4,33]])
        expect(messages[6].location.position).toEqual([[5,12],[5,13]])
        expect(messages[7].location.position).toEqual([[5,21],[5,22]])
        expect(messages[8].location.position).toEqual([[5,32],[5,33]])
        expect(messages[9].location.position).toEqual([[6,13],[6,14]])
        expect(messages[10].location.position).toEqual([[6,22],[6,23]])
        expect(messages[11].location.position).toEqual([[6,33],[6,34]])
        expect(messages[12].location.position).toEqual([[7,7],[7,8]])
        expect(messages[13].location.position).toEqual([[7,16],[7,17]])
        expect(messages[14].location.position).toEqual([[7,27],[7,28]])
        expect(messages[15].location.position).toEqual([[10,5],[10,6]])
        expect(messages[16].location.position).toEqual([[10,14],[10,15]])
        expect(messages[17].location.position).toEqual([[10,25],[10,26]])
        expect(messages[18].location.position).toEqual([[11,13],[11,14]])
        expect(messages[19].location.position).toEqual([[11,22],[11,23]])
        expect(messages[20].location.position).toEqual([[11,33],[11,34]])
        expect(messages[21].location.position).toEqual([[12,13],[12,14]])
        expect(messages[22].location.position).toEqual([[12,22],[12,23]])
        expect(messages[23].location.position).toEqual([[12,33],[12,34]])
        expect(messages[24].location.position).toEqual([[13,14],[13,15]])
        expect(messages[25].location.position).toEqual([[13,23],[13,24]])
        expect(messages[26].location.position).toEqual([[13,34],[13,35]])
        expect(messages[27].location.position).toEqual([[14,8],[14,9]])
        expect(messages[28].location.position).toEqual([[14,17],[14,18]])
        expect(messages[29].location.position).toEqual([[14,28],[14,29]])
        expect(messages[30].location.position).toEqual([[17,6],[17,7]])
        expect(messages[31].location.position).toEqual([[17,15],[17,16]])
        expect(messages[32].location.position).toEqual([[17,26],[17,27]])
        expect(messages[33].location.position).toEqual([[18,14],[18,15]])
        expect(messages[34].location.position).toEqual([[18,23],[18,24]])
        expect(messages[35].location.position).toEqual([[18,34],[18,35]])
        expect(messages[36].location.position).toEqual([[19,14],[19,15]])
        expect(messages[37].location.position).toEqual([[19,23],[19,24]])
        expect(messages[38].location.position).toEqual([[19,34],[19,35]])
        expect(messages[39].location.position).toEqual([[20,15],[20,16]])
        expect(messages[40].location.position).toEqual([[20,24],[20,25]])
        expect(messages[41].location.position).toEqual([[20,35],[20,36]])
        expect(messages[42].location.position).toEqual([[21,9],[21,10]])
        expect(messages[43].location.position).toEqual([[21,18],[21,19]])
        expect(messages[44].location.position).toEqual([[21,29],[21,30]])
        expect(messages[45].location.position).toEqual([[22,17],[22,18]])
        expect(messages[46].location.position).toEqual([[24,16],[24,17]])
