#!/bin/sh

#This script mocks MyPy behavior
#    it echoes one lint error whith the message of all the provided arguments

#Get the path to the file being linted (last argment)
for lintedfile; do true; done

#Remove the first character from the string "/" since:
# - lint warning are relative path from cwd
# - linter-mypy use the root as the cwd
lintedfile=$(echo "$lintedfile" | sed "s/^.\(.*\)/\1/")

# Echo a lint error about the provided file containing he message of all the provided arguments.
echo "$lintedfile:1: error:" "$@"
