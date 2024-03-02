/mob/living/simple_animal/aitester
	icon = 'icons/uristmob/simpleanimals.dmi'
	icon_state = "ANTAG"

	var/dict/attachments

	var/spawn_commander = TRUE
	var/equip = TRUE
	var/ensure_unique_name = FALSE

	var/commander_id = null


/mob/living/simple_animal/aitester/proc/ChooseFaction()
	var/list/factions = list("ANTAG", "Skrell", "NTIS")
	var/myfaction = pick(factions)
	return myfaction


/mob/living/simple_animal/proc/SpriteForFaction(var/faction)
	if(isnull(faction))
		return

	switch(faction)
		if("ANTAG") return "ANTAG"
		if("Skrell") return "skrellorist"
		if("NTIS") return "agent"
		if("Terran") return "terran_marine"


/mob/living/simple_animal/aitester/proc/Equip()
	var/obj/item/weapon/gun/mygun = new(src)
	to_chat(src, "You've received a [mygun]")
	return src


/mob/living/simple_animal/aitester/proc/SpawnCommander()
	var/datum/utility_ai/mob_commander/combat_commander/new_commander = new()
	#ifdef UTILITY_SMARTOBJECT_SENSES
	// Spec for Dev senses!
	new_commander.sense_filepaths = DEFAULT_UTILITY_AI_SENSES
	#endif
	AttachUtilityCommanderTo(src, new_commander)
	src.commander_id = new_commander.registry_index
	return src


/mob/living/simple_animal/aitester/New()
	. = ..()

	//src.directional_blocker = new(null, null, TRUE, TRUE)
	src.cover_data = new(TRUE, TRUE)

	if(isnull(src.faction))
		src.faction = src.ChooseFaction()
		var/new_sprite = src.SpriteForFaction(src.faction)

		if(new_sprite)
			src.icon_state = new_sprite

	if(equip)
		src.Equip()

	if(isnull(src.real_name))
		src.real_name = "AiTester"

	if(ensure_unique_name)
		src.real_name = "[src.real_name] #[rand(100, 999)]-[rand(100, 999)]"

	src.name = src.real_name

	if(src.spawn_commander)
		src.SpawnCommander()

	return


// Spawns with a pure Utility AI instead
/mob/living/simple_animal/aitester/utility


/mob/living/simple_animal/aitester/utility/verb/ReloadAi()
	set src in view()

	if(!src.commander_id)
		return

	if(IS_REGISTERED_AI(src.commander_id))
		var/datum/utility_ai/mob_commander/commander = GOAI_LIBBED_GLOB_ATTR(global_goai_registry[src.commander_id])
		var/datum/brain/utility/ubrain = commander?.brain
		if(ubrain)
			for(var/cache_key in ubrain.file_actionsets)
				actionset_file_cache[cache_key] = null  // clear the global cache

			PUT_EMPTY_LIST_IN(ubrain.file_actionsets)  // clear the local cache
			to_chat(usr, "AI for [src] reloaded!")

	return src
