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
add_library(${PROJECT_NAME}::version-target ALIAS version-target)

# Add the library and add it also as an alias
add_library(${project_name_lowercase})
add_library(${PROJECT_NAME}::${project_name_lowercase} ALIAS ${project_name_lowercase})

# A new syntax from 3.23 onwards for specifying the source files
# Helps with installing public headers
target_sources(${project_name_lowercase}
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
add_dependencies(${project_name_lowercase} version-target)

# This depends on (header only) boost
#target_link_libraries(library PRIVATE Boost::boost)

# All users of this library will need at least C++20
target_compile_features(${project_name_lowercase} PUBLIC cxx_std_20)

# Don't replace e.g. std=c++20 with std=g++20
set_target_properties(${project_name_lowercase}
    PROPERTIES
    CXX_EXTENSIONS OFF
    OUTPUT_NAME ${project_name_lowercase}
    )

# For position independent code
#set_target_properties(lib1 PROPERTIES POSITION_INDEPENDENT_CODE ON)

# Packaging
# This contains helper functions for creating config files
include(CMakePackageConfigHelpers)

# Copy the file from this directory to the binary directory
# after substituting some variables
configure_package_config_file(${CMAKE_CURRENT_SOURCE_DIR}/Config.cmake.in
    "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake"
    INSTALL_DESTINATION ${PROJECT_INSTALL_CMAKEDIR}/${PROJECT_NAME}
)

# Generate a version file
set_property(TARGET ${project_name_lowercase} PROPERTY VERSION ${PROJECT_VERSION})
set_property(TARGET ${project_name_lowercase} PROPERTY SOVERSION ${PROJECT_VERSION_MAJOR})

# Add a custom property that can be used to check if different versions are compatible
# https://cmake.org/cmake/help/latest/prop_tgt/COMPATIBLE_INTERFACE_STRING.html#prop_tgt:COMPATIBLE_INTERFACE_STRING
set_property(TARGET ${project_name_lowercase} PROPERTY
    INTERFACE_${PROJECT_NAME}_MAJOR_VERSION ${PROJECT_VERSION_MAJOR})
set_property(TARGET ${project_name_lowercase} APPEND PROPERTY
    COMPATIBLE_INTERFACE_STRING ${PROJECT_NAME}_MAJOR_VERSION
)

# generate the version file for the config file
write_basic_package_version_file(
    "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake"
    VERSION "${PROJECT_VERSION}"
    COMPATIBILITY AnyNewerVersion
)

# Installing
# Setting a name for the exported target
# Installing the library and the headers
install(TARGETS ${project_name_lowercase}
    EXPORT ${PROJECT_NAME}Targets
    CONFIGURATIONS Release
    ARCHIVE DESTINATION ${PROJECT_INSTALL_LIBDIR}
    LIBRARY DESTINATION ${PROJECT_INSTALL_LIBDIR}
    FILE_SET public_headers DESTINATION ${PROJECT_INSTALL_INCLUDEDIR}
    )

# Installing the exported target file
install(EXPORT ${PROJECT_NAME}Targets
    FILE ${PROJECT_NAME}Targets.cmake
    NAMESPACE ${PROJECT_NAME}::
    DESTINATION ${PROJECT_INSTALL_CMAKEDIR}/${PROJECT_NAME}
)

# Install the config file and the version file
install(FILES
    "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake"
    "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake"
    DESTINATION ${PROJECT_INSTALL_CMAKEDIR}/${PROJECT_NAME}
)
