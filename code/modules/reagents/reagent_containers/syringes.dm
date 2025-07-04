////////////////////////////////////////////////////////////////////////////////
/// Syringes.
////////////////////////////////////////////////////////////////////////////////
#define SYRINGE_DRAW 0
#define SYRINGE_INJECT 1
#define SYRINGE_BROKEN 2

/obj/item/reagent_containers/syringe
	name = "syringe"
	desc = "A syringe."
	icon = 'icons/obj/tools/syringe.dmi'
	item_state = "rg0"
	icon_state = "rg"
	matter = list(MATERIAL_GLASS = 150)
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = "1;2;5"
	volume = 15
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_EARS
	sharp = TRUE
	unacidable = TRUE
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_NO_TOOLS
	var/mode = SYRINGE_DRAW
	var/image/filling //holds a reference to the current filling overlay
	var/visible_name = "a syringe"
	var/time = 30

/obj/item/reagent_containers/syringe/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/reagent_containers/syringe/on_reagent_change()
	update_icon()

/obj/item/reagent_containers/syringe/pickup(mob/user)
	..()
	update_icon()

/obj/item/reagent_containers/syringe/dropped(mob/user)
	..()
	update_icon()

/obj/item/reagent_containers/syringe/attack_self(mob/user as mob)
	switch(mode)
		if(SYRINGE_DRAW)
			mode = SYRINGE_INJECT
		if(SYRINGE_INJECT)
			mode = SYRINGE_DRAW
		if(SYRINGE_BROKEN)
			return
	update_icon()

/obj/item/reagent_containers/syringe/attack_hand()
	..()
	update_icon()

/obj/item/reagent_containers/syringe/use_after(obj/target, mob/living/user, click_parameters)
	if(mode == SYRINGE_BROKEN)
		to_chat(user, SPAN_WARNING("This syringe is broken."))
		return TRUE

	if(istype(target, /obj/structure/closet/body_bag))
		handleBodyBag(target, user)
		return TRUE

	if(!target.reagents)
		return FALSE

	if(user.a_intent == I_HURT && ismob(target))
		syringestab(target, user)
		return TRUE

	handleTarget(target, user)
	return TRUE

/obj/item/reagent_containers/syringe/on_update_icon()
	ClearOverlays()
	underlays.Cut()

	if(mode == SYRINGE_BROKEN)
		icon_state = "broken"
		return

	var/rounded_vol = clamp(round((reagents.total_volume / volume * 15),5), 5, 15)
	if (reagents.total_volume == 0)
		rounded_vol = 0
	if(ismob(loc))
		var/injoverlay
		switch(mode)
			if (SYRINGE_DRAW)
				injoverlay = "draw"
			if (SYRINGE_INJECT)
				injoverlay = "inject"
		AddOverlays(injoverlay)
	icon_state = "[initial(icon_state)][rounded_vol]"
	item_state = "syringe_[rounded_vol]"

	if(reagents.total_volume)
		filling = image('icons/obj/reagentfillings.dmi', src, "syringe10")

		filling.icon_state = "syringe[rounded_vol]"

		filling.color = reagents.get_color()
		underlays += filling

/obj/item/reagent_containers/syringe/proc/handleTarget(atom/target, mob/user)
	switch(mode)
		if(SYRINGE_DRAW)
			drawReagents(target, user)

		if(SYRINGE_INJECT)
			injectReagents(target, user)

