#pragma once

#include <string_view>

namespace skeleton {
    extern const uint32_t SKELETON_VERSION_MAJOR;
    extern const uint32_t SKELETON_VERSION_MINOR;
    extern const uint32_t SKELETON_VERSION_PATCH;
    extern const uint32_t SKELETON_VERSION_TWEAK;
    extern const std::string_view SKELETON_VERSION_STRING;
    extern const std::string_view GIT_HASH;

    void print_version();
}
