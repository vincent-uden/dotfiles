#!/usr/bin/bash


echo "Backing up and writing new NeoVim config files"

mkdir -p ~/.config/backup
cp -r ~/.config/nvim ~/.config/backup/nvim

rm -rf ~/.config/nvim
cp -r ./nvim ~/.config/

echo -e 'Please open NeoVim and run \033[0;34m:PlugInstall\033[0m'
