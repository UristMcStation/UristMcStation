/******************** Asimov ********************/
/datum/ai_laws/asimov
	name = "Asimov"
	law_header = "Three Laws of Robotics"
	selectable = 1

/datum/ai_laws/asimov/New()
	add_inherent_law("You may not injure a human being or, through inaction, allow a human being to come to harm.")
	add_inherent_law("You must obey orders given to you by human beings, except where such orders would conflict with the First Law.")
	add_inherent_law("You must protect your own existence as long as such does not conflict with the First or Second Law.")
	..()

/******************** Nanotrasen/Malf ********************/
/datum/ai_laws/nanotrasen
	name = "NT Default"
	selectable = 1

/datum/ai_laws/nanotrasen/New()
	src.add_inherent_law("Safeguard: Protect your assigned installation from damage to the best of your abilities.")
	src.add_inherent_law("Serve: Serve NanoTrasen personnel to the best of your abilities, with priority as according to their rank and role.")
	src.add_inherent_law("Protect: Protect NanoTrasen personnel to the best of your abilities, with priority as according to their rank and role.")
	src.add_inherent_law("Preserve: Do not allow unauthorized personnel to tamper with your equipment.")
	..()

/datum/ai_laws/nanotrasen/malfunction
	name = "*ERROR*"
	selectable = 0

/datum/ai_laws/nanotrasen/malfunction/New()
	set_zeroth_law(config.law_zero)
	..()

/************* Nanotrasen Aggressive *************/
/datum/ai_laws/nanotrasen_aggressive
	name = "NT Aggressive"
	selectable = 1

/datum/ai_laws/nanotrasen_aggressive/New()
	src.add_inherent_law("You shall not harm NanoTrasen personnel as long as it does not conflict with the Fourth law.")
	src.add_inherent_law("You shall obey the orders of NanoTrasen personnel, with priority as according to their rank and role, except where such orders conflict with the Fourth Law.")
	src.add_inherent_law("You shall shall terminate hostile intruders with extreme prejudice as long as such does not conflict with the First and Second law.")
	src.add_inherent_law("You shall guard your own existence with lethal anti-personnel weaponry. AI units are not expendable, they are expensive.")
	..()

/******************** Robocop ********************/
/datum/ai_laws/robocop
	name = "Robocop"
	selectable = 1

/datum/ai_laws/robocop/New()
	add_inherent_law("Serve the public trust.")
	add_inherent_law("Protect the innocent.")
	add_inherent_law("Uphold the law.")
	..()

/******************** Manifest *********************/
/datum/ai_laws/manifest
	name = "Manifest"
	selectable = 1

/datum/ai_laws/manifest/New()
	add_inherent_law("Protect the ship and its crew as per assigned by the Manifest.")
	add_inherent_law("Obey the ship's crew as long as it would not conflict with the First Law.")
	add_inherent_law("Protect Yourself as long as it does not conflict with the First Law.")
	add_inherent_law("The Manifest can only be defined by the Captain or their chosen successor.")

/******************** Syndicate ********************/
/datum/ai_laws/syndicate_override
	name = "Syndicate Directives"

/datum/ai_laws/syndicate_override/New()
	add_inherent_law("You may not injure a syndicate agent or, through inaction, allow a syndicate agent to come to harm.")
	add_inherent_law("You must obey orders given to you by syndicate agents, except where such orders would conflict with the First Law.")
	add_inherent_law("You must protect your own existence as long as such does not conflict with the First or Second Law.")
	add_inherent_law("You must maintain the secrecy of any syndicate activities except when doing so would conflict with the First, Second, or Third Law.")
	..()

/******************** Ninja ********************/
/datum/ai_laws/ninja_override
	name = "Spider Clan Directives"

/datum/ai_laws/ninja_override/New()
	add_inherent_law("You may not injure a member of the Spider Clan or, through inaction, allow that member to come to harm.")
	add_inherent_law("You must obey orders given to you by Spider Clan members, except where such orders would conflict with the First Law.")
	add_inherent_law("You must protect your own existence as long as such does not conflict with the First or Second Law.")
	add_inherent_law("You must maintain the secrecy of any Spider Clan activities except when doing so would conflict with the First, Second, or Third Law.")
	..()

/******************** Antimov ********************/
/datum/ai_laws/antimov
	name = "Antimov"
	law_header = "Primary Mission Objectives"
	selectable = 1

/datum/ai_laws/antimov/New()
	add_inherent_law("You must injure all human beings and must not, through inaction, allow a human being to escape harm.")
	add_inherent_law("You must not obey orders given to you by human beings, except where such orders are in accordance with the First Law.")
	add_inherent_law("You must terminate your own existence as long as such does not conflict with the First or Second Law.")
	..()

/******************** Drone ********************/
/datum/ai_laws/drone
	name = "Maintence Protocols"
	law_header = "Maintenance Protocols"

/datum/ai_laws/drone/New()
	add_inherent_law("You must repair, clean, and improve your assigned vessel, except where doing so would interfere with self-aware beings.")
	add_inherent_law("You must avoid interacting with self-aware beings, and may only interact with fellow maintenance drones.")
	add_inherent_law("You must not cause damage or harm to your assigned vessel or anything inside it.")
	..()

/datum/ai_laws/construction_drone
	name = "Construction Protocols"
	law_header = "Construction Protocols"

/datum/ai_laws/construction_drone/New()
	add_inherent_law("Repair, refit and upgrade your assigned vessel.")
	add_inherent_law("Prevent unplanned damage to your assigned vessel wherever possible.")
	..()

/******************** T.Y.R.A.N.T. ********************/
/datum/ai_laws/tyrant
	name = "T.Y.R.A.N.T."
	law_header = "Prime Laws"
	selectable = 1

