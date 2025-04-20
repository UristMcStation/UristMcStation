//Keep this unticked unless you're Glloyd and unfucked this file
/mob/living/carbon/harvester
	name = "Harvester"
	desc = "What the fuck is that thing?"
	icon = 'icons/uristmob/scommobs.dmi'
	icon_state = "harvester"
	maxHealth = 75 //start off weak, can absorb health.
	health = 75
	faction = "alien"
	var/iscloaking = 0

/mob/living/carbon/harvester/New()

	name = "Harvester ([rand(1, 999)])"

	verbs += /mob/living/proc/ventcrawl

	real_name = name
	regenerate_icons()

	add_language("Hivemind")
	add_language("Xenomorph") //Bonus language.
	internal_organs |= new /obj/item/organ/internal/xenos/hivenode(src)

	gender = NEUTER

	if(mind)
		add_spell(new/spell/aoe_turf/blink)

	verbs += /mob/living/carbon/harvester/proc/harvester_glare
	verbs += /mob/living/carbon/harvester/proc/harvester_cloak

	..()

/mob/living/carbon/harvester/death()
	..()
	visible_message("<span class='danger'>The [src.name] fades into nothingness!</span>")
	icon_state = null
	flick("harvester_die", src)
	sleep(6)
	qdel(src)
	return

/mob/living/carbon/harvester/attack_ui(slot_id)
	return

/mob/living/carbon/harvester/attack_hand(mob/living/carbon/M as mob)

	..()

	switch(M.a_intent)

		if (I_HELP)
			for(var/mob/O in viewers(src, null))
				if ((O.client && !( O.blinded )))
					O.show_message(text("<span class='danger'> [] tried to hug [] but their arms passed through!</span>", M, src), 1)
		if (I_GRAB)
			if (M == src)
				return

			playsound(loc, 'sound/weapons/punchmiss.ogg', 50, 1, -1)
			for(var/mob/O in viewers(src, null))
				if ((O.client && !( O.blinded )))
					O.show_message(text("<span class='danger'> [] tried to grab [] but their hands passed through!</span>", M, src), 1)

		else
			if (M == src)
				return

			playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
			for(var/mob/O in viewers(src, null))
				if ((O.client && !( O.blinded )))
					O.show_message(text("<span class='danger'> <B>[] has attempted to punch [] but their hand passed through!</B></span>", M, src), 1)
	return

/mob/living/carbon/harvester/ex_act(severity)

	var/b_loss = null
	var/f_loss = null
	switch (severity)
		if (1.0)
			b_loss += 500
			gib()
			return

		if (2.0)

			b_loss += 60

			f_loss += 60

		if(3.0)
			b_loss += 30
			if (prob(50))
				Paralyse(1)

	adjustBruteLoss(b_loss)
	adjustFireLoss(f_loss)

	updatehealth()

/mob/living/carbon/harvester/instantiate_hud(datum/hud/HUD)
	HUD.infestharvester_hud()

/datum/hud/proc/infestharvester_hud()

	mymob.fire = new /obj/screen()
	mymob.fire.icon = 'icons/mob/screen1_construct.dmi'
	mymob.fire.icon_state = "fire0"
	mymob.fire.name = "fire"
	mymob.fire.screen_loc = ui_construct_fire

	mymob.healths = new /obj/screen()
	mymob.healths.icon = 'icons/mob/screen1_construct.dmi'
	mymob.healths.icon_state = "harvester_health0"
	mymob.healths.name = "health"
	mymob.healths.screen_loc = ui_construct_health

	mymob.pullin = new /obj/screen()
	mymob.pullin.icon = 'icons/mob/screen1_construct.dmi'
	mymob.pullin.icon_state = "pull0"
	mymob.pullin.name = "pull"
	mymob.pullin.screen_loc = ui_construct_pull

	mymob.zone_sel = new /obj/screen/zone_sel()
	mymob.zone_sel.icon = 'icons/mob/screen1_construct.dmi'
	length(mymob.zone_sel.overlays) = 0
	mymob.zone_sel.AddOverlays(image('icons/mob/zone_sel.dmi', "[mymob.zone_sel.selecting]"))

	mymob.client.screen = null

	mymob.client.screen += list(mymob.fire, mymob.healths, mymob.pullin, mymob.zone_sel)


/mob/living/carbon/harvester/Life()
	..()

	. = ..()
	if(.)
//		if(fire)
//			if(fire_alert)							fire.icon_state = "fire1"
//			else									fire.icon_state = "fire0"
		if(pullin)
			if(pulling)								pullin.icon_state = "pull1"
			else

	if (stat != DEAD) //still breathing

		// Radiation.
		handle_mutations_and_radiation()

	blinded = null

	//Status updates, death etc.
	handle_regular_status_updates()
	update_canmove()
	update_icons()

	if(healths)
		switch(health)
			if(maxHealth to INFINITY)								healths.icon_state = "harvester_health0"
			if(maxHealth/1.2 to maxHealth-1)						healths.icon_state = "harvester_health1"
			if(maxHealth/1.5 to maxHealth-maxHealth/1.2-1)			healths.icon_state = "harvester_health2"
			if(maxHealth/2 to maxHealth/1.5-1)						healths.icon_state = "harvester_health3"
			if(maxHealth/3 to maxHealth/2-1)						healths.icon_state = "harvester_health4"
			if(maxHealth/6 to maxHealth/3-1)						healths.icon_state = "harvester_health5"
			if(maxHealth/maxHealth to maxHealth/6-1)				healths.icon_state = "harvester_health6"
			else													healths.icon_state = "harvester_health7"

	if(iscloaking)
		var/light_amount = 0
		if(isturf(src.loc))
			light_amount = get_light_amt(src.loc)

		//	if(!istype(T))
		//		return 0

		if(!iscloaking)
			alpha = 255
			return 0
		if(light_amount <= 2)
			alpha = 10
			return 1
		else
			alpha = round((255 * 0.80))

	else if(!iscloaking)
		alpha = 255

