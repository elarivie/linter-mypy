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
        expect(messages.length).toBe(17)
      it 'should have put the good attributes in each warnings', ->
        msg0 = 'Incompatible types in assignment (expression has type "str", variable has type "int")'
        msg1 = 'Use "-> None" if function does not return a value'
        msg = [msg0, msg1, msg0]
        severities = ['warning', 'warning', 'info']
        messages.forEach (item, index) ->
          expect(item.location.file).toMatch(badPath0Regex)
          expect(item.severity).toBe(severities[index %% 3])
          expect(item.excerpt).toBe(msg[index %% 3])
      it 'should have put the good range base on heuristic', ->
        #Before setting those expected location.position, visually make sure that the underlines of badindent1.py make sens.
        expect(messages[0].location.position).toEqual([[1,0],[1,1]])
        expect(messages[1].location.position).toEqual([[2,0],[2,1]])
        expect(messages[2].location.position).toEqual([[4,1],[4,2]])
        expect(messages[3].location.position).toEqual([[5,1],[5,2]])
        expect(messages[4].location.position).toEqual([[7,2],[7,3]])
        expect(messages[5].location.position).toEqual([[8,2],[8,3]])
        expect(messages[6].location.position).toEqual([[10,3],[10,4]])
        expect(messages[7].location.position).toEqual([[11,3],[11,4]])
        expect(messages[8].location.position).toEqual([[13,4],[13,5]])
        expect(messages[9].location.position).toEqual([[16,1],[16,2]])
        expect(messages[10].location.position).toEqual([[18,3],[18,4]])

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
        msg0 = 'Incompatible types in assignment (expression has type "str", variable has type "int")'
        msg1 = 'Function is missing a return type annotation'
        msg2 = 'Use "-> None" if function does not return a value'
        msg = [msg0, msg1, msg2]
        messages.forEach (item, index) ->
          expect(item.location.file).toMatch(badPath1Regex)
          expect(item.severity).toBe('warning')
          if index <= 43
            expect(item.excerpt).toBe(msg[index %% 3])
          else
            expect(item.excerpt).toBe(msg[2])
      it 'should have put the good range base on heuristic', ->
        #Before setting those expected location.position, visually make sure that the underlines of badindent1.py make sens.
        expect(messages[0].location.position).toEqual([[3,0],[3,3]])
        expect(messages[1].location.position).toEqual([[3,0],[3,3]])
        expect(messages[2].location.position).toEqual([[3,0],[3,1]])
        expect(messages[3].location.position).toEqual([[4,8],[4,11]])
        expect(messages[4].location.position).toEqual([[4,8],[4,11]])
        expect(messages[5].location.position).toEqual([[4,8],[4,9]])
        expect(messages[6].location.position).toEqual([[5,8],[5,11]])
        expect(messages[7].location.position).toEqual([[5,8],[5,11]])
        expect(messages[8].location.position).toEqual([[5,8],[5,9]])
        expect(messages[9].location.position).toEqual([[6,9],[6,12]])
        expect(messages[10].location.position).toEqual([[6,9],[6,12]])
        expect(messages[11].location.position).toEqual([[6,9],[6,10]])
        expect(messages[12].location.position).toEqual([[7,3],[7,6]])
        expect(messages[13].location.position).toEqual([[7,3],[7,6]])
        expect(messages[14].location.position).toEqual([[7,3],[7,4]])
        expect(messages[15].location.position).toEqual([[10,1],[10,4]])
        expect(messages[16].location.position).toEqual([[10,1],[10,4]])
        expect(messages[17].location.position).toEqual([[10,1],[10,2]])
        expect(messages[18].location.position).toEqual([[11,9],[11,12]])
        expect(messages[19].location.position).toEqual([[11,9],[11,12]])
        expect(messages[20].location.position).toEqual([[11,9],[11,10]])
        expect(messages[21].location.position).toEqual([[12,9],[12,12]])
        expect(messages[22].location.position).toEqual([[12,9],[12,12]])
        expect(messages[23].location.position).toEqual([[12,9],[12,10]])
        expect(messages[24].location.position).toEqual([[13,10],[13,13]])
        expect(messages[25].location.position).toEqual([[13,10],[13,13]])
        expect(messages[26].location.position).toEqual([[13,10],[13,11]])
        expect(messages[27].location.position).toEqual([[14,4],[14,7]])
        expect(messages[28].location.position).toEqual([[14,4],[14,7]])
        expect(messages[29].location.position).toEqual([[14,4],[14,5]])
        expect(messages[30].location.position).toEqual([[17,2],[17,5]])
        expect(messages[31].location.position).toEqual([[17,2],[17,5]])
        expect(messages[32].location.position).toEqual([[17,2],[17,3]])
        expect(messages[33].location.position).toEqual([[18,10],[18,13]])
        expect(messages[34].location.position).toEqual([[18,10],[18,13]])
        expect(messages[35].location.position).toEqual([[18,10],[18,11]])
        expect(messages[36].location.position).toEqual([[19,10],[19,13]])
        expect(messages[37].location.position).toEqual([[19,10],[19,13]])
        expect(messages[38].location.position).toEqual([[19,10],[19,11]])
        expect(messages[39].location.position).toEqual([[20,11],[20,14]])
        expect(messages[40].location.position).toEqual([[20,11],[20,14]])
        expect(messages[41].location.position).toEqual([[20,11],[20,12]])
        expect(messages[42].location.position).toEqual([[21,5],[21,8]])
        expect(messages[43].location.position).toEqual([[21,5],[21,8]])
        expect(messages[44].location.position).toEqual([[21,5],[21,6]])
        expect(messages[45].location.position).toEqual([[22,15],[22,16]])
        expect(messages[46].location.position).toEqual([[24,14],[24,15]])
