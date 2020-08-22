# Colors
autoload -U colors && colors    # load colors
setopt autocd                   # automatically cd into typed directory
setopt SHARE_HISTORY            # shares all history
setopt HIST_IGNORE_ALL_DUPS     # ignore all duplicates in history
stty stop undef                 # disable ctrl-s to freeze terminal

# Git prompt with branch name
function precmd {
    if [[ "$NEW_LINE" = true ]] then
        print ""
    else
        NEW_LINE=true
    fi
    vcs_info
}

autoload -Uz vcs_info
zstyle ':vcs_info:git:*' formats 'on %F{red} %F{red}%b'

setopt PROMPT_SUBST
PROMPT='%F{yellow}%1d %F{white}≻≻≻ %F{green}${vcs_info_msg_0_}%f '

# History in cache directory
HISTSIZE=10000
SAVEHIST=10000
HISTFILE="${ZDOTDIR}/.history"

# Exclude garbage in history
function hist() {
    [[ "$#1" -lt 7 \
        || "$1" = "run-help "* \
        || "$1" = "cd "* \
        || "$1" = "man "* \
        || "$1" = "h "* \
        || "$1" = "~ "* ]]
    return $(( 1 - $? ))
}

# Load aliases and shortcuts if existent
source ~/.config/aliasrc 2>/dev/null
source ~/.config/shortcutrc 2>/dev/null

# Autotab complete
setopt completealiases
autoload -U compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list \
    'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*' # case-insensitive completion
zmodload zsh/complist
compinit
_comp_options+=(globdots) # include hidden files
REPORTTIME=1

# Vi mode
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}

# Command not found
command_not_found_handler() {
    printf "command not found \033[31m(╯°□°)╯︵ ┻━┻\033[0m\n"
}

bindkey -s '^f' 'cd "$(dirname "$(fzf)")"\n'

sysinfo

# Load syntax highlighting; should be last
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null
source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh 2>/dev/null
