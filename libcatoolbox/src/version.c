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

#include "stdafx.h"

LIBCATOOLBOX_EXPORT_SYMBOL_DEFAULT(catoolbox_get_version, catoolbox_get_version,
                                   LIBCATOOLBOX_0.1)
LIBCATOOLBOX_EXPORT CATOOLBOX_SAL_SUCCESS(return == CATOOLBOXE_OK)
CATOOLBOX_SAL_CHECK_RETURN CATOOLBOX_GCC_ATTRIBUTE_ACCESS((read_write, 1))
int LIBCATOOLBOX_CALLINGCONVENTION
catoolbox_get_version(CATOOLBOX_SAL_INOUT catoolbox_version_info * versionInfo)
{
    if (versionInfo == NULL) {
        return CATOOLBOXE_INVALID_PARAM;
    }
    if (versionInfo->size >= sizeof(catoolbox_version_info)) {
        versionInfo->major = CATOOLBOX_VERSION_MAJOR;
        versionInfo->minor = CATOOLBOX_VERSION_MINOR;
        versionInfo->build = CATOOLBOX_VERSION_BUILD;
#ifdef CATOOLBOX_VERSION_IS_DEV_BUILD
        versionInfo->is_dev_build = true;
#else /* CATOOLBOX_VERSION_IS_DEV_BUILD */
        versionInfo->is_dev_build = false;
#endif /* CATOOLBOX_VERSION_IS_DEV_BUILD */
    }
    return CATOOLBOXE_OK;
}
