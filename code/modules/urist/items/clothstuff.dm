//clothstuff
//recipes moved to urist/modules/materials/recipes_cloth.dm

/obj/item/clothing/under/verb/cut()
	set name = "Cut up clothing"
	set desc = "Cut some clothes into cloth."
	set category = "Object"
	set src in oview(1)

	if (!can_touch(usr))
		return

	var/obj/item/I = usr.get_active_hand()
	if(!I)
		to_chat(usr, SPAN_NOTICE("You aren't holding anything to cut with."))
		return

	if(is_sharp(I))
		usr.visible_message(SPAN_NOTICE("\The [usr] begins cutting up \the [src] with \a [I]."), SPAN_NOTICE("You begin cutting up \the [src] with \the [I]."))
		if(do_after(usr, 50, src))
			to_chat(usr, SPAN_NOTICE("You cut \the [src] into pieces!"))
			for(var/i in 2 to rand(3,5))
				new /obj/item/stack/material/cloth(get_turf(src))
			for(var/obj/O in src.contents)
				O.dropInto(loc)
			qdel(src)
	else
		to_chat(usr, SPAN_NOTICE("You need something sharper to cut with!"))
	return

/obj/item/clothing/mask/surgical/makeshift_mask
	name = "makeshift mask"
	desc = "A cloth mask to weakly help prevent the spread of diseases."
	icon = 'icons/urist/items/improvised.dmi'
	icon_state = "makemask"
	item_state = "makemask"
	item_icons = URIST_ALL_ONMOBS
	w_class = ITEM_SIZE_SMALL
	body_parts_covered = FACE
	item_flags = ITEM_FLAG_FLEXIBLEMATERIAL
	gas_transfer_coefficient = 0.90
	permeability_coefficient = 0.01
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 30, rad = 0)
	down_gas_transfer_coefficient = 1
	down_body_parts_covered = null
	down_icon_state = "makemaskdown"
	pull_mask = 1

/obj/item/stack/medical/bruise_pack/makeshift_bandage
	name = "makeshift bandages"
	icon = 'icons/urist/items/improvised.dmi'
	singular_name = "makeshift bandage"
	desc = "Some cloth to wrap around wounds"
	icon_state = "makebandage"
	origin_tech = list(TECH_BIO = 1)
	animal_heal = 3

/obj/item/stack/medical/bruise_pack/makeshift_bandage/use_before(atom/target, mob/user as mob, click_params)
	var/mob/living/carbon/human/H = target

	if (!istype(H))
		return ..()

	var/obj/item/organ/external/affecting = H.get_organ(user.zone_sel.selecting) //nullchecked by ..()
	if(affecting.is_bandaged())
		to_chat(user, SPAN_WARNING("The wounds on [H]'s [affecting.name] have already been bandaged."))
		return TRUE

	else
		user.visible_message(SPAN_NOTICE("\The [user] begins hastily treating [H]'s [affecting.name]."), \
							SPAN_NOTICE("You begin hastily treating [H]'s [affecting.name].") )
		var/used = 0

		for(var/datum/wound/W in affecting.wounds)
			if(W.bandaged)
				continue

			if(used == amount)
				break

			if(!do_after(user, H, W.damage/3))
				to_chat(user, SPAN_NOTICE("You must stand still to bandage wounds."))
				break

			if (W.current_stage <= W.max_bleeding_stage)
				user.visible_message(SPAN_NOTICE("\The [user] bandages \a [W.desc] on [H]'s [affecting.name]."), \
									SPAN_NOTICE("You bandage \a [W.desc] on [H]'s [affecting.name].") )
				//H.add_side_effect("Itch")
			else if (W.damage_type == DAMAGE_BRUTE)
				user.visible_message(SPAN_NOTICE("\The [user] places a rugged bandage over \a [W.desc] on [H]'s [affecting.name]."), \
										SPAN_NOTICE("You place a rugged bandage over \a [W.desc] on [H]'s [affecting.name].") )
			else
				user.visible_message(SPAN_NOTICE("\The [user] places a rugged bandage over \a [W.desc] on [H]'s [affecting.name]."), \
										SPAN_NOTICE("You place a rugged bandage over \a [W.desc] on [H]'s [affecting.name].") )

			W.bandage()
			used++

		affecting.update_damages()

		if(used == amount)
			if(affecting.is_bandaged())
				to_chat(user, SPAN_WARNING("\The [src] is used up."))
			else
				to_chat(user, SPAN_WARNING("\The [src] is used up, but there are more wounds to treat on \the [affecting.name]."))

		use(used)
		return TRUE

/obj/item/loom
	name = "table loom"
	desc = "A loom small enough to only take up a table instead of the whole floor."
	icon = 'icons/urist/items/wood.dmi'
	icon_state = "loom"
	w_class = 4 //a table loom is small only by comparison to a floor loom.

/datum/reagent/cottonfiber
	name = "cotton fiber"
	description = "A mass of cotton fibers."
	taste_description = "cotton"
	reagent_state = SOLID
	color = "#f0f0f0"

/datum/seed/cotton
	name = "cotton"
	seed_name = "cotton"
	display_name = "cotton plant"
	chems = list(/datum/reagent/cottonfiber = list(6,1))

/datum/seed/cotton/New()
	..()
	set_trait(TRAIT_MATURATION,10)
	set_trait(TRAIT_PRODUCTION,1)
	set_trait(TRAIT_YIELD,8)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"cotton")
	set_trait(TRAIT_PRODUCT_COLOUR,"#f0f0f0")
	set_trait(TRAIT_PLANT_ICON,"bush2")
	set_trait(TRAIT_WATER_CONSUMPTION, 6)

/obj/item/seeds/cotton
	seed_type = "cotton"

/obj/item/loom/use_tool(obj/item/W, mob/living/user, list/click_params)
	if(istype(W, /obj/item/reagent_containers/food/snacks/grown))
		var/obj/item/reagent_containers/food/snacks/grown/plant = W
		if(plant.seed?.chems)
			if(!isnull(plant.seed.chems[/datum/reagent/cottonfiber]))
				user.visible_message(SPAN_NOTICE("\The [user] weaves \the [plant] into cotton cloth"), SPAN_NOTICE("You weave \the [plant] into cotton cloth"))
				new /obj/item/stack/material/cloth(user.loc)
				qdel(plant)
				return
	..()
