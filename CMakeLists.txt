cmake_minimum_required(VERSION 3.14)

set(PROG_NAME myprg)

project(${PROG_NAME}
    VERSION 1.0.0
    DESCRIPTION "Template for C++ project with CMake"
    LANGUAGES CXX)

#--------------------------------------------------------------
# submodule section
# here we use the following code to support
# old versions of git(that don't download submodule
# contents automatically).
#--------------------------------------------------------------
# [[[
find_package(Git QUIET)
if(GIT_FOUND AND EXISTS "${PROJECT_SOURCE_DIR}/.git")
  if(GIT_SUBMODULE)
    message(STATUS "Submodule update")
    execute_process(
      COMMAND ${GIT_EXECUTABLE} submodule update
      --init --recursive
      WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
      RESULT_VARIABLE GIT_SUBMOD_RESULT
    )
    if(NOT GIT_SUBMOD_RESULT EQUAL "0")
      message(FATAL_ERROR "Git submodule update --init failed with ${GIT_SUBMODULE_RESULT}, Please checkout submodules")
    endif()
  endif()
endif()

# ]]]
#


include(GNUInstallDirs)

set(    main_source
        src/main.cpp)

source_group(TREE "${CMAKE_CURRENT_SOURCE_DIR}" FILES ${main_source})

set(    src_sources
        src/include/inc.h
        src/sources/inc.cpp)

source_group(TREE "${CMAKE_CURRENT_SOURCE_DIR}" FILES ${src_sources})

add_executable(${PROG_NAME}
               ${main_source}
               ${src_sources})


