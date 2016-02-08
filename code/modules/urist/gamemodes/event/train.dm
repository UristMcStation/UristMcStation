//var/mappath = "maps/EventMaps/train.dmm"
var/list/eventwarp1 = list()
var/list/eventwarp2 = list()
var/list/eventwarp3 = list()

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
		qdel(W)

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
proc/traintime()
	set name = "Train Time!"
	set category = "Fun"
	set desc = "All aboard!"
	if(!check_rights(R_FUN))
		src <<"\red \b You do not have the required admin rights."
		return

	for(var/mob/living/carbon/human/M in player_list)

		for (var/obj/item/I in M)
			if (istype(I, /obj/item/weapon/implant))
				continue
			qdel(I)

		if(M.gender == "male")
			M.equip_to_slot_or_del(new /obj/item/clothing/under/urist/suit_jacket/black(M), slot_w_uniform)
			M.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/toggle/urist/coat/blackcoat/suit(M), slot_wear_suit)
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/weapon/pen(M), slot_l_ear)
			M.equip_to_slot_or_del(new /obj/item/clothing/mask/smokable/cigarette(M), slot_wear_mask)
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
		M.loc = pick(eventwarp1)

	message_admins("[key_name_admin(usr)] began the train event. God help us all.")

//snow train stuff

proc/snowtraintime()
	for(var/mob/living/carbon/human/M in player_list)

		for (var/obj/item/I in M)
			if (istype(I, /obj/item/weapon/implant))
				continue
			qdel(I)

		if(M.job in list("Captain", "Head of Personnel", "Chief Engineer", "Research Director", "Chief Medical Officer", "Scientist", "Head of Security"))

			if(M.gender == "male")
				M.equip_to_slot_or_del(new /obj/item/clothing/under/urist/suit_jacket/black(M), slot_w_uniform)
				M.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/toggle/urist/coat/blackcoat/suit(M), slot_wear_suit)
				M.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(M), slot_shoes)
				M.equip_to_slot_or_del(new /obj/item/weapon/pen(M), slot_l_ear)
				M.equip_to_slot_or_del(new /obj/item/clothing/mask/smokable/cigarette(M), slot_wear_mask)
				M.equip_to_slot_or_del(new /obj/item/clothing/head/fedora(M), slot_head)
				M.equip_to_slot_or_del(new /obj/item/weapon/storage/fancy/cigarettes(M), slot_belt)
				M.equip_to_slot_or_del(new /obj/item/weapon/flame/lighter/zippo(M), slot_r_store)

				var/obj/item/weapon/card/id/W = new(M)
				W.name = "[M.real_name]'s ID Card"
				W.icon_state = "centcom"
				W.access = get_all_accesses()
				W.assignment = ""
				W.registered_name = M.real_name
				M.equip_to_slot_or_del(W, slot_wear_id)
				M.loc = pick(eventwarp2)
				M << ("\red You are the elite of the train. The last vestiges of a wealthy class rescued from a dying earth. However, there is discontent among the lower cars. While you leave the fighting to the guards, you know that if the lower cars discovered the secret of the engine, it would not end well for you.")
			else if(M.gender == "female")
				M.equip_to_slot_or_del(new /obj/item/clothing/under/dress/dress_orange(M), slot_w_uniform)
				M.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(M), slot_shoes)
				M.equip_to_slot_or_del(new /obj/item/weapon/pen(M), slot_l_ear)
				M.equip_to_slot_or_del(new /obj/item/weapon/storage/fancy/cigarettes(M), slot_l_store)
				M.equip_to_slot_or_del(new /obj/item/weapon/flame/lighter/zippo(M), slot_r_store)

				var/obj/item/weapon/card/id/W = new(M)
				W.name = "[M.real_name]'s ID Card"
				W.icon_state = "centcom"
				W.access = get_all_accesses()
				W.assignment = "Elite Passenger"
				W.registered_name = M.real_name
				M.equip_to_slot_or_del(W, slot_wear_id)
				M.loc = pick(eventwarp2)
				M << ("\red You are the elite of the train. The last vestiges of a wealthy class rescued from a dying earth. However, there is discontent among the lower cars. While you leave the fighting to the guards, you know that if the lower cars discovered the secret of the engine, it would not end well for you.")

		else if(M.job in list("Security Officer", "Warden"))
			M.equip_to_slot_or_del(new /obj/item/clothing/under/det/slob(M), slot_w_uniform)
			M.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/jacket(M), slot_wear_suit)
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/weapon/pen(M), slot_l_ear)
			M.equip_to_slot_or_del(new /obj/item/clothing/mask/smokable/cigarette(M), slot_wear_mask)
			M.equip_to_slot_or_del(new /obj/item/clothing/head/beret/sec/alt(M), slot_head)
			M.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/revolver/detective(M), slot_belt)
			M.equip_to_slot_or_del(new /obj/item/weapon/storage/fancy/cigarettes(M), slot_l_store)
			M.equip_to_slot_or_del(new /obj/item/weapon/flame/lighter/zippo(M), slot_r_store)

			var/obj/item/weapon/card/id/W = new(M)
			W.name = "[M.real_name]'s ID Card"
			W.icon_state = "centcom"
			W.access = get_all_accesses()
			W.access += get_all_centcom_access()
			W.assignment = "Guard"
			W.registered_name = M.real_name
			M.equip_to_slot_or_del(W, slot_wear_id)
			M.loc = pick(eventwarp3)
			M << ("\red You are the guards of the train. Your goal is to keep the lower cars out of the upper cars, and protect the elite. However, while it pains you, you know that the secret of the engine requires the members of the lower cars in order to work. Thus, you must keep them alive unless there is no other option.")

		else
			M.equip_to_slot_or_del(new /obj/item/clothing/under/urist/dresden(M), slot_w_uniform)
			M.equip_to_slot_or_del(new /obj/item/clothing/suit/coat(M), slot_wear_suit)
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/urist/winter(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/clothing/mask/smokable/cigarette(M), slot_wear_mask)
			M.equip_to_slot_or_del(new /obj/item/weapon/storage/fancy/cigarettes(M), slot_belt)
			M.equip_to_slot_or_del(new /obj/item/weapon/flame/lighter/random(M), slot_r_store)

			var/obj/item/weapon/card/id/W = new(M)
			W.name = "[M.real_name]'s ID Card"
			W.assignment = "Lower Class Passenger"
			W.registered_name = M.real_name
			M.equip_to_slot_or_del(W, slot_wear_id)
			M.loc = pick(eventwarp1)
			M << ("\red You are a member of the lower classes. The few (un)lucky souls to make it onboard the train before it left on its final, neverending journey. While you've managed to scrape out a living on the train, it is not a good life. Indeed, every few weeks it seems that some of your closest friends from the lower cars just disappear. On top of that, food stores are running low. However, you know that you can't beat the guards without working together with every single member of the lower cars. So, will you fight and die, or will you keep on surviving with the hope that you won't be taken away? It's your choice.")
		M.regenerate_icons()


	message_admins("[key_name_admin(usr)] began the snow train event. God help us all.")

