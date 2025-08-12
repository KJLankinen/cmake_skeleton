#pragma once

#include <string_view>

namespace skeleton {
extern const uint32_t PROJECT_VERSION_MAJOR;
extern const uint32_t PROJECT_VERSION_MINOR;
extern const uint32_t PROJECT_VERSION_PATCH;
extern const uint32_t PROJECT_VERSION_TWEAK;
extern const std::string_view PROJECT_VERSION_STRING;
extern const std::string_view PROJECT_GIT_HASH;
extern const std::string_view PROJECT_NAME;

void print_version();
}
