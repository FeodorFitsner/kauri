##
##  GlobalSourceFilesProperties.cmake
##  Revision: 4 (09 jan 2015)
##
##  Manage global scoped source files properties.
##  Using `set_source_files_properties' a property set to a source file
##  is only visible in caller directory scope.
##  This module provide a workaround to this limitation.
##
##  Repo: git:steazzalini/cmake-modules
##  Deps:
##   - DataStructureSet  git:steazzalini/cmake-modules
##   - DataStructureMap  git:steazzalini/cmake-modules
##
##  Operations supported:
##
##   - SET     set one or more properties to a given file list
##   - EXPORT  export to the caller scope all or given source file properties
##
##  Usage example:
##
##  proj\CMakeLists.txt:
##
##    include(GlobalSourceFilesProperties REQUIRED)
##
##    add_subdirectory(subdir)
##
##    global_source_files_properties(EXPORT ALL)
##    # -> now properties prop1 and prop2 set to a.txt, b.txt and c.txt in subdir are visible in this scope
##
##    set_global_source_files_properties(a.txt PROPERTIES prop3 value3)
##    # -> prop3 set to a.txt is also visible here without exporting it
##
##  proj\subdir\CMakeLists.txt:
##
##    include(GlobalSourceFilesProperties REQUIRED)
##
##    global_source_files_properties(SET a.txt b.txt c.txt PROPERTIES prop1 value1 prop2 value2)
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

include(DataStructureSet)
include(DataStructureMap)

#
# Main command
#
macro(GLOBAL_SOURCE_FILES_PROPERTIES _subcommand)

    # grab the args to pass to the subcommand
    set(_subcommand_argv "${ARGN}")

    # switch `subcommand' and invoke it
    if(${_subcommand} STREQUAL "SET")

        _global_source_files_properties_set(${_subcommand_argv})

    elseif(${_subcommand} STREQUAL "GET")

        _global_source_files_properties_get(${_subcommand_argv})

    elseif(${_subcommand} STREQUAL "EXPORT")

        _global_source_files_properties_export(${_subcommand_argv})

    else()

        message(FATAL_ERROR "Invalid subcommand privided.")

    endif()

endmacro()

#
# Subcommand:  SET
# Description: set one or more properties to a given file list
# Usage:       global_source_files_properties(SET <file1> [<file2> [...]] PROPERTIES <prop1> <value1> [<prop2> <value2> [...]])
#
function(_GLOBAL_SOURCE_FILES_PROPERTIES_SET)

    set(usage_message "global_source_files_properties(SET <file1> [<file2> [...]] PROPERTIES <prop1> <value1> [<prop2> <value2> [...]])")

    # to make it easier to manage
    set(argv "${ARGV}")

    # verify that "PROPERTIES" is in the `argv' list
    # and it's not the first argument

    list(FIND argv "PROPERTIES" property_keyword_index)

    if(NOT property_keyword_index GREATER 0)
        _global_source_files_properties_thorw_usage_message("${usage_message}")
    endif()

    # push into `files' the absolute path of the files we want to set the properties to
    foreach(arg ${argv})

        if(${arg} STREQUAL "PROPERTIES")
            break()
        endif()

        get_filename_component(file_absolute_path ${arg} ABSOLUTE)

        list(APPEND files ${file_absolute_path})

    endforeach()

    math(EXPR first_property_index "${property_keyword_index} + 1")
    math(EXPR last_index "${ARGC} - 1")
    math(EXPR property_value_args_count "${last_index} - ${property_keyword_index}")

    if(property_value_args_count LESS 2)
        _global_source_files_properties_thorw_usage_message("${usage_message}")
    endif()

    math(EXPR property_value_args_count_module_2 "(${last_index} - ${property_keyword_index}) % 2")

    if(NOT property_value_args_count_module_2 EQUAL 0)
        _global_source_files_properties_thorw_usage_message("${usage_message}")
    endif()

    foreach(file ${files})

        set(property_value_map_name "_global_source_files_properties_property_value_map_${file}")

        data_structure_map(SET_SCOPE ${property_value_map_name} GLOBAL)

        data_structure_set(SET_SCOPE "_global_source_files_properties_files" GLOBAL)
        data_structure_set(ADD "_global_source_files_properties_files" ${file})

        foreach(property_name_index RANGE ${first_property_index} ${last_index} 2)

            math(EXPR property_value_index "${property_name_index} + 1")

            list(GET argv ${property_name_index} property_name)
            list(GET argv ${property_value_index} property_value)

            data_structure_map(SET ${property_value_map_name} ${property_name} ${property_value})

            # set the propery in the current directory scope as well
            set_source_files_properties(${file} PROPERTIES ${property_name} ${property_value})

        endforeach()

    endforeach()

endfunction()

#
# Subcommand:  EXPORT
# Description: export to the caller scope all or given source file properties
# Usage:       global_source_files_properties(EXPORT <ALL | <file1> [<file2> [...]]>)
#
function(_GLOBAL_SOURCE_FILES_PROPERTIES_EXPORT)

    set(usage_message "global_source_files_properties(EXPORT <ALL | <file1> [<file2> [...]]>)")

    set(argv "${ARGV}")

    if(${ARGC} LESS 1)
        _global_source_files_properties_thorw_usage_message("${usage_message}")
    endif()

    list(GET argv 0 first_arg)

    if(first_arg STREQUAL "ALL")

        data_structure_set(VALUES "_global_source_files_properties_files" files_to_export)

    else()

        foreach(file ${argv})

            get_filename_component(file_absolute_path ${file} ABSOLUTE)

            list(APPEND files_to_export ${file_absolute_path})

        endforeach()

    endif()

    foreach(file ${files_to_export})

        set(property_value_map_name "_global_source_files_properties_property_value_map_${file}")

        data_structure_map(KEYS ${property_value_map_name} properties)

        foreach(property ${properties})

            data_structure_map(GET ${property_value_map_name} ${property} value)

            set_source_files_properties(${file} PROPERTIES ${property} ${value})

        endforeach()

    endforeach()

endfunction()

#
# Throw a bad command usage error
#
function(_GLOBAL_SOURCE_FILES_PROPERTIES_THORW_USAGE_MESSAGE usage)

    message(FATAL_ERROR "Usage: ${usage}")

endfunction()

### END ###