/obj/structure/train/engine/snow
	name = "engine"
	icon = 'icons/obj/power.dmi'
	icon_state = "teg"
	density = 1
	anchored = 1

/obj/structure/train/engine/snow2
	name = "engine"
	icon = 'icons/obj/pipes.dmi'
	icon_state = "turbine"
	density = 1
	anchored = 1

/obj/structure/train/engine/snow/attack_hand(mob/user)
	var/want = input("Stop the train? ((This will end the round)", "Your Choice", "Cancel") in list ("Cancel", "Yes")
	switch(want)
		if("Cancel")
			return
		if("Yes")
			for(var/turf/unsimulated/floor/uristturf/train/snowmoving/F in world)
				F.icon_state = "s"

			for(var/turf/unsimulated/floor/uristturf/train/snowmoving2/F in world)
				F.icon_state = "s2"

			for(var/mob/living/carbon/human/M in player_list)
				if(M.client)
					spawn(0)
						if(M.buckled)
							M << "\red Sudden deceleration presses you into your chair!"
							shake_camera(M, 3, 1)
						else
							M << "\red The floor lurches beneath you as the train comes to a sudden stop!"
							shake_camera(M, 10, 1)
				if(istype(M, /mob/living/carbon))
					if(!M.buckled)
						M.Weaken(3)

			world << "\red \b The train has come to a stop. The lower cars have won this fight, and have brought an end to the tyranny of the upper cars. Was it the right decision? Only time will tell, as the survivors will have to work hard to survive in this cruel new world."

/turf/unsimulated/floor/uristturf/train/snow
	name = "snow"
	icon = 'icons/urist/events/train.dmi'
	icon_state = "s"

/turf/unsimulated/floor/uristturf/train/snowmoving
	name = "snow"
	icon = 'icons/urist/events/train.dmi'
	icon_state = "scircuit"

/turf/unsimulated/floor/uristturf/train/snow2
	name = "snow"
	icon = 'icons/urist/events/train.dmi'
	icon_state = "s2"

/turf/unsimulated/floor/uristturf/train/snowmoving2
	name = "snow"
	icon = 'icons/urist/events/train.dmi'
	icon_state = "scircuit_2"

/turf/unsimulated/wall/other/transparent
	opacity = 0

/obj/effect/blowingsnow
	name = "blowing snow"
	icon = 'icons/urist/events/train.dmi'
	icon_state = "bsnow"
	layer = 5

/obj/effect/blowingsnow/Crossed(O as mob)
	..()
	if(istype(O, /mob/living/))
		var/mob/living/M = O
		if(COLD_RESISTANCE in M.mutations)
			M << ("<span class='warning'> The cold wind feels surprisingly pleasant to you.</span>")
		else
			if(prob(85))
				M.apply_damage(rand(3,5), BURN)
				M << ("<span class='warning'> The cold wind tears at your skin!</span>")
