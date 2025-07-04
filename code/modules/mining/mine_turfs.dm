var/global/list/mining_walls = list()
var/global/list/mining_floors = list()

/**********************Mineral deposits**************************/
/turf/unsimulated/mineral
	name = "impassable rock"
	icon = 'icons/turf/walls.dmi'
	icon_state = "rock-dark"
	blocks_air = 1
	density = TRUE
	opacity = 1

/turf/simulated/mineral //wall piece
	name = "rock"
	icon = 'icons/turf/walls.dmi'
	icon_state = "rock"
	initial_gas = null
	opacity = 1
	density = TRUE
	blocks_air = 1
	temperature = T0C
	color = COLOR_ASTEROID_ROCK
	turf_flags = TURF_DISALLOW_BLOB
	var/mined_turf = /turf/simulated/floor/asteroid
	var/material/mineral
	var/mined_ore = 0
	var/last_act = 0
	var/emitter_blasts_taken = 0 // EMITTER MINING! Muhehe.
	var/mining_hardness = 1 //a modifier for how tough a turf is to mine. A pickaxe's digspeed is multiplied by this var

	var/datum/geosample/geologic_data
	var/excavation_level = 0
	var/list/finds
	var/next_rock = 0
	var/archaeo_overlay = ""
	var/excav_overlay = ""
	var/obj/item/last_find
	var/datum/artifact_find/artifact_find
	var/image/ore_overlay

	has_resources = 1

/turf/simulated/mineral/Initialize()
	. = ..()
	if (!mining_walls["[src.z]"])
		mining_walls["[src.z]"] = list()
	mining_walls["[src.z]"] += src
	MineralSpread()
	update_icon(1)

/turf/simulated/mineral/Destroy()
	if (mining_walls["[src.z]"])
		mining_walls["[src.z]"] -= src
	GLOB.xeno_artifact_turfs -= src
	return ..()

/turf/simulated/mineral/can_build_cable()
	return !density

/turf/simulated/mineral/is_wall()
	return TRUE

/turf/simulated/mineral/on_update_icon(update_neighbors)
	if(!istype(mineral))
		SetName(initial(name))
		icon_state = "rock"
	else
		SetName("[mineral.ore_name] deposit")

	ClearOverlays()

	for(var/direction in GLOB.cardinal)
		var/turf/turf_to_check = get_step(src,direction)
		if(update_neighbors && istype(turf_to_check,/turf/simulated/floor/asteroid))
			var/turf/simulated/floor/asteroid/T = turf_to_check
			T.updateMineralOverlays()
		else if(istype(turf_to_check,/turf/space) || istype(turf_to_check,/turf/simulated/floor) || istype(turf_to_check,/turf/simulated/open))
			var/image/rock_side = image(icon, "rock_side", dir = turn(direction, 180))
			rock_side.turf_decal_layerise()
			if(istype(turf_to_check, /turf/simulated/open))
				rock_side.layer = MOB_LAYER + 1
			else
				rock_side.layer = ABOVE_OBJ_LAYER // the rocks should be above the shadows they cast as walls
			switch(direction)
				if(NORTH)
					rock_side.pixel_y += world.icon_size
				if(SOUTH)
					rock_side.pixel_y -= world.icon_size
				if(EAST)
					rock_side.pixel_x += world.icon_size
				if(WEST)
					rock_side.pixel_x -= world.icon_size
			AddOverlays(rock_side)

	if(ore_overlay)
		AddOverlays(ore_overlay)

	if(excav_overlay)
		AddOverlays(excav_overlay)

	if(archaeo_overlay)
		AddOverlays(archaeo_overlay)

/turf/simulated/mineral/ex_act(severity)
	switch(severity)
		if(EX_ACT_HEAVY)
			if (prob(70))
				mined_ore = 1 //some of the stuff gets blown up
				GetDrilled()
		if(EX_ACT_DEVASTATING)
			mined_ore = 2 //some of the stuff gets blown up
			GetDrilled()

