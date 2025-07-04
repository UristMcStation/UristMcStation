#!/usr/bin/env bash
set -eo pipefail

FAILED=0
shopt -s globstar

exactly() { # exactly N name search [mode] [filter]
	count="$1"
	name="$2"
	search="$3"
	mode="${4:--E}"
	filter="${5:-**/*.dm}"

	num="$(grep "$mode" "$search" $filter | wc -l || true)"

	if [ $num -eq $count ]; then
		echo "[1;32mOK[0m $num $name"
	else
		echo "[1;31mFAIL[0m $num $name (expecting exactly $count)"
		if [ $1 -lt 30 ]; then
			echo "entries:"
			grep "$mode" "$search" $filter
		fi
		FAILED=1
	fi
}

# If you increase any of these numbers you're probably doing it wrong
exactly 0 "escapes" '\\\\(red|blue|green|black|b|i[^mc])'
exactly 4 "Del()s" '\WDel\('
exactly 2 "/atom text paths" '"/atom'
exactly 2 "/area text paths" '"/area'
exactly 2 "/datum text paths" '"/datum'
exactly 2 "/mob text paths" '"/mob'
exactly 10 "/obj text paths" '"/obj'
exactly 8 "/turf text paths" '"/turf'
exactly 141 "to_world uses" '\sto_world\('
exactly 0 "globals with leading /" '^/var' -P
exactly 0 "globals without global sugar" '^var/(?!global/)' -P
exactly 0 "apparent paths with trailing /" '\w/[,\)\n]' -P
exactly 55 "to_world_log uses" '\sto_world_log\('
exactly 0 "world<< uses" 'world<<|world[[:space:]]<<'
exactly 0 "world.log<< uses" 'world.log<<|world.log[[:space:]]<<'
exactly 2 "<< uses" '(?<!<)<<(?!<)' -P
exactly 2 ">> uses" '(?<!>)>>(?!>)' -P
exactly 0 "incorrect indentations" '^( {4,})' -P
exactly 25 "text2path uses" 'text2path'
exactly 5 "update_icon() override" '/update_icon\((.*)\)'  -P
exactly 4 "goto use" 'goto '
exactly 1 "NOOP match" 'NOOP'
exactly 425 "spawn uses" '^\s*spawn\s*\(\s*(-\s*)?\d*\s*\)' -P
exactly 0 "tag uses" '\stag = ' -P '**/*.dmm'
exactly 0 "anchored = 0/1" 'anchored\s*=\s*\d' -P
exactly 2 "density = 0/1" 'density\s*=\s*\d' -P
exactly 0 "emagged = 0/1" 'emagged\s*=\s*\d' -P
exactly 0 "simulated = 0/1" 'simulated\s*=\s*\d' -P
#exactly 2 "var/ in proc arguments" '(^/[^/].+/.+?\(.*?)var/' -P
exactly 0 "tmp/ vars" 'var.*/tmp/' -P
exactly 6 "uses of .len" '\.len\b' -P
exactly 16 "uses of examine()" '[.|\s]examine\(' -P # If this fails it's likely because you used '/atom/proc/examine(mob)' instead of '/proc/examinate(mob, atom)' - Exception: An examine()-proc may call other examine()-procs
exactly 7 "direct modifications of overlays list" '\boverlays((\s*[|^=+&-])|(\.(Cut)|(Add)|(Copy)|(Remove)|(Remove)))' -P
exactly 0 "new/list list instantiations" 'new\s*/list' -P
exactly 0 "== null tests" '(==\s*null\b)|(\bnull\s*==)' -P #Use isnull() instead
exactly 0 "istype /mob where ismob should be used" 'istype\(.*?,\s*/mob\s*\)' -P
exactly 1 "istype /obj where isobj should be used" 'istype\(.*?,\s*/obj\s*\)' -P
exactly 0 "istype /turf where isturf should be used" 'istype\(.*?,\s*/turf\s*\)' -P
exactly 0 "istype /area where isarea should be used" 'istype\(.*?,\s*/area\s*\)' -P
exactly 0 "istype /icon where isicon should be used" 'istype\(.*?,\s*/icon\s*\)' -P
exactly 0 "istype /list where islist should be used" 'istype\(.*?,\s*/list\s*\)' -P
exactly 0 "istype /atom where isloc should be used" 'istype\(.*?,\s*/atom\s*\)' -P
exactly 0 "istype atom/movable where ismovable should be used" 'istype\(.*?,\s*/atom/movable\s*\)' -P
exactly 0 "callback proc/ or verb/ where PROC_REF, VERB_REF, etc should be used" 'Callback\([\w/]*,\s*[\w\./]*proc' -P # Callback(src, .proc/foo) should be Callback(src, PROC_REF(foo)), or equivalent. See code\__defines\procs.dm
# If you increase any of these numbers you're probably doing it wrong

num=`find ./html/changelogs -not -name "*.yml" | wc -l`
echo "$num non-yml files (expecting exactly 2)"
[ $num -eq 2 ] || FAILED=1

num=`find . -perm /111 -name "*.dm*" | wc -l`
echo "$num executable *.dm? files (expecting exactly 0)"
[ $num -eq 0 ] || FAILED=1

exit $FAILED
