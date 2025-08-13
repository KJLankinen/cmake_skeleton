# Find git to get the version
find_package(Git)

set(version_major ${PROJECT_VERSION_MAJOR})
set(version_minor ${PROJECT_VERSION_MINOR})
set(version_patch ${PROJECT_VERSION_PATCH})
set(version_tweak ${PROJECT_VERSION_TWEAK})
set(version ${PROJECT_VERSION})

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
    -D PROJECT_NAME_LOWERCASE=${project_name_lowercase}
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

# A new syntax from 3.23 onwards for specifying the source files
# Helps with installing public headers
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
    ../include/${project_name_lowercase}/lib.hpp
    ../include/${project_name_lowercase}/version.hpp
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

# Packaging
# This contains helper functions for creating config files
include(CMakePackageConfigHelpers)

# Copy the file from this directory to the binary directory
# after substituting some variables
configure_package_config_file(${CMAKE_CURRENT_SOURCE_DIR}/Config.cmake.in
    "${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_PROJECT_NAME}Config.cmake"
    INSTALL_DESTINATION ${PROJECT_INSTALL_CMAKEDIR}/${CMAKE_PROJECT_NAME}
)

# Generate a version file
set_property(TARGET ${libname} PROPERTY VERSION ${version})
set_property(TARGET ${libname} PROPERTY SOVERSION ${version_major})

# Add a custom property that can be used to check if different versions are compatible
# https://cmake.org/cmake/help/latest/prop_tgt/COMPATIBLE_INTERFACE_STRING.html#prop_tgt:COMPATIBLE_INTERFACE_STRING
set_property(TARGET ${libname} PROPERTY
    INTERFACE_${CMAKE_PROJECT_NAME}_MAJOR_VERSION ${version_major})
set_property(TARGET ${libname} APPEND PROPERTY
    COMPATIBLE_INTERFACE_STRING ${CMAKE_PROJECT_NAME}_MAJOR_VERSION
)

# generate the version file for the config file
write_basic_package_version_file(
    "${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_PROJECT_NAME}ConfigVersion.cmake"
    VERSION "${version}"
    COMPATIBILITY AnyNewerVersion
)

# Installing
# Setting a name for the exported target
# Installing the library and the headers
install(TARGETS ${libname}
    EXPORT ${CMAKE_PROJECT_NAME}Targets
    CONFIGURATIONS Release
    ARCHIVE DESTINATION ${PROJECT_INSTALL_LIBDIR}
    LIBRARY DESTINATION ${PROJECT_INSTALL_LIBDIR}
    FILE_SET public_headers DESTINATION ${PROJECT_INSTALL_INCLUDEDIR}
    )

# Installing the exported target file
install(EXPORT ${CMAKE_PROJECT_NAME}Targets
    FILE ${CMAKE_PROJECT_NAME}Targets.cmake
    NAMESPACE ${CMAKE_PROJECT_NAME}::
    DESTINATION ${PROJECT_INSTALL_CMAKEDIR}/${CMAKE_PROJECT_NAME}
)

# Install the config file and the version file
install(FILES
    "${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_PROJECT_NAME}Config.cmake"
    "${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_PROJECT_NAME}ConfigVersion.cmake"
    DESTINATION ${PROJECT_INSTALL_CMAKEDIR}/${CMAKE_PROJECT_NAME}
)
