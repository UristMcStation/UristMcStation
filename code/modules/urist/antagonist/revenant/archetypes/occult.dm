/* OCCULT REVENANT ARCHETYPE
//
// This is meant to be a Nar'Sie-flavored mode that messes with Cult metaknowledge.
//
// HUNGER: Characteristic: Wards - have to draw blood runes that passively slow Distortion growth while existing.
//
// POWERS: Cult creature summons, bloody mess, cult-rune-like powers
//
// SPOOPS: Cultify atoms, ghosts, uncontrollable summons
*/


/obj/effect/rune/revenant_ward
	var/created_at
	var/lifespan = 15 MINUTES
	var/active = TRUE


/obj/effect/rune/revenant_ward/New(var/loc, var/blcolor = "#c80000", var/nblood = "blood")
	. = ..(loc, blcolor, nblood)

	src.created_at = world.time
	src.lifespan = rand(10, 20) MINUTES
	return



/obj/effect/rune/revenant_ward/proc/IsExpired()
	var/check_time = world.time
	var/timedelta = (check_time - src.created_at)
	var/lifespan = (src.lifespan || 0)

	if(timedelta > lifespan)
		return TRUE

	return FALSE


/obj/effect/rune/revenant_ward/proc/Activate()
	src.active = TRUE
	src.visible_message("<span class='warning'>The [src.name] glows a bloody red!</span>")
	return TRUE


/obj/effect/rune/revenant_ward/proc/Deactivate()
	src.active = FALSE
	src.visible_message("<span class='notice'>The [src.name]'s glow fades slowly...</span>")
	return TRUE


/obj/effect/rune/revenant_ward/cast(var/mob/living/user)
	if(!istype(user))
		return

	if(!isbsrevenant(user))
		return ..()

	var/phrase = pick("Maranax shaantitus!", "Vilomaxus hatanoceo!") // references?! in my ss13?!
	user.say(phrase)

	var/activated = src.register_ward(user.mind.bluespace_revenant)

	if(activated)
		src.Activate()
		to_chat(user, "You have activated this ward. As long as it exists, it will help anchor you in reality.")
	return


/obj/effect/rune/revenant_ward/proc/register_ward(var/datum/bluespace_revenant/revenant)
	// Add a weakref to a rune to a tracker so that we can track their count and grant Suppression for each over time.

	if(!istype(revenant))
		return FALSE

	if(isnull(revenant.trackers))
		revenant.trackers = list()

	var/weakref/ward_ref = weakref(src)

	var/list/wards_list = revenant.trackers[TRACKER_KEY_WARDS]
	if(isnull(wards_list))
		wards_list = list()

	if(!(ward_ref in wards_list))
		wards_list += ward_ref

	revenant.trackers[TRACKER_KEY_WARDS] = wards_list
	return TRUE



/mob/proc/revenant_draw_wards()
	var/const/self_msg = "You slice open one of your fingers and begin drawing a rune on the floor whilst chanting the ritual that binds your life essence with the dark arcane energies flowing through the surrounding world."
	src.visible_message("<span class='warning'>\The [src] slices open a finger and begins to chant and paint symbols on the floor.</span>", "<span class='notice'>[self_msg]</span>", "You hear chanting.")

	var/turf/T = get_turf(src)

	if(T.holy)
		to_chat(src, "<span class='warning'>This place is blessed, you may not draw runes on it - defile it first.</span>")
		return

	if(!istype(T, /turf/simulated))
		to_chat(src, "<span class='warning'>You need more space to draw a rune here.</span>")
		return

	if(locate(/obj/effect/rune) in T)
		to_chat(src, "<span class='warning'>There's already a rune here.</span>") // Don't cross the runes
		return

	if(do_after(src, 10))
		pay_for_rune(5)

		if(locate(/obj/effect/rune) in T)
			return

		var/obj/effect/rune/revenant_ward/R = new(T, get_rune_color(), get_blood_name())

		var/area/A = get_area(R)
		log_and_message_admins("created a rune-ward at \the [A.name].")
		R.add_fingerprint(src)

		R.cast(src)

		return TRUE

	return


/datum/power/revenant/bs_hunger/rune_wards
	flavor_tags = list(
		BSR_FLAVOR_OCCULT,
		BSR_FLAVOR_GENERIC
	)
	name = "Runic Wards"
	isVerb = TRUE
	verbpath = /mob/proc/revenant_draw_wards


/datum/bluespace_revenant/proc/ProcessRuneWards(var/ticks = 1)
	if(isnull(src.trackers))
		src.trackers = list()

	var/const/suppression_per_ward = BSR_SUPPRESSION_IN_DECISECONDS(0.05 * BSR_DEFAULT_DECISECONDS_PER_TICK, BSR_DEFAULT_DISTORTION_PER_TICK, BSR_DEFAULT_DECISECONDS_PER_TICK)
	var/const/max_suppression_coeff = 0.95 // there will always be 5% of base suppression leaking through
	var/active_wards = 0
	var/expiring_wards = 0

	var/list/wards_list = src.trackers[TRACKER_KEY_WARDS]
	if(isnull(wards_list))
		wards_list = list()

	for(var/weakref/ward_ref in wards_list)
		var/obj/effect/rune/revenant_ward/ward = ward_ref.resolve()

		if(!istype(ward))
			continue

		if(!ward.active)
			continue

		var/is_expired = ward.IsExpired()
		if(is_expired)
			ward.Deactivate()
			expiring_wards++
			continue

		active_wards++

	var/effective_suppression_per_tick = min((src._distortion_per_tick * max_suppression_coeff), active_wards * suppression_per_ward)
	var/effective_suppression_total = effective_suppression_per_tick * ticks
	to_world_log("BSR: Found a total of [active_wards] wards for a suppression value [effective_suppression_total]")

	if(expiring_wards > 0)
		var/mob/M = src?.mob_ref?.resolve()
		if(istype(M))
			to_chat(M, "You sense [expiring_wards] of your wards have expired recently.")

	src.suppressed_distortion += effective_suppression_total
	return effective_suppression_total


/datum/power/revenant/bs_hunger/rune_wards/Activate(var/datum/mind/M)
	. = ..(M)

	if(!.)
		return

	if(!M.bluespace_revenant)
		return FALSE

	if(isnull(M.bluespace_revenant.callbacks))
		M.bluespace_revenant.callbacks = list()

	if(!(/datum/bluespace_revenant/proc/ProcessRuneWards in M.bluespace_revenant.callbacks))
		M.bluespace_revenant.callbacks.Add(/datum/bluespace_revenant/proc/ProcessRuneWards)

	return


/datum/power/revenant/bs_power/summon
	flavor_tags = list(
		BSR_FLAVOR_OCCULT,
		BSR_FLAVOR_GENERIC
	)
	name = "Summon Stuff"
	isVerb = TRUE
	verbpath = /mob/proc/revenant_draw_wards
