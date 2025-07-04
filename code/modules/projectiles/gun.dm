/*
	Defines a firing mode for a gun.

	A firemode is created from a list of fire mode settings. Each setting modifies the value of the gun var with the same name.
	If the fire mode value for a setting is null, it will be replaced with the initial value of that gun's variable when the firemode is created.
	Obviously not compatible with variables that take a null value. If a setting is not present, then the corresponding var will not be modified.
*/
/datum/firemode
	var/name = "default"
	var/list/settings = list()
	var/list/original_settings

/datum/firemode/New(obj/item/gun/gun, list/properties = null)
	..()
	if(!properties) return

	for(var/propname in properties)
		var/propvalue = properties[propname]

		if(propname == "mode_name")
			name = propvalue
		else if(isnull(propvalue))
			settings[propname] = gun.vars[propname] //better than initial() as it handles list vars like burst_accuracy
		else
			settings[propname] = propvalue

/datum/firemode/proc/apply_to(obj/item/gun/gun)
	LAZYINITLIST(original_settings)

	for(var/propname in settings)
		original_settings[propname] = gun.vars[propname]
		gun.vars[propname] = settings[propname]

/datum/firemode/proc/restore_original_settings(obj/item/gun/gun)
	if (LAZYLEN(original_settings))
		for (var/propname in original_settings)
			gun.vars[propname] = original_settings[propname]

		LAZYCLEARLIST(original_settings)

//Parent gun type. Guns are weapons that can be aimed at mobs and act over a distance
/obj/item/gun
	name = "gun"
	desc = "Its a gun. It's pretty terrible, though."
	icon = 'icons/obj/guns/gui.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/onmob/items/lefthand_guns.dmi',
		slot_r_hand_str = 'icons/mob/onmob/items/righthand_guns.dmi',
		)
	item_state = "gun"
	obj_flags =  OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	matter = list(MATERIAL_STEEL = 2000)
	w_class = ITEM_SIZE_NORMAL
	throwforce = 5
	throw_speed = 4
	throw_range = 5
	force = 5
	origin_tech = list(TECH_COMBAT = 1)
	attack_verb = list("struck", "hit", "bashed")
	zoomdevicename = "scope"
	waterproof = FALSE

	var/burst = 1
	/// Checks if the gun will continue firing if the mouse button is held down.
	var/can_autofire = FALSE
	/// Delay after shooting before the gun can be used again. Cannot be less than [burst_delay+1].
	var/fire_delay = 6
	/// Delay between shots, if firing in bursts.
	var/burst_delay = 2
	var/move_delay = 1
	/// Sound this gun makes when firing. Overridden by projectiles with their own sounds.
	var/fire_sound = 'sound/weapons/gunshot/gunshot.ogg'
	var/fire_sound_text = "gunshot"
	var/fire_sound_vary = TRUE
	var/fire_anim = null
	/// The amount your screen shakes when firing. Shouldn't be greater than 2 unless zoomed.
	var/screen_shake = 0
	/// Whether or not this weapon moves the shooter backwards when fired in space.
	var/space_recoil = 0
	var/silenced = FALSE
	/// Accuracy is measured in tiles. +1 accuracy means that everything is effectively one tile closer for the purpose of miss chance, -1 means the opposite. launchers are not supported, at the moment.
	var/accuracy = 0
	/// Increase of to-hit chance per 1 point of accuracy.
	var/accuracy_power = 5
	/// How unwieldy this weapon for its size, affects accuracy when fired without aiming.
	var/bulk = 0
	/// Time when hand gun's in became active, for purposes of aiming bonuses.
	var/last_handled
	/// Accuracy used when zoomed in a scope. Not additive.
	var/scoped_accuracy = null
	/// How far this weapon's scope can see.
	var/scope_zoom = 0
	var/can_dual_wield = 0
	var/dual_wield_penalty = 4 // by default dual wielding reduces accuracy by 25%
	var/list/burst_accuracy = list(0) //allows for different accuracies for each shot in a burst. Applied on top of accuracy
	var/list/dispersion = list(0)
	var/one_hand_penalty
	var/wielded_item_state
	/// Whether it creates hotspot when fired.
	var/combustion
	var/next_fire_time = 0

	/// Index of the currently selected mode.
	var/sel_mode = 1
	var/list/firemodes = list()
	var/selector_sound = 'sound/weapons/guns/selector.ogg'

	//Aiming system stuff
	/// 1 for "keep shooting until aim is lowered", 0 for "one bullet after target moves and aim is lowered".
	var/keep_aim = 1
	/// Used to determine if you can target multiple people.
	var/multi_aim = 0
	/// List of who you are targeting.
	var/list/mob/living/aim_targets
	/// Used to fire faster at more than one person.
	var/mob/living/last_moved_mob
	/// So that it doesn't spam them with the fact they cannot hit them.
	var/told_cant_shoot = 0
	var/lock_time = -100
	var/last_safety_check = -INFINITY
	var/safety_state = 1
	var/has_safety = TRUE
	/// Overlay to apply to gun based on safety state, if any.
	var/safety_icon

