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

# パイプのみ対応
function str2unicode {
    while read -N1 c; do d=$(echo -n "$c" | iconv -t UCS-2BE | xxd -p); if [[ "$d" == "fffd" ]]; then echo -n "$c" | iconv -t UCS-4BE | xxd -p | xargs printf '\\U%s'; else printf '\\u%s' $d; fi; done
    echo
}

# 指定した番号のPRがマージ可能になったらマージする。
#
# gh pr merge --autoがうまく動いてないので自前polling
# https://github.com/cli/cli/issues/3514
function autoMerge {
    num=${1:?}
    while true
    do
        STATUS=$(
            gh pr status --json mergeStateStatus,number \
                | jq ".createdBy | map(select(.number == ${num}))[0].mergeStateStatus" \
                | sed 's/\"//g'
        )

        if [ "$STATUS" != "CLEAN" ]; then
            echo "Waiting for mergeStateStatus to be CLEAN..."
        else
            gh pr merge --merge $num
            break
        fi
        sleep 30
    done
}

function waitp {
    pid=$(ps | grep "${1:?}" | grep -v "grep ${1:?}" | head -1 | awk '{print $1}')
    if [ -z $pid ]; then
        return
    fi
    lsof -p ${pid:?} +r 2 > /dev/null 2>&1
}

# fbr - checkout git branch (including remote branches)
fbr() {
  local branches branch
  branches=$(git branch --all | grep -v HEAD) &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# ftree - git commit browser
ftree() {
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
      --bind "ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
FZF-EOF"
}

vf() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type f -print 2> /dev/null | fzf +m) &&
  vi "$dir"
}

# git
alias g='git'
alias gasw="git add *.swift"
alias gakt="git add *.kt"
alias gaxml="git add *.xml"
alias gaxib="git add *.xib"
alias gaproj="git add *proj"
alias gdsw="git diff *.swift"
alias gdcsw="git diff --cached *.swift"
alias gapsw="git add -p *.swift"
alias gago="git add *.go"
alias gap="git add -p"
alias gbr='git branch'
alias gbra='git branch -a'
alias gc='git commit'
alias gcm='git commit -m'
alias gd='git diff'
alias gdc='git diff --cached'
alias gfa='git fa'
alias gcal="gcal -H '\e[30;47m:\e[0m:\e[30;31m:\e[0m' -q JP"
alias gcam="git commit --amend"
alias gs='git status'
alias gshow='git show'
alias gshowname='git show --name-only'
alias gst='git stash'
alias gstp='git stash pop'
alias gsubm-f='git submodule update --init -f'
function nbex() {
    nb export ${1} prmsg-${1}.md
}

function copr() {
    git fetch origin pull/${1}/head:${1}
    git checkout $1
}

alias matrix='while true; do uuidgen; sleep 0.01; done | xxd -c 40'

## ffmpeg
function concat_images() {
    ffmpeg -i ${1:?} -i ${2:?} -filter_complex \
        "[0][1]scale2ref='oh*mdar':'if(lt(main_h,ih),ih,main_h)'[0s][1s];
            [1s][0s]scale2ref='oh*mdar':'if(lt(main_h,ih),ih,main_h)'[1s][0s];
            [0s][1s]hstack" ${3:?}
}

function gclobbertags() {
    git fetch --tag 2>&1 | grep rejected | awk '{print $3}' | xargs git tag -d
}

function ginit() {
    git init
    cat >> .gitignore << EOF
.DS_Store/
*.swp
EOF
}

