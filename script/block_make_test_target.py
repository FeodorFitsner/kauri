#
#  kauri
#
#  Copyright (C) 2015 Stefano Azzalini <steazzalini>
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program. If not, see <http://www.gnu.org/licenses/>.
#

#
# Prints the alternative command to use instead of `make test' and then exit
#

import sys
import os
import getopt
from termcolor import colored
from emoji import emojize


def main(argv):

    try:
        opts, args = getopt.getopt(argv, '', ['help', 'alternative-target='])

    except getopt.GetoptError:
        print get_help_message()
        sys.exit(255)

    alternative_target = ''

    for opt, arg in opts:
        if opt == '--help':
            print get_help_message()
            sys.exit()

        elif opt == '--alternative-target':
            alternative_target = arg

    if not alternative_target:
        print get_help_message()
        sys.exit(255)

    print get_block_message(alternative_target)


def get_block_message(alternative_target):

    msg = '\n'
    msg += '#\n'
    msg += '# It seems that '
    msg += colored('make test', 'red', attrs=['bold'])
    msg += ' has been disabled :(\n'
    msg += '# Use '
    msg += colored('make ' + alternative_target, 'green', attrs=['bold'])
    msg += ' instead :)\n'
    msg += '#\n'

    return msg


def get_help_message():

    return os.path.basename(__file__) + ' --alternative-target=<alternative-target-to-use>'


if __name__ == "__main__":

    main(sys.argv[1:])
