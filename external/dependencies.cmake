# This script declares all dependencies used in this project,
# which are made available through FetchContent.
# All the different modules should be Declared,
# then their names must be appended to the
# external_packages list.
# Finally, MakeAvailable is called at the end.

# This script is included in the top level CMakeLists.txt
# before any subdirectories are added so that
# modifications to any variables are visible in the subdirectories,
# notably the CMAKE_MODULE_PATH.

# --------------------------------------------
# INITIALIZATION
# --------------------------------------------

set(external_packages "")

# --------------------------------------------
# DECLARATIONS
# --------------------------------------------

message(STATUS "Declaring fetch content dependencies")

# spdlog
FetchContent_Declare(
    spdlog
    GIT_REPOSITORY https://github.com/gabime/spdlog.git
    GIT_TAG v1.15.3
    )
list(APPEND external_packages spdlog)

set(SPDLOG_INSTALL ON)

# Catch2
if(skeleton_main_project)
    FetchContent_Declare(
        Catch2
        GIT_REPOSITORY https://github.com/catchorg/Catch2.git
        GIT_TAG v3.8.1
        )
    list(APPEND external_packages Catch2)
endif()


# --------------------------------------------
# MAKEAVAILABLE
# --------------------------------------------

message(STATUS "Making declared fetch contents available")

FetchContent_MakeAvailable(${external_packages})

if(skeleton_main_project)
    # Add this to module path so include(Catch) works in tests directory
    list(APPEND CMAKE_MODULE_PATH ${catch2_SOURCE_DIR}/extras)
endif()
