#!/bin/bash
# Get a tag from git matching the pattern v0.1.0.0
# If there're no tags matching that pattern, just return 0.0.0.0
# Note that the newline needs to be removed or cmake cannot use the string
(git describe --tags --match "v[0-9]*" --abbrev=0 2>/dev/null || echo "v0.0.0.0") | sed "s/^v\([0-9]\+[0-9\.]*\).*$/\1/"

# If you don't want to use git tags for the version information,
# you can just do
# echo "0.0"
# in this file
