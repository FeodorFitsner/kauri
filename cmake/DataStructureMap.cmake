##
##  DataStructureMap.cmake
##  Revision: 7 (05 jan 2015)
##
##  Implementation of the map data structure.
##
##  Repo: git:steazzalini/cmake-modules
##  Deps:
##   - DataStructureSet  git:steazzalini/cmake-modules
##   - Assert (optional) git:steazzalini/cmake-modules
##
##  Operations supported:
##
##   - INIT         initialize the map with a key-value pair list
##   - SET          set values with a key-value pair list
##   - GET          get the value associated with a given key
##   - REMOVE       remove a key from the map
##   - KEYS         get the list of keys in the map
##   - VALUES       get the list of values in the map
##   - CLEAR        remove all the items
##   - IS_EMPTY     verify if the map is empty
##   - COUNT        get the number of items in the map
##   - GET_SCOPE    get the scope of the map
##   - SET_SCOPE    make the map DIRECTORY or GLOBAL scoped
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

#
# Main command
#
macro(DATA_STRUCTURE_MAP _subcommand)

    # grab the args to pass to the subcommand
    set(_subcommand_argv "${ARGN}")

    # switch `subcommand' and invoke it
    if(${_subcommand} STREQUAL "INIT")

        _data_structure_map_init(${_subcommand_argv})

    elseif(${_subcommand} STREQUAL "SET")

        _data_structure_map_set(${_subcommand_argv})

    elseif(${_subcommand} STREQUAL "GET")

        _data_structure_map_get(${_subcommand_argv})

    elseif(${_subcommand} STREQUAL "REMOVE")

        _data_structure_map_remove(${_subcommand_argv})

    elseif(${_subcommand} STREQUAL "KEYS")

        _data_structure_map_keys(${_subcommand_argv})

    elseif(${_subcommand} STREQUAL "VALUES")

        _data_structure_map_values(${_subcommand_argv})

    elseif(${_subcommand} STREQUAL "CLEAR")

        _data_structure_map_clear(${_subcommand_argv})

    elseif(${_subcommand} STREQUAL "IS_EMPTY")

        _data_structure_map_is_empty(${_subcommand_argv})

    elseif(${_subcommand} STREQUAL "COUNT")

        _data_structure_map_count(${_subcommand_argv})

    elseif(${_subcommand} STREQUAL "GET_SCOPE")

        _data_structure_map_get_scope(${_subcommand_argv})

    elseif(${_subcommand} STREQUAL "SET_SCOPE")

        _data_structure_map_set_scope(${_subcommand_argv})

    else()

        message(FATAL_ERROR "Invalid subcommand privided.")

    endif()

endmacro()

#
# Subcommand:  INIT
# Description: initialize the map with a key-value pair list
# Usage:       data_structure_map(INIT <map> [<key> <value> [<key> <value> [...]]])
#
function(_DATA_STRUCTURE_MAP_INIT)

    set(usage_message "data_structure_map(INIT <map> [<key> <value> [<key> <value> [...]]])")

    if(${ARGC} LESS 1)
        _data_structure_map_thorw_usage_message(${usage_message})
    endif()

    set(argv "${ARGV}")

    list(GET argv 0 map)

    data_structure_map(CLEAR ${map})

    if(${ARGC} GREATER 1)

        math(EXPR key_value_pairs_module_2 "(${ARGC} - 1) % 2")

        if(NOT key_value_pairs_module_2 EQUAL 0)
            _data_structure_map_thorw_usage_message(${usage_message})
        endif()

        data_structure_map(SET "${argv}")

    endif()

endfunction()

#
# Subcommand:  SET
# Description: set values with a key-value pair list
# Usage:       data_structure_map(SET <map> <key> <value> [<key> <value> [<key> <value> [...]]])
#
function(_DATA_STRUCTURE_MAP_SET)

    set(usage_message "data_structure_map(SET <map> <key> <value> [<key> <value> [<key> <value> [...]]])")

    if(${ARGC} LESS 3)
        _data_structure_map_thorw_usage_message(${usage_message})
    endif()

    set(argv "${ARGV}")

    list(GET argv 0 map)

    # verify that the key-value list contains an even number of items
    math(EXPR key_value_pairs_module_2 "(${ARGC} - 1) % 2")

    if(NOT key_value_pairs_module_2 EQUAL 0)
        _data_structure_map_thorw_usage_message(${usage_message})
    endif()

    _data_structure_map_get_scope(${map} scope)

    # loop the key-value list and add them to the map
    math(EXPR last_index "${ARGC} - 2")

    foreach(key_index RANGE 1 ${last_index} 2)

        math(EXPR value_index "${key_index} + 1")

        list(GET argv ${key_index} key)
        list(GET argv ${value_index} value)

        set_property(${scope} PROPERTY "_data_structure_map_${map}_${key}" ${value})

        data_structure_set(ADD "_data_structure_map_${map}_keys" ${key})

    endforeach()

