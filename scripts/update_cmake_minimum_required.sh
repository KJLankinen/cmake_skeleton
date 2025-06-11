#!/bin/bash

# This script updates the minimum and maximum versions required by CMake
# in the CMakeLists.txt

minimum=3.18
maximum=3.29

get_subdirs_from_cmake_lists() {
    sed -n "s/add_subdirectory(\(.*\))/\1/p" $1
}

get_cmake_lists_txt() {
    # $1 is the directory containing the top level CMakeLists.txt
    file="$1/CMakeLists.txt"
    declare -a arr=($file)

    for dir in $(get_subdirs_from_cmake_lists $file)
    do
        arr+=($(get_cmake_lists_txt "$1/$dir"))
    done
    echo "${arr[@]}"
}

for file in $(get_cmake_lists_txt ".")
do
    echo $file
    sed -i "s/\(cmake_minimum_required(VERSION\) \([0-9]*\.[0-9]*\)\(\.\.\.\)\(.*\))/\1 $minimum\3$maximum)/" $file
done

