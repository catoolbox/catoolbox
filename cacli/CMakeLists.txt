# Copyright © 2019-2020, the catoolbox contributors
#
# cacli is free software: you can redistribute it and/or modify it under the
# terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# cacli is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with
# cacli. If not, see <http://www.gnu.org/licenses/>.
#
# Additional permission under GNU GPL version 3 section 7
#
# If you modify cacli, or any covered work, by linking or combining it with
# - OpenSSL (or a modified version of that library),
# - any C/C++ runtime library,
# containing parts covered by the terms of their respective licenses, the
# licensors of cacli grant you additional permission to convey the
# resulting work.
# If you modify this software, you may extend this exception to your version of
# the software, but you are not obliged to do so. If you do not wish to do so,
# delete this exception statement from your version.

set(cacli_sources
    src/main.c
)

add_executable(cacli ${cacli_sources})
add_dependencies(cacli libcatoolbox)
set_target_properties(cacli PROPERTIES
    OUTPUT_NAME "cacli${CATOOLBOX_VERSION_SUFFIX}"
)
set_target_debug_security_flags(cacli)
target_link_libraries(cacli
    PRIVATE
        libcatoolbox
)
if(${CMAKE_VERSION} VERSION_GREATER_EQUAL "3.16.0")
    target_precompile_headers(cacli
        PRIVATE
            src/stdafx.h
    )
endif(${CMAKE_VERSION} VERSION_GREATER_EQUAL "3.16.0")
target_include_directories(cacli
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/src
        ${PROJECT_BINARY_DIR}/libcatoolbox/include
        ${PROJECT_SOURCE_DIR}/libcatoolbox/include
        ${PROJECT_SOURCE_DIR}
        ${PROJECT_BINARY_DIR}
)

install(TARGETS cacli
        EXPORT CAToolboxTargets
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
        COMPONENT catoolbox_cacli
)
