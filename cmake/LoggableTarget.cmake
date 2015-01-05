##
##  FindLoggableTarget.cmake
##  Revision: 3 (05 jan 2015)
##
##  Insipired by http://www.kitware.com/blog/home/post/39
##  `LOGGABLE_TARGET' is a wrappers to the major `add_???' commands
##  with the purpose to track all the targets declared through it
##  and then log all the relative information in various file formats.
##
##  Commands:
##   - ADD      declare a target that could be a library or executable
##   - LOG      log to file all the informations about the declared targets
##
##  File formats supported:
##   - XML
##   - INI
##   - YAML
##
##  Repo: git:steazzalini/cmake-modules
##  Deps:
##   - DataStructureSet  git:steazzalini/cmake-modules
##   - DataStructureMap  git:steazzalini/cmake-modules
##
##  Operations supported:
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
include(DataStructureMap)

#
# Main command
#
macro(LOGGABLE_TARGET _subcommand)

    # grab the args to pass to the subcommand
    set(_subcommand_argv "${ARGN}")

    # switch `subcommand' and invoke it
    if(${_subcommand} STREQUAL "ADD")

        _loggable_target_add(${_subcommand_argv})

    elseif(${_subcommand} STREQUAL "LOG")

        _loggable_target_log(${_subcommand_argv})

    else()

        message(FATAL_ERROR "Invalid subcommand privided.")

    endif()

endmacro()

#
# Subcommand:  ADD
# Description: declare a target that could be a library or executable
# Usage:       loggable_target(ADD <LIBRARY | EXECUTABLE> <name> [<usual add_* args>])
#
function(_LOGGABLE_TARGET_ADD kind target_name)

    set(usage_message "loggable_target(ADD <LIBRARY | EXECUTABLE> <name> [<usual add_* args>])")

    set(add_xxx_args ${ARGN})

    list(INSERT add_xxx_args 0 ${target_name})

    if(kind STREQUAL "LIBRARY")

        add_library(${add_xxx_args})

    elseif(kind STREQUAL "EXECUTABLE")

        add_executable(${add_xxx_args})

    else()

        _loggable_target_thorw_usage_message(${_usage_message})

    endif()

    data_structure_set(ADD "_loggable_target_targets" ${target_name})

    data_structure_set(SET_SCOPE "_loggable_target_targets" GLOBAL)

endfunction()

#
# Subcommand:  LOG
# Description: log to file all the informations about the declared targets
# Usage:       loggable_target(LOG <XML | INI | YAML> <filename>)
#
function(_LOGGABLE_TARGET_LOG format filename)

    set(usage_message "loggable_target(LOG <XML | INI | YAML> <filename>)")

    if(format STREQUAL "XML")

        _loggable_target_log_xml(${filename})

    elseif(format STREQUAL "INI")

        _loggable_target_log_ini(${filename})

    elseif(format STREQUAL "YAML")

        _loggable_target_log_yaml(${filename})

    else()

        _loggable_target_thorw_usage_message(${usage_message})

    endif()

endfunction()

# Create the XML and write it to a file at `filename'
function(_LOGGABLE_TARGET_LOG_XML filename)

    data_structure_set(VALUES "_loggable_target_targets" targets)

    set(xml "")

    string(CONCAT xml ${xml} "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n")
    string(CONCAT xml ${xml} "<!--\n")
    string(CONCAT xml ${xml} "\n")
    string(CONCAT xml ${xml} "    Created by CMake through LoggableTarget module.\n")
    string(CONCAT xml ${xml} "    https://github.com/steazzalini/cmake-modules\n")
    string(CONCAT xml ${xml} "\n")
    string(CONCAT xml ${xml} "-->\n")

    string(CONCAT xml ${xml} "<targets>" "\n")

    foreach(target ${targets})

        _loggable_target_get_target_properties_map(property_value_map ${target})

        string(CONCAT xml ${xml} "    <target>\n")

        data_structure_map(KEYS property_value_map properties)

        foreach(property ${properties})

            data_structure_map(GET property_value_map ${property} value)

            string(CONCAT xml ${xml} "        <${property}>${value}</${property}>\n")

        endforeach()

        string(CONCAT xml ${xml} "    </target>\n")

    endforeach()

    string(CONCAT xml ${xml} "</targets>\n")

    file(GENERATE OUTPUT ${filename} CONTENT ${xml})

