#!/usr/bin/env coffee
#
# This spec file validates:
#  * That the settings are correctly implemented.
#
#  If it fails:
#  * Validate the settings declaration & observation.

LinterMyPystyle = require '../lib/init'
path = require 'path'
{CompositeDisposable} = require 'atom'
helpers = require 'atom-linter'

originalPythonExecutable = atom.config.get('linter-mypy.executablePath')
pyPath = path.join(__dirname, 'fixtures', 'integration', 'aFile.py')
pseudoPythonExecutable = path.join(__dirname, 'fixtures', 'integration', 'echo_stdout_args_lint.sh')

describe "linter-mypy ... settings.", ->
  lint = undefined
  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage('linter-mypy')
    waitsForPromise ->
      atom.packages.activatePackage('language-python')
  beforeEach ->
    lint = require('../lib/init').provideLinter().lint
    atom.config.set('linter-mypy.executablePath', pseudoPythonExecutable)

  afterEach ->
    atom.config.set('linter-mypy.executablePath', originalPythonExecutable)

  it 'should be in the package list', ->
    expect(atom.packages.isPackageLoaded('linter-mypy')).toBe true

  it 'should have activated the package', ->
    expect(atom.packages.isPackageActive('linter-mypy')).toBe true

  describe "lint", ->
    editor = null
    beforeEach ->
      waitsForPromise ->
        atom.workspace.open(pyPath).then (e) ->
          editor = e

    describe "With the setting: disallowUntypedCalls", ->
      settingName = "linter-mypy.disallowUntypedCalls"
      describe 'Set to True', ->
        oldValue = atom.config.get(settingName)
        messages = null
        beforeEach ->
          atom.config.set(settingName, true)
          waitsForPromise ->
            lint(editor).then (msgs) ->
              messages = msgs
        it 'Adds the expected arguments', ->
          expect(messages.length).toBe(1)
          expect(messages[0].excerpt).toContain(" --disallow-untyped-calls ")
          expect(messages[0].excerpt).not.toContain(" --allow-untyped-calls ")
          atom.config.set(settingName, oldValue)
      describe 'Set to False', ->
        oldValue = atom.config.get(settingName)
        messages = null
        beforeEach ->
          atom.config.set(settingName, false)
          waitsForPromise ->
            lint(editor).then (msgs) ->
              messages = msgs
        it 'Adds the expected arguments', ->
          expect(messages.length).toBe(1)
          expect(messages[0].excerpt).not.toContain(" --disallow-untyped-calls ")
          expect(messages[0].excerpt).toContain(" --allow-untyped-calls ")
          atom.config.set(settingName, oldValue)

    describe "With the setting: disallowUntypedGlobals", ->
      settingName = "linter-mypy.disallowUntypedGlobals"
      describe 'Set to True', ->
        oldValue = atom.config.get(settingName)
        messages = null
        beforeEach ->
          atom.config.set(settingName, true)
          waitsForPromise ->
            lint(editor).then (msgs) ->
              messages = msgs
        it 'Adds the expected arguments', ->
          expect(messages.length).toBe(1)
          expect(messages[0].excerpt).toContain(" --disallow-untyped-globals ")
          expect(messages[0].excerpt).not.toContain(" --allow-untyped-globals ")
          atom.config.set(settingName, oldValue)
      describe 'Set to False', ->
        oldValue = atom.config.get(settingName)
        messages = null
        beforeEach ->
          atom.config.set(settingName, false)
          waitsForPromise ->
            lint(editor).then (msgs) ->
              messages = msgs
        it 'Adds the expected arguments', ->
          expect(messages.length).toBe(1)
          expect(messages[0].excerpt).not.toContain(" --disallow-untyped-globals ")
          expect(messages[0].excerpt).toContain(" --allow-untyped-globals ")
          atom.config.set(settingName, oldValue)

    describe "With the setting: disallowRedefinition", ->
      settingName = "linter-mypy.disallowRedefinition"
      describe 'Set to True', ->
        oldValue = atom.config.get(settingName)
        messages = null
        beforeEach ->
          atom.config.set(settingName, true)
          waitsForPromise ->
            lint(editor).then (msgs) ->
              messages = msgs
        it 'Adds the expected arguments', ->
          expect(messages.length).toBe(1)
          expect(messages[0].excerpt).toContain(" --disallow-redefinition ")
          expect(messages[0].excerpt).not.toContain(" --allow-redefinition ")
          atom.config.set(settingName, oldValue)
      describe 'Set to False', ->
        oldValue = atom.config.get(settingName)
        messages = null
        beforeEach ->
          atom.config.set(settingName, false)
          waitsForPromise ->
            lint(editor).then (msgs) ->
              messages = msgs
        it 'Adds the expected arguments', ->
          expect(messages.length).toBe(1)
          expect(messages[0].excerpt).not.toContain(" --disallow-redefinition ")
          expect(messages[0].excerpt).toContain(" --allow-redefinition ")
          atom.config.set(settingName, oldValue)

    describe "With the setting: strictEquality", ->
      settingName = "linter-mypy.strictEquality"
      describe 'Set to True', ->
        oldValue = atom.config.get(settingName)
        messages = null
        beforeEach ->
          atom.config.set(settingName, true)
          waitsForPromise ->
            lint(editor).then (msgs) ->
              messages = msgs
        it 'Adds the expected arguments', ->
          expect(messages.length).toBe(1)
          expect(messages[0].excerpt).toContain(" --strict-equality ")
          expect(messages[0].excerpt).not.toContain(" --no-strict-equality ")
          atom.config.set(settingName, oldValue)
      describe 'Set to False', ->
        oldValue = atom.config.get(settingName)
        messages = null
        beforeEach ->
          atom.config.set(settingName, false)
          waitsForPromise ->
            lint(editor).then (msgs) ->
              messages = msgs
        it 'Adds the expected arguments', ->
          expect(messages.length).toBe(1)
          expect(messages[0].excerpt).toContain(" --no-strict-equality ")
          expect(messages[0].excerpt).not.toContain(" --strict-equality ")
          atom.config.set(settingName, oldValue)

    describe "With the setting: namespacePackages", ->
      settingName = "linter-mypy.namespacePackages"
      describe 'Set to True', ->
        oldValue = atom.config.get(settingName)
        messages = null
        beforeEach ->
          atom.config.set(settingName, true)
          waitsForPromise ->
            lint(editor).then (msgs) ->
              messages = msgs
        it 'Adds the expected arguments', ->
          expect(messages.length).toBe(1)
          expect(messages[0].excerpt).toContain(" --namespace-packages ")
          expect(messages[0].excerpt).not.toContain(" --no-namespace-packages ")
          atom.config.set(settingName, oldValue)
      describe 'Set to False', ->
        oldValue = atom.config.get(settingName)
        messages = null
        beforeEach ->
          atom.config.set(settingName, false)
          waitsForPromise ->
            lint(editor).then (msgs) ->
              messages = msgs
        it 'Adds the expected arguments', ->
          expect(messages.length).toBe(1)
          expect(messages[0].excerpt).not.toContain(" --namespace-packages ")
          expect(messages[0].excerpt).toContain(" --no-namespace-packages ")
          atom.config.set(settingName, oldValue)

    describe "With the setting: disallowUntypedDefs", ->
      settingName = "linter-mypy.disallowUntypedDefs"
      describe 'Set to True', ->
        oldValue = atom.config.get(settingName)
        messages = null
        beforeEach ->
          atom.config.set(settingName, true)
          waitsForPromise ->
            lint(editor).then (msgs) ->
              messages = msgs
        it 'Adds the expected arguments', ->
          expect(messages.length).toBe(1)
          expect(messages[0].excerpt).toContain(" --disallow-untyped-defs ")
          expect(messages[0].excerpt).not.toContain(" --allow-untyped-defs ")
          atom.config.set(settingName, oldValue)
      describe 'Set to False', ->
        oldValue = atom.config.get(settingName)
        messages = null
        beforeEach ->
          atom.config.set(settingName, false)
          waitsForPromise ->
            lint(editor).then (msgs) ->
              messages = msgs
        it 'Adds the expected arguments', ->
          expect(messages.length).toBe(1)
          expect(messages[0].excerpt).not.toContain(" --disallow-untyped-defs ")
          expect(messages[0].excerpt).toContain(" --allow-untyped-defs ")
          atom.config.set(settingName, oldValue)

    describe "With the setting: disallowIncompleteDefs", ->
      settingName = "linter-mypy.disallowIncompleteDefs"
      describe 'Set to True', ->
        oldValue = atom.config.get(settingName)
        messages = null
        beforeEach ->
          atom.config.set(settingName, true)
          waitsForPromise ->
            lint(editor).then (msgs) ->
              messages = msgs
        it 'Adds the expected arguments', ->
          expect(messages.length).toBe(1)
          expect(messages[0].excerpt).toContain(" --disallow-incomplete-defs ")
          expect(messages[0].excerpt).not.toContain(" --allow-incomplete-defs ")
          atom.config.set(settingName, oldValue)
      describe 'Set to False', ->
        oldValue = atom.config.get(settingName)
        messages = null
        beforeEach ->
          atom.config.set(settingName, false)
          waitsForPromise ->
            lint(editor).then (msgs) ->
              messages = msgs
        it 'Adds the expected arguments', ->
          expect(messages.length).toBe(1)
          expect(messages[0].excerpt).not.toContain(" --disallow-incomplete-defs ")
          expect(messages[0].excerpt).toContain(" --allow-incomplete-defs ")
          atom.config.set(settingName, oldValue)

    describe "With the setting: checkUntypedDefs", ->
      settingName = "linter-mypy.checkUntypedDefs"
      describe 'Set to True', ->
        oldValue = atom.config.get(settingName)
        messages = null
        beforeEach ->
          atom.config.set(settingName, true)
          waitsForPromise ->
            lint(editor).then (msgs) ->
              messages = msgs
        it 'Adds the expected arguments', ->
          expect(messages.length).toBe(1)
          expect(messages[0].excerpt).toContain(" --check-untyped-defs ")
          expect(messages[0].excerpt).not.toContain(" --no-check-untyped-defs ")
          atom.config.set(settingName, oldValue)
      describe 'Set to False', ->
        oldValue = atom.config.get(settingName)
        messages = null
        beforeEach ->
          atom.config.set(settingName, false)
          waitsForPromise ->
            lint(editor).then (msgs) ->
              messages = msgs
        it 'Adds the expected arguments', ->
          expect(messages.length).toBe(1)
          expect(messages[0].excerpt).not.toContain(" --check-untyped-defs ")
          expect(messages[0].excerpt).toContain(" --no-check-untyped-defs ")
          atom.config.set(settingName, oldValue)

    describe "With the setting: warnIncompleteStub", ->
      settingName = "linter-mypy.warnIncompleteStub"
      describe 'Set to True', ->
        oldValue = atom.config.get(settingName)
        messages = null
        beforeEach ->
          atom.config.set(settingName, true)
          waitsForPromise ->
            lint(editor).then (msgs) ->
              messages = msgs
        it 'Adds the expected arguments', ->
          expect(messages.length).toBe(1)
          expect(messages[0].excerpt).toContain(" --warn-incomplete-stub ")
          expect(messages[0].excerpt).not.toContain(" --no-warn-incomplete-stub ")
          atom.config.set(settingName, oldValue)
      describe 'Set to False', ->
        oldValue = atom.config.get(settingName)
        messages = null
        beforeEach ->
          atom.config.set(settingName, false)
          waitsForPromise ->
            lint(editor).then (msgs) ->
              messages = msgs
        it 'Adds the expected arguments', ->
          expect(messages.length).toBe(1)
          expect(messages[0].excerpt).not.toContain(" --warn-incomplete-stub ")
          expect(messages[0].excerpt).toContain(" --no-warn-incomplete-stub ")
          atom.config.set(settingName, oldValue)

    describe "With the setting: disallowUntypedDecorators", ->
      settingName = "linter-mypy.disallowUntypedDecorators"
      describe 'Set to True', ->
        oldValue = atom.config.get(settingName)
        messages = null
        beforeEach ->
          atom.config.set(settingName, true)
          waitsForPromise ->
            lint(editor).then (msgs) ->
              messages = msgs
        it 'Adds the expected arguments', ->
          expect(messages.length).toBe(1)
          expect(messages[0].excerpt).toContain(" --disallow-untyped-decorators ")
          expect(messages[0].excerpt).not.toContain(" --allow-untyped-decorators ")
          atom.config.set(settingName, oldValue)
      describe 'Set to False', ->
        oldValue = atom.config.get(settingName)
        messages = null
        beforeEach ->
          atom.config.set(settingName, false)
          waitsForPromise ->
            lint(editor).then (msgs) ->
              messages = msgs
        it 'Adds the expected arguments', ->
          expect(messages.length).toBe(1)
          expect(messages[0].excerpt).not.toContain(" --disallow-untyped-decorators ")
          expect(messages[0].excerpt).toContain(" --allow-untyped-decorators ")
          atom.config.set(settingName, oldValue)

    describe "With the setting: warnRedundantCasts", ->
      settingName = "linter-mypy.warnRedundantCasts"
      describe 'Set to True', ->
        oldValue = atom.config.get(settingName)
        messages = null
        beforeEach ->
          atom.config.set(settingName, true)
          waitsForPromise ->
            lint(editor).then (msgs) ->
              messages = msgs
        it 'Adds the expected arguments', ->
          expect(messages.length).toBe(1)
          expect(messages[0].excerpt).toContain(" --warn-redundant-casts ")
          expect(messages[0].excerpt).not.toContain(" --no-warn-redundant-casts ")
          atom.config.set(settingName, oldValue)
      describe 'Set to False', ->
        oldValue = atom.config.get(settingName)
        messages = null
        beforeEach ->
          atom.config.set(settingName, false)
          waitsForPromise ->
            lint(editor).then (msgs) ->
              messages = msgs
        it 'Adds the expected arguments', ->
          expect(messages.length).toBe(1)
          expect(messages[0].excerpt).not.toContain(" --warn-redundant-casts ")
          expect(messages[0].excerpt).toContain(" --no-warn-redundant-casts ")
          atom.config.set(settingName, oldValue)

    describe "With the setting: warnNoReturn", ->
      settingName = "linter-mypy.warnNoReturn"
      describe 'Set to True', ->
        oldValue = atom.config.get(settingName)
        messages = null
        beforeEach ->
          atom.config.set(settingName, true)
          waitsForPromise ->
            lint(editor).then (msgs) ->
              messages = msgs
        it 'Adds the expected arguments', ->
          expect(messages.length).toBe(1)
          expect(messages[0].excerpt).toContain(" --warn-no-return ")
          expect(messages[0].excerpt).not.toContain(" --no-warn-no-return ")
          atom.config.set(settingName, oldValue)
      describe 'Set to False', ->
        oldValue = atom.config.get(settingName)
        messages = null
        beforeEach ->
          atom.config.set(settingName, false)
          waitsForPromise ->
            lint(editor).then (msgs) ->
              messages = msgs
        it 'Adds the expected arguments', ->
          expect(messages.length).toBe(1)
          expect(messages[0].excerpt).not.toContain(" --warn-no-return ")
          expect(messages[0].excerpt).toContain(" --no-warn-no-return ")
          atom.config.set(settingName, oldValue)

    describe "With the setting: warnReturnAny", ->
      settingName = "linter-mypy.warnReturnAny"
      describe 'Set to True', ->
        oldValue = atom.config.get(settingName)
        messages = null
        beforeEach ->
          atom.config.set(settingName, true)
          waitsForPromise ->
            lint(editor).then (msgs) ->
              messages = msgs
        it 'Adds the expected arguments', ->
          expect(messages.length).toBe(1)
          expect(messages[0].excerpt).toContain(" --warn-return-any ")
          expect(messages[0].excerpt).not.toContain(" --no-warn-return-any ")
          atom.config.set(settingName, oldValue)
      describe 'Set to False', ->
        oldValue = atom.config.get(settingName)
        messages = null
        beforeEach ->
          atom.config.set(settingName, false)
          waitsForPromise ->
            lint(editor).then (msgs) ->
              messages = msgs
        it 'Adds the expected arguments', ->
          expect(messages.length).toBe(1)
          expect(messages[0].excerpt).not.toContain(" --warn-return-any ")
          expect(messages[0].excerpt).toContain(" --no-warn-return-any ")
          atom.config.set(settingName, oldValue)

    describe "With the setting: disallowSubclassingAny", ->
      settingName = "linter-mypy.disallowSubclassingAny"
      describe 'Set to True', ->
        oldValue = atom.config.get(settingName)
        messages = null
        beforeEach ->
          atom.config.set(settingName, true)
          waitsForPromise ->
            lint(editor).then (msgs) ->
              messages = msgs
        it 'Adds the expected arguments', ->
          expect(messages.length).toBe(1)
          expect(messages[0].excerpt).toContain(" --disallow-subclassing-any ")
          expect(messages[0].excerpt).not.toContain(" --allow-subclassing-any ")
          atom.config.set(settingName, oldValue)
      describe 'Set to False', ->
        oldValue = atom.config.get(settingName)
        messages = null
        beforeEach ->
          atom.config.set(settingName, false)
          waitsForPromise ->
            lint(editor).then (msgs) ->
              messages = msgs
        it 'Adds the expected arguments', ->
          expect(messages.length).toBe(1)
          expect(messages[0].excerpt).not.toContain(" --disallow-subclassing-any ")
          expect(messages[0].excerpt).toContain(" --allow-subclassing-any ")
          atom.config.set(settingName, oldValue)

    describe "With the setting: disallowAnyUnimported", ->
      settingName = "linter-mypy.disallowAnyUnimported"
      describe 'Set to True', ->
        oldValue = atom.config.get(settingName)
        messages = null
        beforeEach ->
          atom.config.set(settingName, true)
          waitsForPromise ->
            lint(editor).then (msgs) ->
              messages = msgs
        it 'Adds the expected arguments', ->
          expect(messages.length).toBe(1)
          expect(messages[0].excerpt).toContain(" --disallow-any-unimported ")
          atom.config.set(settingName, oldValue)
      describe 'Set to False', ->
        oldValue = atom.config.get(settingName)
        messages = null
        beforeEach ->
          atom.config.set(settingName, false)
          waitsForPromise ->
            lint(editor).then (msgs) ->
              messages = msgs
        it 'Adds the expected arguments', ->
          expect(messages.length).toBe(1)
          expect(messages[0].excerpt).not.toContain(" --disallow-any-unimported ")
          atom.config.set(settingName, oldValue)

    describe "With the setting: disallowAnyExpr", ->
      settingName = "linter-mypy.disallowAnyExpr"
      describe 'Set to True', ->
        oldValue = atom.config.get(settingName)
        messages = null
        beforeEach ->
          atom.config.set(settingName, true)
          waitsForPromise ->
            lint(editor).then (msgs) ->
              messages = msgs
        it 'Adds the expected arguments', ->
          expect(messages.length).toBe(1)
          expect(messages[0].excerpt).toContain(" --disallow-any-expr ")
          atom.config.set(settingName, oldValue)
      describe 'Set to False', ->
        oldValue = atom.config.get(settingName)
        messages = null
        beforeEach ->
          atom.config.set(settingName, false)
          waitsForPromise ->
            lint(editor).then (msgs) ->
              messages = msgs
        it 'Adds the expected arguments', ->
          expect(messages.length).toBe(1)
          expect(messages[0].excerpt).not.toContain(" --disallow-any-expr ")
          atom.config.set(settingName, oldValue)

    describe "With the setting: disallowAnyDecorated", ->
      settingName = "linter-mypy.disallowAnyDecorated"
      describe 'Set to True', ->
        oldValue = atom.config.get(settingName)
        messages = null
        beforeEach ->
          atom.config.set(settingName, true)
          waitsForPromise ->
            lint(editor).then (msgs) ->
              messages = msgs
        it 'Adds the expected arguments', ->
          expect(messages.length).toBe(1)
          expect(messages[0].excerpt).toContain(" --disallow-any-decorated ")
          atom.config.set(settingName, oldValue)
      describe 'Set to False', ->
        oldValue = atom.config.get(settingName)
        messages = null
        beforeEach ->
          atom.config.set(settingName, false)
          waitsForPromise ->
            lint(editor).then (msgs) ->
              messages = msgs
        it 'Adds the expected arguments', ->
          expect(messages.length).toBe(1)
          expect(messages[0].excerpt).not.toContain(" --disallow-any-decorated ")
          atom.config.set(settingName, oldValue)

    describe "With the setting: disallowAnyExplicit", ->
      settingName = "linter-mypy.disallowAnyExplicit"
      describe 'Set to True', ->
        oldValue = atom.config.get(settingName)
        messages = null
        beforeEach ->
          atom.config.set(settingName, true)
          waitsForPromise ->
            lint(editor).then (msgs) ->
              messages = msgs
        it 'Adds the expected arguments', ->
          expect(messages.length).toBe(1)
          expect(messages[0].excerpt).toContain(" --disallow-any-explicit ")
          atom.config.set(settingName, oldValue)
      describe 'Set to False', ->
        oldValue = atom.config.get(settingName)
        messages = null
        beforeEach ->
          atom.config.set(settingName, false)
          waitsForPromise ->
            lint(editor).then (msgs) ->
              messages = msgs
        it 'Adds the expected arguments', ->
          expect(messages.length).toBe(1)
          expect(messages[0].excerpt).not.toContain(" --disallow-any-explicit ")
          atom.config.set(settingName, oldValue)

    describe "With the setting: disallowAnyGenerics", ->
      settingName = "linter-mypy.disallowAnyGenerics"
      describe 'Set to True', ->
        oldValue = atom.config.get(settingName)
        messages = null
        beforeEach ->
          atom.config.set(settingName, true)
          waitsForPromise ->
            lint(editor).then (msgs) ->
              messages = msgs
        it 'Adds the expected arguments', ->
          expect(messages.length).toBe(1)
          expect(messages[0].excerpt).toContain(" --disallow-any-generics ")
          atom.config.set(settingName, oldValue)
      describe 'Set to False', ->
        oldValue = atom.config.get(settingName)
        messages = null
        beforeEach ->
          atom.config.set(settingName, false)
          waitsForPromise ->
            lint(editor).then (msgs) ->
              messages = msgs
        it 'Adds the expected arguments', ->
          expect(messages.length).toBe(1)
          expect(messages[0].excerpt).not.toContain(" --disallow-any-generics ")
          atom.config.set(settingName, oldValue)

    describe "With the setting: warnUnusedIgnores", ->
      settingName = "linter-mypy.warnUnusedIgnores"
      describe 'Set to True', ->
        oldValue = atom.config.get(settingName)
        messages = null
        beforeEach ->
          atom.config.set(settingName, true)
          waitsForPromise ->
            lint(editor).then (msgs) ->
              messages = msgs
        it 'Adds the expected arguments', ->
          expect(messages.length).toBe(1)
          expect(messages[0].excerpt).toContain(" --warn-unused-ignores ")
          expect(messages[0].excerpt).not.toContain(" --no-warn-unused-ignores ")
          atom.config.set(settingName, oldValue)
      describe 'Set to False', ->
        oldValue = atom.config.get(settingName)
        messages = null
        beforeEach ->
          atom.config.set(settingName, false)
          waitsForPromise ->
            lint(editor).then (msgs) ->
              messages = msgs
        it 'Adds the expected arguments', ->
          expect(messages.length).toBe(1)
          expect(messages[0].excerpt).not.toContain(" --warn-unused-ignores ")
          expect(messages[0].excerpt).toContain(" --no-warn-unused-ignores ")
          atom.config.set(settingName, oldValue)

    describe "With the setting: warnUnusedConfigs", ->
      settingName = "linter-mypy.warnUnusedConfigs"
      describe 'Set to True', ->
        oldValue = atom.config.get(settingName)
        messages = null
        beforeEach ->
          atom.config.set(settingName, true)
          waitsForPromise ->
            lint(editor).then (msgs) ->
              messages = msgs
        it 'Adds the expected arguments', ->
          expect(messages.length).toBe(1)
          expect(messages[0].excerpt).toContain(" --warn-unused-configs ")
          expect(messages[0].excerpt).not.toContain(" --no-warn-unused-configs ")
          atom.config.set(settingName, oldValue)
      describe 'Set to False', ->
        oldValue = atom.config.get(settingName)
        messages = null
        beforeEach ->
          atom.config.set(settingName, false)
          waitsForPromise ->
            lint(editor).then (msgs) ->
              messages = msgs
        it 'Adds the expected arguments', ->
          expect(messages.length).toBe(1)
          expect(messages[0].excerpt).not.toContain(" --warn-unused-configs ")
          expect(messages[0].excerpt).toContain(" --no-warn-unused-configs ")
          atom.config.set(settingName, oldValue)

    describe "With the setting: warnMissingImports", ->
      settingName = "linter-mypy.warnMissingImports"
      describe 'Set to True', ->
        oldValue = atom.config.get(settingName)
        messages = null
        beforeEach ->
          atom.config.set(settingName, true)
          waitsForPromise ->
            lint(editor).then (msgs) ->
              messages = msgs
        it 'Adds the expected arguments', ->
          expect(messages.length).toBe(1)
          expect(messages[0].excerpt).not.toContain(" --ignore-missing-imports ")
          atom.config.set(settingName, oldValue)
      describe 'Set to False', ->
        oldValue = atom.config.get(settingName)
        messages = null
        beforeEach ->
          atom.config.set(settingName, false)
          waitsForPromise ->
            lint(editor).then (msgs) ->
              messages = msgs
        it 'Adds the expected arguments', ->
          expect(messages.length).toBe(1)
          expect(messages[0].excerpt).toContain(" --ignore-missing-imports ")
          atom.config.set(settingName, oldValue)

    describe "With the setting: strictOptional", ->
      settingName = "linter-mypy.strictOptional"
      describe 'Set to True', ->
        oldValue = atom.config.get(settingName)
        messages = null
        beforeEach ->
          atom.config.set(settingName, true)
          waitsForPromise ->
            lint(editor).then (msgs) ->
              messages = msgs
        it 'Adds the expected arguments', ->
          expect(messages.length).toBe(1)
          expect(messages[0].excerpt).toContain(" --strict-optional ")
          expect(messages[0].excerpt).not.toContain(" --no-strict-optional ")
          atom.config.set(settingName, oldValue)
      describe 'Set to False', ->
        oldValue = atom.config.get(settingName)
        messages = null
        beforeEach ->
          atom.config.set(settingName, false)
          waitsForPromise ->
            lint(editor).then (msgs) ->
              messages = msgs
        it 'Adds the expected arguments', ->
          expect(messages.length).toBe(1)
          expect(messages[0].excerpt).not.toContain(" --strict-optional ")
          expect(messages[0].excerpt).toContain(" --no-strict-optional ")
          atom.config.set(settingName, oldValue)

    describe "With the setting: noImplicitOptional", ->
      settingName = "linter-mypy.noImplicitOptional"
      describe 'Set to True', ->
        oldValue = atom.config.get(settingName)
        messages = null
        beforeEach ->
          atom.config.set(settingName, true)
          waitsForPromise ->
            lint(editor).then (msgs) ->
              messages = msgs
        it 'Adds the expected arguments', ->
          expect(messages.length).toBe(1)
          expect(messages[0].excerpt).toContain(" --no-implicit-optional ")
          expect(messages[0].excerpt).not.toContain(" --implicit-optional ")
          atom.config.set(settingName, oldValue)
      describe 'Set to False', ->
        oldValue = atom.config.get(settingName)
        messages = null
        beforeEach ->
          atom.config.set(settingName, false)
          waitsForPromise ->
            lint(editor).then (msgs) ->
              messages = msgs
        it 'Adds the expected arguments', ->
          expect(messages.length).toBe(1)
          expect(messages[0].excerpt).not.toContain(" --no-implicit-optional ")
          expect(messages[0].excerpt).toContain(" --implicit-optional ")
          atom.config.set(settingName, oldValue)

    describe "With the setting: warnUnreachable", ->
      settingName = "linter-mypy.warnUnreachable"
      describe 'Set to True', ->
        oldValue = atom.config.get(settingName)
        messages = null
        beforeEach ->
          atom.config.set(settingName, true)
          waitsForPromise ->
            lint(editor).then (msgs) ->
              messages = msgs
        it 'Adds the expected arguments', ->
          expect(messages.length).toBe(1)
          expect(messages[0].excerpt).toContain(" --warn-unreachable ")
          expect(messages[0].excerpt).not.toContain(" --no--warn-unreachable ")
          atom.config.set(settingName, oldValue)
      describe 'Set to False', ->
        oldValue = atom.config.get(settingName)
        messages = null
        beforeEach ->
          atom.config.set(settingName, false)
          waitsForPromise ->
            lint(editor).then (msgs) ->
              messages = msgs
        it 'Adds the expected arguments', ->
          expect(messages.length).toBe(1)
          expect(messages[0].excerpt).not.toContain(" --warn-unreachable ")
          expect(messages[0].excerpt).toContain(" --no--warn-unreachable ")
          atom.config.set(settingName, oldValue)

    describe "With the setting: noImplicitReexport", ->
      settingName = "linter-mypy.noImplicitReexport"
      describe 'Set to True', ->
        oldValue = atom.config.get(settingName)
        messages = null
        beforeEach ->
          atom.config.set(settingName, true)
          waitsForPromise ->
            lint(editor).then (msgs) ->
              messages = msgs
        it 'Adds the expected arguments', ->
          expect(messages.length).toBe(1)
          expect(messages[0].excerpt).toContain(" --no-implicit-reexport ")
          expect(messages[0].excerpt).not.toContain(" --implicit-reexport ")
          atom.config.set(settingName, oldValue)
      describe 'Set to False', ->
        oldValue = atom.config.get(settingName)
        messages = null
        beforeEach ->
          atom.config.set(settingName, false)
          waitsForPromise ->
            lint(editor).then (msgs) ->
              messages = msgs
        it 'Adds the expected arguments', ->
          expect(messages.length).toBe(1)
          expect(messages[0].excerpt).not.toContain(" --no-implicit-reexport ")
          expect(messages[0].excerpt).toContain(" --implicit-reexport ")
          atom.config.set(settingName, oldValue)
