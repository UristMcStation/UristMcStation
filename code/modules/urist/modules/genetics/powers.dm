#define EAT_MOB_DELAY 300 // 30s

//genetics powers, ported from vg who took them from goon

// WAS: /datum/bioEffect/alcres
/datum/dna/gene/basic/sober
	name="Sober"
	activation_messages=list("You feel unusually sober.")
	deactivation_messages = list("You feel like you could use a stiff drink.")

	mutation=M_SOBER

/datum/dna/gene/basic/sober/New()
	block=GLOB.SOBERBLOCK

//WAS: /datum/bioEffect/psychic_resist
/datum/dna/gene/basic/psychic_resist
	name="Psy-Resist"
	desc = "Boosts efficiency in sectors of the brain commonly associated with meta-mental energies."
	activation_messages = list("Your mind feels closed.")
	deactivation_messages = list("You feel oddly exposed.")

	mutation=M_PSY_RESIST

/datum/dna/gene/basic/psychic_resist/New()
		block=GLOB.PSYRESISTBLOCK

/////////////////////////
// Stealth Enhancers
/////////////////////////

/datum/dna/gene/basic/stealth

/datum/dna/gene/basic/stealth/can_activate(mob/M, flags)
	// Can only activate one of these at a time.
	if(is_type_in_list(/datum/dna/gene/basic/stealth,M.active_genes))
		testing("Cannot activate [type]: /datum/dna/gene/basic/stealth in M.active_genes.")
		return 0
	return ..(M,flags)

/datum/dna/gene/basic/stealth/deactivate(mob/M)
	..(M)
	M.alpha=255

// WAS: /datum/bioEffect/darkcloak
/datum/dna/gene/basic/stealth/darkcloak
	name = "Cloak of Darkness"
	desc = "Enables the subject to bend low levels of light around themselves, creating a cloaking effect."
	activation_messages = list("You begin to fade into the shadows.")
	deactivation_messages = list("You become fully visible.")

/datum/dna/gene/basic/stealth/darkcloak/New()
	block=GLOB.SHADOWBLOCK

/datum/dna/gene/basic/stealth/darkcloak/OnMobLife(mob/M)

	if(isturf(M.loc))
		var/turf/T = M.loc
		if(shadow_check(T, 0.1, 1))
			M.alpha = 1
		else
			M.alpha = round(255 * 0.80)
	else
		M.alpha = round(255 * 0.80)

//WAS: /datum/bioEffect/chameleon
/*/datum/dna/gene/basic/stealth/chameleon // needs work to port - Glloyd
	name = "Chameleon"
	desc = "The subject becomes able to subtly alter light patterns to become invisible, as long as they remain still."
	activation_messages = list("You feel one with your surroundings.")
	deactivation_messages = list("You feel oddly exposed.")

	New()
		block=GLOB.CHAMELEONBLOCK

	OnMobLife(var/mob/M)
		if((world.time - M.last_movement) >= 30 && !M.stat && M.canmove && !M.restrained())
			M.alpha = 0
		else
			M.alpha = round(255 * 0.80)*/

/////////////////////////////////////////////////////////////////////////////////////////

/datum/dna/gene/basic/grant_spell
	var/spell/spelltype //TODO: might need to convert it to a list later

/datum/dna/gene/basic/grant_spell/activate(mob/M, connected, flags)
	..()
	M.add_spell(src.spelltype, "genetic_spell_ready")
	return 1


/datum/dna/gene/basic/grant_spell/deactivate(mob/M, connected, flags)
	..()
	M.remove_spell(src.spelltype)
	return 1

/datum/dna/gene/basic/grant_verb
	var/verbtype

/datum/dna/gene/basic/grant_verb/activate(mob/M, connected, flags)
	..()
	M.verbs += verbtype
	return 1

/datum/dna/gene/basic/grant_verb/deactivate(mob/M, connected, flags)
	..()
	M.verbs -= verbtype

