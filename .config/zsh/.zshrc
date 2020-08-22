# Colors
autoload -U colors && colors    # Load colors
setopt autocd                   # Automatically cd into typed directory
setopt share_history            # Shares all history
setopt hist_ignore_all_dups     # Ignore all duplicates in history
stty stop undef                 # Disable ctrl-s to freeze terminal

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
  'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*' # Case-insensitive completion
zmodload zsh/complist
compinit
_comp_options+=(globdots) # Include hidden files
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

# Change cursor shape for different vi modes
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
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # Initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt

# Command not found
command_not_found_handler() {
    printf "command not found \033[31m(╯°□°)╯︵ ┻━┻\033[0m\n"
}

bindkey -s '^a' 'bc -l\n'

bindkey -s '^f' 'cd "$(dirname "$(fzf)")"\n'

sysinfo

# Load syntax highlighting; should be last
source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh 2>/dev/null
