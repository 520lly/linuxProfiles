# If you come from bash you might have to change your $PATH.

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
#ZSH_THEME="robbyrussell"
#ZSH_THEME="ys"
#ZSH_THEME="bureau"
#ZSH_THEME="agnoster"
#ZSH_THEME="zeta"
ZSH_THEME="spaceship"

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  zsh-autosuggestions
  fzf
  golang
  zsh_reload
  tmux
  vi-mode
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"


alias .2='cd ../../../'
alias .3='cd ../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../../'
alias .6='cd ../../../../../../'
alias .7='cd ../../../../../../../'
export LS_COLORS=di=00\;34:fi=00\;32:ln=00\;33:ex=00\;31:pi=00\;35:so=00\;36:

alias mib3='cd ~/jpcc/code/mib3/'
alias phones='cd ~/jpcc/code/mib3/dev/src/phone'
alias phoneb='cd ~/jpcc/code/mib3/dev/build/phone'
alias phoned='cd ~/jpcc/code/mib3/dev/dist/phone'
#alias tc='sshpass -p root ssh root@m3'
alias lg='lazygit'
alias tmux='tmux -2'
[[ $TMUX = "" ]] && export TERM="xterm-256color"
autoload bashcompinit
bashcompinit
source ~/tools/bob/contrib/bash-completion

#for State Machine Genetation tools
export STMGEN_JAR_PATH="/home/PREHCN/wang_j11/tools/jpcc-stm-generator/libs/tsd.common.tools.stmgen.jar"
#export EA_STM_EXPORT_FILE="/home/PREHCN/wang_j11/tools/jpcc-stm-generator/exportFiles/CarLifeIosStm/export.xml"
export EA_STM_EXPORT_FILE="/home/PREHCN/wang_j11/tools/jpcc-stm-generator/exportFiles/ConnectStm/export.xml"
#export EA_STM_EXPORT_FILE="/home/PREHCN/wang_j11/tools/jpcc-stm-generator/exportFiles/ReconnectMain/export.xml"
#export EA_STM_EXPORT_FILE="/home/PREHCN/wang_j11/tools/jpcc-stm-generator/exportFiles/CarLifeWlStm/export.xml"
#export EA_STM_EXPORT_FILE="/home/PREHCN/wang_j11/tools/jpcc-stm-generator/exportFiles/ReconnectStm/export.xml"

#CommonAPI generator
MY_DOMAIN=/home/PREHCN/wang_j11
RECIPIES_DIR=${MY_DOMAIN}/mib3Update/mib3
BOB_DEV=${RECIPIES_DIR}/dev
COMMONAPI_CREATOR_PATH=${BOB_DEV}/dist/communication/tsd-communication-binding-generator/7/workspace/usr
COMMONAPI_BINARIES_PATH=${BOB_DEV}/dist/communication/ext-commonapi-generator/1/workspace
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${COMMONAPI_CREATOR_PATH}/lib64
export LD_LIBRARY_PATH

export GOPATH=$HOME/tools/gopath
export GOROOT=$HOME/tools/go1.10.3
export GOBIN=$GOROOT/bin
export GO15VENDOREXPERIMENT=1

#Setting for LLVM/CLANG
LLVM_CLANG_PATH=${MY_DOMAIN}/opt/clang+llvm-7.0.0-x86_64-linux-gnu-ubuntu-14.04

export PATH=$PATH:$HOME/bin:/usr/local/bin:$GOBIN:$GOPATH/bin:$COMMONAPI_CREATOR_PATH/bin:${COMMONAPI_BINARIES_PATH}:${LLVM_CLANG_PATH}/bin

export WORKON_HOME=$HOME/.virtualenvs
#source /usr/local/bin/virtualenvwrapper.sh

alias vimrc='vim ~/.vimrc'
alias zshrc='vim ~/.zshrc'


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

## Prefer vi shortcuts
#bindkey -v
#DEFAULT_VI_MODE=viins
#KEYTIMEOUT=1

#__set_cursor() {
#    local style
#    case $1 in
#        reset) style=0;; # The terminal emulator's default
#        blink-block) style=1;;
#        block) style=2;;
#        blink-underline) style=3;;
#        underline) style=4;;
#        blink-vertical-line) style=5;;
#        vertical-line) style=6;;
#    esac

#    [ $style -ge 0 ] && print -n -- "\e[${style} q"
#}

## Set your desired cursors here...
#__set_vi_mode_cursor() {
#    case $KEYMAP in
#        vicmd)
#          __set_cursor block
#          ;;
#        main|viins)
#          __set_cursor vertical-line
#          ;;
#    esac
#}

#__get_vi_mode() {
#    local mode
#    case $KEYMAP in
#        vicmd)
#          mode=NORMAL
#          ;;
#        main|viins)
#          mode=INSERT
#          ;;
#    esac
#    print -n -- $mode
#}

#zle-keymap-select() {
#    __set_vi_mode_cursor
#    zle reset-prompt
#}

#zle-line-init() {
#    zle -K $DEFAULT_VI_MODE
#}

#zle -N zle-line-init
#zle -N zle-keymap-select

## Optional: allows you to open the in-progress command inside of $EDITOR
#autoload -Uz edit-command-line
#bindkey -M vicmd 'v' edit-command-line
#zle -N edit-command-line

## PROMPT_SUBST enables functions and variables to re-run everytime the prompt
## is rendered
#setopt PROMPT_SUBST

## Single quotes are important so that function is not run immediately and saved
## in the variable
#RPROMPT='$(__get_vi_mode)'
