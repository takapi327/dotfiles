#!/bin/zsh

ln -sf ~/dotfiles/.vim ~/.vim
ln -sf ~/dotfiles/.vimrc ~/.vimrc
ln -sf ~/dotfiles/.zshrc ~/.zshrc
chsh -s $(which zsh)
source ~/dotfiles/.zshrc
