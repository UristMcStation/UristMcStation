//This is the gamemode file for the ported goon gamemode vampires.
//They get a traitor objective and a blood sucking objective

/datum/game_mode/vampire
	antag_tags = list(MODE_VAMPIRE)
	name = "Vampire"
	round_description = "There are Vampires from Space Transylvania on the station!"
	extended_round_description = "Posing as ordinary crewmembers, unholy creatures have infiltrated the station! Keep your blood close and neck safe!"
	config_tag = "vampire"
	required_players = 2
	required_enemies = 1
	end_on_antag_death = 0
	antag_scaling_coeff = 7


/datum/vampire
	var/bloodtotal = 0
	var/bloodusable = 0
	var/mob/living/owner = null
	var/gender = FEMALE
	var/iscloaking = 0 // handles the vampire cloak toggle
	var/list/powers = list() // list of available powers and passives, see defines in setup.dm
	var/mob/living/carbon/human/draining // who the vampire is draining of blood
	var/nullified = 0 //Nullrod makes them useless for a short while.
	//var/thralls = list()
	var/torpor = 0 // handles coffinsleep

/datum/vampire/New(gend = FEMALE)
	gender = gend

/mob/proc/make_vampire()
	if(!mind)				return
	if(!mind.vampire)
		mind.vampire = new /datum/vampire(gender)
		mind.vampire.owner = src
	if(!mind in vamps.current_antagonists)
		vamps.add_antagonist(src.mind)

	verbs += /client/proc/vampire_rejuvinate
	verbs += /client/proc/vampire_coffinsleep
	verbs += /client/proc/vampire_hypnotise
	verbs += /client/proc/vampire_glare

	for(var/i = 1; i <= 3; i++)
		if(!(i in mind.vampire.powers))
			mind.vampire.powers.Add(i)


	for(var/n in mind.vampire.powers)
		switch(n)
			if(VAMP_SHAPE)
				verbs += /client/proc/vampire_shapeshift
			if(VAMP_VISION)
				continue
			if(VAMP_DISEASE)
				verbs += /client/proc/vampire_disease
			if(VAMP_CLOAK)
				verbs += /client/proc/vampire_cloak
			if(VAMP_BATS)
				verbs += /client/proc/vampire_bats
			if(VAMP_SCREAM)
				verbs += /client/proc/vampire_screech
			if(VAMP_JAUNT)
				verbs += /client/proc/vampire_jaunt
			if(VAMP_BLINK)
				verbs += /client/proc/vampire_shadowstep
			if(VAMP_SLAVE)
				verbs += /client/proc/vampire_turn
			if(VAMP_FULL)
				continue

/mob/proc/remove_vampire_powers()

	verbs -= /client/proc/vampire_rejuvinate
	verbs -= /client/proc/vampire_hypnotise
	verbs -= /client/proc/vampire_glare
	verbs -= /client/proc/vampire_coffinsleep
	verbs -= /client/proc/vampire_shapeshift
	verbs -= /client/proc/vampire_disease
	verbs -= /client/proc/vampire_cloak
	verbs -= /client/proc/vampire_bats
	verbs -= /client/proc/vampire_screech
	verbs -= /client/proc/vampire_jaunt
	verbs -= /client/proc/vampire_shadowstep
	verbs -= /client/proc/vampire_turn


