# shell/prompt-zsh.sh
#-------------------------------------------------------------
# ZSH GENERAL
#-------------------------------------------------------------
alias reload!="source ~/.zshrc"
export CLICOLOR=1   # enable colored output from ls, etc
setopt extendedglob # Enable extended globbing
unsetopt nomatch    # Allow [ or ] whereever you want

#-------------------------------------------------------------
# COMMAND COMPLETION
#-------------------------------------------------------------
shared='/usr/local/share'
fpath=(
  ~/.zsh/completion
  $shared/zsh-completions
  $shared/zsh/site-functions
  $SHELL_CONFIG/completions
  $fpath
)

autoload -U compinit && compinit
source $shared/zsh/site-functions/_aws
source $shared/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

compdef g=git

#-------------------------------------------------------------
# DIRECTORY STACK  (see http://j.mp/1lOiWio)
#-------------------------------------------------------------
setopt autocd autopushd pushd_minus pushd_silent
setopt pushd_to_home cdable_vars pushd_ignore_dups
DIRSTACKSIZE=10

#-------------------------------------------------------------
# HISTORY SETTINGS
#-------------------------------------------------------------
setopt hist_ignore_all_dups inc_append_history
HISTFILE=~/.zhistory
HISTSIZE=4096
SAVEHIST=4096

#-------------------------------------------------------------
# COMMAND-LINE AND HISTORY NAVIGATION
#-------------------------------------------------------------
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
bindkey "^Y" accept-and-hold    # issues cmd but keeps it on the CL
bindkey "^N" insert-last-word
bindkey "^P" history-search-backward
bindkey -s "^T" "^[Isudo ^[A"   # T to prepend sudo
bindkey "^R" history-incremental-search-backward
bindkey "\e[A" history-search-backward
bindkey "\e[B" history-search-forward
bindkey "\eOA" history-search-backward
bindkey "\eOB" history-search-forward
bindkey "^[[3"  prefix-2     # ensure delete backwards deletes
bindkey "^[[3~" delete-char  # ensure delete forwards deletes
setopt complete_in_word # back-i-search begins with current word

#-------------------------------------------------------------
# COLORS
#-------------------------------------------------------------
autoload -U colors && colors

function color {
  if   [[ $1 == 'red'    ]]; then echo -n %{$fg_no_bold[red]%}
  elif [[ $1 == 'yellow' ]]; then echo -n %{$fg_no_bold[yellow]%}
  elif [[ $1 == 'green'  ]]; then echo -n %{$fg_no_bold[green]%}
  elif [[ $1 == 'violet' ]]; then echo -n %{$fg_no_bold[magenta]%}
  elif [[ $1 == 'blue'   ]]; then echo -n %{$fg_no_bold[blue]%}
  elif [[ $1 == 'white'  ]]; then echo -n %{$fg_no_bold[white]%}
  elif [[ $1 == 'reset'  ]]; then echo -n %{$reset_color%}
  fi
}

#-------------------------------------------------------------
# PROMPT WITH SHORT PWD, COLORIZED GIT INFO
#-------------------------------------------------------------
setopt prompt_subst       # enables command substitution

PS1=$'\n$(color blue)%c ' # basename of pwd after a newline
PS1+='$(git_branch)'      # current branch or commit name, with color
PS1+='$(color reset)%# '  # reset color, add %
export PS1

#-------------------------------------------------------------
# Use Vim mode in Zsh
#-------------------------------------------------------------
bindkey -v
export KEYTIMEOUT=1      # no lag after pressing ESC to enter normal mode
setopt transient_rprompt # so modes for previous lines aren't displayed

# ------------ Right-side prompt -----------------------------
vim_ins_mode='[insert]'
vim_cmd_mode='[normal]'
vim_mode=$vim_ins_mode

function zle-keymap-select {
  vim_mode="${${KEYMAP/vicmd/${vim_cmd_mode}}/(main|viins)/${vim_ins_mode}}"
  zle reset-prompt
}

function zle-line-finish {
  vim_mode=$vim_ins_mode
}

zle -N zle-keymap-select
zle -N zle-line-finish

RPROMPT='$(color yellow)${vim_mode}$(color reset)'
RPROMPT2='$(color yellow)${vim_mode}$(color reset)'

#-------------------------------------------------------------
# Move to where the arguments belong.
#-------------------------------------------------------------
function after-first-word() {
  zle beginning-of-line
  zle forward-word
}
zle -N after-first-word
bindkey "^X" after-first-word

#-------------------------------------------------------------
# UNDO (DISABLE ZSH DEFAULTS)
#-------------------------------------------------------------
disable r       # disable zsh's r

#-------------------------------------------------------------
# GNU LS (use -G for BSD)
#-------------------------------------------------------------
alias ls="ls --color"

