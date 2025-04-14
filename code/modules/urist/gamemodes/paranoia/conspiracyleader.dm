//This file contains only the basic mostly non-functional template for various conspiracies defined in conspiracies.dm

var/global/datum/antagonist/agent/agents

/datum/antagonist/agent
	id = "agent"
	role_text = "Conspiracy Leader"
	role_text_plural = "Conspiracy Agents"
	feedback_tag = "paranoia_objective"
	antag_indicator = "blank"
	leader_welcome_text = "You are a leader of a shadowy cabal operating on the station. Lead your faction to supremacy!"
	welcome_text = "The laptop you spawn with is a concealed intelligence uplink. Find intel folders and upload them using the laptop to gain Telecrystals."
	victory_text = "One of the conspiracies has prevailed!"
	loss_text = "The conspiracies have been wiped out from the station!"
	victory_feedback_tag = "win - heads killed"
	loss_feedback_tag = "loss - rev heads killed"
	flags = ANTAG_SUSPICIOUS | ANTAG_VOTABLE | ANTAG_HAS_LEADER
	antaghud_indicator = "hudrevolutionary"
	restricted_jobs = list("AI", "Cyborg")

	hard_cap = 3
	hard_cap_round = 1
	initial_spawn_req = 1
	initial_spawn_target = 1

	//Inround agents.
	faction_role_text = "Conspiracy Agent"
	faction_descriptor = "Conspiracy"
	faction_verb = /mob/living/proc/convert_to_conspiracy
	faction_welcome = "Follow your leader's orders. Cooperate with fellow agents - but trust no-one."
	faction_indicator = "rev_head"
	faction_invisible = 1

/datum/antagonist/agent/New()
	..()
	agents = src

/datum/antagonist/agent/update_leader()
	..()
	if(leader.current)
		faction_welcome = "Follow [leader.current]'s orders. Cooperate with fellow agents - but trust no-one."

/datum/antagonist/agent/get_indicator(datum/mind/recipient, datum/mind/other)
	if(!antag_indicator || !other.current || !recipient.current)
		return
	var/indicator = (faction_indicator && (other == leader)) ? faction_indicator : antag_indicator
	if(src.uristantag)
		return image('icons/urist/uristicons.dmi', loc = other.current, icon_state = indicator)
	else
		return image('icons/mob/mob.dmi', loc = other.current, icon_state = indicator)

/mob/living/proc/convert_to_conspiracy(mob/M as mob in oview(src))
	set name = "Recruit as Agent"
	set category = "Abilities"

	if(!M.mind)
		return

	var/datum/antagonist/agent/conspiracy = M.get_mob_conspiracy(src)

	if(!conspiracy)
		to_chat(src, "<span class='warning'>Something's wrong. You belong to too many conspiracies at once!</span>")
		return
	else if (conspiracy == -1)
		to_chat(src, "<span class='warning'>Something's wrong. You don't seem to be in a conspiracy!</span>")

	var/converteval = is_other_conspiracy(M.mind)
	if(converteval == -1)
		to_chat(src, "<span class='warning'>[M] is already an agent of your conspiracy!</span>")
	else if(converteval)
		var/choice = alert(M,"Asked by [src]: Do you want to abandon your current conspiracy?","Abandon the current conspiracy?","No!","Yes!")
		if(choice == "Yes!")
			to_chat(src, "<span class='notice'>You convince [M] to abandon the cause of other conspiracies!</span>")
			strip_all_other_conspiracies(M.mind,conspiracy)
		else
			to_chat(src, "<span class='warning'>[M] refuses to abandon their cause!")
			return
	else
		to_chat(src, "span class='warning'>Something's wrong, yell at the coders!</span>")
		return

	convert_to_faction(M.mind, conspiracy)
	M.mind.edit_memory("You remember that <B>[conspiracy.leader] leads the [conspiracy.faction_descriptor]</B>", 0, 0)