/obj/item/gun/Initialize()
	. = ..()
	for(var/i in 1 to length(firemodes))
		firemodes[i] = new /datum/firemode(src, firemodes[i])

	if(isnull(scoped_accuracy))
		scoped_accuracy = accuracy

	if(scope_zoom)
		verbs += /obj/item/gun/proc/scope

	if(length(firemodes))
		var/datum/firemode/new_mode = firemodes[sel_mode]
		new_mode.apply_to(src)

/obj/item/gun/on_update_icon()
	var/mob/living/M = loc
	ClearOverlays()
	if(istype(M))
		if(wielded_item_state)
			if(M.can_wield_item(src) && src.is_held_twohanded(M))
				item_state_slots[slot_l_hand_str] = wielded_item_state
				item_state_slots[slot_r_hand_str] = wielded_item_state
			else
				item_state_slots[slot_l_hand_str] = initial(item_state)
				item_state_slots[slot_r_hand_str] = initial(item_state)

//Checks whether a given mob can use the gun
//Any checks that shouldn't result in handle_click_empty() being called if they fail should go here.
//Otherwise, if you want handle_click_empty() to be called, check in consume_next_projectile() and return null there.
/obj/item/gun/proc/special_check(mob/user)

	if(!istype(user, /mob/living))
		return 0
	if(!user.IsAdvancedToolUser())
		return 0
	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		if(istype(H.wear_suit,/obj/item/clothing/suit/space/changeling/armored) && !istype(src,/obj/item/gun/projectile/changeling))
			to_chat(user,SPAN_WARNING("This form is too bulky to make use of the trigger guard!"))
			return FALSE
	var/mob/living/M = user
	if((MUTATION_CLUMSY in M.mutations) && prob(40)) //Clumsy handling
		var/obj/P = consume_next_projectile()
		if(P)
			if(process_projectile(P, user, user, pick(BP_L_FOOT, BP_R_FOOT)))
				handle_post_fire(user, user)
				var/datum/pronouns/pronouns = user.choose_from_pronouns()
				user.visible_message(
					SPAN_DANGER("\The [user] shoots [pronouns.self] in the foot with \the [src]!"),
					SPAN_DANGER("You shoot yourself in the foot with \the [src]!")
					)
				M.unequip_item()
		else
			handle_click_empty(user)
		return 0
	return 1

/obj/item/gun/emp_act(severity)
	for(var/obj/O in contents)
		O.emp_act(severity)
	..()

/obj/item/gun/proc/check_dual_wield(atom/A, mob/living/user, params)
	var/obj/item/gun/G = user.get_inactive_hand()
	if(can_dual_wield && G.can_dual_wield)
		if(w_class <= ITEM_SIZE_SMALL && G.w_class <= ITEM_SIZE_SMALL)
			Fire(A,user,params, dual_wield=1)
			user.swap_hand()
		else
			Fire(A,user,params) //Otherwise, fire normally.
	else
		Fire(A,user,params)

