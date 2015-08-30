//This is the gamemode file for the ported goon gamemode vampires.
//They get a traitor objective and a blood sucking objective

var/global/list/datum/mind/vampires_list = list()
var/global/list/datum/mind/enthralled_list = list() //those controlled by a vampire
var/global/list/thrallslist = list() //vampires controlling somebody

/datum/game_mode/vampire
//	id = MODE_VAMPIRE
	role_type = BE_VAMPIRE
	role_text = "Vampire"
	role_text_plural = "Vampires"
	round_description = "There are Vampires from Space Transylvania on the station, keep your blood close and neck safe!"
	extended_round_description = "WIP."
	config_tag = "vampire"
	required_players = 1
	required_players_secret = 7
	required_enemies = 1
	end_on_antag_death = 1
	antag_scaling_coeff = 7.5

var/datum/antagonist/vampire/vampires
var/datum/antagonist/thrall/thralls

/datum/antagonist/thrall
	id = "thrall"
	role_text = "Thrall"
	role_text_plural = "Thralls"
	restricted_jobs = list("AI", "Cyborg", "Chaplain")
	protected_jobs = list() //not applicable
	welcome_text = "You have become a vampire's thrall. Follow their every command."
	flags = 0
	antag_indicator = "vampthrall"
	uristantag = 1

/datum/antagonist/thrall/New()
	..()
	thralls = src

/datum/antagonist/thrall/add_antagonist(var/datum/mind/player)
	if(!can_become_antag(player))
		return 0
	current_antagonists |= player
	player.special_role = "Thrall"
	update_icons_added(player)

/*/datum/antagonist/vampire
	id = MODE_VAMPIRE
	role_type = BE_VAMPIRE
	role_text = "Vampire"
	role_text_plural = "Vampires"
	bantype = "vampire"
	feedback_tag = "vampire_objective"
	restricted_jobs = list("AI", "Cyborg", "Chaplain")
	protected_jobs = list("Security Officer", "Warden", "Detective", "Head of Security", "Captain")
	welcome_text = "To bite someone, target the head and use harm intent with an empty hand. Drink blood to gain new powers. <br>You are weak to holy things and starlight. Don't go into space and avoid the Chaplain, the chapel and, especially, Holy Water."
	flags = ANTAG_SUSPICIOUS | ANTAG_RANDSPAWN | ANTAG_VOTABLE
	antag_indicator = "vampire"
	uristantag = 1*/

/datum/antagonist/vampire/New()
	..()
	vampires = src

///datum/antagonist/vampire/get_special_objective_text(var/datum/mind/player)
//	return //"<br><b>Real Name:</b> [player.real_name].

/datum/antagonist/vampire/create_objectives(var/datum/mind/vampire)
	if(!..())
		return

	var/datum/objective/blood/blood_objective = new
	blood_objective.owner = vampire
	blood_objective.gen_amount_goal(150, 400)
	vampire.objectives += blood_objective

	var/datum/objective/assassinate/kill_objective = new
	kill_objective.owner = vampire
	kill_objective.find_target()
	vampire.objectives += kill_objective

	var/datum/objective/steal/steal_objective = new
	steal_objective.owner = vampire
	steal_objective.find_target()
	vampire.objectives += steal_objective

	switch(rand(1,100))
		if(1 to 80)
			if (!(locate(/datum/objective/escape) in vampire.objectives))
				var/datum/objective/escape/escape_objective = new
				escape_objective.owner = vampire
				vampire.objectives += escape_objective
		else
			if (!(locate(/datum/objective/survive) in vampire.objectives))
				var/datum/objective/survive/survive_objective = new
				survive_objective.owner = vampire
				vampire.objectives += survive_objective
	return


