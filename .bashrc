SETTING_DIR=~/settings

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
alias mkdir='mkdir -p'

function waitp {
    lsof -p $(ps | grep "${1:?}" | grep -v "grep ${1:?}" | head -1 | awk '{print $1}') +r 2 > /dev/null 2>&1
}

# git
alias g='git'
alias gasw="git add *.swift"
alias gago="git add *.go"
alias gap="git add -p"
alias gbr='git branch'
alias gbra='git branch -a'
alias gc='git commit'
alias gcm='git commit -m'
alias gd='git diff'
alias gdc='git diff --cached'
alias gcal="gcal -H '\e[30;47m:\e[0m:\e[30;31m:\e[0m' -q JP"
alias gcam="git commit --amend"
alias gs='git status'
alias gshow='git show'
alias gst='git stash'
alias gstp='git stash pop'
alias gsubu='git submodule update --init -f'

function ginit() {
    git init
    cat >> .gitignore << EOF
.DS_Store/
*.swp
EOF
}

# kubernetes
source $HOME/.kubectl_aliases
alias kgd='kubectl get deploy'
alias kge='kubectl get event'
alias kgew='kubectl get event -w'
alias ke='kubectl edit'
alias ked='kubectl edit deploy'

export EDITOR=vi
function viconflicts {
    vi `git status | grep 'both modified' | awk -F: '{print $2}'`
}

# toshi0383
alias gs='git status'
alias gc='git commit'
alias ga='git add'
alias gp='git pull'
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

alias gcl='git clone'
alias yyyymmdd='date +%Y-%m-%d'
alias unixtime='date +%s'

function vggl {
    vim `git grep -l $1 $2`
}

alias vn='vim -c NERDTree'
function vnfd {
    vim -c "NERDTree" `fd "$1" | head -1`
}

export PATH=~/github/markdown-resume/bin:$PATH

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
    alias oproj='openx *xcodeproj'
    alias opace='openx *xcworkspace'
    alias cmsdecrypt='security cms -D -i'
    alias plbuddy='/usr/libexec/PlistBuddy'

    # altool
    export PATH=$PATH:/Applications/Xcode.app/Contents/Applications/Application\ Loader.app/Contents/Frameworks/ITunesSoftwareService.framework/Versions/A/Support
    #$(dirname "$(find $(dirname $(xcode-select -p)) -name altool | head -1)")

    export DERIVED=~/Library/Developer/Xcode/DerivedData
    alias resetd='rm -rf $DERIVED/*'
    alias resetdd='resetd && fastlane snapshot reset_simulators'
	export SNAPSHOT_FORCE_DELETE=true

	export PATH=$PATH:`xcode-select -p`/../SharedFrameworks/DTDeviceKitBase.framework/Versions/A/Resources

    # swift-protobuf
    export PATH=$PATH:/Users/toshi0383/.protoc

    # Workaround for Sierra
    export GEM_HOME=$HOME/Software/ruby
    export PATH=$PATH:$GEM_HOME/bin

    # cmdshelf
    alias run='cmdshelf run'
    alias list='cmdshelf list'
    alias approve='cmdshelf run github/pr-approve'
    alias design='cmdshelf run design/init_design.sh'

    # bash-completion
    if [ -f /usr/local/share/bash-completion/bash_completion ]; then
        . /usr/local/share/bash-completion/bash_completion
    fi
    # bash_completion.d
    for f in $(ls /usr/local/etc/bash_completion.d/); do source /usr/local/etc/bash_completion.d/$f; done

    alias sort-by-last="awk '{print \$NF,\$0 }' | sort -nr | cut -d ' ' -f 2-"

    # gvm
    [[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"
    function gvmu {
        gvm use $1 || return
        export GOPATH=$HOME/gohome
    }

    export GOPATH=$HOME/gohome
    export GOBIN=$GOPATH/bin
    export PATH=$PATH:$GOPATH/bin

    # gcloud
    GCLOUD_BASH_COMPETION=/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc
    GCLOUD_PATH=/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc
    [[ -s $GCLOUD_BASH_COMPETION ]] && source $GCLOUD_BASH_COMPETION
    [[ -d $GCLOUD_PATH ]] && export PATH=$PATH:$GCLOUD_PATH
fi

function command_not_found_handle(){
  if [ -e /usr/local/bin/imgcat ];then
    if [ -f ~/Documents/rivai-small.jpg ];then
      /usr/local/bin/imgcat ~/Documents/rivai-small.jpg
    fi
  fi
  echo "$1?"
  echo "全然なってない。全部やり直せ。"
}

alias cdstream='cd /Library/WebServer/Documents/stream'
