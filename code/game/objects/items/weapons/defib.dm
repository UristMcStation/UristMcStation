#define DEFIB_TIME_LIMIT (8 MINUTES) //past this many seconds, defib is useless. Currently 8 Minutes
#define DEFIB_TIME_LOSS  (2 MINUTES) //past this many seconds, brain damage occurs. Currently 2 minutes

//backpack item
/obj/item/defibrillator
	name = "auto-resuscitator"
	desc = "A device that delivers powerful shocks via detachable paddles to resuscitate incapacitated patients."
	icon = 'icons/obj/tools/defibrillator.dmi'
	icon_state = "defibunit"
	item_state = "defibunit"
	slot_flags = SLOT_BACK
	force = 5
	throwforce = 6
	w_class = ITEM_SIZE_LARGE
	origin_tech = list(TECH_BIO = 4, TECH_POWER = 2)
	matter = list(MATERIAL_STEEL = 5000, MATERIAL_PLASTIC = 2000, MATERIAL_GLASS = 1500, MATERIAL_ALUMINIUM = 1000)
	action_button_name = "Remove/Replace Paddles"
	var/obj/item/shockpaddles/linked/paddles
	var/obj/item/cell/bcell = null

/obj/item/defibrillator/Initialize() //starts without a cell for rnd
	. = ..()
	if(ispath(paddles))
		paddles = new paddles(src, src)
	else
		paddles = new(src, src)

	if(ispath(bcell))
		bcell = new bcell(src)
	update_icon()

/obj/item/defibrillator/Destroy()
	. = ..()
	QDEL_NULL(paddles)
	QDEL_NULL(bcell)

/obj/item/defibrillator/loaded //starts with regular power cell for R&D to replace later in the round.
	bcell = /obj/item/cell/standard

/obj/item/defibrillator/on_update_icon()
	var/list/new_overlays = list()

	if(paddles) //in case paddles got destroyed somehow.
		if(paddles.loc == src)
			new_overlays += "[initial(icon_state)]-paddles"
		if(bcell && bcell.check_charge(paddles.chargecost))
			if(!paddles.safety)
				new_overlays += "[initial(icon_state)]-emagged"
			else
				new_overlays += "[initial(icon_state)]-powered"

	if(bcell)
		var/ratio = ceil(bcell.percent()/25) * 25
		new_overlays += "[initial(icon_state)]-charge[ratio]"
	else
		new_overlays += "[initial(icon_state)]-nocell"

	SetOverlays(new_overlays)

/obj/item/defibrillator/examine(mob/user)
	. = ..()
	if(bcell)
		to_chat(user, "The charge meter is showing [bcell.percent()]% charge left.")
	else
		to_chat(user, "There is no cell inside.")

/obj/item/defibrillator/ui_action_click(mob/living/user)
	toggle_paddles()

/obj/item/defibrillator/attack_hand(mob/user)
	if(loc == user)
		toggle_paddles()
	else
		..()

/obj/item/defibrillator/MouseDrop()
	if(ismob(src.loc))
		if(!CanMouseDrop(src))
			return
		var/mob/M = src.loc
		if(!M.unEquip(src))
			return
		src.add_fingerprint(usr)
		M.put_in_any_hand_if_possible(src)


/obj/item/defibrillator/use_tool(obj/item/W, mob/living/user, list/click_params)
	if(W == paddles)
		reattach_paddles(user)
		return TRUE

	else if (istype(W, /obj/item/cell))
		if(bcell)
			to_chat(user, SPAN_WARNING("\The [src] already has a cell."))
			return TRUE
		if (!user.unEquip(W))
			FEEDBACK_UNEQUIP_FAILURE(user, W)
			return TRUE
		W.forceMove(src)
		bcell = W
		to_chat(user, SPAN_NOTICE("You install a cell in \the [src]."))
		update_icon()
		return TRUE

	else if(isScrewdriver(W))
		if(bcell)
			bcell.update_icon()
			bcell.dropInto(loc)
			bcell = null
			to_chat(user, SPAN_NOTICE("You remove the cell from \the [src]."))
			update_icon()
			return TRUE

	return ..()

/obj/item/defibrillator/emag_act(uses, mob/user)
	if(paddles)
		return paddles.emag_act(uses, user, src)
	return NO_EMAG_ACT

//Paddle stuff

