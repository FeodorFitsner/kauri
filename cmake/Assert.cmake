##
##  Assert.cmake
##  Revision: 5 (05 jan 2015)
##
##  Some ASSERT_* macros.
##
##  Repo: https://github.com/steazzalini/cmake-modules
##
##  Features supported:
##
##   - ASSERT_UNDEFINED             assert that a variable is undefined
##   - ASSERT_DEFINED               assert that a variable is defined
##   - ASSERT_TRUE                  assert that a variable is evaluated as TRUE
##   - ASSERT_FALSE                 assert that a variable is evaluated as FALSE
##   - ASSERT_NUMBER                assert that a variable is a number
##   - ASSERT_LESS                  assert that a variable is a number and it's less than another
##   - ASSERT_LESS_OR_EQUAL         assert that a variable is a number and it's less or equal to another
##   - ASSERT_EQUAL                 assert that a variable is a number and it's equal to another
##   - ASSERT_NOT_EQUAL             assert that a variable is a number and it isn't equal to another
##   - ASSERT_GREATER               assert that a variable is a number and it's greater than another
##   - ASSERT_GREATER_OR_EQUAL      assert that a variable is a number and it's greater or equal to another
##   - ASSERT_NEGATIVE              assert that a variable is a number and it's negative
##   - ASSERT_POSITIVE              assert that a variable is a number and it's positive
##   - ASSERT_STR_LESS              assert that a variable is lexicographically less than another
##   - ASSERT_STR_LESS_OR_EQUAL     assert that a variable is lexicographically less or equal to another
##   - ASSERT_STR_EQUAL             assert that a variable is lexicographically equal to another
##   - ASSERT_STR_NOT_EQUAL         assert that a variable is lexicographically not equal to another
##   - ASSERT_STR_GREATER           assert that a variable is lexicographically greater than another
##   - ASSERT_STR_GREATER_OR_EQUAL  assert that a variable is lexicographically greater or equal to another
##   - ASSERT_MATCHES               assert that a variable matches a given regular expression
##   - ASSERT_LIST_EQUAL            assert that a list is equal to another
##   - ASSERT_LIST_NOT_EQUAL        assert that a list is not equal to another
##   - ASSERT_LIST_EQUIVALENT       assert that a list is equivalent to another
##   - ASSERT_LIST_EMPTY            assert that a list is empty
##   - ASSERT_LIST_NOT_EMPTY        assert that a list is not empty
##   - ASSERT_LIST_HAS_LENGTH       assert that a list has an expected length
##   - ASSERT_LIST_CONTAINS         assert that a list contains a list of values
##   - ASSERT_LIST_NOT_CONTAINS     assert that a list doesn't contain a list of values
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
# Command:     ASSERT_UNDEFINED
# Description: assert that a variable is undefined
# Usage:       assert_undefined(<variable>)
#
macro(ASSERT_UNDEFINED _variable)

    if(DEFINED ${_variable})
        _assert_throw_failed_test("Variable `${_variable}' expected to be undefined.")
    endif()

endmacro()

#
# Command:     ASSERT_DEFINED
# Description: assert that a variable is defined
# Usage:       assert_defined(<variable>)
#
macro(ASSERT_DEFINED _variable)

    if(NOT DEFINED ${_variable})
        _assert_throw_failed_test("Variable `${_variable}' expected to be defined.")
    endif()

endmacro()

#
# Command:     ASSERT_TRUE
# Description: assert that a variable is evaluated as TRUE
# Usage:       assert_true(<variable>)
#
macro(ASSERT_TRUE _variable)

    if(NOT ${_variable})
        _assert_throw_failed_test("Variable `${_variable}' expected to be TRUE.")
    endif()

endmacro()

#
# Command:     ASSERT_FALSE
# Description: assert that a variable is evaluated as FALSE
# Usage:       assert_false(<variable>)
#
macro(ASSERT_FALSE _variable)

    if(${_variable})
        _assert_throw_failed_test("Variable `${_variable}' expected to be FALSE.")
    endif()

endmacro()

#
# Command:     ASSERT_NUMBER
# Description: assert that a variable is a number
# Usage:       assert_number(<variable>)
#
macro(ASSERT_NUMBER _variable)

    if(NOT ${_variable} MATCHES "^[+|-]?[0-9]+$")
        _assert_throw_failed_test("Variable `${_variable}' expected to be a number.")
    endif()

endmacro()

#
# Command:     ASSERT_LESS
# Description: assert that a variable is a number and it's less than another
# Usage:       assert_less(<variable> <comparator>)
#
macro(ASSERT_LESS _variable _comparator)

    assert_number(${_variable})
    assert_number(${_comparator})

    if(NOT ${_variable} LESS ${_comparator})
        _assert_throw_failed_test("Variable `${_variable}' expected to be less than ${_comparator}.")
    endif()

