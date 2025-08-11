## What is this?

A skeleton for a CMake project.
Clone this and modify as needed to start a new C++ project.

Alternatively, you can clone this once somewhere,
copy the entire directory elsewhere, then cd to that directory
and run `scripts/setup_new_project.sh name_of_project` to set it up.

## Configure & build the skeleton project

You should first compile the project you've just setup.

Do that with:

```bash
# Create directory for build files
mkdir build

# Configure & build project
cmake -S . -B build
cmake --build build -t all

# Run tests
ctest --test-dir build

# Run a sample binary
build/apps/name_of_project-bin
```
