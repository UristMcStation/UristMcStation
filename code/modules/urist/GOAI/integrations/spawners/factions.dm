// TODO: port to Utility!

/proc/spawn_faction_commander(var/faction_name)
	var/datum/goai/goai_commander/faction_ai/new_commander = new()
	var/true_faction_name = (faction_name || BuildFactionName())

	if(true_faction_name)
		new_commander.name = true_faction_name


/proc/BuildFactionName()
	var/list/faction_prefixes = list(
		"Red",
		"Green",
		"Blue",
		"White",
		"Black",
		"Grey"
	)

	var/list/faction_nouns = list(
		"Faction",
		"Falcons",
		"Stripes",
		"Federation",
		"Coalition",
		"Fraternity"
	)

	var/prefix = pick(faction_prefixes)
	var/noun = pick(faction_nouns)
	var/list/name_builder = list("The", prefix, noun)

	var/new_name = name_builder.Join(" ")
	return new_name


/obj/spawner/oneshot/faction
	var/faction_name
	script = /proc/spawn_faction_commander


/obj/spawner/oneshot/faction/CallScript()
	if(!active)
		return

	var/script_args = list(faction_name = BuildFactionName())
	sleep(-1)
	call(script)(arglist(script_args))