/obj/item/defibrillator/verb/toggle_paddles()
	set name = "Toggle Paddles"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(!paddles)
		to_chat(user, SPAN_WARNING("The paddles are missing!"))
		return

	if(paddles.loc != src)
		reattach_paddles(user) //Remove from their hands and back onto the defib unit
		return

	if(!slot_check())
		to_chat(user, SPAN_WARNING("You need to equip [src] before taking out [paddles]."))
	else
		if(!usr.put_in_hands(paddles)) //Detach the paddles into the user's hands
			to_chat(user, SPAN_WARNING("You need a free hand to hold the paddles!"))
		update_icon() //success

//checks that the base unit is in the correct slot to be used
/obj/item/defibrillator/proc/slot_check()
	var/mob/M = loc
	if(!istype(M))
		return 0 //not equipped

	if((slot_flags & SLOT_BACK) && M.get_equipped_item(slot_back) == src)
		return 1
	if((slot_flags & SLOT_BELT) && M.get_equipped_item(slot_belt) == src)
		return 1

	return 0

/obj/item/defibrillator/dropped(mob/user)
	..()
	reattach_paddles(user) //paddles attached to a base unit should never exist outside of their base unit or the mob equipping the base unit

/obj/item/defibrillator/proc/reattach_paddles(mob/user)
	if(!paddles) return

	if(ismob(paddles.loc))
		var/mob/M = paddles.loc
		if(M.drop_from_inventory(paddles, src))
			to_chat(user, SPAN_NOTICE("\The [paddles] snap back into the main unit."))
	else
		paddles.forceMove(src)

	update_icon()

/*
	Base Unit Subtypes
*/

/obj/item/defibrillator/compact
	name = "compact defibrillator"
	desc = "A belt-equipped defibrillator that can be rapidly deployed."
	icon_state = "defibcompact"
	item_state = "defibcompact"
	w_class = ITEM_SIZE_NORMAL
	slot_flags = SLOT_BELT
	origin_tech = list(TECH_BIO = 5, TECH_POWER = 3)

/obj/item/defibrillator/compact/loaded
	bcell = /obj/item/cell/high


/obj/item/defibrillator/compact/combat
	name = "combat defibrillator"
	desc = "A belt-equipped blood-red defibrillator that can be rapidly deployed. Does not have the restrictions or safeties of conventional defibrillators and can revive through space suits."
	paddles = /obj/item/shockpaddles/linked/combat

/obj/item/defibrillator/compact/combat/loaded
	bcell = /obj/item/cell/high

/obj/item/shockpaddles/linked/combat
	combat = 1
	safety = 0
	chargetime = (1 SECONDS)


//paddles

/obj/item/shockpaddles
	name = "defibrillator paddles"
	desc = "A pair of plastic-gripped paddles with flat metal surfaces that are used to deliver powerful electric shocks."
	icon = 'icons/obj/tools/defibrillator.dmi'
	icon_state = "defibpaddles"
	item_state = "defibpaddles"
	gender = PLURAL
	force = 2
	throwforce = 6
	w_class = ITEM_SIZE_LARGE


	var/safety = 1 //if you can zap people with the paddles on harm mode
	var/combat = 0 //If it can be used to revive people wearing thick clothing (e.g. spacesuits)
	var/cooldowntime = (6 SECONDS) // How long in deciseconds until the defib is ready again after use.
	var/chargetime = (2 SECONDS)
	var/chargecost = 100 //units of charge
	var/burn_damage_amt = 5

	var/wielded = 0
	var/cooldown = 0
	var/busy = 0

/obj/item/shockpaddles/proc/set_cooldown(delay)
	cooldown = 1
	update_icon()

	spawn(delay)
		if(cooldown)
			cooldown = 0
			update_icon()

			make_announcement("beeps, \"Unit is re-energized.\"", "notice")
			playsound(src, 'sound/machines/defib_ready.ogg', 50, 0)

/obj/item/shockpaddles/update_twohanding()
	var/mob/living/M = loc
	if(istype(M) && is_held_twohanded(M))
		wielded = 1
		SetName("[initial(name)] (wielded)")
	else
		wielded = 0
		SetName(initial(name))
	..()

/obj/item/shockpaddles/on_update_icon()
	icon_state = "defibpaddles[wielded]"
	item_state = "defibpaddles[wielded]"
	if(cooldown)
		icon_state = "defibpaddles[wielded]_cooldown"

