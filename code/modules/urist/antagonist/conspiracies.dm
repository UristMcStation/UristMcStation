//This file defines the various conspiracies
//Unfortunately large amounts of boilerplate code, but cleaning it would require some major work
//Begin terrible SS13-pun names, credit/blame goes to some ancient /tg/station thread:

//////////////////////////BUILDABORGS///////////////////////////////

var/datum/antagonist/agent/buildaborg/buildaborgs
/datum/antagonist/agent/buildaborg/New()
	..()
	buildaborgs = src

/datum/antagonist/agent/buildaborg
	id = "Buildaborg"
	role_text = "Buildaborg Group Leader"
	role_text_plural = "Buildaborg Agents"
	faction_role_text = "Buildaborg Agent"
	faction_descriptor = "Buildaborg Group"
	faction_verb = /mob/living/proc/convert_to_conspiracy
	faction_welcome = "Help the cause. Do not harm your fellow agents."

/mob/living/proc/convert_to_buildaborg(mob/M as mob in oview(src))
	set name = "Recruit as Agent"
	set category = "Abilities"

	if(!M.mind)
		return

	convert_to_faction(M.mind, buildaborgs)

//////////////////////////FREEMESONS//////////////////////////////////

var/datum/antagonist/agent/freemesonry/freemesons
/datum/antagonist/agent/freemesonry/New()
	..()
	freemesons = src

/datum/antagonist/agent/freemesonry
	id = "Freemesons"
	role_text = "Mesonic Lodge Master"
	role_text_plural = "Freemeson Agents"
	faction_role_text = "Freemeson Agent"
	faction_descriptor = "Freemesons"
	faction_verb = /mob/living/proc/convert_to_conspiracy
	faction_welcome = "Help the cause. Do not harm your fellow agents."

/mob/living/proc/convert_to_freemesons(mob/M as mob in oview(src))
	set name = "Recruit as Agent"
	set category = "Abilities"

	if(!M.mind)
		return

	convert_to_faction(M.mind, freemesons)

/////////////////////////MEN IN GREY/////////////////////////////////

var/datum/antagonist/agent/meningrey/MIGs
/datum/antagonist/agent/meningrey/New()
	..()
	MIGs = src

/datum/antagonist/agent/meningrey
	id = "MIG"
	role_text = "Men in Grey Commander"
	role_text_plural = "Men in Grey Agents"
	faction_role_text = "Men in Grey Agent"
	faction_descriptor = "Men in Grey"
	faction_verb = /mob/living/proc/convert_to_conspiracy
	faction_welcome = "Help the cause. Do not harm your fellow agents."

/mob/living/proc/convert_to_MIGs(mob/M as mob in oview(src))
	set name = "Recruit as Agent"
	set category = "Abilities"

	if(!M.mind)
		return

	convert_to_faction(M.mind, MIGs)

/////////////////////////ALIUMINATI//////////////////////////////////

var/datum/antagonist/agent/aliuminati/aliuminatis
/datum/antagonist/agent/aliuminati/New()
	..()
	buildaborgs = src

/datum/antagonist/agent/aliuminati
	id = "Aliuminati"
	role_text = "The Aliuminated One"
	role_text_plural = "Aliuminati Agents"
	faction_role_text = "Aliuminati Agent"
	faction_descriptor = "Aliuminati"
	faction_verb = /mob/living/proc/convert_to_conspiracy
	faction_welcome = "Help the cause. Do not harm your fellow agents."

/mob/living/proc/convert_to_aliuminati(mob/M as mob in oview(src))
	set name = "Recruit as Agent"
	set category = "Abilities"

	if(!M.mind)
		return

	convert_to_faction(M.mind, aliuminatis)

///////////////////I am terribly, terribly sorry/////////////////////
