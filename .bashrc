alias ll='ls -l'
alias lrt='ls -lrt'
alias g='git'

# source /usr/local/etc/bash_completion.d/git-prompt.sh
# source /usr/local/etc/bash_completion.d/git-completion.bash

export EDITOR=vi

# alias javac='javac -J-Duser.language=en'

MAIN_BRANCH=
alias dev='git checkout $MAIN_BRANCH'
alias devp='git checkout $MAIN_BRANCH && git pull --ff-only'
alias pr='hub pull-request'
alias propen='gh pr -B '
alias openprfor='~/Settings/scripts/open-pull-request-for.sh'

alias xselp='xcode-select -p'
alias xsels='sudo xcode-select -s'

export GOPATH=~/gohome
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:~/Settings/scripts
export PS1='\W $ '

export PATH=$PATH:/usr/local/lib/node_modules

# for new Swift
export PATH=/Library/Developer/Toolchains/swift-latest.xctoolchain/usr/bin:$PATH

# altool
#export PATH=$PATH:/Applications/Xcode.app/Contents/Applications/Application\ Loader.app/Contents/Frameworks/ITunesSoftwareService.framework/Versions/A/Support
#$(dirname "$(find $(dirname $(xcode-select -p)) -name altool | head -1)")

