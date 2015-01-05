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

include(LoggableTarget)

function(KAURI_ADD_LIBRARY)

    loggable_target(ADD LIBRARY ${ARGN})

endfunction()

function(KAURI_ADD_EXECUTABLE)

    loggable_target(ADD EXECUTABLE ${ARGN})

endfunction()

function(KAURI_WRITE_TARGETS_LOGS format path)

    loggable_target(LOG ${format} ${path})

endfunction()

## END ##