endmacro()

#
# Command:     ASSERT_LESS_OR_EQUAL
# Description: assert that a variable is a number and it's less or equal to another
# Usage:       assert_less_or_equal(<variable> <comparator>)
#
macro(ASSERT_LESS_OR_EQUAL _variable _comparator)

    assert_number(${_variable})
    assert_number(${_comparator})

    if(${_variable} GREATER ${_comparator})
        _assert_throw_failed_test("Variable `${_variable}' expected to be less or equal than ${_comparator}.")
    endif()

endmacro()

#
# Command:     ASSERT_EQUAL
# Description: assert that a variable is a number and it's equal to another
# Usage:       assert_equal(<variable> <comparator>)
#
macro(ASSERT_EQUAL _variable _comparator)

    assert_number(${_variable})
    assert_number(${_comparator})

    if(NOT ${_variable} EQUAL ${_comparator})
        _assert_throw_failed_test("Variable `${_variable}' expected to be equal to ${_comparator}.")
    endif()

endmacro()

#
# Command:     ASSERT_NOT_EQUAL
# Description: assert that a variable is a number and it isn't equal to another
# Usage:       assert_not_equal(<variable> <comparator>)
#
macro(ASSERT_NOT_EQUAL _variable _comparator)

    assert_number(${_variable})
    assert_number(${_comparator})

    if(${_variable} EQUAL ${_comparator})
        _assert_throw_failed_test("Variable `${_variable}' expected to be not equal to ${_comparator}.")
    endif()

endmacro()

#
# Command:     ASSERT_GREATER
# Description: assert that a variable is a number and it's greater than another
# Usage:       assert_greater(<variable> <comparator>)
#
macro(ASSERT_GREATER _variable _comparator)

    assert_number(${_variable})
    assert_number(${_comparator})

    if(NOT ${_variable} GREATER ${_comparator})
        _assert_throw_failed_test("Variable `${_variable}' expected to be greater to ${_comparator}.")
    endif()

endmacro()

#
# Command:     ASSERT_GREATER_OR_EQUAL
# Description: assert that a variable is a number and it's greater or equal to another
# Usage:       assert_greater_or_equal(<variable> <comparator>)
#
macro(ASSERT_GREATER_OR_EQUAL _variable _comparator)

    assert_number(${_variable})
    assert_number(${_comparator})

    if(${_variable} LESS ${_comparator})
        _assert_throw_failed_test("Variable `${_variable}' expected to be greater or equal to ${_comparator}.")
    endif()

endmacro()

#
# Command:     ASSERT_NEGATIVE
# Description: assert that a variable is a number and it's negative
# Usage:       assert_negative(<variable>)
#
macro(ASSERT_NEGATIVE _variable)

    assert_number(${_variable})

    if(NOT ${_variable} LESS 0)
        _assert_throw_failed_test("Variable `${_variable}' expected to be negative.")
    endif()

endmacro()

#
# Command:     ASSERT_POSITIVE
# Description: assert that a variable is a number and it's positive
# Usage:       assert_positive(<variable>)
#
macro(ASSERT_POSITIVE _variable)

    assert_number(${_variable})

    if(${_variable} LESS 0)
        _assert_throw_failed_test("Variable `${_variable}' expected to be positive.")
    endif()

endmacro()

#
# Command:     ASSERT_STR_LESS
# Description: assert that a variable is lexicographically less than another
# Usage:       assert_str_less(<variable>)
#
macro(ASSERT_STR_LESS _variable _comparator)

    if(NOT ${_variable} STRLESS ${_comparator})
        _assert_throw_failed_test("Variable `${_variable}' expected to be less than '${_comparator}'.")
    endif()

endmacro()

#
# Command:     ASSERT_STR_LESS_OR_EQUAL
# Description: assert that a variable is lexicographically less or equal to another
# Usage:       assert_str_less_or_equal(<variable> <comparator>)
#
macro(ASSERT_STR_LESS_OR_EQUAL _variable _comparator)

    if(${_variable} STRGREATER ${_comparator})
        _assert_throw_failed_test("Variable `${_variable}' expected to be less or equal to '${_comparator}'.")
    endif()

endmacro()

#
# Command:     ASSERT_STR_EQUAL
# Description: assert that a variable is lexicographically equal to another
# Usage:       assert_str_equal(<variable> <comparator>)
#
macro(ASSERT_STR_EQUAL _variable _comparator)

    if(NOT ${_variable} STREQUAL ${_comparator})
        _assert_throw_failed_test("Variable `${_variable}' expected to be equal to '${_comparator}'.")
    endif()

