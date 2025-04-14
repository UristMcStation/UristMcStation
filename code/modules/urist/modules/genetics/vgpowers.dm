/*
This is /vg/'s nerf for hulk.  Feel free to steal it.

Obviously, requires DNA2.
*/

// When hulk was first applied (world.time).
/mob/living/carbon/human/var/hulk_time=0

// In decaseconds.
#define HULK_DURATION 300 // How long the effects last
#define HULK_COOLDOWN 600 // How long they must wait to hulk out.

/datum/dna/gene/basic/grant_spell/hulk
	name = "Hulk"
	desc = "Allows the subject to become the motherfucking Hulk."
	activation_messages = list("Your muscles hurt.")
	deactivation_messages = list("Your muscles quit tensing.")
//	flags = GENE_UNNATURAL // Do NOT spawn on roundstart.

	spelltype = new/spell/targeted/hulk

/datum/dna/gene/basic/grant_spell/hulk/New()
	..()
	block = GLOB.HULKBLOCK

/datum/dna/gene/basic/grant_spell/hulk/can_activate(mob/M,flags)
	// Can't be big AND small.
	if(mSmallsize in M.mutations)
		return 0
	return ..(M,flags)

/datum/dna/gene/basic/grant_spell/hulk/OnDrawUnderlays(mob/M,g,fat)
	if(MUTATION_HULK in M.mutations)
		if(fat)
			return "hulk_[fat]_s"
		else
			return "hulk_[g]_s"
	return 0

/datum/dna/gene/basic/grant_spell/hulk/OnMobLife(mob/living/carbon/human/M)
	if(!istype(M)) return
	if(MUTATION_HULK in M.mutations)
		var/timeleft=M.hulk_time - world.time
		if(M.health <= 25 || timeleft <= 0)
			M.hulk_time=0 // Just to be sure.
			M.mutations.Remove(MUTATION_HULK)
			//M.dna.SetSEState(HULKBLOCK,0)
			M.update_mutations()		//update our mutation overlays
			M.update_body()
			to_chat(M, "<span class='warning'> You suddenly feel very weak.</span>")
			M.Weaken(3)
			M.emote("collapse")

/spell/targeted/hulk
	name = "Hulk Out"
	panel = "Mutant Powers"
	range = 0
	spell_flags = INCLUDEUSER

	charge_type = "recharge"
	charge_max = HULK_COOLDOWN

	invocation_type = "none"
	hud_state = "gen_hulk"

/spell/targeted/hulk/New()
	desc = "Get mad!  For [HULK_DURATION/10] seconds, anyway."
	..()

/spell/targeted/hulk/cast(list/targets)
	if (istype(usr.loc,/mob))
		to_chat(usr, "<span class='warning'> You can't hulk out right now!</span>")
		return
	var/mob/living/carbon/human/M=usr
	M.hulk_time = world.time + HULK_DURATION
	M.mutations.Add(MUTATION_HULK)
	M.update_mutations()		//update our mutation overlays
	M.update_body()
	//M.say(pick("",";")+pick("HULK MAD","YOU MADE HULK ANGRY")) // Just a note to security.
	message_admins("[key_name(usr)] has hulked out!")
	return

/datum/dna/gene/basic/noir
	name="Noir"
	desc = "In recent years, there's been a real push towards 'Detective Noir' movies, but since the last black and white camera was lost many centuries ago, Scientists had to develop a way to turn any movie noir."
	activation_messages=list("The Station's bright coloured light hits your eyes for the last time, and fades into a more appropriate tone, something's different about this place, but you can't put your finger on it. You feel a need to check out the bar, maybe get to the bottom of what's going on in this godforsaken place.")
	deactivation_messages = list("You now feel soft boiled.")

	mutation=M_NOIR

/datum/dna/gene/basic/noir/New()
	block=GLOB.NOIRBLOCK
	..()

/datum/dna/gene/basic/noir/activate(mob/M)
	..()
	M.update_color()

/datum/dna/gene/basic/noir/deactivate(mob/M,connected,flags)
	..()
	M.update_color()
