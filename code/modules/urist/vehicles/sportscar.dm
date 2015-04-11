/obj/vehicle/train/cargo/engine/sportscar
	name = "sports car"
	desc = "A very luxurious vehicle."
	icon = 'icons/urist/vehicles/sportscar.dmi'
	icon_state = "sportscar_roof"
	emagged = 0
	health = 100
	charge_use = 0
	bound_width = 64
	bound_height = 64
	layer = MOB_LAYER + 0.1


	proc/update_dir_sportscar_overlays()
		overlays = null
		if(src.dir == NORTH||SOUTH||WEST)
			if(src.dir == NORTH)
				var/image/I = new(icon = 'icons/urist/vehicles/sportscar.dmi', icon_state = "sportscar_north", layer = src.layer + 0.2) //over mobs
				overlays += I
				mob_offset_x = 3
				mob_offset_y = 20
			else if(src.dir == SOUTH)
				var/image/I = new(icon = 'icons/urist/vehicles/sportscar.dmi', icon_state = "sportscar_south", layer = src.layer + 0.2) //over mobs
				overlays += I
				mob_offset_x = 10
				mob_offset_y = 27
			else if(src.dir == WEST)
				mob_offset_x = 34
				mob_offset_y = 10
				var/image/I = new(icon = 'icons/urist/vehicles/sportscar.dmi', icon_state = "sportscar_west", layer = src.layer + 0.2) //over mobs
				overlays += I
			else
				var/image/I = new(icon = 'icons/urist/vehicles/sportscar.dmi', icon_state = "sportscar_east", layer = src.layer + 0.2) //over mobs
				mob_offset_x = 20
				mob_offset_y = 23
				overlays += I


/obj/vehicle/train/cargo/engine/sportscar/New()
	..()
	update_dir_sportscar_overlays()

/obj/vehicle/train/cargo/engine/sportscar/Move()
	..()
	update_dir_sportscar_overlays()
