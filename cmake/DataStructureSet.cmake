##
##  DataStructureSet.cmake
##  Revision: 8 (05 jan 2015)
##
##  Implementation of the set data structure.
##
##  Repo: git:steazzalini/cmake-modules
##  Deps:
##   - Assert (optional) git:steazzalini/cmake-modules
##
##  Operations supported:
##
##   - INIT         initialize the set with a list of itmes
##   - ADD          add one or more items to the set
##   - REMOVE       remove one or more items from the set
##   - VALUES       get the list of items in the set
##   - CONTAINS     verify if the set contains an item
##   - CLEAR        remove all the items
##   - IS_EMPTY     verify if the set is empty
##   - COUNT        get the number of items in the set
##   - GET_SCOPE    get the scope of the set
##   - SET_SCOPE    make the set DIRECTORY or GLOBAL scoped
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

#
# Main command
#
macro(DATA_STRUCTURE_SET _subcommand)

    # grab the args to pass to the subcommand
    set(_subcommand_argv "${ARGN}")

    # switch `subcommand' and invoke it
    if(${_subcommand} STREQUAL "INIT")

        _data_structure_set_init(${_subcommand_argv})

    elseif(${_subcommand} STREQUAL "ADD")

        _data_structure_set_add(${_subcommand_argv})

    elseif(${_subcommand} STREQUAL "VALUES")

        _data_structure_set_values(${_subcommand_argv})

    elseif(${_subcommand} STREQUAL "CONTAINS")

        _data_structure_set_contains(${_subcommand_argv})

    elseif(${_subcommand} STREQUAL "REMOVE")

        _data_structure_set_remove(${_subcommand_argv})

    elseif(${_subcommand} STREQUAL "CLEAR")

        _data_structure_set_clear(${_subcommand_argv})

    elseif(${_subcommand} STREQUAL "IS_EMPTY")

        _data_structure_set_is_empty(${_subcommand_argv})

    elseif(${_subcommand} STREQUAL "COUNT")

        _data_structure_set_count(${_subcommand_argv})

    elseif(${_subcommand} STREQUAL "GET_SCOPE")

        _data_structure_set_get_scope(${_subcommand_argv})

    elseif(${_subcommand} STREQUAL "SET_SCOPE")

        _data_structure_set_set_scope(${_subcommand_argv})

    else()

        message(FATAL_ERROR "Invalid subcommand privided.")

    endif()

endmacro()

#
# Subcommand:  INIT
# Description: initialize the set with a list of itmes
# Usage:       data_structure_set(INIT <set> [<item> [<item> [...]]])
#
function(_DATA_STRUCTURE_SET_INIT)

    set(usage_message "data_structure_set(INIT <set> [<item> [<item> [...]]])")

    if(${ARGC} LESS 1)
        _data_structure_set_thorw_usage_message(${usage_message})
    endif()

    set(argv "${ARGV}")

    list(GET argv 0 set_name)

    # get the list of items to put in the set
    # removing the first value from a copy of `argv'
    set(values_to_set ${argv})
    list(REMOVE_AT values_to_set 0)

    # to (re)inizialize the set first clean it...
    data_structure_set(CLEAR ${set_name})

    # ... and then, if at least one item is provided...
    list(LENGTH values_to_set count_items_to_set)

    if(count_items_to_set GREATER 0)

        # ... add them to the set
        data_structure_set(ADD ${set_name} ${values_to_set})

    endif()

endfunction()

#
# Subcommand:  ADD
# Description: add one or more items to the set
# Usage:       data_structure_set(ADD <set> <item> [<item> [...]])
#
function(_DATA_STRUCTURE_SET_ADD)

    set(usage_message "data_structure_set(ADD <set> <item> [<item> [...]])")

    if(${ARGC} LESS 2)
        _data_structure_set_thorw_usage_message(${usage_message})
    endif()

    set(argv "${ARGV}")

    list(GET argv 0 set_name)

    _data_structure_set_export(${set_name} data_structure_set)

    # loop through all the items...

    math(EXPR last_index "${ARGC} - 1")

    foreach(idx RANGE 1 ${last_index})

        # and if not already present in the set...
        list(GET argv ${idx} value)

        list(FIND data_structure_set ${value} already_present)

        if(already_present EQUAL -1)

            # ... put it in
            list(APPEND data_structure_set ${value})

        endif()

    endforeach()

    _data_structure_set_save(${set_name} "${data_structure_set}")

