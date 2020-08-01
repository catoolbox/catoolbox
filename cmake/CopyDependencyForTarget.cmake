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

# This script is run to get the dependencies of an executable file and to
# copy them to the target directory (useful for Windows builds where we have
# no RPATH equivalent).

if(${CMAKE_VERSION} VERSION_LESS "3.16.0")
    message(FATAL_ERROR "CMake 3.16.0 or later is required to run this script.")
endif(${CMAKE_VERSION} VERSION_LESS "3.16.0")
if(NOT DEFINED CATOOLBOX_EXCLUSIONS)
    message(FATAL_ERROR "You must define the catoolbox exclusion list.")
endif(NOT DEFINED CATOOLBOX_EXCLUSIONS)
if(NOT DEFINED TARGET_TO_TRACK)
    message(FATAL_ERROR "You must define a target to track.")
endif(NOT DEFINED TARGET_TO_TRACK)
if(NOT DEFINED TARGET_ADDITIONAL_DIRECTORIES)
    set(TARGET_ADDITIONAL_DIRECTORIES "")
endif(NOT DEFINED TARGET_ADDITIONAL_DIRECTORIES)
if(NOT DEFINED TARGET_FILE_DIR)
    message(FATAL_ERROR "You must define the target directory.")
endif(NOT DEFINED TARGET_FILE_DIR)
string(TOLOWER "${CATOOLBOX_EXCLUSIONS}" CATOOLBOX_EXCLUSIONS_LOWER)
string(REGEX REPLACE "([][+.*()^])" "\\\\\\1" CATOOLBOX_EXCLUSIONS_ESCAPED
       "${CATOOLBOX_EXCLUSIONS_LOWER}")
list(TRANSFORM CATOOLBOX_EXCLUSIONS_ESCAPED PREPEND "^")
list(TRANSFORM CATOOLBOX_EXCLUSIONS_ESCAPED APPEND "$")
file(GET_RUNTIME_DEPENDENCIES
     RESOLVED_DEPENDENCIES_VAR executable_deps
     EXECUTABLES "${TARGET_TO_TRACK}"
     DIRECTORIES "${TARGET_ADDITIONAL_DIRECTORIES}"
     PRE_EXCLUDE_REGEXES
        "^advapi32\\.dll$"
        "^comctl32\\.dll$"
        "^comdlg32\\.dll$"
        "^gdi32\\.dll$"
        "^imm32\\.dll$"
        "^kernel32\\.dll$"
        "^netapi32\\.dll$"
        "^ole32\\.dll$"
        "^shell32\\.dll$"
        "^shscrap\\.dll$"
        "^user32\\.dll$"
        "^winmm\\.dll$"
        "^ws2_32\\.dll$"
        "^msvcrt.*\\.dll$"
        "^msvcp.*\\.dll$"
        "^crtdll.*\\.dll$"
        "^atl.*\\.dll$"
        "^mfc.*\\.dll$"
        "^vcomp.*\\.dll$"
        "^vcruntime.*\\.dll$"
        "^ucrtbase.*\\.dll$"
        "^api\\-ms\\-win\\-.*\\.dll$"
        ${CATOOLBOX_EXCLUSIONS_ESCAPED})
if(executable_deps)
    message(STATUS "${TARGET_TO_TRACK}: copying \"${executable_deps}\" to "
                   "\"${TARGET_FILE_DIR}\"")
    file(COPY ${executable_deps}
         DESTINATION "${TARGET_FILE_DIR}")
endif(executable_deps)
