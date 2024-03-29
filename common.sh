###############################
#          common.sh          #
###############################
#
# A collection of commonly used bash functions
# and variables to reduce reused code in many
# bash scripts
#
# decaby7e - 2020.01.21


#~#~#~#~#~#~#~#~#~#~#~#
#      Variables      #
#~#~#~#~#~#~#~#~#~#~#~#

## Color Variables ##

RED='\033[0;31m'    # Red
L_RED='\033[1;31m'  # Light red
GREEN='\033[0;32m'  # Green
YELLOW='\033[1;33m' # Yellow
WHITE='\033[1;34m'  # White
ORANGE='\033[0;33m' # Orange
NC='\033[0m'        # No Color

## Path Variables ##

# Return the full path of a running script
SCRIPT_PATH=$(dirname $(realpath -s $0))


#~#~#~#~#~#~#~#~#~#~#~#
#      Functions      #
#~#~#~#~#~#~#~#~#~#~#~#


## Logging Variables ##

# Usage: debug 'Debug Message'
debug(){
  printf '\033[0;33mDEBUG\033[0m  %s\n' "$1"
}

# Usage: info 'Information Message'
info(){
  printf '\033[1;34mINFO\033[0m   %s\n' "$1"
}

# Usage: warn 'Warning Message'
warn(){
  printf '\033[1;33mWARN\033[0m   %s\n' "$1"
}

# Usage: fatal 'Error Message'
fatal(){
  printf '\033[0;31mFATAL  %s\033[0m\n' "$1"
  exit 1
}

## Checks ##

# Usage: root_check
root_check(){
  if [ "$EUID" -ne 0 ]; then
    fatal "Must be run as root."
  fi
}

#
# Usage: lock_self
#
# Alternative in one line from http://man7.org/linux/man-pages/man1/flock.1.html
# [ "${FLOCKER}" != "$0" ] && exec env FLOCKER="$0" flock -en "$0" "$0" "$@" || :
#
lock_self(){
  LOCK_FILE=a.lock
  exec 100>"$LOCK_FILE"
  flock -n 100 ||\
  fatal "Script currently running."
}


dehumanize(){
    awk '/[0-9]$/{print $1;next};/[gG]$/{printf "%u\n", $1*(1024*1024*1024);next};/[mM]$/{printf "%u\n", $1*(1024*1024);next};/[kK]$/{printf "%u\n", $1*1024;next}' <(echo $1)
}
