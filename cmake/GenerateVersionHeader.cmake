# Get the latest commit hash of the working branch
if(GIT_EXECUTABLE)
  execute_process(
    COMMAND ${GIT_EXECUTABLE} log -1 --format=%H
    OUTPUT_VARIABLE GIT_HASH
    OUTPUT_STRIP_TRAILING_WHITESPACE
    )
endif()

# Find the up-to-date version string
execute_process(
    COMMAND ${SCRIPTS_DIR}/version.sh
    OUTPUT_VARIABLE VERSION_STRING
    OUTPUT_STRIP_TRAILING_WHITESPACE
)

# Make sure the version list/string contains all four arguments
# Append 0s if it's shorter than 4
string(REPLACE "." ";" VERSION_LIST ${VERSION_STRING})
list(LENGTH VERSION_LIST LEN)
while(LEN LESS 4)
    list(APPEND VERSION_LIST 0)
    list(LENGTH VERSION_LIST LEN)
endwhile()

list(GET VERSION_LIST 0 VERSION_MAJOR)
list(GET VERSION_LIST 1 VERSION_MINOR)
list(GET VERSION_LIST 2 VERSION_PATCH)
list(GET VERSION_LIST 3 VERSION_TWEAK)

configure_file(${SRC} ${DST} @ONLY)
