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

include(AddTestsFromGoogleTestExecutable)
include(KauriGoogleTestDefinitions)
include(KauriGoogleMockDefinitions)

set(source_files
    tests.cpp)

include_directories(
    ${GOOGLE_TEST_INCLUDE_DIR}
    ${GOOGLE_MOCK_INCLUDE_DIR})

kauri_add_executable(kauri_test_all ${source_files})

target_link_libraries(kauri_test_all gmock gmock_main)

add_tests_from_google_test_executable(kauri_test_all)

set(TEST_TARGET_NAME check)

add_custom_target(${TEST_TARGET_NAME} COMMAND ${CMAKE_CTEST_COMMAND} DEPENDS kauri_test_all)

configure_file(CTestCustom.cmake.in ../CTestCustom.cmake @ONLY)

## END ##