/turf/simulated/mineral/bullet_act(obj/item/projectile/Proj)

	// Emitter blasts
	if(istype(Proj, /obj/item/projectile/beam/emitter))
		emitter_blasts_taken++

		if(emitter_blasts_taken > 2) // 3 blasts per tile
			mined_ore = 1
			GetDrilled()

/turf/simulated/mineral/Bumped(AM)
	. = ..()
	if (ismob(AM))
		var/mob/mob = AM
		var/obj/item/pickaxe/pickaxe = mob.IsHolding(/obj/item/pickaxe)
		if (pickaxe)
			use_tool(pickaxe, mob)

/turf/simulated/mineral/proc/MineralSpread()
	if(istype(mineral) && mineral.ore_spread_chance > 0)
		for(var/trydir in GLOB.cardinal)
			if(prob(mineral.ore_spread_chance))
				var/turf/simulated/mineral/target_turf = get_step(src, trydir)
				if(istype(target_turf) && isnull(target_turf.mineral))
					target_turf.mineral = mineral
					target_turf.UpdateMineral()
					target_turf.MineralSpread()


/turf/simulated/mineral/proc/UpdateMineral()
	clear_ore_effects()
	ore_overlay = image('icons/turf/mining_decals.dmi', "[mineral.ore_icon_overlay]")
	ore_overlay.appearance_flags = RESET_COLOR
	if(prob(50))
		ore_overlay.SetTransform(scale_x = -1)
	ore_overlay.color = mineral.icon_colour
	ore_overlay.turf_decal_layerise()
	update_icon()

