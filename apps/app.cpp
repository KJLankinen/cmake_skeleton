/*
 * SPDX-FileCopyrightText: 2025 Juhana Lankinen
 *
 * SPDX-License-Identifier: MIT
 */

#include <cstdint>
#include <fstream>
#include <nlohmann/json.hpp>
#include <skeleton/skeleton.hpp>
#include <spdlog/spdlog.h>
#include <string>

using json = nlohmann::json;

int main(int argc, char **argv) {
    // Demonstrate the usage of all the external dependencies and the main
    // library
    skeleton::print_version();

    std::ifstream f("data/input.json");
    json data = json::parse(f);

    const auto number = data["number"].template get<int32_t>();

    spdlog::info("Number: {}, 2x number: {}, word: \"{}\"", number,
                 skeleton::add(number, number),
                 data["word"].template get<std::string>());

    return 0;
}
