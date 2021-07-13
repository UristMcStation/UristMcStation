/datum/factions
	var/factionid = "faction"//how are mobs tied to our faction
	var/name = "faction"
	var/desc = "faction"
	var/reputation = 0 //how much do they like/hate us
	var/hostile = FALSE //are they hostile?
	var/allow_spawn = TRUE //can they spawn? for initializaing on a per-map basis, if we don't want UHA in Glloydstation or whatever, idk.
	var/faction_species = /mob/living/carbon/human //mob type of the dominant species in the faction, currently only used for boarding
	//transport ships?
	//guard ships?

/datum/factions/nanotrasen
	factionid = "nanotrasen"
	name = FACTION_NANOTRASEN
	reputation = 35

/datum/factions/terran
	factionid = "terran"
	name = FACTION_SOL_CENTRAL
	reputation = 15

/datum/factions/uha
	factionid = "uha"
	name = "United Human Alliance"
	reputation = 5

/datum/factions/pirate
	factionid = "pirate"
	name = "pirate"
	reputation = -100
	hostile = TRUE

/datum/factions/alien
	factionid = "alien"
	name = "alien"
	reputation = -100
	hostile = TRUE
	faction_species = /mob/living/carbon/human/lactera

/datum/factions/rebel
	factionid = "rebel"
	name = "rebel"
