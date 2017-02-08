//This should hold all the vampire related powers

/mob/proc/vampire_power(required_blood=0, max_stat=0)

	if(!src.mind)		return 0
	if(!ishuman(src))
		src << "<span class='warning'>You are in too weak of a form to do this!</span>"
		return 0

	var/datum/vampire/vampire = src.mind.vampire

	if(!vampire)
		world.log << "[src] has vampire verbs but isn't a vampire."
		return 0

	var/fullpower = (VAMP_FULL in vampire.powers)

	if(src.stat > max_stat)
		src << "<span class='warning'>You are incapacitated.</span>"
		return 0

	if(vampire.nullified)
		if(!fullpower)
			src << "<span class='warning'>Something is blocking your powers!</span>"
			return 0
	if(vampire.bloodusable < required_blood)
		src << "<span class='warning'>You require at least [required_blood] units of usable blood to do that!</span>"
		return 0
	//chapel check
	if(loc.holy)
		if(!fullpower)
			src << "<span class='warning'>Your powers are useless on this holy ground.</span>"
			return 0
	return 1

/mob/proc/vampire_affected(datum/mind/M)
	//Other vampires aren't affected
	if(mind && mind.vampire) return 0
	//Vampires who have reached their full potential can affect nearly everything
	if(M && M.vampire && (VAMP_FULL in M.vampire.powers))
		return 1
	//Chaplains are resistant to vampire powers
	if(mind && mind.assigned_role == "Chaplain")
		return 0
	return 1

/mob/proc/vampire_can_reach(mob/M as mob, active_range = 1)
	if(M.loc == src.loc) return 1 //target and source are in the same thing
	if(!isturf(src.loc) || !isturf(M.loc)) return 0 //One is inside, the other is outside something.
	if(Adjacent(M))//If a path exists, good!
		return 1
	return 0

/mob/proc/vampire_active(required_blood=0, max_stat=0, active_range=1)
	var/pass = vampire_power(required_blood, max_stat)
	if(!pass)								return
	var/datum/vampire/vampire = mind.vampire
	if(!vampire) return
	var/list/victims = list()
	for(var/mob/living/carbon/C in view(active_range))
		victims += C
	var/mob/living/carbon/T = input(src, "Victim?") as null|anything in victims

	if(!T) return
	if(!(T in view(active_range))) return
	if(!vampire_can_reach(T, active_range)) return
	if(!vampire_power(required_blood, max_stat)) return
	return T

/client/proc/vampire_coffinsleep() //because I don't like keeping hooks in life.dm for little reason.
	set category = "Vampire"
	set name = "Vampiric Torpor (Toggle)"
	set desc= "Enter a corpselike state that allows you to regenerate in coffins."
	var/datum/mind/M = usr.mind
	if(!M) return
	var/mob/living/carbon/human/H = M.current

	if(!M.vampire.torpor)
		M.vampire.torpor = 1
		H << "<span class='notice'>You are now entering torpor. For all intents and purposes, you will appear dead. You can wake up at any time, but you will be slightly drowsy briefly afterwards.</span>"
		H.status_flags |= FAKEDEATH		//play dead
	else
		M.vampire.torpor = 0
		H << "<span class='notice'>You are now waking up from your sleep.</span>"
		H.paralysis += 2 //as above
		H.status_flags &= ~(FAKEDEATH)
		H.update_canmove()
		H.drowsyness += 10 //so they don't spring back up immediately fully conscious

	do
		vampire_coffinregen(M)
		sleep(10)
	while(vampire_canregen(M))