// WAS: /datum/bioEffect/cryokinesis
/datum/dna/gene/basic/grant_spell/cryo
	name = "Cryokinesis"
	desc = "Allows the subject to lower the body temperature of others."
	activation_messages = list("You notice a strange cold tingle in your fingertips.")
	deactivation_messages = list("Your fingers feel warmer.")

	spelltype = new/spell/targeted/cryokinesis

/datum/dna/gene/basic/grant_spell/cryo/New()
	..()
	block = GLOB.CRYOBLOCK

/spell/targeted/cryokinesis
	name = "Cryokinesis"
	desc = "Drops the bodytemperature of another person."
	panel = "Mutant Powers"

	charge_type = "recharge"
	charge_max = 600

	invocation_type = "none"
	range = 7
	selection_type = "range"
	hud_state = "gen_ice"

	spell_flags = Z2NOCAST|INCLUDEUSER
	compatible_mobs = list(/mob/living/carbon/human)

/spell/targeted/cryokinesis/cast(list/targets)
	if(!length(targets))
		to_chat(usr, "<span class='notice'>No target found in range.</span>")
		return

	var/mob/living/carbon/C = targets[1]

	if(!iscarbon(C))
		to_chat(usr, "<span class='warning'> This will only work on normal organic beings.</span>")
		return

	if (MUTATION_COLD_RESISTANCE in C.mutations)
		C.visible_message("<span class='warning'> A cloud of fine ice crystals engulfs [C.name], but disappears almost instantly!</span>")
		return

	C.bodytemperature = 0
	C.adjustFireLoss(20)
	C.ExtinguishMob()

	C.visible_message("<span class='warning'> A cloud of fine ice crystals engulfs [C]!</span>")

	//playsound(usr.loc, 'bamf.ogg', 50, 0)

	new/obj/urist_intangible/effects/self_deleting(C.loc, icon('icons/effects/genetics.dmi', "cryokinesis"))

	return

/obj/urist_intangible/effects/self_deleting
	density = FALSE
	opacity = 0
	anchored = TRUE
	icon = null
	desc = ""
	//layer = 15

/obj/urist_intangible/effects/self_deleting/New(atom/location, icon/I, duration = 20, oname = "something")
	..()
	src.name = oname
	loc=location
	src.icon = I
	spawn(duration)
		qdel(src)

///////////////////////////////////////////////////////////////////////////////////////////

// WAS: /datum/bioEffect/mattereater
/datum/dna/gene/basic/grant_spell/mattereater
	name = "Matter Eater"
	desc = "Allows the subject to eat just about anything without harm."
	activation_messages = list("You feel hungry.")
	deactivation_messages = list("You don't feel quite so hungry anymore.")

	spelltype = new/spell/targeted/eat

/datum/dna/gene/basic/grant_spell/mattereater/New()
	..()
	block = GLOB.EATBLOCK

/spell/targeted/eat
	name = "Eat"
	desc = "Eat just about anything!"
	panel = "Mutant Powers"

	charge_type = "recharge"
	charge_max = 300

	invocation_type = "none"
	range = 1
	selection_type = "view"
	hud_state = "gen_eat"
	spell_flags = INCLUDEUSER //TODO: axe the old proc's choose_targets, make it SELECTABLE properly

	var/list/types_allowed=list(/obj/item,/mob/living/simple_animal, /mob/living/carbon/human)

/spell/targeted/eat/choose_targets(mob/user = usr)
	var/list/targets = list()
	var/list/possible_targets = list()

	for(var/atom/movable/O in view_or_range(range, user, selection_type))
		if(is_type_in_list(O,types_allowed) && !ismob(O.loc)) // No eating things inside of you or another person, that's just creepy
			possible_targets += O

	targets += input("Choose the target of your hunger.", "Targeting") as anything in possible_targets

	if(!length(targets)) //doesn't waste the spell
		return

	perform(targets)

