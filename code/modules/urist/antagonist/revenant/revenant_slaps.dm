/*
// -*-  SLAPS  -*-
//
// This is a slightly tongue-in cheek name for a system designed to penalize ignoring Distortion.
//
// If a BSR player abuses their powers too much or does not care about Distortion effects, they
// will be faced with a straight-up negative and generally Unfun effect either targetting them
// SPECIFICALLY (as opposed to Distortions, which are just negative for everyone around), or
// a straight up round-ender - hence, we give them a Slap for not being an involved antag.
//
// The effect type is deliberately obfuscated from the BSR player to maintain the core focus of being a penalty;
// otherwise, some players might *deliberately* go for these, which is against the intended gameplay experience.
//
// Unlike normal Distortion Effects, which are triggered based on local 'pollution', Slaps are based off of
// the amount of *unsuppressed* Distortion - players can keep going even with insanely high Total Distortion
// for hours, but they MUST keep up with their Hungers to do so.
*/


/datum/power/revenant/bs_slap
	// How much total Distortion we need to unlock this
	var/distortion_threshold = 1000000
	var/warning_message = "You are feeling severely unstable! You'd better satisfy your Hunger fast!"
	var/slap_message = "You have neglected your Hunger for too long. Time to pay the price..."


/datum/power/revenant/bs_slap/proc/Slap(var/mob/M)
	return


var/list/revenant_slaps = (typesof(/datum/power/revenant/bs_slap) - /datum/power/revenant/bs_slap)


/datum/bluespace_revenant/proc/get_slaps_by_tag() // -> assoc list<flavor : power type>
	// Indexes available BsRevenant powers by flavor tag, for procgenning a selection.

	var/list/tagged_list = list()

	if(isnull(GLOB.revenant_powerinstances))
		src.initialize_powerinstances()

	for(var/P in revenant_slaps)
		var/datum/power/revenant/bs_slap/instanceP = GLOB.revenant_powerinstances[P]

		for(var/flavor_tag in instanceP.flavor_tags)
			var/list/existing_list = tagged_list[flavor_tag]

			if(isnull(existing_list))
				existing_list = list()

			existing_list += instanceP
			tagged_list[flavor_tag] = existing_list

	return tagged_list


/datum/bluespace_revenant/proc/select_slaps(var/list/flavors_override = null)
	var/helper_result = src.select_bsrevenant_attributes(flavors_override, /datum/bluespace_revenant/proc/get_slaps_by_tag, 3, "Slap")
	return helper_result


/datum/bluespace_revenant/proc/HandleApplySlaps()
	var/mob/M = null

	if(istype(src.mob_ref))
		M = src.mob_ref.resolve()

	if(!istype(M))
		return

	var/effective_distortion = (src.get_effective_distortion() || 0)

	var/list/applicable_slaps = list()

	for(var/datum/power/revenant/bs_slap/cand_slap in src.slaps)
		if(cand_slap.distortion_threshold && effective_distortion > cand_slap.distortion_threshold)
			applicable_slaps.Add(cand_slap)

	if(!(applicable_slaps.len))
		return

	var/datum/power/revenant/bs_slap/slap = pick(applicable_slaps)

	if(prob(99))
		to_chat(M, SPAN_WARNING(slap.warning_message))
		return FALSE

	to_chat(M, SPAN_DANGER(slap.slap_message))

	. = slap.Slap(M)
	return


/* Gibs the BSR mob. */
/datum/power/revenant/bs_slap/gib
	name = "Gibs"
	flavor_tags = list(
		BSR_FLAVOR_CHIMERA,
		BSR_FLAVOR_VAMPIRE,
		BSR_FLAVOR_DEMONIC,
		BSR_FLAVOR_BLUESPACE,
		BSR_FLAVOR_DENTIST,
		BSR_FLAVOR_FLESH,
		BSR_FLAVOR_GENERIC
	)
	warning_message = "You can feel your organs twitching and pulsing erratically! You'd better satisfy your Hunger fast!"
	slap_message = "You have neglected your Hunger for too long! You feel your tendons snapping and your muscles tearing away from the bone as your organs violently burst..."