/obj/item/gun/afterattack(atom/A, mob/living/user, adjacent, params)
	if(adjacent) return //A is adjacent, is the user, or is on the user's person

	if(!user.aiming)
		user.aiming = new(user)

	if(user && user.client && user.aiming && user.aiming.active && user.aiming.aiming_at != A)
		PreFire(A,user,params) //They're using the new gun system, locate what they're aiming at.
		return

	var/obj/item/I = user.get_inactive_hand()

	if(user && user.a_intent == I_HELP) //regardless of what happens, refuse to shoot if help intent is on
		to_chat(user, "<span class='warning'>You refrain from firing \the [src] as your intent is set to help.</span>")
	else if(istype(I, /obj/item/gun)) //DUAL WIELDING
		check_dual_wield(A, user, params)
	else
		Fire(A,user,params) //Otherwise, fire normally.

/obj/item/gun/use_before(atom/target, mob/living/user, click_parameters)
	// Suicide check
	var/suicide = FALSE
	if (user == target)
		suicide = TRUE
		if (user.zone_sel.selecting == BP_MOUTH && (!user.aiming?.active))
			user.toggle_gun_mode()

	// Aim mode override
	if (user.aiming?.active)
		if (user.aiming.aiming_at != target)
			var/checkperm
			if (suicide)
				if (!GET_FLAGS(user.aiming.target_permissions, TARGET_CAN_CLICK))
					user.aiming.toggle_permission(TARGET_CAN_CLICK, TRUE)
					checkperm = TRUE
			PreFire(target, user)
			if (checkperm)
				addtimer(new Callback(user.aiming, TYPE_PROC_REF(/obj/aiming_overlay, toggle_permission), TARGET_CAN_CLICK, TRUE), 1)
		else
			if (suicide && user.zone_sel.selecting == BP_MOUTH && istype(user, /mob/living/carbon/human))
				handle_suicide(user)
			else
				Fire(target, user, pointblank = TRUE)
		return TRUE

	// Point blank shooting
	if (user.a_intent == I_HURT && !user.isEquipped(target))
		Fire(target, user, pointblank = TRUE)
		return TRUE

	return ..()


/obj/item/gun/dropped(mob/living/user)
	update_icon()
	return ..()

/obj/item/gun/proc/Fire(atom/target, mob/living/user, clickparams, pointblank=0, reflex=0, dual_wield=0)
	if(!user || !target) return
	if(target.z != user.z) return

	add_fingerprint(user)

	if((!waterproof && submerged()) || !special_check(user))
		return

	if(world.time < next_fire_time)
		if (world.time % 3) //to prevent spam
			to_chat(user, SPAN_WARNING("[src] is not ready to fire again!"))
		return

	var/shoot_time = (burst - 1)* burst_delay
	user.setClickCooldown(shoot_time) //no clicking on things while shooting
	user.SetMoveCooldown(shoot_time) //no moving while shooting either
	next_fire_time = world.time + shoot_time

	var/held_twohanded = (user.can_wield_item(src) && src.is_held_twohanded(user))

	//actually attempt to shoot
	var/turf/targloc = get_turf(target) //cache this in case target gets deleted during shooting, e.g. if it was a securitron that got destroyed.
	for(var/i in 1 to burst)
		var/obj/projectile = consume_next_projectile(user)
		if(!projectile)
			handle_click_empty(user)
			break

		process_accuracy(projectile, user, target, i, held_twohanded, dual_wield)

		if(pointblank)
			process_point_blank(projectile, user, target)

		if(process_projectile(projectile, user, target, user.zone_sel?.selecting, clickparams))
			handle_post_fire(user, target, pointblank, reflex, projectile)
			update_icon()

		if(i < burst)
			sleep(burst_delay)

		if(!(target && target.loc))
			target = targloc
			pointblank = 0

	//update timing
	var/delay = max(burst_delay+1, fire_delay)
	user.setClickCooldown(min(delay, DEFAULT_QUICK_COOLDOWN))
	user.SetMoveCooldown(move_delay)
	next_fire_time = world.time + delay

