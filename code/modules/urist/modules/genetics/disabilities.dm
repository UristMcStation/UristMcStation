//////////////////
// DISABILITIES //
//////////////////

//
// CHANGELOG
//
//
// 2019-08-14	Corrected how the radioactive mutation acted on its surroundings - Irra
//

//genetics disabilities, ported from vg who took them from goon, edited by UMcS

////////////////////////////////////////
// Totally Crippling
////////////////////////////////////////

// WAS: /datum/bioEffect/mute
/datum/dna/gene/disability/mute
	name = "Mute"
	desc = "Completely shuts down the speech center of the subject's brain."
	activation_message   = "You feel unable to express yourself at all."
	deactivation_message = "You feel able to speak freely again."

/datum/dna/gene/disability/mute/New()
	..()
	block=GLOB.MUTEBLOCK

/datum/dna/gene/disability/mute/OnSay(mob/M, message)
	return ""

////////////////////////////////////////
// Harmful to others as well as self
////////////////////////////////////////

/datum/dna/gene/disability/radioactive
	name = "Radioactive"
	desc = "The subject suffers from constant radiation sickness and causes the same on nearby organics."
	activation_message = "You feel a strange sickness permeate your whole body."
	deactivation_message = "You no longer feel awful and sick all over."

/datum/dna/gene/disability/radioactive/New()
	..()
	block=GLOB.RADBLOCK

/datum/dna/gene/disability/radioactive/OnMobLife(mob/owner)
	owner.radiation = max(owner.radiation, 20)
	for(var/atom/L in range(1, owner))
		if(L == owner) continue
		if (istype(L, /mob/living))
			to_chat(L, "<span class='warning'> You are enveloped by a soft green glow emanating from [owner].</span>")
		L.rad_act(5)
	return

/datum/dna/gene/disability/radioactive/OnDrawUnderlays(mob/M,g,fat)
	return "rads[fat]_s"

////////////////////////////////////////
// Other disabilities
////////////////////////////////////////

// WAS: /datum/bioEffect/fat
/datum/dna/gene/disability/fat
	name = "Obesity"
	desc = "Greatly slows the subject's metabolism, enabling greater buildup of lipid tissue."
	activation_message = "You feel blubbery and lethargic!"
	deactivation_message = "You feel fit!"

	mutation = M_OBESITY

/datum/dna/gene/disability/fat/New()
	..()
	block=GLOB.FATBLOCK

/////////////////////////
// SPEECH MANIPULATORS //
/////////////////////////

/* Duplicate
// WAS: /datum/bioEffect/stutter
/datum/dna/gene/disability/stutter
	name = "Stutter"
	desc = "Hinders nerve transmission to and from the speech center of the brain, resulting in faltering speech."
	activation_message = "Y-you f.. feel a.. a bit n-n-nervous."
	deactivation_message = "You don't feel nervous anymore."

	New()
		..()
		block=STUTTERBLOCK

	OnMobLife(var/mob/owner)
		if (prob(10))
			owner:stuttering = max(10, owner:stuttering)

/datum/dna/gene/disability/speech
	can_activate(var/mob/M, var/flags)
		// Can only activate one of these at a time.
		if(is_type_in_list(/datum/dna/gene/disability/speech,M.active_genes))
			return 0
		return ..(M,flags)
*/

/* Figure out what the fuck this one does.
// WAS: /datum/bioEffect/smile
/datum/dna/gene/disability/speech/smile
	name = "Smile"
	desc = "Causes the speech center of the subject's brain to produce large amounts of seratonin when engaged."
	activation_message = "You feel like you want to smile and smile and smile forever :)"
	deactivation_message = "You don't feel like smiling anymore. :("

	New()
		..()
		block=SMILEBLOCK

	OnSay(var/mob/M, var/message)
		return message

// WAS: /datum/bioEffect/elvis
/datum/dna/gene/disability/speech/elvis
	name = "Elvis"
	desc = "Forces the language center of the subject's brain to drawl out sentences in a funky manner."
	activation_message = "You feel funky."
	deactivation_message = "You feel a little less conversation would be great."

	New()
		..()
		block=ELVISBLOCK

	OnSay(var/mob/M, var/message)
		return message
*/

// WAS: /datum/bioEffect/chav
/datum/dna/gene/disability/speech/chav
	name = "Chav"
	desc = "Forces the language center of the subject's brain to construct sentences in a more rudimentary manner."
	activation_message = "Ye feel like a reet prat like, innit?"
	deactivation_message = "You no longer feel like being rude and sassy."

/datum/dna/gene/disability/speech/chav/New()
	..()
	block=GLOB.CHAVBLOCK

