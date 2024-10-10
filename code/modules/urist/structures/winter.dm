//below are ported from polaris. snow time!

/obj/structure/snowman
	name = "snowman"
	icon = 'icons/urist/structures&machinery/snowman.dmi'
	icon_state = "snowman"
	desc = "A happy little snowman smiles back at you!"
	anchored = TRUE

/obj/structure/snowman/attack_hand(mob/user as mob)
	if(user.a_intent == I_HURT)
		to_chat(user, SPAN_NOTICE("In one hit, [src] easily crumples into a pile of snow. You monster."))
		var/turf/simulated/floor/F = get_turf(src)
		if (istype(F))
			new /obj/item/stack/material/snow(F)
		qdel(src)

/obj/structure/snowman/borg
	name = "snowborg"
	icon_state = "snowborg"
	desc = "A snowy little robot. It even has a monitor for a head."

/obj/structure/snowman/spider
	name = "snow spider"
	icon_state = "snowspider"
	desc = "An impressively crafted snow spider. Not nearly as creepy as the real thing."

/obj/item/material/snow/snowball
	name = "loose packed snow ball"
	desc = "A fun snowball. Throw it at your friends!"
	icon = 'icons/urist/items/snow.dmi'
	icon_state = "snowball"
	default_material = MATERIAL_SNOW
	health_max = 1
	force_multiplier = 0.01
	thrown_force_multiplier = 0.1
	applies_material_name = FALSE
	w_class = ITEM_SIZE_SMALL
	attack_verb = list("mushed", "splatted", "splooshed", "splushed") // Words that totally exist.

/obj/item/material/snow/snowball/attack_self(mob/user as mob)
	if(user.a_intent == I_HURT)
		to_chat(user, SPAN_NOTICE("You smash the snowball in your hand."))
		var/atom/S = new /obj/item/stack/material/snow(user.loc)
		qdel(src)
		user.put_in_hands(S)
	else
		to_chat(user, SPAN_NOTICE("You start compacting the snowball."))
		if(do_after(user, 2 SECONDS))
			var/atom/S = new /obj/item/material/snow/snowball/reinforced(user.loc)
			qdel(src)
			user.put_in_hands(S)

/obj/item/material/snow/snowball/reinforced
	name = "snowball"
	desc = "A well-formed and fun snowball. It looks kind of dangerous."
	force_multiplier = 5
	thrown_force_multiplier = 5

/obj/item/stack/material/snow
	name = "snow"
	desc = "The temptation to build a snowman rises."
	icon_state = "sheet-snow"
	default_type = "snow"
	icon = 'icons/urist/items/snow.dmi'

/turf/simulated/floor/attack_hand(mob/user)
	if (!user.pulling && has_snow)
		visible_message(SPAN_NOTICE("[user] starts scooping up some snow..."), SPAN_NOTICE("You start scooping up some snow..."))
		if(do_after(user, 1 SECOND))
			var/obj/S = new /obj/item/stack/material/snow(user.loc)
			user.put_in_hands(S)
			visible_message(SPAN_NOTICE("[user] scoops up a pile of snow."), SPAN_NOTICE("You scoop up a pile of snow."))
		return
	return ..()