/spell/targeted/eat/proc/doHeal(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H=user
		for(var/name in H.organs_by_name)
			var/obj/item/organ/external/affecting = null
			if(!H.organs[name])
				continue
			affecting = H.organs[name]
			if(!istype(affecting, /obj/item/organ/external))
				continue
			affecting.heal_damage(4, 0)
		H.UpdateDamageIcon()
		H.updatehealth()

/spell/targeted/eat/cast(list/targets)
	if(!length(targets))
		to_chat(usr, "<span class='notice'>No target found in range.</span>")
		return

	var/atom/movable/the_item = targets[1]
	if(ishuman(the_item))
		//My gender
		var/m_his="his"
		if(usr.gender==FEMALE)
			m_his="her"
		// Their gender
		var/t_his="his"
		if(the_item.gender==FEMALE)
			t_his="her"
		var/mob/living/carbon/human/H = the_item
		var/obj/item/organ/external/limb = H.get_organ(usr.zone_sel.selecting)
		if(!istype(limb))
			to_chat(usr, "<span class='warning'> You can't eat this part of them!</span>")
//			revert_cast()
			return 0
		if(istype(limb,/obj/item/organ/external/head))
			// Bullshit, but prevents being unable to clone someone.
			to_chat(usr, "<span class='warning'> You try to put \the [limb] in your mouth, but [t_his] ears tickle your throat!</span>")
//			revert_cast()
			return 0
		if(istype(limb,/obj/item/organ/external/chest))
			// Bullshit, but prevents being able to instagib someone.
			to_chat(usr, "<span class='warning'> You try to put their [limb] in your mouth, but it's too big to fit!</span>")
//			revert_cast()
			return 0
		usr.visible_message("<span class='danger'>[usr] begins stuffing [the_item]'s [limb.name] into [m_his] gaping maw!</span>")
		var/oldloc = H.loc
		if(!do_after(usr,H,EAT_MOB_DELAY))
			to_chat(usr, "<span class='warning'> You were interrupted before you could eat [the_item]!</span>")
		else
			if(!limb || !H)
				return
			if(H.loc!=oldloc)
				to_chat(usr, "<span class='warning'> \The [limb] moved away from your mouth!</span>")
				return
			usr.visible_message("<span class='warning'> [usr] [pick("chomps","bites")] off [the_item]'s [limb]!</span>")
			playsound(usr.loc, 'sound/items/eatfood.ogg', 50, 0)
			var/obj/limb_obj=limb.droplimb(1,1)
			if(limb_obj)
				var/obj/item/organ/external/chest=usr:get_organ("chest")
				chest.implants += limb_obj
				limb_obj.loc=usr
			doHeal(usr)
	else
		usr.visible_message("<span class='warning'> [usr] eats \the [the_item].</span>")
		playsound(usr.loc, 'sound/items/eatfood.ogg', 50, 0)
		qdel(the_item)
		doHeal(usr)

	return

////////////////////////////////////////////////////////////////////////

//WAS: /datum/bioEffect/jumpy
/datum/dna/gene/basic/grant_spell/jumpy
	name = "Jumpy"
	desc = "Allows the subject to leap great distances."
	//cooldown = 30
	activation_messages = list("Your leg muscles feel taut and strong.")
	deactivation_messages = list("Your leg muscles shrink back to normal.")

	spelltype = new/spell/targeted/leap

/datum/dna/gene/basic/grant_spell/jumpy/New()
	..()
	block = GLOB.JUMPBLOCK

/spell/targeted/leap
	name = "Jump"
	desc = "Leap great distances!"
	panel = "Mutant Powers"
	range = 0

	charge_type = "recharge"
	charge_max = 30
	hud_state = "gen_leap"

	invocation_type = "none"
	spell_flags = INCLUDEUSER

/spell/targeted/leap/cast(list/targets)
	if (ismob(usr.loc))
		to_chat(usr, "<span class='warning'> You can't jump right now!</span>")
		return

	if (isturf(usr.loc))
		usr.visible_message("<span class='danger'>[usr.name] takes a huge leap!</span>")
		playsound(usr.loc, 'sound/weapons/thudswoosh.ogg', 50, 1)
		var/prevLayer = usr.layer
		usr.layer = 15

		for(var/i=0, i<10, i++)
			step(usr, usr.dir)
			if(i < 5) usr.pixel_y += 8
			else usr.pixel_y -= 8
			sleep(1)

		if (MUTATION_FAT in usr.mutations && prob(66))
			usr.visible_message("<span class='danger'>[usr.name] crashes due to their heavy weight!</span>")
			//playsound(usr.loc, 'zhit.wav', 50, 1)
			usr.weakened += 10
			usr.stunned += 5

		usr.layer = prevLayer

	if (isobj(usr.loc))
		var/obj/container = usr.loc
		to_chat(usr, "<span class='warning'> You leap and slam your head against the inside of [container]! Ouch!</span>")
		usr.paralysis += 3
		usr.weakened += 5
		container.visible_message("<span class='danger'>[usr.loc]emits a loud thump and rattles a bit.</span>")
		playsound(usr.loc, 'sound/effects/bang.ogg', 50, 1)
		var/wiggle = 6
		while(wiggle > 0)
			wiggle--
			container.pixel_x = rand(-3,3)
			container.pixel_y = rand(-3,3)
			sleep(1)
		container.pixel_x = 0
		container.pixel_y = 0


	return

////////////////////////////////////////////////////////////////////////

// WAS: /datum/bioEffect/polymorphism

/*/datum/dna/gene/basic/grant_spell/polymorph  //Off for now to do some work on it -- Glloyd
	name = "Polymorphism"
	desc = "Enables the subject to reconfigure their appearance to mimic that of others."

	spelltype = new/spell/targeted/polymorph
	//cooldown = 1800
	activation_messages = list("You don't feel entirely like yourself somehow.")
	deactivation_messages = list("You feel secure in your identity.")

	New()
		..()
		block = GLOB.POLYMORPHBLOCK

/spell/targeted/polymorph
	name = "Polymorph"
	desc = "Mimic the appearance of others!"
	panel = "Mutant Powers"
	charge_max = 1800

	clothes_req = 0
	stat_allowed = 0
	invocation_type = "none"
	range = 1
	selection_type = "range"

/spell/targeted/polymorph/cast(list/targets)
	var/mob/living/M=targets[1]
	if(!ishuman(M))
		to_chat(usr, "<span class='warning'> You can only change your appearance to that of another human.</span>")
		return

	if(!ishuman(usr)) return


	//playsound(usr.loc, 'blobattack.ogg', 50, 1)

	usr.visible_message("<span class='warning'> [usr]'s body shifts and contorts.</span>")

	spawn(10)
		if(M && usr)
			//playsound(usr.loc, 'gib.ogg', 50, 1)
			usr.UpdateAppearance(M.dna.UI)
			usr:real_name = M:real_name
			usr:name = M:name*/
////////////////////////////////////////////////////////////////////////

// WAS: /datum/bioEffect/empath
/datum/dna/gene/basic/grant_verb/empath
	name = "Empathic Thought"
	desc = "The subject becomes able to read the minds of others for certain information."

	verbtype = /proc/bioproc_empath
	activation_messages = list("You suddenly notice more about others than you did before.")
	deactivation_messages = list("You no longer feel able to sense intentions.")

/datum/dna/gene/basic/grant_verb/empath/New()
		..()
		block = GLOB.EMPATHBLOCK

/proc/bioproc_empath(mob/living/carbon/M in range(7,usr))
	set name = "Read Mind"
	set desc = "Read the minds of others for information."
	set category = "Mutant Abilities"

	if(!iscarbon(M))
		to_chat(usr, "<span class='warning'> You may only use this on other organic beings.</span>")
		return

	if(usr.stat)
		return

	if (M_PSY_RESIST in M.mutations)
		to_chat(usr, "<span class='warning'> You can't see into [M.name]'s mind at all!</span>")
		return

	if (M.stat == 2)
		to_chat(usr, "<span class='warning'> [M.name] is dead and cannot have their mind read.</span>")
		return
	if (M.health < 0)
		to_chat(usr, "<span class='warning'> [M.name] is dying, and their thoughts are too scrambled to read.</span>")
		return

	to_chat(usr, "<span class='notice'> Mind Reading of <b>[M.name]:</b></span>")
	var/pain_condition = M.health
	// lower health means more pain
	var/list/randomthoughts = list("what to have for lunch","the future","the past","money",
	"their hair","what to do next","their job","space","amusing things","sad things",
	"annoying things","happy things","something incoherent","something they did wrong")
	var/thoughts = "thinking about [pick(randomthoughts)]"
//	if (M.fire_stacks)
//		pain_condition -= 50
//		thoughts = "preoccupied with the fire"
	if (M.radiation)
		pain_condition -= 25

	switch(pain_condition)
		if (81 to INFINITY)
			to_chat(usr, "<span class='notice'> <b>Condition</b>: [M.name] feels good.</span>")
		if (61 to 80)
			to_chat(usr, "<span class='notice'> <b>Condition</b>: [M.name] is suffering mild pain.</span>")
		if (41 to 60)
			to_chat(usr, "<span class='notice'> <b>Condition</b>: [M.name] is suffering significant pain.</span>")
		if (21 to 40)
			to_chat(usr, "<span class='notice'> <b>Condition</b>: [M.name] is suffering severe pain.</span>")
		else
			to_chat(usr, "<span class='notice'> <b>Condition</b>: [M.name] is suffering excruciating pain.</span>")
			thoughts = "haunted by their own mortality"

	switch(M.a_intent)
		if ("help")
			to_chat(usr, "<span class='notice'> <b>Mood</b>: You sense benevolent thoughts from [M.name].</span>")
		if ("disarm")
			to_chat(usr, "<span class='notice'> <b>Mood</b>: You sense cautious thoughts from [M.name].</span>")
		if ("grab")
			to_chat(usr, "<span class='notice'> <b>Mood</b>: You sense hostile thoughts from [M.name].</span>")
		if ("harm")
			to_chat(usr, "<span class='notice'> <b>Mood</b>: You sense cruel thoughts from [M.name].</span>")
			for(var/mob/living/L in view(7,M))
				if (L == M)
					continue
				thoughts = "thinking about punching [L.name]"
				break
		else
			to_chat(usr, "<span class='notice'> <b>Mood</b>: You sense strange thoughts from [M.name].</span>")

	if (istype(M,/mob/living/carbon/human))
		var/numbers[0]
		var/mob/living/carbon/human/H = M
		if(H.mind && H.mind.initial_account)
			numbers += H.mind.initial_account.account_number
			numbers += H.mind.initial_account.remote_access_pin
		if(length(numbers)>0)
			to_chat(usr, "<span class='notice'> <b>Numbers</b>: You sense the number[length(numbers)>1?")s":""] [english_list(numbers)] [length(numbers)>1?"are":"is"] important to [M.name].</span>")
	to_chat(usr, "<span class='notice'> <b>Thoughts</b>: [M.name] is currently [thoughts].</span>")

	if (/datum/dna/gene/basic/grant_verb/empath in M.active_genes)
		to_chat(M, "<span class='warning'> You sense [usr.name] reading your mind.</span>")
	else if (prob(5) || M.mind.assigned_role=="Chaplain")
		to_chat(M, "<span class='warning'> You sense someone intruding upon your thoughts...</span>")
	return

////////////////////////////////////////////////////////////////////////

/*// WAS: /datum/bioEffect/superfart
/datum/dna/gene/basic/superfart			//NO -- Glloyd
	name = "High-Pressure Intestines"
	desc = "Vastly increases the gas capacity of the subject's digestive tract."
	activation_messages = list("You feel bloated and gassy.")
	deactivation_messages = list("You no longer feel gassy. What a relief!")

	mutation = M_SUPER_FART

	New()
		..()
		block = GLOB.SUPERFARTBLOCK*/
