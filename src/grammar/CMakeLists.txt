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
    kauri_flex_scanner
    ${CMAKE_CURRENT_SOURCE_DIR}/scanner.l
    ${CMAKE_CURRENT_BINARY_DIR}/scanner.cpp)

bison_target(
    kauri_bison_parser
    ${CMAKE_CURRENT_SOURCE_DIR}/parser.y
    ${CMAKE_CURRENT_BINARY_DIR}/parser.cpp)

add_flex_bison_dependency(kauri_flex_scanner kauri_bison_parser)

add_custom_target(
    kauri_parser
    DEPENDS
        ${FLEX_kauri_flex_scanner_OUTPUTS}
        ${BISON_kauri_bison_parser_OUTPUTS})

global_source_files_properties(
    SET
        ${CMAKE_CURRENT_BINARY_DIR}/scanner.cpp
        ${CMAKE_CURRENT_BINARY_DIR}/parser.cpp
    PROPERTIES
        # skip the file presence check during the configuration process
        GENERATED TRUE
        # flex uses a lot the `register' class specifier, which is deprecated... no care about that too much
        COMPILE_FLAGS -Wno-deprecated-register)

source_file_container(
    ADD
        kauri_source_files
    FILES
        ${CMAKE_CURRENT_BINARY_DIR}/scanner.cpp
        ${CMAKE_CURRENT_BINARY_DIR}/parser.cpp)

## END ##
