var/list/datum/map_template/map_templates = list()
var/list/datum/map_template/space_ruins_templates = list()
var/list/datum/map_template/planet_templates = list()
var/list/datum/map_template/underground_templates = list()

/datum/map_template
	var/name = "Default Template Name"
	var/width = 0
	var/height = 0
	var/tallness = 0
	var/mappath = null
	var/loaded = 0 // Times loaded this round

/datum/map_template/New(path = null, rename = null)
	if(path)
		mappath = path
	if(mappath)
		preload_size(mappath)
	if(rename)
		name = rename

/datum/map_template/proc/preload_size(path)
	var/datum/map_load_metadata/M = maploader.load_map(file(path), 1, 1, 1, cropMap=FALSE, measureOnly=TRUE)
	if(M)
		width = M.bounds[MAP_MAXX] // Assumes all templates are rectangular, have a single Z level, and begin at 1,1,1
		height = M.bounds[MAP_MAXY]
		tallness = M.bounds[MAP_MAXZ]
	return M

/datum/map_template/proc/init_atoms(var/list/atoms)
	var/list/obj/machinery/atmospherics/atmos_machines = list()
	var/list/obj/structure/cable/cables = list()

	for(var/A in atoms)
		if(istype(A, /obj/structure/cable))
			cables += A
		if(istype(A, /obj/machinery/atmospherics))
			atmos_machines += A

	SSatoms.InitializeAtoms(atoms)
	SSmachines.setup_powernets_for_cables(cables)
	SSmachines.setup_atmos_machinery(atmos_machines)

/datum/map_template/proc/load_new_z()

	if (tallness > 1) // aka this template has multiple zlevels and needs to be linked by the zlevel system...
		if (tallness + world.maxz > GLOB.HIGHEST_CONNECTABLE_ZLEVEL_INDEX) // aka it's too tall to fit in the system...
			return  // fug!

	var/x = round((world.maxx - width)/2)
	var/y = round((world.maxy - height)/2)

	if (x < 1) x = 1
	if (y < 1) y = 1

	var/datum/map_load_metadata/M = maploader.load_map(file(mappath), x, y, no_changeturf=TRUE)
	if(!M)
		return

	//initialize things that are normally initialized after map load
	init_atoms(M.atoms_to_initialise)
	log_game("Z-level [name] loaded at [x],[y],[world.maxz]")

	return locate(world.maxx/2, world.maxy/2, world.maxz)

/datum/map_template/proc/load(turf/T, centered=FALSE, clear_contents=FALSE)
	if(centered)
		T = locate(T.x - round(width/2) , T.y - round(height/2) , T.z)
	if(!T)
		return
	if(T.x+width > world.maxx)
		return
	if(T.y+height > world.maxy)
		return

	var/datum/map_load_metadata/M = maploader.load_map(file(mappath), T.x, T.y, T.z, cropMap=TRUE, clear_contents=clear_contents)
	if(!M)
		return

	//initialize things that are normally initialized after map load
	init_atoms(M.atoms_to_initialise)

	log_game("[name] loaded at at [T.x],[T.y],[T.z]")
	return TRUE

/datum/map_template/proc/get_affected_turfs(turf/T, centered = FALSE)
	var/turf/placement = T
	if(centered)
		var/turf/corner = locate(placement.x - round(width/2), placement.y - round(height/2), placement.z)
		if(corner)
			placement = corner
	return block(placement, locate(placement.x+width-1, placement.y+height-1, placement.z))


//for your ever biggening badminnery kevinz000
//? - Cyberboss
/proc/load_new_z_level(var/file, var/name)
	var/datum/map_template/template = new(file, name)
	template.load_new_z()

/proc/preloadTemplates(path = "maps/templates/") //see master controller setup
	var/list/filelist = flist(path)
	for(var/map in filelist)
		var/datum/map_template/T = new(path = "[path][map]", rename = "[map]")
		map_templates[T.name] = T

	preloadOtherTemplates()

	admin_notice("<span class='danger'>Templates Preloaded</span>", R_DEBUG)

	for(var/obj/effect/template_loader/E in world)
		if(E.gamemode)
			continue
		E.Load()

