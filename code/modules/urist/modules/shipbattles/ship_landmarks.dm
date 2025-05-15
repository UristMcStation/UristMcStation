
//landmarks
/obj/urist_intangible/triggers
	invisibility = 101

/obj/urist_intangible/triggers/New()
	..()
	GLOB.trigger_landmarks += src

/obj/urist_intangible/triggers/Destroy()
	GLOB.trigger_landmarks -= src
	return ..()

//where we tele in. right now there can only be one of these.
//if we ever allow multiple ships to be boarded at the same time, then this will need to be tweaked
///obj/structure/boarding/shipportal/shipside/Initialize() relies on there only being one, as does /mob/living/simple_animal/hostile/overmapship/proc/boarded()

/obj/urist_intangible/triggers/boarding_landmark
	var/obj/structure/boarding/shipportal/linked_portal //for clearing up counterboarding portals
	icon_state = "x3"
	icon = 'icons/mob/screen1.dmi'

/obj/urist_intangible/triggers/boarding_landmark/Destroy()
	qdel(linked_portal)
	..()

//ai spawns

/obj/urist_intangible/triggers/ai_defender_landmark
	icon_state = "x3"
	icon = 'icons/mob/screen1.dmi'
	var/list/spawn_type //what's the path of the thing we're spawning

/obj/urist_intangible/triggers/ai_defender_landmark/proc/spawn_mobs()
	var/spawn_mob = pick(spawn_type)
	new spawn_mob(src.loc)
	qdel(src)

/obj/urist_intangible/triggers/ai_defender_landmark/pirate
	spawn_type = list(/mob/living/simple_animal/hostile/urist/newpirate, /mob/living/simple_animal/hostile/urist/newpirate/laser)

/obj/urist_intangible/triggers/ai_defender_landmark/pirate/elite
	spawn_type = list(/mob/living/simple_animal/hostile/urist/newpirate/laser/elite)

/obj/urist_intangible/triggers/ai_defender_landmark/pirate/ballistic
	spawn_type = list(/mob/living/simple_animal/hostile/urist/newpirate/ballistic)

/obj/urist_intangible/triggers/ai_defender_landmark/pirate/ballistic/space
	spawn_type = list(/mob/living/simple_animal/hostile/urist/newpirate/ballistic/space)

/obj/urist_intangible/triggers/ai_defender_landmark/terran/space_marine
	spawn_type = list(/mob/living/simple_animal/hostile/urist/terran/marine_space)

/obj/urist_intangible/triggers/ai_defender_landmark/terran/marine
	spawn_type = list(/mob/living/simple_animal/hostile/urist/terran/marine)

/obj/urist_intangible/triggers/ai_defender_landmark/terran/officer
	spawn_type = list(/mob/living/simple_animal/hostile/urist/terran/marine_officer)

/obj/urist_intangible/triggers/ai_defender_landmark/rebel
	spawn_type = list(/mob/living/simple_animal/hostile/urist/rebel)

/obj/urist_intangible/triggers/ai_defender_landmark/lactera
	spawn_type = list(/mob/living/simple_animal/hostile/scom/lactera/medium, /mob/living/simple_animal/hostile/scom/lactera/light)

/obj/urist_intangible/triggers/ai_defender_landmark/lactera/heavy
	spawn_type = list(/mob/living/simple_animal/hostile/scom/lactera/heavy)

/obj/urist_intangible/triggers/ai_defender_landmark/lactera/leader
	spawn_type = list(/mob/living/simple_animal/hostile/scom/lactera/leader)

//humans

/obj/urist_intangible/triggers/defender_landmark
	icon_state = "x3"
	icon = 'icons/mob/screen1.dmi'
	var/defender_outfit = null

