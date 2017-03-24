/obj/vehicle/train/cargo/engine/motorcycle_4dir
	name = "motorcycle"
	desc = "A fast and highly maneuverable vehicle."
	icon = 'icons/urist/vehicles/uristvehicles.dmi'
	icon_state = "motorcycle_4dir"
	emagged = 0
	mob_offset_y = 6
	load_offset_x = 0
	health = 150
	charge_use = 0

	proc/update_dir_motorcycle_overlays()
		overlays = null
		if(src.dir == NORTH||SOUTH)
			if(src.dir == NORTH)
				var/image/I = new(icon = 'icons/urist/vehicles/uristvehicles.dmi', icon_state = "motorcycle_overlay_n", layer = src.layer + 0.2) //over mobs
				overlays += I
			else if(src.dir == SOUTH)
				var/image/I = new(icon = 'icons/urist/vehicles/uristvehicles.dmi', icon_state = "motorcycle_overlay_s", layer = src.layer + 0.2) //over mobs
				overlays += I
		else
			var/image/I = new(icon = 'icons/urist/vehicles/uristvehicles.dmi', icon_state = "motorcycle_overlay_side", layer = src.layer + 0.2) //over mobs
			overlays += I

/obj/vehicle/train/cargo/engine/motorcycle_4dir/New()
	..()
	update_dir_motorcycle_overlays()

/obj/vehicle/train/cargo/engine/motorcycle_4dir/Move()
	..()
	update_dir_motorcycle_overlays()

/obj/vehicle/train/cargo/engine/motorcycle_1dir
	name = "motorcycle"
	desc = "A fast and highly maneuverable vehicle."
	icon = 'icons/urist/vehicles/uristvehicles.dmi'
	icon_state = "motorcycle"
	emagged = 1
	mob_offset_y = 6
	load_offset_x = 0
	health = 250
	charge_use = 0

/obj/vehicle/train/cargo/engine/motorcycle_1dir/New()
	..()
	overlays = null
	var/image/I = new(icon = 'icons/urist/vehicles/uristvehicles.dmi', icon_state = "motorcycle_overlay_n", layer = src.layer + 0.2) //over mobs
	overlays += I

/obj/vehicle/train/cargo/engine/motorcycle_1dir/Move()
	..()
	load.dir = NORTH //the bikes used on the trains just speed up and slow down, so they always face north - so should the mob.