/turf/simulated/mineral/use_tool(obj/item/W, mob/living/user, list/click_params)
	if (!user.IsAdvancedToolUser())
		to_chat(usr, SPAN_WARNING("You don't have the dexterity to do this!"))
		return TRUE

	if (istype(W, /obj/item/device/core_sampler))
		geologic_data.UpdateNearbyArtifactInfo(src)
		var/obj/item/device/core_sampler/C = W
		C.sample_item(src, user)
		return TRUE

	if (istype(W, /obj/item/device/depth_scanner))
		var/obj/item/device/depth_scanner/C = W
		C.scan_atom(user, src)
		return TRUE

	if (istype(W, /obj/item/device/measuring_tape))
		var/obj/item/device/measuring_tape/P = W
		user.visible_message(SPAN_NOTICE("\The [user] extends [P] towards [src]."),SPAN_NOTICE("You extend [P] towards [src]."))
		if(do_after(user, 1 SECOND, src, DO_PUBLIC_UNIQUE))
			to_chat(user, SPAN_NOTICE("\The [src] has been excavated to a depth of [excavation_level]cm."))
		return TRUE

	if (istype(W, /obj/item/pickaxe))
		if(!isturf(user.loc))
			return

		var/obj/item/pickaxe/P = W
		var/digtime = P.digspeed * mining_hardness // applies the modifier for mining_hardness. default is 1, so no change from digspeed.

		if(last_act + digtime > world.time)//prevents message spam
			to_chat(user, SPAN_WARNING("You cannot use \the [W] again so soon!"))
			return TRUE

		last_act = world.time
		playsound(user, P.drill_sound, 20, 1)

		var/newDepth = excavation_level + P.excavation_amount // Used commonly below
		//handle any archaeological finds we might uncover
		var/fail_message = ""
		if(finds && length(finds))
			var/datum/find/F = finds[1]
			if(newDepth > F.excavation_required) // Digging too deep can break the item. At least you won't summon a Balrog (probably)
				fail_message = ". <b>[pick("There is a crunching noise","[W] collides with some different rock","Part of the rock face crumbles away","Something breaks under [W]")]</b>"

		to_chat(user, SPAN_NOTICE("You start [P.drill_verb][fail_message]."))

		if(fail_message && prob(90))
			if(prob(25))
				excavate_find(prob(5), finds[1])
			else if(prob(50))
				finds.Remove(finds[1])
				if(prob(50))
					artifact_debris()

		if(do_after(user, digtime, src,  DO_DEFAULT | DO_PUBLIC_PROGRESS))
			if(finds && length(finds))
				var/datum/find/F = finds[1]
				if(newDepth == F.excavation_required) // When the pick hits that edge just right, you extract your find perfectly, it's never confined in a rock
					excavate_find(1, F)
				else if(newDepth > F.excavation_required - F.clearance_range) // Not quite right but you still extract your find, the closer to the bottom the better, but not above 80%
					excavate_find(prob(80 * (F.excavation_required - newDepth) / F.clearance_range), F)

			to_chat(user, SPAN_NOTICE("You finish [P.drill_verb] \the [src]."))

			if(newDepth >= 200) // This means the rock is mined out fully
				var/obj/structure/boulder/B
				if(artifact_find)
					if( excavation_level > 0 || prob(15) )
						//boulder with an artifact inside
						B = new(src)
						if(artifact_find)
							B.artifact_find = artifact_find
					else
						artifact_debris(1)
				else if(prob(5))
					//empty boulder
					B = new(src)

				if(B)
					GetDrilled(0)
				else
					GetDrilled(1)
				return TRUE

			excavation_level += P.excavation_amount
			var/updateIcon = 0

			//archaeo overlays
			if(!archaeo_overlay && finds && length(finds))
				var/datum/find/F = finds[1]
				if(F.excavation_required <= excavation_level + F.view_range)
					archaeo_overlay = image('icons/turf/excavation_overlays.dmi',"overlay_archaeo[rand(1,3)]")
					updateIcon = 1

			else if(archaeo_overlay && (!finds || !length(finds)))
				archaeo_overlay = null
				updateIcon = 1

			//there's got to be a better way to do this
			var/update_excav_overlay = 0
			if(excavation_level >= 150)
				if(excavation_level - P.excavation_amount < 150)
					update_excav_overlay = 1
			else if(excavation_level >= 100)
				if(excavation_level - P.excavation_amount < 100)
					update_excav_overlay = 1
			else if(excavation_level >= 50)
				if(excavation_level - P.excavation_amount < 50)
					update_excav_overlay = 1

			//update overlays displaying excavation level
			if( !(excav_overlay && excavation_level > 0) || update_excav_overlay )
				var/excav_quadrant = round(excavation_level / 50) + 1
				excav_overlay = image('icons/turf/excavation_overlays.dmi',"overlay_excv[excav_quadrant]_[rand(1,3)]")
				updateIcon = 1

			if(updateIcon)
				update_icon()

			//drop some rocks
			next_rock += P.excavation_amount
			while(next_rock > 50)
				next_rock -= 50
				var/obj/item/ore/O = new(src)
				geologic_data.UpdateNearbyArtifactInfo(src)
				O.geologic_data = geologic_data
		return TRUE

	else
		return ..()

/turf/simulated/mineral/proc/clear_ore_effects()
	CutOverlays(ore_overlay)
	ore_overlay = null

/turf/simulated/mineral/proc/DropMineral()
	if(!mineral)
		return

	clear_ore_effects()
	var/obj/item/ore/O = new(src, mineral.name)
	if(geologic_data && istype(O))
		geologic_data.UpdateNearbyArtifactInfo(src)
		O.geologic_data = geologic_data
	return O

/turf/simulated/mineral/proc/GetDrilled(artifact_fail = 0)
	//var/destroyed = 0 //used for breaking strange rocks
	if (mineral && mineral.ore_result_amount)

		//if the turf has already been excavated, some of it's ore has been removed
		for (var/i = 1 to mineral.ore_result_amount - mined_ore)
			DropMineral()

	//destroyed artifacts have weird, unpleasant effects
	//make sure to destroy them before changing the turf though
	if(artifact_find && artifact_fail)
		var/pain = 0
		if(prob(50))
			pain = 1
		for(var/mob/living/M in range(src, 200))
			to_chat(M, SPAN_COLOR("red", "<b>[pick("A high pitched [pick("keening","wailing","whistle")]","A rumbling noise like [pick("thunder","heavy machinery")]")] somehow penetrates your mind before fading away!</b>"))
			if(pain)
				flick("pain",M.pain)
				if(prob(50))
					M.adjustBruteLoss(5)
			else
				M.flash_eyes()
				if(prob(50))
					M.Stun(5)
		SSradiation.flat_radiate(src, 25, 200)

	//Let's add some effects
	new/obj/particle_emitter/burst/rocks(src, 1 SECOND, color)

	//Add some rubble,  you did just clear out a big chunk of rock.

	var/turf/simulated/floor/asteroid/N = ChangeTurf(mined_turf)

	if(istype(N))
		N.overlay_detail = "asteroid[rand(0,9)]"
		N.updateMineralOverlays(1)
		if(!N.has_resources || length(N.resources))
			return
		for(var/i in random_maps)
			var/datum/random_map/noise/ore/orenoise = random_maps[i]
			if(!istype(orenoise))
				continue
			if(orenoise.origin_z == N.z)
				orenoise.generate_map_tile(N)
				break

