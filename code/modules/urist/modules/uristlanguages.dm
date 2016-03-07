//Urist custom languages file

//Totally-not-kobaian, because why not? It's a conlang and I'm a massive nerd.
/datum/language/mekanik
	name = "Sol-Divergent"
	desc = "A strange, militaristic-sounding amalgamation of Germanic and Slavic languages contaminated with French and long isolation from mainstream humanity."
	speech_verb = "says"
	whisper_verb = "whispers"
	colour = "rough"
	key = null
	flags = RESTRICTED
	space_chance = 60

	//syllables are at the bottom of the file

/datum/language/mekanik/get_spoken_verb(var/msg_end)
	switch(msg_end)
		if("!")
			return pick("exclaims","shouts","yells")
		if("?")
			return ask_verb
	return speech_verb

/datum/language/mekanik/get_random_name(var/gender) //TODO: custom Germanesque name list
	if (prob(80))
		if(gender==FEMALE)
			return capitalize(pick(first_names_female)) + " " + capitalize(pick(last_names))
		else
			return capitalize(pick(first_names_male)) + " " + capitalize(pick(last_names))
	else
		return ..()

//Syllable Lists

/datum/language/mekanik/syllables = list(
"hur","dëh", "ant", "wurdah ", "zik", "köhn", "ork", "bahnn", "strain", "wort", "siš", "felt", "wirt",
"da", "fünk", "zort", "wuhr", "di", "heul", "urwah ", "glaö", "šteuhr", "wurd", "dowëri", "rin", "sün",
"hirr", "ünt", "tlait", "wowosëhn", "ri", "wölt"
)