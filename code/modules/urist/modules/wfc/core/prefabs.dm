var/global/list/wfc_prefab_repo = list()


/wfc_prefab
	var/repo_key

	// T = 'Top', M = 'Middle', B = 'Bottom'
	// L = 'Left', M = 'Middle', R = 'Right'

	var/turf/tl
	var/turf/tm
	var/turf/tr
	var/turf/ml
	var/turf/mm
	var/turf/mr
	var/turf/bl
	var/turf/bm
	var/turf/br


/wfc_prefab/New(var/repo_key = null)
	var/_repokey = repo_key || src.repo_key
	if(_repokey)
		wfc_prefab_repo[_repokey] = src

