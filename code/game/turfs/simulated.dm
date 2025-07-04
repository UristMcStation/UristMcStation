/turf/simulated
	name = "station"
	var/wet = 0
	var/image/wet_overlay = null

	//Mining resources (for the large drills).
	var/has_resources
	var/list/resources

	var/thermite = 0
	initial_gas = list(GAS_OXYGEN = MOLES_O2STANDARD, GAS_NITROGEN = MOLES_N2STANDARD)
	var/to_be_destroyed = 0 //Used for fire, if a melting temperature was reached, it will be destroyed
	var/max_fire_temperature_sustained = 0 //The max temperature of the fire which it was subjected to
	var/dirt = 0

	var/timer_id

	zone_membership_candidate = TRUE

// This is not great.
/turf/simulated/proc/wet_floor(wet_val = 1, overwrite = FALSE)
	if(wet_val < wet && !overwrite)
		return

	if(!wet)
		wet = wet_val
		wet_overlay = image('icons/effects/water.dmi',src,"wet_floor")
		AddOverlays(wet_overlay)

	timer_id = addtimer(new Callback(src, PROC_REF(unwet_floor)), 8 SECONDS, TIMER_STOPPABLE|TIMER_UNIQUE|TIMER_NO_HASH_WAIT|TIMER_OVERRIDE)

/turf/simulated/proc/unwet_floor(check_very_wet = TRUE)
	if(check_very_wet && wet >= 2)
		wet--
		timer_id = addtimer(new Callback(src, PROC_REF(unwet_floor)), 8 SECONDS, TIMER_STOPPABLE|TIMER_UNIQUE|TIMER_NO_HASH_WAIT|TIMER_OVERRIDE)
		return

	wet = 0
	if(wet_overlay)
		CutOverlays(wet_overlay)
		wet_overlay = null

/turf/simulated/examine()
	. = ..()
	if(wet && (get_lumcount() >= 0.25))
		to_chat(usr, "<span class='warning'>It has a slight shimmer to it.</span>")

/turf/simulated/clean_blood()
	for(var/obj/decal/cleanable/blood/B in contents)
		B.clean_blood()
	..()

/turf/simulated/New()
	..()
	if(istype(loc, /area/chapel))
		holy = 1
	levelupdate()

/turf/simulated/proc/AddTracks(typepath,bloodDNA,comingdir,goingdir,bloodcolor=COLOR_BLOOD_HUMAN)
	var/obj/decal/cleanable/blood/tracks/tracks = locate(typepath) in src
	if(!tracks)
		tracks = new typepath(src)
	tracks.AddTracks(bloodDNA,comingdir,goingdir,bloodcolor)

/turf/simulated/proc/update_dirt()
	dirt = min(dirt+0.5, 101)
	var/obj/decal/cleanable/dirt/dirtoverlay = locate(/obj/decal/cleanable/dirt, src)
	if (dirt > 50)
		if (!dirtoverlay)
			dirtoverlay = new/obj/decal/cleanable/dirt(src)
		dirtoverlay.alpha = min((dirt - 50) * 5, 255)

/turf/simulated/remove_cleanables()
	dirt = 0
	. = ..()

