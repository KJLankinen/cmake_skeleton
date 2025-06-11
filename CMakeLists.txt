cmake_minimum_required(VERSION 3.18...3.29)

project(jlfoam
    VERSION 0.1
    DESCRIPTION "Foam simulation"
    LANGUAGES CXX)

add_subdirectory(apps)
add_subdirectory(docs)
add_subdirectory(src)
add_subdirectory(tests)
