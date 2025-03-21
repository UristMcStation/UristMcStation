var/global/list/sparring_attack_cache = list()

//Species unarmed attacks
/datum/unarmed_attack
	var/attack_verb = list("attack")	// Empty hand hurt intent verb.
	var/attack_noun = list("fist")
	var/damage = 0						// Extra empty hand attack damage.
	var/attack_sound = "punch"
	var/miss_sound = 'sound/weapons/punchmiss.ogg'
	var/shredding = FALSE // Calls the old attack_alien() behavior on objects/mobs when on harm intent.
	var/sharp = FALSE
	var/edge = FALSE
	var/delay = 0

	var/deal_halloss
	var/sparring_variant_type = /datum/unarmed_attack/light_strike

	var/eye_attack_text
	var/eye_attack_text_victim

	var/attack_name = "fist"
	var/should_attack_log = TRUE

/datum/unarmed_attack/proc/get_damage_type()
	if(deal_halloss)
		return DAMAGE_PAIN
	return DAMAGE_BRUTE

/datum/unarmed_attack/proc/get_sparring_variant()
	if(sparring_variant_type)
		if(!sparring_attack_cache[sparring_variant_type])
			sparring_attack_cache[sparring_variant_type] = new sparring_variant_type()
		return sparring_attack_cache[sparring_variant_type]

/datum/unarmed_attack/proc/is_usable(mob/living/carbon/human/user, mob/target, zone)
	if(user.restrained())
		return FALSE

	// Check if they have a functioning hand.
	var/obj/item/organ/external/E = user.organs_by_name[BP_L_HAND]
	if(E && !E.is_stump())
		return TRUE

	E = user.organs_by_name[BP_R_HAND]
	if(E && !E.is_stump())
		return TRUE

	return FALSE

/datum/unarmed_attack/proc/get_unarmed_damage()
	return damage

/datum/unarmed_attack/proc/apply_effects(mob/living/carbon/human/user,mob/living/carbon/human/target,attack_damage,zone)

	if(target.stat == DEAD)
		return

	var/stun_chance = rand(0, 100)
	var/armour = target.get_blocked_ratio(zone, DAMAGE_BRUTE, damage = attack_damage)

	if(attack_damage >= 5 && armour < 1 && !(target == user) && stun_chance <= attack_damage * 5) // 25% standard chance
		switch(zone) // strong punches can have effects depending on where they hit
			if(BP_HEAD, BP_EYES, BP_MOUTH)
				// Induce blurriness
				target.visible_message(SPAN_DANGER("[target] looks momentarily disoriented."), SPAN_DANGER("You see stars."))
				target.apply_effect(attack_damage * 2, EFFECT_EYE_BLUR, armour)
			if(BP_L_ARM, BP_L_HAND)
				if (target.l_hand)
					// Disarm left hand
					//Urist McAssistant dropped the macguffin with a scream just sounds odd.
					if(target.drop_l_hand())
						target.visible_message(SPAN_DANGER("\The [target.l_hand] was knocked right out of \the [target]'s grasp!"))
			if(BP_R_ARM, BP_R_HAND)
				if (target.r_hand)
					// Disarm right hand
					if(target.drop_r_hand())
						target.visible_message(SPAN_DANGER("\The [target.r_hand] was knocked right out of \the [target]'s grasp!"))
			if(BP_CHEST)
				if(!target.lying)
					var/turf/T = get_step(get_turf(target), get_dir(get_turf(user), get_turf(target)))
					if(!T.density)
						step(target, get_dir(get_turf(user), get_turf(target)))
						target.visible_message(SPAN_CLASS("danger", "[pick("[target] was sent flying backward!", "[target] staggers back from the impact!")]"))
					if(prob(50))
						target.set_dir(GLOB.reverse_dir[target.dir])
					target.apply_effect(attack_damage * 0.4, EFFECT_WEAKEN, armour)
			if(BP_GROIN)
				target.visible_message(
					SPAN_WARNING("[target] looks like \he is in pain!"),
					SPAN_WARNING("[(target.gender=="female") ? "Oh god that hurt!" : "Oh no, not your[pick("testicles", "crown jewels", "clockweights", "family jewels", "marbles", "bean bags", "teabags", "sweetmeats", "goolies")]!"]")
				)
				target.apply_effects(stutter = attack_damage * 2, agony = attack_damage* 3, blocked = armour)
			if(BP_L_LEG, BP_L_FOOT, BP_R_LEG, BP_R_FOOT)
				if(!target.lying)
					target.visible_message(SPAN_WARNING("[target] gives way slightly."))
					target.apply_effect(attack_damage * 3, EFFECT_PAIN, armour)
	else if(attack_damage >= 5 && !(target == user) && (stun_chance + attack_damage * 5 >= 100) && armour < 1) // Chance to get the usual throwdown as well (25% standard chance)
		if(!target.lying)
			target.visible_message(SPAN_CLASS("danger", "[target] [pick("slumps", "falls", "drops")] down to the ground!"))
		else
			target.visible_message(SPAN_DANGER("[target] has been weakened!"))
		target.apply_effect(3, EFFECT_WEAKEN, armour * 100)

	var/obj/item/clothing/C = target.get_covering_equipped_item_by_zone(zone)
	if(istype(C) && prob(10))
		C.leave_evidence(user)

