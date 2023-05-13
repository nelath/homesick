#!/usr/bin/env bash

# help is used globally
# shellcheck disable=SC2120
help() {
  if [[ $1 ]]; then
    extended_help "$1"
    exit "$EX_SUCCESS"
  fi

printf "homes\e[1;34mh\e[0mick uses git in concert with symlinks to track your precious dotfiles.

 Usage: homesick [options] TASK

 Tasks:
  homesick cd CASTLE                 # Enter a castle
  homesick clone URI..               # Clone URI as a castle for homesick
  homesick generate CASTLE..         # Generate a castle repo
  homesick list                      # List cloned castles
  homesick check [CASTLE..]          # Check a castle for updates
  homesick refresh [DAYS [CASTLE..]] # Check if a castle needs refreshing
  homesick pull [CASTLE..]           # Update a castle
  homesick link [CASTLE..]           # Symlinks all dotfiles from a castle
  homesick track CASTLE FILE..       # Add a file to a castle
  homesick help [TASK]               # Show usage of a task

 Aliases:
  ls      # Alias to list
  symlink # Alias to link
  updates # Alias to check

 Runtime options:
   -q, [--quiet]    # Suppress status output
   -s, [--skip]     # Skip files that already exist
   -f, [--force]    # Overwrite files that already exist
   -b, [--batch]    # Batch-mode: Skip interactive prompts / Choose the default
   -v, [--verbose]  # Verbose-mode: Detailed status output

 Note:
  To check, refresh, pull or symlink all your castles
  simply omit the CASTLE argument

"
}

extended_help() {
  case $1 in
    cd)
      printf "Enters a castle's home directory.\n"
      printf "NOTE: For this to work, homesick must be invoked via homesick.{sh,csh,fish}.\n\n"
      printf "Usage:\n  homesick cd CASTLE"
      ;;
    clone)
      printf "Clones URI as a castle for homesick\n"
      printf "Usage:\n  homesick clone URL.."
      ;;
    generate)
      printf "Generates a repo prepped for usage with homesick\n"
      printf "Usage:\n  homesick generate CASTLE.."
      ;;
    list|ls)
      printf "Lists cloned castles\n"
      printf "Usage:\n  homesick %s" "$1"
      ;;
    check|updates)
      printf "Checks if a castle has been updated on the remote\n"
      printf "Usage:\n  homesick %s [CASTLE..]" "$1"
      ;;
    refresh)
      printf "Checks if a castle has not been pulled in DAYS days.\n"
      printf "The default is one week.\n"
      printf "Usage:\n  homesick refresh [DAYS] [CASTLE..]"
      ;;
    pull)
      printf "Updates a castle. Also recurse into submodules.\n"
      printf "Usage:\n  homesick pull [CASTLE..]"
      ;;
    link|symlink)
      printf "Symlinks all dotfiles from a castle\n"
      printf "Usage:\n  homesick %s [CASTLE..]" "$1"
      ;;
    track)
      printf "Adds a file to a castle.\n"
      printf "This moves the file into the castle and creates a symlink in its place.\n"
      printf "Usage:\n  homesick track CASTLE FILE.."
      ;;
    help)
      printf "Shows usage of a task\n"
      printf "Usage:\n  homesick help [TASK]"
      ;;
    *)
      # no args for help
      # shellcheck disable=SC2119
      help
      ;;
    esac
  printf "\n\n"
}
