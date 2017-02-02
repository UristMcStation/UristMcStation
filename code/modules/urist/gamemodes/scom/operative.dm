#define RANK_SUPPORT 0
#define RANK_SOLDIER 1
#define RANK_OFFICER 2
#define RANK_COMMAND 3

var/datum/antagonist/scom/scommies

/proc/isscom(var/mob/player)
	if(!scommies || !player.mind)
		return 0
	if(player.mind in scommies.current_antagonists)
		return 1

/datum/antagonist/scom
	id = "scomop"
	role_text = "SCOM Operative"
	role_text_plural = "SCOM Operatives"
	suspicion_chance = 0 //duh

	uristantag = 1
	antaghud_indicator = "scomop"
	antag_indicator = "scomop"
	initial_spawn_req = 1
	initial_spawn_target = 1 //we're hijacking spawning in scomtime/scom join

	valid_species = list("Unathi","Skrell","Human","Resomi")
	min_player_age = 0
	id_type = /obj/item/weapon/card/id/centcom/ERT
	default_access = list() //TODO
	flags = ANTAG_OVERRIDE_JOB | ANTAG_RANDOM_EXCEPTED | ANTAG_CLEAR_EQUIPMENT

/datum/antagonist/scom/New()
	..()
	scommies = src

/datum/antagonist/scom/update_antag_mob(var/datum/mind/player, var/preserve_appearance = 1, var/rank)
	..()
	if(rank)
		var/scom_rank = ""

		switch(rank)
			if(RANK_SUPPORT)
				scom_rank = pick("Dr. ")
			if(RANK_SOLDIER)
				scom_rank = pick("Spc. ", "Cpl. ", "Sgt. ")
			if(RANK_OFFICER)
				scom_rank = pick("Lt. ", "Col. ", "Cpt. ", "Maj. ")
			if(RANK_COMMAND)
				scom_rank = pick("Comm. ")

		player.current.real_name = scom_rank + player.current.real_name
		player.name = player.current.real_name

	return

/datum/antagonist/scom/equip(var/mob/living/carbon/human/M, var/rank = RANK_SOLDIER, var/team = 0)

	. = ..()

	if(M.species == "Unathi")
		M.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots/unathi(M), slot_shoes)

	switch(rank)
		if(RANK_SUPPORT)
			M.equip_to_slot_or_del(new /obj/item/device/radio/headset/heads/captain(M), slot_l_ear)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/rank/scientist(M), slot_w_uniform)
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/device/pda/science(M), slot_belt)
			M.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/toxins(M), slot_back)
			M.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/toggle/labcoat/science(M), slot_wear_suit)
			create_id("S-COM Researcher", M)

		if(RANK_SOLDIER)
			switch(team)
				if(1)
					M.equip_to_slot_or_del(new /obj/item/clothing/under/urist/scom/s1(M), slot_w_uniform)
				if(2)
					M.equip_to_slot_or_del(new /obj/item/clothing/under/urist/scom/s2(M), slot_w_uniform)
				if(3)
					M.equip_to_slot_or_del(new /obj/item/clothing/under/urist/scom/s3(M), slot_w_uniform)
				if(4)
					M.equip_to_slot_or_del(new /obj/item/clothing/under/urist/scom/s4(M), slot_w_uniform)
				else
					M.equip_to_slot_or_del(new /obj/item/clothing/under/urist/scom(M), slot_w_uniform)

			M.equip_to_slot_or_del(new /obj/item/device/radio/headset(M), slot_l_ear)
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/clothing/gloves/thick/swat(M), slot_gloves)
			M.equip_to_slot_or_del(new /obj/item/weapon/storage/belt/urist/military/scom(M), slot_belt)
			M.equip_to_slot_or_del(new /obj/item/clothing/head/beret/sec/navy/officer(M), slot_head)
			M.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/silenced/knight(M), slot_r_store)
			create_id("S-COM Operative", M)

		if(RANK_OFFICER)
			switch(team)
				if(1)
					M.equip_to_slot_or_del(new /obj/item/clothing/under/urist/scom/s1l(M), slot_w_uniform)
				if(2)
					M.equip_to_slot_or_del(new /obj/item/clothing/under/urist/scom/s2l(M), slot_w_uniform)
				if(3)
					M.equip_to_slot_or_del(new /obj/item/clothing/under/urist/scom/s3l(M), slot_w_uniform)
				if(4)
					M.equip_to_slot_or_del(new /obj/item/clothing/under/urist/scom/s4l(M), slot_w_uniform)
				else
					M.equip_to_slot_or_del(new /obj/item/clothing/under/urist/scom(M), slot_w_uniform)

			M.equip_to_slot_or_del(new /obj/item/device/radio/headset(M), slot_l_ear)
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/clothing/gloves/thick/swat(M), slot_gloves)
			M.equip_to_slot_or_del(new /obj/item/weapon/storage/belt/urist/military/scom(M), slot_belt)
			M.equip_to_slot_or_del(new /obj/item/clothing/head/beret/centcom/captain(M), slot_head)
			M.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/silenced/knight(M), slot_r_store)
			M.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/deus_blueshield(M), slot_wear_suit)
			create_id("S-COM Officer", M)

		if(RANK_COMMAND)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/rank/centcom(M), slot_w_uniform)
			M.equip_to_slot_or_del(new /obj/item/clothing/suit/captunic(M), slot_wear_suit)
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/device/radio/headset/heads/captain(M), slot_l_ear)
			M.equip_to_slot_or_del(new /obj/item/clothing/mask/smokable/cigarette(M), slot_wear_mask)
			M.equip_to_slot_or_del(new /obj/item/clothing/head/caphat/formal(M), slot_head)
			create_id("S-COM Commander", M)