/datum/unarmed_attack/proc/show_attack(mob/living/carbon/human/user, mob/living/carbon/human/target, zone, attack_damage)
	var/obj/item/organ/external/affecting = target.get_organ(zone)
	user.visible_message(SPAN_WARNING("[user] [pick(attack_verb)] [target] in the [affecting.name]!"))
	playsound(user.loc, attack_sound, 25, 1, -1)

/datum/unarmed_attack/proc/handle_eye_attack(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/obj/item/organ/internal/eyes/eyes = target.internal_organs_by_name[BP_EYES]
	if(eyes)
		eyes.take_internal_damage(rand(3,4), 1)
		user.visible_message(SPAN_DANGER("[user] presses \his [eye_attack_text] into [target]'s [eyes.name]!"))
		var/eye_pain = eyes.can_feel_pain()
		to_chat(target, SPAN_CLASS("danger", "You experience[(eye_pain) ? "" : " immense pain as you feel" ] [eye_attack_text_victim] being pressed into your [eyes.name][(eye_pain)? "." : "!"]"))
		return
	user.visible_message(SPAN_DANGER("[user] attempts to press \his [eye_attack_text] into [target]'s eyes, but they don't have any!"))

/datum/unarmed_attack/proc/damage_flags()
	return (src.sharp? DAMAGE_FLAG_SHARP : 0)|(src.edge? DAMAGE_FLAG_EDGE : 0)

/datum/unarmed_attack/bite
	attack_verb = list("bit")
	attack_sound = 'sound/weapons/bite.ogg'
	damage = 0
	attack_name = "bite"

/datum/unarmed_attack/bite/sharp
	attack_verb = list("bit", "chomped")
	sharp = TRUE
	edge = TRUE

/datum/unarmed_attack/bite/is_usable(mob/living/carbon/human/user, mob/living/carbon/human/target, zone)

	if(istype(user.wear_mask, /obj/item/clothing/mask))
		return FALSE
	for(var/obj/item/clothing/C in list(user.wear_mask, user.head, user.wear_suit))
		if(C && (C.body_parts_covered & FACE) && (C.item_flags & ITEM_FLAG_THICKMATERIAL))
			return FALSE //prevent biting through a space helmet or similar
	if (user == target && (zone == BP_HEAD || zone == BP_EYES || zone == BP_MOUTH))
		return FALSE //how do you bite yourself in the head?
	return TRUE

/datum/unarmed_attack/punch
	attack_verb = list("punched")
	attack_noun = list("fist")
	eye_attack_text = "fingers"
	eye_attack_text_victim = "digits"
	damage = 0
	attack_name = "punch"

/datum/unarmed_attack/punch/show_attack(mob/living/carbon/human/user, mob/living/carbon/human/target, zone, attack_damage)
	var/obj/item/organ/external/affecting = target.get_organ(zone)
	var/organ = affecting.name

	attack_damage = clamp(attack_damage, 1, 5) // We expect damage input of 1 to 5 for this proc. But we leave this check juuust in case.

	if(target == user)
		user.visible_message(SPAN_DANGER("[user] [pick(attack_verb)] \himself in the [organ]!"))
		return FALSE

	target.update_personal_goal(/datum/goal/achievement/fistfight, TRUE)
	user.update_personal_goal(/datum/goal/achievement/fistfight, TRUE)

	if(!target.lying)
		switch(zone)
			if(BP_HEAD, BP_MOUTH, BP_EYES)
				// ----- HEAD ----- //
				switch(attack_damage)
					if(1 to 2)
						user.visible_message(SPAN_DANGER("[user] slapped [target] across \his cheek!"))
					if(3 to 4)
						user.visible_message(pick(
							80; SPAN_DANGER("[user] [pick(attack_verb)] [target] in the head!"),
							20; SPAN_CLASS("danger", "[user] struck [target] in the head[pick("", " with a closed fist")]!"),
							50; SPAN_DANGER("[user] threw a hook against [target]'s head!")
							))
					if(5)
						user.visible_message(pick(
							10; SPAN_DANGER("[user] gave [target] a solid slap across \his face!"),
							90; SPAN_CLASS("danger", "[user] smashed \his [pick(attack_noun)] into [target]'s [pick("[organ]", "face", "jaw")]!")
							))
			else
				// ----- BODY ----- //
				switch(attack_damage)
					if(1 to 2)	user.visible_message(SPAN_DANGER("[user] threw a glancing punch at [target]'s [organ]!"))
					if(1 to 4)	user.visible_message(SPAN_DANGER("[user] [pick(attack_verb)] [target] in \his [organ]!"))
					if(5)		user.visible_message(SPAN_DANGER("[user] smashed \his [pick(attack_noun)] into [target]'s [organ]!"))
	else
		user.visible_message(SPAN_CLASS("danger", "[user] [pick("punched", "threw a punch at", "struck", "slammed their [pick(attack_noun)] into")] [target]'s [organ]!")) //why do we have a separate set of verbs for lying targets?

/datum/unarmed_attack/kick
	attack_verb = list("kicked", "kicked", "kicked", "kneed")
	attack_noun = list("kick", "kick", "kick", "knee strike")
	attack_sound = "swing_hit"
	damage = 0
	attack_name = "kick"

/datum/unarmed_attack/kick/is_usable(mob/living/carbon/human/user, mob/living/carbon/human/target, zone)
	if(!(zone in list(BP_L_LEG, BP_R_LEG, BP_L_FOOT, BP_R_FOOT, BP_GROIN)))
		return FALSE

	var/obj/item/organ/external/E = user.organs_by_name[BP_L_FOOT]
	if(E && !E.is_stump())
		return TRUE

	E = user.organs_by_name[BP_R_FOOT]
	if(E && !E.is_stump())
		return TRUE

	return TRUE

/datum/unarmed_attack/kick/get_unarmed_damage(mob/living/carbon/human/user)
	var/obj/item/clothing/shoes = user.shoes
	if(!istype(shoes))
		return damage
	return damage + (shoes ? shoes.force : 0)

/datum/unarmed_attack/kick/show_attack(mob/living/carbon/human/user, mob/living/carbon/human/target, zone, attack_damage)
	var/obj/item/organ/external/affecting = target.get_organ(zone)
	var/organ = affecting.name

	attack_damage = clamp(attack_damage, 1, 5)

	switch(attack_damage)
		if(1 to 2)	user.visible_message(SPAN_DANGER("[user] threw [target] a glancing [pick(attack_noun)] to the [organ]!")) //it's not that they're kicking lightly, it's that the kick didn't quite connect
		if(3 to 4)	user.visible_message(SPAN_DANGER("[user] [pick(attack_verb)] [target] in \his [organ]!"))
		if(5)		user.visible_message(SPAN_DANGER("[user] landed a strong [pick(attack_noun)] against [target]'s [organ]!"))

/datum/unarmed_attack/stomp
	attack_verb = list("stomped on")
	attack_noun = list("stomp")
	attack_sound = "swing_hit"
	damage = 0
	attack_name = "stomp"

/datum/unarmed_attack/stomp/is_usable(mob/living/carbon/human/user, mob/living/carbon/human/target, zone)
	if(!istype(target))
		return FALSE

	if (!user.lying && (target.lying || (zone in list(BP_L_FOOT, BP_R_FOOT))))
		if(target.grabbed_by == user && target.lying)
			return FALSE
		var/obj/item/organ/external/E = user.organs_by_name[BP_L_FOOT]
		if(E && !E.is_stump())
			return TRUE

		E = user.organs_by_name[BP_R_FOOT]
		if(E && !E.is_stump())
			return TRUE

		return FALSE

/datum/unarmed_attack/stomp/get_unarmed_damage(mob/living/carbon/human/user)
	var/obj/item/clothing/shoes = user.shoes
	return damage + (shoes ? shoes.force : 0)

/datum/unarmed_attack/stomp/show_attack(mob/living/carbon/human/user, mob/living/carbon/human/target, zone, attack_damage)
	var/obj/item/organ/external/affecting = target.get_organ(zone)
	var/organ = affecting.name
	var/obj/item/clothing/shoes = user.shoes

	attack_damage = clamp(attack_damage, 1, 5)

	var/shoe_text = shoes ? copytext(shoes.name, 1, -1) : "foot"
	switch(attack_damage)
		if(1 to 4)
			user.visible_message(pick(
				SPAN_CLASS("danger", "[user] stomped on [target]'s [organ][pick("", " with their [shoe_text]")]!"),
				SPAN_DANGER("[user] stomped \his [shoe_text] down onto [target]'s [organ]!")))
		if(5)
			user.visible_message(pick(
				SPAN_CLASS("danger", "[user] stomped down hard onto [target]'s [organ][pick("", " with their [shoe_text]")]!"),
				SPAN_DANGER("[user] slammed \his [shoe_text] down onto [target]'s [organ]!")))

/datum/unarmed_attack/light_strike
	deal_halloss = 3
	attack_noun = list("tap","light strike")
	attack_verb = list("tapped", "lightly struck")
	damage = 0
	sharp = TRUE
	edge = TRUE
	attack_name = "light hit"
	should_attack_log = FALSE
