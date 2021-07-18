#######################################################################################
#                                     宏定义
#######################################################################################
#设置cmake版本要求
macro(SET_REQ_CMAKE_VERSION )
    message(STATUS "CURRENT_CMAKE_VERSION:${CMAKE_VERSION}")
    if("${ARGV0}" STREQUAL "")
        set(REQ_CMAKE_VERSION ${CMAKE_VERSION})
    else()
        set(REQ_CMAKE_VERSION ${ARGV0})
    endif()
    message(STATUS "SET_REQ_CMAKE_VERSION:${REQ_CMAKE_VERSION}")
    cmake_minimum_required (VERSION ${REQ_CMAKE_VERSION})
endmacro()

#进入当前目录提示
macro(ENTER_CUR_DIR)
    message(STATUS "ENTER_CUR_DIR:${CMAKE_CURRENT_SOURCE_DIR}")
endmacro()

#获取当前模块的名字
macro(GET_CUR_MOD_NAME )
    # remove last end of "/"
    string(REGEX REPLACE "/$" "" CUR_DIR_ABS ${CMAKE_CURRENT_SOURCE_DIR})
    # 获取当前目录名
    get_filename_component(CUR_MOD_NAME ${CUR_DIR_ABS} NAME)
    message(STATUS "GET_CUR_MOD_NAME:${CUR_MOD_NAME}")
endmacro()

#设置工程名
macro(SET_PROJECT_NAME )
    if("${ARGV0}" STREQUAL "")
        set(PROJECT_NAME ${CUR_MOD_NAME})
    else()
        set(PROJECT_NAME ${ARGV0})
    endif()
    project(${PROJECT_NAME} LANGUAGES)
    message(STATUS "SET_PROJECT_NAME:${PROJECT_NAME}")
endmacro(SET_PROJECT_NAME)

#设置目标文件
macro(SET_TARGET_NAME )
    if("${ARGV0}" STREQUAL "")
        set(TARGET_NAME ${PROJECT_NAME})
    else()
        set(TARGET_NAME ${ARGV0})
    endif()
    #设置目标文件名
    set(TARGET_ELF ${TARGET_NAME}.elf )
    set(TARGET_HEX ${TARGET_NAME}.hex )
    set(TARGET_BIN ${TARGET_NAME}.bin )
    message(STATUS "SET_TARGET_NAME:${TARGET_ELF},${TARGET_HEX},${TARGET_BIN}")
endmacro()

#设置编译类型
macro(SET_BUILD_TYPE )
    if("${ARGV0}" STREQUAL "")
        set(BUILD_TYPE debug)
    else()
        set(BUILD_TYPE ${ARGV0})
    endif()
    message(STATUS "BUILD_TYPE:${BUILD_TYPE}")
endmacro()

#设置编译工具链和编译参数
macro(SET_BUILD_TOOL )
    if("${ARGV0}" STREQUAL "")
        set(CROSS_COMPILE_PREFIX arm-none-eabi-)
    else()
        set(CROSS_COMPILE_PREFIX ${ARGV0})
    endif()
    message(STATUS "SET_BUILD_TOOL:${CROSS_COMPILE_PREFIX}")
    #包含工具链和编译参数以及MCU定义
    include(${PROJECT_SOURCE_DIR}/tool/cmake/compile-tool-chains.cmake)
    include(${PROJECT_SOURCE_DIR}/tool/cmake/compile-mcu-def.cmake)
    include(${PROJECT_SOURCE_DIR}/tool/cmake/compile-flags.cmake)
endmacro(SET_BUILD_TOOL)