endfunction()

#
# Subcommand:  REMOVE
# Description: remove one or more items from the set
# Usage:       data_structure_set(REMOVE <set> <item> [<item> [...]])
#
function(_DATA_STRUCTURE_SET_REMOVE)

    set(usage_message "data_structure_set(REMOVE <set> <item> [<item> [...]])")

    if(${ARGC} LESS 2)
        _data_structure_set_thorw_usage_message(${usage_message})
    endif()

    set(argv "${ARGV}")

    list(GET argv 0 set_name)

    # get the list of values to remove removing
    # the first element from a copy of `argv'

    set(values_to_remove ${argv})

    list(REMOVE_AT values_to_remove 0)

    _data_structure_set_export(${set_name} data_structure_set)

    list(REMOVE_ITEM data_structure_set ${values_to_remove})

    _data_structure_set_save(${set_name} "${data_structure_set}")

endfunction()

#
# Subcommand:  VALUES
# Description: get the list of items in the set
# Usage:       data_structure_set(VALUES <set> <output variable>)
#
function(_DATA_STRUCTURE_SET_VALUES)

    set(usage_message "data_structure_set(VALUES <set> <output variable>)")

    if(${ARGC} LESS 2)
        _data_structure_set_thorw_usage_message(${usage_message})
    endif()

    set(argv "${ARGV}")

    list(GET argv 0 set_name)
    list(GET argv 1 output)

    _data_structure_set_export(${set_name} data_structure_set)

    set(${output} ${data_structure_set} PARENT_SCOPE)

endfunction()

#
# Subcommand:  CONTAINS
# Description: verify if the set contains an item
# Usage:       data_structure_set(CONTAINS <set> <item> <output variable>)
#
function(_DATA_STRUCTURE_SET_CONTAINS)

    set(usage_message "data_structure_set(CONTAINS <set> <item> <output variable>)")

    if(${ARGC} LESS 3)
        _data_structure_set_thorw_usage_message(${usage_message})
    endif()

    set(argv "${ARGV}")

    list(GET argv 0 set_name)
    list(GET argv 1 item)
    list(GET argv 2 output)

    _data_structure_set_export(${set_name} data_structure_set)

    list(FIND data_structure_set ${item} found)

    if(found EQUAL -1)

        set(${output} FALSE PARENT_SCOPE)

    else()

        set(${output} TRUE PARENT_SCOPE)

    endif()

endfunction()

#
# Subcommand:  CLEAR
# Description: remove all the items
# Usage:       data_structure_set(CLEAR <set>)
#
function(_DATA_STRUCTURE_SET_CLEAR)

    set(usage_message "data_structure_set(CLEAR <set>)")

    if(${ARGC} LESS 1)
        _data_structure_set_thorw_usage_message(${usage_message})
    endif()

    set(argv "${ARGV}")

    list(GET argv 0 set_name)

    # save the set as an empty list
    _data_structure_set_save(${set_name} "")

endfunction()

#
# Subcommand:  IS_EMPTY
# Description: verify if the set is empty
# Usage:       data_structure_set(IS_EMPTY <set> <output variable>)
#
function(_DATA_STRUCTURE_SET_IS_EMPTY)

    set(usage_message "data_structure_set(IS_EMPTY <set> <output variable>)")

    if(${ARGC} LESS 2)
        _data_structure_set_thorw_usage_message(${usage_message})
    endif()

    set(argv "${ARGV}")

    list(GET argv 0 set_name)
    list(GET argv 1 output)

    _data_structure_set_export(${set_name} data_structure_set)

    # the set is empty if it's list rappresentation has zero-length

    list(LENGTH data_structure_set length)

    if(length EQUAL 0)
        set(${output} TRUE PARENT_SCOPE)
    else()
        set(${output} FALSE PARENT_SCOPE)
    endif()

