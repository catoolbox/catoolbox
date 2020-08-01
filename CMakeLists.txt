# Copyright © 2019-2020, the catoolbox contributors
#
# This file is free software: you can redistribute it and/or modify it under:
# - the terms of the GNU Lesser General Public License as published by the
#   Free Software Foundation, either version 3 of the License, or (at your
#   option) any later version; and/or
# - the terms of the GNU General Public License as published by the Free
#   Software Foundation, either version 3 of the License, or (at your option)
#   any later version.
# If you modify this file, you may:
# - dual license your modifications under both sets of terms, or
# - license them under one of those sets of terms. In this case, remove the
#   set of terms you do not wish to license your modifications under from your
#   version.
#
# This file is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License and of the
# GNU Lesser General Public License along with catoolbox. If not, see
# <http://www.gnu.org/licenses/>.
#
# Additional permission under GNU GPL version 3 section 7
#
# If you modify this file by linking or combining it with
# - OpenSSL (or a modified version of that library), or
# - any C/C++ runtime library,
# containing parts covered by the terms of their respective licenses, the
# licensors of this file grant you additional permission to convey the
# resulting work.
# If you modify this software, you may extend this exception to your version of
# the software, but you are not obliged to do so. If you do not wish to do so,
# delete this exception statement from your version.

# On Mac OS X systems, we need to differentiate between the Apple Clang
# variant and the standard Clang variant, as they support different flags.
# For this reason, require CMake to be version 3.0 or higher on that OS.
# On Microsoft Windows, we require CMake 3.16 or higher to be able to
# dynamically detect DLL dependencies and copy them to the target directory at
# build time (this is required by unit tests).
if(APPLE)
    cmake_minimum_required(VERSION 3.0.0)
elseif(WIN32)
    cmake_minimum_required(VERSION 3.16.0)
else()
    cmake_minimum_required(VERSION 2.8.12)
endif()

# Report the Apple Clang compiler as AppleClang
cmake_policy(SET CMP0025 NEW)
# Enable Mac OS X RPATH usage by default
cmake_policy(SET CMP0042 NEW)
# Only interpret if() arguments when unquoted
cmake_policy(SET CMP0054 NEW)

enable_language(C)

include(CMakePackageConfigHelpers)
include(GNUInstallDirs)

project(catoolbox C)

list(APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake/Modules/")

# Set catoolbox global variables and options.
set(CATOOLBOX_VERSION_MAJOR 0)
set(CATOOLBOX_VERSION_MINOR 1)
set(CATOOLBOX_VERSION_BUILD 0)
set(CATOOLBOX_VERSION_REVISION 0) # For Windows compatibility purposes
set(CATOOLBOX_VERSION "${CATOOLBOX_VERSION_MAJOR}.${CATOOLBOX_VERSION_MINOR}.${CATOOLBOX_VERSION_BUILD}")
set(CATOOLBOX_VERSION_WITH_REVISION "${CATOOLBOX_VERSION_MAJOR}.${CATOOLBOX_VERSION_MINOR}.${CATOOLBOX_VERSION_BUILD}.${CATOOLBOX_VERSION_REVISION}")
set(CATOOLBOX_VERSION_IS_DEV_BUILD true)

if(WIN32)
    if("${CMAKE_SIZEOF_VOID_P}" STREQUAL "4")
        set(CATOOLBOX_WINDOWS_MANIFEST_PROCESSOR_ARCHITECTURE "x86")
    else("${CMAKE_SIZEOF_VOID_P}" STREQUAL "4")
        set(CATOOLBOX_WINDOWS_MANIFEST_PROCESSOR_ARCHITECTURE "ia64")
    endif("${CMAKE_SIZEOF_VOID_P}" STREQUAL "4")
endif(WIN32)

option(CATOOLBOX_BUILD_CACLI "Build and install the cacli tool." ON)
option(CATOOLBOX_RUN_TESTS "Build and run unit tests." ON)
set(CATOOLBOX_VERSION_SUFFIX "" CACHE STRING "Add this suffix to the catoolbox directories and files.")
mark_as_advanced(CATOOLBOX_VERSION_SUFFIX)

# Set C standard options.
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Set CPack options.
set(CPACK_GENERATOR "")
set(CPACK_SOURCE_GENERATOR "TGZ")
set(CPACK_PACKAGE_NAME "catoolbox")
set(CPACK_PACKAGE_VENDOR "The catoolbox contributors")
set(CPACK_PACKAGE_VERSION_MAJOR "${CATOOLBOX_VERSION_MAJOR}")
set(CPACK_PACKAGE_VERSION_MINOR "${CATOOLBOX_VERSION_MINOR}")
set(CPACK_PACKAGE_VERSION_PATCH "${CATOOLBOX_VERSION_BUILD}")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "Manage a CA with ease")
set(CPACK_SOURCE_PACKAGE_FILE_NAME "${CPACK_PACKAGE_NAME}-${CATOOLBOX_VERSION}")
include(CPack)

