# Default programs
export EDITOR="nvim"
export TERMINAL="kitty"
export VISUAL="nvim"
export BROWSER="zen-browser"

# XDG PATHS
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_SCREENSHOTS_DIR="$HOME/Pictures/Screenshots"

# Clean up - Original settings
# Nim 
export NIMBLE_DIR="$XDG_DATA_HOME/nimble"
# Bundle
export BUNDLE_USER_CACHE=$XDG_CACHE_HOME/bundle
export BUNDLE_USER_CONFIG=$XDG_CONFIG_HOME/bundle
export BUNDLE_USER_PLUGIN=$XDG_DATA_HOME/bundle
# Cargo
export CARGO_HOME="$XDG_DATA_HOME"/cargo
# Discord
export DISCORD_USER_DATA_DIR="${XDG_DATA_HOME}"
# Docker
export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker
export MACHINE_STORAGE_PATH="$XDG_DATA_HOME"/docker-machine
# Ruby
export GEM_HOME="$XDG_DATA_HOME/gem"
export GEM_CONFIG="$XDG_CONFIG_HOME/gem/gemrc"
export IRBRC="$XDG_CONFIG_HOME/irb"
export RDOCRC="$XDG_DATA_HOME/rdoc"
# Npm
export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc
# Pyenv
export PYENV_ROOT=$XDG_DATA_HOME/pyenv
#Golang
export GOPATH="$XDG_DATA_HOME"/go
export GOMODCACHE="$XDG_CACHE_HOME"/go/mod

# Additional XDG cleanups from xdg-ninja
# Android
export ANDROID_USER_HOME="$XDG_DATA_HOME"/android
# Bash history
export HISTFILE="${XDG_STATE_HOME}"/bash/history
# CUDA
export CUDA_CACHE_PATH="$XDG_CACHE_HOME"/nv
# DotNet
export DOTNET_CLI_HOME="$XDG_DATA_HOME"/dotnet
# GnuPG
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
# Icons cursor path
export XCURSOR_PATH=/usr/share/icons:$XDG_DATA_HOME/icons
# Oh My Zsh
export ZSH="$XDG_DATA_HOME"/oh-my-zsh
# GNU Parallel
export PARALLEL_HOME="$XDG_CONFIG_HOME"/parallel
# Keras/TensorFlow
export KERAS_HOME="${XDG_STATE_HOME}/keras"
# Ren'Py
export RENPY_PATH_TO_SAVES="$XDG_DATA_HOME"
# Vagrant
export VAGRANT_HOME="$XDG_DATA_HOME"/vagrant
# Wine
export WINEPREFIX="$XDG_DATA_HOME"/wine
# Parallel 
export PARALLEL_HOME="$XDG_CONFIG_HOME"/parallel

# PATH additions for tools that need them
export PATH="$CARGO_HOME/bin:$PATH"
export PATH="$GEM_HOME/bin:$PATH"
export PATH="$PYENV_ROOT/bin:$PATH"
