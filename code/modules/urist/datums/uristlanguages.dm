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

/datum/language/mekanik/get_spoken_verb(msg_end)
	switch(msg_end)
		if("!")
			return pick("exclaims","shouts","yells")
		if("?")
			return ask_verb
	return speech_verb

/datum/language/mekanik/get_random_name(gender) //TODO: custom Germanesque name list
	if (prob(80))
		if(gender==FEMALE)
			return capitalize(pick(GLOB.first_names_female)) + " " + capitalize(pick(GLOB.last_names))
		else
			return capitalize(pick(GLOB.first_names_male)) + " " + capitalize(pick(GLOB.last_names))
	else
		return ..()

//Syllable Lists

/datum/language/mekanik/syllables = list(
"hur","d�h", "ant", "wurdah ", "zik", "k�hn", "ork", "bahnn", "strain", "wort", "si�", "felt", "wirt",
"da", "f�nk", "zort", "wuhr", "di", "heul", "urwah ", "gla�", "�teuhr", "wurd", "dow�ri", "rin", "s�n",
"hirr", "�nt", "tlait", "wowos�hn", "ri", "w�lt"
)
