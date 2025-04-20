var/global/list/datum/map_template/map_templates = list()
var/global/list/datum/map_template/space_ruins_templates = list()
var/global/list/datum/map_template/planet_templates = list()
var/global/list/datum/map_template/underground_templates = list()
var/global/list/datum/map_template/ship/ship_templates = list()

/datum/controller/subsystem/mapping/proc/preloadOtherTemplates()
	var/list/potentialSpaceRuins = generateMapList(filename = "config/spaceRuins.txt")
	for(var/ruin in potentialSpaceRuins)
		var/datum/map_template/T = new(list(ruin), ruin)
		space_ruins_templates[T.name] = T

	var/list/potentialPlanetTemplates = generateMapList(filename = "config/planetTemplates.txt")
	for(var/ruin in potentialPlanetTemplates)
		var/datum/map_template/T = new(list(ruin), ruin)
		planet_templates[T.name] = T

	var/list/potentialUndergroundTemplates = generateMapList(filename = "config/undergroundTemplates.txt")
	for(var/ruin in potentialUndergroundTemplates)
		var/datum/map_template/T = new(list(ruin), ruin)
		underground_templates[T.name] = T

	var/list/potentialShipTemplates = generateMapList(filename = "config/shipTemplates.txt")
	for(var/ruin in potentialShipTemplates)
		var/datum/map_template/ship/T = new(list(ruin), ruin)
		ship_templates[T.name] = T
		SSmapping.map_templates[T.name] = T

/obj/urist_intangible/trigger/template_loader
	name = "random ruin"
	icon = 'icons/obj/weapons/other.dmi'
	icon_state = "syndballoon"
	invisibility = 101
	var/gamemode = 0

/obj/urist_intangible/trigger/template_loader/proc/Load()
	return

/obj/urist_intangible/trigger/template_loader/space/Load(list/potentialRuins = space_ruins_templates, datum/map_template/template = null)
	var/list/possible_ruins = list()
	for(var/A in potentialRuins)
		var/datum/map_template/T = potentialRuins[A]
		if(!T.loaded)
			possible_ruins += T
	if(!template && length(possible_ruins))
		template = difflist(possible_ruins)
	if(!template)
		return
	var/turf/central_turf = get_turf(src)
	template.load(central_turf,centered = TRUE)
//	template.loaded++
	QDEL_IN(src,0)

/obj/urist_intangible/trigger/template_loader/planet/Load(list/potentialRuins = planet_templates, datum/map_template/template = null)
	var/list/possible_ruins = list()
	for(var/A in potentialRuins)
		var/datum/map_template/T = potentialRuins[A]
		if(!T.loaded)
			possible_ruins += T
//	report_progress(Loading ruins...")
	if(!template && length(possible_ruins))
		template = difflist(possible_ruins)
	if(!template)
//		report_progress(No ruins found.")
		return
	template.load(get_turf(src),centered = TRUE)
	template.loaded++
//	report_progress(Ruins loaded.")
	QDEL_IN(src,0)

/obj/urist_intangible/trigger/template_loader/underground/Load(list/potentialRuins = underground_templates, datum/map_template/template = null)
	var/list/possible_ruins = list()
	for(var/A in potentialRuins)
		var/datum/map_template/T = potentialRuins[A]
		if(!T.loaded)
			possible_ruins += T
	if(!template && length(possible_ruins))
		template = difflist(possible_ruins)
	if(!template)
		return
	var/turf/central_turf = get_turf(src)
	template.load(central_turf,centered = TRUE)
//	template.loaded++
	QDEL_IN(src,0)

/obj/urist_intangible/trigger/template_loader/gamemode
	var/mapfile = null
	invisibility = 101

/obj/urist_intangible/trigger/template_loader/gamemode/Load(list/potentialRuins = map_templates, datum/map_template/template = null)

	for(var/A in potentialRuins)
		var/datum/map_template/T = potentialRuins[A]
//		log_debug("T = [T.name]")
		if(T.name == src.mapfile)
			template = T
//	log_debug(Template = [template] Mapfile = [mapfile]")
	template.load(get_turf(src), centered = TRUE)
//	template.loaded++

	QDEL_IN(src,0)

/obj/urist_intangible/trigger/template_loader/gamemode/assault
	var/maptype = 0
	gamemode = "assault"

/obj/urist_intangible/trigger/template_loader/ships
	var/mapfile = null
	var/mob/living/simple_animal/hostile/overmapship/home_ship = null //what ship are we connected to
	gamemode = "ships" //this is dumb, but i don't want to rewrite it

/obj/urist_intangible/trigger/template_loader/ships/Load(list/potentialRuins = ship_templates, datum/map_template/ship/template = null)

	for(var/A in potentialRuins)
		var/datum/map_template/ship/T = potentialRuins[A]
//		report_progress("<span>T = [T.name]</span>")
		if(T.name == src.mapfile)
			template = T
//	report_progress("<span>Template = [template] Mapfile = [mapfile]</span>")

	if(template.load(get_turf(src), centered = TRUE))
//	template.loaded++
		home_ship.map_spawned = TRUE
		QDEL_IN(src,0)

/* MATRIXCOMMENT
/obj/urist_intangible/trigger/template_loader/matrix/Initialize()
	GLOB.SSmatrix.init_matrix_memory(src)
	. = ..()

/obj/urist_intangible/trigger/template_loader/matrix/Load(security_rating = LOW_SEC, datum/map_template/template = null)
	switch(security_rating)
		if(LOW_SEC)
			template = safepick(low_matrix_templates)
		if(MED_SEC)
			template = safepick(med_matrix_templates)
		if(HIGH_SEC)
			template = safepick(high_matrix_templates)
	if(!template)
		return
	return template.load(get_turf(src),centered = TRUE)
*/

/obj/urist_intangible/trigger/template_loader/volcanic

/obj/urist_intangible/trigger/template_loader/housing

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
