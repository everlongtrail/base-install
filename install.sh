#!/bin/env bash

# base-install script for new Linux builds
# Run this after installing Git. See below.
# inspiration from https://github.com/victoriadrake/dotfiles

# Pre-requisites:
# 1. Install Git
# 2. Generate an ssh key
# 3. Start ssh-agent and add ssh key
# 3. Add ssh key to GitHub

# Update and get standard repository programs
sudo apt update && sudo apt full-upgrade -y

git config --global user.email "21221061+everlongtrail@users.noreply.github.com"
git config --global user.name "Eric Allard"

# Pull down .dotfiles from GitHub (everlongtrail/.dotfiles)
git clone --bare git@github.com:everlongtrail/.dotfiles.git $HOME/.dotfiles

function install {
  which $1 &> /dev/null

  if [ $? -ne 0 ]; then
    echo "Installing: ${1}..."
    sudo apt install -y $1
  else
    echo "Already installed: ${1}"
  fi
}

# Basics
install neovim
install zsh
install docker.io



# don't change shell yet. do that later after you figure out how to setup your .dotfiles and have your .zshrc
# chsh -s $(which zsh)
