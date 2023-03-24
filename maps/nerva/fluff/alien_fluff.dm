/singleton/cultural_info/culture/hidden/xenophage/lactera
	name = CULTURE_LACTERA
	language = LANGUAGE_XENOPHAGE
	description = "Similar in appearance to the Unathi, the Lactera are one of the constituent races of the invading alien forces of the Galactic Crisis. Formerly mind-slaved to the powerful Allophylus, \
	the Lactera were the frontline soldiers of the invaders. Although at one point they were a distinct species with their own culture and free will, psionic enslavement by the Allophylus has changed that. \
	Born in a laboratory and raised for the sole purpose of killing, they are creatures genetically modified to be an ideal soldier. \
	Without fear, or regard for their own lives, they are extremely dangerous, despite being relatively fragile. \
	Indeed, they do not feel pain, they do not need to breathe, and their feet are implanted with a magnetic traction system. Driven only by a desire to kill, they can psionically \
	communicate with the other members of their hivemind in order to work effectively as a unit. \
	With the psionic control of the Allophylus broken after the Battle of Qerrbalak in 2565, the Lactera are directionless and scattered. \
	Individual units of Lactera have turned to piracy and raiding - killing is the only thing they know, and they continue to do so aimlessly, although \
	with ruthless efficiency they became known for during the Galactic Crisis."
	default_language = LANGUAGE_XENOPHAGE
	additional_langs = list(LANGUAGE_XENOPHAGE_GLOBAL)
	caste_name = "soldier"

/singleton/cultural_info/faction/galactic_crisis
	name = FACTION_GALACTIC_CRISIS
	language = LANGUAGE_XENOPHAGE
	default_language = LANGUAGE_XENOPHAGE
	additional_langs = list(LANGUAGE_XENOPHAGE_GLOBAL)
	description = "The aliens of the Galactic Crisis are a force from an unknown galaxy that invaded the Milky Way beginning in 2556. Comprising a wide range of species held together \
	by the psionic control of the Allophylus, the only goal of the alien forces appeared to be to wipe out humanity and to mind-slave them to the Allophylus, as had been done \
	with the other constituent species of the invading force. With the alien forces broken after the Battle of Qerrbalak in 2565, the Galactic Crisis has ended. However, although the  \
	psionic control of the Allophylus has been broken, alien forces remain in the Milky Way, directionless and scattered, but still dangerous."
	mob_faction = "alien"
	additional_langs = list("Hivemind")
	secondary_langs = null
	economic_power = 0
	hidden = TRUE

/singleton/cultural_info/location/deep_space/galactic_crisis
	name = HOME_SYSTEM_GALACTIC_CRISIS
	description = "You came from somewhere beyond the Milky Way, along with the other alien forces of the Galactic Crisis. \
	Now that the Galactic Crisis is over and the alien forces are broken, you wander the galaxy aimlessly."