endfunction()

#
# Subcommand:  GET
# Description: get the value associated with a given key
# Usage:       data_structure_map(GET <map> <key> <output variable>)
#
function(_DATA_STRUCTURE_MAP_GET)

    set(usage_message "data_structure_map(GET <map> <key> <output variable>)")

    if(${ARGC} LESS 3)
        _data_structure_map_thorw_usage_message(${usage_message})
    endif()

    set(argv "${ARGV}")

    list(GET argv 0 map)
    list(GET argv 1 key)
    list(GET argv 2 output)

    # verify that the given key is present in the key set...
    data_structure_set(CONTAINS "_data_structure_map_${map}_keys" ${key} key_is_valid)

    if(key_is_valid)

        # ... return the associated value

        _data_structure_map_get_scope(${map} scope)

        get_property(value ${scope} PROPERTY "_data_structure_map_${map}_${key}")

    else()

        # ... otherwise consited it as FALSE
        set(value FALSE)

    endif()

    set(${output} ${value} PARENT_SCOPE)

endfunction()

#
# Subcommand:  REMOVE
# Description: remove a key from the map
# Usage:       data_structure_map(REMOVE <map> <key>)
#
function(_DATA_STRUCTURE_MAP_REMOVE)

    set(usage_message "data_structure_map(REMOVE <map> <key> [<key> [<key> [...]]])")

    if(${ARGC} LESS 2)
        _data_structure_map_thorw_usage_message(${usage_message})
    endif()

    set(argv "${ARGV}")

    math(EXPR last_index "${ARGC} - 1")

    list(GET argv 0 map)

    foreach(idx RANGE 1 ${last_index})

        list(GET argv ${idx} key)

        data_structure_set(REMOVE "_data_structure_map_${map}_keys" ${key})

    endforeach()

endfunction()

#
# Subcommand:  KEYS
# Description: get the list of keys in the map
# Usage:       data_structure_map(KEYS <map> <output variable>)
#
function(_DATA_STRUCTURE_MAP_KEYS)

    set(usage_message "data_structure_map(KEYS <map> <output variable>)")

    if(${ARGC} LESS 2)
        _data_structure_map_thorw_usage_message(${usage_message})
    endif()

    set(argv "${ARGV}")

    list(GET argv 0 map)
    list(GET argv 1 output)

    data_structure_set(VALUES "_data_structure_map_${map}_keys" keys)

    set(${output} ${keys} PARENT_SCOPE)

endfunction()

#
# Subcommand:  VALUES
# Description: get the list of values in the map
# Usage:       data_structure_map(VALUES <map> <output variable>)
#
function(_DATA_STRUCTURE_MAP_VALUES)

    set(usage_message "data_structure_map(VALUES <map> <output variable>)")

    if(${ARGC} LESS 2)
        _data_structure_map_thorw_usage_message(${usage_message})
    endif()

    set(argv "${ARGV}")

    list(GET argv 0 map)
    list(GET argv 1 output)

    _data_structure_map_get_scope(${map} scope)

    data_structure_set(VALUES "_data_structure_map_${map}_keys" keys)

    foreach(key ${keys})

        get_property(value ${scope} PROPERTY "_data_structure_map_${map}_${key}")

        list(APPEND values ${value})

    endforeach()

    set(${output} ${values} PARENT_SCOPE)

endfunction()

#
# Subcommand:  CLEAR
# Description: remove all the items from the map
# Usage:       data_structure_map(CLEAR <map>)
#
function(_DATA_STRUCTURE_MAP_CLEAR)

    set(usage_message "data_structure_map(CLEAR <map>)")

    if(${ARGC} LESS 1)
        _data_structure_map_thorw_usage_message(${usage_message})
    endif()

    set(argv "${ARGV}")

    list(GET argv 0 map)

    data_structure_set(VALUES "_data_structure_map_${map}_keys" keys)
    data_structure_set(CLEAR "_data_structure_map_${map}_keys")