endmacro()

#
# Command:     ASSERT_STR_NOT_EQUAL
# Description: assert that a variable is lexicographically not equal to another
# Usage:       assert_str_not_equal(<variable> <comparator>)
#
macro(ASSERT_STR_NOT_EQUAL _variable _comparator)

    if(${_variable} STREQUAL ${_comparator})
        _assert_throw_failed_test("Variable `${_variable}' expected to be not equal to '${_comparator}'.")
    endif()

endmacro()

#
# Command:     ASSERT_STR_GREATER
# Description: assert that a variable is lexicographically greater than another
# Usage:       assert_str_greater(<variable> <comparator>)
#
macro(ASSERT_STR_GREATER _variable comparator)

    if(NOT ${_variable} STRGREATER ${comparator})
        _assert_throw_failed_test("Variable `${_variable}' expected to be greater than '${comparator}'.")
    endif()

endmacro()

#
# Command:     ASSERT_STR_GREATER_OR_EQUAL
# Description: assert that a variable is lexicographically greater or equal to another
# Usage:       assert_str_greater_or_equal(<variable> <comparator>)
#
macro(ASSERT_STR_GREATER_OR_EQUAL _variable _comparator)

    if(${_variable} STRLESS ${_comparator})
        _assert_throw_failed_test("Variable `${_variable}' expected to be greater or equal to '${_comparator}'.")
    endif()

endmacro()

#
# Command:     ASSERT_MATCHES
# Description: assert that a variable matches a given regular expression.
# Usage:       assert_matches(<variable> <regex>)
#
macro(ASSERT_MATCHES _variable _regex)

    if(NOT ${_variable} MATCHES ${regex})
        _assert_throw_failed_test("Variable `${_variable}' expected to match '/${regex}/'.")
    endif()

endmacro()

#
# Command:     ASSERT_LIST_EQUAL
# Description: assert that a list is equal to another
# Usage:       assert_list_equal(<variable> [<expected value> [<expected value> [...]]])
#
macro(ASSERT_LIST_EQUAL _variable)

    set(_actual_list ${${_variable}})
    set(_expected_list "${ARGN}")
    set(_message "List `${_variable}' expected equal to '${_expected_list}'")

    list(LENGTH _actual_list _actual_list_length)
    list(LENGTH _expected_list _expected_list_length)

    if(NOT _actual_list_length EQUAL _expected_list_length)
        _assert_throw_failed_test("${_message}")
    endif()

    if(_actual_list_length EQUAL 0)
        return()
    endif()

    math(EXPR _last_index "${_actual_list_length} - 1")

    foreach(_idx RANGE 0 ${_last_index})

        list(GET _actual_list ${_idx} _a)
        list(GET _expected_list ${_idx} _b)

        if(NOT _a STREQUAL _b)
            _assert_throw_failed_test("${_message}")
        endif()

    endforeach()

endmacro()

#
# Command:     ASSERT_LIST_NOT_EQUAL
# Description: assert that a list is not equal to another
# Usage:       assert_list_not_equal(<variable> [<expected value> [<expected value> [...]]])
#
macro(ASSERT_LIST_NOT_EQUAL _variable)

    set(_actual_list ${${_variable}})
    set(_expected_list "${ARGN}")
    set(_message "List `${_variable}' expected not equal to '${_expected_list}'")

    list(LENGTH _actual_list _actual_list_length)
    list(LENGTH _expected_list _expected_list_length)

    if(NOT _actual_list_length EQUAL _expected_list_length)
        return()
    endif()

    if((_actual_list_length EQUAL 0) AND (_expected_list_length EQUAL 0))
        _assert_throw_failed_test("${_message}")
    endif()

    math(EXPR _last_index "${_actual_list_length} - 1")

    foreach(_idx RANGE 0 ${_last_index})

        list(GET _actual_list ${_idx} _a)
        list(GET _expected_list ${_idx} _b)

        if(_a STREQUAL _b)
            _assert_throw_failed_test("${_message}")
        endif()

    endforeach()

endmacro()

