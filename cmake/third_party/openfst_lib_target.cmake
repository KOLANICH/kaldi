if(NOT OPENFST_ROOT_DIR)
    message(FATAL_ERROR)
endif()

set(fst_source_dir ${OPENFST_ROOT_DIR}/src/lib)
set(fst_include_dir ${OPENFST_ROOT_DIR}/src/include)

include_directories(${fst_include_dir})
file(GLOB fst_sources "${fst_source_dir}/*.cc")

add_library(fst ${fst_sources})
harden(fst)

target_include_directories(fst PUBLIC
     $<BUILD_INTERFACE:${fst_include_dir}>
     $<INSTALL_INTERFACE:include/openfst>
)

install(TARGETS fst
    EXPORT kaldi-targets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_FULL_LIBDIR}
    COMPONENT "libfst_dev"
    LIBRARY DESTINATION ${CMAKE_INSTALL_FULL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_FULL_BINDIR}
    COMPONENT "libfst"
)

install(DIRECTORY "${fst_include_dir}/fst"
    DESTINATION "${CMAKE_INSTALL_FULL_INCLUDEDIR}/openfst"
    COMPONENT "libfst_dev"
    PATTERN "test/*.h" EXCLUDE
)

unset(fst_source_dir)
unset(fst_include_dir)
unset(fst_sources)