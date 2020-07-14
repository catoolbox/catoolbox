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

# This module includes a SET_COMPILER_DEBUG_SECURITY_FLAGS function that
# sets appropriate debug and hardening flags depending on the target type.
#
# References:
# <https://developers.redhat.com/blog/2018/03/21/compiler-and-linker-flags-gcc/>
# <https://www.owasp.org/index.php/C-Based_Toolchain_Hardening>
# plus Clang/GCC/Microsoft Visual C++ manuals

include(CheckCCompilerFlag)

function(add_c_flag_if_supported flagvar flag)
    if(ARGV2)
        set(additionalflag "${ARGV2}")
    else(ARGV2)
        set(additionalflag "")
    endif(ARGV2)

    string(REGEX REPLACE "[/:=,]" "_" supported "${flag}")
    string(REPLACE "-" "_" supported "${supported}")
    string(REGEX REPLACE "__+" "_" supported "${supported}")
    string(TOUPPER "${supported}" supported)
    # Treat all warnings as fatal
    if(CMAKE_C_COMPILER_ID STREQUAL "AppleClang"
       OR CMAKE_C_COMPILER_ID STREQUAL "Clang"
       OR CMAKE_C_COMPILER_ID STREQUAL "GNU")
        check_c_compiler_flag("${flag} -Werror ${additionalflag}"
                              "COMPILER_SUPPORTS${supported}")
    endif(CMAKE_C_COMPILER_ID STREQUAL "AppleClang"
          OR CMAKE_C_COMPILER_ID STREQUAL "Clang"
          OR CMAKE_C_COMPILER_ID STREQUAL "GNU")
    if(CMAKE_C_COMPILER_ID STREQUAL "MSVC")
        check_c_compiler_flag("${flag} /WX" "COMPILER_SUPPORTS${supported}")
    endif(CMAKE_C_COMPILER_ID STREQUAL "MSVC")
    if(${COMPILER_SUPPORTS${supported}})
        set(${flagvar} "${${flagvar}};${flag}" PARENT_SCOPE)
    endif(${COMPILER_SUPPORTS${supported}})
endfunction(add_c_flag_if_supported flag)

function(add_linker_flag_if_supported flagvar flag)
    string(REGEX REPLACE "[/:=,]" "_" supported "${flag}")
    string(REPLACE "-" "_" supported "${supported}")
    string(REGEX REPLACE "__+" "_" supported "${supported}")
    string(TOUPPER "${supported}" supported)
    # Treat all warnings as fatal (exclude Mac OS X where the flag is not
    # supported)
    if(CMAKE_C_COMPILER_ID STREQUAL "AppleClang")
        set(CMAKE_REQUIRED_FLAGS "${flag}")
        check_c_compiler_flag("${flag}"
                              "LINKER_SUPPORTS${supported}")
    endif(CMAKE_C_COMPILER_ID STREQUAL "AppleClang")
    if(CMAKE_C_COMPILER_ID STREQUAL "Clang"
       OR CMAKE_C_COMPILER_ID STREQUAL "GNU")
        set(CMAKE_REQUIRED_FLAGS "-Wl,--fatal-warnings ${flag}")
        check_c_compiler_flag("-Wl,--fatal-warnings ${flag}"
                              "LINKER_SUPPORTS${supported}")
    endif(CMAKE_C_COMPILER_ID STREQUAL "Clang"
          OR CMAKE_C_COMPILER_ID STREQUAL "GNU")
    if(CMAKE_C_COMPILER_ID STREQUAL "MSVC")
        set(CMAKE_REQUIRED_FLAGS "/WX ${flag}")
        check_c_compiler_flag("/WX ${flag}" "LINKER_SUPPORTS${supported}")
    endif(CMAKE_C_COMPILER_ID STREQUAL "MSVC")
    if(${LINKER_SUPPORTS${supported}})
        set(${flagvar} "${${flagvar}};${flag}" PARENT_SCOPE)
    endif(${LINKER_SUPPORTS${supported}})
