#!/bin/bash
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
NORMAL="\033[0;39m"

source ./util.sh

echo -en "${YELLOW}Initializing your environments in your OS `uname -s`. Are you sure ? (y/n):${NORMAL}"
read line

if [ $line != y ];then
    echo "Exiting..."
    exit 1;
fi

SSHKEY=~/.ssh/id_rsa.pub
if [ ! -f $SSHKEY ];then
    echo -e "Generating ssh key... ${SSHKEY} with no passphrase"
    ssh-keygen -N "" -f ${SSHKEY}
    echo -e "${GREEN}Regist this public key for GitHub.${NORMAL}"
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
    INSTALL_PACKAGE_MANAGEMENT_COMMAND='/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"'
    INSTALL_COMMAND="${PACKAGE_MANAGEMENT_COMMAND} install"
    INSTALL_GUI_COMMAND="sudo ${PACKAGE_MANAGEMENT_COMMAND} cask install"
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
        echo "${INSTALL_PACKAGE_MANAGEMENT_COMMAND}" | bash
        checkStatus INSTALL_PACKAGE_MANAGEMENT_COMMAND
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
        $INSTALL_COMMAND swiftgen
        $INSTALL_COMMAND carthage
        $INSTALL_COMMAND coreutils
        $INSTALL_COMMAND git
        $INSTALL_COMMAND ghi
        $INSTALL_COMMAND gibo
        $INSTALL_COMMAND cloc
        $INSTALL_COMMAND ninja
        #$INSTALL_GUI_COMMAND android-studio
        $INSTALL_GUI_COMMAND iterm2
        $INSTALL_GUI_COMMAND google-chrome
        $GEM_INSTALL fastlane
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
    git clone git@github.com:apple/swift.git $GITHUB_DIR/swift
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


if [ ! -d $SETTING_DIR ];
    mkdir $SETTING_DIR
    cd $SETTING_DIR
fi
if [ ! -d $SETTING_DIR/dotfiles ];
    git clone git@github.com:toshi0383/dotfiles.git
fi
cd $SETTING_DIR/dotfiles

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

git clone git@github.com:there4/markdown-resume.git $GITHUB_DIR/markdown-resume

make_sure_everything_is_up_to_date

echo -e "${GREEN}Finished bootstrapping. Please restart your Terminal.${NORMAL}"
echo -e "${GREEN}You might need to fixup directory permissions for brew or brew-cask to work.${NORMAL}"
echo -e "${GREEN}Good Luck !${NORMAL}"

