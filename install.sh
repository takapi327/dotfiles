#!/bin/zsh

## sh エミュレーションモード
emulate -R sh

## シンボリックリンク
ln -nfs ~/dotfiles/.zshrc ~/.zshrc
source ~/.zshrc

## install brew
if ! which brew > /dev/null; then
  echo "[INFO] install brew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
else
  echo "[INFO] brew is already installed"
fi

## make directory .config
echo "[INFO] create config directory"
mkdir -p ~/.config

## install tmux
if ! which tmux > /dev/null; then
    echo "[INFO] install tmux"
    brew install tmux
    ln -nfs ~/dotfiles/.tmux.conf ~/.tmux.conf
else
    echo "[INFO] tmux is already installed"
fi

## install alacritty
if ! which alacritty > /dev/null; then
    echo "[INFO] install alacritty"
    brew cask install alacritty
    ln -nfs ~/dotfiles/alacritty ~/.config/alacritty
else
    echo "[INFO] alacritty is already installed"
fi

## install neovim
if ! which neovim > /dev/null; then
    echo "[INFO] install neovim"
    brew install neovim
    echo "[INFO] create nvim directory"
    mkdir -p ~/.config/nvim
    ln -nfs ~/dotfiles/nvim/init.vim ~/.config/nvim/init.vim
    ln -nfs ~/dotfiles/nvim/dein.vim ~/.config/nvim/dein.vim
    ln -nfs ~/dotfiles/nvim/lazy.vim ~/.config/nvim/lazy.vim
    echo "[INFO] create colors directory"
    mkdir -p ~/.config/nvim/colors
    ln -nfs ~/dotfiles/colors/hybrid.vim ~/.config/nvim/colors/hybrid.vim
else
    echo "[INFO] neovim is already installed"
fi
ln -nsf ~/dotfiles/.vim ~/.vim
ln -nsf ~/dotfiles/.vimrc ~/.vimrc
#ln -sf ~/dotfiles/.zshrc ~/.zshrc
#ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf
#chsh -s $(which zsh)
#source ~/dotfiles/.zshrc