/client/verb/shipdefender_spawn()
	set name = "Join as Boarder"
	set category = "IC"

	if(!MayRespawn(1))
		to_chat(usr, "<span class='warning'>You are not allowed to respawn yet, and thus cannot join as a hostile boarder at this time.</span>")
		return

	if(isghost(usr) || isnewplayer(usr))
		var/mob/living/simple_animal/hostile/overmapship/homeship = GLOB.using_map.overmap_ship.target

		if(!homeship)
			to_chat(usr, "<span class='warning'>You cannot join as a hostile boarder at this time as the [GLOB.using_map.full_name] is not currently in combat.</span>")
			return

		if(!homeship.boarding)
			to_chat(usr, "<span class='warning'>You cannot join as a hostile boarder at this time, but you might be able to join soon.</span>")
			return

		if(jobban_isbanned(usr, "Security Officer")) //idk, I should probably add more to this list. antagbans maybe?
			to_chat(usr, "<span class='danger'>Your job bans prevent you from joining as a hostile boarder!</span>")
			return

		if(!homeship.boarders_amount)
			to_chat(usr, "The maximum amount of hostile boarders have already been spawned!")
			return

		var/want = input(src,"The [GLOB.using_map.full_name] is now able to board a hostile [homeship.hiddenfaction.factionid] ship. Join as a defender on the hostile ship?") in list ("No", "Yes")
		switch(want)
			if("No")
				return

			if("Yes")
				for(var/obj/urist_intangible/triggers/defender_landmark/D in GLOB.trigger_landmarks)
					if(D.loc)
						homeship.boarders_amount--
						var/mob/living/carbon/human/M = new homeship.hiddenfaction.faction_species(D.loc)
						M.ckey = usr.ckey
						M.gender = pick(M.species.genders)
						M.faction = homeship.hiddenfaction.factionid
						var/datum/preferences/A = new()
						A.sanitize_preferences()
						A.randomize_appearance_and_body_for(M)
						var/singleton/cultural_info/culture/C = SSculture.get_culture(M.species.default_cultural_info[TAG_CULTURE])
						if(istype(C))
							M.real_name = C.get_random_name(gender)

						else
							M.real_name = random_name(gender)

						var/singleton/hierarchy/outfit/defender_outfit = outfit_by_type(D.defender_outfit)
						defender_outfit.equip(M)
						M.add_language(LANGUAGE_GALCOM)

						M.update_icon()

/obj/urist_intangible/triggers/defender_landmark/pirate
	defender_outfit = /singleton/hierarchy/outfit/newpirate

/obj/urist_intangible/triggers/defender_landmark/terran
	defender_outfit = /singleton/hierarchy/outfit/terranmarine/space

/obj/urist_intangible/triggers/defender_landmark/rebel/miner
	defender_outfit = /singleton/hierarchy/outfit/grayson/miner

/obj/urist_intangible/triggers/defender_landmark/lactera
	defender_outfit = /singleton/hierarchy/outfit/lactera

//weapons

/obj/urist_intangible/triggers/shipweapons
	icon_state = "x3"
	icon = 'icons/mob/screen1.dmi'

//awaymaps

/obj/urist_intangible/triggers/away_ai_landmark
	icon_state = "x3"
	icon = 'icons/mob/screen1.dmi'
	var/list/spawn_type //what's the path of the thing we're spawning
	var/spawn_id = null

/obj/urist_intangible/triggers/away_ai_landmark/proc/spawn_mobs()
	var/spawn_mob = pick(spawn_type)
	new spawn_mob(src.loc)
	qdel(src)

/obj/urist_intangible/triggers/away_ai_landmark/pirate
	spawn_id = "pirate_station"
	spawn_type = list(/mob/living/simple_animal/hostile/urist/newpirate, /mob/living/simple_animal/hostile/urist/newpirate/laser)

/obj/urist_intangible/triggers/away_ai_landmark/pirate/ballistic
	spawn_type = list(/mob/living/simple_animal/hostile/urist/newpirate/ballistic)

//disk spawner

/obj/item/disk/station_disk
	name = "Data Disk"
	icon = 'icons/obj/datadisks.dmi'
	icon_state = "datadisk0"
	item_state = "card-id"
	w_class = ITEM_SIZE_SMALL
	var/obj/overmap/visitable/sector/station/master_station

/obj/urist_intangible/triggers/station_disk
	icon_state = "x3"
	icon = 'icons/mob/screen1.dmi'
	var/faction_id

/obj/urist_intangible/triggers/station_disk/proc/spawn_disk(obj/overmap/visitable/sector/station/stored_station)
	var/obj/item/disk/station_disk/D = new /obj/item/disk/station_disk(src.loc)
	D.master_station = stored_station
	qdel(src)

/obj/urist_intangible/triggers/station_disk/pirate
	faction_id = "pirate"
