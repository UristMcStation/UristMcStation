//faction datums. once the faction system is more finalized, move these into the individual map folders and define them on a per-map basis. currently, these defines only make sense for Nerva.

/datum/factions
	var/factionid = "faction"//how are mobs tied to our faction
	var/name = "faction"
	var/desc = "faction"
	var/reputation = 0 //how much do they like/hate us
	var/hostile = FALSE //are they hostile?
	var/allow_spawn = TRUE //can they spawn? for initializing on a per-map basis, if we don't want UHA in Glloydstation or whatever, idk.
	var/faction_species = /mob/living/carbon/human //mob type of the dominant species in the faction, currently only used for boarding
	//transport ships?
	//guard ships?

/datum/factions/nanotrasen
	factionid = "nanotrasen"
	name = "NanoTrasen"
	reputation = 35
	desc = "The NanoTrasen Corporation, commonly referred to as NT, is the largest of the great megacorporations of the modern day. A nation unto itself, \
	NanoTrasen is currently headquartered in New Amsterdam on Procyon and headed by CEO Jackson Trasen and the NanoTrasen Board of Directors. \
	It deals in research of the most advanced sciences,	such as genetics, blue space, and - recently - the uses of phoron, \
	as well as mass consumer manufacturing on a truly galactic scale. Since the Galactic Crisis, they have increasingly turned to contracting independent vessels \
	to conduct their work in the outer systems. As such, NanoTrasen is frequently the only human presence remaining in outer systems, lending them a virtual monopoly on trade in these areas."

/datum/factions/terran
	factionid = "terran"
	name = "Terran Confederacy"
	desc = "The Terran Confederacy, commonly referred to as the Confederacy or the TC, is an oligarchic federal republic composed of numerous human planets spanning many systems. \
	Based in the Sol System with its capital on Mars, the Terran Confederacy governs the majority of human space. However, between the ongoing Terran Civil War with the United Human Alliance, \
	growing rebellions for liberation in the outer colonies, and the lasting impact of the Galactic Crisis, the Terran Confederacy has been rapidly declining in recent years, and some fear its imminent collapse."
	reputation = 15

/datum/factions/uha
	factionid = "uha"
	name = "United Human Alliance"
	desc = "The United Human Alliance, commonly referred to as the UHA, is a growing power in human space, \
	bordered by the Terran Confederacy towards the galactic centre. Born out of the post Galactic Crisis unrest, \
	xenophobia and economic turmoil in the Terran Confederacy, the United Human Alliance is a radical xenophobic \
	secessionist movement started by a group of planetary governors and Terran politicians discontent at the \
	concessions made to the Unathi in exchange for their help during the Galactic Crisis. Based out of the planet of Terra (formerly known as New Earth), \
	the central government and planetary governments are almost entirely dominated by the military, and civil rights have been extremely curtailed, in the name of winning the ongoing civil war."
	reputation = 5

/datum/factions/pirate
	factionid = "pirate"
	name = "Pirates"
	desc = "Piracy has been a hallmark of the outer systems since mankind started expanding beyond Sol. However, since the Galactic Crisis, piracy has grown exponentially, and pirates have become bolder, \
	better armed, and more numerous. A large number of this growth comes from those displaced by the Galactic Crisis, who have turned to piracy as a means of survival when the state has failed them. \
	They generally take no prisoners, and won't treat independent vessels kindly. Watch out for them."
	reputation = -100
	hostile = TRUE

/datum/factions/alien
	factionid = "alien"
	name = "Galactic Crisis Aliens"
	desc = "The aliens of the Galactic Crisis are a force from an unknown galaxy that invaded the Milky Way beginning in 2556. Comprising a wide range of species held together \
	by the psionic control of the Allophylus, the only goal of the alien forces appeared to be to wipe out humanity and to mind-slave them to the Allophylus, as had been done \
	with the other constituent species of the invading force such as the Lactera. With the alien forces broken after the Battle of Qerrbalak in 2565, the Galactic Crisis has ended. However, although the  \
	psionic control of the Allophylus has been broken, alien forces remain in the Milky Way, directionless and scattered, but still dangerous."
	reputation = -100
	hostile = TRUE
	faction_species = /mob/living/carbon/human/lactera

/datum/factions/rebel
	allow_spawn = FALSE //pending lore
	factionid = "rebel"
	name = "rebel"
