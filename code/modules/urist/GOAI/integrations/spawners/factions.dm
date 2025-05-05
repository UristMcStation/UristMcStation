
/proc/spawn_faction_commander(var/factionspec_filepath, var/generate_faction_name = FALSE)
	var/datum/utility_ai/faction_commander/spawner/new_commander = new()

	if(factionspec_filepath)
		new_commander.factionspec_source = factionspec_filepath

	// We use deferred InitPawn() here so we need to call it ourselves.
	new_commander.InitPawn()

	if(generate_faction_name)
		new_commander.name = BuildFactionName()
	else
		var/mob/pawnmob = new_commander.GetPawn()
		new_commander.name = pawnmob?.name

	return new_commander


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


/obj/goai_spawner/oneshot/faction
	var/factionspec_filepath = null
	var/generate_faction_name = null
	script = GLOBAL_PROC_REF(spawn_faction_commander)


/obj/goai_spawner/oneshot/faction/CallScript()
	set waitfor = FALSE

	if(!active)
		return

	var/script_args = list()

	if(!isnull(src.factionspec_filepath))
		script_args["factionspec_filepath"] = src.factionspec_filepath

	if(!isnull(src.generate_faction_name))
		script_args["generate_faction_name"] = src.generate_faction_name

	sleep(0)
	call(script)(arglist(script_args))