endfunction()

# Create the INI and write it to a file at `filename'
function(_LOGGABLE_TARGET_LOG_INI filename)

    data_structure_set(VALUES "_loggable_target_targets" targets)

    set(ini "")

    string(CONCAT ini ${ini} "$<SEMICOLON>\n")
    string(CONCAT ini ${ini} "$<SEMICOLON>  Created by CMake through LoggableTarget module.\n")
    string(CONCAT ini ${ini} "$<SEMICOLON>  https://github.com/steazzalini/cmake-modules\n")
    string(CONCAT ini ${ini} "$<SEMICOLON>\n")
    string(CONCAT ini ${ini} "\n")

    foreach(target ${targets})

        _loggable_target_get_target_properties_map(property_value_map ${target})

        data_structure_map(KEYS property_value_map properties)

        string(CONCAT ini ${ini} "[${target}]\n")

        foreach(property ${properties})

            data_structure_map(GET property_value_map ${property} value)

            string(CONCAT ini ${ini} "${property} = \"${value}\"\n")

        endforeach()

        string(CONCAT ini ${ini} "\n")

    endforeach()

    file(GENERATE OUTPUT ${filename} CONTENT ${ini})

endfunction()

# Create the YAML and write it to a file at `filename'
function(_LOGGABLE_TARGET_LOG_YAML filename)

    data_structure_set(VALUES "_loggable_target_targets" targets)

    set(yaml "")

    string(CONCAT yaml ${yaml} "#\n")
    string(CONCAT yaml ${yaml} "#  Created by CMake through LoggableTarget module.\n")
    string(CONCAT yaml ${yaml} "#  https://github.com/steazzalini/cmake-modules\n")
    string(CONCAT yaml ${yaml} "#\n")
    string(CONCAT yaml ${yaml} "\n")

    string(CONCAT yaml ${yaml} "targets:\n")

    foreach(target ${targets})

        string(CONCAT yaml ${yaml} "    - ${target}\n")

    endforeach()

    string(CONCAT yaml ${yaml} "\n")

    foreach(target ${targets})

        _loggable_target_get_target_properties_map(property_value_map ${target})

        data_structure_map(KEYS property_value_map properties)

        string(CONCAT yaml ${yaml} "${target}:\n")

        foreach(property ${properties})

            data_structure_map(GET property_value_map ${property} value)

            string(CONCAT yaml ${yaml} "    - ${property}: \"${value}\"\n")

        endforeach()

        string(CONCAT yaml ${yaml} "\n")

    endforeach()

    file(GENERATE OUTPUT ${filename} CONTENT ${yaml})

endfunction()

# Init the map named `map_name' setting as the property as key
# and as value the property's value
function(_LOGGABLE_TARGET_GET_TARGET_PROPERTIES_MAP map_name target)

    get_target_property(target_type ${target} TYPE)
    get_target_property(exports_enabled ${target} ENABLE_EXPORTS)

    data_structure_map(CLEAR ${map_name})

    data_structure_map(SET ${map_name} target_name      "${target}")
    data_structure_map(SET ${map_name} target_file      "$<TARGET_FILE:${target}>")
    data_structure_map(SET ${map_name} target_file_name "$<TARGET_FILE_NAME:${target}>")
    data_structure_map(SET ${map_name} target_file_dir  "$<TARGET_FILE_DIR:${target}>")

    if(
        (target_type STREQUAL "STATIC_LIBRARY") OR
        (target_type STREQUAL "SHARED_LIBRARY") OR
        (target_type STREQUAL "MODULE_LIBRARY") OR
        (target_type STREQUAL "EXECUTABLE" AND exports_enabled))

        data_structure_map(SET ${map_name} linker_file      "$<TARGET_LINKER_FILE:${target}>")
        data_structure_map(SET ${map_name} linker_file_name "$<TARGET_LINKER_FILE_NAME:${target}>")
        data_structure_map(SET ${map_name} linker_file_dir  "$<TARGET_LINKER_FILE_DIR:${target}>")

    endif()

    if(target_type STREQUAL "SHARED_LIBRARY")

        data_structure_map(SET ${map_name} soname_file      "$<TARGET_SONAME_FILE:${target}>")
        data_structure_map(SET ${map_name} soname_file_name "$<TARGET_SONAME_FILE_NAME:${target}>")
        data_structure_map(SET ${map_name} soname_file_dir  "$<TARGET_SONAME_FILE_DIR:${target}>")

    endif()

    _loggable_target_get_properties_available_through_target_property_generator(properties)

    foreach(property ${properties})

        string(TOLOWER ${property} lowercase_property)

        data_structure_map(SET ${map_name} ${lowercase_property} "$<TARGET_PROPERTY:${target},${property}>")

    endforeach()

