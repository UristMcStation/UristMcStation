// Foam
// Similar to smoke, but spreads out more
// metal foams leave behind a foamed metal wall

/obj/effect/foam
	name = "foam"
	icon_state = "foam"
	opacity = 0
	anchored = TRUE
	density = FALSE
	layer = ABOVE_OBJ_LAYER
	mouse_opacity = 0
	animate_movement = 0
	var/amount = 3
	var/expand = 1
	var/metal = 0

/obj/effect/foam/New(loc, ismetal = 0)
	..(loc)
	icon_state = "[ismetal? "m" : ""]foam"
	metal = ismetal
	playsound(src, 'sound/effects/bubbles2.ogg', 80, 1, -3)
	spawn(3 + metal * 3)
		Process()
		checkReagents()
	addtimer(new Callback(src, PROC_REF(remove_foam)), 12 SECONDS)

/obj/effect/foam/proc/remove_foam()
	STOP_PROCESSING(SSobj, src)
	if(metal)
		var/obj/structure/foamedmetal/M = new(src.loc)
		M.metal = metal
		M.update_icon()
	flick("[icon_state]-disolve", src)
	QDEL_IN(src, 5)

/obj/effect/foam/proc/checkReagents() // transfer any reagents to the floor
	if(!metal && reagents)
		var/turf/T = get_turf(src)
		reagents.touch_turf(T)
		for(var/obj/O in T)
			reagents.touch_obj(O)

/obj/effect/foam/Process()
	if(--amount < 0)
		return

	for(var/direction in GLOB.cardinal)
		var/turf/T = get_step(src, direction)
		if(!T)
			continue

		if(!T.Enter(src))
			continue

		var/obj/effect/foam/F = locate() in T
		if(F)
			continue

		F = new(T, metal)
		F.amount = amount
		if(!metal)
			F.create_reagents(10)
			if(reagents)
				for(var/datum/reagent/R in reagents.reagent_list)
					F.reagents.add_reagent(R.type, 1, safety = 1) //added safety check since reagents in the foam have already had a chance to react

/obj/effect/foam/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume) // foam disolves when heated, except metal foams
	if(!metal && prob(max(0, exposed_temperature - 475)))
		flick("[icon_state]-disolve", src)

		spawn(5)
			qdel(src)

/obj/effect/foam/Crossed(atom/movable/AM)
	if(metal)
		return
	if(istype(AM, /mob/living))
		var/mob/living/M = AM
		M.slip("the foam", 6)

/datum/effect/foam_spread
	var/amount = 5				// the size of the foam spread.
	var/list/carried_reagents	// the IDs of reagents present when the foam was mixed
	var/metal = 0				// 0 = foam, 1 = metalfoam, 2 = ironfoam

/datum/effect/foam_spread/set_up(amt=5, loca, datum/reagents/carry = null, metalfoam = 0)
	amount = round(sqrt(amt / 3), 1)
	if(isturf(loca))
		location = loca
	else
		location = get_turf(loca)

	carried_reagents = list()
	metal = metalfoam

	// bit of a hack here. Foam carries along any reagent also present in the glass it is mixed with (defaults to water if none is present). Rather than actually transfer the reagents, this makes a list of the reagent ids and spawns 1 unit of that reagent when the foam disolves.

	if(carry && !metal)
		for(var/datum/reagent/R in carry.reagent_list)
			carried_reagents += R.type

/datum/effect/foam_spread/start()
	spawn(0)
		var/obj/effect/foam/F = locate() in location
		if(F)
			F.amount += amount
			return

		F = new /obj/effect/foam(location, metal)
		F.amount = amount

		if(!metal) // don't carry other chemicals if a metal foam
			F.create_reagents(10)

			if(carried_reagents)
				for(var/id in carried_reagents)
					F.reagents.add_reagent(id, 1, safety = 1) //makes a safety call because all reagents should have already reacted anyway
			else
				F.reagents.add_reagent(/datum/reagent/water, 1, safety = 1)

// wall formed by metal foams, dense and opaque, but easy to break

/obj/structure/foamedmetal
	icon = 'icons/effects/effects.dmi'
	icon_state = "metalfoam"
	density = TRUE
	opacity = 1 // changed in New()
	anchored = TRUE
	name = "foamed metal"
	desc = "A lightweight foamed metal wall."
	var/metal = 1 // 1 = aluminium, 2 = iron
	atmos_canpass = CANPASS_NEVER

/obj/structure/foamedmetal/iron
	icon_state = "ironfoam"
	metal = 2

/obj/structure/foamedmetal/New()
	..()
	update_nearby_tiles(1)

/obj/structure/foamedmetal/Destroy()
	set_density(0)
	update_nearby_tiles(1)
	. = ..()

/obj/structure/foamedmetal/on_update_icon()
	if(metal == 1)
		icon_state = "metalfoam"
	else
		icon_state = "ironfoam"

/obj/structure/foamedmetal/ex_act(severity)
	qdel(src)

/obj/structure/foamedmetal/bullet_act()
	if(metal == 1 || prob(50))
		qdel(src)

/obj/structure/foamedmetal/attack_hand(mob/user)
	if ((MUTATION_FERAL in user.mutations) || prob(75 - metal * 25))
		user.visible_message(SPAN_WARNING("[user] smashes through the foamed metal."), SPAN_NOTICE("You smash through the metal foam wall."))
		qdel(src)
	else
		to_chat(user, SPAN_NOTICE("You hit the metal foam but bounce off it."))
	return


/obj/structure/foamedmetal/use_grab(obj/item/grab/grab, list/click_params)
	// Harm intent - Smash through foam
	if (grab.assailant.a_intent == I_HURT)
		if (!Adjacent(grab.affecting))
			USE_FEEDBACK_GRAB_FAILURE("\The [grab.affecting] must be next to \the [src] to smash them into it.")
			return TRUE
		grab.assailant.visible_message(
			SPAN_WARNING("\The [grab.assailant] smashes \the [grab.affecting] through \the [src]!"),
			SPAN_DANGER("You smash \the [grab.affecting] through \the [src]!"),
			exclude_mobs = list(grab.affecting)
		)
		grab.affecting.show_message(
			SPAN_DANGER("\The [grab.assailant] smashes you through \the [src]!"),
			VISIBLE_MESSAGE,
			SPAN_DANGER("You feel yourself being smashed through something!")
		)
		qdel(grab)
		qdel_self()
		return TRUE

	return ..()


/obj/structure/foamedmetal/use_weapon(obj/item/weapon, mob/user, list/click_params)
	// Snowflake damage handling - TODO: Use standardized damage
	if (weapon.force > 0 && !HAS_FLAGS(weapon.item_flags, ITEM_FLAG_NO_BLUDGEON))
		user.setClickCooldown(user.get_attack_speed(weapon))
		user.do_attack_animation(src)
		if (prob(weapon.force * 20 - metal * 25))
			playsound(src, damage_hitsound, 75, TRUE)
			user.visible_message(
				SPAN_WARNING("\The [user] smashes through \the [src] with \a [weapon]!"),
				SPAN_DANGER("You smash through \the [src] with \the [weapon]!")
			)
			qdel_self()
			return TRUE
		playsound(src, damage_hitsound, 50, TRUE)
		user.visible_message(
			SPAN_WARNING("\The [user] hits \the [src] with \a [weapon]!"),
			SPAN_DANGER("You hit \the [src] with \the [weapon]!")
		)
		return TRUE

	return ..()
