#!/bin/sh

# download source - git clone 
# work in local directory and push remote server - git add , git commit,  git  push 
# make branch - git checkout -b <branch>
# switch branch - git checkout <branch>, git checkout master
# remove branch - git branch -d <branch>
# revert - git checkout -- <file>


# initalize alias must be call in bashrc
function git_init {
    git config --global core.whitespace cr-at-eol
    git config --global alias.co checkout
    git config --global alias.br branch
    git config --global alias.ci commit
    git config --global alias.st status -s
    git config --global alias.diff diff --word-diff
    git config --global alias.dc diff --cached
    git config --global alias.last "log -1 HEAD"
    git config --global alias.timeline "log --oneline --graph --decorate"
    git config --global alias.rvt "checkout HEAD ."
    git config --global core.editor /usr/bin/vim
}

# show tracked all files
function git_files {
    git ls-files
}

function git_tag {
    git tag -a $1
}

# show untracked all files
function git_untracked {
    git ls-files --other --exclude-standard
}

# checkout HEAD first
function git_update_force {
    git checkout HEAD .
}

# remove untracked file
function git_cleanup {
    git clean -f -d
}

# show last log message
function git_last {
    git init
    git last
}

# show all timeline log
function git_timeline {
    git_init
    git timeline
}

# add branch
function git_add_branch {
    git branch $1
}

# switch branch
function git_switch_branch {
    git checkout $1
}

# remove local branch
function git_remove_branch {
    git branch -D $1
}

function git_gerrit_enable {
    git config remote.origin.push refs/heads/*:refs/for/*
}
