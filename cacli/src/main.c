/*
 * Copyright © 2019, the catoolbox contributors
 *
 * cacli is free software: you can redistribute it and/or modify it under the
 * terms of the GNU General Public License as published by the Free Software
 * Foundation, either version 3 of the License, or (at your option) any later
 * version.
 *
 * cacli is distributed in the hope that it will be useful, but WITHOUT ANY
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
 * details.
 *
 * You should have received a copy of the GNU General Public License along with
 * cacli. If not, see <http://www.gnu.org/licenses/>.
 *
 * Additional permission under GNU GPL version 3 section 7
 *
 * If you modify cacli, or any covered work, by linking or combining it with
 * - OpenSSL (or a modified version of that library),
 * - any C/C++ runtime library,
 * containing parts covered by the terms of their respective licenses, the
 * licensors of cacli grant you additional permission to convey the
 * resulting work.
 * If you modify this software, you may extend this exception to your version of
 * the software, but you are not obliged to do so. If you do not wish to do so,
 * delete this exception statement from your version.
 */

#include <stdio.h>
#include <stdlib.h>

/**
 * The cacli entry point.
 *
 * @return This function returns:
 * <ul>
 * <li><tt>EXIT_SUCCESS</tt> if the operation completed successfully.</li>
 * </ul>
 */
int main(int argc, char *argv[])
{
    printf("Hello, World!\n");
    return EXIT_SUCCESS;
}