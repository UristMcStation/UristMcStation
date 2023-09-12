// beautiful lighting because fabulous

/obj/machinery/light/colored
	name = "light fixture"
	icon = 'icons/urist/citymap_icons/coloredlights.dmi'
	base_state = "yellow"		// base description and icon_state
	icon_state = "yellow1"
	desc = "A lighting fixture."
//	brightness_range = 9
//	brightness_power = 10

/obj/machinery/light/colored/orange
	base_state = "orange"		// base description and icon_state
	icon_state = "orange1"
	light_type = /obj/item/light/tube/large/neon/orange

/obj/machinery/light/colored/purple
	base_state = "purple"		// base description and icon_state
	icon_state = "purple1"
	light_type = /obj/item/light/tube/large/neon/purple

/obj/machinery/light/colored/red
	base_state = "red"		// base description and icon_state
	icon_state = "red1"
	light_type = /obj/item/light/tube/large/neon/red


/obj/machinery/light/colored/pink
	base_state = "pink"		// base description and icon_state
	icon_state = "pink1"
	light_type = /obj/item/light/tube/large/neon/pink

/obj/machinery/light/colored/blue
	base_state = "blue"		// base description and icon_state
	icon_state = "blue1"
	light_type = /obj/item/light/tube/large/neon/blue

/obj/machinery/light/colored/green
	base_state = "green"		// base description and icon_state
	icon_state = "green1"
	light_type = /obj/item/light/tube/large/neon/green


//colored bulbs

/obj/item/light/tube/large/neon/red
	color = "#feebeb"
//	brightness_color = "#feebeb"
	light_color = "#feebeb"

/obj/item/light/tube/large/neon/orange
	color = "#fef9eb"
//	brightness_color = "#fef9eb"
	light_color = "#fef9eb"

/obj/item/light/tube/large/neon/purple
	color = "#fcebfe"
//	brightness_color = "#fcebfe"
	light_color = "#fcebfe"

/obj/item/light/tube/large/neon/pink
	color = "#fff9f9"
//	brightness_color = "#fff9f9"
	light_color = "#fff9f9"

/obj/item/light/tube/large/neon/blue
	color = "#ebf7fe"
//	brightness_color = "#ebf7fe"
	light_color = "#ebf7fe"

/obj/item/light/tube/large/neon/green
	color = "#ebfeec"
//	brightness_color = "#ebfeec"
	light_color = "#ebfeec"

/obj/machinery/light/floor
	icon_state = "floor1"
	base_state = "floor"
	layer = BELOW_OBJ_LAYER
//	plane = HIDING_MOB_LAYER
	light_type = /obj/item/light/bulb
//	brightness_range = 4
//	brightness_power = 2
//	brightness_color = "#a0a080"

/obj/machinery/light/overhead_blue
	icon = 'icons/urist/citymap_icons/floorlights.dmi'
	icon_state = "inv1"
	base_state = "inv"
//	brightness_range = 10
//	brightness_power = 1.5
//	brightness_color = "#0080ff"

/obj/machinery/light/street
	name = "street lamp"
	icon = 'icons/urist/citymap_icons/street.dmi'
	icon_state = "streetlamp1"
	base_state = "streetlamp"
	desc = "A street lighting fixture."
//	brightness_range = 8
//	brightness_color = "#0080ff"
//	light_type = /obj/item/light/streetbulb

/obj/machinery/light/street/attack_hand(mob/user)
	return

/obj/machinery/light/invis
	icon = 'icons/urist/citymap_icons/floorlights.dmi'
	icon_state = "inv1"
	base_state = "inv"
//	brightness_range = 8

/obj/structure/grille/smallfence
	icon = 'icons/urist/citymap_icons/structures.dmi'
	name = "small fence"
	icon_state = "fence"

/obj/structure/grille/frame
	icon = 'icons/urist/citymap_icons/structures.dmi'
	name = "frame"
	icon_state = "frame"

//BILLBOARDS

/obj/machinery/billboard
	name = "billboard"
	desc = "A billboard"
	icon = 'icons/urist/citymap_icons/billboards.dmi'
	icon_state = "billboard"
	density = FALSE
	anchored = TRUE
	use_power = POWER_USE_ACTIVE
	idle_power_usage = 2
	active_power_usage = 20
	layer = ABOVE_HUMAN_LAYER
//	plane = ABOVE_HUMAN_LAYER
	power_channel = LIGHT
	bounds = "64,32"
	pixel_y = 10
	var/on = 0
	var/default_light_max_bright = 0.8
	var/default_light_inner_range = 1
	var/default_light_outer_range = 4
	var/default_light_colour = "#ebf7fe"  //white blue
	var/ads = list(			"ssl",
							"ntbuilding",
							"keeptidy",
							"smoke",
							"tunguska",
							"vets",
							"fitness",
							"movie1",
							"movie2",
							"blank",
							"legalcoke",
							"pollux",
							"vacay",
							"atluscity",
							"sunstar",
							"speedweed",
							"golf",
							"chonkers")
	var/current_ad

/obj/machinery/billboard/on_update_icon()
	..()
	overlays.Cut()

	if(!current_ad)
		overlays += pick(ads)
	else
		overlays += current_ad

/obj/machinery/billboard/Initialize()
	.=..()
	icon_state = "[initial(icon_state)][rand(1,4)]"

	update_icon()

	on = powered()

	if(!on)
		update_use_power(POWER_USE_OFF)

/obj/machinery/billboard/proc/update_brightness()
	if(on && !light_max_bright)
		update_use_power(POWER_USE_ACTIVE)
		set_light(default_light_max_bright, default_light_inner_range, default_light_outer_range, l_color = default_light_colour)
	else
		update_use_power(POWER_USE_OFF)
		if(light_outer_range || light_max_bright)
			set_light(0)

//	change_power_consumption((light_outer_range + light_max_bright) * 20, POWER_USE_ACTIVE)

/obj/machinery/billboard/power_change()
	..()
	spawn(10)
		on = powered()
		update_brightness()

/obj/machinery/billboard/Destroy()
	var/area/A = get_area(src)
	if(A)
		on = 0
	. = ..()

/obj/machinery/billboard/city
	name = "city billboard"
	desc = "A billboard"
	icon_state = "welcome"
	default_light_colour = "#bbfcb6"  //watered lime
