ALL_MAPS="example|nerva|away_sites_testing"

function msg {
    echo -e "\t\e[34mtest\e[0m: $*"
}

function msg_bad {
    echo -e "\e[31m$*\e[0m"
}

function msg_good {
    echo -e "\e[32m$*\e[0m"
}

function err {
    msg_bad "error: $*"
    exit 1
}

function need_cmd {
    if command -v $1 >/dev/null 2>&1
    then msg "found '$1'"
    else err "program '$1' is missing, please install it"
    fi
}

function find_byond_deps {
    [[ "$CI" != "true" ]] && need_cmd DreamDaemon
}

function find_code {
    if [[ -z ${CODEPATH+x} ]]; then
        if [[ -d ./code ]]
        then CODEPATH=.
        else if [[ -d ../code ]]
            then CODEPATH=..
            fi
        fi
    fi
    cd $CODEPATH
    if [[ ! -d ./code ]]
    then err "invalid CODEPATH: $PWD"
    else msg "found code at $PWD"
    fi
}

if [[ -z ${MAP_PATH+z} ]]; then
    msg_bad "No MAP_PATH env specified. Exiting..."
    exit 1
fi

find_code
find_byond_deps

cp config/example/* config/
if [[ "$CI" == "true" ]]; then
    msg "installing BYOND"
    ./install-byond.sh || exit 1
    source ~/BYOND-${BYOND_MAJOR}.${BYOND_MINOR}/byond/bin/byondsetup
fi

msg "Selected map include is '${MAP_PATH}'"

if [[ "$MAP_PATH" == "all" ]]; then
    eval "scripts/dm.sh -W'$ALL_MAPS' baystation12.dme"
elif [[ "$MAP_PATH" != "none" ]]; then
    eval "scripts/dm.sh -W'$MAP_PATH' baystation12.dme"
else
    eval "scripts/dm.sh -W baystation12.dme"
fi

ret=$?
if [[ ret -ne 0 ]]; then
    err "Failed to compile dme"
fi

eval "DreamDaemon baystation12.dmb -invisible -trusted -core 2>&1 | tee log.txt"
ret=$?
if [[ ret -ne 0 ]]; then
    err "Error running DreamDaeom"
fi

msg_good "Export complete"