//obtains the next projectile to fire
/obj/item/gun/proc/consume_next_projectile()
	return null

//used by aiming code
/obj/item/gun/proc/can_hit(atom/target as mob, mob/living/user as mob)
	if(!special_check(user))
		return 2
	//just assume we can shoot through glass and stuff. No big deal, the player can just choose to not target someone
	//on the other side of a window if it makes a difference. Or if they run behind a window, too bad.
	return check_trajectory(target, user) == target

//called if there was no projectile to shoot
/obj/item/gun/proc/handle_click_empty(mob/user)
	if (user)
		user.visible_message("*click click*", SPAN_DANGER("*click*"))
	else
		src.visible_message("*click click*")
	playsound(src.loc, 'sound/weapons/empty.ogg', 100, 1)

/obj/item/gun/proc/handle_click_safety(mob/user)
	user.visible_message(SPAN_WARNING("[user] squeezes the trigger of \the [src] but it doesn't move!"), SPAN_WARNING("You squeeze the trigger but it doesn't move!"), range = 3)

//called after successfully firing
/obj/item/gun/proc/handle_post_fire(mob/user, atom/target, pointblank = 0, reflex = 0, obj/projectile, dual_wield=0)
	if(fire_anim)
		flick(fire_anim, src)

	if (user)
		var/user_message = SPAN_DANGER("You fire \the [src][pointblank ? " point blank":""] at \the [target][reflex ? " by reflex" : ""]!")
		if (silenced)
			to_chat(user, user_message)
		else
			user.visible_message(
				SPAN_DANGER("\The [user] fires \the [src][pointblank ? " point blank":""] at \the [target][reflex ? " by reflex" : ""]!"),
				user_message,
				SPAN_DANGER("You hear a [fire_sound_text]!")
			)

		if (pointblank)
			admin_attack_log(user, target,
				"shot point blank with \a [type]",
				"shot point blank with \a [type]",
				"shot point blank (\a [type])"
			)

		if(one_hand_penalty)
			if(!src.is_held_twohanded(user))
				switch(one_hand_penalty)
					if(4 to 6)
						if(prob(50)) //don't need to tell them every single time
							to_chat(user, SPAN_WARNING("Your aim wavers slightly."))
					if(6 to 8)
						to_chat(user, SPAN_WARNING("You have trouble keeping \the [src] on target with just one hand."))
					if(8 to INFINITY)
						to_chat(user, SPAN_WARNING("You struggle to keep \the [src] on target with just one hand!"))
			else if(!user.can_wield_item(src))
				switch(one_hand_penalty)
					if(4 to 6)
						if(prob(50)) //don't need to tell them every single time
							to_chat(user, SPAN_WARNING("Your aim wavers slightly."))
					if(6 to 8)
						to_chat(user, SPAN_WARNING("You have trouble holding \the [src] steady."))
					if(8 to INFINITY)
						to_chat(user, SPAN_WARNING("You struggle to hold \the [src] steady!"))

		if(screen_shake)
			spawn()
				shake_camera(user, screen_shake+1, screen_shake)

	if(combustion)
		var/turf/curloc = get_turf(src)
		if(curloc)
			curloc.hotspot_expose(700)

	if(istype(user,/mob/living/carbon/human) && user.is_cloaked()) //shooting will disable a rig cloaking device
		var/mob/living/carbon/human/H = user
		if(istype(H.back,/obj/item/rig))
			var/obj/item/rig/R = H.back
			for(var/obj/item/rig_module/stealth_field/S in R.installed_modules)
				S.deactivate()

	if(space_recoil && !user.check_space_footing())
		var/old_dir = user.dir
		var/mob/living/carbon/human/H = user
		var/obj/item/tank/jetpack/jetpack = H.get_jetpack()
		if(jetpack && !jetpack.stabilization_on)
			user.inertia_ignore = projectile
			step(user,get_dir(target,user))
			user.set_dir(old_dir)


	update_icon()


