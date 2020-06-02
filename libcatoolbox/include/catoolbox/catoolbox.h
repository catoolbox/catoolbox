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
 * @file catoolbox.h
 * @brief The <tt>libcatoolbox</tt> API.
 *
 * This header contains all <tt>libcatoolbox</tt> APIs.
 */

#ifndef CATOOLBOX_CATOOLBOX_H
#define CATOOLBOX_CATOOLBOX_H

/* To allow developers to control the dependencies of their program with
   confidence, API are versioned according to their minor release.
   If you define CATOOLBOX_REQUIRE_VERSION before including this header,
   any APIs belonging to a minor version greater than the one you specify
   will not be available. If no such constant is defined, all APIs will be
   available by default. */
#ifndef CATOOLBOX_REQUIRE_VERSION
    #define CATOOLBOX_REQUIRE_VERSION 1
#endif /* CATOOLBOX_REQUIRE_VERSION */

#include <catoolbox/export.h>

#include <catoolbox/errcodes.h>
#include <catoolbox/version.h>

#endif /* CATOOLBOX_CATOOLBOX_H */
