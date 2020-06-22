
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
	var/spawn_type = null //what's the path of the thing we're spawning

/obj/effect/urist/triggers/ai_defender_landmark/proc/spawn_mobs()
	new spawn_type(src.loc)
	qdel(src)

/obj/effect/urist/triggers/ai_defender_landmark/pirate
	spawn_type = /mob/living/simple_animal/hostile/pirate //temp

/obj/effect/urist/triggers/ai_defender_landmark/terran/space_marine
	spawn_type = /mob/living/simple_animal/hostile/urist/terran/marine_space

/obj/effect/urist/triggers/ai_defender_landmark/terran/marine
	spawn_type = /mob/living/simple_animal/hostile/urist/terran/marine

/obj/effect/urist/triggers/ai_defender_landmark/terran/officer
	spawn_type = /mob/living/simple_animal/hostile/urist/terran/marine_officer

/obj/effect/urist/triggers/ai_defender_landmark/rebel
	spawn_type = /mob/living/simple_animal/hostile/urist/rebel

/obj/effect/urist/triggers/ai_defender_landmark/lactera/medium
	spawn_type = /mob/living/simple_animal/hostile/scom/lactera/medium

/obj/effect/urist/triggers/ai_defender_landmark/lactera/light
	spawn_type = /mob/living/simple_animal/hostile/scom/lactera/light

/obj/effect/urist/triggers/ai_defender_landmark/lactera/heavy
	spawn_type = /mob/living/simple_animal/hostile/scom/lactera/heavy

/obj/effect/urist/triggers/ai_defender_landmark/lactera/leader
	spawn_type = /mob/living/simple_animal/hostile/scom/lactera/leader

//humans

/obj/effect/urist/triggers/defender_landmark
	icon_state = "x3"
	icon = 'icons/mob/screen1.dmi'
	invisibility = 101
	var/defender_outfit = null

/mob/observer/ghost/proc/shipdefender_spawn(var/datum/factions/hiddenfaction)
	var/want = input("The [GLOB.using_map.name] is now able to board a hostile [hiddenfaction.factionid] ship. Join as a defender on the hostile ship?") in list ("No", "Yes")
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
	defender_outfit = /decl/hierarchy/outfit/pirate/space //temp

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