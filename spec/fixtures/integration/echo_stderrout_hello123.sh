#!/bin/sh

#This script
# - echo "Hello" to the stdout
# - echo "World!" to the stderr
# Exit with code 123

echo "Hello"
(>&2 echo "World!")
exit 123
