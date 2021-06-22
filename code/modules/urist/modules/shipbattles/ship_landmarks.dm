
//landmarks


/obj/effect/urist/triggers/New()
	..()
	GLOB.trigger_landmarks += src

/obj/effect/urist/triggers/Destroy()
	GLOB.trigger_landmarks -= src
	return ..()

//where we tele in

/obj/effect/urist/triggers/boarding_landmark
	icon_state = "x3"
	icon = 'icons/mob/screen1.dmi'
	invisibility = 101

//ai spawns

/obj/effect/urist/triggers/ai_defender_landmark
	icon_state = "x3"
	icon = 'icons/mob/screen1.dmi'
	invisibility = 101
	var/list/spawn_type //what's the path of the thing we're spawning

/obj/effect/urist/triggers/ai_defender_landmark/proc/spawn_mobs()
	var/spawn_mob = pick(spawn_type)
	new spawn_mob(src.loc)
	qdel(src)

/obj/effect/urist/triggers/ai_defender_landmark/pirate
	spawn_type = list(/mob/living/simple_animal/hostile/urist/newpirate, /mob/living/simple_animal/hostile/urist/newpirate/laser)

/obj/effect/urist/triggers/ai_defender_landmark/pirate/ballistic
	spawn_type = list(/mob/living/simple_animal/hostile/urist/newpirate/ballistic)

/obj/effect/urist/triggers/ai_defender_landmark/terran/space_marine
	spawn_type = list(/mob/living/simple_animal/hostile/urist/terran/marine_space)

/obj/effect/urist/triggers/ai_defender_landmark/terran/marine
	spawn_type = list(/mob/living/simple_animal/hostile/urist/terran/marine)

/obj/effect/urist/triggers/ai_defender_landmark/terran/officer
	spawn_type = list(/mob/living/simple_animal/hostile/urist/terran/marine_officer)

/obj/effect/urist/triggers/ai_defender_landmark/rebel
	spawn_type = list(/mob/living/simple_animal/hostile/urist/rebel)

/obj/effect/urist/triggers/ai_defender_landmark/lactera
	spawn_type = list(,/mob/living/simple_animal/hostile/scom/lactera/medium, /mob/living/simple_animal/hostile/scom/lactera/light)

/obj/effect/urist/triggers/ai_defender_landmark/lactera/heavy
	spawn_type = list(/mob/living/simple_animal/hostile/scom/lactera/heavy)

/obj/effect/urist/triggers/ai_defender_landmark/lactera/leader
	spawn_type = list(/mob/living/simple_animal/hostile/scom/lactera/leader)

//humans

/obj/effect/urist/triggers/defender_landmark
	icon_state = "x3"
	icon = 'icons/mob/screen1.dmi'
	invisibility = 101
	var/defender_outfit = null

/mob/observer/ghost/proc/shipdefender_spawn(var/datum/factions/hiddenfaction)
	var/want = input(src,"The [GLOB.using_map.name] is now able to board a hostile [hiddenfaction.factionid] ship. Join as a defender on the hostile ship?") in list ("No", "Yes")
	switch(want)
		if("No")
			return
		if("Yes")
			for(var/obj/effect/urist/triggers/defender_landmark/D in GLOB.trigger_landmarks)
				if(D.loc)
					var/mob/living/carbon/human/M = new /mob/living/carbon/human(D.loc)
					M.ckey = src.ckey
					M.gender = pick(MALE,FEMALE)
					var/datum/preferences/A = new()
					A.sanitize_preferences()
					A.randomize_appearance_and_body_for(M)
					M.real_name = random_name(gender)
					M.faction = hiddenfaction.factionid

					var/decl/hierarchy/outfit/defender_outfit = outfit_by_type(D.defender_outfit)
					defender_outfit.equip(M)

					M.update_icon()
					qdel(src)


/obj/effect/urist/triggers/defender_landmark/pirate
	defender_outfit = /decl/hierarchy/outfit/newpirate

/obj/effect/urist/triggers/defender_landmark/terran
	defender_outfit = /decl/hierarchy/outfit/terranmarinespace

/obj/effect/urist/triggers/defender_landmark/rebel/miner
	defender_outfit = /decl/hierarchy/outfit/grayson/miner

/obj/effect/urist/triggers/defender_landmark/lactera
	defender_outfit = /decl/hierarchy/outfit/lactera

//weapons

/obj/effect/urist/triggers/shipweapons
	icon_state = "x3"
	icon = 'icons/mob/screen1.dmi'
	invisibility = 101

//awaymaps

/obj/effect/urist/triggers/away_ai_landmark
	icon_state = "x3"
	icon = 'icons/mob/screen1.dmi'
	invisibility = 101
	var/list/spawn_type //what's the path of the thing we're spawning
	var/spawn_id = null

/obj/effect/urist/triggers/away_ai_landmark/proc/spawn_mobs()
	var/spawn_mob = pick(spawn_type)
	new spawn_mob(src.loc)
	qdel(src)

/obj/effect/urist/triggers/away_ai_landmark/pirate
	spawn_id = "pirate_station"
	spawn_type = list(/mob/living/simple_animal/hostile/urist/newpirate, /mob/living/simple_animal/hostile/urist/newpirate/laser)

/obj/effect/urist/triggers/away_ai_landmark/pirate/ballistic
	spawn_type = list(/mob/living/simple_animal/hostile/urist/newpirate/ballistic)

//disk spawner

/obj/item/weapon/disk/station_disk
	name = "Data Disk"
	icon = 'icons/obj/cloning.dmi'
	icon_state = "datadisk0"
	item_state = "card-id"
	w_class = ITEM_SIZE_SMALL
	var/obj/effect/overmap/sector/station/master_station

/obj/effect/urist/triggers/station_disk
	icon_state = "x3"
	icon = 'icons/mob/screen1.dmi'
	var/faction_id

/obj/effect/urist/triggers/station_disk/proc/spawn_disk(var/obj/effect/overmap/sector/station/stored_station)
	var/obj/item/weapon/disk/station_disk/D = new /obj/item/weapon/disk/station_disk(src.loc)
	D.master_station = stored_station
	qdel(src)

/obj/effect/urist/triggers/station_disk/pirate
	faction_id = "pirate"

//pirate corpses
/obj/effect/landmark/corpse/newpirate
	spawn_flags = CORPSE_SPAWNER_RANDOM_NAME | CORPSE_SPAWNER_CUT_ID_PDA | CORPSE_SPAWNER_CUT_SURVIVAL

/obj/effect/landmark/corpse/newpirate/laser
	name = "New Pirate - Laser"
	corpse_outfits = list(/decl/hierarchy/outfit/newpirate)

/obj/effect/landmark/corpse/newpirate/melee
	name = "New Pirate - Melee"
	corpse_outfits = list(/decl/hierarchy/outfit/newpirate/melee)

/obj/effect/landmark/corpse/newpirate/ballistic
	name = "New Pirate - Ballistic"
	corpse_outfits = list(/decl/hierarchy/outfit/newpirate/ballistic)