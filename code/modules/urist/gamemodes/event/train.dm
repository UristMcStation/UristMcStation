//var/mappath = "maps/EventMaps/train.dmm"
var/global/list/eventwarp1 = list()
var/global/list/eventwarp2 = list()
var/global/list/eventwarp3 = list()

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

/obj/item/train/ticket
	name = "train ticket"
	desc = "All aboard!"
	icon = 'icons/urist/events/train.dmi'
	icon_state = "ticket"
	w_class = 2

/obj/item/train/ticket/use_tool(obj/item/W, mob/living/user, list/click_params)
	..()
	if(istype(W, /obj/item/stamp))
		user.visible_message("[user] stamps the ticket with the stamp. All aboard!", "You stamp the ticket with the stamp.", "You hear the sound of something being stamped.")
		src.desc = "A train ticket. It's been stamped."

/obj/item/train/ore
	icon = 'icons/urist/events/train.dmi'
	icon_state = "ore"
	name = "coal ore"
	desc = "Ore used to feed the train's engine."

/*/obj/structure/train/orebox
	icon = 'icons/obj/mining.dmi'
	icon_state = "orebox0"
	name = "ore box"
	desc = "A heavy box used for storing ore."
	anchored = TRUE
	density = TRUE*/

/obj/structure/train/engine
	icon = 'icons/urist/events/train.dmi'
	icon_state = "intake"
	name = "engine"
	desc = "The engine for the train."
	anchored = TRUE
	density = TRUE

/obj/structure/train/engine/use_tool(obj/item/W, mob/living/user, list/click_params)
	..()
	if(istype(W, /obj/item/train/ore))
		user.visible_message("[user] tosses the coal into the engine!", "You toss the coal ore into the engine.", "You hear the sound of flames roaring.")
		qdel(W)

/obj/item/card/id/passport
	name = "passport"
	icon = 'icons/urist/events/train.dmi'
	icon_state = "passport"

/obj/item/officer
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
//	icon_override = 'icons/urist/events/train.dmi'
	icon_state = "trainman"

/obj/item/clothing/head/urist/conductor
	name = "conductor's hat"
	desc = "A hat worn by a train conductor"
	icon = 'icons/urist/events/train.dmi'
//	icon_override = 'icons/urist/events/train.dmi'
	icon_state = "trainman2"

//hurt me good
/client/proc/traintime()
	set name = "Train Time!"
	set category = "Fun"
	set desc = "All aboard!"
	if(!check_rights(R_FUN))
		to_chat(src,"<span class='danger'> You do not have the required admin rights.</span>")
		return

	for(var/mob/living/carbon/human/M in GLOB.player_list)

		for (var/obj/item/I in M)
			if (istype(I, /obj/item/implant) || istype(I, /obj/item/organ))
				continue
			qdel(I)

		if(M.gender == "male")
			M.equip_to_slot_or_del(new /obj/item/clothing/under/urist/suit_jacket/black(M), slot_w_uniform)
			M.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/toggle/urist/coat/blackcoat/suit(M), slot_wear_suit)
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/pen(M), slot_l_ear)
			M.equip_to_slot_or_del(new /obj/item/clothing/mask/smokable/cigarette(M), slot_wear_mask)
			M.equip_to_slot_or_del(new /obj/item/clothing/head/fedora(M), slot_head)
			M.equip_to_slot_or_del(new /obj/item/storage/fancy/smokable/transstellar(M), slot_belt)
			M.equip_to_slot_or_del(new /obj/item/train/ticket(M), slot_l_store)
			M.equip_to_slot_or_del(new /obj/item/flame/lighter/zippo(M), slot_r_store)

			var/obj/item/card/id/passport/W = new(M)
			W.name = "[M.real_name]'s Passport"
			W.assignment = ""
			W.registered_name = M.real_name
			M.equip_to_slot_or_del(W, slot_wear_id)

		else if(M.gender == "female")
			M.equip_to_slot_or_del(new /obj/item/clothing/under/dress/dress_orange(M), slot_w_uniform)
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/pen(M), slot_l_ear)
			M.equip_to_slot_or_del(new /obj/item/train/ticket(M), slot_l_store)
			M.equip_to_slot_or_del(new /obj/item/flame/lighter/zippo(M), slot_r_store)

			var/obj/item/card/id/passport/W = new(M)
			W.name = "[M.real_name]'s Passport"
			W.assignment = ""
			W.registered_name = M.real_name
			M.equip_to_slot_or_del(W, slot_wear_id)

		M.regenerate_icons()
		M.loc = pick(eventwarp1)

	message_admins("[key_name_admin(usr)] began the train event. God help us all.")

