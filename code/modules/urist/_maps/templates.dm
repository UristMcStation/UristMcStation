var/list/datum/map_template/map_templates = list()
var/list/datum/map_template/space_ruins_templates = list()
var/list/datum/map_template/planet_templates = list()
var/list/datum/map_template/underground_templates = list()

/datum/map_template
	var/name = "Default Template Name"
	var/width = 0
	var/height = 0
	var/mappath = null
	var/mapfile = null
	var/loaded = 0 // Times loaded this round

/datum/map_template/New(path = null, map = null, rename = null)
	if(path)
		mappath = path
		preload_size(mappath)
	if(map)
		mapfile = map
	if(rename)
		name = rename

/datum/map_template/proc/preload_size(path)
	var/quote = ascii2text(34)
	var/map_file = file2text(path)
	var/key_len = length(copytext(map_file,2,findtext(map_file,quote,2,0)))
	//assuming one map per file since more makes no sense for templates anyway
	var/mapstart = findtext(map_file,"\n(1,1,") //todo replace with something saner
	var/content = copytext(map_file,findtext(map_file,quote+"\n",mapstart,0)+2,findtext(map_file,"\n"+quote,mapstart,0)+1)
	var/line_len = length(copytext(content,1,findtext(content,"\n",2,0)))

	if((line_len) && (key_len)) //prevents runtimes if it loads an empty/nonexistent file; obscures potential problem, remove line if fixed
		width = line_len/key_len
		height = length(content)/(line_len+1)

/datum/map_template/proc/load(turf/T, centered = FALSE)
	if(centered)
		T = locate(T.x - round(width/2) , T.y - round(height/2) , T.z)
	if(!T)
		return
	if(T.x+width > world.maxx)
		return
	if(T.y+height > world.maxy)
		return

	var/B = block(T,locate(T.x+width-1, T.y+height-1, T.z))

	for(var/L in B)
		var/turf/turf = L

		turfs += turf

		for(var/obj/W in turf)
			if(istype(W,/obj/machinery/atmospherics) || istype(W,/obj/machinery/atm) || istype(W,/obj/machinery/power/apc) || istype(W,/obj/machinery/alarm) || istype(W,/obj/machinery/firealarm) || istype(W,/obj/structure/cable))
				continue
			qdel(W)

/*		for(var/obj/structure/jungle_plant/A in B)
			qdel(A)
		for(var/obj/structure/flora/A in B)
			qdel(A)
		for(var/obj/structure/bush/A in B)
			qdel(A)*/

	maploader.load_map(get_file(), T.x-1, T.y-1, T.z)

	//initialize things that are normally initialized after map load
/*	var/list/obj/machinery/atmospherics/atmos_machines = list()
	var/list/obj/structure/cable/cables = list()
	var/list/atom/atoms = list()

	for(var/L in block(T,locate(T.x+width-1, T.y+height-1, T.z)))
		var/turf/B = L
		for(var/A in B)
			atoms += A
			if(istype(A,/obj/structure/cable))
				cables += A
				continue
			if(istype(A,/obj/machinery/atmospherics))
				atmos_machines += A
				continue

	SSobj.setup_template_objects(atoms)
	SSmachine.setup_template_powernets(cables)
	SSair.setup_template_machinery(atmos_machines)*/

	log_game("[name] loaded at at [T.x],[T.y],[T.z]")
/* MATRIXCOMMENT
/datum/map_template/matrix/load(turf/T, centered = FALSE)
	..(T, centered)
	return locate(/obj/structure/matrix/portal) in B
*/
/datum/map_template/proc/get_file()
	if(mapfile)
		return mapfile
	if(mappath)
		mapfile = file(mappath)
		return mapfile

/datum/map_template/proc/get_affected_turfs(turf/T, centered = FALSE)
	var/turf/placement = T
	if(centered)
		var/turf/corner = locate(placement.x - round(width/2), placement.y - round(height/2), placement.z)
		if(corner)
			placement = corner
	return block(placement, locate(placement.x+width-1, placement.y+height-1, placement.z))


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