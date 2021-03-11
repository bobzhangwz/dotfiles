# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
ZSH=~/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"
# ZSH_THEME="agnoster"
POWERLINE_NO_BLANK_LINE="true"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

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

plugins=(git gem ruby \
             scala sbt \
             node npm vagrant \
             gitignore archlinux \
             docker z sudo systemd copyfile copydir tig docker asdf \
             github aws docker-compose emoji kubectl kops sbt scala terraform)

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
unsetopt list_beep              # no bell on ambiguous completion
unsetopt hist_beep              # no bell on error in histor
unsetopt beep                   # no bell on error

ZSH_CACHE_DIR=$HOME/.oh-my-zsh-cache
if [[ ! -d $ZSH_CACHE_DIR ]]; then
  mkdir $ZSH_CACHE_DIR
fi

source $ZSH/oh-my-zsh.sh

export EDITOR='nvim'
export OKTA_USERNAME='bo.zhang'
export TERM=rxvt-256color
export PATH="$PATH:$HOME/.local/bin:$HOME/.yarn/bin:$HOME/.local/share/coursier/bin"

export PATH="/usr/lib/jvm/java-8-jdk/bin:$PATH"
export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden --exclude .git'

[[ -r "/usr/share/z/z.sh" ]] && source /usr/share/z/z.sh
[[ -r /usr/share/fzf/key-bindings.zsh ]] && source /usr/share/fzf/key-bindings.zsh
[[ -r /usr/share/fzf/completion.zsh ]] && source /usr/share/fzf/completion.zsh
[[ -r ~/usr/aws-shortcuts/aws-shortcuts.sh ]] && source ~/usr/aws-shortcuts/aws-shortcuts.sh
if [[ -d /opt/asdf-vm ]]; then
  . /opt/asdf-vm/asdf.sh
  export JAVA_HOME=$(asdf where java adopt-openjdk-11.0.7+10)
fi
alias ls="ls -F --color=auto"
alias vi="nvim"
alias vim="nvim"
alias ll='ls -al'
alias em="emacsclient -t"
alias emc="emacsclient -c"
alias grep='grep --color=auto'

if [ -z "$DISPLAY" ] && [ "$(fgconsole)" -eq 1 ]; then
    exec ssh-agent startx
fi

if [ $commands[qshell] ]; then
    source <(qshell completion zsh)
fi
