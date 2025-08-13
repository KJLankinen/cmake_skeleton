# Testing library
FetchContent_Declare(
  catch
  GIT_REPOSITORY https://github.com/catchorg/Catch2.git
  GIT_TAG v3.8.1)
FetchContent_MakeAvailable(catch)

list(APPEND CMAKE_MODULE_PATH ${catch2_SOURCE_DIR}/extras)
include(Catch)

set(testbin ${CMAKE_PROJECT_NAME}-tests)

# Tests need to be added as executables first
add_executable(${testbin} lib.cpp)

target_compile_features(${testbin}
    PRIVATE
    cxx_std_20
    )

# Should be linked to the main library, as well as the Catch2 testing library
target_link_libraries(${testbin}
    PRIVATE
    ${CMAKE_PROJECT_NAME}
    Catch2::Catch2WithMain
    )

catch_discover_tests(${testbin})
