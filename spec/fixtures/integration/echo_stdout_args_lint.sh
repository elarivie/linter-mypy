#!/bin/sh

#This script mocks MyPy behavior
#    it echoes one lint error whith the message of all the provided arguments

#Get the path to the file being linted (last argument)
for lintedfile in $@; do :; done

# Echo a lint error about the provided file containing he message of all the provided arguments.
echo "$lintedfile:1: error:" "$@"
