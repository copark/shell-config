EXCEPT="! -name '.svn'"

function myAllGrep {
    find . -name "*" -exec grep "$1" --color -n "$@" {} \; -print
}

function myGrep {
    find . -name "$1" -exec grep "$2" --color -n "$@" {} \; -print
}

function port_usage {
    sudo lsof -i :$1 # check port $1
}

function make_tar {
    # make_tar a.tar.gz folder
    tar -pczf $1 $2
}

function make_zip {
    # make_zip a.zip folder
    zip -r $1 $2 $3
}

function gen_key {
    keytool -genkey -v -keystore $1.keystore -alias $1 -keyalg RSA -keysize 2048 -validity 10000
}

function extract {
if [ -f $1 ] ; then
    case $1 in
        *.tar.bz2) tar xjf $1 ;;
        *.tar.gz) tar xzf $1 ;;
        *.bz2) bunzip2 $1 ;;
        *.rar) rar x $1 ;;
        *.gz) gunzip $1 ;;
        *.tar) tar xf $1 ;;
        *.tbz2) tar xjf $1 ;;
        *.tgz) tar xzf $1 ;;
        *.zip) unzip $1 ;;
        *.Z) uncompress $1 ;;
        *.7z) 7z x $1 ;;
        *) echo "'$1' cannot be extracted via extract()" ;;
    esac
else
    echo "'$1' is not a valid file"
fi
}

# git log with per-commit cmd-clickable GitHub URLs (iTerm)
function gf {
    local remote="$(git remote -v | awk '/^origin.*\(push\)$/ {print $2}')"
    [[ "$remote" ]] || return
    local user_repo="$(echo "$remote" | perl -pe 's/.*://;s/\.git$//')"
    git log $* --name-status --color | awk "$(cat <<AWK
    /^.*commit [0-9a-f]{40}/ {sha=substr(\$2,1,7)}
    /^[MA]\t/ {printf "%s\thttps://github.com/$user_repo/blob/%s/%s\n", \$1, sha, \$2; next}
    /.*/ {print \$0}
    AWK
    )" | less -F
}

function toHex {
    output=$(printf "0x%x\n" $1)
    echo $1 = $output
}

function toDec {
    output=$(printf "%d\n" 0x$1)
    echo $1 = $output
}

function svn_cleanup {
    svn status | grep ^\? | sed -e 's/^.......\(.*\)$/\1/g' | sed -e 's/\\/\//g' | xargs -Ifile rm -rf file
    svn revert -R .
    svn up --force
}
