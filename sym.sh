#!/bin/bash
#
# new-symlink: Add a new symlink to $@ into $HOME/bin
#
# Copyright 2010 Tom Vincent <http://www.tlvince.com/>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.
#
# Changelog:
# v0.1.0 - (2010-09-16)
#        * Began script
#
# TODO:
# * Delete changelog if using SCM
#
# Exit codes:
#   0   - successful
#   1   - bad argument
#   2   - file not found

# Program meta-data:
NAME="new-symlink"
VERSION="0.1.0 (2010-09-16 21:01)"


##
# Show help options.
#
usage()
{
    cat << END_USAGE
Usage:
  ${0##*/} [OPTION...] [ARGUMENTS...]

Options:
  -h, --help              Show help options
  -q, --quiet             Suppress all normal output
  -v, --version           Output version information and exit
  -V, --verbose           Output processing information
END_USAGE
}

##
# Output program version information.
#
version()
{
    cat << END_VERSION
${0##*/} v$VERSION
Copyright 2010 Tom Vincent <http://www.tlvince.com/>
END_VERSION
}

##
# Parse the runtime options and arguments.
#
parseOpts()
{
    if [[ -z "$1" ]]; then
        usage
        exit 1
    fi

    case "$1" in
        -h|--help)
            usage
        ;;
        -q|--quiet)
            quiet=true
            shift
            parseOpts "$@"
        ;;
        -v|--version)
            version
        ;;
        -V|--verbose)
            verbose=true
            shift
            parseOpts "$@"
        ;;
        *)
            usage
        ;;
    esac
}

for i in "$@"; do
    [[ $1 == "-h" ]] || [[ $1 == "--help" ]] && {
        echo "${0##*/} [file] -> ~/bin/[sanitised-symlink]"
        exit
    }
    full="$(readlink -f "$i")"  # Full canonical path
    file="${full##*/}"          # Basename
    file="${file%.*}"           # Strip extension
    ln -s "$full" "$HOME/bin/$file"
done
