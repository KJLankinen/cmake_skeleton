#!/bin/bash

# This could use some git magic to get a tag from there, and fall back to this if tags not set
git_version=$(git describe --tags --abbrev=0)
# TODO: try to parse the tag, if it's in the form vd.d.d.d, where d is a digit
# fail if not found and just report 0
#echo $git_version
printf "0.0.0"
