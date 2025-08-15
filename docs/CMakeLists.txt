set(DOXYGEN_EXTRACT_ALL YES)
set(DOXYGEN_BUILTIN_STL_SUPPORT YES)
set(DOXYGEN_USE_MDFILE_AS_MAINPAGE "${PROJECT_SOURCE_DIR}/README.md")
set(DOXYGEN_EXCLUDE_PATTERNS */apps/* */build/* */cmake/* */external/* */installed/* */tests/*)
set(DOXYGEN_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}")

# ------------------------------------------------------------------------------
# Documentation target
# ------------------------------------------------------------------------------
doxygen_add_docs(${PROJECT_NAME}-docs
    "${PROJECT_SOURCE_DIR}"
    "${PROJECT_SOURCE_DIR}/README.md"
    COMMENT "Building docs for ${PROJECT_NAME}"
    ALL
    )

add_custom_command(OUTPUT "${DOXYGEN_OUTPUT_DIRECTORY}" DEPENDS ${PROJECT_NAME}-docs)

# ------------------------------------------------------------------------------
# Installation
# ------------------------------------------------------------------------------
install(
    DIRECTORY "${DOXYGEN_OUTPUT_DIRECTORY}"
    TYPE DOC)
