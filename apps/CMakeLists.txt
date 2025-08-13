set(binname ${project_name_lowercase}-cli)

add_executable(${binname}
    app.cpp
    )

target_compile_features(${binname}
    PRIVATE
    cxx_std_20
    )

target_link_libraries(${binname}
    PRIVATE
    ${CMAKE_PROJECT_NAME}
    )

install(TARGETS ${binname}
    CONFIGURATIONS Release
    RUNTIME DESTINATION ${PROJECT_INSTALL_BINDIR}
    )