/*/datum/game_mode/proc/auto_declare_completion_enthralled()
	if(enthralled.len)
		var/text = "<FONT size = 2><B>The Enthralled were:</B></FONT>"
		for(var/datum/mind/Mind in enthralled)
			text += "<br>[Mind.key] was [Mind.name] ("
			if(Mind.current)
				if(Mind.current.stat == DEAD)
					text += "died"
				else
					text += "survived"
				if(Mind.current.real_name != Mind.name)
					text += " as [Mind.current.real_name]"
			else
				text += "body destroyed"
			text += ")"
		world << text
	return 1*/



/datum/game_mode/proc/grant_vampire_powers(mob/living/carbon/vampire_mob)
	if(!istype(vampire_mob))	return
	vampire_mob.make_vampire()

/datum/vampire
	var/bloodtotal = 0
	var/bloodusable = 0
	var/mob/living/owner = null
	var/gender = FEMALE
	var/iscloaking = 0 // handles the vampire cloak toggle
	var/list/powers = list() // list of available powers and passives, see defines in setup.dm
	var/mob/living/carbon/human/draining // who the vampire is draining of blood
	var/nullified = 0 //Nullrod makes them useless for a short while.
/datum/vampire/New(gend = FEMALE)
	gender = gend

/mob/proc/make_vampire()
	if(!mind)				return
	if(!mind.vampire)
		mind.vampire = new /datum/vampire(gender)
		mind.vampire.owner = src
	verbs += /client/proc/vampire_rejuvinate
	verbs += /client/proc/vampire_hypnotise
	verbs += /client/proc/vampire_glare
	faction = "vampire"

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
				verbs += /client/proc/vampire_enthrall
			if(VAMP_FULL)
				continue
/mob/proc/remove_vampire_powers()

	verbs -= /client/proc/vampire_rejuvinate
	verbs -= /client/proc/vampire_hypnotise
	verbs -= /client/proc/vampire_glare
	verbs -= /client/proc/vampire_shapeshift
	verbs -= /client/proc/vampire_disease
	verbs -= /client/proc/vampire_cloak
	verbs -= /client/proc/vampire_bats
	verbs -= /client/proc/vampire_screech
	verbs -= /client/proc/vampire_jaunt
	verbs -= /client/proc/vampire_shadowstep
	verbs -= /client/proc/vampire_enthrall