/obj/item/reagent_containers/syringe/proc/drawReagents(atom/target, mob/user)
	if(!reagents.get_free_space())
		to_chat(user, SPAN_WARNING("The syringe is full."))
		mode = SYRINGE_INJECT
		return

	if(ismob(target))//Blood!
		if(reagents.has_reagent(/datum/reagent/blood))
			to_chat(user, SPAN_NOTICE("There is already a blood sample in this syringe."))
			return
		if(istype(target, /mob/living/carbon))
			if(istype(target, /mob/living/carbon/slime))
				to_chat(user, SPAN_WARNING("You are unable to locate any blood."))
				return
			var/amount = reagents.get_free_space()
			var/mob/living/carbon/T = target
			if(!T.dna)
				to_chat(user, SPAN_WARNING("You are unable to locate any blood."))
				if(istype(target, /mob/living/carbon/human))
					CRASH("[T] \[[T.type]\] was missing their dna datum!")
				return


			var/allow = T.can_inject(user, check_zone(user.zone_sel.selecting))
			if(!allow)
				return

			if(allow == INJECTION_PORT) // Taking a blood sample through a hardsuit takes longer due to needing to find a port first.
				if(target != user)
					user.visible_message(SPAN_WARNING("\The [user] begins hunting for an injection port on \the [target]'s suit!"))
				else
					to_chat(user, SPAN_NOTICE("You begin hunting for an injection port on your suit."))
				if(!do_after(user, INJECTION_PORT_DELAY, target, do_flags = DO_MEDICAL))
					return

				if (!reagents)
					return

			if(target != user)
				user.visible_message(SPAN_WARNING("\The [user] is trying to take a blood sample from \the [target]."))
			else
				to_chat(user, SPAN_NOTICE("You start trying to take a blood sample from yourself."))

			user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
			user.do_attack_animation(target)

			if(!do_after(user, time, target, do_flags = DO_MEDICAL))
				return

			if (!reagents)
				return

			T.take_blood(src, amount)
			to_chat(user, SPAN_NOTICE("You take a blood sample from [target]."))
			for(var/mob/O in viewers(4, user))
				O.show_message(SPAN_NOTICE("[user] takes a blood sample from [target]."), 1)

			if(ishuman(target))
				var/mob/living/carbon/human/H = target
				H.custom_pain(SPAN_WARNING("The needle stings a bit."), 2, TRUE, H.get_organ(user.zone_sel.selecting))

	else //if not mob
		if(!target.reagents.total_volume)
			to_chat(user, SPAN_NOTICE("[target] is empty."))
			return

		if(!target.is_open_container() && !istype(target, /obj/structure/reagent_dispensers) && !istype(target, /obj/item/slime_extract))
			to_chat(user, SPAN_NOTICE("You cannot directly remove reagents from this object."))
			return

		var/trans = target.reagents.trans_to_obj(src, amount_per_transfer_from_this)
		to_chat(user, SPAN_NOTICE("You fill the syringe with [trans] units of the solution."))
		update_icon()

	if(!reagents.get_free_space())
		mode = SYRINGE_INJECT
		update_icon()

/obj/item/reagent_containers/syringe/proc/injectReagents(atom/target, mob/user)
	if(!reagents?.total_volume)
		to_chat(user, SPAN_NOTICE("The syringe is empty."))
		mode = SYRINGE_DRAW
		return
	if(istype(target, /obj/item/implantcase/chem))
		return

	if(!target.is_open_container() && !ismob(target) && !istype(target, /obj/item/reagent_containers/food) && !istype(target, /obj/item/slime_extract) && !istype(target, /obj/item/clothing/mask/smokable/cigarette) && !istype(target, /obj/item/storage/fancy/smokable))
		to_chat(user, SPAN_NOTICE("You cannot directly fill this object."))
		return
	if(!target.reagents.get_free_space())
		to_chat(user, SPAN_NOTICE("[target] is full."))
		return

	if(isliving(target))
		injectMob(target, user)
		return

	var/trans = reagents.trans_to(target, amount_per_transfer_from_this)
	to_chat(user, SPAN_NOTICE("You inject \the [target] with [trans] units of the solution. \The [src] now contains [src.reagents.total_volume] units."))
	if(reagents.total_volume <= 0 && mode == SYRINGE_INJECT)
		mode = SYRINGE_DRAW
		update_icon()

/obj/item/reagent_containers/syringe/proc/handleBodyBag(obj/structure/closet/body_bag/bag, mob/living/carbon/user)
	if(bag.opened || !bag.contains_body)
		return

	var/mob/living/L = locate() in bag
	if(L)
		injectMob(L, user, bag)

