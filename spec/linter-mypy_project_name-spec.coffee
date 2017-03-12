#!/usr/bin/env coffee
#
# This spec file validates:
#  * The use of $PROJECT_NAME variable in the config path
#
#  If it fails:
#  * Adjust the project_name method

LinterMyPystyle = require '../lib/init'
path = require 'path'
{CompositeDisposable} = require 'atom'
helpers = require 'atom-linter'

fdescribe "The MyPy provider for Linter", ->
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
      directory = path.join(__dirname, '..')
      atom.project.setPaths([directory])

    it "should return the project's name when given the variable", ->
      result = LinterMyPystyle.resolvePath("$PROJECT_NAME")
      # Return this project's name (i.e. linter-mypy)
      expect(result).toBe("linter-mypy")

    it "should return the project's name when given a full path", ->
      targetPath = '/home/user/.virtualenvs/$PROJECT_NAME/bin/python'
      result = LinterMyPystyle.resolvePath(targetPath)
      expectedPath = '/home/user/.virtualenvs/linter-mypy/bin/python'
      expect(result).toBe(expectedPath)

    it "should return the same path if the variable is not set", ->
      targetPath = '/home/user/.virtualenvs/somevenv/bin/python'
      result = LinterMyPystyle.resolvePath(targetPath)
      expectedPath = '/home/user/.virtualenvs/somevenv/bin/python'
      expect(result).toBe(expectedPath)
