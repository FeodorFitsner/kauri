##
##  SourceFileContainer.cmake
##  Revision: 2 (09 jan 2015)
##
##  Implementation of the map data structure.
##
##  Repo: git:steazzalini/cmake-modules
##  Deps:
##   - DataStructureSet  git:steazzalini/cmake-modules
##
##  Operations supported:
##
##   - ADD  add a list of soruce files to the container
##   - GET  get all the source file added to the container
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

include(DataStructureSet)
include(CMakeParseArguments)

#
# Main command
#
macro(SOURCE_FILE_CONTAINER _subcommand)

    # grab the args to pass to the subcommand
    set(_argv "${ARGV}")

    # switch `subcommand' and invoke it
    if(${_subcommand} STREQUAL "ADD")

        _source_file_container_add(${_argv})

    elseif(${_subcommand} STREQUAL "GET")

        _source_file_container_get(${_argv})

    else()

        message(FATAL_ERROR "Invalid subcommand privided.")

    endif()

endmacro()

#
# Subcommand:  ADD
# Description: add a list of soruce files to the container
# Usage:       source_file_container(ADD <container> FILES <file> [<file> [<file> [...]]])
#
function(_SOURCE_FILE_CONTAINER_ADD)

    set(usage_message "source_file_container(ADD <container> FILES <file> [<file> [<file> [...]]])")

    set(options)
    set(oneValueArgs ADD)
    set(multiValueArgs FILES)

    cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    set(container "${ARG_ADD}")
    set(files "${ARG_FILES}")

    if(container STREQUAL "" OR files STREQUAL "")
        _source_file_container_thorw_usage_message("${usage_message}")
    endif()

    data_structure_set(SET_SCOPE ${container} GLOBAL)

    foreach(file ${files})

        get_filename_component(absolute_file_path ${file} ABSOLUTE)

        data_structure_set(ADD ${container} ${absolute_file_path})

    endforeach()

endfunction()

#
# Subcommand:  GET
# Description: get all the source file added to the container
# Usage:       source_file_container(GET <container> <output variabl>)
#
function(_SOURCE_FILE_CONTAINER_GET)

    set(usage_message "source_file_container(GET <container> <output variabl>)")

    if(${ARGC} LESS 3)
        _data_structure_map_thorw_usage_message(${usage_message})
    endif()

    set(argv "${ARGV}")

    list(GET argv 1 container)
    list(GET argv 2 output)

    data_structure_set(VALUES ${container} files)

    set(${output} ${files} PARENT_SCOPE)

endfunction()

#
# Throw a bad command usage error
#
function(_SOURCE_FILE_CONTAINER_THORW_USAGE_MESSAGE usage)

    message(FATAL_ERROR "Usage: ${usage}")

endfunction()

## END ##
