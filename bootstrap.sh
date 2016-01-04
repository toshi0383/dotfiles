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

install_additional_commands() {
    for i in tree lv
    do
        which $i > /dev/null
        if [ $? -ne 0 ];then
            echo -n "Installing ${i} ... "
            sudo apt-get --quiet install $i
            echo "done"
        fi
    done
}

copy .bashrc
copy .vimrc
copy .gitconfig

if [ "`uname -s`" == "Linux" ];then
    which setxkbmap > /dev/null
    if [ $? -ne 0 ];then
        sudo apt-get --quiet install setxkbmap
    fi
    copy .Xmodmap
fi

install_additional_commands

echo -e "${GREEN}Finished bootstrapping. Please restart your Terminal.${NORMAL}"