/datum/dna/gene/disability/speech/chav/OnSay(mob/M, message)
	// THIS ENTIRE THING BEGS FOR REGEX
	message = replacetext(message,"dick","prat")
	message = replacetext(message,"comdom","knob'ead")
	message = replacetext(message,"looking at","gawpin' at")
	message = replacetext(message,"great","bangin'")
	message = replacetext(message,"man","mate")
	message = replacetext(message,"friend",pick("mate","bruv","bledrin"))
	message = replacetext(message,"what","wot")
	message = replacetext(message,"drink","wet")
	message = replacetext(message,"get","giz")
	message = replacetext(message,"what","wot")
	message = replacetext(message,"no thanks","wuddent fukken do one")
	message = replacetext(message,"i don't know","wot mate")
	message = replacetext(message,"no","naw")
	message = replacetext(message,"robust","chin")
	message = replacetext(message," hi ","how what how")
	message = replacetext(message,"hello","sup bruv")
	message = replacetext(message,"kill","bang")
	message = replacetext(message,"murder","bang")
	message = replacetext(message,"windows","windies")
	message = replacetext(message,"window","windy")
	message = replacetext(message,"break","do")
	message = replacetext(message,"your","yer")
	message = replacetext(message,"security","coppers")
	message = replacetext(message,"stab","cut")
	message = replacetext(message,"excuse me","you wot mate")
	message = replacetext(message,"my mom", "me mam")
	message = replacetext(message,"i swear","swer on me mam")
	message = replacetext(message,"right","reet")
	message = replacetext(message,"isn't it","innit")
	return message

// WAS: /datum/bioEffect/swedish
/datum/dna/gene/disability/speech/swedish
	name = "Swedish"
	desc = "Forces the language center of the subject's brain to construct sentences in a vaguely norse manner."
	activation_message = "You feel Swedish, however that works."
	deactivation_message = "The feeling of Swedishness passes."

/datum/dna/gene/disability/speech/swedish/New()
	..()
	block=GLOB.SWEDEBLOCK

/datum/dna/gene/disability/speech/swedish/OnSay(mob/M, message)
	// svedish
	message = replacetext(message,"w","v")
	if(prob(30))
		message += " Bork[pick("",", bork",", bork, bork")]!"
	return message

// WAS: /datum/bioEffect/unintelligable
/*
/datum/dna/gene/disability/unintelligable
	name = "Unintelligable"
	desc = "Heavily corrupts the part of the brain responsible for forming spoken sentences."
	activation_message = "You can't seem to form any coherent thoughts!"
	deactivation_message = "Your mind feels more clear."

	New()
		..()
		block=SCRAMBLEBLOCK

	OnSay(var/mob/M, var/message)
		var/prefix=copytext(message,1,2)
		if(prefix == ";")
			message = copytext(message,2)
		else if(prefix in list(":","#"))
			prefix += copytext(message,2,3)
			message = copytext(message,3)
		else
			prefix=""

		var/list/words = splittext(message," ")
		var/list/rearranged = list()
		for(var/i=1;i<=length(words);i++)
			var/cword = pick(words)
			words.Remove(cword)
			var/suffix = copytext(cword,length(cword)-1,length(cword))
			while(length(cword)>0 && suffix in list(".",",",";","!",":","?"))
				cword  = copytext(cword,1              ,length(cword)-1)
				suffix = copytext(cword,length(cword)-1,length(cword)  )
			if(length(cword))
				rearranged += cword
		return "[prefix][uppertext(dd_list2text(rearranged," "))]!!"*/

/*// WAS: /datum/bioEffect/toxic_farts
/datum/dna/gene/disability/toxic_farts // NO -- Glloyd
	name = "Toxic Farts"
	desc = "Causes the subject's digestion to create a significant amount of noxious gas."
	activation_message = "Your stomach grumbles unpleasantly."
	deactivation_message = "Your stomach stops acting up. Phew!"

	mutation = M_TOXIC_FARTS

	New()
		..()
		block=TOXICFARTBLOCK*/

//////////////////
// USELESS SHIT //
//////////////////

/*// WAS: /datum/bioEffect/strong
/datum/dna/gene/disability/strong
	// pretty sure this doesn't do jack shit, putting it here until it does //axed by vg
	name = "Strong"
	desc = "Enhances the subject's ability to build and retain heavy muscles."
	activation_message = "You feel buff!"
	deactivation_message = "You feel wimpy and weak."

	mutation = M_STRONG

	New()
		..()
		block=STRONGBLOCK */

// WAS: /datum/bioEffect/horns
/datum/dna/gene/disability/horns // Need to get the icons -- Glloyd //got you -- Scrdest
	name = "Horns"
	desc = "Enables the growth of a compacted keratin formation on the subject's head."
	activation_message = "A pair of horns erupt from your head."
	deactivation_message = "Your horns crumble away into nothing."

