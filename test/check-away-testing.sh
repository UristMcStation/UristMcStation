FAILED=0
TOTAL=0
SKIPPED=0

EXCLUDE=("stations")

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

find_code
msg "checking away_sites_testing.dm ..."
for dir in maps/away/*/; do
  ((TOTAL++))
  name="$(basename "$dir")"
  if [[ " ${EXCLUDE[*]} " =~ " ${name} " ]]; then
    ((SKIPPED++))
    continue
  fi
  eval "grep -q '#include \"../away/$name/$name.dm\"' maps/away_sites_testing/away_sites_testing.dm"
  ret=$?
  if [[ ret -eq 1 ]]; then
    msg_bad "could not find $name in away_sites_testing.dm"
    ((FAILED++))
  fi
done
if [[ $FAILED -ne 0 ]]; then
  err "[$FAILED/$TOTAL]($SKIPPED Skipped) away maps not found in away_sites_testing.dm"
else msg_good "[$TOTAL]($SKIPPED Skipped) away maps included in away_sites_testing.dm"
fi