/obj/item/gun/proc/process_point_blank(obj/projectile, mob/user, atom/target)
	var/obj/item/projectile/P = projectile
	if(!istype(P))
		return //default behaviour only applies to true projectiles

	//default point blank multiplier
	var/max_mult = 1

	//determine multiplier due to the target being grabbed
	if(isliving(target))
		var/mob/living/L = target
		if(L.incapacitated())
			max_mult = 1.2
		for(var/obj/item/grab/G in L.grabbed_by)
			max_mult = max(max_mult, G.point_blank_mult())
	P.damage *= max_mult

/obj/item/gun/proc/process_accuracy(obj/projectile, mob/living/user, atom/target, burst, held_twohanded, dual_wield)
	var/obj/item/projectile/P = projectile
	if(!istype(P))
		return //default behaviour only applies to true projectiles

	var/acc_mod = burst_accuracy[min(burst, length(burst_accuracy))]
	var/disp_mod = dispersion[min(burst, length(dispersion))]
	var/stood_still = last_handled
	//Not keeping gun active will throw off aim (for non-Masters)
	stood_still = min(user.l_move_time, last_handled)

	stood_still = max(0,round((world.time - stood_still)/10) - 1)
	if(stood_still)
		acc_mod += min(max(3, accuracy), stood_still)
	else
		acc_mod -= w_class - ITEM_SIZE_NORMAL
		acc_mod -= bulk

	if(one_hand_penalty >= 4 && !held_twohanded)
		acc_mod -= one_hand_penalty/2
		disp_mod += one_hand_penalty*0.5 //dispersion per point of two-handedness

	if(dual_wield)
		acc_mod -= dual_wield_penalty/2
		disp_mod += dual_wield_penalty*0.5

	//accuracy bonus from aiming
	if (aim_targets && (target in aim_targets))
		//If you aim at someone beforehead, it'll hit more often.
		//Kinda balanced by fact you need like 2 seconds to aim
		//As opposed to no-delay pew pew
		acc_mod += 2

	acc_mod += user.ranged_accuracy_mods()
	acc_mod += accuracy
	P.hitchance_mod = accuracy_power*acc_mod
	P.dispersion = disp_mod

//does the actual launching of the projectile
/obj/item/gun/proc/process_projectile(obj/projectile, mob/user, atom/target, target_zone, params=null)
	var/obj/item/projectile/P = projectile
	if(!istype(P))
		return 0 //default behaviour only applies to true projectiles

	if(params)
		P.set_clickpoint(params)

	//shooting while in shock
	var/x_offset = 0
	var/y_offset = 0
	if(istype(user, /mob/living/carbon/human))
		var/mob/living/carbon/human/mob = user
		if(mob.shock_stage > 120)
			y_offset = rand(-2,2)
			x_offset = rand(-2,2)
		else if(mob.shock_stage > 70)
			y_offset = rand(-1,1)
			x_offset = rand(-1,1)

	var/launched = !P.launch_from_gun(target, user, src, target_zone, x_offset, y_offset)

	if(launched)
		play_fire_sound(user,P)

	return launched


/obj/item/gun/proc/play_fire_sound(mob/user, obj/item/projectile/projectile)
	var/sound = fire_sound
	if (istype(projectile) && projectile.fire_sound)
		sound = projectile.fire_sound
	if (islist(sound))
		sound = pick(sound)
	var/volume = 50
	if (silenced)
		volume = 10
	playsound(src, sound, volume, fire_sound_vary)


