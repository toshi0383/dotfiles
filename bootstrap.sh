#!/bin/bash
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
NORMAL="\033[0;39m"

echo -en "${YELLOW}Initializing your environments in your OS `uname -s`. Are you sure ? (y/n):${NORMAL}"
read line

if [ $line != y ];then
    echo "Exiting..."
    exit 1;
fi

SSHKEY=~/.ssh/id_rsa.pub
if [ ! -f $SSHKEY ];then
    echo -e "${RED}${SSHKEY} does not exist. Make sure you generate ssh-key before cloning GitHub repos.${NORMAL}"
    echo "Exiting..."
    exit 1;
fi

if [ "`uname -s`" == "Linux" ];then
    INSTALL_COMMAND="sudo apt-get --quiet install"
    UPDATE_COMMAND="sudo apt-get update"
    UPGRADE_COMMAND="sudo apt-get upgrade"
    NPM_INSTALL="sudo npm install -g"
else
    INSTALL_COMMAND="brew install"
    UPDATE_COMMAND="brew update"
    UPGRADE_COMMAND="brew upgrade"
    GEM_INSTALL="sudo gem install"
    NPM_INSTALL="npm install -g"
fi

make_sure_everything_is_up_to_date() {
    $UPDATE_COMMAND && $UPGRADE_COMMAND
}


copy() {
    echo -n "Copying ${1} ... "
    cp $PWD/${1} ~/${1}
    echo "done"
}

uninstall_libreoffice() {
    if [ "`uname -s`" == "Linux" ];then
        #sudo apt-get remove --purge libreoffice 4.2*
        sudo apt-get remove --purge libreoffice-core
        sudo apt-get autoremove
    fi
}

install_additional_commands() {
    $UPDATE_COMMAND
    for i in tree lv dos2unix npm hub
    do
        which $i > /dev/null
        if [ $? -ne 0 ];then
            echo -n "Installing ${i} ... "
            $INSTALL_COMMAND ${i}
            echo "done"
        fi
    done

    $NPM_INSTALL gh

    if [ "`uname -s`" == "Darwin" ];then
        GEM_INSTALL fastlane
        GEM_INSTALL sigh
    fi
}

get_rid_of_vim_tiny() {
    if [ "`uname -s`" == "Linux" ];then
        $INSTALL_COMMAND vim
    fi
}

setup_dirs() {
    mkdir ~/github
    mkdir -p ~/dev/tmp
}

install_swift() {
    echo -en "${YELLOW}Install Swift ?(y/n):${NORMAL}"
    read line
    if [ $line != "y" ];then
        return
    fi
    git clone git@github.com:apple/swift.git ~/github/swift
    if [ "`uname -s`" == "Linux" ];then
        source ./install_swift_dependencies_for_linux.sh
        install_swift_dependencies_for_ubuntu
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

uninstall_libreoffice

install_additional_commands

get_rid_of_vim_tiny

setup_dirs

install_swift

make_sure_everything_is_up_to_date

echo -e "${GREEN}Finished bootstrapping. Please restart your Terminal.${NORMAL}"

