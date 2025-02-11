#!/bin/bash

set -o pipefail

dmepath=""
retval=1

for var; do
    if [[ $var != -* && $var == *.dme ]]; then
        dmepath=$(echo $var | sed -r 's/.{4}$//')
        break
    fi
done

if [[ $dmepath == "" ]]; then
    echo "No .dme file specified, aborting."
    exit 1
fi

if [[ -a $dmepath.mdme ]]; then
    rm $dmepath.mdme
fi

cp $dmepath.dme $dmepath.mdme
if [[ $? != 0 ]]; then
    echo "Failed to make modified dme, aborting."
    exit 2
fi

for var; do
    arg=$(echo $var | sed -r 's/^.{2}//')
    if [[ $var == -D* ]]; then
        sed -i '1s!^!#define '$arg'\n!' $dmepath.mdme
    elif [[ $var == -I* ]]; then
        sed -i 's!// BEGIN_INCLUDE!// BEGIN_INCLUDE\n#include "'$arg'"!' $dmepath.mdme
    elif [[ $var == -M* ]]; then
        sed -i '1s/^/#define MAP_OVERRIDE\n/' $dmepath.mdme
        sed -i 's!#include "maps\\_map_include.dm"!#include "maps\\'$arg'\\'$arg'.dm"!' $dmepath.mdme
    elif [[ $var == -T ]]; then
        sed -i '1s/^/#define MAP_TEST_TEMPLATES\n/' $dmepath.mdme
    elif [[ $var == -W* ]]; then
        sed -i '1s/^/#define DEBUG_GENERATE_WORTHS\n/' $dmepath.mdme
        sed -i '1s/^/#define MAP_OVERRIDE\n/' $dmepath.mdme
        declare -i line=$(grep -n '#include "maps\\_map_include.dm"' $dmepath.mdme | cut -d : -f 1)
        line+=1
        sed -i 's!#include "maps\\_map_include.dm"!#include "maps\\template_testing\\template_testing.dm"!' $dmepath.mdme
        maps=$(echo $arg | tr "|" "\n")
        for map in $maps
        do
            sed -i ''$line's/^/#include \"maps\\'$map'\\'$map'.dm\"\n/' $dmepath.mdme
        done
    fi
done

source "$( dirname "${BASH_SOURCE[0]}" )/sourcedm.sh"

if [[ $DM == "" ]]; then
    echo "Couldn't find the DreamMaker executable, aborting."
    exit 3
fi

"$DM" $dmepath.mdme | tee build_log.txt
retval=$?

[[ -e $dmepath.mdme.dmb ]] && mv $dmepath.mdme.dmb $dmepath.dmb
[[ -e $dmepath.mdme.rsc ]] && mv $dmepath.mdme.rsc $dmepath.rsc

rm $dmepath.mdme

exit $retval
