##
##  kauri
##
##  Copyright (C) 2015 Stefano Azzalini <steazzalini>
##
##  This program is free software: you can redistribute it and/or modify
##  it under the terms of the GNU General Public License as published by
##  the Free Software Foundation, either version 3 of the License, or
##  (at your option) any later version.
##
##  This program is distributed in the hope that it will be useful,
##  but WITHOUT ANY WARRANTY; without even the implied warranty of
##  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
##  GNU General Public License for more details.
##
##  You should have received a copy of the GNU General Public License
##  along with this program. If not, see <http://www.gnu.org/licenses/>.
##

cmake_minimum_required(VERSION 2.8.7 FATAL_ERROR)

project(KAURI CXX)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")

include(KauriUserConfiguration)
include(KauriTargets)
include(KauriToolchainDefinitions)
include(KauriOutputDirectoryDefinitions)

add_subdirectory(src)
add_subdirectory(ext)

# ... only if the user wants to
if(KAURI_DEFINE_TEST_TARGETS)

    enable_testing()

    add_subdirectory(test EXCLUDE_FROM_ALL)

endif()

# ... only if the user wants to
if(KAURI_LOG_CMAKE_FEATURE_SUMMARY)

    feature_summary(
        FILENAME ${KAURI_LOG_CMAKE_FEATURE_SUMMARY_PATH}
        INCLUDE_QUIET_PACKAGES
        WHAT ALL)

endif()

# ... only if the user wants to
if(KAURI_LOG_XML_TARGETS_INFO)

    kauri_write_targets_logs(XML ${KAURI_LOG_XML_TARGETS_INFO_PATH})

endif()

## END ##
