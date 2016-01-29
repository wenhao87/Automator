#!/bin/zsh

# automatically output status of all projects
# whchen.io
# 01.28.2016

# bash color
# http://misc.flogisoft.com/bash/tip_colors_and_formatting
STYLE_WHITE="\e[97m"
STYLE_CYAN="\e[36m"
STYLE_RED="\e[31m"
STYLE_YELLOW="\e[33m"
STYLE_RESET="\e[0m"
STYLE_BOLD="\e[1m"

# unicode char for git status
# ✗✔⚑✖◒§▴
SIGN_CLEAN="✔"
SIGN_DIRTY="✗"

# fixed width for directory
WIDTH_DIR='               '

PROMPT_ON=" ${STYLE_WHITE}on${STYLE_RESET} "
PROMPT_BRANCH=":${STYLE_CYAN}"
PROMPT_SUFFIX="${STYLE_RESET}"
PROMPT_CLEAN="${STYLE_RESET}${SIGN_CLEAN}"
PROMPT_DIRTY="${STYLE_RED}${SIGN_DIRTY}"

GIT_PROMPT_LOCATION="${PROMPT_ON}git${PROMPT_BRANCH}"
GIT_PROMPT_SUFFIX="$PROMPT_SUFFIX"
GIT_PROMPT_DIRTY="$PROMPT_DIRTY"
GIT_PROMPT_CLEAN="$PROMPT_CLEAN"

function git_prompt_info() {
  local ref
  if [[ "$(command git config --get oh-my-zsh.hide-status 2>/dev/null)" != "1" ]]; then
    ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return 0
    # echo "$GIT_PROMPT_LOCATION${ref#refs/heads/} $(parse_git_dirty)$GIT_PROMPT_SUFFIX"
    echo -n " $(parse_git_dirty)$GIT_PROMPT_SUFFIX  "
  fi
}

# Checks if working tree is dirty
function parse_git_dirty() {
  local STATUS=''
  local FLAGS
  FLAGS=('--porcelain')
  if [[ "$(command git config --get oh-my-zsh.hide-dirty)" != "1" ]]; then
    STATUS=$(command git status ${FLAGS} 2> /dev/null | tail -n1)
  fi
  if [[ -n $STATUS ]]; then
    echo "$GIT_PROMPT_DIRTY"
  else
    echo "$GIT_PROMPT_CLEAN"
  fi
}

tput civis

cd /Users/whchen/Public/Github/
echo ${STYLE_BOLD}${STYLE_CYAN}gst${STYLE_RESET} ${STYLE_WHITE}in ${STYLE_BOLD}${STYLE_YELLOW}`pwd`${STYLE_RESET}
while :; do
  # clear
  tput sc # save cursor
  for dir in */ ; do
    cd ${dir}
    dir=${dir%/}
    # printf "$STYLE_BOLD$STYLE_CYAN%s%s$STYLE_RESET" $dir "${WIDTH_DIR:${#dir}}"
    git_prompt_info
    cd ..
  done
  sleep 1
  tput rc;tput el  # rc = restore cursor, el = erase to end of line
done
