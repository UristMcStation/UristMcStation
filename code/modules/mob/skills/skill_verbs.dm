//Skill-related mob verbs that require skill checks to be satisfied to be added.

GLOBAL_LIST_AS(skill_verbs, init_subtypes(/datum/skill_verb))

/datum/skillset/proc/fetch_verb_datum(given_type)
	for(var/datum/skill_verb/SV in skill_verbs)
		if(SV.type == given_type)
			return SV

/datum/skillset/proc/update_verbs()
	for(var/datum/skill_verb/SV in skill_verbs)
		SV.update_verb()

/datum/skill_verb
	var/datum/skillset/skillset   //Owner, if any.
	var/the_verb                  //The verb to keep track of. Should be a mob verb.
	var/cooldown                  //How long the verb cools down for after use. null = has no cooldown.
	var/cooling_down = 0          //Whether it's currently cooling down.

/datum/skill_verb/Destroy()
	skillset = null
	. = ..()

//Not whether it can be accessed/used; just whether the mob skillset should have this datum and check it when updating skill verbs.
/datum/skill_verb/proc/should_have_verb(datum/skillset/given_skillset)
	return 1

/datum/skill_verb/proc/give_to_skillset(datum/skillset/given_skillset)
	var/datum/skill_verb/new_verb = new type
	new_verb.skillset = given_skillset
	LAZYADD(given_skillset.skill_verbs, new_verb)

//Updates whether or not the mob has access to this verb.
/datum/skill_verb/proc/update_verb()
	if(!skillset || !skillset.owner)
		return
	. = should_see_verb()
	. ? (skillset.owner.verbs |= the_verb) : (skillset.owner.verbs -= the_verb)

/datum/skill_verb/proc/should_see_verb()
	if(cooling_down)
		return
	return 1

/datum/skill_verb/proc/remove_cooldown()
	cooling_down = 0
	update_verb()

/datum/skill_verb/proc/set_cooldown()
	if(!cooldown)
		return
	cooling_down = 1
	update_verb()
	addtimer(new Callback(src, PROC_REF(remove_cooldown)), cooldown)

/datum/skill_buff/motivate/can_buff(mob/target)
	if(!..())
		return
	if(!ishuman(target))
		return
	return 1
/*
The Appraise verb. Used on objects to estimate their value.
*/
/datum/skill_verb/appraise
	the_verb = /mob/proc/appraise

/datum/skill_verb/appraise/should_have_verb(datum/skillset/given_skillset)
	if(!..())
		return
	if(!isliving(given_skillset.owner))
		return
	return 1

/datum/skill_verb/appraise/should_see_verb()
	if(!..())
		return
	return 1

/mob/proc/appraise(obj/item as obj in get_equipped_items(1))
	set category = "IC"
	set name = "Appraise"
	set src = usr
	set popup_menu = 0

	if(incapacitated() || !istype(item))
		return
	var/value = get_value(item)
	var/message
	if(!value)
		message = "\The [item] seems worthless."
	else
		var/multiple = round(log(10, value))
		if(multiple < 0)
			message = "\The [item] seems worthless."
		else
			var/level = 5
			level *= 10 ** (max(multiple - 1, 0))
			var/low = level * round(value/level)  //low and high bracket the value between multiples of level
			var/high = low + level
			if(!low && multiple >= 2)
				low = 10 ** (multiple - 1) //Adjusts the lowball estimate away from 0 if the item has a high upper estimate.
			message = "You appraise the item to be worth between [low] and [high] [GLOB.using_map.local_currency_name]."
	to_chat(src, message)

/datum/skill_verb/noirvision
	the_verb = /mob/proc/noirvision

/datum/skill_verb/noirvision/should_have_verb(datum/skillset/given_skillset)
	if(!..())
		return
	if(!isliving(given_skillset.owner))
		return
	return 1

/datum/skill_verb/noirvision/should_see_verb()
	if(!..())
		return
	if(!skillset.owner.skill_check(SKILL_FORENSICS, SKILL_MASTER))
		return
	return 1

/mob/proc/noirvision()
	set category = "IC"
	set name = "Detective instinct"
	set src = usr
	set popup_menu = FALSE
	if (incapacitated())
		return
	if (has_client_color(/datum/client_color/noir))
		remove_client_color(/datum/client_color/noir)
		to_chat(src, "You stop looking for clues.")
	else
		add_client_color(/datum/client_color/noir)
		to_chat(src, "You clear your mind and focus on the scene before you.")
