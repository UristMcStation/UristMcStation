
// Phoron shards have been moved to code/game/objects/items/weapons/shards.dm

//legacy crystal
/obj/machinery/crystal
	name = "Crystal"
	icon = 'icons/obj/crystals.dmi'
	icon_state = "crystal"


/obj/machinery/crystal/New()
	..()
	icon_state = pick("crystal", "crystal2", "crystal3")


//Variant crystals, in case you want to spawn/map those directly.
/obj/structure/research_crystal
	name = "glowing crystal"
	desc = "A spiky, glowing, crystal. Some parts of it appear to be flaking and could be cut off."
	icon = 'icons/obj/crystals.dmi'
	icon_state = "crystal"
	anchored = TRUE
	density = TRUE
	var/crystal_color = "#5fff47"
	var/crystals_left

/obj/structure/research_crystal/Initialize()
	. = ..()
	crystals_left = rand(1,5)
	set_light(0.3, 0.5, 2, l_color = crystal_color)

/obj/structure/research_crystal/pink
	icon_state = "crystal2"
	crystal_color = "#ff66cc"

/obj/structure/research_crystal/orange
	icon_state = "crystal3"
	crystal_color = "#ffbf66"

/obj/structure/research_crystal/cyan
	icon_state = "crystal4"
	crystal_color = "#66d9ff"

/obj/structure/research_crystal/use_tool(obj/item/O as obj, mob/user as mob)
	if(is_sharp(O))
		if(crystals_left > 0)
			to_chat(SPAN_NOTICE("You begin to cut into a weak area of \the [src]"))
			if(do_after(user, 1.5 SECONDS))
				to_chat(user, SPAN_NOTICE("You slice off a piece of \the [src] with \the [O]."))
				new /obj/item/research_crystal(get_turf(user),crystal_color)
				crystals_left--
				if(!crystals_left)
					set_light(0,0,0)
					to_chat(user, SPAN_WARNING("\The [src] goes dark as a thick liquid oozes out of the last place you cut!"))
				return
			else
				to_chat(user, SPAN_NOTICE("You decide to not touch \the [src]."))
				return
		else
			to_chat(user, SPAN_NOTICE("There doesn't seem to be any shards left large enough to collect."))
			return
	..()

/obj/item/research_crystal
	name = "crystal shard"
	desc = "A glowing shard from a crystal, it seems to hum while you hold it."
	icon = 'icons/obj/materials/shards.dmi'
	icon_state = "shardlarge"
	origin_tech = list(TECH_MATERIAL = 6, TECH_POWER = 3, TECH_ELECTROMAGNETIC = 7)

/obj/item/research_crystal/New(turf/T, crystal_color)
	..(T)
	color = crystal_color
	icon_state = pick("shardlarge","shardmedium","shardsmall")
	create_reagents(15)
	reagents.add_reagent(/datum/reagent/silicon, rand(5,10))
	reagents.add_reagent(/datum/reagent/lithium, rand(2,5)) //arbitrary chem to assist in making three eye

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
