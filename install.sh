#!/bin/env bash

# base-install: a script for new Linux builds
# call install.sh from $HOME after installing Git. See below.

# Pre-requisites:
# 1. Install Git
# 2. Generate an ssh key
# 3. Start ssh-agent and add ssh key
# 3. Add ssh key to GitHub

echo "*** UPDATE MACHINE ***"
# Update and get standard repository programs
apt update -y

echo "*** ADD GITHUB FINGERPRINT TO KNOWN HOSTS ***"
if ! grep github.com ~/.ssh/known_hosts > /dev/null
then
     echo "github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl" >> ~/.ssh/known_hosts
fi

echo "*** SET GIT CONFIGS ***"
git config --global user.email "21221061+everlongtrail@users.noreply.github.com"
git config --global user.name "Eric Allard"

# Pull down .dotfiles from GitHub (everlongtrail/.dotfiles)
echo "*** PULL DOWN DOTFILES ***"
git clone --bare git@github.com:everlongtrail/.dotfiles.git $HOME/.dotfiles
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
config push --set-upstream origin master

# Install apps
function install {
  which $1 &> /dev/null

  if [ $? -ne 0 ]; then
    echo "*** Installing: ${1}..."
    sudo apt install -y $1
  else
    echo "*** Already installed: ${1}"
  fi
}

echo "*** INSTALLING APPS ***"
install neovim
install zsh
install docker.io

chsh -s $(which zsh)