/obj/item/shockpaddles/proc/can_use(mob/user, mob/M)
	if(busy)
		return 0
	if(!check_charge(chargecost))
		to_chat(user, SPAN_WARNING("\The [src] doesn't have enough charge left to do that."))
		return 0
	if(!wielded && !isrobot(user))
		to_chat(user, SPAN_WARNING("You need to wield the paddles with both hands before you can use them on someone!"))
		return 0
	if(cooldown)
		to_chat(user, SPAN_WARNING("\The [src] are re-energizing!"))
		return 0
	return 1

//Checks for various conditions to see if the mob is revivable
/obj/item/shockpaddles/proc/can_defib(mob/living/carbon/human/H) //This is checked before doing the defib operation
	if((H.species.species_flags & SPECIES_FLAG_NO_SCAN) || H.isSynthetic())
		return "buzzes, \"Unrecogized physiology. Operation aborted.\""

	if(!check_contact(H))
		return "buzzes, \"Patient's chest is obstructed. Operation aborted.\""

/obj/item/shockpaddles/proc/can_revive(mob/living/carbon/human/H) //This is checked right before attempting to revive
	if(H.stat == DEAD)
		return "buzzes, \"Resuscitation failed - Severe neurological decay makes recovery of patient impossible. Further attempts futile.\""

/obj/item/shockpaddles/proc/check_contact(mob/living/carbon/human/H)
	if(!combat)
		for(var/obj/item/clothing/cloth in list(H.wear_suit, H.w_uniform))
			if((cloth.body_parts_covered & UPPER_TORSO) && (cloth.item_flags & ITEM_FLAG_THICKMATERIAL))
				return FALSE
	return TRUE

/obj/item/shockpaddles/proc/check_blood_level(mob/living/carbon/human/H)
	if(!H.should_have_organ(BP_HEART))
		return FALSE
	var/obj/item/organ/internal/heart/heart = H.internal_organs_by_name[BP_HEART]
	if(!heart || H.get_blood_volume() < BLOOD_VOLUME_SURVIVE)
		return TRUE
	return FALSE

/obj/item/shockpaddles/proc/check_charge(charge_amt)
	return 0

/obj/item/shockpaddles/proc/checked_use(charge_amt)
	return 0

/obj/item/shockpaddles/use_before(mob/living/M, mob/living/user)
	. = FALSE
	var/mob/living/carbon/human/H = M
	if (!istype(H) || user.a_intent != I_HELP)
		return FALSE

	if (can_use(user, H))
		busy = 1
		update_icon()

		do_revive(H, user)

		busy = 0
		update_icon()
	return TRUE

//Since harm-intent now skips the delay for deliberate placement, you have to be able to hit them in combat in order to shock people.
/obj/item/shockpaddles/apply_hit_effect(mob/living/target, mob/living/user, hit_zone)
	if(ishuman(target) && can_use(user, target))
		busy = 1
		update_icon()

		do_electrocute(target, user, hit_zone)

		busy = 0
		update_icon()

		return 1

	return ..()