/proc/preloadOtherTemplates()
	var/list/potentialSpaceRuins = generateMapList(filename = "config/spaceRuins.txt")
	for(var/ruin in potentialSpaceRuins)
		var/datum/map_template/T = new(path = "[ruin]", rename = "[ruin]")
		space_ruins_templates[T.name] = T

	var/list/potentialPlanetTemplates = generateMapList(filename = "config/planetTemplates.txt")
	for(var/ruin in potentialPlanetTemplates)
		var/datum/map_template/T = new(path = "[ruin]", rename = "[ruin]")
		planet_templates[T.name] = T

	var/list/potentialUndergroundTemplates = generateMapList(filename = "config/undergroundTemplates.txt")
	for(var/ruin in potentialUndergroundTemplates)
		var/datum/map_template/T = new(path = "[ruin]", rename = "[ruin]")
		underground_templates[T.name] = T

/obj/effect/template_loader
	name = "random ruin"
	icon = 'icons/obj/weapons.dmi'
	icon_state = "syndballoon"
	invisibility = 0
	var/gamemode = 0

/*/obj/effect/template_loader/New()
	..()
	Load()	*/

/obj/effect/template_loader/proc/Load()
	return

/obj/effect/template_loader/space/Load(list/potentialRuins = space_ruins_templates, datum/map_template/template = null)
	var/list/possible_ruins = list()
	for(var/A in potentialRuins)
		var/datum/map_template/T = potentialRuins[A]
		if(!T.loaded)
			possible_ruins += T
//	world << "<span class='boldannounce'>Loading ruins...</span>"
	if(!template && possible_ruins.len)
		template = safepick(possible_ruins)
	if(!template)
//		world << "<span class='boldannounce'>No ruins found.</span>"
		return
	template.load(get_turf(src),centered = TRUE)
	template.loaded++
//	world << "<span class='boldannounce'>Ruins loaded.</span>"
	qdel(src)

/obj/effect/template_loader/planet/Load(list/potentialRuins = planet_templates, datum/map_template/template = null)
	var/list/possible_ruins = list()
	for(var/A in potentialRuins)
		var/datum/map_template/T = potentialRuins[A]
		if(!T.loaded)
			possible_ruins += T
//	world << "<span class='boldannounce'>Loading ruins...</span>"
	if(!template && possible_ruins.len)
		template = safepick(possible_ruins)
	if(!template)
//		world << "<span class='boldannounce'>No ruins found.</span>"
		return
	template.load(get_turf(src),centered = TRUE)
	template.loaded++
//	world << "<span class='boldannounce'>Ruins loaded.</span>"
	qdel(src)

/obj/effect/template_loader/underground/Load(list/potentialRuins = underground_templates, datum/map_template/template = null)
	var/list/possible_ruins = list()
	for(var/A in potentialRuins)
		var/datum/map_template/T = potentialRuins[A]
		if(!T.loaded)
			possible_ruins += T
//	world << "<span class='boldannounce'>Loading ruins...</span>"
	if(!template && possible_ruins.len)
		template = safepick(possible_ruins)
	if(!template)
//		world << "<span class='boldannounce'>No ruins found.</span>"
		return
	template.load(get_turf(src),centered = TRUE)
	template.loaded++
//	world << "<span class='boldannounce'>Ruins loaded.</span>"
	qdel(src)

/obj/effect/template_loader/gamemode
	var/mapfile = null
	invisibility = 101

/obj/effect/template_loader/gamemode/Load(list/potentialRuins = map_templates, datum/map_template/template = null)

	for(var/A in potentialRuins)
		var/datum/map_template/T = potentialRuins[A]
//		world << "<span class='boldannounce'>T = [T.name]</span>"
		if(T.name == src.mapfile)
			template = T
//	world << "<span class='boldannounce'>Template = [template] Mapfile = [mapfile]</span>"
	template.load(get_turf(src), centered = TRUE)
	template.loaded++

	qdel(src)


/obj/effect/template_loader/gamemode/assault
	var/maptype = 0
	gamemode = "assault"
/* MATRIXCOMMENT
/obj/effect/template_loader/matrix/Initialize()
	GLOB.SSmatrix.init_matrix_memory(src)
	. = ..()

/obj/effect/template_loader/matrix/Load(var/security_rating = LOW_SEC, datum/map_template/template = null)
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

/obj/effect/template_loader/volcanic

/obj/effect/template_loader/housing