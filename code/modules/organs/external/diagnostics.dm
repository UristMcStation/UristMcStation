
/obj/item/organ/external/proc/get_wounds_desc()
	if(BP_IS_ROBOTIC(src))
		var/list/descriptors = list()
		if(brute_dam)
			switch(brute_dam)
				if(0 to 20)
					descriptors += "some dents"
				if(21 to INFINITY)
					descriptors += pick("a lot of dents","severe denting")
		if(burn_dam)
			switch(burn_dam)
				if(0 to 20)
					descriptors += "some burns"
				if(21 to INFINITY)
					descriptors += pick("a lot of burns","severe melting")
		switch(hatch_state)
			if(HATCH_UNSCREWED)
				descriptors += "a closed but unsecured panel"
			if(HATCH_OPENED)
				descriptors += "an open panel"

		return english_list(descriptors)

	var/list/flavor_text = list()
	if((status & ORGAN_CUT_AWAY) && !is_stump() && !(parent && parent.status & ORGAN_CUT_AWAY))
		flavor_text += "a tear at the [amputation_point] so severe that it hangs by a scrap of flesh"

	var/list/wound_descriptors = list()
	for(var/datum/wound/W in wounds)
		var/this_wound_desc = W.desc
		if (W.damage_type == INJURY_TYPE_BURN && W.salved)
			this_wound_desc = "salved [this_wound_desc]"

		if(W.bleeding())
			if(W.wound_damage() > W.bleed_threshold)
				this_wound_desc = "<b>bleeding</b> [this_wound_desc]"
			else
				this_wound_desc = "bleeding [this_wound_desc]"
		else if(W.bandaged)
			this_wound_desc = "bandaged [this_wound_desc]"

		if(W.germ_level > 600)
			this_wound_desc = "badly infected [this_wound_desc]"
		else if(W.germ_level > 330)
			this_wound_desc = "lightly infected [this_wound_desc]"

		if(wound_descriptors[this_wound_desc])
			wound_descriptors[this_wound_desc] += W.amount
		else
			wound_descriptors[this_wound_desc] = W.amount

	if(how_open() >= SURGERY_RETRACTED)
		var/bone = encased ? encased : "bone"
		if(status & ORGAN_BROKEN)
			bone = "broken [bone]"
		wound_descriptors["a [bone] exposed"] = 1

		if(!encased || how_open() >= SURGERY_ENCASED)
			var/list/bits = list()
			for(var/obj/item/organ/internal/organ in internal_organs)
				bits += organ.get_visible_state()
			for(var/obj/item/implant in implants)
				bits += implant.name
			if(length(bits))
				wound_descriptors["[english_list(bits)] visible in the wounds"] = 1

	for(var/wound in wound_descriptors)
		switch(wound_descriptors[wound])
			if(1)
				flavor_text += "a [wound]"
			if(2)
				flavor_text += "a pair of [wound]s"
			if(3 to 5)
				flavor_text += "several [wound]s"
			if(6 to INFINITY)
				flavor_text += "a ton of [wound]\s"

	return english_list(flavor_text)

/obj/item/organ/external/get_scan_results(tag = FALSE)
	. = ..()
	if(status & ORGAN_ARTERY_CUT)
		. += tag ? "<span style='font-weight: bold; color: [COLOR_MEDICAL_INTERNAL_DANGER]'>[capitalize(artery_name)] ruptured</span>" : "[capitalize(artery_name)] ruptured"
	if(status & ORGAN_TENDON_CUT)
		. += tag ? "<span style='font-weight: bold; color: [COLOR_MEDICAL_INTERNAL]'>Severed [tendon_name]</span>" : "Severed [tendon_name]"
	if(dislocated >= 1) // non-magical constants when
		. += tag ? "<span style='font-weight: bold; color: [COLOR_MEDICAL_DISLOCATED]'>Dislocated</span>" : "Dislocated"
	if(splinted)
		. += tag ? "<span style='font-weight: bold; color: [COLOR_MEDICAL_SPLINTED]'>Splinted</span>" : "Splinted"
	if(status & ORGAN_BLEEDING)
		. += tag ? "<span style='font-weight: bold; color: [COLOR_MEDICAL_BRUTE]'>Bleeding</span>" : "Bleeding"
	if(status & ORGAN_BROKEN)
		. += tag ? "<span style='font-weight: bold; color: [COLOR_MEDICAL_BROKEN]'>[capitalize(broken_description)]</span>" : capitalize(broken_description)
	if (implants && length(implants))
		var/unknown_body = 0
		for(var/I in implants)
			var/obj/item/implant/imp = I
			if(istype(I,/obj/item/implant))
				if(imp.hidden)
					continue
				if (imp.known)
					. += tag ? "<span style='font-weight: bold; color: [COLOR_MEDICAL_IMPLANT]'>[capitalize(imp.name)] implanted</span>" : "[capitalize(imp.name)] implanted"
					continue
			unknown_body++
		if(unknown_body)
			. += tag ? "<span style='font-weight: bold; color: [COLOR_MEDICAL_UNKNOWN_IMPLANT]'>Unknown body present</span>" : "Unknown body present"
	for (var/obj/item/organ/internal/augment/aug in internal_organs)
		if (aug.augment_flags & AUGMENT_SCANNABLE)
			. += tag ? "<span style='font-weight: bold; color: [COLOR_MEDICAL_IMPLANT]'>[capitalize(aug.name)] implanted</span>" : "[capitalize(aug.name)] implanted"

