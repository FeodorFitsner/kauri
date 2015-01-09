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

find_package(FLEX REQUIRED)
find_package(BISON REQUIRED)

include(GlobalSourceFilesProperties)
include(SourceFileContainer)

flex_target(
    kauri_scanner
    ${CMAKE_CURRENT_SOURCE_DIR}/scanner.l
    ${CMAKE_CURRENT_BIANRY_DIR}/scanner.cpp)

bison_target(
    kauri_parser
    ${CMAKE_CURRENT_SOURCE_DIR}/parser.y
    ${CMAKE_CURRENT_BINARY_DIR}/parser.cpp)

add_flex_bison_dependency(kauri_scanner kauri_parser)

global_source_files_properties(
    SET
        ${CMAKE_CURRENT_SOURCE_DIR}/scanner.cpp     # use CMAKE_CURRENT_BINARY_DIR instead
        ${CMAKE_CURRENT_SOURCE_DIR}/parser.cpp
    PROPERTIES
        GENERATED TRUE)

source_file_container(
    ADD
        kauri_source_files
    FILES
        ${CMAKE_CURRENT_SOURCE_DIR}/scanner.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/parser.cpp)

## END ##
