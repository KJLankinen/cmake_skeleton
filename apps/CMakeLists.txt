set(binname ${CMAKE_PROJECT_NAME}-bin)

add_executable(${binname}
    app.cpp
    )

target_compile_features(${binname}
    PRIVATE
    cxx_std_20
    )

target_link_libraries(${binname}
    PRIVATE
    ${CMAKE_PROJECT_NAME}-lib
    )
