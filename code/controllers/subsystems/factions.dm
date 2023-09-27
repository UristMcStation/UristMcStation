SUBSYSTEM_DEF(factions)
	name = "Faction"
	flags = SS_NO_FIRE
	var/list/factions = list()
	var/list/hostile_factions = list()

/datum/controller/subsystem/factions/Initialize()
	for(var/faction_type in typesof(/datum/factions) - /datum/factions)
		var/datum/factions/F = new faction_type()
		if(F.allow_spawn)
			factions.Add(F)

			if(F.reputation < 0 || F.hostile)
				hostile_factions.Add(F)

	if(GLOB.using_map.trading_faction)
		GLOB.using_map.trading_faction = get_faction_by_type(GLOB.using_map.trading_faction)

	. = ..()

/datum/controller/subsystem/factions/proc/update_reputation(datum/factions/faction, var/rep = 0) //call this on stuff that would incur a relationship boost or hit
	faction.reputation += rep
	faction.reputation = clamp(faction.reputation, -100, 100)

	if(faction.reputation < 0 && !faction.hostile) //maybe cap things at 100? idk
		faction.hostile = TRUE
		hostile_factions.Add(faction)
		update_mob_faction(faction, TRUE)

	else if(faction.reputation >= 0 && faction.hostile)
		faction.hostile = FALSE
		hostile_factions.Remove(faction)
		update_mob_faction(faction, FALSE)

/datum/controller/subsystem/factions/proc/update_mob_faction(datum/factions/faction, var/is_hostile)
	for(var/mob/living/simple_animal/hostile/M in GLOB.simple_mob_list)
		if(M.hiddenfaction == faction)
			if(is_hostile)
				M.faction = M.hiddenfaction.factionid

			else
				M.faction = "neutral"

/datum/controller/subsystem/factions/proc/get_faction_by_type(var/faction)
	for(var/datum/factions/F in factions)
		if(F.type == faction)
			return F