/datum/dna/gene/disability/horns/New()
	..()
	block=GLOB.HORNSBLOCK

/datum/dna/gene/disability/horns/OnDrawUnderlays(mob/M,g,fat)
	return "horns_s"

/* Stupid
/datum/bioEffect/stinky
	name = "Apocrine Enhancement"
	desc = "Increases the amount of natural body substances produced from the subject's apocrine glands."
	id = "stinky"
	effectType = effectTypeDisability
	isBad = 1
	msgGain = "You feel sweaty."
	msgLose = "You feel much more hygenic."
	var/personalized_stink = "Wow, it stinks in here!"

	New()
		..()
		src.personalized_stink = stinkString()
		if (prob(5))
			src.variant = 2

	OnLife()
		if (prob(10))
			for(var/mob/living/carbon/C in view(6,get_turf(owner)))
				if (C == owner)
					continue
				if (src.variant == 2)
					to_target(C, "<span class='warning'> [src.personalized_stink]</span>")
				else
					to_target(C, "<span class='warning'> [stinkString()]</span>")
*/


////////////////////////////////////////////////////////////////////////
/*// WAS: /datum/bioEffect/immolate
/datum/dna/gene/basic/grant_spell/immolate // adding once I get mobs on fire in -- Glloyd
	name = "Incendiary Mitochondria"
	desc = "The subject becomes able to convert excess cellular energy into thermal energy."
	activation_messages = list("You suddenly feel rather hot.")
	deactivation_messages = list("You no longer feel uncomfortably hot.")

	spelltype=/obj/effect/proc_holder/spell/targeted/immolate

	New()
		..()
		block = IMMOLATEBLOCK

/obj/effect/proc_holder/spell/targeted/immolate
	name = "Incendiary Mitochondria"
	desc = "The subject becomes able to convert excess cellular energy into thermal energy."
	panel = "Mutant Powers"

	charge_type = "recharge"
	charge_max = 600

	clothes_req = 0
	stat_allowed = 0
	invocation_type = "none"
	range = -1
	selection_type = "range"
	var/list/compatible_mobs = list(/mob/living/carbon/human, /mob/living/carbon/monkey)
	include_user = 1

/obj/effect/proc_holder/spell/targeted/immolate/cast(list/targets)
	var/mob/living/L = usr

	L.adjust_fire_stacks(0.5) // Same as walking into fire. Was 100 (goon fire)
	L.visible_message("<span class='warning'><b>[L.name]</b> suddenly bursts into flames!</span>")
	L.on_fire = 1
	L.update_icon = 1
	playsound(L.loc, 'sound/effects/bamf.ogg', 50, 0)*/

////////////////////////////////////////////////////////////////////////

/*// WAS: /datum/bioEffect/melt
/datum/dna/gene/basic/grant_verb/melt //No skellington in UMcS, and I don't really want to fuck around with mutantraces at the moment.
	name = "Self Biomass Manipulation"
	desc = "The subject becomes able to transform the matter of their cells into a liquid state."
	activation_messages = list("You feel strange and jiggly.")
	deactivation_messages = list("You feel more solid.")

	verbtype=/proc/bioproc_melt

	New()
		..()
		block = MELTBLOCK

/proc/bioproc_melt()
	set name = "Dissolve"
	set desc = "Transform yourself into a liquified state."
	set category = "Mutant Abilities"

	if (istype(usr,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = usr

		H.visible_message("<span class='danger'>[H.name]'s flesh melts right off! Holy shit!</span>")
		//if (H.gender == "female")
		//	playsound(H.loc, 'female_fallscream.ogg', 50, 0)
		//else
		//	playsound(H.loc, 'male_fallscream.ogg', 50, 0)
		//playsound(H.loc, 'bubbles.ogg', 50, 0)
		//playsound(H.loc, 'loudcrunch2.ogg', 50, 0)
		var/mob/living/carbon/human/skellington/nH = new /mob/living/carbon/human/skellington(H.loc)
		nH.real_name = H.real_name
		nH.name = "[H.name]'s skeleton"
		//H.decomp_stage = 4
		nH.brain_op_stage = 4
		H.gib(1)
	else
		usr.visible_message("<span class='danger'>[usr.name] melts into a pile of bloody viscera!</span>")
		usr.gib(1)

	return*/

///////////////////////////////////////////////////////////////////////////////////////////////////

//lithp

/datum/dna/gene/disability/lisp
	name = "Lisp"
	desc = "I wonder wath thith doeth."
	activation_message = "Thomething doethn't feel right."
	deactivation_message = "You now feel able to pronounce consonants."

/datum/dna/gene/disability/lisp/New()
	..()
	block=GLOB.LISPBLOCK

/datum/dna/gene/disability/lisp/OnSay(mob/M, message)
		return replacetext(message,"s","th")
