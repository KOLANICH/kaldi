set(PUBLIC_HEADERS
    tensorflow-rnnlm.h
)

add_library(kaldi-tfrnnlm
    tensorflow-rnnlm.cc
)

if(NOT EXISTS ${TENSORFLOW_DIR}/bazel-bin/tensorflow/libtensorflow_framework.so
    OR NOT EXISTS ${TENSORFLOW_DIR}/bazel-bin/tensorflow/libtensorflow_cc.so)
    message(FATAL_ERROR "TensorFlow components are not built, please build TensorFlow first.")
endif()

target_include_directories(kaldi-tfrnnlm PUBLIC 
    ${TENSORFLOW_DIR}/bazel-tensorflow/external/com_google_protobuf/src
    ${TENSORFLOW_DIR}/bazel-genfiles
    ${TENSORFLOW_DIR}
    ${TENSORFLOW_DIR}/tensorflow/lite/tools/make/downloads/eigen
    ${TENSORFLOW_DIR}/tensorflow/lite/tools/make/downloads/absl
)

target_include_directories(kaldi-tfrnnlm PUBLIC 
     $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/..>
     $<INSTALL_INTERFACE:include/kaldi>
)

target_link_libraries(kaldi-tfrnnlm PUBLIC
    kaldi-lm
    kaldi-util
    kaldi-matrix
    kaldi-base
    -lz
    -ldl
    -fPIC
    -L${TENSORFLOW_DIR}/bazel-bin/tensorflow
    -ltensorflow_cc
    -ltensorflow_framework
)


install(TARGETS kaldi-tfrnnlm
    EXPORT kaldi-targets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_FULL_LIBDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_FULL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_FULL_BINDIR}
    COMPONENT tfrnnlm
)

install(FILES ${PUBLIC_HEADERS} DESTINATION include/kaldi/tfrnnlm COMPONENT tfrnnlm_dev)

set(CPACK_DEBIAN_TFRNNLM_PACKAGE_NAME "libkaldi-tfrnnlm" PARENT_SCOPE)
set(CPACK_DEBIAN_TFRNNLM_PACKAGE_DEPENDS "libkaldi" PARENT_SCOPE)

set(CPACK_DEBIAN_TFRNNLM_DEV_PACKAGE_NAME "${CPACK_DEBIAN_TFRNNLM_PACKAGE_NAME}-dev" PARENT_SCOPE)
set(CPACK_DEBIAN_TFRNNLM_DEV_PACKAGE_DEPENDS "${CPACK_DEBIAN_TFRNNLM_PACKAGE_NAME}" PARENT_SCOPE)
pass_through_cpack_vars()
