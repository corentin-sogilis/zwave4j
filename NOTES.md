# Specific notes for Technosens

## Context

After the Sauron Eye Tester, the logical way to go was to explore the
existing bindings between open-zwave and Java. Zwave4j is a good
starting point as it provides precisely a JNI interface for
open-zwave.

Zwave4j was last modified in 2015 (3 years ago to date) and the gradle
script to build the project against an open-zwave repository is out
of date and do not work with recent versions of open-zwave. Hence the
work to create a Makefile that replaces the gradle script. Why not
just updating the gradle script ? Because Gradle is a monstruous wart
on top of all the maven cesspit and I doubt anyone is really able to
understand a gradle script that aims at building C++.

The idea is to provide a way for java applications to call the C++
functions of open-zwave through the JNI interface. So the project
needs to add functions to the open-zwave C++ library that conform the
the specification of JNI in order to provide a new C++ library that
will be handle by the zwave4j final jar.

Since it is not possible to add object files to an existing C++ shared
library (.so), we need to get access to the original object files of
open-zwave. Then we can add the additional interface functions after
compiling them and build a new shared library, libzwave4j.so.

To get quickly to a working example of ZWave controller use on
Android, we skip all the platform considerations and compile only
binaries for the target architecture.

## Requirements

Clone the open-zwave
[repository](https://github.com/OpenZWave/open-zwave) and build it
with the provided instructions.

## Compilation process

1. Build the java classes with a minimal gradle file
   (minimal.gradle.build)
2. Build open-zwave from the cloned repository
3. Copy object files from open-zwave/.lib to the build directory of
   libzwave4j
4. Generate the C++ headers from the Java classes designed to be the
   interface to the open-zwave Manager and Options objects with javah
5. Build the zwave4j C++ functions that comply with the generated
   headers. Note :
       - Include open-zwave headers
       - Include JNI headers from java home
       - Include generated header from step 4
       - Compile with -fPIC flag, like open-zwave
6. Link all the objects to libzwave4j.so. Note :
       - Pass the -Wl,-fPIC option for the linker
       - Link with udev (-ludev) on linux
7. Copy the shared library to the directory next to zwave4j.jar where
   it can be loaded as a resource (native_libs/linux/x86-64)

## Steps to build and run

Check the Makefile to see if those two variables are suitable to your
configuration :
    USB_ZWAVE_DEVICE usually /dev/ttyACM0, or /dev/ttyUSB0
                     check dmesg when plugin controller in
    OPENZWAVE_DIR    directory of the open-zwave git repository
                     ../open-zwave if you cloned next to zwave4j repo

You can define those by setting matching environment variables.

Then you can run the following commands to build, then run the example
program.

    make
    make run