endfunction()

#
# Subcommand:  COUNT
# Description: get the number of items in the set
# Usage:       data_structure_set(COUNT <set> <output variable>)
#
function(_DATA_STRUCTURE_SET_COUNT)

    set(usage_message "data_structure_set(COUNT <set> <output variable>)")

    if(${ARGC} LESS 2)
        _data_structure_set_thorw_usage_message(${usage_message})
    endif()

    set(argv "${ARGV}")

    list(GET argv 0 set_name)
    list(GET argv 1 output)

    _data_structure_set_export(${set_name} data_structure_set)

    list(LENGTH data_structure_set length)

    set(${output} ${length} PARENT_SCOPE)

endfunction()

#
# Subcommand:  GET_SCOPE
# Description: get the scope of the set
# Usage:       data_structure_set(GET_SCOPE <set> <output variable>)
#
function(_DATA_STRUCTURE_SET_GET_SCOPE)

    set(usage_message "data_structure_set(GET_SCOPE <set> <output variable>)")

    if(${ARGC} LESS 2)
        _data_structure_set_thorw_usage_message(${usage_message})
    endif()

    set(argv "${ARGV}")

    list(GET argv 0 set_name)
    list(GET argv 1 output)

    # scopes are stored in global properties named '_data_structure_set_scope_[set]'
    get_property(scope GLOBAL PROPERTY "_data_structure_set_scope_${set_name}")

    # since only DIRECTORY and GLOBAL are valid scopes,
    # if the variable isn't set yet,
    # is assumed that the set is DIRECTORY scoped
    if(NOT scope STREQUAL "GLOBAL")
        set(scope "DIRECTORY")
    endif()

    set(${output} ${scope} PARENT_SCOPE)

endfunction()

#
# Subcommand:  SET_SCOPE
# Description: make the set DIRECTORY or GLOBAL scoped
# Usage:       data_structure_set(SET_SCOPE <set> <DIRECTORY | GLOBAL>)
#
function(_DATA_STRUCTURE_SET_SET_SCOPE)

    set(usage_message "data_structure_set(SET_SCOPE <set> <DIRECTORY | GLOBAL>)")

    if(${ARGC} LESS 2)
        _data_structure_set_thorw_usage_message(${usage_message})
    endif()

    set(argv "${ARGV}")

    list(GET argv 0 set_name)
    list(GET argv 1 scope)

    set(valid_scopes
        DIRECTORY
        GLOBAL)

    # verify if the scope is a vaild one
    list(FIND valid_scopes ${scope} is_valid_scope)

    if(is_valid_scope EQUAL -1)
        message(FATAL_ERROR "Invalid <scope>. Use ${valid_scopes}")
    endif()

    # if the scope is already set to the one requested, exit
    data_structure_set(GET_SCOPE ${set_name} current_scope)

    if(current_scope STREQUAL scope)
        return()
    endif()

    _data_structure_set_export(${set_name} data_structure_set)

    # in base of the scope requested,
    # move the list rappresentation of the set
    # from GLOBAL to DIRECTORY scoped, or viceversa
    if(scope STREQUAL "GLOBAL")

        set_property(DIRECTORY PROPERTY "_data_structure_set_${set_name}")
        set_property(GLOBAL PROPERTY "_data_structure_set_${set_name}" ${data_structure_set})

    else()

        set_property(GLOBAL PROPERTY "_data_structure_set_${set_name}")
        set_property(DIRECTORY PROPERTY "_data_structure_set_${set_name}" ${data_structure_set})

    endif()

    set_property(GLOBAL PROPERTY "_data_structure_set_scope_${set_name}" ${scope})

endfunction()

