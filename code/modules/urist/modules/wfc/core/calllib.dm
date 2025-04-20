#define WFC_PREFAB_SIZE 3

// Deepmaint uses copies of itself with multiple linked variants.

// Number of variants
#define DEEPMAINT_VARIANT_REPEATS_X 2
#define DEEPMAINT_VARIANT_REPEATS_Y 2

// Size of each map variant
#define DEEPMAINT_VARIANT_SIZE_X 90
#define DEEPMAINT_VARIANT_SIZE_Y 90

// Distance between copies, on X/Y axes respectively
#define DEEPMAINT_VARIANT_SPACING_X 10
#define DEEPMAINT_VARIANT_SPACING_Y 10

#define DEEPMAINT_YEET_POS(POS, REP, SIZE, SPACING) (POS + REP * (SIZE + SPACING))
#define DEEPMAINT_RELATIVE_POS(POS, SIZE, SPACING) (POS % (SIZE + SPACING))

/proc/generate_wfc_map(rules_json = "deepmaint.json")
	call_ext("ss13_wfc.dll", "from_ruleset")(rules_json)

	if(!fexists("genmap.json"))
		log_debug("Deepmaint - failed to generate in the DLL.")
		return FALSE

	return TRUE


/proc/generate_from_wfc_file(mapname = "genmap.json", overwrite_all = FALSE, zlevel = 1, xvariants = DEEPMAINT_VARIANT_REPEATS_X, yvariants = DEEPMAINT_VARIANT_REPEATS_Y)
	if(!fexists(mapname))
		log_debug("Deepmaint - Could not find map file: [mapname]")
		return

	var/fh = file(mapname)
	var/data = file2text(fh)
	var/regex/map_regex = regex(@"(\d+)\|(\d+),(\d+)", "g")

	var/regex/matcher = TWOD_FRACTCOORDS_REGEX
	var/list/idx_to_varkey = list(
		list("bl", "bm", "br"),
		list("ml", "mm", "mr"),
		list("tl", "tm", "tr")
	)

	spawn(0)
		while(TRUE)
			var/found = map_regex.Find(data)
			if(!found)
				break

			var/raw_state = map_regex.group[1]
			var/raw_x = map_regex.group[2]
			var/raw_y = map_regex.group[3]

			var/state = text2num(raw_state)
			var/x = text2num(raw_x)
			var/y = text2num(raw_y)

			var/coords = "2/[text2num(x) + 1],[text2num(y) + 1],[zlevel]"

			var/list/children = fractal_children_str(coords, WFC_PREFAB_SIZE)

			for(var/ch in children)
				sleep(0)

				if(!matcher.Find(ch))
					continue

				var/match_x = text2num(matcher.group[2])
				var/match_y = text2num(matcher.group[3])
				var/match_z = text2num(matcher.group[4])

				// the logical OR is to convert 0s to <maxsize> because DM is 1-indexed
				var/prefab_idx_x = (match_x % WFC_PREFAB_SIZE) || WFC_PREFAB_SIZE
				var/prefab_idx_y = (match_y % WFC_PREFAB_SIZE) || WFC_PREFAB_SIZE

				var/my_varkey = idx_to_varkey[prefab_idx_y][prefab_idx_x]

				var/turf_type = null

				turf_type = state2prefab_deepmaint(state, my_varkey)

				for(var/repeat_off_x = 0, repeat_off_x < xvariants, repeat_off_x++)
					for(var/repeat_off_y = 0, repeat_off_y < yvariants, repeat_off_y++)
						sleep(-1)

						var/variant_x = DEEPMAINT_YEET_POS(match_x, repeat_off_x, DEEPMAINT_VARIANT_SIZE_X, DEEPMAINT_VARIANT_SPACING_X)
						var/variant_y = DEEPMAINT_YEET_POS(match_y, repeat_off_y, DEEPMAINT_VARIANT_SIZE_Y, DEEPMAINT_VARIANT_SPACING_Y)

						var/turf/child_turf = locate(variant_x, variant_y, match_z)

						if(turf_type && child_turf && (overwrite_all || child_turf.wfc_overwritable))
							WFC_CHANGE_TURF(child_turf, turf_type)

	return TRUE


/proc/generate_wfc_map_full(rules_json = "deepmaint.json", overwrite_all = FALSE, zlevel = 1)
	var/mapname = "genmap.json"
	var/status = TRUE // abusing short-circuiting
	status = status && generate_wfc_map(rules_json)
	status = status && generate_from_wfc_file(mapname, overwrite_all = FALSE, zlevel = zlevel)
	return status
