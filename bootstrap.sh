#!/bin/bash
echo -n "Initializing your dotfiles in your OS `uname -s`. Are you sure ? (y/n):"
read line
if [ $line != y ];then
    echo "Exiting..."
    exit 1;
fi
cp $PWD/.bashrc ~/.bashrc
cp $PWD/.vimrc ~/.vimrc
cp $PWD/.gitconfig ~/.gitconfig

if [ "`uname -s`" == "Linux" ];then
    cp $PWD/.Xmodmap ~/.Xmodmap
    which setxkbmap > /dev/null
    if [ $? -ne 0 ];then
        sudo apt-get install setxkbmap
    fi
fi