//snow train stuff

/client/proc/snowtraintime()
	for(var/mob/living/carbon/human/M in GLOB.player_list)

		for (var/obj/item/I in M)
			if (istype(I, /obj/item/implant) || istype(I, /obj/item/organ))
				continue
			qdel(I)

		if(M.job in list("Captain", "Head of Personnel", "Chief Engineer", "Research Director", "Chief Medical Officer", "Scientist", "Head of Security"))

			if(M.gender == "male")
				M.equip_to_slot_or_del(new /obj/item/clothing/under/urist/suit_jacket/black(M), slot_w_uniform)
				M.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/toggle/urist/coat/blackcoat/suit(M), slot_wear_suit)
				M.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(M), slot_shoes)
				M.equip_to_slot_or_del(new /obj/item/pen(M), slot_l_ear)
				M.equip_to_slot_or_del(new /obj/item/clothing/mask/smokable/cigarette(M), slot_wear_mask)
				M.equip_to_slot_or_del(new /obj/item/clothing/head/fedora(M), slot_head)
				M.equip_to_slot_or_del(new /obj/item/storage/fancy/smokable/transstellar(M), slot_belt)
				M.equip_to_slot_or_del(new /obj/item/flame/lighter/zippo(M), slot_r_store)

				var/obj/item/card/id/W = new(M)
				W.name = "[M.real_name]'s ID Card"
				W.icon_state = "centcom"
				W.access = get_all_accesses()
				W.assignment = ""
				W.registered_name = M.real_name
				M.equip_to_slot_or_del(W, slot_wear_id)
				M.loc = pick(eventwarp2)
				to_chat(M, "<span class='warning'> You are the elite of the train. The last vestiges of a wealthy class rescued from a dying earth. However, there is discontent among the lower cars. While you leave the fighting to the guards, you know that if the lower cars discovered the secret of the engine, it would not end well for you.</span>")
			else if(M.gender == "female")
				M.equip_to_slot_or_del(new /obj/item/clothing/under/dress/dress_orange(M), slot_w_uniform)
				M.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(M), slot_shoes)
				M.equip_to_slot_or_del(new /obj/item/pen(M), slot_l_ear)
				M.equip_to_slot_or_del(new /obj/item/storage/fancy/smokable/transstellar(M), slot_l_store)
				M.equip_to_slot_or_del(new /obj/item/flame/lighter/zippo(M), slot_r_store)

				var/obj/item/card/id/W = new(M)
				W.name = "[M.real_name]'s ID Card"
				W.icon_state = "centcom"
				W.access = get_all_accesses()
				W.assignment = "Elite Passenger"
				W.registered_name = M.real_name
				M.equip_to_slot_or_del(W, slot_wear_id)
				M.loc = pick(eventwarp2)
				to_chat(M, "<span class='warning'> You are the elite of the train. The last vestiges of a wealthy class rescued from a dying earth. However, there is discontent among the lower cars. While you leave the fighting to the guards, you know that if the lower cars discovered the secret of the engine, it would not end well for you.</span>")

		else if(M.job in list("Security Officer", "Warden"))
			M.equip_to_slot_or_del(new /obj/item/clothing/under/det/black(M), slot_w_uniform)
			M.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/jacket(M), slot_wear_suit)
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/pen(M), slot_l_ear)
			M.equip_to_slot_or_del(new /obj/item/clothing/mask/smokable/cigarette(M), slot_wear_mask)
			M.equip_to_slot_or_del(new /obj/item/clothing/head/beret/sec/navy/officer(M), slot_head)
			M.equip_to_slot_or_del(new /obj/item/gun/projectile/revolver/detective(M), slot_belt)
			M.equip_to_slot_or_del(new /obj/item/storage/fancy/smokable/transstellar(M), slot_l_store)
			M.equip_to_slot_or_del(new /obj/item/flame/lighter/zippo(M), slot_r_store)

			var/obj/item/card/id/W = new(M)
			W.name = "[M.real_name]'s ID Card"
			W.icon_state = "centcom"
			W.access = get_all_accesses()
			W.access += get_all_centcom_access()
			W.assignment = "Guard"
			W.registered_name = M.real_name
			M.equip_to_slot_or_del(W, slot_wear_id)
			M.loc = pick(eventwarp3)
			to_chat(M, "<span class='warning'> You are the guards of the train. Your goal is to keep the lower cars out of the upper cars, and protect the elite. However, while it pains you, you know that the secret of the engine requires the members of the lower cars in order to work. Thus, you must keep them alive unless there is no other option.</span>")

		else
			M.equip_to_slot_or_del(new /obj/item/clothing/under/urist/dresden(M), slot_w_uniform)
			M.equip_to_slot_or_del(new /obj/item/clothing/suit/coat(M), slot_wear_suit)
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/urist/winter(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/clothing/mask/smokable/cigarette(M), slot_wear_mask)
			M.equip_to_slot_or_del(new /obj/item/storage/fancy/smokable/transstellar(M), slot_belt)
			M.equip_to_slot_or_del(new /obj/item/flame/lighter/random(M), slot_r_store)

			var/obj/item/card/id/W = new(M)
			W.name = "[M.real_name]'s ID Card"
			W.assignment = "Lower Class Passenger"
			W.registered_name = M.real_name
			M.equip_to_slot_or_del(W, slot_wear_id)
			M.loc = pick(eventwarp1)
			to_chat(M,"<span class='warning'> You are a member of the lower classes. The few (un)lucky souls to make it onboard the train before it left on its final, neverending journey. While you've managed to scrape out a living on the train, it is not a good life. Indeed, every few weeks it seems that some of your closest friends from the lower cars just disappear. On top of that, food stores are running low. However, you know that you can't beat the guards without working together with every single member of the lower cars. So, will you fight and die, or will you keep on surviving with the hope that you won't be taken away? It's your choice.</span>")
		M.regenerate_icons()


	message_admins("[key_name_admin(usr)] began the snow train event. God help us all.")

