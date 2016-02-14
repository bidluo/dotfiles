/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
brew install tmux nvim fish the_silver_searcher fish node
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf

