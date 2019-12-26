# Copyright © 2019, the catoolbox contributors
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

include(GenerateExportHeaderWithMap)
include(GNUInstallDirs)

set(libcatoolbox_headers
    "${CMAKE_CURRENT_BINARY_DIR}/include/catoolbox/export.h"
    include/catoolbox/catoolbox.h
    include/catoolbox/errcodes.h
    include/catoolbox/version.h
)
set(libcatoolbox_sources
    libcatoolbox.map
    src/version.c
)

add_library(libcatoolbox SHARED
            ${libcatoolbox_headers}
            ${libcatoolbox_sources}
)
configure_file("${CMAKE_CURRENT_SOURCE_DIR}/libcatoolbox.def.in"
               "${CMAKE_CURRENT_BINARY_DIR}/libcatoolbox.def"
               @ONLY)
set_target_properties(libcatoolbox PROPERTIES
    OUTPUT_NAME "catoolbox-${CATOOLBOX_VERSION_MAJOR}"
    PUBLIC_HEADER "${libcatoolbox_headers}"
    VERSION ${CATOOLBOX_VERSION}
    SOVERSION ${CATOOLBOX_VERSION_MAJOR}
    LINK_DEPENDS "${CMAKE_CURRENT_BINARY_DIR}/libcatoolbox.def;${CMAKE_CURRENT_SOURCE_DIR}/libcatoolbox.map"
    POSITION_INDEPENDENT_CODE ON
)

generate_export_header_with_map(TARGET libcatoolbox
                                INCLUDE_GUARD_NAME "CATOOLBOX_EXPORT_H"
                                EXPORT_FILE_NAME "${CMAKE_CURRENT_BINARY_DIR}/include/catoolbox/export.h"
                                MAP_FILE_NAME "${CMAKE_CURRENT_SOURCE_DIR}/libcatoolbox.map"
                                DEF_FILE_NAME "${CMAKE_CURRENT_BINARY_DIR}/libcatoolbox.def"
)
target_include_directories(libcatoolbox
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include/catoolbox-${CATOOLBOX_VERSION_MAJOR}>
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/src
        ${CMAKE_CURRENT_BINARY_DIR}/include
        ${PROJECT_BINARY_DIR}
)

install(TARGETS libcatoolbox
        EXPORT CAToolboxTargets
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
                COMPONENT catoolbox_libcatoolbox
        LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
                COMPONENT catoolbox_libcatoolbox
        ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
                COMPONENT catoolbox_devel
        PUBLIC_HEADER DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/catoolbox-${CATOOLBOX_VERSION_MAJOR}/catoolbox"
                COMPONENT catoolbox_devel
)