#
# Command:     ASSERT_LIST_EQUIVALENT
# Description: assert that a list is equivalent to another
# Usage:       assert_list_equivalent(<list> [<expected value> [<expected value> [...]]])
#
macro(ASSERT_LIST_EQUIVALENT _variable)

    set(_actual_list ${${_variable}})
    set(_expected_list "${ARGN}")
    set(_message "List `${_variable}' expected equivalent to '${_expected_list}'")

    list(LENGTH _actual_list _actual_list_length)
    list(LENGTH _expected_list _expected_list_length)

    if(NOT _actual_list_length EQUAL _expected_list_length)
        _assert_throw_failed_test("${_message}")
    endif()

    if(_actual_list_length EQUAL 0)
        return()
    endif()

    math(EXPR _last_index "${_actual_list_length} - 1")

    foreach(_idx RANGE 0 ${_last_index})

        list(GET _expected_list ${_idx} _value)
        list(FIND _actual_list ${_value} _index_to_remove)

        if(_index_to_remove EQUAL -1)
            _assert_throw_failed_test("${_message}")
        endif()

        list(REMOVE_AT _actual_list ${_index_to_remove})

    endforeach()

endmacro()

#
# Command:     ASSERT_LIST_EMPTY
# Description: assert that a list is empty
# Usage:       assert_list_empty(<list>)
#
macro(ASSERT_LIST_EMPTY _variable)

    set(_list ${${_variable}})

    list(LENGTH _list _list_length)

    if(NOT _list_length EQUAL 0)
        _assert_throw_failed_test("List `${_variable}' expected to be empty.")
    endif()

endmacro()

#
# Command:     ASSERT_LIST_NOT_EMPTY
# Description: assert that a list is not empty
# Usage:       assert_list_not_empty(<list>)
#
macro(ASSERT_LIST_NOT_EMPTY _variable)

    set(_list ${${_variable}})

    list(LENGTH _list _list_length)

    if(_list_length EQUAL 0)
        _assert_throw_failed_test("List `${_variable}' expected to not be empty.")
    endif()

endmacro()

#
# Command:     ASSERT_LIST_HAS_LENGTH
# Description: assert that a list has an expected length
# Usage:       assert_list_has_length(<list> <length expected>)
#
macro(ASSERT_LIST_HAS_LENGTH _variable _length_expected)

    set(_list ${${_variable}})

    list(LENGTH _list _list_length)

    if(NOT _list_length EQUAL ${_length_expected})
        _assert_throw_failed_test("List `${_variable}' expected to have ${_length_expected} items.")
    endif()

endmacro()

#
# Command:     ASSERT_LIST_CONTAINS
# Description: assert that a list contains a list of values
# Usage:       assert_list_contains(<list> <value> [<value> [<value> [...]]])
#
macro(ASSERT_LIST_CONTAINS _variable _first_value)

    set(_actual_list ${${_variable}})

    set(_values_to_find "${ARGN}")
    list(INSERT _values_to_find 0 ${_first_value})
    list(REMOVE_DUPLICATES _values_to_find)

    set(_message "List `${_variable}' expected to contain '${_values_to_find}'")

    list(LENGTH _actual_list _actual_list_length)
    list(LENGTH _values_to_find _values_to_find_length)

    if(_values_to_find_length GREATER ${_actual_list_length})
        _assert_throw_failed_test("${_message}")
    endif()

    math(EXPR _last_index "${_values_to_find_length} - 1")

    foreach(_idx RANGE 0 ${_last_index})

        list(GET _values_to_find ${_idx} _value)
        list(FIND _actual_list ${_value} _index_to_remove)

        if(_index_to_remove EQUAL -1)
            _assert_throw_failed_test("${_message}")
        endif()

    endforeach()

endmacro()

#
# Command:     ASSERT_LIST_NOT_CONTAINS
# Description: assert that a list doesn't contain a list of values
# Usage:       assert_list_not_contains(<list> <value> [<value> [<value> [...]]])
#
macro(ASSERT_LIST_NOT_CONTAINS _variable _first_value)

    set(_actual_list ${${_variable}})

    set(_values_to_find "${ARGN}")
    list(INSERT _values_to_find 0 ${_first_value})
    list(REMOVE_DUPLICATES _values_to_find)

    set(_message "List `${_variable}' expected to not contain '${_values_to_find}'")

    list(LENGTH _actual_list _actual_list_length)
    list(LENGTH _values_to_find _values_to_find_length)

    math(EXPR _last_index "${_values_to_find_length} - 1")
    math(EXPR _actual_list_last_index "${_actual_list_length} - 1")

    foreach(_idx RANGE 0 ${_last_index})

        list(GET _values_to_find ${_idx} _value)

        list(FIND _actual_list ${_value} _index_to_remove)

        if(NOT _index_to_remove EQUAL -1)
            _assert_throw_failed_test("${_message}")
        endif()

    endforeach()

endmacro()

#
# Notify a failing test thowing an error
#
macro(_ASSERT_THROW_FAILED_TEST reason)
    message(FATAL_ERROR ${reason})
endmacro()

### END ###
