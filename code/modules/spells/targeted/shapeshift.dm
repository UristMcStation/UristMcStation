//basic transformation spell. Should work for most simple_animals

/spell/targeted/shapeshift
	name = "Shapeshift"
	desc = "This spell transforms the target into something else for a short while."

	school = "transmutation"

	charge_type = Sp_RECHARGE
	charge_max = 600

	duration = 0 //set to 0 for permanent.

	var/list/possible_transformations = list()
	var/list/newVars = list() //what the variables of the new created thing will be.

	cast_sound = 'sound/magic/charge.ogg'
	var/revert_sound = 'sound/magic/charge.ogg' //the sound that plays when something gets turned back.
	var/share_damage = 1 //do we want the damage we take from our new form to move onto our real one? (Only counts for finite duration)
	var/drop_items = 1 //do we want to drop all our items when we transform?
	var/toggle = TRUE //Can we toggle this?
	var/list/transformed_dudes = list() //Who we transformed. Transformed = Transformation. Both mobs.

/spell/targeted/shapeshift/cast(list/targets, mob/user)
	for(var/m in targets)
		var/mob/living/M = m
		if(M.stat == DEAD)
			to_chat(user, "[name] can only transform living targets.")
			continue
		if(M.buckled)
			M.buckled.unbuckle_mob()
		if(toggle && length(transformed_dudes) && stop_transformation(M))
			continue
		else if(!toggle && (M in transformed_dudes))
			continue // double polymorph will cause bugs
		var/new_mob = pick(possible_transformations)

		var/mob/living/trans = new new_mob(get_turf(M))
		for(var/varName in newVars) //stolen shamelessly from Conjure
			if(varName in trans.vars)
				trans.vars[varName] = newVars[varName]
		//Give them our languages
		for(var/l in M.languages)
			var/datum/language/L = l
			trans.add_language(L.name)
		trans.faction = M.faction
		trans.SetName("[trans.name] ([M])")
		if(istype(M,/mob/living/carbon/human) && drop_items)
			for(var/obj/item/I in M.contents)
				M.drop_from_inventory(I)
		if(M.mind)
			M.mind.transfer_to(trans)
		else
			trans.key = M.key
		new /obj/temporary(get_turf(M), 5, 'icons/effects/effects.dmi', "summoning")

		charge_counter = charge_max
		M.forceMove(trans) //move inside the new dude to hide him.
		M.status_flags |= GODMODE //don't want him to die or breathe or do ANYTHING
		transformed_dudes[trans] = M
		GLOB.death_event.register(trans, src, PROC_REF(stop_transformation))
		GLOB.destroyed_event.register(trans, src, PROC_REF(stop_transformation))
		GLOB.destroyed_event.register(M, src, PROC_REF(destroyed_transformer))
		if(duration)
			spawn(duration)
				stop_transformation(trans)

/spell/targeted/shapeshift/proc/destroyed_transformer(mob/target) //Juuuuust in case
	var/mob/current = transformed_dudes[target]
	to_chat(current, SPAN_DANGER("You suddenly feel as if this transformation has become permanent..."))
	remove_target(target)

/spell/targeted/shapeshift/proc/stop_transformation(mob/living/target)
	var/mob/living/transformer = transformed_dudes[target]
	if(!transformer)
		return FALSE
	transformer.status_flags &= ~GODMODE
	if(share_damage)
		var/ratio = target.health/target.maxHealth
		var/damage = transformer.maxHealth - round(transformer.maxHealth*(ratio))
		for(var/i in 1 to ceil(damage/10))
			transformer.adjustBruteLoss(10)
	if(target.mind)
		target.mind.transfer_to(transformer)
	else
		transformer.key = target.key
	playsound(get_turf(target), revert_sound, 50, 1)
	charge_counter = 0
	transformer.forceMove(get_turf(target))
	GLOB.death_event.unregister(target,src,/spell/targeted/shapeshift/proc/stop_transformation)
	GLOB.destroyed_event.unregister(target,src,/spell/targeted/shapeshift/proc/stop_transformation)
	GLOB.destroyed_event.unregister(transformer, src, /spell/targeted/shapeshift/proc/destroyed_transformer)
	remove_target(target)
	qdel(target)
	return TRUE

/spell/targeted/shapeshift/proc/remove_target(mob/living/target)
	var/mob/current = transformed_dudes[target]
	GLOB.destroyed_event.unregister(target,src)
	GLOB.death_event.unregister(current,src)
	GLOB.destroyed_event.unregister(current,src)
	transformed_dudes[target] = null
	transformed_dudes -= target

