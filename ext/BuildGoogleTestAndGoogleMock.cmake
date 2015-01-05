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

#
# Build GoogleTest and GoogleMock.
#
# GoogleTest is shipped within GoogleMock by default.
# CMake is supported by both of these packages so
# you only need to include GoogleMock to the project as subdirectory.
# GoogleMock has the resposabiliy to configure and build GoogleTest by itself,
# so no deal must be made with it.
# These targets are excluded form the `make all' and built on demand
# when required, e.g. running `make test'.
#
# Libs:
#  - gtest          GoogleTest core
#  - gtest_main     classic main function that initialize and run tests
#  - gmock          GoogleMock core linked with gtest
#  - gmock_main     classic main function that initialize and run tests
#

add_subdirectory(gmock-1.7.0 EXCLUDE_FROM_ALL)

## END ##
