/obj/machinery/door //i simply refuse
	autoset_access = FALSE

/datum/map/glloydstation/get_map_info()
	. = list()
	. +=  "You're aboard the <b>NSS Urist</b>, a top of the line NanoTrasen scientific space station, orbiting a geneseeded world on the frontier of human settlement."
	. +=  "As employees of NanoTrasen, it is your job to advance our scientific understanding, whether through studying the relatively new material 'phoron,' experimenting with the unstable supermatter shard or the singularity, or studying the artifacts found on or below the planet's surface."
	. +=  "This being the edge of settled space, there are many hazards, including pirates, operatives from hostile corporations, hostile alien life forms, and much more. You've also heard rumours about some space stations in this area being destroyed by an unknown alien force. It's probably nothing though... Ah well, it's all just another day on a NanoTrasen space station in the year 2556."
	return jointext(., "<br>")

/datum/map/glloydstation/get_skybox_image()
	var/image/base = image('icons/skybox/planet.dmi', "base")
	base.color = "#538224"

	var/image/skybox_image = image('icons/skybox/planet.dmi', "")
	skybox_image.overlays += base

	var/image/water = image('icons/skybox/planet.dmi', "water")
	water.color = "#1e160a"
	water.appearance_flags = DEFAULT_APPEARANCE_FLAGS | PIXEL_SCALE
	skybox_image.overlays += water

	var/image/clouds = image('icons/skybox/planet.dmi', "weak_clouds")

	clouds.overlays += image('icons/skybox/planet.dmi', "clouds")

	clouds.color = COLOR_WHITE
	skybox_image.overlays += clouds

	var/image/atmo = image('icons/skybox/planet.dmi', "atmoring")
	skybox_image.underlays += atmo

	var/image/shadow = image('icons/skybox/planet.dmi', "shadow")
	shadow.blend_mode = BLEND_MULTIPLY
	skybox_image.overlays += shadow

	var/image/light = image('icons/skybox/planet.dmi', "lightrim")
	skybox_image.overlays += light

	skybox_image.pixel_x = rand(0,64)
	skybox_image.pixel_y = rand(128,256)
	skybox_image.appearance_flags = DEFAULT_APPEARANCE_FLAGS | RESET_COLOR
	skybox_image.blend_mode = BLEND_OVERLAY

	return skybox_image

/datum/random_map/automata/cave_system/glloydplanet
	floor_type = /turf/simulated/floor/asteroid/glloydplanet

/datum/map/glloydstation/perform_map_generation()
	new /datum/random_map/automata/cave_system/glloydplanet(null, 1, 1, 5, 255, 255) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, 5, 64, 64)         // Create the mining ore distribution map.
	return 1