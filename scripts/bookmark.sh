#!/usr/bin/sh
tmp=~/.bkmark
bookmarks=~/github/dotfiles/scripts/bookmarks.txt
sort $bookmarks | dmenu -l 10 > $tmp
[ -s $tmp ] && google-chrome-stable $(cat $tmp)
