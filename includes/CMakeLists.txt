add_executable(pico_base_main
        main.c
)

# pull in common dependencies
target_link_libraries(pico_base_main
        # See https://www.raspberrypi.com/documentation/pico-sdk/ for a
        # list of libraries that can be linked.
        #
        # Adding something here? Be sure to reload your CMake project
        # afterwards! This will make CLion index the newly-added libraries
        # for code completion.
        pico_stdlib
)

# create map/bin/hex/uf2 file etc.
pico_add_extra_outputs(pico_base_main)