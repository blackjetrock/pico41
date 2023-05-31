cmake_minimum_required(VERSION 3.13)

# initalize pico_sdk from installed location
# (note this can come from environment, CMake cache etc)
set(PICO_SDK_PATH "/tree/downloaded_tools/pico/pico-sdk")

include(pico_sdk_import.cmake)
project(pico41 C CXX ASM)
set(PICO_COPY_TO_RAM 1)

set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)

pico_sdk_init()
add_executable(pico41
pico41.c
)

pico_enable_stdio_usb(pico41 1)
pico_enable_stdio_uart(pico41 0)
pico_add_extra_outputs(pico41)
target_link_libraries(pico41 pico_stdlib)

# Add any user requested libraries
target_link_libraries(pico41
        #hardware_i2c
        hardware_pio
        hardware_clocks
	hardware_adc
        pico_multicore
        )
