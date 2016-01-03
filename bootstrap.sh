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

