# This first part generates a library that has the current git hash hard coded into it
# This version library will be linked to the actual library

# Find git to make the version library
find_package(Git)

# Run a CMake script to generate the version file with the git hash
add_custom_target(
    version
    ${CMAKE_COMMAND}
    -D SRC=${CMAKE_CURRENT_SOURCE_DIR}/version.cpp.in
    -D DST=${CMAKE_CURRENT_BINARY_DIR}/version.cpp
    -P ${CMAKE_SOURCE_DIR}/cmake/GenerateVersionHeader.cmake
)

add_library(version_lib ${CMAKE_CURRENT_BINARY_DIR}/version.cpp)
add_dependencies(version_lib version)
target_include_directories(version_lib PUBLIC ../include)
target_compile_features(version_lib PUBLIC cxx_std_20)
set_target_properties(version_lib PROPERTIES CXX_EXTENSIONS OFF)

# Note that headers are optional, and do not affect add_library, but they will not
# show up in IDEs unless they are listed in add_library.

file(GLOB HEADER_LIST CONFIGURE_DEPENDS "${PROJECT_SOURCE_DIR}/include/${CMAKE_PROJECT_NAME}/*.hpp")

set(libname ${CMAKE_PROJECT_NAME}-lib)

# Make an automatic library - will be static or dynamic based on user setting
add_library(${libname}
    lib.cpp
    ${HEADER_LIST})

# We need this directory, and users of our library will need it too
target_include_directories(${libname} PUBLIC ../include)

# This depends on (header only) boost
#target_link_libraries(library PRIVATE Boost::boost)

target_link_libraries(${libname} version_lib)

# All users of this library will need at least C++20
target_compile_features(${libname} PUBLIC cxx_std_20)

# Don't replace e.g. std=c++20 with std=g++20
set_target_properties(${libname} PROPERTIES CXX_EXTENSIONS OFF)

# For position independent code
#set_target_properties(lib1 PROPERTIES POSITION_INDEPENDENT_CODE ON)

# IDEs should put the headers in a nice place
source_group(
  TREE "${PROJECT_SOURCE_DIR}/include"
  PREFIX "Header Files"
  FILES ${HEADER_LIST})