/spell/targeted/shapeshift/baleful_polymorph
	name = "Baleful Polymorth"
	desc = "This spell transforms its target into a small, furry animal."
	feedback = "BP"
	possible_transformations = list(/mob/living/simple_animal/passive/lizard,/mob/living/simple_animal/passive/mouse,/mob/living/simple_animal/passive/corgi)

	share_damage = 0
	toggle = FALSE
	invocation = "Yo'balada!"
	invocation_type = SpI_SHOUT
	spell_flags = NEEDSCLOTHES | SELECTABLE
	range = 3
	duration = 150 //15 seconds.
	cooldown_min = 200 //20 seconds

	level_max = list(Sp_TOTAL = 2, Sp_SPEED = 2, Sp_POWER = 2)

	newVars = list("health" = 50, "maxHealth" = 50)

	hud_state = "wiz_poly"


/spell/targeted/shapeshift/baleful_polymorph/empower_spell()
	if(!..())
		return 0

	duration += 50

	return "Your target will now stay in their polymorphed form for [duration/10] seconds."

/spell/targeted/shapeshift/avian
	name = "Polymorph"
	desc = "This spell transforms the wizard into the common parrot."
	feedback = "AV"
	possible_transformations = list(/mob/living/simple_animal/hostile/retaliate/parrot)

	drop_items = 0
	share_damage = 0
	invocation = "Poli'crakata!"
	invocation_type = SpI_SHOUT
	spell_flags = INCLUDEUSER
	range = 0
	duration = 150
	charge_max = 600
	cooldown_min = 300
	level_max = list(Sp_TOTAL = 1, Sp_SPEED = 1, Sp_POWER = 0)
	hud_state = "wiz_parrot"

/spell/targeted/shapeshift/avian/check_valid_targets(list/targets)
	return TRUE

/spell/targeted/shapeshift/corrupt_form
	name = "Corrupt Form"
	desc = "This spell shapes the wizard into a terrible, terrible beast."
	feedback = "CF"
	possible_transformations = list(/mob/living/simple_animal/hostile/faithless)

	invocation = "mutters something dark and twisted as their form begins to twist..."
	invocation_type = SpI_EMOTE
	spell_flags = INCLUDEUSER
	range = 0
	duration = 15 SECONDS
	charge_max = 1200
	cooldown_min = 60 SECONDS

	drop_items = 0
	share_damage = 0
	level_max = list(Sp_TOTAL = 3, Sp_SPEED = 2, Sp_POWER = 2)

	newVars = list("name" = "corrupted soul")

	hud_state = "wiz_corrupt"
	cast_sound = 'sound/magic/disintegrate.ogg'

/spell/targeted/shapeshift/corrupt_form/check_valid_targets(list/targets)
	return TRUE

/spell/targeted/shapeshift/corrupt_form/empower_spell()
	if(!..())
		return 0

	switch(spell_levels[Sp_POWER])
		if(1)
			duration *= 2
			possible_transformations = list(/mob/living/simple_animal/hostile/faithless/strong)
			return "Your form is stronger and will stay corrupted for [duration/10] seconds."
		if(2)
			possible_transformations = list(/mob/living/simple_animal/hostile/incarnate)
			duration = 0
			charge_counter = 5 MINUTES
			charge_max = 5 MINUTES
			return "You revel in the corruption. There is no turning back. Corrupted Form will last until destroyed, but you are as powerful as a juggernaut."

/spell/targeted/shapeshift/familiar
	name = "Transform"
	desc = "Transform into a familiar form. Literally."
	feedback = "FA"
	possible_transformations = list()
	drop_items = 0
	invocation_type = SpI_EMOTE
	invocation = "'s body dissipates into a pale mass of light, then reshapes!"
	range = 0
	spell_flags = INCLUDEUSER
	duration = 0
	charge_max = 2 MINUTES

	hud_state = "wiz_carp"

/spell/targeted/shapeshift/familiar/check_valid_targets(list/targets)
	return TRUE

/spell/targeted/shapeshift/familiar/cast(list/targets, mob/user)
	..()
	for(var/mob/living/L in transformed_dudes)
		L.can_enter_vent_with += /mob/living/carbon/human

/mob/living/simple_animal/hostile/incarnate
	name = "\proper corruption incarnate"
	real_name = "\proper corruption incarnate"
	desc = "A possessed suit of armour driven by incomprehensible power."
	icon = 'icons/mob/mob.dmi'
	icon_state = "behemoth"
	icon_living = "behemoth"
	maxHealth = 300
	health = 300
	speak_emote = list("rumbles")
	response_harm = "harmlessly punches"
	harm_intent_damage = 0
	natural_weapon = /obj/item/natural_weapon/juggernaut
	mob_size = MOB_LARGE
	speed = 3
	environment_smash = 2
	status_flags = 0
	resistance = 10
	can_escape = TRUE
