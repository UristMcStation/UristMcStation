/obj/urist_intangible/triggers/template_loader
	name = "random ruin"
	icon = 'icons/obj/weapons/other.dmi'
	icon_state = "syndballoon"
	invisibility = 101
	var/gamemode
// what triggers us loading. TEMPLATE_LOADER_LOAD defined in _uristdefines.dm.
// Defaults to false, which is being called to load by something other than Initialize() or the misc late init subsystem
	var/load_trigger
// allows you to define a map file by name (usually the filename for things loaded by the mapping subsystem)
// if your map template isn't in SSmapping.map_templates, this probably won't do anything
// on_call template_loaders need a mapfile set or they won't load. see overmapships.dm for an example of how this works in practice
	var/mapfile
	var/centre = TRUE //do we centre the map file we're loading

/obj/urist_intangible/triggers/template_loader/Initialize()
	. = ..()
	if(load_trigger == TEMPLATE_LOADER_LOAD_ON_SPAWN)
		Load()
		return INITIALIZE_HINT_QDEL

/obj/urist_intangible/triggers/template_loader/proc/Load(list/potentialRuins, datum/map_template/template = null)
	return

/obj/urist_intangible/triggers/template_loader/on_init
	load_trigger = TEMPLATE_LOADER_LOAD_ON_INIT

/obj/urist_intangible/triggers/template_loader/on_init/Load(list/potentialRuins, datum/map_template/template = null)
	var/list/possible_ruins = list()
	for(var/A in potentialRuins)
		var/datum/map_template/T = potentialRuins[A]
		if(!T.loaded)
			possible_ruins += T
	if(!template && length(possible_ruins))
		template = pick(possible_ruins)
	if(!template)
		return
	var/turf/central_turf = get_turf(src)
	template.load(central_turf,centered = centre)
	template.loaded = TRUE
	QDEL_IN(src,0)

/obj/urist_intangible/triggers/template_loader/on_init/space/Load(list/potentialRuins = SSmapping.space_ruins_templates, datum/map_template/template = null)
	..()

/obj/urist_intangible/triggers/template_loader/on_init/planet/Load(list/potentialRuins = SSmapping.planet_templates, datum/map_template/template = null)
	..()

/obj/urist_intangible/triggers/template_loader/on_init/underground/Load(list/potentialRuins = SSmapping.underground_templates, datum/map_template/template = null)
	..()

/obj/urist_intangible/triggers/template_loader/on_init/submap //we don't load maps at runtime, so we need to get funky if we want to use submaps on the nerva
	centre = FALSE
	name = "submap template loader"
	icon = 'icons/urist/effects/map_effects_96x96.dmi'
	icon_state = "mapmanip_loader"
	pixel_x = -32
	pixel_y = -32

/obj/urist_intangible/triggers/template_loader/on_init/submap/Load(list/potentialRuins = SSmapping.submap_templates, datum/map_template/template = null)
	if(mapfile)
		to_world("submap loading")
		for(var/A in potentialRuins)
			var/datum/map_template/T = potentialRuins[A]
			if(T.name == src.mapfile)
				to_world("[T.name] found")
				template = T
		if(template)
			to_world("template loading. centre = [centre]")
			template.load(get_turf(src), centered = centre)
		QDEL_IN(src,0)

/obj/urist_intangible/triggers/template_loader/on_call/Load(list/potentialRuins = SSmapping.map_templates, datum/map_template/template = null)
	if(mapfile) //on_call template loaders need a mapfile set or they will not load
		for(var/A in potentialRuins)
			var/datum/map_template/T = potentialRuins[A]
			if(T.name == src.mapfile)
				template = T
		if(template)
			template.load(get_turf(src), centered = centre)
		QDEL_IN(src,0)

/obj/urist_intangible/triggers/template_loader/on_call/gamemode/assault
	var/maptype = 0
	gamemode = "assault"

/obj/urist_intangible/triggers/template_loader/on_call/ships
	var/mob/living/simple_animal/hostile/overmapship/home_ship = null //what ship are we connected to

/obj/urist_intangible/triggers/template_loader/on_call/ships/Load(list/potentialRuins = SSmapping.ship_templates, datum/map_template/template = null)
	if(mapfile)
		for(var/A in potentialRuins)
			var/datum/map_template/ship/T = potentialRuins[A]
			if(T.name == src.mapfile)
				template = T

		if(template.load(get_turf(src), centered = TRUE))
			home_ship.map_spawned = TRUE
			QDEL_IN(src,0)

/obj/urist_intangible/triggers/template_loader/on_spawn
	load_trigger = TEMPLATE_LOADER_LOAD_ON_SPAWN

/obj/urist_intangible/triggers/template_loader/on_spawn/Load(list/potentialRuins = SSmapping.map_templates, datum/map_template/template = null)
	if(mapfile)
		for(var/A in potentialRuins)
			var/datum/map_template/T = potentialRuins[A]
			if(T.name == src.mapfile)
				template = T
		if(template)
			template.load(get_turf(src), centered = centre)

/datum/map_template/ship
	template_flags = TEMPLATE_FLAG_CLEAR_CONTENTS | TEMPLATE_FLAG_ALLOW_DUPLICATES

/datum/map_template/ship/load(turf/T, centered=FALSE)
	if(centered)
		T = locate(T.x - round(width/2) , T.y - round(height/2) , T.z)
	if(!T)
		return
	if(T.x+width > world.maxx)
		return
	if(T.y+height > world.maxy)
		return

	for(var/L in block(T,locate(T.x+width-1, T.y+height-1, T.z)))
		var/turf/B = L

		for(var/mob/living/carbon/human/W in B)
			if(W.faction == "neutral")
				var/tele_x = GLOB.using_map.overmap_ship.evac_x
				var/tele_y = GLOB.using_map.overmap_ship.evac_y
				var/tele_z = GLOB.using_map.overmap_ship.evac_z

				do_teleport(W, locate(tele_x,tele_y,tele_z), 0)
				to_chat(W, "<span class='warning'>You teleport back to the ship!</span>")

			else
				qdel(W)

		for(var/mob/living/silicon/S in B)
			var/tele_x = GLOB.using_map.overmap_ship.evac_x
			var/tele_y = GLOB.using_map.overmap_ship.evac_y
			var/tele_z = GLOB.using_map.overmap_ship.evac_z

			do_teleport(S, locate(tele_x,tele_y,tele_z), 0)
			to_chat(S, "<span class='warning'>You teleport back to the ship!</span>")


	var/list/atoms_to_initialise = list()

	for (var/mappath in mappaths)
		var/datum/map_load_metadata/M = GLOB.maploader.load_map(file(mappath), T.x, T.y, T.z, cropMap=TRUE, clear_contents=(template_flags & TEMPLATE_FLAG_CLEAR_CONTENTS))
		if (M)
			atoms_to_initialise += M.atoms_to_initialise
		else
			return FALSE

	//initialize things that are normally initialized after map load
	init_atoms(atoms_to_initialise)
	init_shuttles()
	SSlighting.InitializeTurfs(atoms_to_initialise)	// Hopefully no turfs get placed on new coords by SSatoms.
	log_game("[name] loaded at at [T.x],[T.y],[T.z]")
	loaded++

	return TRUE
