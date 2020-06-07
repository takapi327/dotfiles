#!/bin/zsh

ln -sf ~/dotfiles/.zshrc ~/.zshrc
chsh -s $(which zsh)
source ~/dotfiles/.zshrc
