#!/bin/bash

set -e

# Take on argument from user, replace "skeleton" with that
if [ $# -ne 1 ]
then
    echo "Give the name of the project as argument"
    exit 1
fi

export project_name=$1

git clone https://github.com/KJLankinen/cmake_skeleton.git $project_name
cd $project_name

for file in $(git grep -r skeleton | awk -F: '{print $1}')
do
    sed -i "s/skeleton/$project_name/g" $file
done

for file in $(git grep -r SKELETON | awk -F: '{print $1}')
do
    sed -i "s/SKELETON/\U$project_name/g" $file
done

mv include/skeleton include/$project_name
mkdir build

# Need to use envsubst instead of cat:
# We want the $project_name to expand
# We don't want the bacticks ` to expand
# Thus, quoting EOF but substituting $project_name with the env var
envsubst > README.md << 'EOF'
# About

This is a project called $project_name.

It has the following directory structure:
- `apps` contains a simple binary that calls the library code
- `docs` contains files for generating html documentation using doxygen & dot
- `include/$project_name` contains the header files of this project
- `scripts` contains some scripts
- `src` contains the source code for the library
- `tests` contains a simple test using Catch2 testing framework

You can configure and build this project with

```bash
cmake -S . -B build
cmake --build build -t all
```

To execute the tests and the sample binary, do
```bash
# Run tests
ctest --test-dir build
# Or cmake --build build --target test

# Run a sample binary
build/apps/name_of_project-bin
```

It's not a git repository yet, so you may want to do
```bash
git init
git add .
git commit -m "Initial commit"
```
EOF

rm -rf .git
rm TODO.md
rm -rf scripts
mkdir scripts
