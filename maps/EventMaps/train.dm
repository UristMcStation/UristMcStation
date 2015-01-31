var/list/trainwarp = list()

/turf/unsimulated/floor/uristturf/train/grass
	name = "grass"
	icon = 'icons/urist/events/train.dmi'
	icon_state = "g"

/turf/unsimulated/floor/uristturf/train/grassmoving
	name = "grass"
	icon = 'icons/urist/events/train.dmi'
	icon_state = "gcircuit"

/obj/item/weapon/train/ticket
	name = "train ticket"
	desc = "All aboard!"
	icon = 'icons/urist/events/train.dmi'
	icon_state = "ticket"

/obj/item/weapon/card/id/passport
	name = "passport"
	icon = 'icons/urist/events/train.dmi'
	icon_state = "passport"

//hurt me good
proc/TrainTime()
	for(var/mob/living/carbon/human/M in player_list)

		for (var/obj/item/I in M)
			if (istype(I, /obj/item/weapon/implant))
				continue
			del(I)

		if(M.gender == "male")
			M.equip_to_slot_or_del(new /obj/item/clothing/under/urist/suit_jacket/black(M), slot_w_uniform)
			M.equip_to_slot_or_del(new /obj/item/clothing/suit/urist/coat/blackcoat/suit(M), slot_wear_suit)
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/weapon/pen(M), slot_l_ear)
			M.equip_to_slot_or_del(new /obj/item/clothing/mask/cigarette(M), slot_wear_mask)
			M.equip_to_slot_or_del(new /obj/item/clothing/head/fedora(M), slot_head)
			M.equip_to_slot_or_del(new /obj/item/weapon/storage/fancy/cigarettes(M), slot_belt)
			M.equip_to_slot_or_del(new /obj/item/weapon/train/ticket(M), slot_l_store)
			M.equip_to_slot_or_del(new /obj/item/weapon/flame/lighter/zippo(M), slot_r_store)

			var/obj/item/weapon/card/id/passport/W = new(M)
			W.name = "[M.real_name]'s Passport"
			W.assignment = ""
			W.registered_name = M.real_name
			M.equip_to_slot_or_del(W, slot_wear_id)

		else if(M.gender == "female")
			M.equip_to_slot_or_del(new /obj/item/clothing/under/dress/dress_orange(M), slot_w_uniform)
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/weapon/pen(M), slot_l_ear)
			M.equip_to_slot_or_del(new /obj/item/weapon/train/ticket(M), slot_l_store)
			M.equip_to_slot_or_del(new /obj/item/weapon/flame/lighter/zippo(M), slot_r_store)

			var/obj/item/weapon/card/id/passport/W = new(M)
			W.name = "[M.real_name]'s Passport"
			W.assignment = ""
			W.registered_name = M.real_name
			M.equip_to_slot_or_del(W, slot_wear_id)

		M.regenerate_icons()
		M.loc = pick(trainwarp)

	message_admins("[key_name_admin(usr)] began the train event. God help us all.")

proc/LoadEventMap()

	var/list/potentialEventMap = list()
	world << "\red \b Searching for Event Map..."
	var/list/Lines = file2list("maps/EventMaps/fileList.txt")
	if(!Lines.len)	return
	for (var/t in Lines)
		if (!t)
			continue

		t = trim(t)
		if (length(t) == 0)
			continue
		else if (copytext(t, 1, 2) == "#")
			continue

		var/pos = findtext(t, " ")
		var/name = null
	//	var/value = null

		if (pos)
            // No, don't do lowertext here, that breaks paths on linux
			name = copytext(t, 1, pos)
		//	value = copytext(t, pos + 1)
		else
            // No, don't do lowertext here, that breaks paths on linux
			name = t

		if (!name)
			continue

		potentialEventMap.Add(name)


	if(potentialEventMap.len)
		world << "\red \b Loading EventMap..."

		var/map = pick(potentialEventMap)
		var/file = file(map)
		if(isfile(file))
			maploader.load_map(file)

		world << "\red \b Event Map loaded."

	else
		world << "\red \b Event Map found."
		return