export EDITOR=vim
function viconflicts {
    vi `git status | grep 'both modified' | awk -F: '{print $2}'`
}
function vimodified {
    vi `git status | grep 'modified' | awk -F: '{print $2}'`
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
alias timer='d=`date +%s`; while true; do sleep 1; expr `date +%s` - $d; done'

function vggl {
    vim `git grep -l $1 $2`
}

alias vn='vim -c NERDTree'
function vifd {
    vim "`fd $1 | head -1`"
}
function vnfd {
    vim -c "NERDTree" `fd "$1" | head -1`
}

export PS1='\W $ '


# Setup for OS X
if [ "`uname -s`" == "Darwin" ];then
    # Xcode
    export PATH="/opt/homebrew/bin:$PATH"
    export PATH=$PATH:`xcode-select -p`/usr/bin
    export PATH="$HOME/.fastlane/bin:$PATH"
    export PATH="$PATH:~/dev/flutter/bin/"

    alias xselp='xcode-select -p'
    alias xsels='sudo xcode-select -s'
    alias openx='open -a `xselp`/../..'
    alias oproj='openx *xcodeproj'
    alias opace='openx *xcworkspace'
    alias cmsdecrypt='security cms -D -i'
    alias plbuddy='/usr/libexec/PlistBuddy'
    alias notifyme='echo "display notification with title \"done\" sound name \"Beep\"" | /usr/bin/osascript'

    # altool
    export PATH=$PATH:/Applications/Xcode.app/Contents/Applications/Application\ Loader.app/Contents/Frameworks/ITunesSoftwareService.framework/Versions/A/Support
    #$(dirname "$(find $(dirname $(xcode-select -p)) -name altool | head -1)")

    # sips
    function convertToJPEG {
        sips --setProperty format jpeg $1 --out `echo $1 | gsed -rn 's/(.*)\..*/\1.jpg/p'`
    }

    export DERIVED=~/Library/Developer/Xcode/DerivedData
    alias removeDerived='rm -rf $DERIVED/*'
    alias removeSimulators='rm -rf ~/Library/Logs/CoreSimulator/* && rm -rf ~/Library/Developer/CoreSimulator/Devices/*'

    function removeCaches() {
        rm -rf $DERIVED/*
        rm -rf `brew --cache`
        rm -rf ~/Library/Caches/org.carthage.CarthageKit/
        rm -rf ~/Library/Caches/CocoaPods/
        rm -rf ~/Library/Developer/CoreSimulator/Caches/*
        rm -rf ~/Library/Developer/Xcode/iOS\ Device\ Logs/*
        rm -rf ~/Library/Developer/CoreSimulator/Devices/**/data/Library/Caches/*
        rm -rf ~/.android/cache
        rm -rf ~/.gradle/caches
        rm -rf ~/work/and/.gradle

        # Simulatorを個別にダウンロードした場合に溜まってる
        rm -rf ~/Library/Caches/com.apple.dt.Xcode/Downloads/*
    }

    alias resetdd='removeCaches && fastlane snapshot reset_simulators && sudo killall -9 com.apple.CoreSimulator.CoreSimulatorService'
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
    if [ -f /opt/homebrew/share/bash-completion/bash_completion ]; then
        . /opt/homebrew/share/bash-completion/bash_completion
    fi
    # bash_completion.d
    for f in $(ls /opt/homebrew/etc/bash_completion.d/); do source /opt/homebrew/etc/bash_completion.d/$f; done

    alias sort-by-last="awk '{print \$NF,\$0 }' | sort -nr | cut -d ' ' -f 2-"

    # gvm
    [[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"
    function gvmu {
        gvm use $1 || return
        export GOPATH=$HOME/gohome
    }

    # adb under Android Studio dir
    [[ -s "$HOME/Library/Android/sdk/platform-tools/" ]] && export PATH=$PATH:$HOME/Library/Android/sdk/platform-tools
    [[ -s "$HOME/Library/Android/sdk/tools/bin/" ]] && export PATH=$PATH:$HOME/Library/Android/sdk/tools/bin
    export ANDROID_SDK_ROOT="/opt/homebrew/share/android-sdk"
    export ANDROID_HOME="${HOME}/Library/Android/sdk"
    export ANDROID_NDK_HOME="${ANDROID_HOME}/ndk/21.2.6472646/"
    export JAVA_HOME=/Applications/Android\ Studio.app/Contents/jre/jdk/Contents/Home/

    export GOPATH=$HOME/gohome
    export GOBIN=$GOPATH/bin
    export PATH=$PATH:$GOPATH/bin

    # gcloud
    GCLOUD_BASH_COMPETION=/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc
    GCLOUD_PATH=/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc
    [[ -s $GCLOUD_BASH_COMPETION ]] && source $GCLOUD_BASH_COMPETION
    [[ -d $GCLOUD_PATH ]] && export PATH=$PATH:$GCLOUD_PATH
fi

export LC_ALL=en_US.UTF-8
# anyenv
export PATH="$HOME/.anyenv/bin:$PATH"
eval "$(anyenv init -)"
eval "$(rbenv init - bash)"
alias abrew='/opt/homebrew/bin/brew'

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

