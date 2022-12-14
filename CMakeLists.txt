cmake_minimum_required(VERSION 3.14)

project(myprg
    VERSION 1.0.0
    DESCRIPTION "Template for C++ project with CMake"
    LANGUAGES CXX)
set(CMAKE_CXX_STANDARD 17)

#-------------------------------------------------------------------
# Определение опций сборки
#-------------------------------------------------------------------
option(MYPRG_BUILD_TESTS "Build mylib tests" ON)
option(USE_BOOST_LIB "Include and link boost lib to your project" ON)
option(USE_SOME_LIB "A simple lib for smth" OFF)
#-------------------------------------------------------------------

#-------------------------------------------------------------------
# Подключение внешних ресурсов
#-------------------------------------------------------------------
if(USE_SOME_LIB)
    message("USE_SOME_LIB")

    list(APPEND EXTRA_INCLUDE_DIRS "some_lib")
    list(APPEND EXTRA_LIB_DIRS "some_lib")
    list(APPEND EXTRA_LINKS pqxx)
endif()

if(USE_BOOST_LIB)
    set(Boost_USE_STATIC_LIBS ON)
    add_definitions(-DBOOST_PYTHON_STATIC_LIB)
    set(Boost_USE_MULTITHREADED ON)

    find_package( Boost 1.74 COMPONENTS program_options REQUIRED )
    message(STATUS "Boost version: ${Boost_VERSION}")
    if(Boost_FOUND)
        list(APPEND EXTRA_INCLUDE_DIRS
            ${Boost_INCLUDE_DIR} )

        list(APPEND EXTRA_LINKS
            ${Boost_LIBRARIES} )
    else()
        message(BOOST NOT FOUND)
    endif()
endif()
#----------------------------------------------------

#-------------------------------------------------------------------
# Добавление генерируемых конфигурационных файлов
#-------------------------------------------------------------------
configure_file(src/config/MyPrgConfig.h.in src/config/MyPrgConfig.h @ONLY)
#-------------------------------------------------------------------

include(GNUInstallDirs)

#-------------------------------------------------------------------
# Определим файлы с которыми будет вестись разработка
#-------------------------------------------------------------------
#Файл с main() функцией для выполнения
list(APPEND     main_source
                src/main.cpp)

#Остальные файлы, с которыми ведется работа
list(APPEND     src_sources
                src/include/inc.h
                src/sources/inc.cpp)
#-------------------------------------------------------------------

#-------------------------------------------------------------------
# Добавим корректное отбражение файлов в IDE
#-------------------------------------------------------------------
source_group(TREE "${CMAKE_CURRENT_SOURCE_DIR}" FILES ${src_sources})
source_group(TREE "${CMAKE_CURRENT_SOURCE_DIR}" FILES ${main_source})
#-------------------------------------------------------------------

add_executable(${PROJECT_NAME}
               ${main_source}
               ${src_sources}
               )

#-------------------------------------------------------------------
# Добавляем внешние ресурсы, к таргету
#-------------------------------------------------------------------
target_include_directories(${PROJECT_NAME}
    PUBLIC ${PROJECT_BINARY_DIR}
           ${EXTRA_INCLUDE_DIRS})
target_link_directories(${PROJECT_NAME} PUBLIC
    ${EXTRA_LIB_DIRS})

target_link_libraries(${PROJECT_NAME}
    ${EXTRA_LINKS})
#-------------------------------------------------------------------

#-------------------------------------------------------------------
# Определение правил установки
#-------------------------------------------------------------------
install(TARGETS ${PROJECT_NAME} DESTINATION bin)

include(InstallRequiredSystemLibraries)
#set(CPACK_RESOURCE_FILE_LICENSE )
set(CPACK_PACKAGING_VERSION_MAJOR "${PROJECT_VERSION_MAJOR}")
set(CPACK_PACKAGING_VERSION_MINOR "${PROJECT_VERSION_MINOR}")
include(CPack)
#-------------------------------------------------------------------

#-------------------------------------------------------------------
# Подключение опциональных модулей
#-------------------------------------------------------------------
if(MYPRG_BUILD_TESTS)
    enable_testing()
    add_subdirectory(tests)
endif()
#-------------------------------------------------------------------
