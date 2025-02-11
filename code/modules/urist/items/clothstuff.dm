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
		to_chat(usr, "<span class='notice'>You aren't holding anything to cut with.</span>")
		return

	if(is_sharp(I))
		usr.visible_message("<span class='notice'>\The [usr] begins cutting up \the [src] with \a [I].</span>", "<span class='notice'>You begin cutting up \the [src] with \the [I].</span>")
		if(do_after(usr, 50, src))
			to_chat(usr, "<span class='notice'>You cut \the [src] into pieces!</span>")
			for(var/i in 2 to rand(3,5))
				new /obj/item/stack/material/cloth(get_turf(src))
			for(var/obj/O in src.contents)
				O.dropInto(loc)
			qdel(src)
	else
		to_chat(usr, "<span class='notice'>You need something sharper to cut with!</span>")
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

/obj/item/stack/medical/bruise_pack/makeshift_bandage/attack(mob/living/carbon/M as mob, mob/user as mob)
	if(..())
		return 1
	if (istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affecting = H.get_organ(user.zone_sel.selecting) //nullchecked by ..()
		if(affecting.is_bandaged())
			to_chat(user, "<span class='warning'>The wounds on [M]'s [affecting.name] have already been bandaged.</span>")
			return 1
		else
			user.visible_message("<span class='notice'>\The [user] begins hastily treating [M]'s [affecting.name].</span>", \
								"<span class='notice'>You begin hastily treating [M]'s [affecting.name].</span>" )
			var/used = 0
			for (var/datum/wound/W in affecting.wounds)
				if(W.bandaged)
					continue
				if(used == amount)
					break
				if(!do_after(user, M, W.damage/3))
					to_chat(user, "<span class='notice'>You must stand still to bandage wounds.</span>")
					break
				if (W.current_stage <= W.max_bleeding_stage)
					user.visible_message("<span class='notice'>\The [user] bandages \a [W.desc] on [M]'s [affecting.name].</span>", \
										"<span class='notice'>You bandage \a [W.desc] on [M]'s [affecting.name].</span>" )
					//H.add_side_effect("Itch")
				else if (W.damage_type == DAMAGE_BRUTE)
					user.visible_message("<span class='notice'>\The [user] places a rugged bandage over \a [W.desc] on [M]'s [affecting.name].</span>", \
											"<span class='notice'>You place a rugged bandage over \a [W.desc] on [M]'s [affecting.name].</span>" )
				else
					user.visible_message("<span class='notice'>\The [user] places a rugged bandage over \a [W.desc] on [M]'s [affecting.name].</span>", \
											"<span class='notice'>You place a rugged bandage over \a [W.desc] on [M]'s [affecting.name].</span>" )
				W.bandage()
				used++
			affecting.update_damages()
			if(used == amount)
				if(affecting.is_bandaged())
					to_chat(user, "<span class='warning'>\The [src] is used up.</span>")
				else
					to_chat(user, "<span class='warning'>\The [src] is used up, but there are more wounds to treat on \the [affecting.name].</span>")
			use(used)

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

/obj/item/loom/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/reagent_containers/food/snacks/grown))
		var/obj/item/reagent_containers/food/snacks/grown/plant = W
		if(plant.seed?.chems)
			if(!isnull(plant.seed.chems[/datum/reagent/cottonfiber]))
				user.visible_message(SPAN_NOTICE("\The [user] weaves \the [plant] into cotton cloth"), SPAN_NOTICE("You weave \the [plant] into cotton cloth"))
				new /obj/item/stack/material/cloth(user.loc)
				qdel(plant)
				return
	..()
