#!/usr/bin/env coffee
#
# This spec file validates:
#  * The use of $PROJECT_NAME variable in the config path
#
#  If it fails:
#  * Adjust the project_name method

LinterMyPystyle = require '../lib/init'
path = require 'path'
fs = require 'fs'
{CompositeDisposable} = require 'atom'
helpers = require 'atom-linter'

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

  describe "resolve the project name variable", ->

    beforeEach ->
      @firstProjectName = 'first_python_project'
      @firstProjectPath = '/tmp/' + @firstProjectName
      fs.mkdirSync(@firstProjectPath)
      fs.mkdirSync(@firstProjectPath + '/src')
      @firstFilePath = @firstProjectPath + '/src/first_file.py'
      fs.closeSync(fs.openSync(@firstFilePath, 'w'))

      @secondProjectName = 'second_python_project'
      @secondProjectPath = '/tmp/' + @secondProjectName
      fs.mkdirSync(@secondProjectPath)
      fs.mkdirSync(@secondProjectPath + '/src')
      @secondFilePath = @secondProjectPath + '/src/second_file.py'
      fs.closeSync(fs.openSync(@secondFilePath, 'w'))

      atom.project.setPaths([@firstProjectPath, @secondProjectPath])

    afterEach ->
      fs.unlinkSync(@firstFilePath)
      fs.rmdirSync(@firstProjectPath + '/src')
      fs.rmdirSync(@firstProjectPath)

      fs.unlinkSync(@secondFilePath)
      fs.rmdirSync(@secondProjectPath + '/src')
      fs.rmdirSync(@secondProjectPath)

    it "should return the first project's name when given the variable", ->
      firstProjectName = @firstProjectName
      firstFilePath = @firstFilePath
      waitsForPromise ->
        atom.workspace.open(firstFilePath).then (e) ->
          result = LinterMyPystyle.resolvePath("$PROJECT_NAME")
          # Return this project's name (i.e. first_python_project)
          expect(result).toBe(firstProjectName)

    it "should return the second project's name when given the variable", ->
      secondProjectName = @secondProjectName
      secondFilePath = @secondFilePath
      waitsForPromise ->
        atom.workspace.open(secondFilePath).then (e) ->
          result = LinterMyPystyle.resolvePath("$PROJECT_NAME")
          # Return this project's name (i.e. second_python_project)
          expect(result).toBe(secondProjectName)

    it "should return the first project's name when given a full path", ->
      firstFilePath = @firstFilePath
      targetPath = '/home/user/.virtualenvs/$PROJECT_NAME/bin/python'
      expectedPath = '/home/user/.virtualenvs/first_python_project/bin/python'
      waitsForPromise ->
        atom.workspace.open(firstFilePath).then (e) ->
          result = LinterMyPystyle.resolvePath(targetPath)
          expect(result).toBe(expectedPath)

    it "should return the second project's name when given a full path", ->
      secondFilePath = @secondFilePath
      targetPath = '/home/user/.virtualenvs/$PROJECT_NAME/bin/python'
      expectedPath = '/home/user/.virtualenvs/second_python_project/bin/python'
      waitsForPromise ->
        atom.workspace.open(secondFilePath).then (e) ->
          result = LinterMyPystyle.resolvePath(targetPath)
          expect(result).toBe(expectedPath)

    it "should return the same path if the variable is not set (first)", ->
      firstFilePath = @firstFilePath
      targetPath = '/home/user/.virtualenvs/somevenv/bin/python'
      expectedPath = '/home/user/.virtualenvs/somevenv/bin/python'
      waitsForPromise ->
        atom.workspace.open(firstFilePath).then (e) ->
          result = LinterMyPystyle.resolvePath(targetPath)
          expect(result).toBe(expectedPath)

    it "should return the same path if the variable is not set (second)", ->
      secondFilePath = @secondFilePath
      targetPath = '/home/user/.virtualenvs/somevenv/bin/python'
      expectedPath = '/home/user/.virtualenvs/somevenv/bin/python'
      waitsForPromise ->
        atom.workspace.open(secondFilePath).then (e) ->
          result = LinterMyPystyle.resolvePath(targetPath)
          expect(result).toBe(expectedPath)
