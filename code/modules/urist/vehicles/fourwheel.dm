/obj/vehicle/train/cargo/engine/fourwheeler //make this hold passengers
	name = "four-wheeler"
	desc = "A fast and highly maneuverable vehicle."
	icon = 'icons/urist/vehicles/uristvehicles.dmi'
	icon_state = "4wheeler"
	emagged = FALSE
	mob_offset_y = 6
	load_offset_x = 0
	health_max = 300
	charge_use = 0

/obj/vehicle/train/cargo/engine/fourwheeler/proc/update_dir_fourwheel_overlays()
	overlays = null
	if(src.dir == NORTH||SOUTH)
		if(src.dir == NORTH)
			var/image/I = new(icon = 'icons/urist/vehicles/uristvehicles.dmi', icon_state = "4wheeler_north", layer = src.layer + 0.2) //over mobs
			overlays += I
		else if(src.dir == SOUTH)
			var/image/I = new(icon = 'icons/urist/vehicles/uristvehicles.dmi', icon_state = "4wheeler_south", layer = src.layer + 0.2) //over mobs
			overlays += I

/obj/vehicle/train/cargo/engine/fourwheeler/New()
	..()
	update_dir_fourwheel_overlays()

/obj/vehicle/train/cargo/engine/fourwheeler/Move()
	..()
	update_dir_fourwheel_overlays()