endfunction()

#
# Subcommand:  IS_EMPTY
# Description: verify if the map is empty
# Usage:       data_structure_map(IS_EMPTY <map> <output variable>)
#
function(_DATA_STRUCTURE_MAP_IS_EMPTY)

    set(usage_message "data_structure_map(IS_EMPTY <map> <output variable>)")

    if(${ARGC} LESS 2)
        _data_structure_map_thorw_usage_message(${usage_message})
    endif()

    set(argv "${ARGV}")

    list(GET argv 0 map)
    list(GET argv 1 output)

    data_structure_set(IS_EMPTY "_data_structure_map_${map}_keys" is_empty)

    set(${output} ${is_empty} PARENT_SCOPE)

endfunction()

# Subcommand:  COUNT
# Description: get the number of items in the map
# Usage:       data_structure_map(COUNT <map> <output variable>)
#
function(_DATA_STRUCTURE_MAP_COUNT)

    set(usage_message "data_structure_map(COUNT <map> <output variable>)")

    if(${ARGC} LESS 2)
        _data_structure_map_thorw_usage_message(${usage_message})
    endif()

    set(argv "${ARGV}")

    list(GET argv 0 map)
    list(GET argv 1 output)

    data_structure_set(COUNT "_data_structure_map_${map}_keys" count)

    set(${output} ${count} PARENT_SCOPE)

endfunction()

#
# Subcommand:  GET_SCOPE
# Description: get the scope of the map
# Usage:       data_structure_map(GET_SCOPE <map> <output variable>)
#
function(_DATA_STRUCTURE_MAP_GET_SCOPE)

    if(${ARGC} LESS 2)
        _data_structure_map_thorw_usage_message("data_structure_map(GET_SCOPE <map> <output variable>)")
    endif()

    set(argv "${ARGV}")

    list(GET argv 0 map)
    list(GET argv 1 output)

    # scopes are stored in global properties named '_data_structure_map_[<map name>]_scope'
    get_property(scope GLOBAL PROPERTY "_data_structure_map_{map}_scope")

    # since only DIRECTORY and GLOBAL are valid scopes,
    # if the variable isn't set yet,
    # is assumed that the map is DIRECTORY scoped
    if(NOT scope STREQUAL "GLOBAL")
        set(scope "DIRECTORY")
    endif()

    set(${output} ${scope} PARENT_SCOPE)

endfunction()

#
# Subcommand:  SET_SCOPE
# Description: make the map DIRECTORY or GLOBAL scoped
# Usage:       data_structure_map(SET_SCOPE <set> <DIRECTORY | GLOBAL>)
#
function(_DATA_STRUCTURE_MAP_SET_SCOPE)

    set(usage_message "data_structure_map(SET_SCOPE <set> <DIRECTORY | GLOBAL>)")

    if(${ARGC} LESS 2)
        _data_structure_map_thorw_usage_message("${usage_message}")
    endif()

    set(argv "${ARGV}")

    list(GET argv 0 map)
    list(GET argv 1 scope)

    set(valid_scopes
        DIRECTORY
        GLOBAL)

    # verify if the scope is a vaild one
    list(FIND valid_scopes ${scope} is_valid_scope)

    if(is_valid_scope EQUAL -1)
        _data_structure_map_thorw_usage_message("${usage_message}")
    endif()

    # if the scope is already set to the one requested, exit
    data_structure_set(GET_SCOPE ${map} current_scope)

    if(current_scope STREQUAL scope)
        return()
    endif()

    data_structure_set(VALUES "_data_structure_map_${map}_keys" keys)

    data_structure_set(SET_SCOPE "_data_structure_map_${map}_keys" ${scope})

    foreach(key ${keys})

        get_property(value ${current_scope} PROPERTY "_data_structure_map_${map}_${key}")

        # remove the value from the current scope ...
        set_property(${current_scope} PROPERTY "_data_structure_map_${map}_${key}")

        # ... and set it in the new one
        set_property(${scope} PROPERTY "_data_structure_map_${map}_${key}" ${value})

    endforeach()

    set_property(GLOBAL PROPERTY "_data_structure_map_{map}_scope" ${scope})