endfunction(add_linker_flag_if_supported flag)

function(determine_target_debug_security_flags)
    set(COMMON_COMPILE_DEFINITIONS "")
    set(COMMON_COMPILE_OPTIONS "")
    set(COMMON_LINK_OPTIONS "")

    if(CMAKE_BUILD_TYPE STREQUAL "Debug")
        list(APPEND COMMON_COMPILE_DEFINITIONS "DEBUG=1")
        if(CMAKE_C_COMPILER_ID STREQUAL "AppleClang"
           OR CMAKE_C_COMPILER_ID STREQUAL "Clang"
           OR CMAKE_C_COMPILER_ID STREQUAL "GNU")
            list(APPEND COMMON_COMPILE_OPTIONS "-Og")
            add_c_flag_if_supported(COMMON_COMPILE_OPTIONS "-ggdb3")
            if(NOT COMPILER_SUPPORTS_GGDB3)
                add_c_flag_if_supported(COMMON_COMPILE_OPTIONS "-g3")
                if(NOT COMPILER_SUPPORTS_G3)
                    list(APPEND COMMON_COMPILE_OPTIONS "-g")
                endif(NOT COMPILER_SUPPORTS_G3)
            endif(NOT COMPILER_SUPPORTS_GGDB3)
        endif(CMAKE_C_COMPILER_ID STREQUAL "AppleClang"
              OR CMAKE_C_COMPILER_ID STREQUAL "Clang"
              OR CMAKE_C_COMPILER_ID STREQUAL "GNU")
        if(CMAKE_C_COMPILER_ID STREQUAL "MSVC")
            list(APPEND COMMON_COMPILE_OPTIONS "/Od")
            list(APPEND COMMON_COMPILE_OPTIONS "/ZI")
            list(APPEND COMMON_COMPILE_OPTIONS "/Gy")
            list(APPEND COMMON_COMPILE_DEFINITIONS "_DEBUG=1")
            list(APPEND COMMON_COMPILE_DEFINITIONS "_ITERATOR_DEBUG_LEVEL=2")
        endif(CMAKE_C_COMPILER_ID STREQUAL "MSVC")
    endif(CMAKE_BUILD_TYPE STREQUAL "Debug")

    if(CMAKE_BUILD_TYPE STREQUAL "Release"
       OR CMAKE_BUILD_TYPE STREQUAL "RelWithDebInfo")
        list(APPEND COMMON_COMPILE_DEFINITIONS "NDEBUG=1")
        if(CMAKE_C_COMPILER_ID STREQUAL "AppleClang"
           OR CMAKE_C_COMPILER_ID STREQUAL "Clang"
           OR CMAKE_C_COMPILER_ID STREQUAL "GNU")
            list(APPEND COMMON_COMPILE_OPTIONS "-O2")
            add_c_flag_if_supported(COMMON_COMPILE_OPTIONS "-ggdb2")
            if(NOT COMPILER_SUPPORTS_GGDB2)
                add_c_flag_if_supported(COMMON_COMPILE_OPTIONS "-g2")
                if(NOT COMPILER_SUPPORTS_G2)
                    list(APPEND COMMON_COMPILE_OPTIONS "-g")
                endif(NOT COMPILER_SUPPORTS_G2)
            endif(NOT COMPILER_SUPPORTS_GGDB2)
            list(APPEND COMMON_COMPILE_DEFINITIONS "_FORTIFY_SOURCE=2")
        endif(CMAKE_C_COMPILER_ID STREQUAL "AppleClang"
              OR CMAKE_C_COMPILER_ID STREQUAL "Clang"
              OR CMAKE_C_COMPILER_ID STREQUAL "GNU")
        if(CMAKE_C_COMPILER_ID STREQUAL "MSVC")
            list(APPEND COMMON_COMPILE_OPTIONS "/O2")
            list(APPEND COMMON_COMPILE_OPTIONS "/Zi")
            list(APPEND COMMON_COMPILE_DEFINITIONS "_ITERATOR_DEBUG_LEVEL=1")
        endif(CMAKE_C_COMPILER_ID STREQUAL "MSVC")
    endif(CMAKE_BUILD_TYPE STREQUAL "Release"
          OR CMAKE_BUILD_TYPE STREQUAL "RelWithDebInfo")

    if(CMAKE_C_COMPILER_ID STREQUAL "AppleClang"
       OR CMAKE_C_COMPILER_ID STREQUAL "Clang"
       OR CMAKE_C_COMPILER_ID STREQUAL "GNU")
        list(APPEND COMMON_COMPILE_OPTIONS "-Werror")
        if(CMAKE_C_COMPILER_ID STREQUAL "AppleClang"
           OR CMAKE_C_COMPILER_ID STREQUAL "Clang")
            add_c_flag_if_supported(COMMON_COMPILE_OPTIONS "-Weverything")
        endif(CMAKE_C_COMPILER_ID STREQUAL "AppleClang"
              OR CMAKE_C_COMPILER_ID STREQUAL "Clang")
        if(COMPILER_SUPPORTS_WEVERYTHING)
            # Disable warnings about structure padding (let the compiler
            # handle it)
            list(APPEND COMMON_COMPILE_OPTIONS "-Wno-padded")
        else(COMPILER_SUPPORTS_WEVERYTHING)
            list(APPEND COMMON_COMPILE_OPTIONS "-pedantic-errors")
            list(APPEND COMMON_COMPILE_OPTIONS "-Wall")
            list(APPEND COMMON_COMPILE_OPTIONS "-Wextra")
            add_c_flag_if_supported(COMMON_COMPILE_OPTIONS
                                    "-Waggregate-return")
            add_c_flag_if_supported(COMMON_COMPILE_OPTIONS "-Wcast-align")
            add_c_flag_if_supported(COMMON_COMPILE_OPTIONS "-Wcast-qual")
            add_c_flag_if_supported(COMMON_COMPILE_OPTIONS "-Wconversion")
            add_c_flag_if_supported(COMMON_COMPILE_OPTIONS "-Wdate-time")
            add_c_flag_if_supported(COMMON_COMPILE_OPTIONS
                                    "-Wdouble-promotion")
            add_c_flag_if_supported(COMMON_COMPILE_OPTIONS
                                    "-Wduplicated-branches")
            add_c_flag_if_supported(COMMON_COMPILE_OPTIONS
                                    "-Wduplicated-cond")
            add_c_flag_if_supported(COMMON_COMPILE_OPTIONS "-Wformat=2")
            add_c_flag_if_supported(COMMON_COMPILE_OPTIONS
                                    "-Wformat-overflow=2")
            add_c_flag_if_supported(COMMON_COMPILE_OPTIONS
                                    "-Wformat-truncation=2")
            add_c_flag_if_supported(COMMON_COMPILE_OPTIONS
                                    "-Wformat-signedness")
            add_c_flag_if_supported(COMMON_COMPILE_OPTIONS "-Wlogical-op")
            add_c_flag_if_supported(COMMON_COMPILE_OPTIONS
                                    "-Wmissing-declarations")
            add_c_flag_if_supported(COMMON_COMPILE_OPTIONS
                                    "-Wmissing-prototypes")
            add_c_flag_if_supported(COMMON_COMPILE_OPTIONS
                                    "-Wnull-dereference")
            add_c_flag_if_supported(COMMON_COMPILE_OPTIONS
                                    "-Wold-style-definition")
            add_c_flag_if_supported(COMMON_COMPILE_OPTIONS "-Wshadow")
            add_c_flag_if_supported(COMMON_COMPILE_OPTIONS "-Wsign-conversion")
            add_c_flag_if_supported(COMMON_COMPILE_OPTIONS "-Wstack-protector")
            add_c_flag_if_supported(COMMON_COMPILE_OPTIONS "-Wstrict-overflow")
            add_c_flag_if_supported(COMMON_COMPILE_OPTIONS
                                    "-Wstrict-prototypes")
            add_c_flag_if_supported(COMMON_COMPILE_OPTIONS
                                    "-Wstringop-truncation")
            add_c_flag_if_supported(COMMON_COMPILE_OPTIONS "-Wtrampolines")
            add_c_flag_if_supported(COMMON_COMPILE_OPTIONS "-Wundef")
            add_c_flag_if_supported(COMMON_COMPILE_OPTIONS "-Wuninitialized")
            add_c_flag_if_supported(COMMON_COMPILE_OPTIONS "-Wunused")
            add_c_flag_if_supported(COMMON_COMPILE_OPTIONS "-Wwrite-strings")
        endif(COMPILER_SUPPORTS_WEVERYTHING)
        list(APPEND COMMON_COMPILE_OPTIONS "-fno-common")
        list(APPEND COMMON_COMPILE_OPTIONS "-fno-omit-frame-pointer")
        add_c_flag_if_supported(COMMON_COMPILE_OPTIONS
                                "-fasynchronous-unwind-tables")
        add_c_flag_if_supported(COMMON_COMPILE_OPTIONS "-fexceptions")
        add_c_flag_if_supported(COMMON_COMPILE_OPTIONS "-fno-common")
        add_c_flag_if_supported(COMMON_COMPILE_OPTIONS "-fplugin=annobin")
        add_c_flag_if_supported(COMMON_COMPILE_OPTIONS "-frecord-gcc-switches")
        add_c_flag_if_supported(COMMON_COMPILE_OPTIONS "-fstack-check")
        add_c_flag_if_supported(COMMON_COMPILE_OPTIONS "-fstack-protector-all")
        add_c_flag_if_supported(COMMON_COMPILE_OPTIONS "-fvtable-verify=std")
        add_c_flag_if_supported(COMMON_COMPILE_OPTIONS "-mcet")
        add_c_flag_if_supported(COMMON_COMPILE_OPTIONS
                                "-mfunction-return=thunk")
        add_c_flag_if_supported(COMMON_COMPILE_OPTIONS
                                "-mindirect-branch=thunk")
        # If the toolchain does not support Spectre mitigations,
        # use -fcfprotection=full as a backup option. We disable it under
        # Clang because, in that case, the linker will fail with the error
        # message "ld: error: FILENAME: <corrupt x86 feature size: 0x8>".
        if(NOT COMPILER_SUPPORTS_MFUNCTION_RETURN_THUNK
           AND NOT COMPILER_SUPPORTS_MFUNCTION_RETURN_THUNK
           AND NOT CMAKE_C_COMPILER_ID STREQUAL "AppleClang"
           AND NOT CMAKE_C_COMPILER_ID STREQUAL "Clang")
            add_c_flag_if_supported(COMMON_COMPILE_OPTIONS
                                    "-fcf-protection=full")
        endif(NOT COMPILER_SUPPORTS_MFUNCTION_RETURN_THUNK
              AND NOT COMPILER_SUPPORTS_MFUNCTION_RETURN_THUNK
              AND NOT CMAKE_C_COMPILER_ID STREQUAL "AppleClang"
              AND NOT CMAKE_C_COMPILER_ID STREQUAL "Clang")
        # -mmitigate-rop is not supported anymore in GCC >= 9.1.0, but the
        # check passes as the error message is not listed among those
        # recognized by check_c_compiler_flag.
        # For now, introduce a manual workaround.
        if(CMAKE_C_COMPILER_ID STREQUAL "GNU"
           AND CMAKE_C_COMPILER_VERSION VERSION_LESS "9.0.0")
            add_c_flag_if_supported(COMMON_COMPILE_OPTIONS "-mmitigate-rop")
        endif(CMAKE_C_COMPILER_ID STREQUAL "GNU"
              AND CMAKE_C_COMPILER_VERSION VERSION_LESS "9.0.0")
        # Fatal linker warnings are not supported on Mac OS X
        if(NOT CMAKE_C_COMPILER_ID STREQUAL "AppleClang")
            list(APPEND COMMON_LINK_OPTIONS "-Wl,--fatal-warnings")
        endif(NOT CMAKE_C_COMPILER_ID STREQUAL "AppleClang")
        add_linker_flag_if_supported(COMMON_LINK_OPTIONS "-Wl,-z,defs")
        add_linker_flag_if_supported(COMMON_LINK_OPTIONS "-Wl,-z,nodlopen")
        add_linker_flag_if_supported(COMMON_LINK_OPTIONS "-Wl,-z,nodump")
        add_linker_flag_if_supported(COMMON_LINK_OPTIONS "-Wl,-z,noexecheap")
        add_linker_flag_if_supported(COMMON_LINK_OPTIONS "-Wl,-z,noexecstack")
        add_linker_flag_if_supported(COMMON_LINK_OPTIONS "-Wl,-z,now")
        add_linker_flag_if_supported(COMMON_LINK_OPTIONS "-Wl,-z,relro")
        if(WIN32)
            add_linker_flag_if_supported(COMMON_LINK_OPTIONS
                                         "-Wl,--dynamicbase")
            add_linker_flag_if_supported(COMMON_LINK_OPTIONS
                                         "-Wl,--high-entropy-va")
            add_linker_flag_if_supported(COMMON_LINK_OPTIONS
                                         "-Wl,--large-address-aware")
            add_linker_flag_if_supported(COMMON_LINK_OPTIONS "-Wl,--nxcompat")
        endif(WIN32)
    endif(CMAKE_C_COMPILER_ID STREQUAL "AppleClang"
          OR CMAKE_C_COMPILER_ID STREQUAL "Clang"
          OR CMAKE_C_COMPILER_ID STREQUAL "GNU")

    if(CMAKE_C_COMPILER_ID STREQUAL "MSVC")
        list(APPEND COMMON_COMPILE_DEFINITIONS "STRICT")
        list(APPEND COMMON_COMPILE_DEFINITIONS
             "_CRT_SECURE_CPP_OVERLOAD_STANDARD_NAMES=1")
        list(APPEND COMMON_COMPILE_DEFINITIONS
             "_CRT_SECURE_CPP_OVERLOAD_STANDARD_NAMES_COUNT=1")
        list(APPEND COMMON_COMPILE_OPTIONS "/W4")
        list(APPEND COMMON_COMPILE_OPTIONS "/WX")
        add_c_flag_if_supported(COMMON_COMPILE_OPTIONS "/analyze")
        add_c_flag_if_supported(COMMON_COMPILE_OPTIONS "/GS")
        add_c_flag_if_supported(COMMON_COMPILE_OPTIONS "/Gs")
        if(CMAKE_BUILD_TYPE STREQUAL "Release"
           OR CMAKE_BUILD_TYPE STREQUAL "RelWithDebInfo")
            add_c_flag_if_supported(COMMON_COMPILE_OPTIONS "/guard:cf")
        endif(CMAKE_BUILD_TYPE STREQUAL "Release"
              OR CMAKE_BUILD_TYPE STREQUAL "RelWithDebInfo")
        add_c_flag_if_supported(COMMON_COMPILE_OPTIONS "/Qspectre")
        add_c_flag_if_supported(COMMON_COMPILE_OPTIONS "/sdl")
        add_c_flag_if_supported(COMMON_COMPILE_OPTIONS "/utf-8")
        add_linker_flag_if_supported(COMMON_LINK_OPTIONS "/DEBUG:FULL")
        add_linker_flag_if_supported(COMMON_LINK_OPTIONS "/DYNAMICBASE")
        add_linker_flag_if_supported(COMMON_LINK_OPTIONS "/GUARD:CF")
        add_linker_flag_if_supported(COMMON_LINK_OPTIONS "/HIGHENTROPYVA")
        add_linker_flag_if_supported(COMMON_LINK_OPTIONS "/LARGEADDRESSAWARE")
        add_linker_flag_if_supported(COMMON_LINK_OPTIONS "/NXCOMPAT")
        # The /SAFESEH option is only supported on x86.
        if(CMAKE_SIZEOF_VOID_P EQUAL 4)
            add_linker_flag_if_supported(COMMON_LINK_OPTIONS "/SAFESEH")
        endif(CMAKE_SIZEOF_VOID_P EQUAL 4)
        add_linker_flag_if_supported(COMMON_LINK_OPTIONS "/WX")
    endif(CMAKE_C_COMPILER_ID STREQUAL "MSVC")

    set(EXECUTABLE_COMPILE_DEFINITIONS_TMP "${COMMON_COMPILE_DEFINITIONS}")
    set(EXECUTABLE_COMPILE_OPTIONS_TMP "${COMMON_COMPILE_OPTIONS}")
    set(EXECUTABLE_LINK_OPTIONS_TMP "${COMMON_LINK_OPTIONS}")
    if(NOT CMAKE_C_COMPILER_ID STREQUAL "MSVC")
        add_c_flag_if_supported(EXECUTABLE_COMPILE_OPTIONS_TMP "-fpie")
        add_c_flag_if_supported(EXECUTABLE_COMPILE_OPTIONS_TMP "-fPIE")
        add_linker_flag_if_supported(EXECUTABLE_LINK_OPTIONS_TMP "-Wl,-pie")
    endif(NOT CMAKE_C_COMPILER_ID STREQUAL "MSVC")

    set(SHARED_LIBRARY_COMPILE_DEFINITIONS_TMP "${COMMON_COMPILE_DEFINITIONS}")
    set(SHARED_LIBRARY_COMPILE_OPTIONS_TMP "${COMMON_COMPILE_OPTIONS}")
    set(SHARED_LIBRARY_LINK_OPTIONS_TMP "${COMMON_LINK_OPTIONS}")
    if(NOT CMAKE_C_COMPILER_ID STREQUAL "MSVC")
        add_c_flag_if_supported(SHARED_LIBRARY_COMPILE_OPTIONS_TMP "-fpic")
        add_c_flag_if_supported(SHARED_LIBRARY_COMPILE_OPTIONS_TMP "-fPIC")
    endif(NOT CMAKE_C_COMPILER_ID STREQUAL "MSVC")

    message(STATUS "Setting debug and hardening compile definitions for executables: ${EXECUTABLE_COMPILE_DEFINITIONS_TMP}")
    set(EXECUTABLE_COMPILE_DEFINITIONS "${EXECUTABLE_COMPILE_DEFINITIONS_TMP}"
        CACHE INTERNAL "The build definitions for executable targets.")
    message(STATUS "Setting debug and hardening compile options for executables: ${EXECUTABLE_COMPILE_OPTIONS_TMP}")
    set(EXECUTABLE_COMPILE_OPTIONS "${EXECUTABLE_COMPILE_OPTIONS_TMP}"
        CACHE INTERNAL "The build options for executable targets.")
    message(STATUS "Setting debug and hardening link options for executables: ${EXECUTABLE_LINK_OPTIONS_TMP}")
    set(EXECUTABLE_LINK_OPTIONS "${EXECUTABLE_LINK_OPTIONS_TMP}"
        CACHE INTERNAL "The link options for executable targets.")
    message(STATUS "Setting debug and hardening compile definitions for shared libraries: ${SHARED_LIBRARY_COMPILE_DEFINITIONS_TMP}")
    set(SHARED_LIBRARY_COMPILE_DEFINITIONS "${SHARED_LIBRARY_COMPILE_DEFINITIONS_TMP}"
        CACHE INTERNAL "The build definitions for shared library targets.")
    message(STATUS "Setting debug and hardening compile options for shared libraries: ${SHARED_LIBRARY_COMPILE_OPTIONS_TMP}")
    set(SHARED_LIBRARY_COMPILE_OPTIONS "${SHARED_LIBRARY_COMPILE_OPTIONS_TMP}"
        CACHE INTERNAL "The build options for shared library targets.")
    message(STATUS "Setting debug and hardening link options for shared libraries: ${SHARED_LIBRARY_LINK_OPTIONS_TMP}")
    set(SHARED_LIBRARY_LINK_OPTIONS "${SHARED_LIBRARY_LINK_OPTIONS_TMP}"
        CACHE INTERNAL "The link options for shared library targets.")
