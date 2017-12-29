#!/usr/bin/env coffee
#
# This spec file validates:
#  * How linter-mypy behaves when linting a situation like mypy bug 2974
#  * * https://github.com/python/mypy/issues/2974
#
#  If it fails:
#  * Check if the Mypy bug has been fix
#  * Adjust the the command line vs cwd vs heuristics

LinterMyPystyle = require '../lib/init'
path = require 'path'
fs = require 'fs'
os = require 'os'
{CompositeDisposable} = require 'atom'
helpers = require 'atom-linter'

describe "MyPy ... bug 2974", ->
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

  describe "reproduce mypy bug 2974", ->

    ProjectRoot = ""
    folderPathProject = ""
    folderPathProjectLib = ""
    filePathProjectInit = ""
    filePathProjectCli = ""
    filePathProjectLibInit = ""
    filePathProjectLibOptions = ""

    beforeEach ->
      # Prepare a project for testing
      # Create a project root (aka isolated temp folder)
      ProjectRoot = path.join(os.tmpdir(), "linter-mypy" + Math.floor(Math.random() * 9007199254740991))

      #Reproduce the problematic situation
      folderPathProject = path.join(ProjectRoot, "project")
      folderPathProjectLib = path.join(folderPathProject, "lib")

      filePathProjectInit = path.join(folderPathProject, '__init__.py')
      filePathProjectCli = path.join(folderPathProject, 'cli.py')

      filePathProjectLibInit = path.join(folderPathProjectLib, '__init__.py')
      filePathProjectLibOptions = path.join(folderPathProjectLib, 'options.py')

      # Create folders on HD:
      fs.mkdirSync(ProjectRoot)
      fs.mkdirSync(folderPathProject)
      fs.mkdirSync(folderPathProjectLib)

      #Create files on HD:
      fs.closeSync(fs.openSync(filePathProjectInit, 'w'))
      fs.closeSync(fs.openSync(filePathProjectLibInit, 'w'))
      fs.writeFileSync(filePathProjectLibOptions, """hi = 'hello'""")
      fs.writeFileSync(filePathProjectCli, """from .lib import options


# Deliberately failing type hints
def main(arg: str=None) -> int:
    print(options.hi)


if __name__ == '__main__':
    main()
""")

      # Open the project
      atom.project.setPaths([ProjectRoot])

    afterEach ->
      # Remove the files created on the hard drive.
      fs.unlinkSync(filePathProjectInit)
      fs.unlinkSync(filePathProjectCli)
      fs.unlinkSync(filePathProjectLibInit)
      fs.unlinkSync(filePathProjectLibOptions)

      # Remove the folders created on the hard drive.
      fs.rmdirSync(folderPathProjectLib)
      fs.rmdirSync(folderPathProject)
      fs.rmdirSync(ProjectRoot)

    describe "open cli.py and", ->
      editor = null
      beforeEach ->
        waitsForPromise ->
          atom.workspace.open(filePathProjectCli).then (e) ->
            editor = e

      describe "validates reported warnings", ->
        messages = null
        beforeEach ->
          waitsForPromise ->
            lint(editor).then (msgs) -> messages = msgs
        it 'should have detected something', ->
          expect(messages.length).not.toBe(0)
