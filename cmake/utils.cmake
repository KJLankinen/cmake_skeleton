function(skeleton_extract_version)
    # Find the up-to-date version string
    # The output is expected to be a version argument
    # like "0.1.6.0", "1.0" or similar
    execute_process(
        COMMAND ${CMAKE_CURRENT_LIST_DIR}/scripts/version.sh
        WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}
        OUTPUT_VARIABLE SKELETON_VERSION
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )

    # Make sure the version list/string contains all four arguments
    # Append 0s if it's shorter than 4
    string(REPLACE "." ";" VERSION_LIST ${SKELETON_VERSION})
    list(LENGTH VERSION_LIST LEN)
    while(LEN LESS 4)
        list(APPEND VERSION_LIST 0)
        list(LENGTH VERSION_LIST LEN)
    endwhile()

    list(GET VERSION_LIST 0 SKELETON_VERSION_MAJOR)
    list(GET VERSION_LIST 1 SKELETON_VERSION_MINOR)
    list(GET VERSION_LIST 2 SKELETON_VERSION_PATCH)
    list(GET VERSION_LIST 3 SKELETON_VERSION_TWEAK)

    set(SKELETON_VERSION ${SKELETON_VERSION} PARENT_SCOPE)
    set(SKELETON_VERSION_MAJOR ${SKELETON_VERSION_MAJOR} PARENT_SCOPE)
    set(SKELETON_VERSION_MINOR ${SKELETON_VERSION_MINOR} PARENT_SCOPE)
    set(SKELETON_VERSION_PATCH ${SKELETON_VERSION_PATCH} PARENT_SCOPE)
    set(SKELETON_VERSION_TWEAK ${SKELETON_VERSION_TWEAK} PARENT_SCOPE)
endfunction()
