#!/bin/env bash

# base-install script for new Linux builds
# Run this after installing Git. See below.
# inspiration from https://github.com/victoriadrake/dotfiles

# Pre-requisites:
# 1. Install Git
# 2. Generate an ssh key
# 3. Start ssh-agent and add ssh key
# 3. Add ssh key to GitHub

echo "*** UPDATE MACHINE ***\n"
# Update and get standard repository programs
# sudo apt update && sudo apt full-upgrade -y

echo "*** ADD GITHUB FINGERPRINT TO KNOWN HOSTS ***"
if ! grep github.com ~/.ssh/known_hosts > /dev/null
then
     echo "github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl" >> ~/.ssh/known_hosts
fi

echo "*** SET GIT CONFIGS ***i\n"
git config --global user.email "21221061+everlongtrail@users.noreply.github.com"
git config --global user.name "Eric Allard"

# Pull down .dotfiles from GitHub (everlongtrail/.dotfiles)
git clone --bare git@github.com:everlongtrail/.dotfiles.git $HOME/.dotfiles
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
function config {
   /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
}
mkdir -p .config-backup
config checkout
if [ $? = 0 ]; then
  echo "Checked out config.";
  else
    echo "Backing up pre-existing dot files.";
    config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .config-backup/{}
fi;
config checkout
config config status.showUntrackedFiles no

function install {
  which $1 &> /dev/null

  if [ $? -ne 0 ]; then
    echo "*** Installing: ${1}..."
    sudo apt install -y $1
  else
    echo "*** Already installed: ${1}"
  fi
}

# Basics
install neovim
install zsh
install docker.io



# don't change shell yet. do that later after you figure out how to setup your .dotfiles and have your .zshrc
# chsh -s $(which zsh)
