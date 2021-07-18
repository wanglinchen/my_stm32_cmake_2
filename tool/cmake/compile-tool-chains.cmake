# the name of the target operating system
set(CMAKE_SYSTEM_NAME   Generic)
set(CMAKE_SYSTEM_PROCESSOR  Arm)
set(CMAKE_SYSTEM_VERSION  1)



# specify the cross compiler
set(CMAKE_C_COMPILER ${CROSS_COMPILE_PREFIX}gcc)
message(STATUS "Specified C compiler: ${CMAKE_C_COMPILER}")
set(CMAKE_CXX_COMPILER ${CROSS_COMPILE_PREFIX}g++)
message(STATUS "Specified CXX compiler: ${CMAKE_CXX_COMPILER}")
set(CMAKE_ASM_COMPILER ${CROSS_COMPILE_PREFIX}gcc)
message(STATUS "Specified ASM compiler: ${CMAKE_ASM_COMPILER}")
set(CMAKE_OBJCOPY ${CROSS_COMPILE_PREFIX}objcopy)
message(STATUS "Specified object copy: ${CMAKE_OBJCOPY}")
set(CMAKE_OBJDUMP ${CROSS_COMPILE_PREFIX}objdump)
message(STATUS "Specified object dump: ${CMAKE_OBJDUMP}")

# find additional toolchain executables
find_program(ARM_SIZE_EXECUTABLE ${CROSS_COMPILE_PREFIX}size)
find_program(ARM_GDB_EXECUTABLE ${CROSS_COMPILE_PREFIX}gdb)
find_program(ARM_OBJCOPY_EXECUTABLE ${CROSS_COMPILE_PREFIX}objcopy)
find_program(ARM_OBJDUMP_EXECUTABLE ${CROSS_COMPILE_PREFIX}objdump)



#set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

#指定交叉编译环境安装目录
# search for program/library/include in the build host directories

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
