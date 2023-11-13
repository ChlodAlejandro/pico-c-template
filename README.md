# Raspberry Pi Pico C/C++ base project

This is a template for a Raspberry Pi Pico C/C++ project. It uses
the [Raspberry Pi Pico SDK](https://www.raspberrypi.com/documentation/pico-sdk)
and [CMake](https://cmake.org/) to build the project. This project is
configured to run on CLion on Windows; for a Visual Studio Code version,
see the `Pico - Visual Studio Code` shortcut bundled with the SDK instead.

## Getting started

### Prerequisites
> [!IMPORTANT]
> If possible, install the Pico SDK in a location that does not contain any spaces.
> This means **not** installing it in "C:/Program Files/". You will be unable to
> debug with OpenOCD in CLion if this is not the case. By default, this template
> will also look at "C:/PicoSDK". If you installed your SDK in a different location,
> set `PICO_INSTALL_PATH` as an environment variable or a CMake variable.
> 
> In addition, you also need to place **your project** in a location that does
> not contain any spaces. If your user directory contains spaces (e.g.
> "C:/Users/John Smith/"), move your project to a different folder on your drive.

* [Pico SDK](https://github.com/raspberrypi/pico-setup-windows/releases/latest/)
* [CLion](https://www.jetbrains.com/clion/)
* [CMake](https://cmake.org/download/)
  * For a quick installation on Windows 11, run `winget install Kitware.CMake` in cmd/PowerShell.

### Project structure
The CLion CMake configuration is stored and shared inside the project files.
The default project is named pico_base_main, and refers to the project in the
`includes/` directory. The CMakeLists.txt file in this directory is used to
build the project. **Libraries need to be explicitly linked here.**

### CMake
CMake will automatically detect an installation of the Pico SDK on first load.
If you have multiple versions of the SDK installed, the latest one will be
used. If you want to use a specific version, set the `PICO_INSTALL_PATH`
environment variable in the CMake settings of the IDE (or in 
`.idea/cmake.xml`).

**The compiler toolchain set in CLion will always be  overridden by the
arm-none-eabi-gcc toolchain bundled with the SDK.** To avoid this, set the
`PICO_SET_TOOLCHAIN` environment variable to `0`.

CLion will automatically load the project when the template has been opened
and trusted. If you want to load the project manually, run `cmake .` in the
current folder.

> [!NOTE]
> To set CMake variables, go to `File > Settings > Build, Execution, Deployment > CMake`.
> At the bottom, there is an "Environment" field. You may add the variables here,
> separated by semicolons, or click on the "$" icon on the right side for a graphical
> interface.

### Building
To build the project, run Build (Ctrl + F9) with the "pico_base_main" 
configuration. CMake will build the executable and generate build files.
Output files, such as the .elf/.uf2 files, will be located in `build/includes`.
You can then flash this onto your Pico as you would normally.

**Building for Pico W?** Set the `PICO_BOARD` environment variable to `pico_w`
or add the following line to the top-level or project-level `CMakeLists.txt`:
```cmake
set(PICO_BOARD pico_w)
```

### Running with PicoProbe
> [!NOTE]
> Debugging (but not running) requires that the project and the SDK be located in
> a folder without spaces due to a CLion bug. This is being tracked at
> [CPP-28608](https://youtrack.jetbrains.com/issue/CPP-28608). While this bug
> remains unfixed, you will need to move your project and SDK (reinstalling,
> if required) to a path without spaces.

CLion has built-in OpenOCD support, which can be used to run or debug firmware
running on the Pico through PicoProbe. For more info on PicoProbe, see the
[Pico Getting Started Guide, Appendix A: Using PicoProbe](https://datasheets.raspberrypi.com/pico/getting-started-with-pico.pdf)
OpenOCD is bundled with the Pico SDK, so you can skip to the "PicoProbe Wiring"
section.

> [!IMPORTANT]
> Due to oddities in the packaging of OpenOCD in the Raspberry Pi Pico SDK,
> a symlink needs to be created in the SDK folder. Before doing the following
> step, run the following command in an elevated (administrator) Command
> Prompt in the SDK folder:
> ```cmd
> mklink /J openocd\bin openocd
> ```

Point CLion to the proper OpenOCD executable in the IDE settings. Go to
`File > Settings > Build, Execution, Deployment > Embedded Development`,
and set the "OpenOCD Location" to the "openocd.exe" file found in the
`openocd/bin` folder of the Pico SDK.

A custom board configuration must be used for OpenOCD. This is the `pico-debug.cfg`
file at the root of this template. To use this, go to the "Run through PicoProbe"
configuration, and update the "Board config file" to point to that configuration
file.

After this, you can now use the "Run through PicoProbe (OpenOCD)" configuration
to run the firmware on the Pico. Running normally will flash the firmware and
reset the Pico; debugging will flash the firmware and enter a GDB debug
session on the Pico. You can then set breakpoints, step debug, and do as you
would a normal C project.

## License
```
Copyright 2023 Chlod Alejandro

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the “Software”),
to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom
the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.
```