
// Phoron shards have been moved to code/game/objects/items/weapons/shards.dm

//legacy crystal
/obj/machinery/crystal
	name = "Crystal"
	icon = 'icons/obj/mining.dmi'
	icon_state = "crystal"


/obj/machinery/crystal/New()
	..()
	icon_state = pick("crystal", "crystal2", "crystal3")


//Variant crystals, in case you want to spawn/map those directly.
/obj/machinery/crystal_static
	name = "Crystal"
	icon = 'icons/obj/mining.dmi'
	icon_state = "crystal"
	var/crystal_color = "#5fff47"

/obj/machinery/crystal_static/New()
	..()
	set_light(l_range = 2, l_power = 2, l_color = crystal_color)

/obj/machinery/crystal_static/pink
	icon_state = "crystal2"
	crystal_color = "#ff66cc"

/obj/machinery/crystal_static/orange
	icon_state = "crystal3"
	crystal_color = "#ffbf66"

/obj/machinery/crystal_static/cyan
	icon_state = "crystal4"
	crystal_color = "#66d9ff"


//large finds
				/*
				obj/machinery/syndicate_beacon
				obj/machinery/wish_granter
			if(18)
				item_type = "jagged green crystal"
				additional_desc = pick("It shines faintly as it catches the light.","It appears to have a faint inner glow.","It seems to draw you inward as you look it at.","Something twinkles faintly as you look at it.","It's mesmerizing to behold.")
				icon_state = "crystal"
				apply_material_decorations = 0
				if(prob(10))
					apply_image_decorations = 1
			if(19)
				item_type = "jagged pink crystal"
				additional_desc = pick("It shines faintly as it catches the light.","It appears to have a faint inner glow.","It seems to draw you inward as you look it at.","Something twinkles faintly as you look at it.","It's mesmerizing to behold.")
				icon_state = "crystal2"
				apply_material_decorations = 0
				if(prob(10))
					apply_image_decorations = 1
				*/
			//machinery type artifacts?
