#! bash oh-my-bash.module
# Adapt to your liking. Tried to make it as modular as possible
# NOTE: Create pill adds space at the end to accomodate for hidden pills
# Also yeah, colors are global. Couldn't be bothered to fix it.
# SEE: Adapt text color to your liking based on your theme. Sometimes BACKGROUND is not contrasting enough
# You could add another argument with the text color value
# TODO: Bold color handling?
# prompt theming

# Foreground colors
FOREGROUND="\e[39m"

WHITE="\e[97m"
GRAY="\e[90m"
BLACK="\e[30m"
LGRAY="\e[37m"

RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
MAGENTA="\e[35m"
CYAN="\e[36m"

LRED="\e[91m"
LGREEN="\e[92m"
LYELLOW="\e[93m"
LBLUE="\e[94m"
LMAGENTA="\e[95m"
LCYAN="\e[96m"

# Background colors

BACKGROUND="\e[49m"

BWHITE="\e[107m"
BGRAY="\e[100m"
BBLACK="\e[40m"
BLGRAY="\e[47m"

BRED="\e[41m"
BGREEN="\e[42m"
BYELLOW="\e[43m"
BBLUE="\e[44m"
BMAGENTA="\e[45m"
BCYAN="\e[46m"

BLRED="\e[101m"
BLGREEN="\e[102m"
BLYELLOW="\e[103m"
BLBLUE="\e[104m"
BLMAGENTA="\e[105m"
BLCYAN="\e[106m"

# Powerline Symbols
OPEN=""
CLOSE=""

# Color helpers
INV="\e[7m"
RINV="\e[27m"
RBOLD="e[21m"
RESET="\e[0m"

function create_pill() {
  # Args
  local DARK="$1"   # Color for the pill text
  local LIGHT="$2"  # Color for the pill icon
  local TEXT="$3"   # Pill text
  local ICON="$4"   # Pill NF icon
  #local BOLD="$5"   # Bold for brighter colors (for terminals that work like that) ----- W.I.P.

  # Background colors
  local DARKBG=${DARK//\[3/\[4}
  local DARKBG=${DARKBG//\[9/\[10}


  # Pill
  echo -e $LIGHT$OPEN$INV$ICON$RINV$DARKBG$CLOSE $RESET$DARK$INV$TEXT$RINV$CLOSE$RESET" "
} 

function create_uwu() {
  local STATUS="$1"
  local UWU
  # 0 - success
  # 127 - not found
  # * - err

  if ((status == 0)); then  
    UWU=$LMAGENTA$OPEN$INV"^_^";
  elif (( status == 127)); then
    UWU=$LBLUE$OPEN$INV"∘_°";
  else
    UWU=$LRED$OPEN$INV"T_T";
  fi

  echo -e "$UWU$RINV$CLOSE\n"➤ "$RESET"

}

function _omb_theme_PROMPT_COMMAND() {
  # status
  local status=$?

  #Memory
  local MEM_FREE="$(awk '/MemFree/ { printf "%.f", $2/1024/1024 }' /proc/meminfo)"
  local MEM_FREE_DETAIL="$(awk '/MemFree/ { printf "%.1f", $2/1024/1024 }' /proc/meminfo)"

  local MEM_TOTAL="$(awk '/MemTotal/ { printf "%.f", $2/1024/1024 }' /proc/meminfo)"
  local MEM_DIFF=$(($MEM_TOTAL - $MEM_FREE))

  local FREE_COLOR=$GREEN

  if (( $MEM_DIFF <= 2)); then
    FREE_COLOR=$RED
  elif (( $MEM_DIFF <= 4)); then
    FREE_COLOR=$YELLOW
  fi

  local MEMORY=$MEM_FREE_DETAIL"/"$MEM_TOTAL

  # Time
  local TIME=$(date +"%H:%M")

  # Source Code Management
  local SCM="$(scm_prompt_info)"

  # Dir
  local DIR="\w"

  # Node
  if [ -d node_modules ]; then
    local NODEV=$(node -v)
    local NODEVT=${NODEV:1}
    local NPMV=$(npm -v)
  fi


  # Pills
  local PILL_WORKDIR=$(create_pill $BLUE $LBLUE $DIR )
  local PILL_STATUS=$(create_uwu status)
  local PILL_MEMORY=$(create_pill $FREE_COLOR $LGREEN $MEMORY )
  local PILL_TIME=$(create_pill $YELLOW $LYELLOW $TIME )
  
  local PILL_SCM=""
  if [ ! -z "$SCM" ]; then
    local PILL_SCM=$(create_pill $CYAN $LCYAN $SCM )
  fi

  local PILL_NODE=""
  local PILL_NPM=""
  if [ -d node_modules ]; then
    PILL_NODE=$(create_pill $MAGENTA $LMAGENTA $NODEVT )
    PILL_NPM=$(create_pill $RED $LRED $NPMV )
  fi


  PS1="\n$PILL_WORKDIR$PILL_SCM\n$PILL_TIME$PILL_MEMORY$PILL_NODE$PILL_NPM$PILL_STATUS"
}

# scm theming
SCM_THEME_PROMPT_DIRTY="✗"
SCM_THEME_PROMPT_CLEAN=" ✓"
SCM_THEME_PROMPT_PREFIX=""
SCM_THEME_PROMPT_SUFFIX=""


_omb_util_add_prompt_command _omb_theme_PROMPT_COMMAND
