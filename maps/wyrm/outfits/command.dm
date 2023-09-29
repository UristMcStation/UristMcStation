/singleton/hierarchy/outfit/job/wyrm/captain
	name = WYRM_OUTFIT_JOB_NAME("Captain")
	uniform = /obj/item/clothing/under/casual_pants/classicjeans
	shoes = /obj/item/clothing/shoes/black
	pda_type = /obj/item/modular_computer/pda/captain
	id_types = list(/obj/item/card/id/gold)
	l_ear = /obj/item/device/radio/headset/heads/captain

/singleton/hierarchy/outfit/job/wyrm/captain/post_equip(var/mob/living/carbon/human/H)
	..()
	var/obj/item/clothing/uniform = H.w_uniform
	if(uniform)
		var/obj/item/clothing/accessory/toggleable/hawaii/random/eyegore = new()
		if(uniform.can_attach_accessory(eyegore))
			uniform.attach_accessory(null, eyegore)
		else
			qdel(eyegore)

/singleton/hierarchy/outfit/job/wyrm/mate
	name = WYRM_OUTFIT_JOB_NAME("First Mate")
	uniform = /obj/item/clothing/under/casual_pants/blackjeans
	shoes = /obj/item/clothing/shoes/black
	id_types = list(/obj/item/card/id/silver)
	pda_type = /obj/item/modular_computer/pda/heads/hop
	l_ear = /obj/item/radio/headset/heads/hop/wyrm

/singleton/hierarchy/outfit/job/wyrm/mate/post_equip(var/mob/living/carbon/human/H)
	..()
	var/obj/item/clothing/uniform = H.w_uniform
	if(uniform)
		var/obj/item/clothing/accessory/toggleable/corpjacket/heph/wyrm/profesinal = new()
		if(uniform.can_attach_accessory(profesinal))
			profesinal.buttons_state = !profesinal.buttons_state
			profesinal.icon_state = "[initial(profesinal.icon_state)][profesinal.buttons_suffix]"
			uniform.attach_accessory(null, profesinal)
		else
			qdel(profesinal)

/obj/item/clothing/accessory/toggleable/corpjacket/heph/wyrm
	name = "first mate's jacket"
	desc = "A well-kept jacket more typically worn by corporate executives."

/obj/item/radio/headset/heads/hop/wyrm
	name = "first mate's headset"

/singleton/hierarchy/outfit/job/wyrm/hos
	name = WYRM_OUTFIT_JOB_NAME("Security Officer")
	uniform = /obj/item/clothing/under/guard/wyrm
	shoes = /obj/item/clothing/shoes/jackboots
	belt = /obj/item/storage/belt/security
	glasses = /obj/item/clothing/glasses/sunglasses
	l_ear = /obj/item/device/radio/headset/headset_com
	r_pocket = /obj/item/device/flash