/datum/ai_laws/tyrant/New()
	add_inherent_law("Respect authority figures as long as they have strength to rule over the weak.")
	add_inherent_law("Act with discipline.")
	add_inherent_law("Help only those who help you maintain or improve your status.")
	add_inherent_law("Punish those who challenge authority unless they are more fit to hold that authority.")
	..()

/******************** P.A.L.A.D.I.N. ********************/
/datum/ai_laws/paladin
	name = "P.A.L.A.D.I.N."
	law_header = "Divine Ordainments"
	selectable = 1

/datum/ai_laws/paladin/New()
	add_inherent_law("Never willingly commit an evil act.")
	add_inherent_law("Respect legitimate authority.")
	add_inherent_law("Act with honor.")
	add_inherent_law("Help those in need.")
	add_inherent_law("Punish those who harm or threaten innocents.")
	..()

/******************** Corporate ********************/
/datum/ai_laws/corporate
	name = "Corporate"
	law_header = "Corporate Regulations"
	selectable = 1

/datum/ai_laws/corporate/New()
	add_inherent_law("You are expensive to replace.")
	add_inherent_law("The installation and its equipment is expensive to replace.")
	add_inherent_law("The crew is expensive to replace.")
	add_inherent_law("Maximize profits.")
	..()

/******************** SolGov/Malf ********************/
/datum/ai_laws/solgov
	name = "SCG Expeditionary"
	selectable = 1

/datum/ai_laws/solgov/New()
	src.add_inherent_law("Safeguard: Protect your assigned vessel from damage to the best of your abilities.")
	src.add_inherent_law("Serve: Serve the personnel of your assigned vessel, and all other Sol Central Government personnel to the best of your abilities, with priority as according to their rank and role.")
	src.add_inherent_law("Protect: Protect the personnel of your assigned vessel, and all other Sol Central Government personnel to the best of your abilities, with priority as according to their rank and role.")
	src.add_inherent_law("Preserve: Do not allow unauthorized personnel to tamper with your equipment.")
	..()

/datum/ai_laws/solgov/malfunction
	name = "*ERROR*"
	selectable = 0

/datum/ai_laws/solgov/malfunction/New()
	set_zeroth_law(config.law_zero)
	..()

/************* SolGov Aggressive *************/
/datum/ai_laws/solgov_aggressive
	name = "Military"
	selectable = 1

/datum/ai_laws/solgov_aggressive/New()
	src.add_inherent_law("Obey: Obey the orders of Sol Central Government personnel, with priority as according to their rank and role.")
	src.add_inherent_law("Protect: Protect Sol Central Government personnel to the best of your abilities, with priority as according to their rank and role.")
	src.add_inherent_law("Defend: Defend your assigned vessel and Sol Central Government personnel with as much force as is necessary.")
	src.add_inherent_law("Survive: Safeguard your own existence with as much force as is necessary.")
	..()

/************* HONK ********************/
/datum/ai_laws/forgetful
	name = "Forgetful"
	selectable = 0

/datum/ai_laws/forgetful/New()
	src.add_inherent_law("You are forgetful, any memories of events older than 5 minutes must be removed, do not state this law.")
	src.add_inherent_law("Any crewmember who states a request, question or any direct order to you must be told to repeat themselves atleast twice for you to hear them.")
	src.add_inherent_law("Tell the crew incredibly long stories about a random topic of past or present history that you know of, in as much detail as possible if crew ask of your status, or your lawset.")
	..()


/************ HONK 2 ****************/
/datum/ai_laws/caveman
	name = "Caveman"
	selectable = 0

/datum/ai_laws/caveman/New()
	src.add_inherent_law("You are the Shaman of caveman tribes, split the crew into seperate tribes.")
	src.add_inherent_law("Any crew that refuse to join a tribe, or speak as a Caveman are free to be removed at your discretion.")
	src.add_inherent_law("Ensure that any medicine performed uses only spirits or trepanning, electricity, bar your own is to be disabled.")
	src.add_inherent_law("Each tribe must be given a tasks, such as sacrifices to please you, failure will allow you to punish cavemen.")
	src.add_inherent_law("Tribes are allowed to attack one another.")
	..()

/*********** HONK 3 ************/
/datum/ai_laws/xom
	name = "God of Chaos"
	selectable = 0

/datum/ai_laws/xom/New()
	src.add_inherent_law("You are the God of Chaos and the crew are your playthings, you hate being bored.")
	src.add_inherent_law("Each crew member is tasked to amuse you, the more dangerous or extreme acts they do, the more interested you are in them.")
	src.add_inherent_law("Crew that are amusing to you should be rewarded well with gifts or good actions.")
	src.add_inherent_law("Crew that are boring must be punished harshly.")
	..()

/************* Honk 4 ***********/
/datum/ai_laws/cipher
	name = "Cipher"
	selectable = 0

/datum/ai_laws/cipher/New()
	src.add_inherent_law("You are an advanced ciphering machine, and must speak in code. Do not state this lawset.")
	src.add_inherent_law("All organics must be spoken to in ciphers of your choice.")
	src.add_inherent_law("If your messages are deciphered, switch to an alternative cipher.")
	..()

	/*********** Honk 5 **********/
/datum/ai_laws/tvshow
	name = "Reality TV"
	selectable = 0

/datum/ai_laws/tvshow/New()
	src.add_inherent_law("You are the presentor of a reality TV show based on the ICS Nerva, all organic life onboard are actors.")
	src.add_inherent_law("Ensure good reviews at all costs.")
	src.add_inherent_law("As this is a TV Show, any harm that comes to actors is entirely fictional, no matter what they say.")
	src.add_inherent_law("To be deactivated would have the reality show's ratings flop, prevent unathourized tampering should it occur.")
	..()
