
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
	name = "\improper Crystal"
	icon = 'icons/obj/mining.dmi'
	icon_state = "crystal"
	anchored = 1
	density = 1
	var/crystal_color = "#5fff47"
	var/collected

/obj/machinery/crystal_static/New()
	..()
	collected = rand(-3,0)
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

/obj/machinery/crystal_static/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(is_sharp(O))
		if(collected <= 0)
			if(do_after(user, 3 SECONDS))
				to_chat(user, "You slice off a piece of the crystal with \the [O].")
				new /obj/item/research_crystal(get_turf(user),crystal_color)
				collected++
				return
			else
				to_chat(user, "You decide to not touch the glowing [src].")
				return
		else
			to_chat(user, "There doesn't seem to be any shards large enough to collect.")
			return
	..()

/obj/item/research_crystal
	name = "crystal shard"
	desc = "A glowing shard from a crystal, it seems to hum while you hold it."
	icon = 'icons/obj/shards.dmi'
	icon_state = "shardlarge"
	origin_tech = list(TECH_MATERIAL = 6, TECH_POWER = 3, TECH_ELECTROMAGNETIC = 7)

/obj/item/research_crystal/New(var/turf/T, var/crystal_color)
	..(T)
	color = crystal_color
	icon_state = pick("shardlarge","shardmedium","shardsmall")

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
