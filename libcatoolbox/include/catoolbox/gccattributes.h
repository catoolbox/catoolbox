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
 * @file gccattributes.h
 * @brief <tt>libcatoolbox</tt> GCC attributes.
 *
 * This header defines GCC annotation macros. It is not meant to be included
 * directly.
 */

#ifndef CATOOLBOX_INTERNAL_INCLUDE_GUARD
#error This header is used by libcatoolbox internals and is not meant to be included directly.
#endif /* CATOOLBOX_INTERNAL_INCLUDE_GUARD */

#ifndef CATOOLBOX_GCCANNOTATIONS_H
#define CATOOLBOX_GCCANNOTATIONS_H

#if defined(__GNUC__) && __GNUC__ >= 10
    #define CATOOLBOX_GCC_ATTRIBUTE_ACCESS(x) __attribute__((access (x)))
#else
    #define CATOOLBOX_GCC_ATTRIBUTE_ACCESS(x)
#endif /* defined(__GNUC__) && __GNUC__ >= 10 */

#endif /* CATOOLBOX_GCCANNOTATIONS_H */
