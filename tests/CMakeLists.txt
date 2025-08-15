# Gives us access to e.g. catch_discover_tests
include(Catch)

set(testbin ${PROJECT_NAME}-tests)

# Tests need to be added as executables first
add_executable(${testbin} add_tests.cpp)

target_compile_features(${testbin}
    PRIVATE
    cxx_std_20
    )

# Should be linked to the main library, as well as the Catch2 testing library
target_link_libraries(${testbin}
    PRIVATE
    ${PROJECT_NAME}
    Catch2::Catch2WithMain
    )

set_target_properties(${testbin}
    PROPERTIES
    OUTPUT_NAME tests
    )

catch_discover_tests(${testbin})
