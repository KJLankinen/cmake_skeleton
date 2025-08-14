# Find git to get the version
find_package(Git)

# Run a CMake script to generate the version source file with the git hash
add_custom_target(
    version-target
    ${CMAKE_COMMAND}
    -D SCRIPTS_DIR=${CMAKE_SOURCE_DIR}/scripts
    -D SRC=${CMAKE_CURRENT_SOURCE_DIR}/version.cpp.in
    -D DST=${CMAKE_CURRENT_BINARY_DIR}/version.cpp
    -D GIT_EXECUTABLE=${GIT_EXECUTABLE}
    -D PROJECT_NAME=${PROJECT_NAME}
    -D PROJECT_NAME_LOWERCASE=${project_name_lowercase}
    -P ${CMAKE_SOURCE_DIR}/cmake/GenerateVersionHeader.cmake
    BYPRODUCTS ${CMAKE_CURRENT_BINARY_DIR}/version.cpp
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
add_dependencies(${libname} version-target)

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
set_property(TARGET ${libname} PROPERTY VERSION ${PROJECT_VERSION})
set_property(TARGET ${libname} PROPERTY SOVERSION ${PROJECT_VERSION_MAJOR})

# Add a custom property that can be used to check if different versions are compatible
# https://cmake.org/cmake/help/latest/prop_tgt/COMPATIBLE_INTERFACE_STRING.html#prop_tgt:COMPATIBLE_INTERFACE_STRING
set_property(TARGET ${libname} PROPERTY
    INTERFACE_${CMAKE_PROJECT_NAME}_MAJOR_VERSION ${PROJECT_VERSION_MAJOR})
set_property(TARGET ${libname} APPEND PROPERTY
    COMPATIBLE_INTERFACE_STRING ${CMAKE_PROJECT_NAME}_MAJOR_VERSION
)

# generate the version file for the config file
write_basic_package_version_file(
    "${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_PROJECT_NAME}ConfigVersion.cmake"
    VERSION "${PROJECT_VERSION}"
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
