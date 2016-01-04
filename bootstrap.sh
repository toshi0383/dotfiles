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

if [ "`uname -s`" == "Linux" ];then
    INSTALL_COMMAND="sudo apt-get --quiet install"
else
    INSTALL_COMMAND="brew install"
fi

copy() {
    echo -n "Copying ${1} ... "
    cp $PWD/${1} ~/${1}
    echo "done"
}

install_additional_commands() {
    for i in tree lv dos2unix
    do
        which $i > /dev/null
        if [ $? -ne 0 ];then
            echo -n "Installing ${i} ... "
            $INSTALL_COMMAND ${i}
            echo "done"
        fi
    done
}

get_rid_of_vim_tiny() {
    if [ "`uname -s`" == "Linux" ];then
        $INSTALL_COMMAND vim
    fi
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

get_rid_of_vim_tiny

echo -e "${GREEN}Finished bootstrapping. Please restart your Terminal.${NORMAL}"

