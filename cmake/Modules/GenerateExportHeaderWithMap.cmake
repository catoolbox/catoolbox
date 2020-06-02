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

# This module works similarly to the CMake standard "GenerateExportHeader"
# by generating export macros in a special header and also dealing with
# symbol export information.

include(CheckCSourceCompiles)

function(GENERATE_EXPORT_HEADER_WITH_MAP)
    set(oneValueArgs TARGET BASE_NAME INCLUDE_GUARD_NAME EXPORT_MACRO_NAME
        EXPORT_MACRO_SYMBOL_NAME EXPORT_MACRO_SYMBOL_DEFAULT_NAME
        DEPRECATED_MACRO_NAME CALLINGCONVENTION_MACRO_NAME
        MAP_FILE_NAME DEF_FILE_NAME EXPORT_FILE_NAME)
    cmake_parse_arguments(_GEHWM "" "${oneValueArgs}" "" ${ARGN})

    if(NOT DEFINED _GEHWM_TARGET)
        message(FATAL_ERROR "generate_export_header_with_map requires a TARGET")
    endif(NOT DEFINED _GEHWM_TARGET)

    get_property(tgttype TARGET ${_GEHWM_TARGET} PROPERTY TYPE)
    if(NOT ${tgttype} STREQUAL "SHARED_LIBRARY"
       AND NOT ${tgttype} STREQUAL "STATIC_LIBRARY")
        message(FATAL_ERROR
                "generate_export_header_with_map can be used only with shared or static libraries")
    endif(NOT ${tgttype} STREQUAL "SHARED_LIBRARY"
          AND NOT ${tgttype} STREQUAL "STATIC_LIBRARY")

    if(NOT DEFINED _GEHWM_MAP_FILE_NAME)
        message(FATAL_ERROR "generate_export_header_with_map requires a map file")
    endif(NOT DEFINED _GEHWM_MAP_FILE_NAME)
    if(NOT EXISTS ${_GEHWM_MAP_FILE_NAME})
        message(FATAL_ERROR "The map file ${_GEHWM_MAP_FILE_NAME} does not exist")
    endif(NOT EXISTS ${_GEHWM_MAP_FILE_NAME})

    if(NOT DEFINED _GEHWM_DEF_FILE_NAME)
        message(FATAL_ERROR "generate_export_header_with_map requires a DEF file")
    endif(NOT DEFINED _GEHWM_DEF_FILE_NAME)
    if(NOT EXISTS ${_GEHWM_DEF_FILE_NAME})
        message(FATAL_ERROR "The DEF file ${_GEHWM_DEF_FILE_NAME} does not exist")
    endif(NOT EXISTS ${_GEHWM_DEF_FILE_NAME})

    if(${tgttype} STREQUAL "SHARED_LIBRARY")
        set(BUILDING_STATIC_CONDITION 0)
    else(${tgttype} STREQUAL "SHARED_LIBRARY")
        set(BUILDING_STATIC_CONDITION 1)
    endif(${tgttype} STREQUAL "SHARED_LIBRARY")

    if(_GEHWM_BASE_NAME)
        set(BASE_NAME "${_GEHWM_BASE_NAME}")
    else(_GEHWM_BASE_NAME)
        set(BASE_NAME "${_GEHWM_TARGET}")
    endif(_GEHWM_BASE_NAME)

    string(TOUPPER "${BASE_NAME}" BASE_NAME_UPPER)
    string(TOLOWER "${BASE_NAME}" BASE_NAME_LOWER)

    set(EXPORT_FILE_NAME "${CMAKE_CURRENT_BINARY_DIR}/${BASE_NAME_LOWER}_export.h")
    set(INCLUDE_GUARD_NAME "${BASE_NAME_UPPER}_EXPORT_H")
    set(EXPORT_MACRO_NAME "${BASE_NAME_UPPER}_EXPORT")
    set(EXPORT_MACRO_SYMBOL_NAME "${BASE_NAME_UPPER}_EXPORT_SYMBOL")
    set(EXPORT_MACRO_SYMBOL_DEFAULT_NAME
        "${BASE_NAME_UPPER}_EXPORT_SYMBOL_DEFAULT")
    set(DEPRECATED_MACRO_NAME "${BASE_NAME_UPPER}_DEPRECATED")
    set(CALLINGCONVENTION_MACRO_NAME "${BASE_NAME_UPPER}_CALLINGCONVENTION")

    if(_GEHWM_EXPORT_FILE_NAME)
        if(IS_ABSOLUTE ${_GEHWM_EXPORT_FILE_NAME})
            set(EXPORT_FILE_NAME "${_GEHWM_EXPORT_FILE_NAME}")
        else(IS_ABSOLUTE ${_GEHWM_EXPORT_FILE_NAME})
            set(EXPORT_FILE_NAME
                "${CMAKE_CURRENT_BINARY_DIR}/${_GEHWM_EXPORT_FILE_NAME}")
        endif(IS_ABSOLUTE ${_GEHWM_EXPORT_FILE_NAME})
    endif(_GEHWM_EXPORT_FILE_NAME)
    if(_GEHWM_INCLUDE_GUARD_NAME)
        string(TOUPPER "${_GEHWM_INCLUDE_GUARD_NAME}" INCLUDE_GUARD_NAME)
    endif(_GEHWM_INCLUDE_GUARD_NAME)
    if(_GEHWM_EXPORT_MACRO_NAME)
        string(TOUPPER "${_GEHWM_EXPORT_MACRO_NAME}" EXPORT_MACRO_NAME)
    endif(_GEHWM_EXPORT_MACRO_NAME)
    if(_GEHWM_EXPORT_MACRO_SYMBOL_NAME)
        string(TOUPPER "${_GEHWM_EXPORT_MACRO_SYMBOL_NAME}"
               EXPORT_MACRO_SYMBOL_NAME)
    endif(_GEHWM_EXPORT_MACRO_SYMBOL_NAME)
    if(_GEHWM_EXPORT_MACRO_SYMBOL_DEFAULT_NAME)
        string(TOUPPER "${_GEHWM_EXPORT_MACRO_SYMBOL_DEFAULT_NAME}"
               EXPORT_MACRO_SYMBOL_DEFAULT_NAME)
    endif(_GEHWM_EXPORT_MACRO_SYMBOL_DEFAULT_NAME)
    if(_GEHWM_DEPRECATED_MACRO_NAME)
        string(TOUPPER "${_GEHWM_DEPRECATED_MACRO_NAME}" DEPRECATED_MACRO_NAME)
    endif(_GEHWM_DEPRECATED_MACRO_NAME)
    if(_GEHWM_CALLINGCONVENTION_MACRO_NAME)
        string(TOUPPER "${_GEHWM_CALLINGCONVENTION_MACRO_NAME}"
               CALLINGCONVENTION_MACRO_NAME)
    endif(_GEHWM_CALLINGCONVENTION_MACRO_NAME)

    # Since headers are read by both our library (when compiling it) and by
    # clients, determine the preprocessor symbol to use when our sources are
    # compiled vs. when our header is used.
    get_target_property(BUILDING_LIBRARY_CONDITION ${_GEHWM_TARGET} DEFINE_SYMBOL)
    if(NOT BUILDING_LIBRARY_CONDITION)
        set(BUILDING_LIBRARY_CONDITION "${_GEHWM_TARGET}_EXPORTS")
    endif(NOT BUILDING_LIBRARY_CONDITION)

    if(WIN32 OR CYGWIN)
        set(EXPORT_MACRO_DEFINITION "__declspec(dllexport)")
        set(EXPORT_MACRO_SYMBOL_DEFINITION "")
        set(EXPORT_MACRO_SYMBOL_DEFAULT_DEFINITION "")
        set(IMPORT_MACRO_DEFINITION "__declspec(dllimport)")
        set(IMPORT_MACRO_SYMBOL_DEFINITION "")
        set(IMPORT_MACRO_SYMBOL_DEFAULT_DEFINITION "")
        set(DEPRECATED_MACRO_DEFINITION "__declspec(deprecated((message)))")
        set(CALLINGCONVENTION_MACRO_DEFINITION "__cdecl")
        get_target_property(LIBRARY_LINKER_FLAGS ${_GEHWM_TARGET} LINK_FLAGS)
        if(LIBRARY_LINKER_FLAGS STREQUAL "LIBRARY_LINKER_FLAGS-NOTFOUND")
            set(LIBRARY_LINKER_FLAGS "")
        else(LIBRARY_LINKER_FLAGS STREQUAL "LIBRARY_LINKER_FLAGS-NOTFOUND")
            set(LIBRARY_LINKER_FLAGS "${LIBRARY_LINKER_FLAGS} ")
        endif(LIBRARY_LINKER_FLAGS STREQUAL "LIBRARY_LINKER_FLAGS-NOTFOUND")
        set_target_properties(${_GEHWM_TARGET} PROPERTIES
                              LINK_FLAGS "${LIBRARY_LINKER_FLAGS}/DEF:\"${_GEHWM_DEF_FILE_NAME}\"")
    else(WIN32 OR CYGWIN)
        check_c_source_compiles("__attribute__((visibility(\"default\"))) int testfunc() {return 0;} int main() {return testfunc();}"
                                COMPILER_SUPPORTS_ATTRIBUTE_VISIBILITY_DEFAULT)
        if(COMPILER_SUPPORTS_ATTRIBUTE_VISIBILITY_DEFAULT)
            set(EXPORT_MACRO_DEFINITION "__attribute__((visibility(\"default\")))")
            set_target_properties(${_GEHWM_TARGET} PROPERTIES
                                  C_VISIBILITY_PRESET hidden)
            set_target_properties(${_GEHWM_TARGET} PROPERTIES
                                  VISIBILITY_INLINES_HIDDEN 1)
        else(COMPILER_SUPPORTS_ATTRIBUTE_VISIBILITY_DEFAULT)
            set(EXPORT_MACRO_DEFINITION "")
        endif(COMPILER_SUPPORTS_ATTRIBUTE_VISIBILITY_DEFAULT)
        set(IMPORT_MACRO_DEFINITION "")
        check_c_source_compiles("__asm__(\".symver testfunc,testfunc@TESTFUNC_1.0\"); int testfunc() {return 0;} int main() {return testfunc();}"
                                COMPILER_SUPPORTS_SYMBOL)
        if(COMPILER_SUPPORTS_SYMBOL)
            set(EXPORT_MACRO_SYMBOL_DEFINITION "__asm__(\".symver \" #function \",\" #symbol \"@\" #version);")
        else(COMPILER_SUPPORTS_SYMBOL)
            set(EXPORT_MACRO_SYMBOL_DEFINITION "")
        endif(COMPILER_SUPPORTS_SYMBOL)
        set(IMPORT_MACRO_SYMBOL_DEFINITION "")
        check_c_source_compiles("__asm__(\".symver new_testfunc,testfunc@@@TESTFUNC_1.0\"); int new_testfunc() {return 0;} int main() {return new_testfunc();}"
                                COMPILER_SUPPORTS_SYMBOL_DEFAULT)
        if(COMPILER_SUPPORTS_SYMBOL_DEFAULT)
            set(EXPORT_MACRO_SYMBOL_DEFAULT_DEFINITION "__asm__(\".symver \" #function \",\" #symbol \"@@@\" #version);")
        else(COMPILER_SUPPORTS_SYMBOL_DEFAULT)
            set(EXPORT_MACRO_SYMBOL_DEFAULT_DEFINITION "")
        endif(COMPILER_SUPPORTS_SYMBOL_DEFAULT)
        if(COMPILER_SUPPORTS_SYMBOL OR COMPILER_SUPPORTS_SYMBOL_DEFAULT)
            get_target_property(LIBRARY_LINKER_FLAGS ${_GEHWM_TARGET} LINK_FLAGS)
            if(LIBRARY_LINKER_FLAGS STREQUAL "LIBRARY_LINKER_FLAGS-NOTFOUND")
                set(LIBRARY_LINKER_FLAGS "")
            else(LIBRARY_LINKER_FLAGS STREQUAL "LIBRARY_LINKER_FLAGS-NOTFOUND")
                set(LIBRARY_LINKER_FLAGS "${LIBRARY_LINKER_FLAGS} ")
            endif(LIBRARY_LINKER_FLAGS STREQUAL "LIBRARY_LINKER_FLAGS-NOTFOUND")
            set_target_properties(${_GEHWM_TARGET} PROPERTIES
                                  LINK_FLAGS "${LIBRARY_LINKER_FLAGS}-Wl,--exclude-libs=ALL -Wl,--version-script,\"${_GEHWM_MAP_FILE_NAME}\"")
        endif(COMPILER_SUPPORTS_SYMBOL OR COMPILER_SUPPORTS_SYMBOL_DEFAULT)
        set(IMPORT_MACRO_SYMBOL_DEFAULT_DEFINITION "")
        check_c_source_compiles("__attribute__((deprecated(\"Obsolete\"))) int testfunc() {return 0;} int main() {return testfunc();}"
                                COMPILER_SUPPORTS_ATTRIBUTE_DEPRECATED)
        if(COMPILER_SUPPORTS_ATTRIBUTE_DEPRECATED)
            set(DEPRECATED_MACRO_DEFINITION "__attribute__((deprecated((message))))")
        else(COMPILER_SUPPORTS_ATTRIBUTE_DEPRECATED)
            set(DEPRECATED_MACRO_DEFINITION "")
        endif(COMPILER_SUPPORTS_ATTRIBUTE_DEPRECATED)
        if(CMAKE_C_COMPILER_ID MATCHES "GNU" AND CMAKE_SIZEOF_VOID_P GREATER 4)
            # GNU compilers on 64-bit platforms do not support the CDECL
            # attribute and will emit a warning
            set(CALLINGCONVENTION_MACRO_DEFINITION "")
        else(CMAKE_C_COMPILER_ID MATCHES "GNU" AND CMAKE_SIZEOF_VOID_P GREATER 4)
            check_c_source_compiles("__attribute__((__cdecl__)) int testfunc() {return 0;} int main() {return testfunc();}"
                                    COMPILER_SUPPORTS_ATTRIBUTE_CDECL)
            if(COMPILER_SUPPORTS_ATTRIBUTE_CDECL)
                set(CALLINGCONVENTION_MACRO_DEFINITION
                    "__attribute__((__cdecl__))")
            else(COMPILER_SUPPORTS_ATTRIBUTE_CDECL)
                set(CALLINGCONVENTION_MACRO_DEFINITION "")
            endif(COMPILER_SUPPORTS_ATTRIBUTE_CDECL)
        endif(CMAKE_C_COMPILER_ID MATCHES "GNU" AND CMAKE_SIZEOF_VOID_P GREATER 4)
    endif(WIN32 OR CYGWIN)

    string(MAKE_C_IDENTIFIER ${INCLUDE_GUARD_NAME} INCLUDE_GUARD_NAME)
    string(MAKE_C_IDENTIFIER ${EXPORT_MACRO_NAME} EXPORT_MACRO_NAME)
    string(MAKE_C_IDENTIFIER ${EXPORT_MACRO_SYMBOL_NAME}
           EXPORT_MACRO_SYMBOL_NAME)
    string(MAKE_C_IDENTIFIER ${EXPORT_MACRO_SYMBOL_DEFAULT_NAME}
           EXPORT_MACRO_SYMBOL_DEFAULT_NAME)
    string(MAKE_C_IDENTIFIER ${DEPRECATED_MACRO_NAME} DEPRECATED_MACRO_NAME)
    string(MAKE_C_IDENTIFIER ${BUILDING_LIBRARY_CONDITION}
           BUILDING_LIBRARY_CONDITION)

    message(STATUS "Saving the export definitions to ${EXPORT_FILE_NAME}")
    configure_file("${PROJECT_SOURCE_DIR}/cmake/ExportHeaderWithMaps.h.in"
                   "${EXPORT_FILE_NAME}"
                   @ONLY
    )
endfunction(GENERATE_EXPORT_HEADER_WITH_MAP)
