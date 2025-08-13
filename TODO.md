## TODO

- Parse git tag to version number with sed
- Add extern directory and figure out what to do there: CMakeLists.txt with add\_subdir?
    - Add extern, then add the FetchContent things there
    - E.g. catch2: use it in tests, but declare in extern?
        - No, since it's only used for testing
    - Is it ok to use FetchContentMakeAvail in many places?
