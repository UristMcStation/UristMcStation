/obj/item/stack/medical/chem_patch
	name = "chem patch"
	desc = "A membrane coated with skin-permeable carrier chemicals. On other words, stick it on you."
	animal_heal = 0
	heal_brute = 0
	heal_burn = 0
	w_class = ITEM_SIZE_TINY
	amount = 1
	max_amount = 1
	icon_state = "brutepack"
	var/mob/living/carbon/affecting_mob // what mob are we affecting?
	var/transfer_per_tick = 0.5

/obj/item/stack/medical/chem_patch/Initialize()
	. = ..()
	create_reagents(60)

/obj/item/stack/medical/chem_patch/Destroy()
	affecting_mob = null
	..()

/obj/item/stack/medical/chem_patch/attack(mob/living/carbon/M as mob, mob/user as mob)
	if(..())
		return 1

	if (istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affecting = H.get_organ(user.zone_sel.selecting) //nullchecked by ..()
		var/limb = affecting.name
		user.visible_message("<span class='danger'>[user] starts to apply \the [src] to [M]'s [limb].</span>", "<span class='danger'>You start to apply \the [src] to [M]'s [limb].</span>", "<span class='danger'>You hear something being wrapped.</span>")
		if(do_after(user, 10, M))
			user.remove_from_mob(src)
			reagents.trans_to_mob(affecting_mob, reagents.total_volume, CHEM_PATCH)

			if (M != user)
				user.visible_message("<span class='danger'>\The [user] finishes applying [src] to [M]'s [limb].</span>", "<span class='danger'>You finish applying \the [src] to [M]'s [limb].</span>", "<span class='danger'>You hear something being wrapped.</span>")
			else
				user.visible_message("<span class='danger'>\The [user] successfully applies [src] to their [limb].</span>", "<span class='danger'>You successfully apply \the [src] to your [limb].</span>", "<span class='danger'>You hear something being wrapped.</span>")
			qdel(src)

/obj/item/stack/medical/chem_patch/test
	name = "test patch"

/obj/item/stack/medical/chem_patch/test/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/space_drugs, 60)