/mob/proc/handle_bloodsucking(mob/living/carbon/human/H)
	src.mind.vampire.draining = H
	var/blood = 0
	var/bloodtotal = 0 //used to see if we increased our blood total
	var/bloodusable = 0 //used to see if we increased our blood usable
	src.attack_log += text("\[[time_stamp()]\] <font color='red'>Bit [H.name] ([H.ckey]) in the neck and started draining their blood</font>")
	H.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been bit in the neck by [src.name] ([src.ckey])</font>")
	log_attack("[src.name] ([src.ckey]) bit [H.name] ([H.ckey]) in the neck")
	src.visible_message("<span class='warning'><b>[src.name] bites [H.name]'s neck!<b>,</span>", "<span class='warning'><b>You bite [H.name]'s neck and begin to drain their blood.</span>", "<span class='notice'>You hear a soft puncture and a wet sucking noise</span>")
	if(!iscarbon(src))
		H.LAssailant = null
	else
		H.LAssailant = src
	while(do_mob(src, H, 50))
		if((!mind.vampire) || !(mind in vampires))
			src << "<span class='warning'> Your fangs have disappeared!</span>"
			return 0
		if(H.flags & NO_BLOOD)
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
			H.traumatic_shock += 2 // vampire bites suck, a long suckership will hurt the victim enough to knock them out
		else
			blood = min(5, H.vessel.get_reagent_amount("blood"))// The dead only give 5 bloods
			src.mind.vampire.bloodtotal += blood
		if(bloodtotal != src.mind.vampire.bloodtotal)
			src << "<span class='notice'> <b>You have accumulated [src.mind.vampire.bloodtotal] [src.mind.vampire.bloodtotal > 1 ? "units" : "unit"] of blood[src.mind.vampire.bloodusable != bloodusable ?", and have [src.mind.vampire.bloodusable] usable blood</span>" : "."]"
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
		//src << "\blue Your rejuvination abilities have improved and will now heal you over time when used."

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
	if(vamp.bloodtotal >= 600)
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
					src << "<span class='notice'> You have gained the Diseased Touch ability which causes those you touch to die shortly after unless treated medically."
					verbs += /client/proc/vampire_disease
				if(VAMP_CLOAK)
					src << "<span class='notice'> You have gained the Cloak of Darkness ability which when toggled makes you near invisible in the shroud of darkness."
					verbs += /client/proc/vampire_cloak
				if(VAMP_BATS)
					src << "<span class='notice'>You have gained the Summon Bats ability."
					verbs += /client/proc/vampire_bats // work in progress
				if(VAMP_SCREAM)
					src << "<span class='notice'> You have gained the Chriopteran Screech ability which stuns anything with ears in a large radius and shatters glass in the process.</span>"
					verbs += /client/proc/vampire_screech
				if(VAMP_JAUNT)
					src << "<span class='notice'> You have gained the Mist Form ability which allows you to take on the form of mist for a short period and pass over any obstacle in your path.</span>"
					verbs += /client/proc/vampire_jaunt
				if(VAMP_SLAVE)
					src << "<span class='notice'> You have gained the Enthrall ability which at a heavy blood cost allows you to enslave a human that is not loyal to any other for a random period of time.</span>"
					verbs += /client/proc/vampire_enthrall
				if(VAMP_BLINK)
					src << "<span class='notice'> You have gained the ability to shadowstep, which makes you disappear into nearby shadows at the cost of blood.</span>"
					verbs += /client/proc/vampire_shadowstep
				if(VAMP_FULL)
					src << "<span class='notice'> You have reached your full potential and are no longer weak to the effects of anything holy and your vision has been improved greatly.</span>"
					//no verb

/datum/game_mode/proc/update_vampire_icons_removed(datum/mind/vampire_mind)
	for(var/headref in thralls)
		var/datum/mind/head = locate(headref)
		for(var/datum/mind/t_mind in thralls[headref])
			if(t_mind.current)
				if(t_mind.current.client)
					for(var/image/I in t_mind.current.client.images)
						if((I.icon_state == "vampthrall" || I.icon_state == "vampire") && I.loc == vampire_mind.current)
							//world.log << "deleting [vampire_mind] overlay"
							del(I)
		if(head)
			//world.log << "found [head.name]"
			if(head.current)
				if(head.current.client)
					for(var/image/I in head.current.client.images)
						if((I.icon_state == "vampthrall" || I.icon_state == "vampire") && I.loc == vampire_mind.current)
							//world.log << "deleting [vampire_mind] overlay"
							del(I)
	if(vampire_mind.current)
		if(vampire_mind.current.client)
			for(var/image/I in vampire_mind.current.client.images)
				if(I.icon_state == "vampthrall" || I.icon_state == "vampire")
					del(I)

/datum/game_mode/proc/remove_vampire_mind(datum/mind/vampire_mind, datum/mind/head)
	if(!istype(head))
		head = vampire_mind //workaround for removing a thrall's control over the enthralled
	var/ref = "\ref[head]"
	if(ref in thralls)
		thralls[ref] -= vampire_mind
	enthralled -= vampire_mind
	vampire_mind.special_role = null
	update_vampire_icons_removed(vampire_mind)
	//world << "Removed [vampire_mind.current.name] from vampire shit"
	vampire_mind.current << "<span class='warning'> <FONT size = 3><B>The fog clouding your mind clears. You remember nothing from the moment you were enthralled until now.</B></FONT></span>"

/mob/living/carbon/human/proc/check_sun()

	var/ax = x
	var/ay = y
	var/mob/living/carbon/M = src

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
					src << "<b><span class='warning'> Your skin burns!</span></b>"
				else
					src << "<b>\red You continue to burn!</b>"
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
