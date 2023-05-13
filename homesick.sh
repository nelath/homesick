#!/usr/bin/env bash
# This script should be sourced in the context of your shell like so:
# source $HOME/.homesick/repos/.homeshick/homeshick.sh
# Once the homeshick() function is defined, you can type
# "homeshick cd CASTLE" to enter a castle.

homesick() {
	if [ "$1" = "cd" ] && [ -n "$2" ]; then
		# We want replicate cd behavior, so don't use cd ... ||
		# shellcheck disable=SC2164
		if [[ -d "${HOME}/.homesick/repos/castle-$2" ]]; then
			prefix=castle-
		else
			prefix=
		fi
		cd "$HOME/.homesick/repos/${prefix}$2"
	else
		"${HOMESICK_DIR:-$HOME/.homesick/repos/homesick}/bin/homesick" "$@"
	fi
}
alias hs=homesick