// This proc is used so that we can return out of the revive process while ensuring that busy and update_icon() are handled
/obj/item/shockpaddles/proc/do_revive(mob/living/carbon/human/H, mob/living/user)
	if(H.ssd_check())
		to_chat(find_dead_player(H.ckey, 1), SPAN_NOTICE("Someone is attempting to resuscitate you. Re-enter your body if you want to be revived!"))

	//beginning to place the paddles on patient's chest to allow some time for people to move away to stop the process
	user.visible_message(SPAN_WARNING("\The [user] begins to place [src] on [H]'s chest."), SPAN_WARNING("You begin to place [src] on [H]'s chest..."))
	if(!do_after(user, 30, H))
		return
	user.visible_message(SPAN_NOTICE("\The [user] places [src] on [H]'s chest."), SPAN_WARNING("You place [src] on [H]'s chest."))
	playsound(get_turf(src), 'sound/machines/defib_charge.ogg', 50, 0)

	var/error = can_defib(H)
	if(error)
		make_announcement(error, "warning")
		playsound(get_turf(src), 'sound/machines/defib_failed.ogg', 50, 0)
		return

	if(check_blood_level(H))
		make_announcement("buzzes, \"Warning - Patient is in hypovolemic shock and may require a blood transfusion.\"", "warning")

	if(H.internal_organs_by_name[BP_HEART]) //People may need more direct instruction
		var/obj/item/organ/internal/heart/heart = H.internal_organs_by_name[BP_HEART]
		if(heart.is_bruised())
			make_announcement("buzzes, \"Danger! The patient has sustained a cardiac contusion and will require surgical treatment for full recovery!\"", "danger")

	//placed on chest and short delay to shock for dramatic effect, revive time is 5sec total
	if(!do_after(user, chargetime, H, DO_MEDICAL | DO_USER_UNIQUE_ACT))
		return

	//deduct charge here, in case the base unit was EMPed or something during the delay time
	if(!checked_use(chargecost))
		make_announcement("buzzes, \"Insufficient charge.\"", "warning")
		playsound(get_turf(src), 'sound/machines/defib_failed.ogg', 50, 0)
		return

	H.visible_message(SPAN_WARNING("\The [H]'s body convulses a bit."))
	playsound(get_turf(src), "bodyfall", 50, 1)
	playsound(get_turf(src), 'sound/machines/defib_zap.ogg', 50, 1, -1)
	set_cooldown(cooldowntime)

	error = can_revive(H)
	if(error)
		make_announcement(error, "warning")
		playsound(get_turf(src), 'sound/machines/defib_failed.ogg', 50, 0)
		return

	H.apply_damage(burn_damage_amt, DAMAGE_BURN, BP_CHEST)

	//set oxyloss so that the patient is just barely in crit, if possible
	make_announcement("pings, \"Resuscitation successful.\"", "notice")
	playsound(get_turf(src), 'sound/machines/defib_success.ogg', 50, 0)
	H.resuscitate()
	var/obj/item/organ/internal/cell/potato = H.internal_organs_by_name[BP_CELL]
	if(istype(potato) && potato.cell)
		var/obj/item/cell/C = potato.cell
		C.give(chargecost)
	H.AdjustSleeping(-60)
	log_and_message_admins("used \a [src] to revive [key_name(H)].", user)


/obj/item/shockpaddles/proc/do_electrocute(mob/living/carbon/human/H, mob/user, target_zone)
	var/obj/item/organ/external/affecting = H.get_organ(target_zone)
	if(!affecting)
		to_chat(user, SPAN_WARNING("They are missing that body part!"))
		return

	//no need to spend time carefully placing the paddles, we're just trying to shock them
	user.visible_message(SPAN_DANGER("\The [user] slaps [src] onto [H]'s [affecting.name]. [safety? "However, it fizzles out as the safety indicator flashes.": ""]"), SPAN_DANGER("You overcharge [src] and slap them onto [H]'s [affecting.name]. [safety? "However, it fizzles out as the safety indicator flashes.": ""]"))

	//Just stop at awkwardly slapping electrodes on people if the safety is enabled
	if(safety)
		to_chat(user, SPAN_WARNING("You can't do that while the safety is enabled."))
		return

	playsound(get_turf(src), 'sound/machines/defib_charge.ogg', 50, 0)
	audible_message(SPAN_WARNING("\The [src] lets out a steadily rising hum..."))

	if(!do_after(user, chargetime, H, DO_DEFAULT | DO_USER_UNIQUE_ACT | DO_PUBLIC_PROGRESS))
		return

	//deduct charge here, in case the base unit was EMPed or something during the delay time
	if(!checked_use(chargecost))
		make_announcement("buzzes, \"Insufficient charge.\"", "warning")
		playsound(get_turf(src), 'sound/machines/defib_failed.ogg', 50, 0)
		return

	user.visible_message(SPAN_DANGER("<i>\The [user] shocks [H] with \the [src]!</i>"), SPAN_WARNING("You shock [H] with \the [src]!"))
	playsound(get_turf(src), 'sound/machines/defib_zap.ogg', 100, 1, -1)
	playsound(loc, 'sound/weapons/Egloves.ogg', 100, 1, -1)
	set_cooldown(cooldowntime)

	H.stun_effect_act(2, 120, target_zone)
	var/burn_damage = H.electrocute_act(burn_damage_amt*2, src, def_zone = target_zone)
	if(burn_damage > 15 && H.can_feel_pain())
		H.emote("scream")
	var/obj/item/organ/internal/heart/doki = LAZYACCESS(affecting.internal_organs, BP_HEART)
	if(istype(doki) && doki.pulse && !doki.open && prob(10))
		to_chat(doki, SPAN_DANGER("Your [doki] has stopped!"))
		doki.pulse = PULSE_NONE

	admin_attack_log(user, H, "Electrocuted using \a [src]", "Was electrocuted with \a [src]", "used \a [src] to electrocute")

