/obj/overmap/visitable/sector/planetoid
	name = "a generic planetoid"
	is_planet = TRUE
	sector_flags = OVERMAP_SECTOR_KNOWN //planetoids are known, like exoplanets. still can't spacewalk to them though.

	var/static_name = null // if we don't want to generate a name
	var/atmo_color = COLOR_WHITE //do we have atmos, and if so, what color are the clouds
	var/has_rings = FALSE //do we have rings?

/obj/overmap/visitable/sector/planetoid/New(nloc, max_x, max_y)
	if(!static_name)
		name = "[generate_planet_name()], \a [name]"

	..()

/obj/overmap/visitable/sector/planetoid/Initialize()
	. = ..()

	generate_planet_image()

/obj/overmap/visitable/sector/planetoid/get_skybox_representation()
	return skybox_image

/obj/overmap/visitable/sector/planetoid/generate_planet_image()
	if(!surface_color)
		surface_color = color

	var/image/base = image('icons/skybox/planet.dmi', "base")
	base.color = surface_color

	skybox_image = image('icons/skybox/planet.dmi', "")

	skybox_image.AddOverlays(base)

	if (water_color)
		var/image/water = image('icons/skybox/planet.dmi', "water")
		water.color = water_color
		water.appearance_flags = DEFAULT_APPEARANCE_FLAGS | PIXEL_SCALE
		water.SetTransform(rotation = rand(0, 360))
		skybox_image.AddOverlays(water)

	if (atmo_color)

		var/image/clouds = image('icons/skybox/planet.dmi', "weak_clouds")

		if (water_color)
			clouds.AddOverlays(image('icons/skybox/planet.dmi', "clouds"))

		clouds.color = atmo_color
		skybox_image.AddOverlays(clouds)

		var/image/atmo = image('icons/skybox/planet.dmi', "atmoring")
		skybox_image.underlays += atmo

	var/image/shadow = image('icons/skybox/planet.dmi', "shadow")
	shadow.blend_mode = BLEND_MULTIPLY
	skybox_image.AddOverlays(shadow)

	var/image/light = image('icons/skybox/planet.dmi', "lightrim")
	skybox_image.AddOverlays(light)

	if (has_rings)
		var/image/rings = image('icons/skybox/planet_rings.dmi')
		rings.icon_state = pick("sparse", "dense")
		rings.color = pick("#f0fcff", "#dcc4ad", "#d1dcad", "#adb8dc")
		rings.pixel_x = -128
		rings.pixel_y = -128
		skybox_image.AddOverlays(rings)

	skybox_image.pixel_x = rand(0,64)
	skybox_image.pixel_y = rand(128,256)
	skybox_image.appearance_flags = DEFAULT_APPEARANCE_FLAGS | RESET_COLOR
	skybox_image.blend_mode = BLEND_OVERLAY
