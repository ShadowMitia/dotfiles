# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
export HISTSIZE=-1
export HISTFILESIZE=-1
# Change history location to avoid some sessions to truncate history by mistake
export HISTFILE=~/.bash_eternal_history

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

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
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

if command -v yt-dlp &> /dev/null; then

function dla
{
    if [ -z "$1" ]
    then
  echo 'Usage: dla "URL"'
    else
  yt-dlp --downloader aria2c --add-metadata --write-all-thumbnails --embed-thumbnail --write-info-json --embed-subs --all-subs -i --prefer-free-formats -o '~/Music/Downloads/%(title)s.%(ext)s'  --download-archive ~/Music/Downloads/archive.txt  --extract-audio $1


    fi
}

function dllist
{
    if [ -z $1 ]
    then
  echo 'Usage: dllist "URL" [range] where range can be any of x-y x,y x,z,w\nNote: URL _NEEDS_ to be in quotes'
    else
  if [ -z $2 ]
  then
      yt-dlp --downloader aria2c -c --add-metadata --embed-thumbnail --embed-subs -i --prefer-free-formats -o "~/Videos/Downloads/%(playlist)s/[%(playlist_index)s]-%(title)s.%(ext)s"  --download-archive ~/Videos/Downloads/archive.txt "${1}"
  else
      yt-dlp --downloader aria2c -c --add-metadata --embed-thumbnail --embed-subs --prefer-free-formats -o "~/Videos/Downloads/%(playlist)s/[%(playlist_index)s]-%(title)s.%(ext)s"  --download-archive ~/Videos/Downloads/archive.txt "${1}" --playlist-items $2
  fi
    fi
}


function dl
{
    if [ -z $1 ]
    then
  echo 'Usage: dl "URL"'
    else
      yt-dlp --downloader aria2c -c --add-metadata --embed-thumbnail --embed-subs --all-subs -i --prefer-free-formats -o '~/Videos/Downloads/%(title)s.%(ext)s'  --download-archive ~/Videos/Downloads/archive.txt $1
    fi
}
fi


# the fuck : https://github.com/nvbn/thefuck
if command -v thefuck &> /dev/null
then
    eval "$(thefuck --alias)"
fi


function sl
{
    # sl - prints a mirror image of ls. (C) 2017 Tobias Girstmair, https://gir.st/, GPLv3

    LEN=$(ls "$@" |wc -L) # get the length of the longest line

    ls "$@" | rev | while read -r line
    do
	printf "%${LEN}.${LEN}s\\n" "$line" | sed 's/^\(\s\+\)\(\S\+\)/\2\1/'
    done
}

function cleanup
{
    echo "=== Cleaning up logs ===";
    sudo journalctl --vacuum-size=128M; #http://www.commitstrip.com/en/2017/01/16/nice-try/
    echo "=== Checking logs integrity ===";
    journalctl --verify;
    echo "=== Done cleaning ===";
}

# alias cmake="cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1"
command -v bat &> /dev/null && alias cat="bat"

if command -v emacs &> /dev/null; then
    # Banish all evil!
    alias vim="emacs"
    alias vi="emacs"
fi

if command -v ffmpeg &> /dev/null; then
  function convert_to_mp4 {
    ffmpeg -i "${1}" -codec copy "${1%.*}".mp4
  }
fi

command -v docker &> /dev/null && alias OMG_DOCKER_Y_U_TAKE_SO_MUCH_SPACE="docker system prune -f"

# oh my posh
#if command -v oh-my-posh &> /dev/null; then
#    eval "$(oh-my-posh --init --shell bash --config ~/.poshthemes/powerlevel10k_rainbow.omp.json)"
#fi

# if [ -f ~/bin/bash.command-not-found ]; then
#     . ~/bin/bash.command-not-found
# fi

export PATH=$PATH:~/.cargo/bin/
export PATH=$PATH:~/.local/bin/


[[ "$TERM" == "xterm-kitty" ]] && alias ssh="kitty +kitten ssh"
[[ "$TERM" == "xterm-kitty" ]] && alias icat="kitty +kitten icat"

if [ -d "$HOME/.nvm" ]; then
	export NVM_DIR="$HOME/.nvm"
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
	[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

# fnm
if [ -d "$HOME/.fnm" ]; then
	export PATH="$HOME/.fnm":$PATH
	eval "$(fnm env)"
fi

# fzf
if command -v fzf &> /dev/null; then
  source /usr/share/doc/fzf/examples/key-bindings.bash
fi

# Starship prompt
eval "$(starship init bash)"

# Keep last, apply local only, non-synced settings.
if [ -f ~/.bashrc-local ]; then
     . ~/.bashrc-local
fi

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH=$BUN_INSTALL/bin:$PATH
