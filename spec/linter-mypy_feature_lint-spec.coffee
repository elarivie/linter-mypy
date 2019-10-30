#!/usr/bin/env coffee
#
# This spec file validates the handling of specific lint message:
#  * Make sure a given lint is correctly detected.
#  * Make sure the range and the attributes are correctly set.
#
#  If it fails:
#  * Visually validate the related fixture file
#  * Adjust the related heuristic/regex.

LinterMyPystyle = require '../lib/init'
path = require 'path'
{CompositeDisposable} = require 'atom'
helpers = require 'atom-linter'

test_pyfile = (p_data) ->
  describe "When linting the file: " + p_data.filename, ->
    pyPath = path.join(__dirname, 'fixtures', 'specificLint', p_data.filename + '.py')
    editor = null
    messages = null
    lint = undefined
    beforeEach -> #aka Before each it
      waitsForPromise -> atom.packages.activatePackage('linter-mypy')
      waitsForPromise -> atom.packages.activatePackage('language-python')
    beforeEach ->
      lint = require('../lib/init').provideLinter().lint
    beforeEach ->
      waitsForPromise ->
        atom.workspace.open(pyPath).then (e) ->
          editor = e
          messages = null
    it 'Then should be in the package list and activated', ->
      expect(atom.packages.isPackageLoaded('linter-mypy')).toBe true
      expect(atom.packages.isPackageLoaded('language-python')).toBe true
      expect(atom.packages.isPackageActive('linter-mypy')).toBe true
      expect(atom.packages.isPackageActive('language-python')).toBe true

    it 'Then should detect all the errors of the file: ' + p_data.filename, ->
      runs ->
        waitsForPromise -> lint(editor).then (msgs) ->
          messages = msgs
          expect(messages.length).toBe(p_data.lintcount)
          messages.forEach (item, index) ->
            expect(item.location.file).toMatch(new RegExp('^.+' + p_data.filename + '\\.py$', 'g'))
            expect(item.severity).toBe(p_data.severity)

          #Before setting the following expected values, visually make sure that the underlines make sens.
          i = 0
          j = 0

          if ("lint_argumenthasincompatibletype" == p_data.filename)
            expect(messages[i++].excerpt).toBe('Argument 1 to "add" has incompatible type "str"; expected "int"  [arg-type]')
            expect(messages[j++].location.position).toEqual([[3,0],[3,3]])

            expect(messages[i++].excerpt).toBe('Argument 2 to "add" has incompatible type "str"; expected "int"  [arg-type]')
            expect(messages[j++].location.position).toEqual([[3,0],[3,3]])

            expect(messages[i++].excerpt).toBe('Argument 1 to "add" has incompatible type "str"; expected "int"  [arg-type]')
            expect(messages[j++].location.position).toEqual([[4,8],[4,11]])

            expect(messages[i++].excerpt).toBe('Argument 2 to "add" has incompatible type "str"; expected "int"  [arg-type]')
            expect(messages[j++].location.position).toEqual([[4,8],[4,11]])

            expect(messages[i++].excerpt).toBe('Argument 1 to "add" has incompatible type "str"; expected "int"  [arg-type]')
            expect(messages[j++].location.position).toEqual([[5,8],[5,11]])

            expect(messages[i++].excerpt).toBe('Argument 2 to "add" has incompatible type "str"; expected "int"  [arg-type]')
            expect(messages[j++].location.position).toEqual([[5,8],[5,11]])

            expect(messages[i++].excerpt).toBe('Argument 1 to "add" has incompatible type "str"; expected "int"  [arg-type]')
            expect(messages[j++].location.position).toEqual([[6,9],[6,12]])

            expect(messages[i++].excerpt).toBe('Argument 2 to "add" has incompatible type "str"; expected "int"  [arg-type]')
            expect(messages[j++].location.position).toEqual([[6,9],[6,12]])

            expect(messages[i++].excerpt).toBe('Argument 1 to "add" has incompatible type "str"; expected "int"  [arg-type]')
            expect(messages[j++].location.position).toEqual([[7,3],[7,6]])

            expect(messages[i++].excerpt).toBe('Argument 2 to "add" has incompatible type "str"; expected "int"  [arg-type]')
            expect(messages[j++].location.position).toEqual([[7,3],[7,6]])

            expect(messages[i++].excerpt).toBe('Argument 1 to "add" has incompatible type "str"; expected "int"  [arg-type]')
            expect(messages[j++].location.position).toEqual([[10,1],[10,4]])

            expect(messages[i++].excerpt).toBe('Argument 2 to "add" has incompatible type "str"; expected "int"  [arg-type]')
            expect(messages[j++].location.position).toEqual([[10,1],[10,4]])

            expect(messages[i++].excerpt).toBe('Argument 1 to "add" has incompatible type "str"; expected "int"  [arg-type]')
            expect(messages[j++].location.position).toEqual([[11,9],[11,12]])

            expect(messages[i++].excerpt).toBe('Argument 2 to "add" has incompatible type "str"; expected "int"  [arg-type]')
            expect(messages[j++].location.position).toEqual([[11,9],[11,12]])

            expect(messages[i++].excerpt).toBe('Argument 1 to "add" has incompatible type "str"; expected "int"  [arg-type]')
            expect(messages[j++].location.position).toEqual([[12,9],[12,12]])

            expect(messages[i++].excerpt).toBe('Argument 2 to "add" has incompatible type "str"; expected "int"  [arg-type]')
            expect(messages[j++].location.position).toEqual([[12,9],[12,12]])

            expect(messages[i++].excerpt).toBe('Argument 1 to "add" has incompatible type "str"; expected "int"  [arg-type]')
            expect(messages[j++].location.position).toEqual([[13,10],[13,13]])

            expect(messages[i++].excerpt).toBe('Argument 2 to "add" has incompatible type "str"; expected "int"  [arg-type]')
            expect(messages[j++].location.position).toEqual([[13,10],[13,13]])

            expect(messages[i++].excerpt).toBe('Argument 1 to "add" has incompatible type "str"; expected "int"  [arg-type]')
            expect(messages[j++].location.position).toEqual([[14,4],[14,7]])

            expect(messages[i++].excerpt).toBe('Argument 2 to "add" has incompatible type "str"; expected "int"  [arg-type]')
            expect(messages[j++].location.position).toEqual([[14,4],[14,7]])

            expect(messages[i++].excerpt).toBe('Argument 1 to "add" has incompatible type "str"; expected "int"  [arg-type]')
            expect(messages[j++].location.position).toEqual([[17,2],[17,5]])

            expect(messages[i++].excerpt).toBe('Argument 2 to "add" has incompatible type "str"; expected "int"  [arg-type]')
            expect(messages[j++].location.position).toEqual([[17,2],[17,5]])

            expect(messages[i++].excerpt).toBe('Argument 1 to "add" has incompatible type "str"; expected "int"  [arg-type]')
            expect(messages[j++].location.position).toEqual([[18,10],[18,13]])

            expect(messages[i++].excerpt).toBe('Argument 2 to "add" has incompatible type "str"; expected "int"  [arg-type]')
            expect(messages[j++].location.position).toEqual([[18,10],[18,13]])

            expect(messages[i++].excerpt).toBe('Argument 1 to "add" has incompatible type "str"; expected "int"  [arg-type]')
            expect(messages[j++].location.position).toEqual([[19,10],[19,13]])

            expect(messages[i++].excerpt).toBe('Argument 2 to "add" has incompatible type "str"; expected "int"  [arg-type]')
            expect(messages[j++].location.position).toEqual([[19,10],[19,13]])

            expect(messages[i++].excerpt).toBe('Argument 1 to "add" has incompatible type "str"; expected "int"  [arg-type]')
            expect(messages[j++].location.position).toEqual([[20,11],[20,14]])

            expect(messages[i++].excerpt).toBe('Argument 2 to "add" has incompatible type "str"; expected "int"  [arg-type]')
            expect(messages[j++].location.position).toEqual([[20,11],[20,14]])

            expect(messages[i++].excerpt).toBe('Argument 1 to "add" has incompatible type "str"; expected "int"  [arg-type]')
            expect(messages[j++].location.position).toEqual([[21,5],[21,8]])

            expect(messages[i++].excerpt).toBe('Argument 2 to "add" has incompatible type "str"; expected "int"  [arg-type]')
            expect(messages[j++].location.position).toEqual([[21,5],[21,8]])
          else if ("lint_inconsistentuseoftabsandspacesinindentation" == p_data.filename)
            expect(messages[i++].excerpt).toBe('inconsistent use of tabs and spaces in indentation  [syntax]')
            expect(messages[j++].location.position).toEqual([[6,0],[6,8]])
          else if ("lint_invalidsyntax" == p_data.filename)
            expect(messages[i++].excerpt).toBe('invalid syntax  [syntax]')
            expect(messages[j++].location.position).toEqual([[4,0],[4,10]])
          else if ("lint_nameisnotdefined" == p_data.filename)
            expect(messages[i++].excerpt).toBe('Name \'efgh\' is not defined  [name-defined]')
            expect(messages[j++].location.position).toEqual([[4,8],[4,12]])

            expect(messages[i++].excerpt).toBe('Name \'ijkl\' is not defined  [name-defined]')
            expect(messages[j++].location.position).toEqual([[5,1],[5,5]])
          else if ("lint_revealtype" == p_data.filename)
            expect(messages[i++].excerpt).toBe('Revealed type is \'builtins.int\'')
            expect(messages[j++].location.position).toEqual([[8,0],[8,11]])
          else if ("lint_unexpectedunindent" == p_data.filename)
            expect(messages[i++].excerpt).toBe('unexpected unindent  [syntax]')
            expect(messages[j++].location.position).toEqual([[5,0],[5,1]])
          else if ("lint_unindentdoesnotmatchanyouterindentationlevel" == p_data.filename)
            expect(messages[i++].excerpt).toBe('unindent does not match any outer indentation level  [syntax]')
            expect(messages[j++].location.position).toEqual([[5,0],[5,10]])
          else if ("lint_unsupportedoperandtypesfor" == p_data.filename)
            expect(messages[i++].excerpt).toBe('Unsupported operand types for + ("int" and "str")  [operator]')
            expect(messages[j++].location.position).toEqual([[3,0],[3,1]])

            expect(messages[i++].excerpt).toBe('Unsupported operand types for + ("int" and "str")  [operator]')
            expect(messages[j++].location.position).toEqual([[4,8],[4,9]])

            expect(messages[i++].excerpt).toBe('Unsupported operand types for + ("int" and "str")  [operator]')
            expect(messages[j++].location.position).toEqual([[5,8],[5,9]])

            expect(messages[i++].excerpt).toBe('Unsupported operand types for + ("int" and "str")  [operator]')
            expect(messages[j++].location.position).toEqual([[6,9],[6,10]])

            expect(messages[i++].excerpt).toBe('Unsupported operand types for + ("int" and "str")  [operator]')
            expect(messages[j++].location.position).toEqual([[7,3],[7,4]])

            expect(messages[i++].excerpt).toBe('Unsupported operand types for + ("int" and "str")  [operator]')
            expect(messages[j++].location.position).toEqual([[10,1],[10,2]])

            expect(messages[i++].excerpt).toBe('Unsupported operand types for + ("int" and "str")  [operator]')
            expect(messages[j++].location.position).toEqual([[11,9],[11,10]])

            expect(messages[i++].excerpt).toBe('Unsupported operand types for + ("int" and "str")  [operator]')
            expect(messages[j++].location.position).toEqual([[12,9],[12,10]])

            expect(messages[i++].excerpt).toBe('Unsupported operand types for + ("int" and "str")  [operator]')
            expect(messages[j++].location.position).toEqual([[13,10],[13,11]])

            expect(messages[i++].excerpt).toBe('Unsupported operand types for + ("int" and "str")  [operator]')
            expect(messages[j++].location.position).toEqual([[14,4],[14,5]])

            expect(messages[i++].excerpt).toBe('Unsupported operand types for + ("int" and "str")  [operator]')
            expect(messages[j++].location.position).toEqual([[17,2],[17,3]])

            expect(messages[i++].excerpt).toBe('Unsupported operand types for + ("int" and "str")  [operator]')
            expect(messages[j++].location.position).toEqual([[18,10],[18,11]])

            expect(messages[i++].excerpt).toBe('Unsupported operand types for + ("int" and "str")  [operator]')
            expect(messages[j++].location.position).toEqual([[19,10],[19,11]])

            expect(messages[i++].excerpt).toBe('Unsupported operand types for + ("int" and "str")  [operator]')
            expect(messages[j++].location.position).toEqual([[20,11],[20,12]])

            expect(messages[i++].excerpt).toBe('Unsupported operand types for + ("int" and "str")  [operator]')
            expect(messages[j++].location.position).toEqual([[21,5],[21,6]])

            expect(messages[i++].excerpt).toBe('Unsupported operand types for + ("int" and "str")  [operator]')
            expect(messages[j++].location.position).toEqual([[22,15],[22,16]])

            expect(messages[i++].excerpt).toBe('Unsupported operand types for + ("int" and "str")  [operator]')
            expect(messages[j++].location.position).toEqual([[24,14],[24,15]])

          else
            #Safety
            expect(false).toEqual(true)

          #Safety
          expect(i).toEqual(p_data.lintcount)
          expect(j).toEqual(p_data.lintcount)
          editor.destroy()
          editor = null

# Given a fully installed and activated linter-mypy package.

describe "linter-mypy ... lint heuristics.", ->

  testdata = [
    {
      filename: "lint_argumenthasincompatibletype",
      lintcount: 30
      severity: "warning"
    },
    {
      filename: "lint_inconsistentuseoftabsandspacesinindentation",
      lintcount: 1
      severity: "error"
    },
    {
      filename: "lint_invalidsyntax",
      lintcount: 1
      severity: "error"
    },
    {
      filename: "lint_nameisnotdefined",
      lintcount: 2
      severity: "error"
    },
    {
      filename: "lint_revealtype",
      lintcount: 1
      severity: "info"
    },
    {
      filename: "lint_unexpectedunindent",
      lintcount: 1
      severity: "error"
    },
    {
      filename: "lint_unindentdoesnotmatchanyouterindentationlevel",
      lintcount: 1
      severity: "error"
    },
    {
      filename: "lint_unsupportedoperandtypesfor",
      lintcount: 17
      severity: "warning"
    }
  ]
  for c_currFile in testdata
    test_pyfile(c_currFile)