//Suicide handling.
/obj/item/gun/proc/handle_suicide(mob/living/user)
	var/mob/living/carbon/human/M = user
	if ((!waterproof && submerged()) || !special_check(M))
		return
	if (world.time < next_fire_time)
		if (world.time % 3)
			to_chat(M, SPAN_WARNING("\The [src] is not ready to fire again!"))
		return
	M.setClickCooldown((burst - 1) * burst_delay)
	next_fire_time = world.time + max(burst_delay + 1, fire_delay)

	last_safety_check = world.time
	admin_attacker_log(M, "is trying to commit suicide with \a [src]")
	user.visible_message(SPAN_WARNING("\The [M] pulls the trigger."))
	to_chat(M, SPAN_NOTICE("You feel \the [src] go off..."))

	var/obj/item/organ/brain = M.internal_organs_by_name[BP_BRAIN] || M.internal_organs_by_name[BP_POSIBRAIN]
	var/bodypart = brain.parent_organ
	if (brain.parent_organ == BP_HEAD)
		bodypart = BP_MOUTH
	var/obj/item/blocked = M.get_clothing_coverage(bodypart)

	for (var/i = 1 to burst)
		var/obj/item/projectile/in_chamber = consume_next_projectile()
		if (!in_chamber)
			handle_click_empty(M)
			break
		play_fire_sound(M, in_chamber)

		if (in_chamber.damage_type != DAMAGE_PAIN)
			in_chamber.on_hit(M, 0, brain.parent_organ)
			if (istype(in_chamber, /obj/item/projectile/ion))
				in_chamber.on_impact(M)
			if (in_chamber.damage != 0)
				M.apply_damage(in_chamber.damage * 2, in_chamber.damage_type, brain.parent_organ, in_chamber.damage_flags(), used_weapon = "Point blank shot in the mouth with \a [in_chamber]")
				var/dmgmultiplier
				if (prob (95))
					dmgmultiplier = rand(30, 50) / 10
				else
					dmgmultiplier = 0.5
				if (blocked)
					to_chat(M, SPAN_WARNING("A clear shot to your [bodypart] is blocked by the [blocked], significantly reducing damage to \the [brain.name]!"))
					dmgmultiplier = dmgmultiplier/5
				if (istype(brain, /obj/item/organ/internal/brain))
					var/obj/item/organ/internal/brain/notposi = brain
					notposi.take_internal_damage(in_chamber.damage*dmgmultiplier, 0)
				else
					brain.damage = brain.damage + (in_chamber.damage*dmgmultiplier)
		else
			M.apply_effect(110, EFFECT_PAIN, 0)
		qdel(in_chamber)
		update_icon()
		if (i < burst)
			sleep(burst_delay)

	var/delay = max(burst_delay+1, fire_delay)
	M.setClickCooldown(min(delay, DEFAULT_QUICK_COOLDOWN))
	next_fire_time = world.time + delay
	if (brain.damage > brain.max_damage)
		brain.die()

/obj/item/gun/proc/scope()
	set category = "Object"
	set name = "Use Scope"
	set popup_menu = 1

	toggle_scope(usr, scope_zoom)

/obj/item/gun/proc/toggle_scope(mob/user, zoom_amount=2.0)
	//looking through a scope limits your periphereal vision
	//still, increase the view size by a tiny amount so that sniping isn't too restricted to NSEW
	var/zoom_offset = round(world.view * zoom_amount)
	var/view_size = round(world.view + zoom_amount)

	if(zoom)
		unzoom(user)
		return

	zoom(user, zoom_offset, view_size)
	if(zoom)
		accuracy = scoped_accuracy
		if(screen_shake)
			screen_shake = round(screen_shake*zoom_amount+1) //screen shake is worse when looking through a scope

//make sure accuracy and screen_shake are reset regardless of how the item is unzoomed.
/obj/item/gun/unzoom()
	..()
	accuracy = initial(accuracy)
	screen_shake = initial(screen_shake)

/obj/item/gun/examine(mob/user)
	. = ..()
	if(length(firemodes) > 1)
		var/datum/firemode/current_mode = firemodes[sel_mode]
		to_chat(user, "The fire selector is set to [current_mode.name].")

/obj/item/gun/proc/switch_firemodes()
	var/next_mode = get_next_firemode()
	if(!next_mode || next_mode == sel_mode)
		return null

	var/datum/firemode/old_mode = firemodes[sel_mode]
	old_mode.restore_original_settings(src)

	sel_mode = next_mode
	var/datum/firemode/new_mode = firemodes[sel_mode]
	new_mode.apply_to(src)
	playsound(loc, selector_sound, 50, 1)
	return new_mode