/mob/proc/handle_bloodsucking(mob/living/carbon/human/H)
	src.mind.vampire.draining = H
	var/blood = 0
	var/bloodtotal = 0 //used to see if we increased our blood total
	var/bloodusable = 0 //used to see if we increased our blood usable

	admin_attack_log(src, H, "Bit [H.name] ([H.ckey]) in the neck and started draining their blood.", "Has been bit in the neck by [src.name] ([src.ckey]).", "bite")

	src.visible_message("<span class='warning'><b>[src.name] bites [H.name]'s neck!</b>,</span>", "<span class='warning'>You bite [H.name]'s neck and begin to drain their blood.</span>", "<span class='notice'>You hear a soft puncture and a wet sucking noise</span>")
	if(!iscarbon(src))
		H.LAssailant = null
	else
		H.LAssailant = src
	while(do_mob(src, H, 50))
		if((!mind.vampire) || !(mind in get_antags("vampire")))
			src << "<span class='warning'> Your fangs have disappeared!</span>"
			return 0
		if (!H.should_have_organ(BP_HEART))
			src << "<span class='warning'>Not a drop of blood here</span>"
			return 0
		bloodtotal = src.mind.vampire.bloodtotal
		bloodusable = src.mind.vampire.bloodusable
		if(!H.vessel.get_reagent_amount("blood"))
			src << "<span class='warning'> They've got no blood left to give.</span>"
			break
		if(H.stat < 2) //alive
			blood = min(10, H.vessel.get_reagent_amount("blood"))// if they have less than 10 blood, give them the remnant else they get 10 blood
			src.mind.vampire.bloodtotal += (blood)
			src.mind.vampire.bloodusable += (blood)
			if(istype(src.mind.current, /mob/living/carbon/human))
				var/mob/living/carbon/human/V = src.mind.current
				V.vessel.add_reagent("blood", blood) // finally, no more vamps bleeding out mid-draining; trans_to_holder instead?
			H.traumatic_shock += 2 // vampire bites suck, a long suckership will hurt the victim enough to knock them out
		else
			blood = min(5, H.vessel.get_reagent_amount("blood"))// The dead only give 5 bloods
			src.mind.vampire.bloodtotal += blood
			if(istype(src.mind.current, /mob/living/carbon/human))
				var/mob/living/carbon/human/V = src.mind.current
				V.vessel.add_reagent("blood", blood) // finally, no more vamps bleeding out mid-draining; trans_to_holder instead?
		if(bloodtotal != src.mind.vampire.bloodtotal)
			src << "<span class='notice'>You have accumulated [src.mind.vampire.bloodtotal] [src.mind.vampire.bloodtotal > 1 ? "units" : "unit"] of blood[src.mind.vampire.bloodusable != bloodusable ?", and have [src.mind.vampire.bloodusable] left to use" : "."]</span>"
		check_vampire_upgrade(mind)
		H.vessel.remove_reagent("blood",25)

	src.mind.vampire.draining = null
	src << "<span class='notice'> You stop draining [H.name] of blood.</span>"
	return 1

/mob/proc/check_vampire_upgrade(datum/mind/v)
	if(!v) return
	if(!v.vampire) return
	var/datum/vampire/vamp = v.vampire
	var/list/old_powers = vamp.powers.Copy()

	// TIER 1
	if(vamp.bloodtotal >= 100)
		if(!(VAMP_VISION in vamp.powers))
			vamp.powers.Add(VAMP_VISION)
		if(!(VAMP_SHAPE in vamp.powers))
			vamp.powers.Add(VAMP_SHAPE)

	// TIER 2
	if(vamp.bloodtotal >= 150)
		if(!(VAMP_CLOAK in vamp.powers))
			vamp.powers.Add(VAMP_CLOAK)
		if(!(VAMP_DISEASE in vamp.powers))
			vamp.powers.Add(VAMP_DISEASE)

	// TIER 3
	if(vamp.bloodtotal >= 200)
		if(!(VAMP_BATS in vamp.powers))
			vamp.powers.Add(VAMP_BATS)
		if(!(VAMP_SCREAM in vamp.powers))
			vamp.powers.Add(VAMP_SCREAM)
		// Commented out until we can figured out a way to stop this from spamming.
		//src << "<span class='notice'> Your rejuvination abilities have improved and will now heal you over time when used.</span>"

	// TIER 3.5 (/vg/)
	if(vamp.bloodtotal >= 250)
		if(!(VAMP_BLINK in vamp.powers))
			vamp.powers.Add(VAMP_BLINK)

	// TIER 4
	if(vamp.bloodtotal >= 300)
		if(!(VAMP_JAUNT in vamp.powers))
			vamp.powers.Add(VAMP_JAUNT)
		if(!(VAMP_SLAVE in vamp.powers))
			vamp.powers.Add(VAMP_SLAVE)

	// TIER 5
	if(vamp.bloodtotal >= 900)
		if(!(VAMP_FULL in vamp.powers))
			vamp.powers.Add(VAMP_FULL)

	announce_new_power(old_powers, vamp.powers)

