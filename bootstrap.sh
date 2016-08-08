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

SETTING_DIR=~/Settings
SCRIPTS_DIR=$SETTING_DIR/scripts
GITHUB_DIR=~/github

if [ "`uname -s`" == "Linux" ];then
    PACKAGE_MANAGEMENT_COMMAND=apt-get
    INSTALL_PACKAGE_MANAGEMENT_COMMAND="echo apt-get not exists ?? That's weird.; exit 1"
    INSTALL_COMMAND="sudo ${PACKAGE_MANAGEMENT_COMMAND} --quiet install"
    UPDATE_COMMAND="sudo ${PACKAGE_MANAGEMENT_COMMAND} update"
    UPGRADE_COMMAND="sudo ${PACKAGE_MANAGEMENT_COMMAND} upgrade"
    NPM_INSTALL="sudo npm install -g"
else
    PACKAGE_MANAGEMENT_COMMAND=brew
    INSTALL_PACKAGE_MANAGEMENT_COMMAND="/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    INSTALL_COMMAND="${PACKAGE_MANAGEMENT_COMMAND} install"
    UPDATE_COMMAND="${PACKAGE_MANAGEMENT_COMMAND} update"
    UPGRADE_COMMAND="${PACKAGE_MANAGEMENT_COMMAND} upgrade"
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

uninstall_apps() {
    if [ "`uname -s`" == "Linux" ];then
        #sudo apt-get remove --purge libreoffice 4.2*
        sudo apt-get remove --purge libreoffice-core
        sudo apt-get remove unity-webapps-common
        sudo apt-get autoremove
    fi
}

install_additional_commands() {
    if [ ! `which ${PACKAGE_MANAGEMENT_COMMAND}` ];then
        ${INSTALL_PACKAGE_MANAGEMENT_COMMAND}
    fi
    $UPDATE_COMMAND
    for i in tree lv dos2unix npm jq
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
        $INSTALL_COMMAND hub
        $INSTALL_COMMAND swiftlint
        $INSTALL_COMMAND carthage
        $INSTALL_COMMAND coreutils
        $GEM_INSTALL fastlane
        $GEM_INSTALL sigh
    fi
}

get_rid_of_vim_tiny() {
    if [ "`uname -s`" == "Linux" ];then
        $INSTALL_COMMAND vim
    fi
}

setup_dirs() {
    mkdir -p $GITHUB_DIR
    mkdir -p ~/dev/tmp
    mkdir -p $SCRIPTS_DIR
}

clone_my_scripts() {
    git clone git@github.com:toshi0383/scripts.git $SCRIPTS_DIR
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

install_java() {
    if [ "`uname -s`" != "Linux" ];then
        return;
    fi
    echo -en "${YELLOW}Install Java ?(y/n):${NORMAL}"
    read line
    if [ $line != "y" ];then
        return
    fi
    sudo add-apt-repository ppa:webupd8team/java
    sudo apt-get update
    sudo apt-get install oracle-java8-installer
    sudo apt-get install oracle-java8-set-default
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

uninstall_apps

install_additional_commands

get_rid_of_vim_tiny

setup_dirs

clone_my_scripts

# install_swift

install_java

make_sure_everything_is_up_to_date

echo -e "${GREEN}Finished bootstrapping. Please restart your Terminal.${NORMAL}"