/turf/simulated/Entered(atom/A, atom/OL)
	. = ..()
	if (istype(A,/mob/living))
		var/mob/living/M = A

		// Dirt overlays.
		update_dirt()

		if(istype(M, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = M
			// Tracking blood
			var/list/bloodDNA = null
			var/bloodcolor=""
			if(H.shoes)
				var/obj/item/clothing/shoes/S = H.shoes
				if(istype(S))
					S.handle_movement(src, MOVING_QUICKLY(H))
					if(S.blood_transfer_amount && S.blood_DNA)
						bloodDNA = S.blood_DNA
						bloodcolor = S.blood_color
						S.blood_transfer_amount--
			else
				if(H.track_blood && H.feet_blood_DNA)
					bloodDNA = H.feet_blood_DNA
					bloodcolor = H.feet_blood_color
					H.track_blood--

			if (bloodDNA && H.species.get_move_trail(H))
				src.AddTracks(H.species.get_move_trail(H),bloodDNA,H.dir,0,bloodcolor) // Coming
				var/turf/simulated/from = get_step(H,reverse_direction(H.dir))
				if(istype(from) && from)
					from.AddTracks(H.species.get_move_trail(H),bloodDNA,0,H.dir,bloodcolor) // Going

				bloodDNA = null

		if(M.lying)
			return

		if(src.wet)

			if(M.buckled || (!MOVING_QUICKLY(M) && prob(min(100, 100/(wet/10))) ) )
				return

			var/slip_dist = 1
			var/slip_stun = 6
			var/floor_type = "wet"

			if(2 <= src.wet) // Lube
				floor_type = "slippery"
				slip_dist = 4
				slip_stun = 10

			if(M.slip("the [floor_type] floor", slip_stun))
				addtimer(new Callback(M, TYPE_PROC_REF(/mob, slip_handler), M.dir, slip_dist - 1, 1), 1)


/mob/proc/slip_handler(dir, dist, delay)
	if (dist > 0)
		addtimer(new Callback(src, PROC_REF(slip_handler), dir, dist - 1, delay), delay)
	step(src, dir)

//returns 1 if made bloody, returns 0 otherwise
/turf/simulated/add_blood(mob/living/carbon/human/M as mob)
	if (!..())
		return 0

	if(istype(M))
		for(var/obj/decal/cleanable/blood/B in contents)
			if(!B.blood_DNA)
				B.blood_DNA = list()
			if(!B.blood_DNA[M.dna.unique_enzymes])
				B.blood_DNA[M.dna.unique_enzymes] = M.dna.b_type
			return 1 //we bloodied the floor
		blood_splatter(src,M.get_blood(M.vessel),1)
		return 1 //we bloodied the floor
	return 0

// Only adds blood on the floor -- Skie
/turf/simulated/proc/add_blood_floor(mob/living/carbon/M as mob)
	if( istype(M, /mob/living/carbon/alien ))
		var/obj/decal/cleanable/blood/xeno/this = new /obj/decal/cleanable/blood/xeno(src)
		this.blood_DNA["UNKNOWN BLOOD"] = "X*"
	else if( istype(M, /mob/living/silicon/robot ))
		new /obj/decal/cleanable/blood/oil(src)

/turf/simulated/proc/can_build_cable(mob/user)
	return 0

/turf/simulated/use_tool(obj/item/thing, mob/living/user, list/click_params)
	if(isCoil(thing) && can_build_cable(user))
		var/obj/item/stack/cable_coil/coil = thing
		coil.PlaceCableOnTurf(src, user)
		return TRUE
	return ..()

/turf/simulated/attack_hand(mob/living/user)
	. = ..()

	if (Adjacent(user))
		add_fingerprint(user)

	if (!get_max_health() || !ishuman(user) || user.a_intent != I_HURT)
		return

	var/mob/living/carbon/human/assailant = user
	var/datum/unarmed_attack/attack = assailant.get_unarmed_attack(src)
	if (!attack)
		return
	assailant.do_attack_animation(src)
	assailant.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	var/damage = attack.damage + rand(1,5)
	var/attack_verb = "[pick(attack.attack_verb)]"

	if (MUTATION_FERAL in user.mutations)
		attack_verb = "smashes"
		damage = 15

	playsound(src, damage_hitsound, 25, TRUE, -1)
	if (!can_damage_health(damage, attack.get_damage_type()))
		user.visible_message(
			SPAN_WARNING("\The [user] [attack_verb] \the [src], but doesn't even leave a dent!"),
			SPAN_WARNING("You [attack_verb] \the [src], but cause no visible damage and hurt yourself!")
		)
		if (!(MUTATION_FERAL in user.mutations))
			user.apply_damage(3, DAMAGE_BRUTE, user.hand ? BP_L_HAND : BP_R_HAND)
		return TRUE

	assailant.visible_message(
			SPAN_WARNING("\The [assailant] [attack_verb] \the [src]!"),
			SPAN_WARNING("You [attack_verb] \the [src]!")
			)
	damage_health(damage, attack.get_damage_type(), attack.damage_flags())
	return TRUE

/turf/simulated/Initialize()
	if(GAME_STATE >= RUNLEVEL_GAME)
		fluid_update()
	. = ..()

/turf/simulated/damage_health(damage, damage_type, damage_flags, severity, skip_can_damage_check = FALSE)
	if (HAS_FLAGS(damage_flags, DAMAGE_FLAG_TURF_BREAKER))
		damage *= 4
	. = ..()

/turf/simulated/verb/engrave()
	set name = "Engrave floor"
	set desc = "Writes a message on the floor."
	set category = "Object"
	set src in oview(1)

	var/obj/item/I = usr.get_active_hand()
	if(!I)
		to_chat(usr, "<span class='notice'>You aren't holding anything to write with.</span>")
		return

	if (!can_touch(usr))
		return

	try_graffiti(usr, I)
	return
