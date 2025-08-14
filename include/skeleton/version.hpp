/*
 * SPDX-FileCopyrightText: 2025 Juhana Lankinen
 *
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <string_view>

namespace skeleton {
/// \brief The major component of the version string, e.g. `1` from `1.0.2.6`
extern const uint32_t VERSION_MAJOR;
/// \brief The minor component of the version string, e.g. `0` from `1.0.2.6`
extern const uint32_t VERSION_MINOR;
/// \brief The patch component of the version string, e.g. `2` from `1.0.2.6`
extern const uint32_t VERSION_PATCH;
/// \brief The tweak component of the version string, e.g. `6` from `1.0.2.6`
extern const uint32_t VERSION_TWEAK;
/// \brief The version as a string, e.g. `1.0.12`
extern const std::string_view VERSION_STRING;
/// \brief The git hash of the latest commit during build time
extern const std::string_view GIT_HASH;
/// \brief The name of the project
extern const std::string_view NAME;

/// \brief Prints out some meta information of this project
void print_version();
}