/obj/item/gun/proc/get_next_firemode()
	if(length(firemodes) <= 1)
		return null
	. = sel_mode + 1
	if(. > length(firemodes))
		. = 1

/obj/item/gun/attack_self(mob/user)
	var/datum/firemode/new_mode = switch_firemodes(user)
	if(new_mode)
		to_chat(user, SPAN_NOTICE("\The [src] is now set to [new_mode.name]."))

/obj/item/gun/proc/toggle_safety(mob/user)
	if (user?.is_physically_disabled())
		to_chat(user, SPAN_WARNING("You can't do this right now!"))
		return

	safety_state = !safety_state
	update_icon()
	if(user)
		user.visible_message(SPAN_WARNING("[user] switches the safety of \the [src] [safety_state ? "on" : "off"]."), SPAN_NOTICE("You switch the safety of \the [src] [safety_state ? "on" : "off"]."), range = 3)
		last_safety_check = world.time
		playsound(src, 'sound/weapons/flipblade.ogg', 15, 1)

/obj/item/gun/verb/toggle_safety_verb()
	set name = "Toggle Gun Safety"
	set category = "Object"
	set src in usr
	if (usr.incapacitated())
		to_chat(usr, SPAN_WARNING("You're in no condition to do that."))
		return
	var/obj/item/gun/gun = usr.get_active_hand()
	if (!istype(gun))
		gun = usr.get_inactive_hand()
		if (!istype(gun))
			to_chat(usr, SPAN_WARNING("You need a gun in your hands to do that."))
			return
	gun.toggle_safety(usr)

/obj/item/gun/CtrlClick(mob/user)
	if(loc == user)
		toggle_safety(user)
		return TRUE
	return ..()

/obj/item/gun/proc/safety()
	return has_safety && safety_state

/obj/item/gun/equipped()
	..()
	update_icon()
	last_handled = world.time

/obj/item/gun/on_active_hand()
	last_handled = world.time

/obj/item/gun/on_disarm_attempt(mob/target, mob/attacker)
	var/list/turfs = list()
	for(var/turf/T in view())
		turfs += T
	if(length(turfs))
		var/turf/shoot_to = pick(turfs)
		target.visible_message(SPAN_DANGER("\The [src] goes off during the struggle!"))
		afterattack(shoot_to,target)
		return 1

///obj/item/gun/proc/check_accidents(mob/living/user, message = "[user] fumbles with \the [src] and it goes off!",skill_path = gun_skill, fail_chance = 20, no_more_fail = safety_skill, factor = 2) // Bayskills
/obj/item/gun/proc/check_accidents(mob/living/user, message = "[user] fumbles with \the [src] and it goes off!",skill_path = null, fail_chance = 20, no_more_fail = null, factor = 2)
	if(istype(user))
		//if(!safety() && user.skill_fail_prob(skill_path, fail_chance, no_more_fail, factor) && special_check(user)) // Bay version with skills
		if(!safety() && special_check(user))
			user.visible_message(SPAN_WARNING(message))
			var/list/targets = list(user)
			targets += trange(2, get_turf(src))
			var/picked = pick(targets)
			afterattack(picked, user)
			return 1

// Urist additions
/obj/item/gun/proc/can_autofire()
	return (can_autofire && world.time >= next_fire_time)


//I'm tired of trying to force guns to fire

/obj/item/gun/proc/simple_fire(atom/target, mob/user)
	if(target == user)
		to_chat(user, SPAN_WARNING("You can't do this right now!"))
		return

	var/obj/item/projectile/P = consume_next_projectile(user)
	if(!P)
		handle_click_empty(user)
		return
	P.launch(target)
	play_fire_sound(user, P)
	user.visible_message(
		"<span class='danger'>\The [user] fires \the [src]!</span>",
		"<span class='warning'>You fire \the [src]!</span>",
		"You hear a [fire_sound_text]!"
		)