/proc/vampire_canregen(var/datum/mind/V)
	var/mob/living/carbon/human/H = V.current
	if(V.vampire.torpor && ((istype(H.loc, /obj/structure/closet/coffin) || (istype(H.loc, /obj/structure/morgue))))
		if(H.getBruteLoss() || H.getFireLoss() || H.getOxyLoss() || H.getToxLoss())
			return 1
		for(var/obj/item/organ/I in H.internal_organs)
			if(I.damage > 0)
				return 1
		for(var/obj/item/organ/external/E in H.bad_external_organs)
			if ((E.status & (ORGAN_DEAD || ORGAN_MUTATED || ORGAN_CUT_AWAY || ORGAN_BROKEN))||(E.is_stump()))
				return 1
	else
		return 0

/proc/vampire_coffinregen(var/datum/mind/V)

	var/mob/living/carbon/human/H = V.current

	if((V.vampire.torpor) && (istype(H.loc, /obj/structure/closet/coffin)))
		//blatant edited copypasta from xenomorph in alien_species.dm
		var/heal_rate = 3
		var/mend_prob = 20

		//first heal damages
		if(H.getBruteLoss() || H.getFireLoss() || H.getOxyLoss() || H.getToxLoss())
			H.adjustBruteLoss(-heal_rate)
			H.adjustFireLoss(-heal_rate)
			H.adjustOxyLoss(-heal_rate)
			H.adjustToxLoss(-heal_rate)
			if (prob(5))
				H << "<span class='sinister'>You feel a soothing sensation come over you...</span>"
			return 0


		//next internal organs
		for(var/obj/item/organ/I in H.internal_organs)
			if(I.damage > 0)
				I.damage = max(I.damage - heal_rate, 0)
				if (prob(5))
					H << "<span class='sinister'>You feel a soothing sensation within your [I.parent_organ]...</span>"
				return 0


		//next mend broken bones, approx 10 ticks each
		for(var/obj/item/organ/external/E in H.bad_external_organs)
			if (E.status & ORGAN_BROKEN)
				if (prob(mend_prob))
					if (E.mend_fracture())
						H << "<span class='sinister'>You feel something mend itself inside your [E.name].</span>"
					return 0
			if ((E.status & (ORGAN_DEAD || ORGAN_MUTATED || ORGAN_CUT_AWAY))||(E.is_stump()))
				if (prob(round(mend_prob,1)))
					E.status = 0
					H << "<span class='sinister'>You feel your [E.name] regrow, completely intact.</span>"
	else
		return 1
	return



/client/proc/vampire_rejuvinate()
	set category = "Vampire"
	set name = "Rejuvenate "
	set desc= "Flush your system with spare blood to remove any incapacitating effects. Heals more powerful vampires slightly."
	var/datum/mind/M = usr.mind
	if(!M) return
	if(M.current.vampire_power(0, 1))
		M.current.weakened = 0
		M.current.stunned = 0
		M.current.paralysis = 0
		M.current << "<span class='notice'> You flush your system with clean blood and remove any incapacitating effects.</span>"
		spawn(1)
			if(M.vampire.bloodtotal >= 200)
				for(var/i = 0; i < 5; i++)
					M.current.adjustBruteLoss(-2)
					M.current.adjustOxyLoss(-5)
					M.current.adjustToxLoss(-2)
					M.current.adjustFireLoss(-2)
					sleep(35)
		M.current.verbs -= /client/proc/vampire_rejuvinate
		spawn(200)
			M.current.verbs += /client/proc/vampire_rejuvinate

/client/proc/vampire_hypnotise()
	set category = "Vampire"
	set name = "Hypnotise"
	set desc= "A piercing stare that incapacitates and memory-wipes your victim for a good length of time. Ahelp if your victim does not comply." //added the amnesia to clamp down on sucking dry. Ain't no fun for anybody. -scrdest
	var/datum/mind/M = usr.mind
	if(!M) return

	var/mob/living/carbon/C = M.current.vampire_active(0, 0, 1)

	if(!C) return
	if(C == M.current)
		M.current << "<span class='warning'>You try to stare into your own eyes. Oddly, it doesn't work.</span>"
		return

	M.current.visible_message("<span class='warning'>[M.current.name]'s eyes flash briefly as he stares into [C.name]'s eyes</span>")
	M.current.verbs -= /client/proc/vampire_hypnotise
	spawn(1800)
		M.current.verbs += /client/proc/vampire_hypnotise
	if(do_mob(M.current, C, 50))
		if(C.mind && C.mind.vampire)
			M.current << "<span class='warning'> Your piercing gaze fails to knock out [C.name].</span>"
			C << "<span class='notice'> [M.current.name]'s feeble gaze is ineffective.</span>"
			return
		else
			M.current << "<span class='warning'> Your piercing gaze knocks out [C.name].</span>"
			C << "<span class='warning'>You find yourself unable to move and barely able to speak, and you cannot seem to remember what happened to you just seconds ago.</span>"
			C.Weaken(20)
			C.Stun(20)
			C.stuttering = 20
		M.current.remove_vampire_blood(0)
	else
		M.current << "<span class='warning'> You broke your gaze.</span>"
		return

/client/proc/vampire_disease()
	set category = "Vampire"
	set name = "Diseased Touch (50)" //too useless to cost that much
	set desc = "Touches your victim with infected blood giving them the Shutdown Syndrome which quickly shutsdown their major organs resulting in a quick painful death."
	var/datum/mind/M = usr.mind
	if(!M) return

	var/mob/living/carbon/C = M.current.vampire_active(50, 0, 1)
	if(!C) return
	if(C == M.current)
		M.current << "<span class='warning'>You decide against infecting yourself with a deadly disease.</span>"
		return
	if(!M.current.vampire_can_reach(C, 1))
		M.current << "<span class='warning'> <b>You cannot touch [C.name] from where you are standing!</b></span>"
		return
	M.current << "<span class='warning'> You stealthily infect [C.name] with your diseased touch.</span>"

	C.help_shake_act(M.current) // i use da colon
	if(!C.vampire_affected(M))
		M.current << "<span class='warning'> They seem to be unaffected.</span>"
		return
	var/datum/disease2/disease/shutdown = new /datum/disease2/disease
	var/datum/disease2/effectholder/holder = new /datum/disease2/effectholder
	var/datum/disease2/effect/organs/vampire/O = new /datum/disease2/effect/organs/vampire
	holder.effect += O
	holder.chance = 10
	shutdown.infectionchance = 100
	shutdown.antigen |= text2num(pick(ALL_ANTIGENS))
	shutdown.antigen |= text2num(pick(ALL_ANTIGENS))
	shutdown.spreadtype = "None"
	shutdown.uniqueID = rand(0,10000)
	shutdown.effects += holder
	shutdown.speed = 1
	shutdown.stage = 2
	shutdown.clicks = 185
	infect_virus2(C,shutdown,0)
	M.current.remove_vampire_blood(50)
	M.current.verbs -= /client/proc/vampire_disease
	spawn(1800) M.current.verbs += /client/proc/vampire_disease

/client/proc/vampire_glare()
	set category = "Vampire"
	set name = "Glare"
	set desc= "A scary glare that incapacitates people for a short while around you."
	var/datum/mind/M = usr.mind
	if(!M) return
	if(M.current.vampire_power(0, 1))
		M.current.visible_message("<span class='warning'> <b>[M.current.name]'s eyes emit a blinding flash!</b></span>")
		M.current.verbs -= /client/proc/vampire_glare
		spawn(300)
			M.current.verbs += /client/proc/vampire_glare
		/*if(istype(M.current:glasses, /obj/item/clothing/glasses/sunglasses/blindfold))
			M.current << "<span class='warning'>You're blindfolded!</span>"
			return*/ //restore before merge
		for(var/mob/living/carbon/C in view(1))
			if(!C.vampire_affected(M)) continue
			if(!M.current.vampire_can_reach(C, 1)) continue
			if((C.eyecheck()) > 1) continue
			C.Stun(8)
			C.Weaken(8)
			C.stuttering = 20
			C << "<span class='warning'> You are blinded by [M.current.name]'s glare.</span>"

/client/proc/vampire_shapeshift()
	set category = "Vampire"
	set name = "Shapeshift"
	set desc = "Changes your name and appearance, has a cooldown of 3 minutes."
	var/datum/mind/M = usr.mind
	if(!M) return
	if(M.current.vampire_power(0, 0))
		M.current.visible_message("<span class='warning'>[M.current.name] transforms!</span>")
		M.current.client.prefs.real_name = random_name(M.current.gender)
		M.current.client.prefs.randomize_appearance_and_body_for(M.current)
		M.current.regenerate_icons()
		M.current.remove_vampire_blood(0)
		M.current.verbs -= /client/proc/vampire_shapeshift
		spawn(1800) M.current.verbs += /client/proc/vampire_shapeshift

/client/proc/vampire_screech()
	set category = "Vampire"
	set name = "Chiroptean Screech (30)"
	set desc = "An extremely loud shriek that stuns nearby humans and breaks windows as well."
	var/datum/mind/M = usr.mind
	if(!M) return
	if(M.current.vampire_power(30, 0))
		M.current.visible_message("<span class='warning'> [M.current.name] lets out an ear piercing shriek!</span>", "<span class='warning'> You let out a loud shriek.</span>", "<span class='warning'> You hear a loud, painful shriek!</span>")
		for(var/mob/living/carbon/C in hearers(4, M.current))
			if(C == M.current) continue
			if(ishuman(C) && C:is_on_ears(/obj/item/clothing/ears/earmuffs)) continue
			if(!C.vampire_affected(M)) continue
			C << "<span class='warning'><font size='3'><b>You hear a ear piercing shriek and your senses dull!</font></b></span>"
			C.Weaken(8)
			C.ear_deaf = 20
			C.stuttering = 20
			C.Stun(8)
			C.make_jittery(150)
		//sonic grenade code copypasta, more elegant than my method
		for(var/obj/structure/window/W in view(4, M.current.loc)) //Shatters windows
			W.hit(20,1)
			if(get_dist(W, M.current.loc) <= 3) //Reinf windows
				W.hit(60,0)
			if(get_dist(W, M.current.loc) <= 1)
				W.hit(40,0)
		for(var/obj/machinery/door/window/D in view(4, M.current.loc)) //Busting windoors
			D.take_damage(150)
			if(get_dist(D, M.current.loc) <= 2)
				D.take_damage(150)

		playsound(M.current.loc, 'sound/urist/creepyshriek.ogg', 100, 1)
		M.current.remove_vampire_blood(30)
		M.current.verbs -= /client/proc/vampire_screech
		spawn(1800) M.current.verbs += /client/proc/vampire_screech

/client/proc/vampire_turn()
	set category = "Vampire"
	set name = "Turn (500)"
	set desc = "Use a massive portion of your power to infect your victim with vampirism."
	var/datum/mind/M = usr.mind
	if(!M) return
	var/mob/living/carbon/C = M.current.vampire_active(300, 0, 1)
	if(!C) return
	if(C == M.current)
		M.current << ("<span class='warning'> Try as you might, you cannot figure out how to bite your own neck.</span>")
		return

	M.current.visible_message("<span class='warning'> [M.current.name] bites [C.name]'s neck!</span>", "<span class='warning'> You bite [C.name]'s neck and begin the flow of power.</span>")
	C << "<span class='sinister'>You feel the tendrils of evil invade your body.</span>"
	if(!ishuman(C))
		M.current << "<span class='warning'> You can only turn humanoids!</span>"
		return

	if(do_mob(M.current, C, 50))
		if(M.current.can_vampirize(C))
			if(M.current.vampire_power(500, 0)) // recheck
				if(M.current.handle_vampirize(C.mind))
					M.current.remove_vampire_blood(500)
					M.current.verbs -= /client/proc/vampire_turn
					spawn(1800) M.current.verbs += /client/proc/vampire_turn
				else
					M.current << "<span class='warning'> Something's wrong. You have fail to vampirize [C.key], even though you should be fully able to. Yell at coders.</span>"
			else
				M.current << "<span class='warning'> You don't have enough usable blood.</span>"
				return
		else
			M.current << "<span class='warning'> Target is unavailable.</span>"
			return



/client/proc/vampire_cloak()
	set category = "Vampire"
	set name = "Cloak of Darkness (toggle)"
	set desc = "Toggles whether you are currently cloaking yourself in darkness."
	var/datum/mind/M = usr.mind
	if(!M) return
	if(M.current.vampire_power(0, 0))
		M.vampire.iscloaking = !M.vampire.iscloaking
		M.current << "<span class='notice'> You will now be [M.vampire.iscloaking ? "hidden" : "seen"] in darkness.</span>"

/mob/proc/handle_vampire_cloak()
	if(!mind || !mind.vampire || !ishuman(src))
		alpha = 255
		return

	var/light_amount = 0
	if(isturf(src.loc))
		var/turf/T = src.loc
		light_amount = get_light_amt(T)

//	if(!istype(T))
//		return 0

	if(!mind.vampire.iscloaking)
		alpha = 255
		return 0
	if(light_amount <= 2)
		alpha = 10
		return 1
	else
		alpha = round((255 * 0.80))

/mob/proc/can_vampirize(mob/living/carbon/C)
	var/vampirize_safe = 0

	if(!C)
		world.log << "something bad happened on vampirizing a mob src is [src] [src.key] \ref[src]"
		return 0
	if(!C.mind)
		src << "<span class='warning'> [C.name]'s mind is not there for you to vampirize.</span>"
		return 0
	if(vampirize_safe)
		C.visible_message("<span class='warning'> [C] seems to resist the infection!</span>", "<span class='notice'> You feel a strange sensation in your skull that quickly dissipates.</span>")
		return 0
	if((C.mind in get_antags("vampire") )||( C.mind.vampire ))
		C.visible_message("<span class='warning'> [C] seems to resist the infection!</span>", "<span class='notice'> You feel a familiar sensation in your skull that quickly dissipates.</span>")
		return 0
	if(!C.vampire_affected(mind))
		C.visible_message("<span class='warning'> [C] seems to resist the infection!</span>", "<span class='notice'> Your faith of [ticker.Bible_deity_name] has kept your mind clear of all evil</span>")
	if(!ishumanoid(C))
		C.visible_message("<span class='warning'> [C] seems unaffected by the infection!</span>","<span class='notice'> Your simple mind briefly registers an undescribable sensation, but it quickly dissipates among your usual concerns.</span>")
		return 0
	return 1

/mob/proc/handle_vampirize(var/datum/mind/H)
	if(!istype(H))
		src << "<b><span class='warning'> SOMETHING WENT WRONG, YELL AT SCRDEST OR GLLOYD</span></b>"
		return 0

	if(vamps.add_antagonist(H,1,0,0,1,1))
		H.current << "<span class='sinister'> World seems to screech to a halt as an otherworldly presence takes root in your mind... a flash of pain from your gums brings you back to your senses as you notice two sharp fangs growing in your mouth. [name] has turned you into a vampire!</span>"
		src << "<span class='warning'> You have successfully vampirized [H.current.name].</span>"
		log_admin("[ckey(src.key)] has turned [ckey(H.key)] into a vampire.")
		return 1
	else
		log_admin("add_antagonist failed while vampirizing [H.key] ([ckey(H.key)]), relay to a coder please")
		return 0

/client/proc/vampire_bats()
	set category = "Vampire"
	set name = "Summon Bats (75)"
	set desc = "You summon a pair of space bats who attack nearby targets until they or their target is dead."
	var/datum/mind/M = usr.mind
	if(!M) return
	if(M.current.vampire_power(75, 0))
		var/list/turf/locs = new
		var/number = 0
		for(var/direction in alldirs) //looking for bat spawns
			if(locs.len == 2) //we found 2 locations and thats all we need
				break
			var/turf/T = get_step(M.current,direction) //getting a loc in that direction
			if(AStar(M.current.loc, T, /turf/proc/AdjacentTurfs, /turf/proc/Distance, 1)) // if a path exists, so no dense objects in the way its valid salid
				locs += T
		if(locs.len)
			for(var/turf/tospawn in locs)
				number++
				new /mob/living/simple_animal/hostile/scarybat(tospawn, M.current)
			if(number != 2) //if we only found one location, spawn one on top of our tile so we dont get stacked bats
				new /mob/living/simple_animal/hostile/scarybat(M.current.loc, M.current)
		else // we had no good locations so make two on top of us
			new /mob/living/simple_animal/hostile/scarybat(M.current.loc, M.current)
			new /mob/living/simple_animal/hostile/scarybat(M.current.loc, M.current)
		M.current.remove_vampire_blood(75)
		M.current.verbs -= /client/proc/vampire_bats
		spawn(1200) M.current.verbs += /client/proc/vampire_bats

/client/proc/vampire_jaunt()
	//AHOY COPY PASTE INCOMING
	set category = "Vampire"
	set name = "Mist Form (15)" //leaving it with a cost to make shadowstep less useless
	set desc = "You take on the form of mist for a short period of time."
	var/jaunt_duration = 50 //in deciseconds
	var/datum/mind/M = usr.mind
	if(!M) return

	if(usr.z == 2)
		return 0

	else if(M.current.vampire_power(15, 0))
		if(M.current.buckled) M.current.buckled.unbuckle_mob()
		spawn(0)
			var/mobloc = get_turf(M.current.loc)
			var/obj/effect/dummy/spell_jaunt/holder = new /obj/effect/dummy/spell_jaunt( mobloc )
			var/atom/movable/overlay/animation = new /atom/movable/overlay( mobloc )
			animation.name = "water"
			animation.density = 0
			animation.anchored = 1
			animation.icon = 'icons/mob/mob.dmi'
			animation.icon_state = "liquify"
			animation.layer = 5
			animation.master = holder
			M.current.ExtinguishMob()
			if(M.current.buckled)
				M.current.buckled.unbuckle_mob()
			flick("liquify",animation)
			M.current.loc = holder
			M.current.client.eye = holder
			var/datum/effect/effect/system/steam_spread/steam = new /datum/effect/effect/system/steam_spread()
			steam.set_up(10, 0, mobloc)
			steam.start()
			sleep(jaunt_duration)
			mobloc = get_turf(M.current.loc)
			animation.loc = mobloc
			steam.location = mobloc
			steam.start()
			M.current.canmove = 0
			sleep(20)
			flick("reappear",animation)
			sleep(5)
			if(!M.current.Move(mobloc))
				for(var/direction in list(1,2,4,8,5,6,9,10))
					var/turf/T = get_step(mobloc, direction)
					if(T)
						if(M.current.Move(T))
							break
			M.current.canmove = 1
			M.current.client.eye = M.current
			qdel(animation)
			qdel(holder)
		M.current.remove_vampire_blood(15)
		M.current.verbs -= /client/proc/vampire_jaunt
		spawn(600) M.current.verbs += /client/proc/vampire_jaunt

// Blink for vamps
// Less smoke spam.
/client/proc/vampire_shadowstep()
	set category = "Vampire"
	set name = "Shadowstep"
	set desc = "Vanish into the shadows."
	var/datum/mind/M = usr.mind
	if(!M) return

	// Teleport radii
	var/inner_tele_radius = 0
	var/outer_tele_radius = 6

	// Maximum light_amount
	var/max_lum = 1

	if(M.current.vampire_power(0, 0))
		if(M.current.buckled) M.current.buckled.unbuckle_mob()
		spawn(0)
			var/list/turfs = new/list()
			for(var/turf/T in range(outer_tele_radius, usr))
				if(T in range(inner_tele_radius, usr)) continue
				if(istype(T,/turf/space)) continue
				if(T.density) continue
				if(T.x>world.maxx-outer_tele_radius || T.x<outer_tele_radius)	continue	//putting them at the edge is dumb
				if(T.y>world.maxy-outer_tele_radius || T.y<outer_tele_radius)	continue

				if(!(shadow_check(T, max_lum))) continue
				turfs += T

			if(!turfs.len)
				usr << "<span class='warning'> You cannot find darkness to step to.</span>"
				return

			var/turf/picked = pick(turfs)

			if(!picked || !isturf(picked))
				return
			M.current.ExtinguishMob()
			if(M.current.buckled)
				M.current.buckled.unbuckle_mob()
			var/atom/movable/overlay/animation = new /atom/movable/overlay( get_turf(usr) )
			animation.name = usr.name
			animation.density = 0
			animation.anchored = 1
			animation.icon = usr.icon
			animation.alpha = 127
			animation.layer = 5
			//animation.master = src
			usr.forceMove(picked)
			spawn(10)
				qdel(animation)
		M.current.remove_vampire_blood(0)
		M.current.verbs -= /client/proc/vampire_shadowstep
		spawn(20)
			M.current.verbs += /client/proc/vampire_shadowstep

/mob/proc/remove_vampire_blood(amount = 0)
	var/bloodold
	if(!mind || !mind.vampire)
		return
	bloodold = mind.vampire.bloodusable
	mind.vampire.bloodusable = max(0, (mind.vampire.bloodusable - amount))
	if(bloodold != mind.vampire.bloodusable)
		src << "<span class='notice'> <b>You have [mind.vampire.bloodusable] left to use.</b></span>"
