//rename to sportscar if you need
//mostly, my changes just update the C.pixel_ y and x on every iteration of the overlay update proc, since default vehicle code //only does that upon entering. Watch the weird formatting pastebin introduces.

/obj/vehicle/train/cargo/engine/sportscar
	name = "sports car"
	desc = "A very luxurious vehicle."
	icon = 'icons/urist/vehicles/sportscar.dmi'
	icon_state = "sportscar"
	emagged = FALSE
	health = 100
	charge_use = 0
	bound_width = 64
	bound_height = 64


/obj/vehicle/train/cargo/engine/sportscar/proc/update_dir_sportscar_overlays()
	var/atom/movable/C = src.load
	ClearOverlays()
	if(src.dir == NORTH||SOUTH||WEST)
		if(src.dir == NORTH)
			var/image/I = new(icon = 'icons/urist/vehicles/sportscar.dmi', icon_state = "sportscar_north", layer = src.layer + 0.2) //over mobs
			AddOverlays(I)
			src.mob_offset_x = 16
			src.mob_offset_y = 20
		else if(src.dir == SOUTH)
			var/image/I = new(icon = 'icons/urist/vehicles/sportscar.dmi', icon_state = "sportscar_south", layer = src.layer + 0.2) //over mobs
			AddOverlays(I)
			src.mob_offset_x = 20
			src.mob_offset_y = 27
		else if(src.dir == WEST)
			src.mob_offset_x = 34
			src.mob_offset_y = 25
			var/image/I = new(icon = 'icons/urist/vehicles/sportscar.dmi', icon_state = "sportscar_west", layer = src.layer + 0.2) //over mobs
			AddOverlays(I)
		else if(src.dir == EAST)
			var/image/I = new(icon = 'icons/urist/vehicles/sportscar.dmi', icon_state = "sportscar_east", layer = src.layer + 0.2) //over mobs
			src.mob_offset_x = 20
			src.mob_offset_y = 23
			AddOverlays(I)
	if(ismob(C))
		C.pixel_y = src.mob_offset_y
		C.pixel_x = src.mob_offset_x


/obj/vehicle/train/cargo/engine/sportscar/New()
	..()
	update_dir_sportscar_overlays()

/obj/vehicle/train/cargo/engine/sportscar/Move()
	..()
	update_dir_sportscar_overlays()
