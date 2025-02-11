/datum/say_list/gunman
	// Generic thug.
	// Kinda mid-level professionalism - does the job, but still fairly casual.

	speak = list(
		"Doot-doo doo...",
		"Wish I had better equipment...",
		"Damn, I could use a smoke...",
		"...keep it together, just one last job and I'll retire...",
		"The boss said to expect hostiles... where the fuck did everyone go?",
		// I'm evil. These overlap with say_maybe_target *on purpose*. Guy's paranoid, okay?
		"Hey, what's that?",
		"Who's there?"
	)

	say_maybe_target = list(
		"Hey, what's that?",
		"Who's there?"
	)

	say_threaten = list(
		"Get outta here pal, this is none of your business.",
		"Get lost or someone's gonna get hurt.",
		"Make like a tree and get the hell outta my sight!",
		"Wrong place, wrong time bud. Skedaddle."
	)
	emote_hear = list("sniffs", "coughs", "spits")
	emote_see = list("scratches himself", "taps his foot", "looks around", "checks his equipment")

	// These are a copypasta of say_list/merc
	// Unfortunately Merc is a bit *too specific*.
	say_understood = list("Understood!", "Affirmative!")
	say_cannot = list("Negative!")
	say_got_target = list("Engaging!", "Drop 'em!")
	say_stand_down = list("Good.")
	say_escalate = list("Your funeral!", "Bring it!")

	threaten_sound = 'sound/weapons/TargetOn.ogg'
	stand_down_sound = 'sound/weapons/TargetOff.ogg'


/datum/say_list/professional
	// Generic operative, for NTIS/Syndicate agents and similar.
	// Sneaky professional - doesn't make a sound unless he has to.

	// Quiet
	speak = list()
	emote_see = list("quickly scans the environment", "checks his equipment")

	say_maybe_target = list("Investigating...")

	say_threaten = list("Out. Now!")
	say_escalate = list()  // stone-cold

	// These are a copypasta of say_list/merc
	// Unfortunately Merc is a bit *too specific*.
	say_understood = list("Understood.", "Affirmative.")
	say_cannot = list("Negative!")
	say_got_target = list("Engaging!", "Hostile!", "Contact!")
	say_stand_down = list("Good.")

	threaten_sound = 'sound/weapons/TargetOn.ogg'
	stand_down_sound = 'sound/weapons/TargetOff.ogg'


/datum/say_list/fanatic
	// Meant for Skrellorists and Cultists, but fairly generic.
	// I am NOT sorry for the C&C Generals references.

	speak = list(
		"No one escapes...",
		"Our courage will be seen by all!",
		"Our way is true!",
		"I could use some new boots...",
		"We have no time to waste!"
	)
	emote_see = list("sniffs", "coughs", "taps his foot", "looks around", "checks his equipment")

	say_maybe_target = list(
		"The enemy may be near!",
		"I'll punch up the next thing that moves!",
		"Be on watch for the enemy!"
	)

	say_threaten = list(
		"Don't get on my bad side..."
	)
	say_escalate = list("Get them!")

	say_understood = list("Understood.", "Affirmative.")
	say_cannot = list("Negative!")

	say_got_target = list(
		"AAAAAAAAA!",
		"I will die for our cause!",
		"Enemy!",
		"They will fear us!",
		"Get them!",
		"Spray them!"
	)

	say_stand_down = list("Good.")

	threaten_sound = 'sound/weapons/TargetOn.ogg'
	stand_down_sound = 'sound/weapons/TargetOff.ogg'


/datum/say_list/redshirt
	// Police types. Not as icy as Pros.

	// Quiet
	speak = list(
		"All clear so far.",
		"Area secure.",
		"Just one week until retirement...",
		"I'd kill for a donut right now...",
		"Can't wait to take this gear off. What do they make this from, lead plates?"
	)
	emote_see = list("sniffs", "coughs", "taps his foot", "looks around", "checks his equipment")

	say_maybe_target = list("Investigating...")

	say_threaten = list("Hands behind your back, now!", "Down, now!")
	say_escalate = list("Stop resisting!")

	// These are a copypasta of say_list/merc
	// Unfortunately Merc is a bit *too specific*.
	say_understood = list("Understood.", "Affirmative.", "Got it.", "Yup.")
	say_cannot = list("Negative!", "No can do.")
	say_got_target = list("Light them up!", "STOP RESISTING!", "I AM THE LAAAAAW!")
	say_stand_down = list("Damn, they ran off.", "Screw it, I'm not sprinting in *this* gear..")

	threaten_sound = 'sound/weapons/TargetOn.ogg'
	stand_down_sound = 'sound/weapons/TargetOff.ogg'


/datum/say_list/monster_generic
	emote_hear = list("roars!", "growls!", "sniffs the air...", "stomps the ground heavily!")
	emote_see = list("snaps it's head at something...", "looks around...", "chews on something unidentifiable...")