endfunction(determine_target_debug_security_flags)

function(SET_TARGET_DEBUG_SECURITY_FLAGS TARGET)
    get_property(tgttype TARGET ${TARGET} PROPERTY TYPE)

    if(NOT EXECUTABLE_COMPILE_DEFINITIONS
       OR NOT EXECUTABLE_COMPILE_OPTIONS
       OR NOT EXECUTABLE_LINK_OPTIONS
       OR NOT SHARED_LIBRARY_COMPILE_DEFINITIONS
       OR NOT SHARED_LIBRARY_COMPILE_OPTIONS
       OR NOT SHARED_LIBRARY_LINK_OPTIONS)
        determine_target_debug_security_flags()
    endif(NOT EXECUTABLE_COMPILE_DEFINITIONS
          OR NOT EXECUTABLE_COMPILE_OPTIONS
          OR NOT EXECUTABLE_LINK_OPTIONS
          OR NOT SHARED_LIBRARY_COMPILE_DEFINITIONS
          OR NOT SHARED_LIBRARY_COMPILE_OPTIONS
          OR NOT SHARED_LIBRARY_LINK_OPTIONS)

    get_target_property(tgttype "${TARGET}" TYPE)
    if(${tgttype} STREQUAL "EXECUTABLE")
        if(${CMAKE_VERSION} VERSION_GREATER_EQUAL "3.0.0")
            target_compile_definitions(${TARGET}
                PRIVATE
                    ${EXECUTABLE_COMPILE_DEFINITIONS}
            )
        else(${CMAKE_VERSION} VERSION_GREATER_EQUAL "3.0.0")
            if(NOT "${EXECUTABLE_COMPILE_DEFINITIONS}" STREQUAL "")
                if(CMAKE_C_COMPILER_ID STREQUAL "AppleClang"
                   OR CMAKE_C_COMPILER_ID STREQUAL "Clang"
                   OR CMAKE_C_COMPILER_ID STREQUAL "GNU")
                    string(REPLACE ";" " -D" EXECUTABLE_COMPILE_JOINED_DEFS
                           "${EXECUTABLE_COMPILE_DEFINITIONS}")
                    set(CMAKE_C_FLAGS
                        "${CMAKE_C_FLAGS} -D${EXECUTABLE_COMPILE_JOINED_DEFS}")
                endif(CMAKE_C_COMPILER_ID STREQUAL "AppleClang"
                      OR CMAKE_C_COMPILER_ID STREQUAL "Clang"
                      OR CMAKE_C_COMPILER_ID STREQUAL "GNU")
                if(CMAKE_C_COMPILER_ID STREQUAL "MSVC")
                    string(REPLACE ";" " /D" EXECUTABLE_COMPILE_JOINED_DEFS
                           "${EXECUTABLE_COMPILE_DEFINITIONS}")
                    set(CMAKE_C_FLAGS
                        "${CMAKE_C_FLAGS} /D${EXECUTABLE_COMPILE_JOINED_DEFS}")
                endif(CMAKE_C_COMPILER_ID STREQUAL "MSVC")
            endif(NOT "${EXECUTABLE_COMPILE_DEFINITIONS}" STREQUAL "")
        endif(${CMAKE_VERSION} VERSION_GREATER_EQUAL "3.0.0")
        target_compile_options(${TARGET}
            PRIVATE
                ${EXECUTABLE_COMPILE_OPTIONS}
        )
        if(${CMAKE_VERSION} VERSION_GREATER_EQUAL "3.13.0")
            target_link_options(${TARGET}
                PRIVATE
                    ${EXECUTABLE_LINK_OPTIONS}
            )
        else(${CMAKE_VERSION} VERSION_GREATER_EQUAL "3.13.0")
            string(REPLACE ";" " " EXECUTABLE_LINK_JOINED_OPTIONS
                   "${EXECUTABLE_LINK_OPTIONS}")
            set(CMAKE_EXE_LINKER_FLAGS
                "${CMAKE_EXE_LINKER_FLAGS} ${EXECUTABLE_LINK_JOINED_OPTIONS}"
                PARENT_SCOPE)
        endif(${CMAKE_VERSION} VERSION_GREATER_EQUAL "3.13.0")
    elseif(${tgttype} STREQUAL "SHARED_LIBRARY")
        if(${CMAKE_VERSION} VERSION_GREATER_EQUAL "3.0.0")
            target_compile_definitions(${TARGET}
                PRIVATE
                    ${SHARED_LIBRARY_COMPILE_DEFINITIONS}
            )
        else(${CMAKE_VERSION} VERSION_GREATER_EQUAL "3.0.0")
            if(NOT "${SHARED_LIBRARY_COMPILE_DEFINITIONS}" STREQUAL "")
                if(CMAKE_C_COMPILER_ID STREQUAL "AppleClang"
                   OR CMAKE_C_COMPILER_ID STREQUAL "Clang"
                   OR CMAKE_C_COMPILER_ID STREQUAL "GNU")
                    string(REPLACE ";" " -D" SHARED_LIBRARY_COMPILE_JOINED_DEFS
                           "${SHARED_LIBRARY_COMPILE_DEFINITIONS}")
                    set(CMAKE_C_FLAGS
                        "${CMAKE_C_FLAGS} -D${SHARED_LIBRARY_COMPILE_JOINED_DEFS}")
                endif(CMAKE_C_COMPILER_ID STREQUAL "AppleClang"
                      OR CMAKE_C_COMPILER_ID STREQUAL "Clang"
                      OR CMAKE_C_COMPILER_ID STREQUAL "GNU")
                if(CMAKE_C_COMPILER_ID STREQUAL "MSVC")
                    string(REPLACE ";" " /D" SHARED_LIBRARY_COMPILE_JOINED_DEFS
                           "${SHARED_LIBRARY_COMPILE_DEFINITIONS}")
                    set(CMAKE_C_FLAGS
                        "${CMAKE_C_FLAGS} /D${SHARED_LIBRARY_COMPILE_JOINED_DEFS}")
                endif(CMAKE_C_COMPILER_ID STREQUAL "MSVC")
            endif(NOT "${SHARED_LIBRARY_COMPILE_DEFINITIONS}" STREQUAL "")
        endif(${CMAKE_VERSION} VERSION_GREATER_EQUAL "3.0.0")
        target_compile_options(${TARGET}
            PRIVATE
                ${SHARED_LIBRARY_COMPILE_OPTIONS}
        )
        if(${CMAKE_VERSION} VERSION_GREATER_EQUAL "3.13.0")
            target_link_options(${TARGET}
                PRIVATE
                    ${SHARED_LIBRARY_LINK_OPTIONS}
            )
        else(${CMAKE_VERSION} VERSION_GREATER_EQUAL "3.13.0")
            string(REPLACE ";" " " SHARED_LIBRARY_LINK_JOINED_OPTIONS
                   "${SHARED_LIBRARY_LINK_OPTIONS}")
            set(CMAKE_SHARED_LINKER_FLAGS
                "${CMAKE_SHARED_LINKER_FLAGS} ${SHARED_LIBRARY_LINK_JOINED_OPTIONS}"
                PARENT_SCOPE)
        endif(${CMAKE_VERSION} VERSION_GREATER_EQUAL "3.13.0")
    endif()
endfunction(SET_TARGET_DEBUG_SECURITY_FLAGS)
