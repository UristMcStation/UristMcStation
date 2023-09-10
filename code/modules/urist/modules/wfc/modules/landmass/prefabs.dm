
/wfc_prefab/water
	repo_key = "water"

	tl = /turf/water
	tm = /turf/water
	tr = /turf/water
	ml = /turf/water
	mm = /turf/water
	mr = /turf/water
	bl = /turf/water
	bm = /turf/water
	br = /turf/water


/wfc_prefab/grass
	repo_key = "grass"

	tl = /turf/grass
	tm = /turf/grass
	tr = /turf/grass
	ml = /turf/grass
	mm = /turf/grass
	mr = /turf/grass
	bl = /turf/grass
	bm = /turf/grass
	br = /turf/grass


/wfc_prefab/beach
	repo_key = "beach"

	tl = /turf/beach
	tm = /turf/beach
	tr = /turf/beach
	ml = /turf/beach
	mm = /turf/beach
	mr = /turf/beach
	bl = /turf/beach
	bm = /turf/beach
	br = /turf/beach


/wfc_prefab/rock
	repo_key = "rock"

	tl = /turf/rock
	tm = /turf/rock
	tr = /turf/rock
	ml = /turf/rock
	mm = /turf/rock
	mr = /turf/rock
	bl = /turf/rock
	bm = /turf/rock
	br = /turf/rock


/wfc_prefab/snow
	repo_key = "snow"

	tl = /turf/snow
	tm = /turf/snow
	tr = /turf/snow
	ml = /turf/snow
	mm = /turf/snow
	mr = /turf/snow
	bl = /turf/snow
	bm = /turf/snow
	br = /turf/snow


/proc/state2prefab_landmass(var/state, var/my_varkey)
	var/turf_type = null

	switch(state)
		if(1)
			var/wfc_prefab/water/prefab = wfc_prefab_repo["water"]
			if(isnull(prefab))
				prefab = new("water")

			turf_type = prefab.vars[my_varkey]

		if(2)
			var/wfc_prefab/grass/prefab = wfc_prefab_repo["grass"]
			if(isnull(prefab))
				prefab = new("deepmaint_horizcorr")
			turf_type = prefab.vars[my_varkey]

		if(3)
			var/wfc_prefab/beach/prefab = wfc_prefab_repo["beach"]
			if(isnull(prefab))
				prefab = new("beach")

			turf_type = prefab.vars[my_varkey]

		if(4)
			var/wfc_prefab/snow/prefab = wfc_prefab_repo["snow"]
			if(isnull(prefab))
				prefab = new("snow")

			turf_type = prefab.vars[my_varkey]

		if(5)
			var/wfc_prefab/rock/prefab = wfc_prefab_repo["rock"]
			if(isnull(prefab))
				prefab = new("rock")

			turf_type = prefab.vars[my_varkey]

	return turf_type