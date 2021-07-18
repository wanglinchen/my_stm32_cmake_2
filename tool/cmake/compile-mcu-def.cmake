# Target-specific flags
set(MCU_ARCH ARMCM3)
message(STATUS "MCU_ARCH: ${MCU_ARCH}")
set(MCU_FAMILY STM32F103xB)
message(STATUS "MCU_FAMILY: ${MCU_FAMILY}")
set(MCU_NAME STM32F103C8)
message(STATUS "MCU_NAME: ${MCU_NAME}")

set(CPU "-mcpu=cortex-m3")
set(FPU "")
set(FLOAT_ABI "")

set(LINKER_SCRIPT ${PROJECT_SOURCE_DIR}/tool/script/STM32F103C8Tx_FLASH.ld)
message(STATUS "Linker script: ${LINKER_SCRIPT}")

option(USE_LL_LIB "Enable LL library" ON)
message(STATUS "Use LL library: ${USE_LL_LIB}")
option(USE_HAL_LIB "Enable HAL library" OFF)
message(STATUS "Use HAL library: ${USE_HAL_LIB}")

option(USE_SYSTEM_VIEW "Enable Segger SystemView library" OFF)
message(STATUS "Use Segger SystemView library: ${USE_SYSTEM_VIEW}")




