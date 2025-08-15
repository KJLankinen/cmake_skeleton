cmake_minimum_required(VERSION 3.23...3.29)

# ------------------------------------------------------------------------------
# Start skeleton project
# ------------------------------------------------------------------------------
list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

include(utils)

skeleton_extract_version()

project(skeleton VERSION ${SKELETON_VERSION} LANGUAGES CXX)
message(STATUS "Build skeleton: ${SKELETON_VERSION}")

include(GNUInstallDirs)

# Set variables
string(COMPARE EQUAL "${CMAKE_PROJECT_NAME}" "${PROJECT_NAME}" skeleton_main_project)

set(SKELETON_INSTALL_CMAKEDIR ${CMAKE_INSTALL_LIBDIR}/cmake)

set(default_build_type "Release")

# Options
option(BUILD_SHARED_LIBS "Build using shared libraries" ON)

if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  message(STATUS "Setting build type to '${default_build_type}' as none was specified.")
  set(CMAKE_BUILD_TYPE "${default_build_type}" CACHE
      STRING "Choose the type of build." FORCE)
  # Set the possible values of build type for cmake-gui
  set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS
    "Debug" "Release" "MinSizeRel" "RelWithDebInfo")
endif()

# FetchContent added in CMake 3.11, downloads during the configure step
# FetchContent_MakeAvailable was added in CMake 3.14; simpler usage
include(FetchContent)

# This cmake script file includes external packages that
# are fetched using FetchContent
include(external/dependencies.cmake)

# The compiled library code is here
add_subdirectory(src)

# The executable code is here
add_subdirectory(apps)

# Skip these if included through add_subdirectory
if(skeleton_main_project)
    # Export compile commands, usable by LSPs in editors
    set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

    # Let's nicely support folders in IDEs
    set_property(GLOBAL PROPERTY USE_FOLDERS ON)

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