/obj/item/shockpaddles/proc/make_alive(mob/living/carbon/human/M) //This revives the mob
	var/deadtime = world.time - M.timeofdeath

	M.switch_from_dead_to_living_mob_list()
	M.timeofdeath = 0
	M.set_stat(UNCONSCIOUS) //Life() can bring them back to consciousness if it needs to.
	M.regenerate_icons()
	M.failed_last_breath = 0 //So mobs that died of oxyloss don't revive and have perpetual out of breath.
	M.reload_fullscreen()

	M.emote("gasp")
	M.Weaken(rand(10,25))
	M.updatehealth()
	apply_brain_damage(M, deadtime)

/obj/item/shockpaddles/proc/apply_brain_damage(mob/living/carbon/human/H, deadtime)
	if(deadtime < DEFIB_TIME_LOSS) return

	if(!H.should_have_organ(BP_BRAIN)) return //no brain

	var/obj/item/organ/internal/brain/brain = H.internal_organs_by_name[BP_BRAIN]
	if(!brain) return //no brain

	var/brain_damage = clamp((deadtime - DEFIB_TIME_LOSS)/(DEFIB_TIME_LIMIT - DEFIB_TIME_LOSS)*brain.max_damage, H.getBrainLoss(), brain.max_damage)
	H.setBrainLoss(brain_damage)

/obj/item/shockpaddles/proc/make_announcement(message, msg_class)
	audible_message("<b>\The [src]</b> [message]", "\The [src] vibrates slightly.")

/obj/item/shockpaddles/emag_act(uses, mob/user, obj/item/defibrillator/base)
	if(istype(src, /obj/item/shockpaddles/linked))
		var/obj/item/shockpaddles/linked/dfb = src
		if(dfb.base_unit)
			base = dfb.base_unit
	if(!base)
		return
	if(safety)
		safety = 0
		to_chat(user, SPAN_WARNING("You silently disable \the [src]'s safety protocols with the cryptographic sequencer."))
		burn_damage_amt *= 3
		base.update_icon()
		return 1
	else
		safety = 1
		to_chat(user, SPAN_NOTICE("You silently enable \the [src]'s safety protocols with the cryptographic sequencer."))
		burn_damage_amt = initial(burn_damage_amt)
		base.update_icon()
		return 1

/obj/item/shockpaddles/emp_act(severity)
	var/new_safety = rand(0, 1)
	if(safety != new_safety)
		safety = new_safety
		if(safety)
			make_announcement("beeps, \"Safety protocols enabled!\"", "notice")
			playsound(get_turf(src), 'sound/machines/defib_SafetyOn.ogg', 50, 0)
		else
			make_announcement("beeps, \"Safety protocols disabled!\"", "warning")
			playsound(get_turf(src), 'sound/machines/defib_safetyOff.ogg', 50, 0)
		update_icon()
	..()

/obj/item/shockpaddles/robot
	name = "defibrillator paddles"
	desc = "A pair of advanced shockpaddles powered by a robot's internal power cell, able to penetrate thick clothing."
	chargecost = 50
	combat = 1
	icon_state = "defibpaddles0"
	item_state = "defibpaddles0"
	cooldowntime = (3 SECONDS)

/obj/item/shockpaddles/robot/check_charge(charge_amt)
	if(isrobot(src.loc))
		var/mob/living/silicon/robot/R = src.loc
		return (R.cell && R.cell.check_charge(charge_amt))

/obj/item/shockpaddles/robot/checked_use(charge_amt)
	if(isrobot(src.loc))
		var/mob/living/silicon/robot/R = src.loc
		return (R.cell && R.cell.checked_use(charge_amt))

/obj/item/shockpaddles/rig
	name = "mounted defibrillator"
	desc = "If you can see this something is very wrong, report this bug."
	cooldowntime = (4 SECONDS)
	chargetime = (1 SECOND)
	chargecost = 150
	safety = 0
	wielded = 1

	/// The defib module these paddles provide behavior for
	var/obj/item/rig_module/device/defib/module

/obj/item/shockpaddles/rig/Destroy()
	if (module)
		module.device = null
		module = null
	return ..()

/obj/item/shockpaddles/rig/update_twohanding()
	return

/obj/item/shockpaddles/rig/can_use(mob/living/user, mob/living/carbon/human/target)
	. = ..()
	if (!.)
		return
	var/mob/living/carbon/human/wearer = module?.holder?.wearer
	if (!wearer)
		return FALSE
	if (!wearer.HandsEmpty())
		if (wearer == user)
			to_chat(user, SPAN_WARNING("You need two hands free to do that."))
		else
			to_chat(user, SPAN_WARNING("\The [wearer] needs two hands free to do that."))
		return FALSE
	return TRUE

