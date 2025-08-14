set(binname ${project_name_lowercase}_bin)

add_executable(${binname}
    app.cpp
    )

target_compile_features(${binname}
    PRIVATE
    cxx_std_20
    )

target_link_libraries(${binname}
    PRIVATE
    ${project_name_lowercase}
    )

set_target_properties(${binname}
    PROPERTIES
    OUTPUT_NAME ${project_name_lowercase}
    )

install(TARGETS ${binname}
    CONFIGURATIONS Release
    RUNTIME DESTINATION ${PROJECT_INSTALL_BINDIR}
    )
