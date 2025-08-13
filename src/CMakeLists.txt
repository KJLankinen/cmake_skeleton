# Find git to get the version
find_package(Git)

set(version_major ${PROJECT_VERSION_MAJOR})
set(version_minor ${PROJECT_VERSION_MINOR})
set(version_patch ${PROJECT_VERSION_PATCH})
set(version_tweak ${PROJECT_VERSION_TWEAK})

if (NOT DEFINED version_major)
    set(version_major 0)
endif()

if (NOT DEFINED version_minor)
    set(version_minor 0)
endif()

if (NOT DEFINED version_patch)
    set(version_patch 0)
endif()

if (NOT DEFINED version_tweak)
    set(version_tweak 0)
endif()

# Run a CMake script to generate the version file with the git hash
add_custom_target(
    version
    ${CMAKE_COMMAND}
    -D SRC=${CMAKE_CURRENT_SOURCE_DIR}/version.cpp.in
    -D DST=${CMAKE_CURRENT_BINARY_DIR}/version.cpp
    -D GIT_EXECUTABLE=${GIT_EXECUTABLE}
    -D PROJECT_NAME=${PROJECT_NAME}
    -D PROJECT_VERSION=${PROJECT_VERSION}
    -D PROJECT_VERSION_MAJOR=${version_major}
    -D PROJECT_VERSION_MINOR=${version_minor}
    -D PROJECT_VERSION_PATCH=${version_patch}
    -D PROJECT_VERSION_TWEAK=${version_tweak}
    -P ${CMAKE_SOURCE_DIR}/cmake/GenerateVersionHeader.cmake
    BYPRODUCTS ${CMAKE_BINARY_DIR}/src/version.cpp
)

set(libname ${CMAKE_PROJECT_NAME})
add_library(${libname})

target_sources(${libname}
    # source files
    PRIVATE
    lib.cpp
    version.cpp

    # private headers
    PRIVATE
    FILE_SET private_headers
    TYPE HEADERS
    BASE_DIRS
    ${CMAKE_CURRENT_SOURCE_DIR}
    FILES

    # public headers
    PUBLIC
    FILE_SET public_headers
    TYPE HEADERS
    BASE_DIRS
    ../include
    FILES
    ../include/skeleton/lib.hpp
    ../include/skeleton/version.hpp
    )

# The main library depends on the custom git version target
add_dependencies(${libname} version)

# This depends on (header only) boost
#target_link_libraries(library PRIVATE Boost::boost)

# All users of this library will need at least C++20
target_compile_features(${libname} PUBLIC cxx_std_20)

# Don't replace e.g. std=c++20 with std=g++20
set_target_properties(${libname} PROPERTIES CXX_EXTENSIONS OFF)

# For position independent code
#set_target_properties(lib1 PROPERTIES POSITION_INDEPENDENT_CODE ON)

install(TARGETS ${libname}
    CONFIGURATIONS Release
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    FILE_SET public_headers DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
    )
