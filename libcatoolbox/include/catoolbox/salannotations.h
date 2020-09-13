/*
 * Copyright © 2019-2020, the catoolbox contributors
 *
 * libcatoolbox is free software: you can redistribute it and/or modify it
 * under the terms of the GNU Lesser General Public License as published by the
 * Free Software Foundation, either version 3 of the License, or (at your
 * option) any later version.
 *
 * libcatoolbox is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
 * more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with libcatoolbox. If not, see <http://www.gnu.org/licenses/>.
 *
 * Additional permission under GNU GPL version 3 section 7
 *
 * If you modify libcatoolbox, or any covered work, by linking or combining it
 * with
 * - OpenSSL (or a modified version of that library), or
 * - any C/C++ runtime library,
 * containing parts covered by the terms of their respective licenses, the
 * licensors of libcatoolbox grant you additional permission to convey the
 * resulting work.
 * If you modify this library, you may extend this exception to your version of
 * the library, but you are not obliged to do so. If you do not wish to do so,
 * delete this exception statement from your version.
 */

/**
 * @file salannotations.h
 * @brief <tt>libcatoolbox</tt> SAL annotations.
 *
 * This header imports SAL annotations if they are available and defines empty
 * stubs otherwise. It is not meant to be included directly.
 */

#ifndef CATOOLBOX_INTERNAL_INCLUDE_GUARD
#error This header is used by libcatoolbox internals and is not meant to be included directly.
#endif /* CATOOLBOX_INTERNAL_INCLUDE_GUARD */

#ifndef CATOOLBOX_SALANNOTATIONS_H
#define CATOOLBOX_SALANNOTATIONS_H

/* Include SAL annotations. */
#ifdef _MSC_VER
    #include <sal.h>
#endif /* _MSC_VER */

/* SAL annotations will be added as necessary since adding too many of them
   carries the risk of redefining one or more macros.
   We also have to use a custom prefix to prevent GCC from complaining about
   reserved identifiers. */
#ifdef _Check_return_
    #define CATOOLBOX_SAL_CHECK_RETURN _Check_return_
#else
    #define CATOOLBOX_SAL_CHECK_RETURN
#endif /* _Check_return_ */
#ifdef _Inout_
    #define CATOOLBOX_SAL_INOUT _Inout_
#else
    #define CATOOLBOX_SAL_INOUT
#endif /* _Inout_ */
#ifdef _Struct_size_bytes_
    #define CATOOLBOX_SAL_STRUCT_SIZE_BYTES(s) _Struct_size_bytes_(s)
#else
    #define CATOOLBOX_SAL_STRUCT_SIZE_BYTES(s)
#endif /* _Struct_size_bytes_ */
#ifdef _Success_
    #define CATOOLBOX_SAL_SUCCESS(e) _Success_(e)
#else
    #define CATOOLBOX_SAL_SUCCESS(e)
#endif /* _Success_ */

#endif /* CATOOLBOX_SALANNOTATIONS_H */
