# Copyright © 2019-2020, the catoolbox contributors
#
# libcatoolbox is free software: you can redistribute it and/or modify it
# under the terms of the GNU Lesser General Public License as published by the
# Free Software Foundation, either version 3 of the License, or (at your
# option) any later version.
#
# libcatoolbox is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
# more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with libcatoolbox. If not, see <http://www.gnu.org/licenses/>.
#
# Additional permission under GNU GPL version 3 section 7
#
# If you modify libcatoolbox, or any covered work, by linking or combining it
# with
# - OpenSSL (or a modified version of that library), or
# - any C/C++ runtime library,
# containing parts covered by the terms of their respective licenses, the
# licensors of libcatoolbox grant you additional permission to convey the
# resulting work.
# If you modify this library, you may extend this exception to your version of
# the library, but you are not obliged to do so. If you do not wish to do so,
# delete this exception statement from your version.

include(AddCAToolboxTest)
include(DisableMSVCDefaultManifest)
include(GenerateExportHeaderWithMap)
include(GNUInstallDirs)
include(SetTargetDebugSecurityFlags)

set(libcatoolbox_headers
    "${CMAKE_CURRENT_BINARY_DIR}/include/catoolbox/export.h"
    include/catoolbox/catoolbox.h
    include/catoolbox/errcodes.h
    include/catoolbox/salannotations.h
    include/catoolbox/version.h
)
set(libcatoolbox_sources
    libcatoolbox.map
    src/version.c
)

if(WIN32)
    configure_file("${CMAKE_CURRENT_SOURCE_DIR}/libcatoolbox.dll.manifest.in"
                   "${CMAKE_CURRENT_BINARY_DIR}/libcatoolbox.dll.manifest"
                   @ONLY)
    configure_file("${CMAKE_CURRENT_SOURCE_DIR}/libcatoolbox.rc.in"
                   "${CMAKE_CURRENT_BINARY_DIR}/libcatoolbox.rc"
                   @ONLY)
    set(libcatoolbox_sources
        ${libcatoolbox_sources}
        "${CMAKE_CURRENT_BINARY_DIR}/libcatoolbox.rc")
endif(WIN32)

add_library(libcatoolbox SHARED
            ${libcatoolbox_headers}
            ${libcatoolbox_sources}
)
configure_file("${CMAKE_CURRENT_SOURCE_DIR}/libcatoolbox.def.in"
               "${CMAKE_CURRENT_BINARY_DIR}/libcatoolbox.def"
               @ONLY)
set_target_properties(libcatoolbox PROPERTIES
    OUTPUT_NAME "catoolbox${CATOOLBOX_VERSION_SUFFIX}"
    PUBLIC_HEADER "${libcatoolbox_headers}"
    VERSION ${CATOOLBOX_VERSION}
    SOVERSION ${CATOOLBOX_VERSION_MAJOR}
    LINK_DEPENDS "${CMAKE_CURRENT_BINARY_DIR}/libcatoolbox.def;${CMAKE_CURRENT_SOURCE_DIR}/libcatoolbox.map"
    POSITION_INDEPENDENT_CODE ON
)
set_target_debug_security_flags(libcatoolbox)
disable_msvc_auto_manifest(libcatoolbox)

generate_export_header_with_map(TARGET libcatoolbox
                                INCLUDE_GUARD_NAME "CATOOLBOX_EXPORT_H"
                                EXPORT_FILE_NAME "${CMAKE_CURRENT_BINARY_DIR}/include/catoolbox/export.h"
                                MAP_FILE_NAME "${CMAKE_CURRENT_SOURCE_DIR}/libcatoolbox.map"
                                DEF_FILE_NAME "${CMAKE_CURRENT_BINARY_DIR}/libcatoolbox.def"
)
if(${CMAKE_VERSION} VERSION_GREATER_EQUAL "3.16.0")
    target_precompile_headers(libcatoolbox
        PRIVATE
            src/stdafx.h
    )
endif(${CMAKE_VERSION} VERSION_GREATER_EQUAL "3.16.0")
target_include_directories(libcatoolbox
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include/catoolbox${CATOOLBOX_VERSION_SUFFIX}>
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/src
        ${CMAKE_CURRENT_BINARY_DIR}/include
        ${PROJECT_SOURCE_DIR}
        ${PROJECT_BINARY_DIR}
)

# Add unit tests.
if(CATOOLBOX_RUN_TESTS)
    add_catoolbox_test(version tests/test_version.c)
endif(CATOOLBOX_RUN_TESTS)

configure_file("${CMAKE_CURRENT_SOURCE_DIR}/libcatoolbox.pc.in"
               "${CMAKE_CURRENT_BINARY_DIR}/libcatoolbox${CATOOLBOX_VERSION_SUFFIX}.pc"
               @ONLY)

install(TARGETS libcatoolbox
        EXPORT CAToolboxTargets
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
                COMPONENT catoolbox_libcatoolbox
        LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
                COMPONENT catoolbox_libcatoolbox
        ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
                COMPONENT catoolbox_devel
        PUBLIC_HEADER DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/catoolbox${CATOOLBOX_VERSION_SUFFIX}/catoolbox"
                COMPONENT catoolbox_devel
)
install(FILES
            "${CMAKE_CURRENT_BINARY_DIR}/libcatoolbox${CATOOLBOX_VERSION_SUFFIX}.pc"
        DESTINATION "${CMAKE_INSTALL_LIBDIR}/pkgconfig"
        COMPONENT catoolbox_devel
)
