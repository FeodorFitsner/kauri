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

include(KauriTargets)
include(DataStructureSet)
include(GlobalSourceFilesProperties)
include(SourceFileContainer)

add_subdirectory(grammar)

source_file_container(GET kauri_source_files source_files)

global_source_files_properties(EXPORT ALL)

kauri_add_library(kauri ${CMAKE_CURRENT_SOURCE_DIR}/main.cpp ${source_files})

add_dependencies(kauri kauri_parser)

set_target_properties(kauri PROPERTIES COMPILE_FLAGS "-std=c++11")

## END ##