/turf/simulated/mineral/proc/excavate_find(prob_clean = 0, datum/find/F)

	//many finds are ancient and thus very delicate - luckily there is a specialised energy suspension field which protects them when they're being extracted
	if(prob(F.prob_delicate))
		var/obj/suspension_field/S = locate() in src
		if(!S)
			visible_message(SPAN_CLASS("danger", "[pick("An object in the rock crumbles away into dust.","Something falls out of the rock and shatters onto the ground.")]"))
			finds.Remove(F)
			return

	//with skill and luck, players can cleanly extract finds
	//otherwise, they come out inside a chunk of rock
	if(prob_clean)
		var/find = get_archeological_find_by_findtype(F.find_type)
		new find(src)
	else
		var/obj/item/ore/strangerock/rock = new(src, inside_item_type = F.find_type)
		geologic_data.UpdateNearbyArtifactInfo(src)
		rock.geologic_data = geologic_data

	finds.Remove(F)


/turf/simulated/mineral/proc/artifact_debris(severity = 0)
	//Give a random amount of loot from 1 to 3 or 5, varying on severity.
	for(var/j in 1 to rand(1, 3 + max(min(severity, 1), 0) * 2))
		switch(rand(1,7))
			if(1)
				var/obj/item/stack/material/rods/R = new(src)
				R.amount = rand(5,25)

			if(2)
				var/obj/item/stack/material/plasteel/R = new(src)
				R.amount = rand(5,25)

			if(3)
				var/obj/item/stack/material/steel/R = new(src)
				R.amount = rand(5,25)

			if(4)
				var/obj/item/stack/material/plasteel/R = new(src)
				R.amount = rand(5,25)

			if(5)
				var/quantity = rand(1,3)
				for(var/i=0, i<quantity, i++)
					new /obj/item/material/shard(src)

			if(6)
				var/quantity = rand(1,3)
				for(var/i=0, i<quantity, i++)
					new /obj/item/material/shard/phoron(src)

			if(7)
				var/obj/item/stack/material/uranium/R = new(src)
				R.amount = rand(5,25)

/turf/simulated/mineral/random
	name = "mineral deposit"

/turf/simulated/mineral/random/New(newloc, mineral_name, default_mineral_list = GLOB.weighted_minerals_sparse)
	if(!mineral_name && LAZYLEN(default_mineral_list))
		mineral_name = pickweight(default_mineral_list)

	if(!mineral && mineral_name)
		mineral = SSmaterials.get_material_by_name(mineral_name)
	if(istype(mineral))
		UpdateMineral()
	..(newloc)

/turf/simulated/mineral/random/high_chance/New(newloc, mineral_name, default_mineral_list)
	..(newloc, mineral_name, GLOB.weighted_minerals_rich)

/**********************Asteroid**************************/

// Setting icon/icon_state initially will use these values when the turf is built on/replaced.
// This means you can put grass on the asteroid etc.
/turf/simulated/floor/asteroid
	name = "sand"
	icon = 'icons/turf/flooring/asteroid.dmi'
	icon_state = "asteroid"
	base_name = "sand"
	base_desc = "Gritty and unpleasant."
	base_icon = 'icons/turf/flooring/asteroid.dmi'
	base_icon_state = "asteroid"
	footstep_type = /singleton/footsteps/asteroid

	initial_flooring = null
	initial_gas = null
	temperature = TCMB
	var/dug = 0       //0 = has not yet been dug, 1 = has already been dug
	var/overlay_detail
	has_resources = 1

