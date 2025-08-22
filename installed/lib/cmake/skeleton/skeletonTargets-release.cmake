#----------------------------------------------------------------
# Generated CMake target import file for configuration "Release".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "skeleton::skeleton" for configuration "Release"
set_property(TARGET skeleton::skeleton APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(skeleton::skeleton PROPERTIES
  IMPORTED_LINK_DEPENDENT_LIBRARIES_RELEASE "spdlog::spdlog"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libskeleton.so.0.0.0.0"
  IMPORTED_SONAME_RELEASE "libskeleton.so.0"
  )

list(APPEND _cmake_import_check_targets skeleton::skeleton )
list(APPEND _cmake_import_check_files_for_skeleton::skeleton "${_IMPORT_PREFIX}/lib/libskeleton.so.0.0.0.0" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
