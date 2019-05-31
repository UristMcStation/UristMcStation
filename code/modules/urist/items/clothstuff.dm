/material/cloth/generate_recipes()
	..()

	recipes += new/datum/stack_recipe/makeshiftbandage(src)
	recipes += new/datum/stack_recipe/makeshiftmask(src)
	recipes += new/datum/stack_recipe/rag(src)

/datum/stack_recipe/makeshiftbandage
	title = "makeshift bandage"
	result_type = /obj/item/stack/medical/bruise_pack/makeshift_bandage
	req_amount = 1
	time = 10

/datum/stack_recipe/makeshiftmask
	title = "makeshift mask"
	result_type = /obj/item/clothing/mask/surgical/makeshift_mask
	req_amount = 1
	time = 10

/datum/stack_recipe/rag
	title = "rag"
	result_type = /obj/item/weapon/reagent_containers/glass/rag
	req_amount = 1
	time = 10

/obj/item/clothing/under/attackby(obj/item/I, mob/user)
	if(is_sharp(I))
		user.visible_message("<span class='notice'>\The [user] begins cutting up \the [src] with \a [I].</span>", "<span class='notice'>You begin cutting up \the [src] with \the [I].</span>")
		if(do_after(user, 50, src))
			to_chat(user, "<span class='notice'>You cut \the [src] into pieces!</span>")
			for(var/i in 2 to rand(3,5))
				new /obj/item/stack/material/cloth(get_turf(src))
			qdel(src)
		return
	..()

/obj/item/clothing/mask/surgical/makeshift_mask
	name = "makeshift mask"
	desc = "A cloth mask to weakly help prevent the spread of diseases."
	icon = 'icons/urist/items/improvised.dmi'
	icon_state = "makemask"
	item_state = "makemask"
	w_class = ITEM_SIZE_SMALL
	body_parts_covered = FACE
	item_flags = ITEM_FLAG_FLEXIBLEMATERIAL
	gas_transfer_coefficient = 0.90
	permeability_coefficient = 0.01
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 30, rad = 0)
	down_gas_transfer_coefficient = 1
	down_body_parts_covered = null
	down_icon_state = "steriledown"
	pull_mask = 1

/obj/item/stack/medical/bruise_pack/makeshift_bandage
	name = "makeshift bandages"
	icon = 'icons/urist/items/improvised.dmi'
	singular_name = "makeshift bandage"
	desc = "Some cloth to wrap around wounds"
	icon_state = "makebandage"
	origin_tech = list(TECH_BIO = 1)
	animal_heal = 3

/obj/item/stack/medical/bruise_pack/makeshift_banage/attack(mob/living/carbon/M as mob, mob/user as mob)
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
				if(!do_mob(user, M, W.damage/3))
					to_chat(user, "<span class='notice'>You must stand still to bandage wounds.</span>")
					break
				if (W.current_stage <= W.max_bleeding_stage)
					user.visible_message("<span class='notice'>\The [user] bandages \a [W.desc] on [M]'s [affecting.name].</span>", \
										"<span class='notice'>You bandage \a [W.desc] on [M]'s [affecting.name].</span>" )
					//H.add_side_effect("Itch")
				else if (W.damage_type == BRUISE)
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