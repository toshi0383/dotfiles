SETTING_DIR=~/settings
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

# toshi0383
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
alias openprfor='~/settings/scripts/open-pull-request-for.sh'

alias gcl='git clone'

export PATH=~/github/markdown-resume/bin:$PATH

export GOPATH=~/gohome
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:~/settings/scripts
export PS1='\W $ '

export PATH=$PATH:/usr/local/lib/node_modules

# Setup for OS X
if [ "`uname -s`" == "Darwin" ];then
    # Xcode
    export PATH=$PATH:`xcode-select -p`/usr/bin
    export PATH="$HOME/.fastlane/bin:$PATH"
    alias xselp='xcode-select -p'
    alias xsels='sudo xcode-select -s'
    alias openx='open -a `xselp`/../..'
    alias fuckoff='sudo rm -rf /Applications/Xcode.app/'
    alias oproj='openx *proj'
    alias opace='openx *pace'
	alias uuid='~/Settings/scripts/printUUIDofMobileprovision.sh'
    alias size='${SCRIPTS_DIR}/pixelSize.sh'
    alias cmsdecrypt='security cms -D -i'
    alias plbuddy='/usr/libexec/PlistBuddy'

    # altool
    export PATH=$PATH:/Applications/Xcode.app/Contents/Applications/Application\ Loader.app/Contents/Frameworks/ITunesSoftwareService.framework/Versions/A/Support
    #$(dirname "$(find $(dirname $(xcode-select -p)) -name altool | head -1)")

    export DERIVED=~/Library/Developer/Xcode/DerivedData
    alias resetd='rm -rf $DERIVED/*'
    alias resetdd='resetd && fastlane snapshot reset_simulators'
	export SNAPSHOT_FORCE_DELETE=true
    alias disableats='$SCRIPTS_DIR/disableats.sh'

	export PATH=$PATH:`xcode-select -p`/../SharedFrameworks/DTDeviceKitBase.framework/Versions/A/Resources/

    # swift-protobuf
    export PATH=$PATH:/Users/toshi0383/.protoc/

    # Workaround for Sierra
    export GEM_HOME=$HOME/Software/ruby
    export PATH=$PATH:$GEM_HOME/bin
fi
