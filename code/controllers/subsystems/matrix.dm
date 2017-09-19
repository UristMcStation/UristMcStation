SUBSYSTEM_DEF(matrix)
	name = "Matrix"
	flags = SS_NO_FIRE

//matrix memory vars, they're high quality magic
	var/list/memory_modules
	var/matrix_memory_index = 0
	var/list/memory_entraces

//nodes like to secure their stuff when alerts get called
	var/list/datastores

/datum/controller/subsystem/matrix/Initialize(timeofday)

/datum/controller/subsystem/matrix/proc/check_mem()
	if(matrix_memory_index > memory_modules.len || !memory_modules)
		log_debug("ERROR: Matrix subsystem failed a memory check with [memory_modules ? "[memory_modules.len] modules loaded" : "no memory loaded"].")
		return FALSE
	return TRUE

/datum/controller/subsystem/matrix/proc/get_matrix_map(var/security_level)
	switch(security_level)
		if(HIGH_SEC)
			return "maps/wyrm/templates/matrix/high_sec/" + pick("map1","map2")
		if(MED_SEC)
			return "maps/wyrm/templates/matrix/med_sec/" + pick("map1","map2")
		if(LOW_SEC)
			return "maps/wyrm/templates/matrix/low_sec/" +  pick("map1","map2")

/datum/controller/subsystem/matrix/proc/load_matrix(var/security_level)
	if(!check_mem())
		return
	matrix_memory_index++
	var/obj/effect/landmark/using_mem = memory_modules[matrix_memory_index]
	var/matrix_x = using_mem.x + 1
	var/matrix_y = using_mem.y + 1
	var/matrix_z = using_mem.z
	var/matrix_file = file(get_matrix_map(security_level))

	if(!isfile(matrix_file))
		log_debug("ERROR: Matrix subsystem couldn't get a matrix map file.")
		return FALSE

	maploader.load_map(matrix_file,matrix_x,matrix_y,matrix_z)

/datum/controller/subsystem/matrix/proc/unload_matrix(var/turf/T)
	return
//	var/area/A = get_area(T)
//	var/obj/structure/matrix/portal/P = locate() in A.contents

/datum/controller/subsystem/matrix/proc/register_entrace(var/obj/effect/landmark/L)
	if(!check_mem())
		return
	memory_entraces[matrix_memory_index] = L