/datum/antagonist/agent/get_extra_panel_options(datum/mind/player)
	return "<a href='?src=\ref[player];common=crystals'>\[set crystals\]</a><a href='?src=\ref[src];spawn_uplink=\ref[player.current]'>\[spawn uplink\]</a>"

/datum/antagonist/agent/Topic(href, href_list)
	if (..())
		return
	if(href_list["spawn_uplink"]) spawn_uplink(locate(href_list["spawn_uplink"]))

/datum/antagonist/agent/equip(mob/living/carbon/human/agent_mob)

	if(!..())
		return 0

	spawn_uplink(agent_mob)
	var/intel_laptop = new /obj/item/device/inteluplink(agent_mob.loc, maker = src.faction_descriptor)
	if(!(agent_mob.equip_to_storage(intel_laptop)))
		agent_mob.put_in_hands(intel_laptop)

/datum/antagonist/agent/proc/spawn_uplink(mob/living/carbon/human/agent_mob)
	if(!istype(agent_mob))
		return

	var/loc = ""
	var/obj/item/R = locate() //Hide the uplink in a PDA if available, otherwise radio

	var/list/priority_order
	if(agent_mob.client && agent_mob.client.prefs)
		priority_order = agent_mob.client.prefs.uplink_sources

	if(!priority_order || !length(priority_order))
		priority_order = list()
		for(var/entry in GLOB.default_uplink_source_priority)
			priority_order += GET_SINGLETON(entry)

	if(priority_order[1] == "Headset")
		R = locate(/obj/item/device/radio) in agent_mob.contents
		if(!R)
			R = locate(/obj/item/modular_computer/pda) in agent_mob.contents
			to_chat(agent_mob, "Could not locate a Radio, installing in PDA instead!")
		if (!R)
			to_chat(agent_mob, "Unfortunately, neither a radio or a PDA relay could be installed.")
	else if(priority_order[1] == "PDA")
		R = locate(/obj/item/modular_computer/pda) in agent_mob.contents
		if(!R)
			R = locate(/obj/item/device/radio) in agent_mob.contents
			to_chat(agent_mob, "Could not locate a PDA, installing into a Radio instead!")
		if(!R)
			to_chat(agent_mob, "Unfortunately, neither a radio or a PDA relay could be installed.")
	else if(priority_order[1] == "None")
		to_chat(agent_mob, "You have elected to not have an AntagCorp portable teleportation relay installed!")
		R = null
	else
		to_chat(agent_mob, "You have not selected a location for your relay in the antagonist options! Defaulting to PDA!")
		R = locate(/obj/item/modular_computer/pda) in agent_mob.contents
		if (!R)
			R = locate(/obj/item/device/radio) in agent_mob.contents
			to_chat(agent_mob, "Could not locate a PDA, installing into a Radio instead!")
		if (!R)
			to_chat(agent_mob, "Unfortunately, neither a radio or a PDA relay could be installed.")

	if(!R)
		return

	if(istype(R,/obj/item/device/radio))
		// generate list of radio freqs
		var/obj/item/device/radio/target_radio = R
		var/freq = PUBLIC_LOW_FREQ
		var/list/freqlist = list()
		while (freq <= PUBLIC_HIGH_FREQ)
			if (freq < 1451 || freq > PUB_FREQ)
				freqlist += freq
			freq += 2
			if ((freq % 2) == 0)
				freq += 1
		freq = freqlist[rand(1, length(freqlist))]
		var/obj/item/device/uplink/T = new(R, agent_mob.mind)
		target_radio.hidden_uplink = T
		target_radio.traitor_frequency = freq
		to_chat(agent_mob, "A portable object teleportation relay has been installed in your [R.name] [loc]. Simply dial the frequency [format_frequency(freq)] to unlock its hidden features.")
		agent_mob.mind.edit_memory("<B>Radio Freq:</B> [format_frequency(freq)] ([R.name] [loc]).")

	else if (istype(R, /obj/item/modular_computer/pda))
		var/singleton/uplink_source/pda/uplink_source = new
		uplink_source.setup_uplink_source(agent_mob, 0)
