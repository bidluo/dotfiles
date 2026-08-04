#! /bin/bash

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Install fish and OMF
brew install fish
curl -L https://get.oh-my.fish | fish

# Install tmux
brew install tmux
ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf
~/.tmux/plugins/tpm/scripts/install_plugins.sh

# Install neovim
brew install neovim
mkdir -p ~/.config/nvim
ln -s ~/dotfiles/config/nvim/init.vim ~/.config/nvim/init.vim
# Plug install

# Install ag
brew install ag
gem install solargraph


#install font
# install terminal config
# Install gotop
brew tap cjbassi/gotop
brew install gotop
# Install 
