export TERM="xterm-color"
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

TITLEBAR='\[\e]0;\u@\h:\w \a\]'

# define colors
C_DEFAULT="\[\033[m\]"
C_WHITE="\[\033[1m\]"
C_BLACK="\[\033[30m\]"
C_RED="\[\033[31m\]"
C_GREEN="\[\033[32m\]"
C_YELLOW="\[\033[33m\]"
C_BLUE="\[\033[34m\]"
C_PURPLE="\[\033[35m\]"
C_CYAN="\[\033[36m\]"
C_LIGHTGRAY="\[\033[37m\]"
C_DARKGRAY="\[\033[1;30m\]"
C_LIGHTRED="\[\033[1;31m\]"
C_LIGHTGREEN="\[\033[1;32m\]"
C_LIGHTYELLOW="\[\033[1;33m\]"
C_LIGHTBLUE="\[\033[1;34m\]"
C_LIGHTPURPLE="\[\033[1;35m\]"
C_LIGHTCYAN="\[\033[1;36m\]"
C_BG_BLACK="\[\033[40m\]"
C_BG_RED="\[\033[41m\]"
C_BG_GREEN="\[\033[42m\]"
C_BG_YELLOW="\[\033[43m\]"
C_BG_BLUE="\[\033[44m\]"
C_BG_PURPLE="\[\033[45m\]"
C_BG_CYAN="\[\033[46m\]"
C_BG_LIGHTGRAY="\[\033[47m\]"

function parse_git_branch {
    inside_git_repo="$(git rev-parse --is-inside-work-tree 2>/dev/null)"
    if [ "$inside_git_repo" ]; then
        ref=$(git symbolic-ref HEAD 2> /dev/null) || return
        commit=$(git rev-list -n1 --abbrev-commit HEAD)
        echo "${ref#refs/heads/}:${commit}:"
    else
        echo ""
    fi
}

#export PS1="$C_CYAN\h:$C_YELLOW\w \$$C_DEFAULT "
PROMPT_COMMAND='echo -ne "\033]0; ${PWD}\007"'

export PS1="$C_CYAN\h:$C_GREEN\$(parse_git_branch)$C_YELLOW\w \$$C_DEFAULT "

###############################################################################
## HOME : MUST CHANGE
###############################################################################
export HOME=/Users/copark

###############################################################################
## ALIAS AREA
###############################################################################
alias ls='ls -vGF'
alias l='find .'
alias ll='ls -al'
alias dir='ls'
alias cls='clear'
alias q='exit'
alias grep='grep -n --color --exclude-dir=".svn"'
alias vi="vi '+syn on'"
alias fs="stat -f \"%z bytes\""
alias go='cd'
alias ndic="~/.ndic.bash"
# change -s<dir> if necessary.
alias djad='jad -o -r -sjava -dsrc **/*.class'
alias du='du -h'
alias df='df -lh'
# command !$


###############################################################################
## UTIL AREA
###############################################################################
ulimit -S -n 1024

# SVN 
export SVN_EDITOR=/usr/bin/vim

# Maven
export M2_HOME=$HOME/Dev/apache-maven-3.0.5
export PATH=$M2_HOME/bin:$PATH

# Gradle
export GRADLE_HOME=/usr/local/gradle-1.10
export GRADLE_OPTS="-Dfile.encoding=UTF-8 -Xmx512m -XX:PermSize=64m -XX:MaxPermSize=256m"
export PATH=$PATH:$GRADLE_HOME/bin

# MacPorts Installer addition on 2013-01-09_at_12:39:15: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
export MANPATH=$MANPATH:/opt/local/share/man
export INFOPATH=$INFOPATH:/opt/local/share/info
# Finished adapting your PATH environment variable for use with MacPorts.

# GIT
source ~/gitfunction.sh

# ETC Function
source ~/myfunction.sh

# ANDROID
source ~/myandroid.sh

#find . -name '*.java' | xargs wc -l