#!/bin/bash

set -e

# Function taken from stack overflow for finding the directory of this script
get_script_dir()
{
    local SOURCE_PATH="${BASH_SOURCE[0]}"
    local SYMLINK_DIR
    local SCRIPT_DIR
    # Resolve symlinks recursively
    while [ -L "$SOURCE_PATH" ]; do
        # Get symlink directory
        SYMLINK_DIR="$( cd -P "$( dirname "$SOURCE_PATH" )" >/dev/null 2>&1 && pwd )"
        # Resolve symlink target (relative or absolute)
        SOURCE_PATH="$(readlink "$SOURCE_PATH")"
        # Check if candidate path is relative or absolute
        if [[ $SOURCE_PATH != /* ]]; then
            # Candidate path is relative, resolve to full path
            SOURCE_PATH=$SYMLINK_DIR/$SOURCE_PATH
        fi
    done
    # Get final script directory path from fully resolved source path
    SCRIPT_DIR="$(cd -P "$( dirname "$SOURCE_PATH" )" >/dev/null 2>&1 && pwd)"
    echo "$SCRIPT_DIR"
}

replace() {
    # This function replaces any $old in the repository with $new
    old=$1
    new=$2

    for file in $(git grep -r "${old}" | awk -F: '{print $1}')
    do
        sed -i "s/${old}/${new}/g" $file
    done
}

ensure_valid_name_as_cpp_variable() {
    # This function generates a C++ file with the
    # lowercase version of the given project name as a variable.
    # Then the file is compiled using cmake to see if the
    # project name is suitable or not.
    
    tmpdir=/tmp/setup_new_cmake_project_tmp
    mkdir -p $tmpdir
    cd $tmpdir 
    cat > CMakeLists.txt << EOF
project($project_name)
file(GENERATE
    OUTPUT main.cpp
    CONTENT "int main() { int $lowercase_name = 0; }\n"
    )
add_executable(exe main.cpp)
EOF
cmake . . >/dev/null 2>&1
cmake --build . >/dev/null 2>&1
}

exit_on_error() {
    echo $1
    exit 1
}

# Take on argument from user, replace "skeleton" with that
[ $# -eq 1 ] || exit_on_error "Give the name of the project as argument"

# Export these so they work with envsubst
export project_name=$1
export lowercase_name=${project_name,,}
export uppercase_name=${lowercase_name^^}
export capitalized_name=${lowercase_name^}

# Take the user's name from git config
user_name=$(git config user.name)

cwd=${PWD}
ensure_valid_name_as_cpp_variable || exit_on_error "The lowercase version of the given project name \"$lowercase_name\"\
    is not a valid C++ variable name, which it needs to be"
cd $cwd

script_dir=$(get_script_dir)

git clone $script_dir/.. $lowercase_name
cd $lowercase_name

# Replace any placholders with the given project name
replace skeleton $lowercase_name
replace SKELETON $uppercase_name
replace Skeleton $capitalized_name

# Replace the author's name with the user's name taken from git
# This way the Copyrights & Licenses of the new project
# are correct from the start, and not contributed to me
replace "Juhana Lankinen" "${user_name}"

mv include/skeleton include/$lowercase_name
mkdir build

# Need to use envsubst instead of cat:
# We want the $lowercase_name to expand
# We don't want the bacticks ` to expand
# Thus, quoting EOF but substituting $lowercase_name with the env var
envsubst > README.md << 'EOF'
# About

This is a project called $project_name.

It has the following directory structure:
- `apps` contains a simple binary that calls the library code
- `build` is the build directory for cmake
- `docs` contains files for generating html documentation using doxygen & dot
- `include/$lowercase_name` contains the public API header files of this project
- `LICENSES` has MIT license. Feel free to change it to anything else.
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
build/apps/$lowercase_name-cli
```

It's not a git repository yet, so you may want to do
```bash
git init
git add .
git commit -m "Initial commit"

# Git tags are used by CMake to set the version number of the project
git tag -a v0.1
```
EOF

rm -rf .git
rm TODO.md
rm -rf scripts
mkdir scripts
cp $script_dir/version.sh scripts/

echo "Successfully initialized a new project \"$lowercase_name\"!"
cat README.md

set +e
