# Copyright © 2019, the catoolbox contributors
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

cmake_minimum_required(VERSION 2.8.12)

# Enable Mac OS X RPATH usage by default
cmake_policy(SET CMP0042 NEW)

include(CMakePackageConfigHelpers)
include(GNUInstallDirs)

project(catoolbox C)

list(APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake/Modules/")

# Set catoolbox global variables and options.
set(CATOOLBOX_VERSION_MAJOR 0)
set(CATOOLBOX_VERSION_MINOR 1)
set(CATOOLBOX_VERSION_BUILD 0)
set(CATOOLBOX_VERSION "${CATOOLBOX_VERSION_MAJOR}.${CATOOLBOX_VERSION_MINOR}.${CATOOLBOX_VERSION_BUILD}")
set(CATOOLBOX_VERSION_IS_DEV_BUILD true)

option(CATOOLBOX_BUILD_CACLI "Build and install the cacli tool." ON)

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

set(CATOOLBOX_CMAKE_CONFIG_DIR "${CMAKE_INSTALL_LIBDIR}/cmake/CAToolbox${CATOOLBOX_VERSION_MAJOR}")

if(NOT CMAKE_CONFIGURATION_TYPES)
    if(NOT CMAKE_BUILD_TYPE)
        message(STATUS "No build type was specified, defaulting to Release.")
        set_property(CACHE CMAKE_BUILD_TYPE PROPERTY VALUE "Release")
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
        DESTINATION "${CMAKE_INSTALL_DOCDIR}/catoolbox-${CATOOLBOX_VERSION_MAJOR}"
)

# Configure the CMake find_package support.
set(CATOOLBOX_INSTALL_DIR "${CMAKE_INSTALL_PREFIX}")
configure_package_config_file("${CMAKE_CURRENT_SOURCE_DIR}/cmake/CAToolboxConfig.cmake.in"
                              "${PROJECT_BINARY_DIR}/CAToolbox${CATOOLBOX_VERSION_MAJOR}Config.cmake"
                              INSTALL_DESTINATION "${CATOOLBOX_CMAKE_CONFIG_DIR}"
                              PATH_VARS CATOOLBOX_INSTALL_DIR
)
write_basic_package_version_file("${CMAKE_CURRENT_BINARY_DIR}/CAToolbox${CATOOLBOX_VERSION_MAJOR}Config-version.cmake"
                                 VERSION "${CATOOLBOX_VERSION}"
                                 COMPATIBILITY SameMajorVersion
)

# Register the global catoolkit target in CMake.
install(FILES
            "${CMAKE_CURRENT_BINARY_DIR}/CAToolbox${CATOOLBOX_VERSION_MAJOR}Config.cmake"
            "${CMAKE_CURRENT_BINARY_DIR}/CAToolbox${CATOOLBOX_VERSION_MAJOR}Config-version.cmake"
        DESTINATION "${CATOOLBOX_CMAKE_CONFIG_DIR}"
)
install(EXPORT CAToolboxTargets
        DESTINATION "${CATOOLBOX_CMAKE_CONFIG_DIR}"
        NAMESPACE CAToolbox::
        FILE "CAToolbox${CATOOLBOX_VERSION_MAJOR}Targets.cmake"
)