endfunction()

# Set `output' with the list of properties
# available using the $<TARGET_PROPERTY:tgt, prop> generator
function(_LOGGABLE_TARGET_GET_PROPERTIES_AVAILABLE_THROUGH_TARGET_PROPERTY_GENERATOR output)

    set(properties
        ARCHIVE_OUTPUT_DIRECTORY
        ARCHIVE_OUTPUT_DIRECTORY_DEBUG
        ARCHIVE_OUTPUT_DIRECTORY_RELEASE
        ARCHIVE_OUTPUT_NAME
        ARCHIVE_OUTPUT_NAME_DEBUG
        ARCHIVE_OUTPUT_NAME_RELEASE
        AUTOMOC
        AUTOMOC_MOC_OPTIONS
        BUILD_WITH_INSTALL_RPATH
        BUNDLE
        BUNDLE_EXTENSION
        COMPILE_DEFINITIONS
        COMPILE_DEFINITIONS_DEBUG
        COMPILE_DEFINITIONS_RELEASE
        COMPILE_FLAGS
        DEBUG_OUTPUT_NAME
        DEBUG_POSTFIX
        DEFINE_SYMBOL
        EchoString
        ENABLE_EXPORTS
        EXCLUDE_FROM_ALL
        FOLDER
        Fortran_FORMAT
        Fortran_MODULE_DIRECTORY
        FRAMEWORK
        GENERATOR_FILE_NAME
        GNUtoMS
        HAS_CXX
        IMPLICIT_DEPENDS_INCLUDE_TRANSFORM
        IMPORTED
        IMPORTED_CONFIGURATIONS
        IMPORTED_IMPLIB
        IMPORTED_IMPLIB_DEBUG
        IMPORTED_IMPLIB_RELEASE
        IMPORTED_LINK_DEPENDENT_LIBRARIES
        IMPORTED_LINK_DEPENDENT_LIBRARIES_DEBUG
        IMPORTED_LINK_DEPENDENT_LIBRARIES_RELEASE
        IMPORTED_LINK_INTERFACE_LANGUAGES
        IMPORTED_LINK_INTERFACE_LANGUAGES_DEBUG
        IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE
        IMPORTED_LINK_INTERFACE_LIBRARIES
        IMPORTED_LINK_INTERFACE_LIBRARIES_DEBUG
        IMPORTED_LINK_INTERFACE_LIBRARIES_RELEASE
        IMPORTED_LINK_INTERFACE_MULTIPLICITY
        IMPORTED_LINK_INTERFACE_MULTIPLICITY_DEBUG
        IMPORTED_LINK_INTERFACE_MULTIPLICITY_RELEASE
        IMPORTED_LOCATION
        IMPORTED_LOCATION_DEBUG
        IMPORTED_LOCATION_RELEASE
        IMPORTED_NO_SONAME
        IMPORTED_NO_SONAME_DEBUG
        IMPORTED_NO_SONAME_RELEASE
        IMPORTED_SONAME
        IMPORTED_SONAME_DEBUG
        IMPORTED_SONAME_RELEASE
        IMPORT_PREFIX
        IMPORT_SUFFIX
        INCLUDE_DIRECTORIES
        INSTALL_NAME_DIR
        INSTALL_RPATH
        INSTALL_RPATH_USE_LINK_PATH
        INTERPROCEDURAL_OPTIMIZATION
        INTERPROCEDURAL_OPTIMIZATION_DEBUG
        INTERPROCEDURAL_OPTIMIZATION_RELEASE
        LABELS
        LIBRARY_OUTPUT_DIRECTORY
        LIBRARY_OUTPUT_DIRECTORY_DEBUG
        LIBRARY_OUTPUT_DIRECTORY_RELEASE
        LIBRARY_OUTPUT_NAME
        LIBRARY_OUTPUT_NAME_DEBUG
        LIBRARY_OUTPUT_NAME_RELEASE
        LINKER_LANGUAGE
        LINK_DEPENDS
        LINK_FLAGS
        LINK_FLAGS_DEBUG
        LINK_FLAGS_RELEASE
        LINK_INTERFACE_LIBRARIES
        LINK_INTERFACE_LIBRARIES_DEBUG
        LINK_INTERFACE_LIBRARIES_RELEASE
        LINK_INTERFACE_MULTIPLICITY
        LINK_INTERFACE_MULTIPLICITY_DEBUG
        LINK_INTERFACE_MULTIPLICITY_RELEASE
        LINK_SEARCH_END_STATIC
        LINK_SEARCH_START_STATIC
        MACOSX_BUNDLE
        MACOSX_BUNDLE_INFO_PLIST
        MACOSX_FRAMEWORK_INFO_PLIST
        MAP_IMPORTED_CONFIG_DEBUG
        MAP_IMPORTED_CONFIG_RELEASE
        OSX_ARCHITECTURES
        OSX_ARCHITECTURES_DEBUG
        OSX_ARCHITECTURES_RELEASE
        OUTPUT_NAME
        OUTPUT_NAME_DEBUG
        OUTPUT_NAME_RELEASE
        POST_INSTALL_SCRIPT
        PREFIX
        PRE_INSTALL_SCRIPT
        PRIVATE_HEADER
        PROJECT_LABEL
        PUBLIC_HEADER
        RELEASE_OUTPUT_NAME
        RELEASE_POSTFIX
        RESOURCE
        RULE_LAUNCH_COMPILE
        RULE_LAUNCH_CUSTOM
        RULE_LAUNCH_LINK
        RUNTIME_OUTPUT_DIRECTORY
        RUNTIME_OUTPUT_DIRECTORY_DEBUG
        RUNTIME_OUTPUT_DIRECTORY_RELEASE
        RUNTIME_OUTPUT_NAME
        RUNTIME_OUTPUT_NAME_DEBUG
        RUNTIME_OUTPUT_NAME_RELEASE
        SKIP_BUILD_RPATH
        SOURCES
        SOVERSION
        STATIC_LIBRARY_FLAGS
        STATIC_LIBRARY_FLAGS_DEBUG
        STATIC_LIBRARY_FLAGS_RELEASE
        SUFFIX
        TYPE
        VERSION
        VS_DOTNET_REFERENCES
        VS_GLOBAL_KEYWORD
        VS_GLOBAL_PROJECT_TYPES
        VS_GLOBAL_WHATEVER
        VS_KEYWORD
        VS_SCC_AUXPATH
        VS_SCC_LOCALPATH
        VS_SCC_PROJECTNAME
        VS_SCC_PROVIDER
        VS_WINRT_EXTENSIONS
        VS_WINRT_REFERENCES
        WIN32_EXECUTABLE
        XCODE_ATTRIBUTE_WHATEVER)

    set(${output} ${properties} PARENT_SCOPE)

endfunction()

#
# Throw a bad command usage error
#
function(_LOGGABLE_TARGET_THORW_USAGE_MESSAGE usage)

    message(FATAL_ERROR "Usage: ${usage}")

endfunction()

### END ###
