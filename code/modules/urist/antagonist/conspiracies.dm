//This file defines the various conspiracies
//Unfortunately large amounts of boilerplate code, but cleaning it would require some major work
//Begin terrible SS13-pun names, credit/blame goes to some ancient /tg/station thread:

//////////////////////////BUILDABORGS///////////////////////////////

var/global/datum/antagonist/agent/buildaborg/buildaborgs
/datum/antagonist/agent/buildaborg/New()
	..()
	buildaborgs = src

/datum/antagonist/agent/buildaborg
	id = "buildaborg"
	role_text = "Buildaborg Group Leader"
	role_text_plural = "Buildaborg Agents"
	faction_role_text = "Buildaborg Agent"
	faction_descriptor = "Buildaborg Group"
	faction_verb = TYPE_PROC_REF(/mob/living, convert_to_conspiracy)

//////////////////////////FREEMESONS//////////////////////////////////

var/global/datum/antagonist/agent/freemesonry/freemesons
/datum/antagonist/agent/freemesonry/New()
	..()
	freemesons = src

/datum/antagonist/agent/freemesonry
	id = "freemesons"
	role_text = "Mesonic Lodge Master"
	role_text_plural = "Freemeson Agents"
	faction_role_text = "Freemeson Agent"
	faction_descriptor = "Freemesons"
	faction_verb = TYPE_PROC_REF(/mob/living, convert_to_conspiracy)

/////////////////////////MEN IN GREY/////////////////////////////////

var/global/datum/antagonist/agent/meningrey/MIGs
/datum/antagonist/agent/meningrey/New()
	..()
	MIGs = src

/datum/antagonist/agent/meningrey
	id = "MIG"
	role_text = "Men in Grey Commander"
	role_text_plural = "Men in Grey Agents"
	faction_role_text = "Men in Grey Agent"
	faction_descriptor = "Men in Grey"
	faction_verb = TYPE_PROC_REF(/mob/living, convert_to_conspiracy)

/////////////////////////ALIUMINATI//////////////////////////////////

var/global/datum/antagonist/agent/aliuminati/aliuminatis
/datum/antagonist/agent/aliuminati/New()
	..()
	buildaborgs = src

/datum/antagonist/agent/aliuminati
	id = "aliuminati"
	role_text = "The Aliuminated One"
	role_text_plural = "Aliuminati Agents"
	faction_role_text = "Aliuminati Agent"
	faction_descriptor = "Aliuminati"
	faction_verb = TYPE_PROC_REF(/mob/living, convert_to_conspiracy)

///////////////////I am terribly, terribly sorry/////////////////////
