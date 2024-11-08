#!/bin/bash
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
NORMAL="\033[0;39m"

function checkStatus {
    status=$?
    if [ $status -ne 0 ];then
        echo "Encountered an error, aborting!" >&2
        echo $@
        exit $status
    fi
}

echo -en "${YELLOW}Initializing your environments in your OS `uname -s`. Are you sure ? (y/n):${NORMAL}"
read line

if [ $line != y ];then
    echo "Exiting..."
    exit 1;
fi

SSHKEY=~/.ssh/id_rsa
if [ ! -f $SSHKEY ];then
    echo -e "Generating ssh key... ${SSHKEY} with no passphrase"
    ssh-keygen -N "" -f ${SSHKEY}
    echo -e "${GREEN}Register this public key for GitHub.${NORMAL}"
fi

SETTING_DIR=~/settings
GITHUB_DIR=~/github
DOTFILES_DIR=$SETTING_DIR/dotfiles

if [ ! -e $SETTING_DIR ];then
    mkdir $SETTING_DIR
fi

if [ "`uname -s`" == "Linux" ];then
    PACKAGE_MANAGEMENT_COMMAND=apt-get
    INSTALL_PACKAGE_MANAGEMENT_COMMAND="echo apt-get not exists ?? That's weird.; exit 1"
    INSTALL_COMMAND="sudo ${PACKAGE_MANAGEMENT_COMMAND} --quiet install"
    UPDATE_COMMAND="sudo ${PACKAGE_MANAGEMENT_COMMAND} update"
    UPGRADE_COMMAND="sudo ${PACKAGE_MANAGEMENT_COMMAND} upgrade"
    NPM_INSTALL="sudo npm install -g"
    GO_GET="go get"
else
    PACKAGE_MANAGEMENT_COMMAND=brew
    INSTALL_PACKAGE_MANAGEMENT_COMMAND='/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
    INSTALL_COMMAND="${PACKAGE_MANAGEMENT_COMMAND} install"
    INSTALL_GUI_COMMAND="${PACKAGE_MANAGEMENT_COMMAND} install --cask"
    UPDATE_COMMAND="${PACKAGE_MANAGEMENT_COMMAND} update"
    UPGRADE_COMMAND="${PACKAGE_MANAGEMENT_COMMAND} upgrade"
    GEM_INSTALL="sudo gem install -N"
    NPM_INSTALL="npm install -g"
fi

make_sure_everything_is_up_to_date() {
    $UPDATE_COMMAND && $UPGRADE_COMMAND

    gibo update
}


copy() {
    if [ ! -e $DOTFILES_DIR ];then
        git clone https://github.com/toshi0383/dotfiles.git $DOTFILES_DIR
    fi
    echo -n "Copying ${1} ... "
    cp -R $DOTFILES_DIR/${1} ~/${1}
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
        checkStatus $INSTALL_PACKAGE_MANAGEMENT_COMMAND
    fi
    $UPDATE_COMMAND

    ## NOTE: mac2unix comes with dos2unix
    for i in tree lv dos2unix jq
    do
        which $i > /dev/null
        if [ $? -ne 0 ];then
            echo -n "Installing ${i} ... "
            $INSTALL_COMMAND ${i}
            echo "done"
        fi
    done

    if [ "`uname -s`" == "Darwin" ];then
        $INSTALL_COMMAND hub
        $INSTALL_COMMAND chisel
        $INSTALL_COMMAND coreutils
        $INSTALL_COMMAND git
        $INSTALL_COMMAND git-lfs
        $INSTALL_COMMAND ghi
        $INSTALL_COMMAND ffmpeg
        $INSTALL_COMMAND gibo
        $INSTALL_COMMAND cloc
        $INSTALL_COMMAND gnu-sed
        $INSTALL_COMMAND gawk
        $INSTALL_COMMAND fd
        $INSTALL_COMMAND imagemagick
        $INSTALL_COMMAND vim
        $INSTALL_COMMAND pass
        $INSTALL_COMMAND rbenv
        $INSTALL_COMMAND tmux
        $INSTALL_COMMAND fzf
        $INSTALL_COMMAND gh
        #$INSTALL_COMMAND go
        #$GEM_INSTALL bundler
        $GEM_INSTALL gist
        #$GEM_INSTALL cocoapods
        $INSTALL_GUI_COMMAND iterm2
        $INSTALL_COMMAND mint
        #$INSTALL_COMMAND carthage
        #$INSTALL_COMMAND xcodegen
        #$INSTALL_COMMAND kotlin
        #$INSTALL_COMMAND ghc cabal-install stack
        curl -L https://iterm2.com/misc/install_shell_integration.sh | bash

        # Workaround:
        #   https://github.com/go-jira/jira/issues/291#issuecomment-554742540
        #GO111MODULE=on $GO_GET github.com/go-jira/jira/cmd/jira

        # NERDTree for vim: WORKAROUND: install via ~/.vim/rc/dein.toml failed
        git clone https://github.com/scrooloose/nerdtree.git ~/.vim/pack/vendor/start/nerdtree
        vim -u NONE -c "helptags ~/.vim/pack/vendor/start/nerdtree/doc" -c q

        #$INSTALL_GUI_COMMAND android-studio
        $INSTALL_GUI_COMMAND google-chrome
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
    mkdir -p ~/.vim/rc
}

