set(binname ${PROJECT_NAME}-cli)

add_executable(${binname}
    app.cpp
    )

target_compile_features(${binname}
    PRIVATE
    cxx_std_20
    )

target_link_libraries(${binname}
    PRIVATE
    ${PROJECT_NAME}
    )

set_target_properties(${binname}
    PROPERTIES
    OUTPUT_NAME ${PROJECT_NAME}
    )

install(TARGETS ${binname}
    CONFIGURATIONS Release
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    )
