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
            expect(messages[j++].location.position).toEqual([[3,4],[3,5]])

            expect(messages[i++].excerpt).toBe('Argument 2 to "add" has incompatible type "str"; expected "int"  [arg-type]')
            expect(messages[j++].location.position).toEqual([[3,13],[3,14]])

            expect(messages[i++].excerpt).toBe('Argument 1 to "add" has incompatible type "str"; expected "int"  [arg-type]')
            expect(messages[j++].location.position).toEqual([[4,12],[4,13]])

            expect(messages[i++].excerpt).toBe('Argument 2 to "add" has incompatible type "str"; expected "int"  [arg-type]')
            expect(messages[j++].location.position).toEqual([[4,21],[4,22]])

            expect(messages[i++].excerpt).toBe('Argument 1 to "add" has incompatible type "str"; expected "int"  [arg-type]')
            expect(messages[j++].location.position).toEqual([[5,12],[5,13]])

            expect(messages[i++].excerpt).toBe('Argument 2 to "add" has incompatible type "str"; expected "int"  [arg-type]')
            expect(messages[j++].location.position).toEqual([[5,21],[5,22]])

            expect(messages[i++].excerpt).toBe('Argument 1 to "add" has incompatible type "str"; expected "int"  [arg-type]')
            expect(messages[j++].location.position).toEqual([[6,13],[6,14]])

            expect(messages[i++].excerpt).toBe('Argument 2 to "add" has incompatible type "str"; expected "int"  [arg-type]')
            expect(messages[j++].location.position).toEqual([[6,22],[6,23]])

            expect(messages[i++].excerpt).toBe('Argument 1 to "add" has incompatible type "str"; expected "int"  [arg-type]')
            expect(messages[j++].location.position).toEqual([[7,7],[7,8]])

            expect(messages[i++].excerpt).toBe('Argument 2 to "add" has incompatible type "str"; expected "int"  [arg-type]')
            expect(messages[j++].location.position).toEqual([[7,16],[7,17]])

            expect(messages[i++].excerpt).toBe('Argument 1 to "add" has incompatible type "str"; expected "int"  [arg-type]')
            expect(messages[j++].location.position).toEqual([[10,5],[10,6]])

            expect(messages[i++].excerpt).toBe('Argument 2 to "add" has incompatible type "str"; expected "int"  [arg-type]')
            expect(messages[j++].location.position).toEqual([[10,14],[10,15]])

            expect(messages[i++].excerpt).toBe('Argument 1 to "add" has incompatible type "str"; expected "int"  [arg-type]')
            expect(messages[j++].location.position).toEqual([[11,13],[11,14]])

            expect(messages[i++].excerpt).toBe('Argument 2 to "add" has incompatible type "str"; expected "int"  [arg-type]')
            expect(messages[j++].location.position).toEqual([[11,22],[11,23]])

            expect(messages[i++].excerpt).toBe('Argument 1 to "add" has incompatible type "str"; expected "int"  [arg-type]')
            expect(messages[j++].location.position).toEqual([[12,13],[12,14]])

            expect(messages[i++].excerpt).toBe('Argument 2 to "add" has incompatible type "str"; expected "int"  [arg-type]')
            expect(messages[j++].location.position).toEqual([[12,22],[12,23]])

            expect(messages[i++].excerpt).toBe('Argument 1 to "add" has incompatible type "str"; expected "int"  [arg-type]')
            expect(messages[j++].location.position).toEqual([[13,14],[13,15]])

            expect(messages[i++].excerpt).toBe('Argument 2 to "add" has incompatible type "str"; expected "int"  [arg-type]')
            expect(messages[j++].location.position).toEqual([[13,23],[13,24]])

            expect(messages[i++].excerpt).toBe('Argument 1 to "add" has incompatible type "str"; expected "int"  [arg-type]')
            expect(messages[j++].location.position).toEqual([[14,8],[14,9]])

            expect(messages[i++].excerpt).toBe('Argument 2 to "add" has incompatible type "str"; expected "int"  [arg-type]')
            expect(messages[j++].location.position).toEqual([[14,17],[14,18]])

            expect(messages[i++].excerpt).toBe('Argument 1 to "add" has incompatible type "str"; expected "int"  [arg-type]')
            expect(messages[j++].location.position).toEqual([[17,6],[17,7]])

            expect(messages[i++].excerpt).toBe('Argument 2 to "add" has incompatible type "str"; expected "int"  [arg-type]')
            expect(messages[j++].location.position).toEqual([[17,15],[17,16]])

            expect(messages[i++].excerpt).toBe('Argument 1 to "add" has incompatible type "str"; expected "int"  [arg-type]')
            expect(messages[j++].location.position).toEqual([[18,14],[18,15]])

            expect(messages[i++].excerpt).toBe('Argument 2 to "add" has incompatible type "str"; expected "int"  [arg-type]')
            expect(messages[j++].location.position).toEqual([[18,23],[18,24]])

            expect(messages[i++].excerpt).toBe('Argument 1 to "add" has incompatible type "str"; expected "int"  [arg-type]')
            expect(messages[j++].location.position).toEqual([[19,14],[19,15]])

            expect(messages[i++].excerpt).toBe('Argument 2 to "add" has incompatible type "str"; expected "int"  [arg-type]')
            expect(messages[j++].location.position).toEqual([[19,23],[19,24]])

            expect(messages[i++].excerpt).toBe('Argument 1 to "add" has incompatible type "str"; expected "int"  [arg-type]')
            expect(messages[j++].location.position).toEqual([[20,15],[20,16]])

            expect(messages[i++].excerpt).toBe('Argument 2 to "add" has incompatible type "str"; expected "int"  [arg-type]')
            expect(messages[j++].location.position).toEqual([[20,24],[20,25]])

            expect(messages[i++].excerpt).toBe('Argument 1 to "add" has incompatible type "str"; expected "int"  [arg-type]')
            expect(messages[j++].location.position).toEqual([[21,9],[21,10]])

            expect(messages[i++].excerpt).toBe('Argument 2 to "add" has incompatible type "str"; expected "int"  [arg-type]')
            expect(messages[j++].location.position).toEqual([[21,18],[21,19]])
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
            expect(messages[j++].location.position).toEqual([[8,0],[8,12]])
          else if ("lint_unexpectedunindent" == p_data.filename)

            # There are two variant of the message (Starting from Python version 3.8 the message changed slightly)
            expect(messages[i++].excerpt in ["unexpected unindent  [syntax]", "expected an indented block  [syntax]"]).toBe(true)
            # expect(messages[i++].excerpt).toBe('unexpected unindent  [syntax]')

            expect(messages[j++].location.position).toEqual([[5,0],[5,1]])
          else if ("lint_unindentdoesnotmatchanyouterindentationlevel" == p_data.filename)
            expect(messages[i++].excerpt).toBe('unindent does not match any outer indentation level  [syntax]')
            expect(messages[j++].location.position).toEqual([[5,0],[5,10]])
          else if ("lint_unsupportedoperandtypesfor" == p_data.filename)
            expect(messages[i++].excerpt).toBe('Unsupported operand types for + ("int" and "str")  [operator]')
            expect(messages[j++].location.position).toEqual([[3,12],[3,13]])

            expect(messages[i++].excerpt).toBe('Unsupported operand types for + ("int" and "str")  [operator]')
            expect(messages[j++].location.position).toEqual([[4,20],[4,21]])

            expect(messages[i++].excerpt).toBe('Unsupported operand types for + ("int" and "str")  [operator]')
            expect(messages[j++].location.position).toEqual([[5,20],[5,21]])

            expect(messages[i++].excerpt).toBe('Unsupported operand types for + ("int" and "str")  [operator]')
            expect(messages[j++].location.position).toEqual([[6,21],[6,22]])

            expect(messages[i++].excerpt).toBe('Unsupported operand types for + ("int" and "str")  [operator]')
            expect(messages[j++].location.position).toEqual([[7,15],[7,16]])

            expect(messages[i++].excerpt).toBe('Unsupported operand types for + ("int" and "str")  [operator]')
            expect(messages[j++].location.position).toEqual([[10,13],[10,14]])

            expect(messages[i++].excerpt).toBe('Unsupported operand types for + ("int" and "str")  [operator]')
            expect(messages[j++].location.position).toEqual([[11,21],[11,22]])

            expect(messages[i++].excerpt).toBe('Unsupported operand types for + ("int" and "str")  [operator]')
            expect(messages[j++].location.position).toEqual([[12,21],[12,22]])

            expect(messages[i++].excerpt).toBe('Unsupported operand types for + ("int" and "str")  [operator]')
            expect(messages[j++].location.position).toEqual([[13,22],[13,23]])

            expect(messages[i++].excerpt).toBe('Unsupported operand types for + ("int" and "str")  [operator]')
            expect(messages[j++].location.position).toEqual([[14,16],[14,17]])

            expect(messages[i++].excerpt).toBe('Unsupported operand types for + ("int" and "str")  [operator]')
            expect(messages[j++].location.position).toEqual([[17,14],[17,15]])

            expect(messages[i++].excerpt).toBe('Unsupported operand types for + ("int" and "str")  [operator]')
            expect(messages[j++].location.position).toEqual([[18,22],[18,23]])

            expect(messages[i++].excerpt).toBe('Unsupported operand types for + ("int" and "str")  [operator]')
            expect(messages[j++].location.position).toEqual([[19,22],[19,23]])

            expect(messages[i++].excerpt).toBe('Unsupported operand types for + ("int" and "str")  [operator]')
            expect(messages[j++].location.position).toEqual([[20,23],[20,24]])

            expect(messages[i++].excerpt).toBe('Unsupported operand types for + ("int" and "str")  [operator]')
            expect(messages[j++].location.position).toEqual([[21,17],[21,18]])

            expect(messages[i++].excerpt).toBe('Unsupported operand types for + ("int" and "str")  [operator]')
            expect(messages[j++].location.position).toEqual([[22,17],[22,18]])

            expect(messages[i++].excerpt).toBe('Unsupported operand types for + ("int" and "str")  [operator]')
            expect(messages[j++].location.position).toEqual([[24,16],[24,17]])

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
