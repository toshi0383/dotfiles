SETTING_DIR=~/Settings
SCRIPTS_DIR=$SETTING_DIR/scripts

if [ "`uname -s`" == "Linux" ];then
    alias update='sudo apt-get update ; sudo npm update -g'
else
    alias update='brew update && brew upgrade ; sudo gem update -N && sudo gem cleanup ; npm update -g'
fi

if [ "`uname -s`" == "Linux" ];then
    alias ll='ls -l --time-style="posix-iso"'
    alias tt='gnome-terminal'
    setxkbmap -option "ctrl:swapcaps"
    xmodmap ~/.Xmodmap
else
    alias ll='ls -l'
fi
alias lrt='ll -rt'
alias g='git'

export EDITOR=vi

# alias javac='javac -J-Duser.language=en'

MAIN_BRANCH=

alias devp='git checkout $MAIN_BRANCH'
alias devp='git checkout $MAIN_BRANCH && git pull --ff-only'
alias pu='g pu'
alias puf='g pu -f'
alias pr='hub pull-request'
alias pupr='pu && pr'
alias pufpr='puf && pr'
alias pru='hub pull-request -b upstream/master'
alias pupru='g pu && pru'
alias prl='gh pr'
alias prlu='gh pr --remote upstream'
alias pro='gh pr -B '
alias prou='gh pr --remote upstream -B '
alias ghio='ghi show --web'
alias openprfor='~/Settings/scripts/open-pull-request-for.sh'

alias gcl='git clone'

export PATH=~/github/markdown-resume/bin:$PATH

export GOPATH=~/gohome
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:~/Settings/scripts
export PS1='\W $ '

export PATH=$PATH:/usr/local/lib/node_modules

# Setup for OS X
if [ "`uname -s`" == "Darwin" ];then
    # Xcode
    export PATH=$PATH:`xcode-select -p`/usr/bin
    alias xselp='xcode-select -p'
    alias xsels='sudo xcode-select -s'
    alias openx='open -a `xselp`/../..'
    alias fuckoff='sudo rm -rf /Applications/Xcode.app/'
    alias oproj='openx *proj'
    alias opace='openx *pace'
	alias uuid='~/Settings/scripts/printUUIDofMobileprovision.sh'
    alias size='${SCRIPTS_DIR}/pixelSize.sh'

    # for new Swift
    #export PATH=/Library/Developer/Toolchains/swift-latest.xctoolchain/usr/bin:$PATH

    #eval "$(hub alias -s)"

    # altool
    export PATH=$PATH:/Applications/Xcode.app/Contents/Applications/Application\ Loader.app/Contents/Frameworks/ITunesSoftwareService.framework/Versions/A/Support
    #$(dirname "$(find $(dirname $(xcode-select -p)) -name altool | head -1)")

    # swiftenv
    #export SWIFTENV_ROOT=~/.swiftenv
    #export PATH=$SWIFTENV_ROOT/bin:$PATH
    #eval $(swiftenv init -)

    alias objc2swift='java -jar /Users/toshi0383/github/objc2swift/build/libs/objc2swift-1.0.jar'

    export DERIVED=~/Library/Developer/Xcode/DerivedData
    alias resetd='rm -rf $DERIVED/*'
    alias resetdd='resetd && snapshot reset_simulators'
	export SNAPSHOT_FORCE_DELETE=true
    alias disableats='$SCRIPTS_DIR/disableats.sh'

fi
