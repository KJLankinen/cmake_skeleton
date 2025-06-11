# Note that headers are optional, and do not affect add_library, but they will not
# show up in IDEs unless they are listed in add_library.

file(GLOB HEADER_LIST CONFIGURE_DEPENDS "${PROJECT_SOURCE_DIR}/include/${CMAKE_PROJECT_NAME}/*.hpp")

set(libname ${CMAKE_PROJECT_NAME}-lib)

# Make an automatic library - will be static or dynamic based on user setting
add_library(${libname}
    lib.cpp
    ${HEADER_LIST})

# We need this directory, and users of our library will need it too
target_include_directories(${libname} PUBLIC ../include)

# This depends on (header only) boost
#target_link_libraries(library PRIVATE Boost::boost)

# All users of this library will need at least C++20
target_compile_features(${libname} PUBLIC cxx_std_20)

# Don't replace e.g. std=c++20 with std=g++20
set_target_properties(${libname} PROPERTIES CXX_EXTENSIONS OFF)

# For position independent code
#set_target_properties(lib1 PROPERTIES POSITION_INDEPENDENT_CODE ON)

# IDEs should put the headers in a nice place
source_group(
  TREE "${PROJECT_SOURCE_DIR}/include"
  PREFIX "Header Files"
  FILES ${HEADER_LIST})
