# Check if PICO_INSTALL_PATH is set
if (NOT DEFINED ENV{PICO_INSTALL_PATH})
    # Check if pico-setup-windows is installed
    file(GLOB PICO_INSTALL_LIST LIST_DIRECTORIES true "C:/Program Files/Raspberry Pi/Pico SDK*")
    list(LENGTH PICO_INSTALL_LIST PICO_INSTALL_LIST_LENGTH)

    if (EXISTS "C:/PicoSDK")
        list(APPEND PICO_INSTALL_LIST "C:/PicoSDK")
    endif ()

    if (PICO_INSTALL_LIST_LENGTH LESS_EQUAL 0)
        message(FATAL_ERROR "PICO_INSTALL_PATH not set and pico-setup-windows not found. Install the Pico SDK from github.com/raspberrypi/pico-setup-windows.")
    else()
        message("Found ${PICO_INSTALL_LIST_LENGTH} Pico SDK installations:")
        foreach (PICO_VERSION_INI ${PICO_INSTALL_LIST})
            message("  ${PICO_VERSION_INI}")
        endforeach ()
    endif ()

    list(POP_BACK PICO_INSTALL_LIST PICO_INSTALL_GUESS)
    message("Using Pico SDK at ${PICO_INSTALL_GUESS}")

    # Read the version.ini file and parse out environment variables
    file(READ "${PICO_INSTALL_GUESS}/version.ini" PICO_VERSION_INI_CONTENTS)
    string(REGEX REPLACE "\n" ";" PICO_VERSION_INI_CONTENTS "${PICO_VERSION_INI_CONTENTS}")
    foreach (LINE ${PICO_VERSION_INI_CONTENTS})
        if ("${LINE}" MATCHES "(.*)=(.*)")
            string(FIND "${LINE}" "=" LINE_EQ_POS)
            string(SUBSTRING "${LINE}" 0 ${LINE_EQ_POS} LINE_KEY)
            MATH(EXPR LINE_EQ_POS "${LINE_EQ_POS}+1")
            string(SUBSTRING "${LINE}" ${LINE_EQ_POS} -1 LINE_VALUE)
            message("  ${LINE_KEY} = ${LINE_VALUE}")
            # Set to CMake var
            set("${LINE_KEY}" "${LINE_VALUE}")
            # Set to env var
            set("ENV{${LINE_KEY}}" "${LINE_VALUE}")
        endif ()
    endforeach ()

    if (NOT DEFINED PICO_INSTALL_PATH)
        message(FATAL_ERROR "Could not automatically find PICO_INSTALL_PATH. Set this manually in the CMake environment variables.")
    endif ()

    message("Using PICO_INSTALL_PATH from detected location ('${PICO_INSTALL_PATH}')")
else ()
    set(PICO_INSTALL_PATH $ENV{PICO_INSTALL_PATH})
    message("Using PICO_INSTALL_PATH from environment ('${PICO_INSTALL_PATH}')")
endif ()

# Check if PICO_INSTALL_PATH exists
get_filename_component(PICO_INSTALL_PATH "${PICO_INSTALL_PATH}" REALPATH BASE_DIR "${CMAKE_BINARY_DIR}")
if (NOT EXISTS ${PICO_INSTALL_PATH})
    message(FATAL_ERROR "Directory '${PICO_INSTALL_PATH}' not found")
endif ()

# Set path, Pico-related variables
# See https://github.com/raspberrypi/pico-setup-windows/blob/master/packages/pico-setup-windows/pico-env.cmd

macro(add_to_path)
    set(ENV{PATH} "${ARGV};$ENV{PATH}")
endmacro()

# PICO_SDK_VERSION, PICO_INSTALL_PATH, PICO_REG_KEY in env set from version.ini
set(ENV{PICO_SDK_PATH} "${PICO_INSTALL_PATH}/pico-sdk")
if (EXISTS "${PICO_INSTALL_PATH}/openocd" AND NOT DEFINED $ENV{OPENOCD_SCRIPTS})
    message("Using OpenOCD from SDK ('${PICO_INSTALL_PATH}/openocd')")
    set(ENV{OPENOCD_SCRIPTS} "${PICO_INSTALL_PATH}/openocd")
endif ()
add_to_path("$ENV{OPENOCD_SCRIPTS}")
# Set generator explicitly
set(CMAKE_GENERATOR "Ninja")
# Set HOME for GDB
set(ENV{HOME} "$ENV{USERPROFILE}")

add_to_path("${PICO_INSTALL_PATH}/cmake/bin")
add_to_path("${PICO_INSTALL_PATH}/gcc-arm-none-eabi/bin")
add_to_path("${PICO_INSTALL_PATH}/ninja")
add_to_path("${PICO_INSTALL_PATH}/python")
add_to_path("${PICO_INSTALL_PATH}/git/cmd")
add_to_path("${PICO_INSTALL_PATH}/pico-sdk-tools")
add_to_path("${PICO_INSTALL_PATH}/picotool")

# If pre-compiled pico-sdk-tools are not available... :(

if (NOT "$ENV{PICO_SET_TOOLCHAIN}" STREQUAL "0")
    set(CMAKE_SYSTEM_NAME Generic)
    set(CMAKE_MAKE_PROGRAM "${PICO_INSTALL_PATH}/ninja/ninja.exe")
    set(CMAKE_C_COMPILER "${PICO_INSTALL_PATH}/gcc-arm-none-eabi/bin/arm-none-eabi-gcc.exe")
    set(CMAKE_CXX_COMPILER "${PICO_INSTALL_PATH}/gcc-arm-none-eabi/bin/arm-none-eabi-c++.exe")
endif ()

# Pull in Pico SDK
include("$ENV{PICO_SDK_PATH}/external/pico_sdk_import.cmake")