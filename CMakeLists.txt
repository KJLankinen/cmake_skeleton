cmake_minimum_required(VERSION 3.23...3.29)

# ------------------------------------------------------------------------------
# Start skeleton project
# ------------------------------------------------------------------------------
list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

include(utils)

skeleton_extract_version(${CMAKE_CURRENT_LIST_DIR})

project(skeleton VERSION ${SKELETON_VERSION} LANGUAGES CXX)
message(STATUS "Build skeleton: ${SKELETON_VERSION}")

include(GNUInstallDirs)

# ------------------------------------------------------------------------------
# Set default build to Release
# ------------------------------------------------------------------------------
set(default_build_type "Release")
if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  message(STATUS "Setting build type to '${default_build_type}' as none was specified.")
  set(CMAKE_BUILD_TYPE "${default_build_type}" CACHE STRING "Choose the type of build." FORCE)

  # Set the possible values of build type for cmake-gui
  set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release" "MinSizeRel" "RelWithDebInfo")
endif()

# ------------------------------------------------------------------------------
# Set SKELETON_MAIN_PROJECT to ON if this is the main project
# ------------------------------------------------------------------------------
string(COMPARE EQUAL "${CMAKE_PROJECT_NAME}" "${PROJECT_NAME}" SKELETON_MAIN_PROJECT)

# ------------------------------------------------------------------------------
# Options & variables
# ------------------------------------------------------------------------------
option(BUILD_SHARED_LIBS "Build using shared libraries" ON)
option(SKELETON_EXPORT_COMPILE_COMMANDS "Export compile commands for editors" ON)

set(SKELETON_INSTALL_CMAKEDIR ${CMAKE_INSTALL_LIBDIR}/cmake)

# ------------------------------------------------------------------------------
# External dependencies
# ------------------------------------------------------------------------------
# Declare these before any subdirectories

# FetchContent added in CMake 3.11, downloads during the configure step
# FetchContent_MakeAvailable was added in CMake 3.14; simpler usage
include(FetchContent)

# This cmake script file includes external packages that
# are fetched using FetchContent
include(external/dependencies.cmake)

# ------------------------------------------------------------------------------
# Main project specifics
# ------------------------------------------------------------------------------
if(SKELETON_MAIN_PROJECT)
    # Let's nicely support folders in IDEs
    set_property(GLOBAL PROPERTY USE_FOLDERS ON)

    # Generate a compile_commands.json if the option is set
    # It helps editors/language servers find the include paths
    # Should be done before adding any subdirectories
    if(SKELETON_EXPORT_COMPILE_COMMANDS)
        set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
    endif()

    # Testing only available if this is the main app
    # Note this needs to be done in the main CMakeLists
    # since it calls enable_testing, which must be in the
    # main CMakeLists.
    include(CTest)
    add_subdirectory(tests)

    # Docs only available if this is the main app
    find_package(Doxygen)
    if(Doxygen_FOUND)
      add_subdirectory(docs)
    else()
      message(STATUS "Doxygen not found, not building docs")
    endif()
endif()

# ------------------------------------------------------------------------------
# Subdirectories
# ------------------------------------------------------------------------------
# Libraries
add_subdirectory(src)

# Executables
add_subdirectory(apps)
