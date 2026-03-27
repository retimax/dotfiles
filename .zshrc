# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# XDG-compliant zsh settings - Create directories if they don't exist
[[ ! -d "$XDG_CACHE_HOME/zsh" ]] && mkdir -p "$XDG_CACHE_HOME/zsh"
[[ ! -d "$XDG_STATE_HOME/zsh" ]] && mkdir -p "$XDG_STATE_HOME/zsh"

# History settings
export HISTFILE="$XDG_STATE_HOME/zsh/history"

# Load completion system (FIXED - was missing autoload)
autoload -Uz compinit
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"

# Cuda
export LD_LIBRARY_PATH=/usr/lib:/opt/cuda/lib64:/opt/cuda/extras/CUPTI/lib64
export CUDA_HOME=/opt/cuda

# PATH updates - Using XDG-compliant paths where possible
export PATH="$NIMBLE_DIR/bin:$PATH"  # Using XDG-compliant nimble path
export PATH="$HOME/.choosenim/current/bin:$PATH"  # This one might not support XDG yet
export PATH="$GEM_HOME/bin:$PATH"  # Using XDG-compliant gem path
export PATH="$CARGO_HOME/bin:$PATH"  # Using XDG-compliant cargo path
export PATH="$PYENV_ROOT/bin:$PATH"  # Using XDG-compliant pyenv path
export PATH="$HOME/.local/share/gem/ruby/3.4.0/bin:$PATH"

# Oh My Zsh installation - FIXED to use XDG-compliant path
export ZSH="$XDG_DATA_HOME/oh-my-zsh"

# Set name of the theme to load
ZSH_THEME="powerlevel10k/powerlevel10k"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Plugins
plugins=(
	git
	zsh-autosuggestions
	zsh-syntax-highlighting
  vi-mode
)

# Vi mode
bindkey -v 
export KEYTIMEOUT=1

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# Load Oh My Zsh - FIXED path and added error checking
if [[ -f "$ZSH/oh-my-zsh.sh" ]]; then
    source "$ZSH/oh-my-zsh.sh"
else
    echo "Warning: Oh My Zsh not found at $ZSH"
    echo "Please run the migration script or move ~/.oh-my-zsh to $ZSH"
fi

# Functions

function reload(){
	source ~/.zshrc && echo "[*] Zshrc recargado!"
}

# Using fzf to search and cd into directories
function cdf() {
  if [[ $# -gt 0 ]]; then 
    builtin cd "$@"
  else
    local dir 
    dir=$(find ${1:-.} -path '*/\.*' -prune -o -type d -print 2> /dev/null | fzf +m) && builtin cd

    "$dir"
  fi
}

# Compile C file and run it
function compc(){
	arg=$1
	gcc -w -o ${arg::-2} $arg && output/${arg::-2}
}

# Open projects in nvim
function projects() {
  local directory="$HOME/Desktop/projects"
  local dir

  dir=$(find $directory -mindepth 1 -maxdepth 1 -type d | fzf --preview 'tree -C {} -L 2' --border --style=full --reverse)

  cd "$dir" && nvim .
}

# The same that compc but just for test the program
function testc(){
	arg=$1
	gcc -w -o ${arg::-2} $arg && ./${arg::-2}
  rm ${arg::-2}
}

# Set path as tittle
function stittle() {
	echo -en "e\2;$,@\a"
}

# Change current working directory when exiting yazi
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# The C Language environment
books="$HOME/Documents/books"
function learning() {
  local books="$HOME/Documents/books"
  foliate $books/development/ePub\ files/TheCProgrammingLanguage.epub &>/dev/null & 
  disown &&
  cd $HOME/Desktop/learning-c/theClanguage/ &&
  nvim .
}

# *****************************
# *    Hacking fucntions      *
# *****************************

function mkt(){
	mkdir {nmap,content,exploits,scripts}
  touch notes.md
}

# Unzip crackmes with default password
function ucrack(){
	unzip -P crackmes.one $1
	rm *.zip
}


# Extract nmap information
function extractPorts(){
	ports="$(cat $1 | grep -oP '\d{1,5}/open' | awk '{print $1}' FS='/' | xargs | tr ' ' ',')"
	ip_address="$(cat $1 | grep -oP '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}' | sort -u | head -n 1)"
	echo -e "\n[*] Extracting information...\n" > extractPorts.tmp
	echo -e "\t[*] IP Address: $ip_address"  >> extractPorts.tmp
	echo -e "\t[*] Open ports: $ports\n"  >> extractPorts.tmp
	echo $ports | tr -d '\n' | xclip -sel clip
	echo -e "[*] Ports copied to clipboard\n"  >> extractPorts.tmp
	cat extractPorts.tmp; rm extractPorts.tmp
}

# Settarget
function settarget(){
	if [ $# -eq 1 ]; then
	echo $1 > ~/.config/bin/target
	elif [ $# -gt 2 ]; then
	echo "settarget [IP] [NAME] | settarget [IP]"
	else
	echo $1 $2 > ~/.config/bin/target
	fi
}

# Bat theme
export BAT_THEME="OneHalfDark"

# User configuration
export MANPAGER="sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -l man -p'"

# Language environment
export LANG=en_US.UTF-8

# kitty ssh fix
[[ "$TERM" == "xterm-kitty" ]] && alias ssh="TERM=xterm-256color ssh"

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='nvim'
fi

# Compilation flags
export ARCHFLAGS="-arch $(uname -m)"

# History options
unsetopt histverify
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt SHARE_HISTORY

# Initialize pyenv if it exists
if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
fi

# Aliases
alias ll='lsd -lh --group-dirs=first'
alias la='lsd -a --group-dirs=first'
alias l='lsd --group-dirs=first'
alias lla='lsd -lha --group-dirs=first'
alias ls='lsd --group-dirs=first'
alias cat='/bin/bat --paging=never'
alias catn='cat'
alias catnl='bat'
alias py='python'
alias py3='python3'
alias crackmes='cd Desktop/reversing/crackmes'
alias dotfiles='cd $HOME/dotfiles'
alias odat='/home/r0lk444/Desktop/offSecTools/odat-libc2.17-x86_64/odat-libc2.17-x86_64'
alias ff="fzf --style full --preview 'fzf-preview.sh {}' --bind 'focus:transform-header:file --brief {}'"

# Load XDG aliases if they exist
[[ -f "$XDG_CONFIG_HOME/xdg-aliases" ]] && source "$XDG_CONFIG_HOME/xdg-aliases"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# FIXED - Using XDG-compliant path for p10k config
[[ ! -f ${ZDOTDIR:-~}/.p10k.zsh ]] || source ${ZDOTDIR:-~}/.p10k.zsh

# Created by `pipx` on 2026-03-10 20:46:44
export PATH="$PATH:/home/r0lk444/.local/bin"