# Ensure that catoolbox is built out of source.
if(CMAKE_SOURCE_DIR EQUAL CMAKE_BINARY_DIR)
    message(FATAL_ERROR "catoolbox must be built outside the source directory.")
endif(CMAKE_SOURCE_DIR EQUAL CMAKE_BINARY_DIR)

# Print the version suffix for ease of debugging.
if(NOT CATOOLBOX_VERSION_SUFFIX STREQUAL "")
    message(STATUS "catoolbox version suffix found: ${CATOOLBOX_VERSION_SUFFIX}")
endif(NOT CATOOLBOX_VERSION_SUFFIX STREQUAL "")

# Enable testing.
if(CATOOLBOX_RUN_TESTS)
    # Allow overriding the CMocka include directory and library path
    # (e.g. on Win32 platforms).
    if(NOT (DEFINED CMOCKA_INCLUDE_DIR AND DEFINED CMOCKA_LIBRARIES))
        find_package(CMocka CONFIG REQUIRED)
    endif(NOT (DEFINED CMOCKA_INCLUDE_DIR AND DEFINED CMOCKA_LIBRARIES))
    enable_testing()
endif(CATOOLBOX_RUN_TESTS)
# Since the CMocka configuration file does not offer us a variable containing
# the full path to the library, we need to ask for it on Microsoft Windows.
# By default, we will try to find the binary library in
# ${CMocka_DIR}/../../../bin.
if(WIN32)
    set(CATOOLBOX_CMOCKA_BINARY_DIR "${CMocka_DIR}/../../../bin" CACHE PATH "The path to the directory where the CMocka binary files are installed.")
    if(NOT (EXISTS "${CATOOLBOX_CMOCKA_BINARY_DIR}/cmocka.dll"))
        message(FATAL_ERROR "cmocka.dll was not found in '${CATOOLBOX_CMOCKA_BINARY_DIR}'.")
    endif(NOT (EXISTS "${CATOOLBOX_CMOCKA_BINARY_DIR}/cmocka.dll"))
endif(WIN32)

set(CATOOLBOX_CMAKE_CONFIG_DIR "${CMAKE_INSTALL_LIBDIR}/cmake/CAToolbox${CATOOLBOX_VERSION_SUFFIX}")

if(NOT CMAKE_CONFIGURATION_TYPES)
    if(NOT CMAKE_BUILD_TYPE)
        message(STATUS "No build type was specified, defaulting to RelWithDebInfo.")
        set_property(CACHE CMAKE_BUILD_TYPE PROPERTY VALUE "RelWithDebInfo")
    endif(NOT CMAKE_BUILD_TYPE)
endif(NOT CMAKE_CONFIGURATION_TYPES)

configure_file("${PROJECT_SOURCE_DIR}/catoolboxconfig.h.in"
               "${PROJECT_BINARY_DIR}/catoolboxconfig.h")

# Add subdirectories.
add_subdirectory(libcatoolbox)
if(CATOOLBOX_BUILD_CACLI)
    add_subdirectory(cacli)
endif(CATOOLBOX_BUILD_CACLI)

# Install the "basic" documentation files to an appropriate directory.
install(FILES
            COPYING
            COPYING.LESSER
            LICENSE
            README.md
        DESTINATION "${CMAKE_INSTALL_DOCDIR}/catoolbox${CATOOLBOX_VERSION_SUFFIX}"
)

# Configure the CMake find_package support.
set(CATOOLBOX_INSTALL_DIR "${CMAKE_INSTALL_PREFIX}")
configure_package_config_file("${CMAKE_CURRENT_SOURCE_DIR}/cmake/CAToolboxConfig.cmake.in"
                              "${PROJECT_BINARY_DIR}/CAToolbox${CATOOLBOX_VERSION_SUFFIX}Config.cmake"
                              INSTALL_DESTINATION "${CATOOLBOX_CMAKE_CONFIG_DIR}"
                              PATH_VARS CATOOLBOX_INSTALL_DIR
)
write_basic_package_version_file("${CMAKE_CURRENT_BINARY_DIR}/CAToolbox${CATOOLBOX_VERSION_SUFFIX}Config-version.cmake"
                                 VERSION "${CATOOLBOX_VERSION}"
                                 COMPATIBILITY SameMajorVersion
)

# Register the global catoolkit target in CMake.
install(FILES
            "${CMAKE_CURRENT_BINARY_DIR}/CAToolbox${CATOOLBOX_VERSION_SUFFIX}Config.cmake"
            "${CMAKE_CURRENT_BINARY_DIR}/CAToolbox${CATOOLBOX_VERSION_SUFFIX}Config-version.cmake"
        DESTINATION "${CATOOLBOX_CMAKE_CONFIG_DIR}"
)
install(EXPORT CAToolboxTargets
        DESTINATION "${CATOOLBOX_CMAKE_CONFIG_DIR}"
        NAMESPACE CAToolbox::
        FILE "CAToolbox${CATOOLBOX_VERSION_SUFFIX}Targets.cmake"
)
