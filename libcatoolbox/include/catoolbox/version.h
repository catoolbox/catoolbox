/*
 * Copyright © 2019, the catoolbox contributors
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
 * @file version.h
 * @brief The <tt>libcatoolbox</tt> version API.
 *
 * This header contains the APIs required to get the version of the
 * <tt>libcatoolbox</tt> library.
 */

#ifndef CATOOLBOX_VERSION_H
#define CATOOLBOX_VERSION_H

#include <catoolbox/export.h>

#include <stdlib.h>
#include <stdbool.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

    /**
     * @brief The structure used to return the <tt>libcatoolbox</tt> version
     * information.
     */
    typedef struct {
        /**
         * @brief The size of the structure.
         *
         * This field must be populated with
         * <tt>sizeof(catoolbox_version_info)</tt> before calling
         * <tt>catoolbox_get_version()</tt>.
         */
        size_t size;
        /**
         * @brief The major version of <tt>libcatoolbox</tt>.
         */
        uint32_t major;
        /**
         * @brief The minor version of <tt>libcatoolbox</tt>.
         */
        uint32_t minor;
        /**
         * @brief The build version of <tt>libcatoolbox</tt>.
         */
        uint32_t build;
        /**
         * @brief Specifies whether the build is a development build.
         *
         * If this field is <tt>true</tt>, the version of <tt>libcatoolbox</tt>
         * in use is a development build; otherwise, it is a release.
         */
        bool is_dev_build;
    } catoolbox_version_info;

    /**
     * @brief Get the version information of <tt>libcatoolbox</tt>.
     *
     * This function takes an instance of <tt>catoolbox_version_info</tt>
     * passed in @p versionInfo and populates it with the version information
     * provided by the library. A client application can then dynamically check
     * for its version and (possibly) disable unsupported features.
     *
     * @param[in,out] versionInfo A pointer to an instance of the
     * <tt>catoolbox_version_info</tt> structure where the version data will be
     * saved. The <tt>size</tt> member of the structure must be populated with
     * <tt>sizeof(catoolbox_version_info)</tt> before calling this function.
     * @return Returns <tt>CATOOLBOXE_OK</tt> if the operation completed
     * successfully or <tt>CATOOLBOXE_INVALID_PARAM</tt> if
     * <tt>versionInfo</tt> is <tt>NULL</tt>.
     */
    LIBCATOOLBOX_EXPORT extern int LIBCATOOLBOX_CALLINGCONVENTION
        catoolbox_get_version(catoolbox_version_info * versionInfo);

#ifdef  __cplusplus
}
#endif /* __cplusplus */
#endif /* CATOOLBOX_VERSION_H */