/turf/simulated/floor/asteroid/Initialize()
	. = ..()
	if (!mining_floors["[src.z]"])
		mining_floors["[src.z]"] = list()
	mining_floors["[src.z]"] += src
	if(prob(20))
		overlay_detail = "asteroid[rand(0,9)]"

/turf/simulated/floor/asteroid/Destroy()
	if (mining_floors["[src.z]"])
		mining_floors["[src.z]"] -= src
	return ..()

/turf/simulated/floor/asteroid/ex_act(severity)
	switch(severity)
		if(EX_ACT_LIGHT)
			return
		if(EX_ACT_HEAVY)
			if (prob(70))
				gets_dug()
		if(EX_ACT_DEVASTATING)
			gets_dug()
	return

/turf/simulated/floor/asteroid/is_plating()
	return !density

/turf/simulated/floor/asteroid/use_tool(obj/item/W, mob/living/user, list/click_params)
	var/list/usable_tools = list(
		/obj/item/shovel,
		/obj/item/pickaxe/diamonddrill,
		/obj/item/pickaxe/drill,
		/obj/item/pickaxe/borgdrill
		)

	var/valid_tool
	for(var/valid_type in usable_tools)
		if(istype(W,valid_type))
			valid_tool = 1
			break

	if(valid_tool)
		if (dug)
			to_chat(user, SPAN_WARNING("This area has already been dug"))
			return TRUE

		var/turf/T = user.loc
		if (!(istype(T)))
			return

		to_chat(user, SPAN_WARNING("You start digging."))
		playsound(user.loc, 'sound/effects/rustle1.ogg', 50, 1)

		if (!do_after(user, 4 SECONDS, src,  DO_DEFAULT | DO_PUBLIC_PROGRESS))
			return TRUE

		to_chat(user, SPAN_NOTICE("You dug a hole."))
		gets_dug()
		return TRUE

	else if(istype(W,/obj/item/storage/ore))
		var/obj/item/storage/ore/S = W
		if(!S.quick_gather_single)
			for(var/obj/item/ore/O in contents)
				O.use_tool(W, user)
				return TRUE
	else if(istype(W,/obj/item/storage/bag/fossils))
		var/obj/item/storage/bag/fossils/S = W
		if(!S.quick_gather_single)
			for(var/obj/item/fossil/F in contents)
				F.use_tool(W, user)
				return TRUE
	else
		return ..()

/turf/simulated/floor/asteroid/proc/gets_dug()

	if(dug)
		return

	for(var/i=0;i<(rand(3)+2);i++)
		new/obj/item/ore/glass(src)

	dug = 1
	icon_state = "asteroid_dug"
	return

/turf/simulated/floor/asteroid/proc/updateMineralOverlays(update_neighbors)

	ClearOverlays()

	for(var/direction in GLOB.cardinal)
		if(istype(get_step(src, direction), /turf/space))
			var/image/aster_edge = image('icons/turf/flooring/asteroid.dmi', "asteroid_edges", dir = direction)
			aster_edge.turf_decal_layerise()
			AddOverlays(aster_edge)

	//todo cache
	if(overlay_detail)
		var/image/floor_decal = image(icon = 'icons/turf/flooring/decals.dmi', icon_state = overlay_detail)
		floor_decal.turf_decal_layerise()
		AddOverlays(floor_decal)

	if(update_neighbors)
		for(var/direction in GLOB.alldirs)
			var/turf/simulated/floor/asteroid/A = get_step(src, direction)
			if(istype(A))
				A.updateMineralOverlays()

/turf/simulated/floor/asteroid/Entered(atom/movable/M as mob|obj)
	..()
	if(istype(M,/mob/living/silicon/robot))
		var/mob/living/silicon/robot/R = M
		for (var/obj/item/item as anything in R.GetAllHeld(/obj/item/storage/ore))
			use_tool(item, R)