/datum/power/revenant/bs_slap/gib/Slap(var/mob/M)
	if(!istype(M))
		return FALSE

	M.gib()
	return TRUE


/* Explodes the BSR mob. */
/datum/power/revenant/bs_slap/boom
	name = "Boom!"
	flavor_tags = list(
		BSR_FLAVOR_BLUESPACE,
		BSR_FLAVOR_DENTIST,
		BSR_FLAVOR_SPACE,
		BSR_FLAVOR_CHAOTIC,
		BSR_FLAVOR_SCIFI
	)
	warning_message = "You feel a quiet but intensifying buzz as your body begins to heat up and vibrate! You'd better satisfy your Hunger fast!"
	slap_message = "You have neglected your Hunger for too long! You feel every molecule in your body vibrate faster and faster, achieving impossible speeds as you try to keep yourself together..."


/datum/power/revenant/bs_slap/boom/Slap(var/mob/M)
	if(!istype(M))
		return FALSE

	var/turf/T = get_turf(M)
	if(!istype(T))
		return FALSE

	M.gib()
	explosion(T, 2, 4, 8, 4)
	return TRUE


/* Slowly fade out of existence */
/datum/power/revenant/bs_slap/fadeout
	name = "Fadeout"
	flavor_tags = list(
		BSR_FLAVOR_CHAOTIC,
		BSR_FLAVOR_SCIFI,
		BSR_FLAVOR_DARK,
		BSR_FLAVOR_DEATH,
		BSR_FLAVOR_GENERIC
	)
	warning_message = "You notice your hands becoming slightly transparent as you lose your connection to reality! You'd better satisfy your Hunger fast!"
	slap_message = "You have neglected your Hunger for too long! You no longer have the strength to fight against reality itself - you let go and start slowly drifting away from existence..."


/datum/power/revenant/bs_slap/fadeout/Slap(var/mob/M)
	if(!istype(M))
		return FALSE

	var/const/fadetime = 600 // 1 min

	M.remove_bsrevenant_powers()

	var/datum/bluespace_revenant/bsr = M?.mind?.bluespace_revenant
	if(istype(bsr))
		bsr.stop_ticker()
		M.mind.bluespace_revenant = null

	M.visible_message(SPAN_WARNING("\The [src] starts to fade out of existence!."))

	animate(M, alpha=0, time=fadetime)

	spawn(fadetime)
		qdel(M)

	return TRUE


/* Summons Nar'Sie */
/datum/power/revenant/bs_slap/raisehell
	name = "Nar'Sie"
	flavor_tags = list(
		BSR_FLAVOR_CULTIST,
		BSR_FLAVOR_VAMPIRE,
		BSR_FLAVOR_DEMONIC,
		BSR_FLAVOR_OCCULT,
		BSR_FLAVOR_DARK,
		BSR_FLAVOR_BLOOD
	)
	warning_message = "Your Distortion has caught the attention of dark forces from beyond... You'd better satisfy your Hunger fast!"
	slap_message = "You have neglected your Hunger for too long! Dark tendrils and limbs pierce out of your body as an unearthly presence uses you as a gateway into this universe!"


/datum/power/revenant/bs_slap/raisehell/Slap(var/mob/M)
	if(!istype(M))
		return FALSE

	var/turf/T = get_turf(M)
	if(!istype(T))
		return FALSE

	M.Stun(100)
	M.Weaken(100)

	log_and_message_admins("[M] has summoned Nar'Sie due to neglecting his Bluespace Revenant Distortion!")
	var/obj/singularity/narsie/large/narnar = new(T)

	if(!istype(narnar))
		return FALSE

	return TRUE