#查找main.c所在目录，指定executable模块
macro(ADD_EXE_MODULE )
    set(CUR_DIR ${CMAKE_CURRENT_SOURCE_DIR})
    file(GLOB CUR_DIR_SRCS RELATIVE ${CUR_DIR} 
    ${CUR_DIR}/*.c
    ${CUR_DIR}/*.cpp)

    set(IS_EXE_MODULE "")
    if("${CUR_DIR_SRCS}" STREQUAL "")
        message(STATUS "ADD_EXE_MODULE:${CUR_DIR_SRCS}")
    else()
        foreach(SRC ${CUR_DIR_SRCS})
            if(SRC MATCHES main.c OR main.cpp)
                list(APPEND IS_EXE_MODULE yes)
            endif()
        endforeach()
        if(${IS_EXE_MODULE} MATCHES yes)
            message(STATUS "ADD_EXE_MODULE:${CUR_DIR_SRCS}")
            add_executable(${TARGET_ELF} ${CUR_DIR_SRCS})
            message(STATUS "generate executable ${TARGET_ELF} with ${CUR_DIR_SRCS}")
        endif()
    endif()
endmacro(ADD_EXE_MODULE)

#在当前目录查找源文件，指定生成静态库文件
macro(ADD_STATIC_LIB_MODULE )
    set(CUR_DIR ${CMAKE_CURRENT_SOURCE_DIR})
    file(GLOB CUR_DIR_SRCS RELATIVE ${CUR_DIR} 
    ${CUR_DIR}/*.c
    ${CUR_DIR}/*.cpp)

    set(IS_EXE_MODULE "")
    if("${CUR_DIR_SRCS}" STREQUAL "")
        message(STATUS "ADD_STATIC_LIB_MODULE:${CUR_DIR_SRCS}")
    else()
        foreach(SRC ${CUR_DIR_SRCS})
            if(SRC MATCHES main.c)
                list(APPEND IS_EXE_MODULE yes)
            endif()
        endforeach()
        if(IS_EXE_MODULE MATCHES "")
            message(STATUS "ADD_STATIC_LIB_MODULE:${CUR_DIR_SRCS}")
            add_library(${CUR_MOD_NAME} STATIC ${CUR_DIR_SRCS})
            message(STATUS "generate library ${CUR_MOD_NAME} with ${CUR_DIR_SRCS}")
        endif()
    endif()
endmacro(ADD_STATIC_LIB_MODULE)

#在当前目录搜索头文件
macro(ADD_CUR_DIR_INCS )
    set(CUR_DIR ${CMAKE_CURRENT_SOURCE_DIR})
    file(GLOB CUR_DIR_INCS RELATIVE ${CUR_DIR} 
    ${CUR_DIR}/*.h
    ${CUR_DIR}/*.hpp)

    if("${CUR_DIR_INCS}" STREQUAL "")
        message(STATUS "ADD_CUR_DIR_INCS:${CUR_DIR_INCS}")
    else()
        message(STATUS "ADD_CUR_DIR_INCS:${CUR_DIR_INCS}")
        target_include_directories(${CUR_MOD_NAME} PRIVATE ${CUR_DIR_INCS})
        message(STATUS "add includes of ${CUR_MOD_NAME} with ${CUR_DIR_INCS}")
    endif()
endmacro(ADD_CUR_DIR_INCS)

#搜索子模块
macro(ADD_SUB_MODULES )
    set(CUR_DIR ${CMAKE_CURRENT_SOURCE_DIR})
    file(GLOB SUB_DIR_FILES RELATIVE ${CUR_DIR} ${CUR_DIR}/*)

    set(SUB_MODULE_LIST "")
    if("${SUB_DIR_FILES}" STREQUAL "")
        message(STATUS "ADD_SUB_MODULES:${SUB_MODULE_LIST}")
    else()
        foreach(FILE ${SUB_DIR_FILES})
        if(IS_DIRECTORY ${CUR_DIR}/${FILE})
            if(EXISTS ${CUR_DIR}/${FILE}/CMakeLists.txt)
                list(APPEND SUB_MODULE_LIST ${FILE})
            endif()
        endif()
        endforeach(FILE)
        if("${SUB_MODULE_LIST}" STREQUAL "")
            message(STATUS "ADD_SUB_MODULES:${SUB_MODULE_LIST}")
        else()
            message(STATUS "ADD_SUB_MODULES:${SUB_MODULE_LIST}")
        endif()
        foreach(SUB_MODULE ${SUB_MODULE_LIST})
            add_subdirectory(${SUB_MODULE})
        endforeach(SUB_MODULE)
    endif()
endmacro(ADD_SUB_MODULES)

########################################################################################################
#                                           调用
########################################################################################################
#设置cmake版本要求
SET_REQ_CMAKE_VERSION(3.0)

#进入当前目录提示
ENTER_CUR_DIR()

#获取当前模块的名字
GET_CUR_MOD_NAME()

#设置工程名
SET_PROJECT_NAME()

#设置目标文件名
SET_TARGET_NAME()

#设置编译类型
SET_BUILD_TYPE()

#设置编译工具
SET_BUILD_TOOL()

#找到mani.c所在目录，生成可执行文件
ADD_EXE_MODULE()

#查找当前目录文件添加静态库
ADD_STATIC_LIB_MODULE()

#查找当前目录的头文件
ADD_CUR_DIR_INCS()

#查找当前目录下的子模块
ADD_SUB_MODULES()
