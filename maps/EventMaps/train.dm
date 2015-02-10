var/list/trainwarp = list()

/turf/unsimulated/floor/uristturf/train/grass
	name = "grass"
	icon = 'icons/urist/events/train.dmi'
	icon_state = "g"

/turf/unsimulated/floor/uristturf/train/grassmoving
	name = "grass"
	icon = 'icons/urist/events/train.dmi'
	icon_state = "gcircuit"

/turf/unsimulated/floor/uristturf/train/grass_night
	name = "grass"
	icon = 'icons/urist/events/train.dmi'
	icon_state = "g_night"

/turf/unsimulated/floor/uristturf/train/grassmoving_night
	name = "grass"
	icon = 'icons/urist/events/train.dmi'
	icon_state = "gcircuit_night"

/turf/unsimulated/wall/blank
	name = ""
	desc = ""
	icon = 'icons/urist/events/train.dmi'
	icon_state = "blank"

/obj/item/weapon/train/ticket
	name = "train ticket"
	desc = "All aboard!"
	icon = 'icons/urist/events/train.dmi'
	icon_state = "ticket"
	w_class = 2

/obj/item/weapon/train/ticket/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if(istype(W, /obj/item/weapon/stamp))
		user.visible_message("[user] stamps the ticket with the stamp. All aboard!", "You stamp the ticket with the stamp.", "You hear the sound of something being stamped.")
		src.desc = "A train ticket. It's been stamped."

/obj/item/weapon/train/ore
	icon = 'icons/urist/events/train.dmi'
	icon_state = "ore"
	name = "coal ore"
	desc = "Ore used to feed the train's engine."

/*/obj/structure/train/orebox
	icon = 'icons/obj/mining.dmi'
	icon_state = "orebox0"
	name = "ore box"
	desc = "A heavy box used for storing ore."
	anchored = 1
	density = 1*/

/obj/structure/train/engine
	icon = 'icons/urist/events/train.dmi'
	icon_state = "intake"
	name = "engine"
	desc = "The engine for the train."
	anchored = 1
	density = 1

/obj/structure/train/engine/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if(istype(W, /obj/item/weapon/train/ore))
		user.visible_message("[user] tosses the coal into the engine!", "You toss the coal ore into the engine.", "You hear the sound of flames roaring.")
		del(W)

/obj/item/weapon/card/id/passport
	name = "passport"
	icon = 'icons/urist/events/train.dmi'
	icon_state = "passport"

/obj/item/weapon/claymore/officer
	icon = 'icons/urist/events/train.dmi'
	name = "ceremonial sword"
	desc = "A ceremonial sword, as would be worn by an officer. Still damn sharp though."
	force = 30

/obj/item/device/flashlight/trainlantern
	name = "lantern"
	desc = "An ornate red lantern."
	icon = 'icons/urist/events/train.dmi'
	icon_state = "wolfflight"

/obj/item/clothing/suit/urist/conductor
	name = "conductor's uniform"
	desc = "An outfit worn by a train conductor"
	icon = 'icons/urist/events/train.dmi'
	icon_override = 'icons/urist/events/train.dmi'
	icon_state = "trainman"

/obj/item/clothing/head/urist/conductor
	name = "conductor's hat"
	desc = "A hat worn by a train conductor"
	icon = 'icons/urist/events/train.dmi'
	icon_override = 'icons/urist/events/train.dmi'
	icon_state = "trainman2"


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