/mob/proc/announce_new_power(list/old_powers, list/new_powers)
	for(var/n in new_powers)
		if(!(n in old_powers))
			switch(n)
				if(VAMP_SHAPE)
					src << "<span class='notice'> You have gained the shapeshifting ability, at the cost of stored blood you can change your form permanently.</span>"
					verbs += /client/proc/vampire_shapeshift
				if(VAMP_VISION)
					src << "<span class='notice'> Your vampiric vision has improved.</span>"
					//no verb
				if(VAMP_DISEASE)
					src << "<span class='notice'> You have gained the Diseased Touch ability which causes those you touch to die shortly after unless treated medically.</span>"
					verbs += /client/proc/vampire_disease
				if(VAMP_CLOAK)
					src << "<span class='notice'> You have gained the Cloak of Darkness ability which when toggled makes you near invisible in the shroud of darkness.</span>"
					verbs += /client/proc/vampire_cloak
				if(VAMP_BATS)
					src << "<span class='notice'>You have gained the Summon Bats ability.</span>"
					verbs += /client/proc/vampire_bats // work in progress
				if(VAMP_SCREAM)
					src << "<span class='notice'> You have gained the Chriopteran Screech ability which stuns anything with ears in a large radius and shatters glass in the process.</span>"
					verbs += /client/proc/vampire_screech
				if(VAMP_JAUNT)
					src << "<span class='notice'> You have gained the Mist Form ability which allows you to take on the form of mist for a short period and pass over any obstacle in your path.</span>"
					verbs += /client/proc/vampire_jaunt
				if(VAMP_SLAVE)
					src << "<span class='notice'> You have gained the Turn ability which, at a heavy blood cost, allows you to infect a human with vampirism. He will NOT have to be loyal to you.</span>"
					verbs += /client/proc/vampire_turn
				if(VAMP_BLINK)
					src << "<span class='notice'> You have gained the ability to shadowstep, which makes you disappear into nearby shadows at the cost of blood.</span>"
					verbs += /client/proc/vampire_shadowstep
				if(VAMP_FULL)
					src << "<span class='notice'> You have reached your full potential and are no longer weak to the effects of anything holy and your vision has been improved greatly.</span>"
					//no verb

/datum/antagonist/vampire/remove_antagonist(var/datum/mind/player, var/show_message, var/implanted)
	player.current.remove_vampire_powers()
	..()

/mob/living/carbon/human/proc/check_sun()

	var/ax = x
	var/ay = y
//	var/mob/living/carbon/M = src

	for(var/i = 1 to 20)
		ax += sun.dx
		ay += sun.dy

		var/turf/T = locate( round(ax,0.5),round(ay,0.5),z)

		if(T.x == 1 || T.x==world.maxx || T.y==1 || T.y==world.maxy)
			break

		if(T.density)
			return
	if(prob(35))
		switch(health)
			if(80 to 100)
				src << "<span class='warning'> Your skin flakes away...</span>"
			if(60 to 80)
				src << "<span class='warning'>Your skin sizzles!</span>"
			if((-INFINITY) to 60)
				if(!on_fire)
					src << "<span class='danger'> Your skin burns!</span>"
				else
					src << "<span class='danger'> You continue to burn!</span>"
				fire_stacks += 5
				IgniteMob() //mobs on fire, woo!

		emote("scream")
	else
		switch(health)
			if((-INFINITY) to 60)
				fire_stacks++ //it's back!
				IgniteMob()

/mob/living/carbon/human/proc/handle_vampire()
//removed blood HUD code here, because of it causing Bad Things clientside, moved it to Status tab.
	handle_vampire_cloak()
	if(istype(loc, /turf/space))
		check_sun()
	mind.vampire.nullified = max(0, mind.vampire.nullified - 1)