/obj/structure/train/engine/snow
	name = "engine"
	icon = 'icons/obj/power.dmi'
	icon_state = "teg"
	density = TRUE
	anchored = TRUE

/obj/structure/train/engine/snow2
	name = "engine"
	icon = 'icons/obj/pipes.dmi'
	icon_state = "turbine"
	density = TRUE
	anchored = TRUE

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

			for(var/mob/living/carbon/human/M in GLOB.player_list)
				if(M.client)
					spawn(0)
						if(M.buckled)
							to_chat(M, "<span class='warning'> Sudden deceleration presses you into your chair!</span>")
							shake_camera(M, 3, 1)
						else
							to_chat(M, "<span class='warning'> The floor lurches beneath you as the train comes to a sudden stop!</span>")
							shake_camera(M, 10, 1)
				if(istype(M, /mob/living/carbon))
					if(!M.buckled)
						M.Weaken(3)

			to_world(SPAN_DANGER("The train has come to a stop. The lower cars have won this fight, and have brought an end to the tyranny of the upper cars. Was it the right decision? Only time will tell, as the survivors will have to work hard to survive in this cruel new world."))

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
/*
/datum/shuttle/ferry/train
	category = /datum/shuttle/ferry/train
	name = "Train"
	location = 1
	warmup_time = 10
	move_time = 22000
	area_offsite = /area/shuttle/train/stop
	area_station = /area/shuttle/train/go
*/
