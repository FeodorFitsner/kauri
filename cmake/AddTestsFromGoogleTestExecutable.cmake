##
##  AddTestsFromGoogleTestExecutable.cmake
##  Revision: 4 (05 jan 2015)
##
##  Inspired by `gtest_add_tests' declared in GTest module,
##  `add_tests_from_google_test_executable' allows to run
##  google unit tests through CTest.
##  The advantage of this function is that it's decopuled from GTest
##  so it becomes useful when e.g. Google Test is shipped and build
##  with the main project and/or through GoogleMock.
##
##  Repo: https://github.com/steazzalini/cmake-modules
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

function(ADD_TESTS_FROM_GOOGLE_TEST_EXECUTABLE executable)

    set(argv ${ARGV})

    if(${ARGC} EQUAL 2)

        list(GET argv 1 extra_args)

    endif()

    get_property(sources TARGET ${executable} PROPERTY SOURCES)

    set(case_name_regex ".*\\( *([A-Za-z_0-9]+), *([A-Za-z_0-9]+) *\\).*")
    set(test_type_regex "(TYPED_TEST|TEST_?[FP]?)")

    foreach(source ${sources})

        file(READ "${source}" contents)

        string(REGEX MATCHALL "${test_type_regex}\\(([A-Za-z_0-9 ,]+)\\)" found_tests ${contents})

        foreach(hit ${found_tests})

            string(REGEX MATCH "${test_type_regex}" test_type ${hit})

            # Parameterized tests have a different signature for the filter
            if(${test_type} STREQUAL "TEST_P")

                string(REGEX REPLACE ${case_name_regex} "*/\\1.\\2/*" test_name ${hit})

            elseif(${test_type} STREQUAL "TEST_F" OR ${test_type} STREQUAL "TEST")

                string(REGEX REPLACE ${case_name_regex} "\\1.\\2" test_name ${hit})

            elseif(${test_type} STREQUAL "TYPED_TEST")

                string(REGEX REPLACE ${case_name_regex} "\\1/*.\\2" test_name ${hit})

            else()

                message(WARNING "Could not parse GTest ${hit} for adding to CTest.")

                continue()

            endif()

            add_test(NAME ${test_name} COMMAND ${executable} --gtest_filter=${test_name} ${extra_args})

        endforeach()

    endforeach()

endfunction()

## END ##
