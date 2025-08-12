#include <cstdio>
#include <skeleton/lib.hpp>
#include <skeleton/version.hpp>

int main(int argc, char **argv) {
    std::printf("%d\n", skeleton::add(argc, argc));
    skeleton::print_version();

    return 0;
}