/obj/item/shockpaddles/rig/check_charge(charge_amt)
	if(istype(src.loc, /obj/item/rig_module/device/defib))
		var/obj/item/rig_module/device/defib/module = src.loc
		return (module.holder && module.holder.cell && module.holder.cell.check_charge(charge_amt))

/obj/item/shockpaddles/rig/checked_use(charge_amt)
	if(istype(src.loc, /obj/item/rig_module/device/defib))
		var/obj/item/rig_module/device/defib/module = src.loc
		return (module.holder && module.holder.cell && module.holder.cell.checked_use(charge_amt))

/obj/item/shockpaddles/rig/set_cooldown(delay)
	..()
	if(istype(src.loc, /obj/item/rig_module/device/defib))
		var/obj/item/rig_module/device/defib/module = src.loc
		module.next_use = world.time + delay
/*
	Shockpaddles that are linked to a base unit
*/
/obj/item/shockpaddles/linked
	var/obj/item/defibrillator/base_unit
	icon_state = "defibpaddles0"

/obj/item/shockpaddles/linked/New(newloc, obj/item/defibrillator/defib)
	base_unit = defib
	if(base_unit.bcell)
		icon_state = "defibpaddles1"
	..(newloc)

/obj/item/shockpaddles/linked/Destroy()
	if(base_unit)
		//ensure the base unit's icon updates
		if(base_unit.paddles == src)
			base_unit.paddles = null
			base_unit.update_icon()
		base_unit = null
	return ..()

/obj/item/shockpaddles/linked/dropped(mob/user)
	..() //update twohanding
	if(base_unit)
		base_unit.reattach_paddles(user) //paddles attached to a base unit should never exist outside of their base unit or the mob equipping the base unit

/obj/item/shockpaddles/linked/check_charge(charge_amt)
	return (base_unit.bcell && base_unit.bcell.check_charge(charge_amt))

/obj/item/shockpaddles/linked/checked_use(charge_amt)
	return (base_unit.bcell && base_unit.bcell.checked_use(charge_amt))

/obj/item/shockpaddles/linked/make_announcement(message, msg_class)
	base_unit.audible_message("<b>\The [base_unit]</b> [message]", "\The [base_unit] vibrates slightly.")

/*
	Standalone Shockpaddles
*/

/obj/item/shockpaddles/standalone
	desc = "A pair of shockpaddles powered by an experimental miniaturized reactor." //Inspired by the advanced e-gun
	var/fail_counter = 0

/obj/item/shockpaddles/standalone/Destroy()
	. = ..()
	if(fail_counter)
		STOP_PROCESSING(SSobj, src)

/obj/item/shockpaddles/standalone/check_charge(charge_amt)
	return 1

/obj/item/shockpaddles/standalone/checked_use(charge_amt)
	SSradiation.radiate(src, charge_amt/12) //just a little bit of radiation. It's the price you pay for being powered by magic I guess
	return 1

/obj/item/shockpaddles/standalone/Process()
	if(fail_counter > 0)
		SSradiation.radiate(src, (fail_counter * 2))
		fail_counter--
	else
		STOP_PROCESSING(SSobj, src)

/obj/item/shockpaddles/standalone/emp_act(severity)
	..()
	var/new_fail = 0
	switch(severity)
		if(EMP_ACT_HEAVY)
			new_fail = max(fail_counter, 20)
			visible_message("\The [src]'s reactor overloads!")
		if(EMP_ACT_LIGHT)
			new_fail = max(fail_counter, 8)
			if(ismob(loc))
				to_chat(loc, SPAN_WARNING("\The [src] feel pleasantly warm."))

	if(new_fail && !fail_counter)
		START_PROCESSING(SSobj, src)
	fail_counter = new_fail

/obj/item/shockpaddles/standalone/traitor
	name = "defibrillator paddles"
	desc = "A pair of unusual looking paddles powered by an experimental miniaturized reactor. It possesses both the ability to penetrate armor and to deliver powerful shocks."
	icon_state = "defibpaddles0"
	item_state = "defibpaddles0"
	combat = 1
	safety = 0
	chargetime = (1 SECONDS)
	burn_damage_amt = 15

#undef DEFIB_TIME_LIMIT
#undef DEFIB_TIME_LOSS
