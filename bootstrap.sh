#!/bin/bash
GREEN="\033[32m"
YELLOW="\033[33m"
NORMAL="\033[0;39m"
echo -en "${YELLOW}Initializing your dotfiles in your OS `uname -s`. Are you sure ? (y/n):${NORMAL}"

read line

if [ $line != y ];then
    echo "Exiting..."
    exit 1;
fi

copy() {
    echo -n "Copying ${1} ... "
    cp $PWD/${1} ~/${1}
    echo "done"
}

copy .bashrc
copy .vimrc
copy .gitconfig

if [ "`uname -s`" == "Linux" ];then
    copy .Xmodmap
    which setxkbmap > /dev/null
    if [ $? -ne 0 ];then
        echo "Installing setxkbmap as root"
        sudo apt-get install setxkbmap
    fi
fi

echo -e "${GREEN}Finished bootstrapping. Please restart your Terminal.${NORMAL}"