#
# Set `output' with the list-rappresentation
# of the set named `set_name`.
#
function(_DATA_STRUCTURE_SET_EXPORT set_name output)

    data_structure_set(GET_SCOPE ${set_name} scope)

    if(scope STREQUAL "GLOBAL")
        get_property(data_structure_set GLOBAL PROPERTY "_data_structure_set_${set_name}")
    else()
        get_property(data_structure_set DIRECTORY PROPERTY "_data_structure_set_${set_name}")
    endif()

    set(${output} ${data_structure_set} PARENT_SCOPE)

endfunction()

#
# Taking a list of values as string (`items')
# store it as a set named `set_name'
#
function(_DATA_STRUCTURE_SET_SAVE set_name items)

    data_structure_set(GET_SCOPE ${set_name} scope)

    if(scope STREQUAL "GLOBAL")
        set_property(GLOBAL PROPERTY "_data_structure_set_${set_name}" ${items})
    else()
        set_property(DIRECTORY PROPERTY "_data_structure_set_${set_name}" ${items})
    endif()

endfunction()

#
# Throw a bad command usage error
#
function(_DATA_STRUCTURE_SET_THORW_USAGE_MESSAGE usage)

    message(FATAL_ERROR "Usage: ${usage}")

endfunction()

#
# Some unit-test-ish
#
function(_DATA_STRUCTURE_SET_TESTS)

    include(Assert)

    _data_structure_set_test_init()
    _data_structure_set_test_add()
    _data_structure_set_test_remove()
    _data_structure_set_test_clear()
    _data_structure_set_test_is_empty()
    _data_structure_set_test_count()
    _data_structure_set_test_contains()
    _data_structure_set_test_get_scope()
    _data_structure_set_test_set_scope()

endfunction()

function(_DATA_STRUCTURE_SET_TEST_INIT)

    data_structure_set(INIT myset a a b b c c)
    data_structure_set(VALUES myset values)

    assert_list_equivalent(values a b c)

endfunction()

function(_DATA_STRUCTURE_SET_TEST_ADD)

    data_structure_set(INIT myset a b c)
    data_structure_set(ADD myset d e f)
    data_structure_set(VALUES myset values)

    assert_list_equivalent(values a b c d e f)

endfunction()

function(_DATA_STRUCTURE_SET_TEST_REMOVE)

    data_structure_set(INIT myset a b c d e f g)
    data_structure_set(REMOVE myset b g)
    data_structure_set(VALUES myset values)

    assert_list_equivalent(values a c d e f)

endfunction()

function(_DATA_STRUCTURE_SET_TEST_CLEAR)

    data_structure_set(INIT myset a b c)
    data_structure_set(CLEAR myset)
    data_structure_set(VALUES myset values)

    assert_list_empty(values)

endfunction()

function(_DATA_STRUCTURE_SET_TEST_IS_EMPTY)

    data_structure_set(INIT myset)
    data_structure_set(VALUES myset values)

    assert_list_empty(values)

endfunction()

function(_DATA_STRUCTURE_SET_TEST_COUNT)

    data_structure_set(INIT myset a b c)
    data_structure_set(COUNT myset count)

    assert_equal(count 3)

endfunction()

function(_DATA_STRUCTURE_SET_TEST_CONTAINS)

    data_structure_set(INIT myset a b c)
    data_structure_set(CONTAINS myset b check_b)
    data_structure_set(CONTAINS myset x check_x)

    assert_true(check_b)
    assert_false(check_x)

endfunction()

function(_DATA_STRUCTURE_SET_TEST_GET_SCOPE)

    data_structure_set(INIT myset)
    data_structure_set(GET_SCOPE myset scope)

    assert_str_equal(scope "DIRECTORY")

endfunction()

function(_DATA_STRUCTURE_SET_TEST_SET_SCOPE)

    data_structure_set(INIT myset)
    data_structure_set(SET_SCOPE myset "GLOBAL")
    data_structure_set(GET_SCOPE myset scope)

    assert_str_equal(scope "GLOBAL")

endfunction()

## END ##
