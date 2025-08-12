#define CATCH_CONFIG_MAIN
#include <catch2/catch_test_macros.hpp>
#include <skeleton/lib.hpp>

TEST_CASE("Add works", "[main]") { REQUIRE(2 == skeleton::add(1, 1)); }
