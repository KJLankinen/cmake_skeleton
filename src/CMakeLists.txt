# ------------------------------------------------------------------------------
# Packages
# ------------------------------------------------------------------------------
find_package(Git)

# ------------------------------------------------------------------------------
# Version generation during build time
# ------------------------------------------------------------------------------
add_custom_target(
    ${PROJECT_NAME}-version
    ${CMAKE_COMMAND}
    -D SRC=${CMAKE_CURRENT_SOURCE_DIR}/version.cpp.in
    -D DST=${CMAKE_CURRENT_BINARY_DIR}/version.cpp
    -D GIT_EXECUTABLE=${GIT_EXECUTABLE}
    -D PROJECT_NAME=${PROJECT_NAME}
    -D DIR=${CMAKE_SOURCE_DIR}
    -P ${CMAKE_SOURCE_DIR}/cmake/GenerateVersionHeader.cmake
    BYPRODUCTS ${CMAKE_CURRENT_BINARY_DIR}/version.cpp
)

# ------------------------------------------------------------------------------
# Targets
# ------------------------------------------------------------------------------
add_library(${PROJECT_NAME})
add_library(${PROJECT_NAME}::${PROJECT_NAME} ALIAS ${PROJECT_NAME})

# ------------------------------------------------------------------------------
# Sources
# ------------------------------------------------------------------------------
# A new syntax from 3.23 onwards for specifying the source files
# Helps with installing public headers
target_sources(${PROJECT_NAME}
    # source files
    PRIVATE
    add.cpp
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
    ../include/${PROJECT_NAME}/${PROJECT_NAME}.hpp
    )

# ------------------------------------------------------------------------------
# Dependecies
# ------------------------------------------------------------------------------
add_dependencies(${PROJECT_NAME} ${PROJECT_NAME}-version)
target_link_libraries(${PROJECT_NAME} PRIVATE spdlog::spdlog)

# ------------------------------------------------------------------------------
# Compilation
# ------------------------------------------------------------------------------
# All users of this library will need at least C++20
target_compile_features(${PROJECT_NAME} PUBLIC cxx_std_20)

# ------------------------------------------------------------------------------
# Properties
# ------------------------------------------------------------------------------
# Don't replace e.g. std=c++20 with std=g++20
set_target_properties(${PROJECT_NAME}
    PROPERTIES
    CXX_EXTENSIONS OFF
    OUTPUT_NAME ${PROJECT_NAME}
    )

# For position independent code
#set_target_properties(lib1 PROPERTIES POSITION_INDEPENDENT_CODE ON)

# ------------------------------------------------------------------------------
# Packaging
# ------------------------------------------------------------------------------
# This contains helper functions for creating config files
include(CMakePackageConfigHelpers)

# Copy the file from this directory to the binary directory
# after substituting some variables
set(skeleton_config_input ${CMAKE_CURRENT_SOURCE_DIR}/Config.cmake.in)
set(skeleton_config_output "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake")
configure_package_config_file(
    ${skeleton_config_input}
    ${skeleton_config_output}
    INSTALL_DESTINATION ${SKELETON_INSTALL_CMAKEDIR}/${PROJECT_NAME}
)

# Generate a version file
set_property(TARGET ${PROJECT_NAME} PROPERTY VERSION ${PROJECT_VERSION})
set_property(TARGET ${PROJECT_NAME} PROPERTY SOVERSION ${PROJECT_VERSION_MAJOR})

# Add a custom property that can be used to check if different versions are compatible
# https://cmake.org/cmake/help/latest/prop_tgt/COMPATIBLE_INTERFACE_STRING.html#prop_tgt:COMPATIBLE_INTERFACE_STRING
set_property(TARGET ${PROJECT_NAME} PROPERTY
    INTERFACE_${PROJECT_NAME}_MAJOR_VERSION ${PROJECT_VERSION_MAJOR})
set_property(TARGET ${PROJECT_NAME} APPEND PROPERTY
    COMPATIBLE_INTERFACE_STRING ${PROJECT_NAME}_MAJOR_VERSION
)

# generate the version file for the config file
write_basic_package_version_file(
    "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake"
    VERSION "${PROJECT_VERSION}"
    COMPATIBILITY AnyNewerVersion
)

# ------------------------------------------------------------------------------
# Installing
# ------------------------------------------------------------------------------
# Setting a name for the exported target
# Installing the library and the headers
install(TARGETS ${PROJECT_NAME}
    EXPORT ${PROJECT_NAME}Targets
    CONFIGURATIONS Release
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    FILE_SET public_headers DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
    )

# Installing the exported target file
install(EXPORT ${PROJECT_NAME}Targets
    FILE ${PROJECT_NAME}Targets.cmake
    NAMESPACE ${PROJECT_NAME}::
    DESTINATION ${SKELETON_INSTALL_CMAKEDIR}/${PROJECT_NAME}
)

# Install the config file and the version file
install(FILES
    "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake"
    "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake"
    DESTINATION ${SKELETON_INSTALL_CMAKEDIR}/${PROJECT_NAME}
)
