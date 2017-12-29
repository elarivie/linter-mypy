#!/usr/bin/env coffee
#
# This spec file validates:
#  * The use of $PROJECT_NAME & $PROJECT_PATH variable in the config path
#
#  If it fails:
#  * Adjust the resolvePath method

LinterMyPystyle = require '../lib/init'
path = require 'path'
fs = require 'fs'
os = require 'os'
{CompositeDisposable} = require 'atom'
helpers = require 'atom-linter'

describe "linter-mypy ... resolvePath", ->
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

  describe "resolve the project name variable", ->

    beforeEach ->
      # Prepare fake projects for testing

      # Create a project root (aka isolated temp folder)
      @ProjectRoot = path.join(os.tmpdir(), "linter-mypy" + Math.floor(Math.random() * 9007199254740991))

      #Simulate a pseudo project #1 containing one file
      @firstProjectName = 'first_python_project'
      @firstProjectPath = path.join(@ProjectRoot, @firstProjectName)
      @firstFilePath = path.join(@firstProjectPath, 'src', 'first_file.py')

      #Simulate a pseudo project #2 containing one file
      @secondProjectName = 'second_python_project'
      @secondProjectPath = path.join(@ProjectRoot, @secondProjectName)
      @secondFilePath = path.join(@secondProjectPath, 'src', 'second_file.py')

      # Note: The methods:
      # * atom.project.relativizePath(filepath)
      # * atom.project.setPaths
      # Requires the folders to exist on HD)
      fs.mkdirSync(@ProjectRoot)
      fs.mkdirSync(@firstProjectPath)
      fs.mkdirSync(path.join(@firstProjectPath, 'src'))
      fs.mkdirSync(@secondProjectPath)
      fs.mkdirSync(path.join(@secondProjectPath, 'src'))

      # Note: The files do not need to be created on HD.
      #fs.closeSync(fs.openSync(@secondFilePath, 'w'))
      #fs.closeSync(fs.openSync(@firstFilePath, 'w'))

      # Open the two projects
      atom.project.setPaths([@firstProjectPath, @secondProjectPath])

    afterEach ->
      # Remove the file/folders created on the hard drive.

      #fs.unlinkSync(@firstFilePath)
      #fs.unlinkSync(@secondFilePath)

      fs.rmdirSync(path.join(@firstProjectPath, 'src'))
      fs.rmdirSync(@firstProjectPath)

      fs.rmdirSync(path.join(@secondProjectPath, 'src'))
      fs.rmdirSync(@secondProjectPath)

      fs.rmdirSync(@ProjectRoot)

    it "should return the same path if the file is not provided", ->
      targetPath = '/home/user/.virtualenvs/somevenv/bin/python'
      expectedPath = '/home/user/.virtualenvs/somevenv/bin/python'
      result = LinterMyPystyle.resolvePath(targetPath)
      expect(result).toBe(expectedPath)

    it "should return the same path if the file is not a child of any projects", ->
      loadedFile = path.join(os.tmpdir(), "/abc/def/ghi.py")
      targetPath = '/home/user/.virtualenvs/$PROJECT_NAME/bin/python'
      expectedPath = '/home/user/.virtualenvs/$PROJECT_NAME/bin/python'
      result = LinterMyPystyle.resolvePath(targetPath, loadedFile)
      expect(result).toBe(expectedPath)

    it "should return the same path if no variable are set", ->
      loadedFile = @secondFilePath
      targetPath = '/home/user/.virtualenvs/somevenv/bin/python'
      expectedPath = '/home/user/.virtualenvs/somevenv/bin/python'
      result = LinterMyPystyle.resolvePath(targetPath, loadedFile)
      expect(result).toBe(expectedPath)

    it "should return the first project's name when given the $PROJECT_NAME variable and a first project file", ->
      firstProjectName = @firstProjectName
      loadedFile = @firstFilePath
      result = LinterMyPystyle.resolvePath("$PROJECT_NAME", loadedFile)
      expect(result).toBe(firstProjectName)

    it "should return the second project's name when given the $PROJECT_NAME variable and a second project file", ->
      secondProjectName = @secondProjectName
      loadedFile = @secondFilePath
      result = LinterMyPystyle.resolvePath("$PROJECT_NAME", loadedFile)
      expect(result).toBe(secondProjectName)

    it "should fulfill the first project's name when given a full path and a first project file", ->
      loadedFile = @firstFilePath
      targetPath = '/home/user/.virtualenvs/$PROJECT_NAME/bin/python'
      expectedPath = '/home/user/.virtualenvs/first_python_project/bin/python'
      result = LinterMyPystyle.resolvePath(targetPath, loadedFile)
      expect(result).toBe(expectedPath)

    it "should fulfill the second project's name when given a full path and a second project file", ->
      loadedFile = @secondFilePath
      targetPath = '/home/user/.virtualenvs/$PROJECT_NAME/bin/python'
      expectedPath = '/home/user/.virtualenvs/second_python_project/bin/python'
      result = LinterMyPystyle.resolvePath(targetPath, loadedFile)
      expect(result).toBe(expectedPath)

    it "should return the first project's path when given the $PROJECT_PATH variable and a first project file", ->
      firstProjectPath = @firstProjectPath
      loadedFile = @firstFilePath
      result = LinterMyPystyle.resolvePath("$PROJECT_PATH", loadedFile)
      expect(result).toBe(firstProjectPath)

    it "should return the second project's path when given the $PROJECT_PATH variable and a second project file", ->
      secondProjectPath = @secondProjectPath
      loadedFile = @secondFilePath
      result = LinterMyPystyle.resolvePath("$PROJECT_PATH", loadedFile)
      expect(result).toBe(secondProjectPath)

    it "should replace as much $PROJECT_PATH and $PROJECT_NAME as requested", ->
      secondProjectPath = @secondProjectPath
      secondProjectName = @secondProjectName
      loadedFile = @secondFilePath
      result = LinterMyPystyle.resolvePath("$PROJECT_PATH$PROJECT_NAME$PROJECT_NAME$PROJECT_PATH$PROJECT_NAME", loadedFile)
      expect(result).toBe(secondProjectPath + secondProjectName + secondProjectName + secondProjectPath + secondProjectName)
