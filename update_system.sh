#!/usr/bin/bash


echo "Backing up and writing new NeoVim config files"

mkdir -p ~/.config/backup
cp -r ~/.config/nvim ~/.config/backup/nvim
cp -r ~/.config/hypr ~/.config/backup/hypr
cp -r ~/.config/waybar ~/.config/backup/waybar
cp -r ~/.zshrc  ~/.config/backup/.zshrc
cp -r ~/.tmux.conf  ~/.config/backup/.tmux.conf

echo -e 'Please open NeoVim and run \033[0;34m:PlugInstall\033[0m'

rm -rf ~/.config/nvim
cp -r ./nvim ~/.config/

if ! [ -d ~/.oh-my-zsh ]; then
    echo "Please make sure oh-my-zsh is installed using:"
    echo 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"'
fi

rm  ~/.zshrc
cp -r ./zshrc ~/.zshrc

rm ~/.tmux.conf
cp -r ./tmux.conf ~/.tmux.conf


rm ~/.config/hypr
cp -r ./hypr ~/.config/hypr

rm ~/.config/waybar/
cp -r ./waybar ~/.config/waybar