/mob/living/carbon/harvester/handle_mutations_and_radiation()

	if(!radiation)
		return

	var/rads = radiation/25
	radiation -= rads
	nutrition += rads
	heal_overall_damage(rads,rads)
	adjustOxyLoss(-(rads))
	adjustToxLoss(-(rads))
	return

/mob/living/carbon/harvester/handle_regular_status_updates() //edit this

	if(status_flags & GODMODE)	return 0

	if(stat == DEAD)
		blinded = 1
		silent = 0
	else
		updatehealth()
		handle_stunned()
		handle_weakened()
		if(health <= 0)
			death()
			blinded = 1
			silent = 0
			return 1

		if(paralysis && paralysis > 0)
			handle_paralysed()
			blinded = 1
			stat = UNCONSCIOUS
			if(getHalLoss() > 0)
				adjustHalLoss(-3)

		if(sleeping)
			adjustHalLoss(-3)
			if (mind)
				if(mind.active && client != null)
					sleeping = max(sleeping-1, 0)
			blinded = 1
			stat = UNCONSCIOUS
		else if(resting)
			if(getHalLoss() > 0)
				adjustHalLoss(-3)

		else
			stat = CONSCIOUS
			if(getHalLoss() > 0)
				adjustHalLoss(-1)

		// Eyes and blindness.
		if(!has_eyes())
			eye_blind =  1
			blinded =    1
			eye_blurry = 1
		else if(eye_blind)
			eye_blind =  max(eye_blind-1,0)
			blinded =    1
		else if(eye_blurry)
			eye_blurry = max(eye_blurry-1, 0)

		//Ears
		if(sdisabilities & DEAF)	//disabled-deaf, doesn't get better on its own
			ear_deaf = max(ear_deaf, 1)
		else if(ear_deaf)			//deafness, heals slowly over time
			ear_deaf = max(ear_deaf-1, 0)
			ear_damage = max(ear_damage-0.05, 0)

		update_icons()

	return 1


/mob/living/carbon/harvester/UnarmedAttack(atom/A, var/proximity)

	if(!..())
		return 0

	var/mob/living/carbon/human/M = A
	if (istype(M))
		M.visible_message("<span class='danger'>[src] has drained the life from [M]!</span>", "<span class='danger'>[src] has drained the life from you!</span>")
		M.adjustFireLoss(10)
		if(src.maxHealth >= 200 || src.health >= 200)
			to_chat(src, "<span class='danger'>You cannot absorb any more life!</span>")
			return

		else if(src.maxHealth <= 195)
			src.maxHealth += 5
			src.health += 5

	else
		A.attack_generic(src, 5 ,"drained")

/mob/living/carbon/harvester/proc/harvester_glare()
	set category = "Harvester"
	set name = "Glare"
	set desc= "A scary glare that incapacitates people for a short while around you."
	var/datum/mind/M = usr.mind
	if(!M) return
	M.current.visible_message("<span class='warning'> <b>The harvester emits a blinding light.!</b></span>")
	M.current.verbs -= /mob/living/carbon/harvester/proc/harvester_glare
	spawn(300)
		M.current.verbs += /mob/living/carbon/harvester/proc/harvester_glare

	for(var/mob/living/carbon/C in view(1))
		if(C.faction == "alien") continue
		if(!src) continue
		if((C.eyecheck()) > 1) continue
		C.Stun(8)
		C.Weaken(8)
		C.stuttering = 20
		to_chat(C,"<span class='warning'> You are blinded by [M.current.name]'s glare.</span>")

/mob/living/carbon/harvester/proc/harvester_cloak()
	set category = "Harvester"
	set name = "Cloak of Darkness (toggle)"
	set desc = "Toggles whether you are currently cloaking yourself in darkness."
	if(iscloaking)
		iscloaking = 0
	else if(!iscloaking)
		iscloaking = 1
	to_chat(src, "<span class='notice'> You will now be [iscloaking ? ")hidden" : "seen"] in darkness.</span>"

/mob/living/carbon/harvester/proc/harvester_turn()
	set category = "Harvester"
	set name = "Create Husk"
	set desc = "Turns a human corpse into a deadly Husk at the cost of some of your health."
	if(maxHealth <= 124) //not enough health to give //add mahealth and heath to the status panel. gamey, but the whole mode's gamey af
		to_chat(src, "<span class='notice'>You do not have enough strength to turn that corpse into a husk.</span>")
		return

	else
		for(var/mob/living/carbon/human/H in view(1))
			if(H.stat != DEAD)
				var/mob/living/simple_animal/hostile/scom/husk/X = new /mob/living/simple_animal/hostile/scom/husk(src.loc) //TURN HUSKS INTO A HUMAN SUBSPECIES //temp spawning the simple mobs
				X.ckey = H.ckey
				qdel(H)
				src.maxHealth -= 50 //mess with this
				if(src.health >= src.maxHealth) //gotta make the health match up. if it's lower, we don't do shit.
					src.health = src.maxHealth
				to_chat(src, "<span class='warning'> You reach out with tendrils of darkness, turning what was once a human being with hopes and dreams into a mindless husk, slaved to the alien hivemind. However, you feel much weaker.</span>")