/obj/item/organ/external/proc/inspect(mob/user)
	if(is_stump())
		to_chat(user, SPAN_NOTICE("[owner] is missing that bodypart."))
		return

	user.visible_message(SPAN_NOTICE("[user] starts inspecting [owner]'s [name] carefully."))
	if(LAZYLEN(wounds))
		to_chat(user, SPAN_WARNING("You find [get_wounds_desc()]"))
		var/list/stuff = list()
		for(var/datum/wound/wound in wounds)
			if(LAZYLEN(wound.embedded_objects))
				stuff |= wound.embedded_objects
		if(length(stuff))
			to_chat(user, SPAN_WARNING("There's [english_list(stuff)] sticking out of [owner]'s [name]."))
	else
		to_chat(user, SPAN_NOTICE("You find no visible wounds."))

	to_chat(user, SPAN_NOTICE("Checking skin now..."))
	if(!do_after(user, 1 SECOND, owner, DO_DEFAULT | DO_USER_UNIQUE_ACT | DO_PUBLIC_PROGRESS))
		return

	var/list/badness = list()
	var/list/symptoms = GET_SINGLETON_SUBTYPE_MAP(/singleton/diagnostic_sign)
	for(var/S in symptoms)
		var/singleton/diagnostic_sign/sign = symptoms[S]
		if(sign.manifested_in(src))
			badness += sign.get_description(user)
	if(!length(badness))
		to_chat(user, SPAN_NOTICE("[owner]'s skin is normal."))
	else
		to_chat(user, SPAN_WARNING("[owner]'s skin is [english_list(badness)]."))

	to_chat(user, SPAN_NOTICE("Checking bones now..."))
	if(!do_after(user, 1 SECOND, owner, DO_DEFAULT | DO_USER_UNIQUE_ACT | DO_PUBLIC_PROGRESS))
		return

	if(status & ORGAN_BROKEN)
		to_chat(user, SPAN_WARNING("The [encased ? encased : "bone in the [name]"] moves slightly when you poke it!"))
		owner.custom_pain("Your [name] hurts where it's poked.",40, affecting = src)
	else
		to_chat(user, SPAN_NOTICE("The [encased ? encased : "bones in the [name]"] seem to be fine."))

	for (var/obj/item/organ/internal/augment/A in internal_organs) // Locate any non-concealed augments
		if (A.augment_flags & AUGMENT_INSPECTABLE)
			to_chat(user, SPAN_WARNING("You feel a foreign object inside of \the [owner]'s [name]!"))
			owner.custom_pain("Your [name] hurts as your [A.name] is jostled inside it.", 20, affecting = src)
			break
	if(status & ORGAN_TENDON_CUT)
		to_chat(user, SPAN_WARNING("The tendons in [name] are severed!"))
	if(dislocated >= 1)
		to_chat(user, SPAN_WARNING("The [joint] is dislocated!"))
	return 1

/obj/item/organ/external/listen()
	var/list/sounds = list()
	for(var/obj/item/organ/internal/I in internal_organs)
		var/gutsound = I.listen()
		if(gutsound)
			sounds += gutsound
	if(!length(sounds))
		if(owner.pulse())
			sounds += "faint pulse"
	if(status & ORGAN_ARTERY_CUT)
		sounds += "rushing liquid"
	return sounds

/singleton/diagnostic_sign
	var/name = "Some symptom"
	var/descriptor
	var/explanation

//Checks conditions for this sign to appear
/singleton/diagnostic_sign/proc/manifested_in(obj/item/organ/external/victim)

/singleton/diagnostic_sign/proc/get_description(mob/user)
	. = descriptor
	. += "<small><a href='byond://?src=\ref[src];show_diagnostic_hint=1'>(?)</a></small>"
	return

/singleton/diagnostic_sign/Topic(href, list/href_list)
	. = ..()
	if(.)
		return
	if(href_list["show_diagnostic_hint"])
		to_chat(usr, SPAN_NOTICE("[name] - [explanation]"))
		return TOPIC_HANDLED

/singleton/diagnostic_sign/shock
	name = "Clammy skin"
	descriptor = "clammy and cool to the touch"
	explanation = "Patient is in shock from severe pain."

/singleton/diagnostic_sign/shock/manifested_in(obj/item/organ/external/victim)
	return victim.owner && victim.owner.shock_stage >= 30

/singleton/diagnostic_sign/liver
	name = "Jaundice"
	descriptor = "jaundiced"
	explanation = "Patient has internal organ damage."

/singleton/diagnostic_sign/liver/manifested_in(obj/item/organ/external/victim)
	return victim.owner && victim.owner.getToxLoss() >= 25

/singleton/diagnostic_sign/oxygenation
	name = "Cyanosis"
	descriptor = "turning blue"
	explanation = "Patient has low blood oxygenation."

/singleton/diagnostic_sign/oxygenation/manifested_in(obj/item/organ/external/victim)
	return victim.owner && victim.owner.get_blood_oxygenation() <= 50

/singleton/diagnostic_sign/circulation
	name = "Paleness"
	descriptor = "very pale"
	explanation = "Patient has issues with blood circulaion or volume."

/singleton/diagnostic_sign/circulation/manifested_in(obj/item/organ/external/victim)
	return victim.owner && victim.owner.get_blood_circulation() <= 60

/singleton/diagnostic_sign/gangrene
	name = "Rot"
	descriptor = "rotting"
	explanation = "Patient has lost this bodypart to an irreversible bacterial infection."

/singleton/diagnostic_sign/gangrene/manifested_in(obj/item/organ/external/victim)
	return victim.status & ORGAN_DEAD
