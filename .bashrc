#!/bin/bash
# ~/.bashrc# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case $TERM in
xterm-color | *-256color) color_prompt=yes ;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
  else
    color_prompt=
  fi
fi

if [ "$color_prompt" = yes ]; then
  PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
  PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi

unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm* | rxvt*)
  PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
  ;;
*) ;;

esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)"
else
  eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  #alias dir='dir --color=auto'
  #alias vdir='vdir --color=auto'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
GCC_COLORS="error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01"
export GCC_COLORS

# source custom bash aliases
if [ -f "$HOME"/.bash_aliases ]; then
  . "$HOME"/.bash_aliases
fi

# source custom local bash aliases
if [ -f "$HOME"/.dotfiles-local-settings ]; then
  . "$HOME"/.dotfiles-local-settings
fi

# source custom bash functions
if [ -f "$HOME"/.bash_functions ]; then
  . "$HOME"/.bash_functions
fi

# enable programmable completion features
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Extends MANPATH to include local directories
MANPATH=/usr/local/man:"$MANPATH"
export MANPATH

# added by travis gem
[ ! -s "$HOME"/.travis/travis.sh ] || source "$HOME"/.travis/travis.sh

# The next line enables shell command completion for Stripe
[ ! -s "$HOME"/.stripe/stripe-completion.bash ] || source "$HOME"/.stripe/stripe-completion.bash

# heroku autocomplete setup
HEROKU_AC_BASH_SETUP_PATH=$HOME/.cache/heroku/autocomplete/bash_setup && test -f "$HEROKU_AC_BASH_SETUP_PATH" && source "$HEROKU_AC_BASH_SETUP_PATH"

# make sure Bun binaries are added to PATH at the user level
eval BUN_INSTALL="$HOME/.bun"
if [ -d "$BUN_INSTALL/bin" ]; then
  PATH="$BUN_INSTALL/bin:$PATH"
fi

# starship config for bash
eval "$(starship init bash)"

# make sure Linuxbrew is included on PATH at the user level
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# configure Homebrew completions in bash ( to support not only brew,
# but other binaries whose completions use that of brew, like heroku.
if type brew &>/dev/null; then
  HOMEBREW_PREFIX="$(brew --prefix)"
  if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
    source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
  else
    for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
      #shellcheck source=/home/linuxbrew/.linuxbrew/etc/bash_completion.d/
      [[ -r "${COMPLETION}" ]] && source "${COMPLETION}"
    done
  fi
fi

# A shortcut function that simplifies usage of xclip.
# - Accepts input from either stdin (pipe), or params.
# Sourced from https://madebynathan.com/2011/10/04/a-nicer-way-to-use-xclip/
# ------------------------------------------------
cb() {
  local _scs_col="\e[0;32m"
  local _wrn_col="\e[1;31m"
  local _trn_col="\e[0;33m"
  # Check that xclip is installed.
  if ! type xclip >/dev/null 2>&1; then
    echo -e "$_wrn_col""You must have the 'xclip' program installed.\e/[0m"
  # Check user is not root (root doesn't have access to user xorg server)
  elif [[ "$USER" == "root" ]]; then
    echo -e "$_wrn_col""Must be regular user (not root) to copy a file to the clipboard.\e[0m"
  else
    # If no tty, data should be available on stdin
    if ! [[ "$(tty)" == /dev/* ]]; then
      input="$(</dev/stdin)"
    # Else, fetch input from params
    else
      input="$*"
    fi
    if [ -z "$input" ]; then # If no input, print usage message.
      echo "Copies a string to the clipboard."
      echo "Usage: cb <string>"
      echo "echo <string> | cb"
    else
      # Copy input to clipboard
      echo -n "$input" | xclip -selection c
      # Truncate text for status
      if [ ${#input} -gt 80 ]; then input="$(echo "$input" | cut -c1-80)$_trn_col...\e[0m"; fi
      # Print status.
      echo -e "$_scs_col""Copied to clipboard:\e[0m $input"
    fi
  fi
}

# keychain
eval "$(keychain --eval id_rsa)"
eval "$(keychain --eval id_ed25519)"

GPG_TTY=$(tty)
export GPG_TTY

export NVM_COLORS="BMGRY"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

cdnvm() {
  command cd "$@" || exit
  nvm_path=$(nvm_find_up .nvmrc | tr -d '\n')

  # If there are no .nvmrc file, use the default nvm version
  if [[ ! $nvm_path = *[^[:space:]]* ]]; then

    declare default_version
    default_version=$(nvm version default)

    # If there is no default version, set it to `node`
    # This will use the latest version on your machine
    if [[ $default_version == "N/A" ]]; then
      nvm alias default node
      default_version=$(nvm version default)
    fi

    # If the current version is not the default version, set it to use the default version
    if [[ $(nvm current) != [[$default_version]] ]]; then
      nvm use default
    fi

  elif [[ -s $nvm_path/.nvmrc && -r $nvm_path/.nvmrc ]]; then
    declare nvm_version
    nvm_version=$(<"$nvm_path"/.nvmrc)

    declare locally_resolved_nvm_version
    # `nvm ls` will check all locally-available versions
    # If there are multiple matching versions, take the latest one
    # Remove the `->` and `*` characters and spaces
    # `locally_resolved_nvm_version` will be `N/A` if no local versions are found
    locally_resolved_nvm_version=$(nvm ls --no-colors "$nvm_version" | tail -1 | tr -d '\->*' | tr -d '[:space:]')

    # If it is not already installed, install it
    # `nvm install` will implicitly use the newly-installed version
    if [[ $locally_resolved_nvm_version == "N/A" ]]; then
      nvm install "$nvm_version"
    elif [[ $(nvm current) != [[$locally_resolved_nvm_version]] ]]; then
      nvm use "$nvm_version"
    fi
  fi
}
alias cd=cdnvm
cd "$PWD" || exit