/obj/item/reagent_containers/syringe/proc/injectMob(mob/living/carbon/target, mob/living/carbon/user, atom/trackTarget)
	if(!trackTarget)
		trackTarget = target

	var/allow = target.can_inject(user, check_zone(user.zone_sel.selecting))
	if(!allow)
		return

	if(allow == INJECTION_PORT) // Injecting through a hardsuit takes longer due to needing to find a port first.
		if(target != user)
			user.visible_message(SPAN_WARNING("\The [user] begins hunting for an injection port on \the [target]'s suit!"))
		else
			to_chat(user, SPAN_NOTICE("You begin hunting for an injection port on your suit."))
		if(!do_after(user, INJECTION_PORT_DELAY, trackTarget, do_flags = DO_MEDICAL))
			return

	if(target != user)
		user.visible_message(SPAN_WARNING("\The [user] is trying to inject \the [target] with [visible_name]!"))
	else
		to_chat(user, SPAN_NOTICE("You begin injecting yourself with [visible_name]."))

	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
	user.do_attack_animation(trackTarget)

	if(!do_after(user, time, trackTarget, do_flags = DO_MEDICAL))
		return

	if(target != user && target != trackTarget && target.loc != trackTarget)
		return
	if (reagents.should_admin_log())
		admin_inject_log(user, target, src, reagents.get_reagents(), amount_per_transfer_from_this)
	var/trans = reagents.trans_to_mob(target, amount_per_transfer_from_this, CHEM_BLOOD)

	if(target != user)
		user.visible_message(SPAN_WARNING("\the [user] injects \the [target] with [visible_name]!"), SPAN_NOTICE("You inject \the [target] with [trans] units of the solution. \The [src] now contains [src.reagents.total_volume] units."))
	else
		to_chat(user, SPAN_NOTICE("You inject yourself with [trans] units of the solution. \The [src] now contains [src.reagents.total_volume] units."))

	if(ishuman(target))
		var/mob/living/carbon/human/T = target
		T.custom_pain(SPAN_WARNING("The needle stings a bit."), 2, TRUE, T.get_organ(user.zone_sel.selecting))

	if(reagents.total_volume <= 0 && mode == SYRINGE_INJECT)
		mode = SYRINGE_DRAW
		update_icon()

/obj/item/reagent_containers/syringe/proc/syringestab(mob/living/carbon/target, mob/living/carbon/user)
	var/should_admin_log = reagents.should_admin_log()
	if(istype(target, /mob/living/carbon/human))

		var/mob/living/carbon/human/H = target

		var/target_zone = ran_zone(check_zone(user.zone_sel.selecting, target))
		var/obj/item/organ/external/affecting = H.get_organ(target_zone)

		if (!affecting || affecting.is_stump())
			to_chat(user, SPAN_DANGER("They are missing that limb!"))
			return

		var/hit_area = affecting.name

		if((user != target) && H.check_shields(7, src, user, "\the [src]"))
			return

		if (target != user && H.get_blocked_ratio(target_zone, DAMAGE_BRUTE, damage_flags=DAMAGE_FLAG_SHARP) > 0.1 && prob(50))
			for(var/mob/O in viewers(world.view, user))
				O.show_message(text(SPAN_DANGER("[user] tries to stab [target] in \the [hit_area] with [src.name], but the attack is deflected by armor!")), 1)
			qdel(src)

			admin_attack_log(user, target, "Attacked using \a [src]", "Was attacked with \a [src]", "used \a [src] to attack")
			return

		user.visible_message(SPAN_DANGER("[user] stabs [target] in \the [hit_area] with [src.name]!"))
		target.apply_damage(3, DAMAGE_BRUTE, target_zone, damage_flags=DAMAGE_FLAG_SHARP)

	else
		user.visible_message(SPAN_DANGER("[user] stabs [target] with [src.name]!"))
		target.apply_damage(3, DAMAGE_BRUTE)

	var/syringestab_amount_transferred = rand(0, (reagents.total_volume - 5)) //nerfed by popular demand
	var/trans = reagents.trans_to_mob(target, syringestab_amount_transferred, CHEM_BLOOD)
	if(isnull(trans)) trans = 0
	if (should_admin_log)
		var/contained_reagents = reagents.get_reagents()
		admin_inject_log(user, target, src, contained_reagents, trans, violent=1)
	break_syringe(target, user)

