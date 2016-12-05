LinterMyPystyle = require '../lib/init'
path = require 'path'
{CompositeDisposable} = require 'atom'
helpers = require 'atom-linter'

goodPath = path.join(__dirname, 'fixtures', 'good.py')
badPath = path.join(__dirname, 'fixtures', 'bad.py')
badPathRegex = /.+bad\.py/
helpPath = path.join(__dirname, 'fixtures', 'mypy.help')

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

  describe "reads good.py and", ->
    editor = null
    beforeEach ->
      waitsForPromise ->
        atom.workspace.open(goodPath).then (e) ->
          atom.config.set('linter-mypy.fastParser', false)
          editor = e

    it 'finds nothing to complain about', ->
      messages = null
      waitsForPromise ->
        lint(editor).then (msgs) -> messages = msgs
      runs ->
        expect(messages.length).toEqual 0

  describe "reads bad.py and", ->
    editor = null
    beforeEach ->
      waitsForPromise ->
        atom.workspace.open(badPath).then (e) ->
          atom.config.set('linter-mypy.fastParser', false)
          editor = e

    it 'finds something to complain about', ->
      messages = null
      waitsForPromise ->
        lint(editor).then (msgs) -> messages = msgs
      runs ->
        expect(messages.length).toBeGreaterThan 0
        expect(messages.length).toBe(3)

    it 'finds the right things to complain about', ->
      messages = null
      waitsForPromise ->
        lint(editor).then (msgs) -> messages = msgs
      runs ->
        msg0 = 'Argument 1 to "add" has incompatible type "str"; expected "int"'
        msg1 = 'Argument 2 to "add" has incompatible type "str"; expected "int"'
        msg2 = 'Unsupported operand types for + ("int" and "str")'
        expect(messages[0].text).toBe(msg0)
        expect(messages[0].range).toEqual([[6,11],[6,11]])
        expect(messages[0].type).toBe('Warning')
        expect(messages[0].filePath).toMatch(badPathRegex)
        expect(messages[1].text).toBe(msg1)
        expect(messages[1].range).toEqual([[6,11],[6,11]])
        expect(messages[1].type).toBe('Warning')
        expect(messages[1].filePath).toMatch(badPathRegex)
        expect(messages[2].text).toBe(msg2)
        expect(messages[2].range).toEqual([[6,30],[6,30]])
        expect(messages[2].type).toBe('Warning')
        expect(messages[2].filePath).toMatch(badPathRegex)

  describe "reads mypy.help and fetch mypy --help", ->
    supportedHelp = null
    mypyHelp = null

    beforeEach ->
      waitsForPromise ->
        atom.workspace.open(helpPath).then (e) ->
          supportedHelp = e.getText().trim()

    beforeEach ->
      waitsForPromise ->
        mypyPath = atom.config.get('linter-mypy.executablePath')
        helpers.exec(mypyPath, ["--help"], { stream: 'stdout', ignoreExitCode: true}).then (helpMsg) ->
          mypyHelp = helpMsg.trim()

    it 'Makes sure the supported "mypy" command interface has not change.', ->
      expect(mypyHelp).toBe(supportedHelp)