setup_cmdshelf() {
    if [ "`uname -s`" == "Darwin" ];then
        brew install cmdshelf
        cmdshelf remote add toshi0383 git@github.com:toshi0383/scripts.git
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

# dependency: git
copy_dotfiles_ifneeded() {
    copy .bashrc
    copy .lldbinit
    copy .vimrc
    copy .vim
    copy .gitconfig
}

touch_bash_profile() {
    if [ ! -f ~/.bash_profile ];then
        echo "source ~/.bashrc" > ~/.bash_profile
    fi
}

configure_mac() {
    if [ "`uname -s`" == "Darwin" ];then
        # Hot corners
        # Possible values:
        #  0: no-op
        #  2: Mission Control
        #  3: Show application windows
        #  4: Desktop
        #  5: Start screen saver
        #  6: Disable screen saver
        #  7: Dashboard
        # 10: Put display to sleep
        # 11: Launchpad
        # 12: Notification Center
        # Top left screen corner → Desktop
        defaults write com.apple.dock wvous-tl-corner -int 4
        defaults write com.apple.dock wvous-tl-modifier -int 0
        # Top right screen corner → Put display to sleep
        defaults write com.apple.dock wvous-tr-corner -int 5
        defaults write com.apple.dock wvous-tr-modifier -int 0
    fi
}

if [ "`uname -s`" == "Linux" ];then
    which setxkbmap > /dev/null
    if [ $? -ne 0 ];then
        sudo apt-get --quiet install setxkbmap
    fi
    copy .Xmodmap
fi

if [ "`uname -s`" == "Darwin" ];then
    echo -e "${NORMAL}Bootstrapping starting. Download and install additional tools below manually.${NORMAL}"
    echo -e "${NORMAL}xcodebuild CLI tools might be required by some tools installation, so hurry!${NORMAL}"
    echo -e "${NORMAL}- [Xcode] https://developer.apple.com/download/more${NORMAL}"
    echo -e "${NORMAL}- [TotalSpaces2] https://totalspaces.binaryage.com${NORMAL}"
    echo -e "${NORMAL}- [gitup] http://gitup.co${NORMAL}"
    echo -e "${NORMAL}I open URLs for you.${NORMAL}"
    open https://totalspaces.binaryage.com http://gitup.co https://developer.apple.com/download/more
fi

uninstall_apps

# Needs to precede install_additional_commands
touch_bash_profile

install_additional_commands

get_rid_of_vim_tiny

setup_dirs

setup_cmdshelf

copy_dotfiles_ifneeded

# install_java

# git clone git@github.com:there4/markdown-resume.git $GITHUB_DIR/markdown-resume

make_sure_everything_is_up_to_date

configure_mac

echo -e "${GREEN}Finished bootstrapping. Please restart your Terminal.${NORMAL}"
echo -e "${GREEN}You might need to fixup directory permissions for brew or brew-cask to work.${NORMAL}"
echo -e "${GREEN}Good Luck !${NORMAL}"