/obj/item/reagent_containers/syringe/proc/break_syringe(mob/living/carbon/target, mob/living/carbon/user)
	desc += " It is broken."
	mode = SYRINGE_BROKEN
	if(target)
		add_blood(target)
	if(user)
		add_fingerprint(user)
	update_icon()

/obj/item/reagent_containers/syringe/ld50_syringe
	name = "Lethal Injection Syringe"
	desc = "A syringe used for lethal injections."
	amount_per_transfer_from_this = 60
	volume = 60
	visible_name = "a giant syringe"
	time = 300

/obj/item/reagent_containers/syringe/ld50_syringe/syringestab(mob/living/carbon/target, mob/living/carbon/user)
	to_chat(user, SPAN_NOTICE("This syringe is too big to stab someone with it."))
	return // No instant injecting

/obj/item/reagent_containers/syringe/ld50_syringe/drawReagents(target, mob/user)
	if(ismob(target)) // No drawing 60 units of blood at once
		to_chat(user, SPAN_NOTICE("This needle isn't designed for drawing blood."))
		return
	..()

////////////////////////////////////////////////////////////////////////////////
/// Syringes. END
////////////////////////////////////////////////////////////////////////////////

/obj/item/reagent_containers/syringe/inaprovaline
	name = "Syringe (inaprovaline)"
	desc = "Contains inaprovaline - used to stabilize patients."

/obj/item/reagent_containers/syringe/inaprovaline/New()
	..()
	reagents.add_reagent(/datum/reagent/inaprovaline, 15)
	mode = SYRINGE_INJECT
	update_icon()

/obj/item/reagent_containers/syringe/antitoxin
	name = "Syringe (anti-toxin)"
	desc = "Contains anti-toxins."

/obj/item/reagent_containers/syringe/antitoxin/New()
	..()
	reagents.add_reagent(/datum/reagent/dylovene, 15)
	mode = SYRINGE_INJECT
	update_icon()

/obj/item/reagent_containers/syringe/antiviral
	name = "Syringe (spaceacillin)"
	desc = "Contains antiviral agents."

/obj/item/reagent_containers/syringe/antiviral/New()
	..()
	reagents.add_reagent(/datum/reagent/spaceacillin, 15)
	mode = SYRINGE_INJECT
	update_icon()

/obj/item/reagent_containers/syringe/drugs
	name = "Syringe (drugs)"
	desc = "Contains aggressive drugs meant for torture."

/obj/item/reagent_containers/syringe/drugs/New()
	..()
	reagents.add_reagent(/datum/reagent/drugs/hextro, 5)
	reagents.add_reagent(/datum/reagent/drugs/mindbreaker, 5)
	reagents.add_reagent(/datum/reagent/drugs/cryptobiolin, 5)
	mode = SYRINGE_INJECT
	update_icon()

/obj/item/reagent_containers/syringe/ld50_syringe/choral

/obj/item/reagent_containers/syringe/ld50_syringe/choral/New()
	..()
	reagents.add_reagent(/datum/reagent/chloralhydrate, 60)
	mode = SYRINGE_INJECT
	update_icon()

/obj/item/reagent_containers/syringe/steroid
	name = "Syringe (anabolic steroids)"
	desc = "Contains drugs for muscle growth."

/obj/item/reagent_containers/syringe/steroid/New()
	..()
	reagents.add_reagent(/datum/reagent/adrenaline, 5)
	reagents.add_reagent(/datum/reagent/hyperzine, 10)


// TG ports

/obj/item/reagent_containers/syringe/bluespace
	name = "bluespace syringe"
	desc = "An advanced syringe that can hold 60 units of chemicals."
	amount_per_transfer_from_this = 20
	volume = 60
	icon_state = "bs"

/obj/item/reagent_containers/syringe/noreact
	name = "cryostasis syringe"
	desc = "An advanced syringe that stops reagents inside from reacting. It can hold up to 20 units."
	volume = 20
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_NO_REACT
	icon_state = "cs"
