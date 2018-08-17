var/list/datum/map_template/map_templates = list()
var/list/datum/map_template/space_ruins_templates = list()
var/list/datum/map_template/planet_templates = list()
var/list/datum/map_template/underground_templates = list()

/datum/controller/subsystem/mapping/proc/preloadOtherTemplates()
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

/obj/effect/template_loader/proc/Load()
	return

/obj/effect/template_loader/space/Load(list/potentialRuins = space_ruins_templates, datum/map_template/template = null)
	var/list/possible_ruins = list()
	for(var/A in potentialRuins)
		var/datum/map_template/T = potentialRuins[A]
		if(!T.loaded)
			possible_ruins += T
	if(!template && possible_ruins.len)
		template = safepick(possible_ruins)
	if(!template)
		return
	var/turf/central_turf = get_turf(src)
	template.load(central_turf,centered = TRUE)
//	template.loaded++
	QDEL_IN(src,0)

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
	QDEL_IN(src,0)

/obj/effect/template_loader/underground/Load(list/potentialRuins = underground_templates, datum/map_template/template = null)
	var/list/possible_ruins = list()
	for(var/A in potentialRuins)
		var/datum/map_template/T = potentialRuins[A]
		if(!T.loaded)
			possible_ruins += T
	if(!template && possible_ruins.len)
		template = safepick(possible_ruins)
	if(!template)
		return
	var/turf/central_turf = get_turf(src)
	template.load(central_turf,centered = TRUE)
//	template.loaded++
	QDEL_IN(src,0)

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
//	template.loaded++

	QDEL_IN(src,0)


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