endfunction()

#
# Throw a bad command usage error
#
function(_DATA_STRUCTURE_MAP_THORW_USAGE_MESSAGE usage)

    message(FATAL_ERROR "Usage: ${usage}")

endfunction()

#
# Some unit-test-ish
#
function(_DATA_STRUCTURE_MAP_TESTS)

    include(Assert)

    _data_structure_map_test_init()
    _data_structure_map_test_set_get()
    _data_structure_map_test_remove()
    _data_structure_map_test_keys()
    _data_structure_map_test_values()
    _data_structure_map_test_clear()
    _data_structure_map_test_is_empty()
    _data_structure_map_test_count()
    _data_structure_map_test_get_scope()
    _data_structure_map_test_set_scope()

endfunction()

function(_DATA_STRUCTURE_MAP_TEST_INIT)

    data_structure_map(INIT mymap k1 v1 k2 v2)
    data_structure_map(INIT mymap k3 v3 k4 v4)

    data_structure_map(GET mymap k3 value_k3)
    data_structure_map(GET mymap k4 value_k4)

    assert_str_equal(value_k3 v3)
    assert_str_equal(value_k4 v4)

endfunction()

function(_DATA_STRUCTURE_MAP_TEST_SET_GET)

    data_structure_map(SET mymap k1 v1 k2 v2)
    data_structure_map(GET mymap k1 value_k1)
    data_structure_map(GET mymap k2 value_k2)

    assert_str_equal(value_k1 v1)
    assert_str_equal(value_k2 v2)

endfunction()

function(_DATA_STRUCTURE_MAP_TEST_REMOVE)

    data_structure_map(INIT mymap k1 v1 k2 v2 k3 v3 k4 v4)
    data_structure_map(REMOVE mymap k1 k4)

    data_structure_map(GET mymap k1 value_k1)
    data_structure_map(GET mymap k2 value_k2)
    data_structure_map(GET mymap k3 value_k3)
    data_structure_map(GET mymap k4 value_k4)

    assert_false(value_k1)
    assert_str_equal(value_k2 v2)
    assert_str_equal(value_k3 v3)
    assert_false(value_k4)

endfunction()

function(_DATA_STRUCTURE_MAP_TEST_KEYS)

    data_structure_map(INIT mymap k1 v1 k2 v2)
    data_structure_map(KEYS mymap keys)

    assert_list_equivalent(keys k1 k2)

endfunction()

function(_DATA_STRUCTURE_MAP_TEST_VALUES)

    data_structure_map(INIT mymap k1 v1 k2 v2 k3 v3 k4 v4)
    data_structure_map(VALUES mymap values)

    assert_list_equivalent(values v1 v2 v3 v4)

endfunction()

function(_DATA_STRUCTURE_MAP_TEST_CLEAR)

    data_structure_map(SET mymap k1 v1 k2 v2)
    data_structure_map(CLEAR mymap)

endfunction()

function(_DATA_STRUCTURE_MAP_TEST_IS_EMPTY)

    data_structure_map(INIT mymap)
    data_structure_map(IS_EMPTY mymap is_empty)

    assert_true(is_empty)

endfunction()

function(_DATA_STRUCTURE_MAP_TEST_COUNT)

    data_structure_map(INIT mymap k1 v1 k2 v2 k3 v3 k4 v4)
    data_structure_map(COUNT mymap count)

    assert_equal(count 4)

endfunction()

function(_DATA_STRUCTURE_MAP_TEST_GET_SCOPE)

    data_structure_map(INIT mymap k1 v1)
    data_structure_map(GET_SCOPE mymap scope)

    assert_str_equal(scope "DIRECTORY")

endfunction()

function(_DATA_STRUCTURE_MAP_TEST_SET_SCOPE)

    data_structure_map(INIT mymap k1 v1 k2 v2 k3 v3 k4 v4)
    data_structure_map(SET_SCOPE mymap "GLOBAL")
    data_structure_map(GET_SCOPE mymap scope)
    data_structure_map(VALUES mymap values)

    assert_str_equal(scope "GLOBAL")
    assert_list_equivalent(values v1 v2 v3 v4)

endfunction()

### END ###
