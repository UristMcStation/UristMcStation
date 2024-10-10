/singleton/cultural_info/culture/hidden/xenophage/lactera
	name = CULTURE_LACTERA
	language = LANGUAGE_XENOPHAGE
	description = "Similar in appearance to the Unathi, the Lactera are one of the constituent races of the invading alien forces of the Galactic Crisis. Mind-slaved to the powerful Allophylus, \
	the Lactera are the frontline soldiers of the invaders. Although at one point they were a distinct species with their own culture and free will, psionic enslavement by the Allophylus has changed that. \
	Born in a laboratory and raised for the sole purpose of killing, they are creatures genetically modified to be an ideal soldier. \
	Without fear, or regard for their own lives, they are extremely dangerous, despite being relatively fragile. \
	Indeed, they do not feel pain, they do not need to breathe, and their feet are implanted with a magnetic traction system. Driven only by a desire to kill, they can psionically \
	communicate with the other members of their hivemind in order to work effectively as a unit."
	default_language = LANGUAGE_XENOPHAGE
	additional_langs = list(LANGUAGE_XENOPHAGE_GLOBAL)

/singleton/cultural_info/faction/galactic_crisis
	name = FACTION_GALACTIC_CRISIS
	language = LANGUAGE_XENOPHAGE
	default_language = LANGUAGE_XENOPHAGE
	additional_langs = list(LANGUAGE_XENOPHAGE_GLOBAL)
	description = "The aliens of the Galactic Crisis are a force from an unknown galaxy that invaded the Milky Way beginning in 2556. Comprising a wide range of species held together \
	by the psionic control of the Allophylus, the only goal of the alien forces appears to be to wipe out humanity and to mind-slave them to the Allophylus, as has been done \
	with the other constituent species of the invading force."
	mob_faction = "alien"
	additional_langs = list("Hivemind")
	secondary_langs = null
	economic_power = 0
	hidden = TRUE

/singleton/cultural_info/location/deep_space/galactic_crisis
	name = HOME_SYSTEM_GALACTIC_CRISIS
	description = "You came from somewhere beyond the Milky Way, along with the other alien forces of the Galactic Crisis."
