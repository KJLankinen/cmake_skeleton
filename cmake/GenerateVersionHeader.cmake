# Get the latest commit hash of the working branch
if(GIT_EXECUTABLE)
  execute_process(
    COMMAND ${GIT_EXECUTABLE} log -1 --format=%H
    OUTPUT_VARIABLE GIT_HASH
    OUTPUT_STRIP_TRAILING_WHITESPACE
    )
endif()

configure_file(${SRC} ${DST} @ONLY)
