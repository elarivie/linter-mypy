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
      waitsForPromise ->
        mypyPath = atom.config.get('linter-mypy.executablePath')

    it "should return the project's name", ->
      console.error(mypyPath)
      expect("hello").toBe("world")
