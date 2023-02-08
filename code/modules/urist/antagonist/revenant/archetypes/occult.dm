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

/obj/effect/rune/revenant


/obj/effect/rune/revenant/attack_hand(var/mob/living/user)
	if(istype(user.wear_mask, /obj/item/clothing/mask/muzzle) || user.silent)
		to_chat(user, "You are unable to speak the words of the rune.")
		return

	if(isbsrevenant(user, TRUE))
		return src.cast(user)

	. = ..()
	return


/obj/effect/rune/revenant/ward
	strokes = 8

	// these are set 'properly' at runtime
	var/activated_at = 0
	var/lifespan = 15 MINUTES
	var/active = FALSE


/obj/effect/rune/revenant/ward/proc/IsExpired()
	var/check_time = world.time
	var/timedelta = (check_time - src.activated_at)
	var/lifespan = (src.lifespan || 0)

	if(timedelta > lifespan)
		return TRUE

	return FALSE


/obj/effect/rune/revenant/ward/proc/Activate()
	src.active = TRUE
	src.activated_at = world.time
	src.lifespan = rand(10, 20) MINUTES
	src.visible_message(SPAN_WARNING("The [src.name] glows a bloody red!"))
	return TRUE


/obj/effect/rune/revenant/ward/proc/Deactivate()
	src.active = FALSE
	src.visible_message(SPAN_NOTICE("The [src.name]'s glow fades slowly..."))
	return TRUE


/obj/effect/rune/revenant/ward/cast(var/mob/living/user)
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


/obj/effect/rune/revenant/ward/proc/register_ward(var/datum/bluespace_revenant/revenant)
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
	set category = "Anomalous Powers"
	set name = "Draw Wards"
	set desc = "Draw a rune that will stabilize you, reducing your effective Distortion generation."

	var/const/self_msg = "You slice open one of your fingers and begin drawing a rune on the floor whilst chanting the ritual that binds your life essence with the dark arcane energies flowing through the surrounding world."
	src.visible_message(SPAN_WARNING("\The [src] slices open a finger and begins to chant and paint symbols on the floor."), SPAN_NOTICE("[self_msg]"), "You hear chanting.")

	var/turf/T = get_turf(src)

	if(T.holy)
		to_chat(src, SPAN_WARNING("This place is blessed, you may not draw runes on it - defile it first."))
		return

	if(!istype(T, /turf/simulated))
		to_chat(src, SPAN_WARNING("You need more space to draw a rune here."))
		return

	if(locate(/obj/effect/rune) in T)
		to_chat(src, SPAN_WARNING("There's already a rune here.")) // Don't cross the runes
		return

	if(do_after(src, 10))
		pay_for_rune(5)

		if(locate(/obj/effect/rune) in T)
			return

		var/obj/effect/rune/revenant/ward/R = new(T, get_rune_color(), get_blood_name())

		// Randomize appearance
		R.strokes = rand(1, 10)
		R.on_update_icon()

		var/area/A = get_area(R)
		log_and_message_admins("created a rune-ward at \the [A.name].")
		R.add_fingerprint(src)

		R.cast(src)

		return TRUE

	return


/datum/power/revenant/bs_hunger/rune_wards
	flavor_tags = list(
		BSR_FLAVOR_OCCULT,
		BSR_FLAVOR_CULTIST,
		BSR_FLAVOR_GENERIC
	)
	name = "Runic Wards"
	isVerb = TRUE
	verbpath = /mob/proc/revenant_draw_wards
	activate_message = "<span class='notice'>You remember an intricate pattern that will slow your Distortion growth for a while when drawn on the floor in blood. This scales for each active rune.</span>"


/datum/bluespace_revenant/proc/ProcessRuneWards(var/ticks = 1)
	if(isnull(src.trackers))
		src.trackers = list()

	var/suppression_per_ward = BSR_DISTORTION_GROWTH_OVER_DECISECONDS(0.05 * BSR_DEFAULT_DECISECONDS_PER_TICK, BSR_DEFAULT_DISTORTION_PER_TICK, BSR_DEFAULT_DECISECONDS_PER_TICK)
	var/const/max_suppression_coeff = 0.95 // there will always be 5% of base suppression leaking through
	var/active_wards = 0
	var/expiring_wards = 0

	var/list/wards_list = src.trackers[TRACKER_KEY_WARDS]
	if(isnull(wards_list))
		wards_list = list()

	var/list/new_wards_list = list()

	for(var/weakref/ward_ref in wards_list)
		var/obj/effect/rune/revenant/ward/ward = ward_ref.resolve()

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
		new_wards_list.Add(ward_ref)

	var/effective_suppression_per_tick = min((src._distortion_per_tick * max_suppression_coeff), active_wards * suppression_per_ward)
	var/effective_suppression_total = effective_suppression_per_tick * ticks
	to_world_log("BSR: Found a total of [active_wards] wards for a suppression value [effective_suppression_total]")

	if(expiring_wards > 0)
		var/mob/M = src?.mob_ref?.resolve()
		if(istype(M))
			to_chat(M, "You sense [expiring_wards] of your wards have expired recently.")

	src.suppressed_distortion += effective_suppression_total
	src.trackers[TRACKER_KEY_WARDS] = new_wards_list // remove dead refs
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
		M.bluespace_revenant.AddCallback(/datum/bluespace_revenant/proc/ProcessRuneWards)

	return


/datum/power/revenant/distortion/cultify
	flavor_tags = list(
		BSR_FLAVOR_OCCULT,
		BSR_FLAVOR_CULTIST,
		BSR_FLAVOR_GENERIC
	)
	name = "DISTORTION: Cultify"


/datum/power/revenant/distortion/cultify/Apply(var/atom/A, var/datum/bluespace_revenant/revenant)
	var/mob/M = A
	var/turf/T = A

	if(istype(M))
		M.cultify()

	if(istype(T))
		T.cultify()

	return TRUE



/proc/bsrevenant_veiltear_helper(var/atom/A, var/datum/bluespace_revenant/revenant, var/list/mobselection_override = null, var/faction_override = null)
	if(!istype(A))
		return

	if(!istype(revenant))
		return

	var/turf/T = get_turf(A)
	if(!istype(T))
		return

	if(!istype(revenant.trackers))
		revenant.trackers = list()

	var/previous_time = revenant.trackers["last veil tear time"]
	var/current_time = world.time

	var/obj/effect/gateway/hole = new(T)
	hole.density = 0

	QDEL_IN(hole, 30 SECONDS)

	if(isnull(previous_time) || ((current_time - previous_time) > 1 MINUTES))
		revenant.trackers["last veil tear time"] = current_time

		spawn(rand(15, 25 SECONDS))
			var/list/possible_spawns = mobselection_override

			if(!istype(possible_spawns) || !(possible_spawns?.len))
				possible_spawns = list(
					/mob/living/simple_animal/hostile/urist/imp,
					/mob/living/simple_animal/hostile/scarybat/cult,
					/mob/living/simple_animal/hostile/faithless/cult
				)

			var/spawn_type = pick(possible_spawns)
			var/mob/living/L = new spawn_type(T)
			if(faction_override)
				L.faction = faction_override

			L.visible_message(SPAN_WARNING("\A [L] escapes from the portal!"))

	return TRUE



/datum/power/revenant/distortion/veil_tear
	flavor_tags = list(
		BSR_FLAVOR_OCCULT,
		BSR_FLAVOR_CULTIST,
		BSR_FLAVOR_DEMONIC,
		BSR_FLAVOR_GENERIC
	)
	name = "DISTORTION - Veil Tear"


/datum/power/revenant/distortion/veil_tear/Apply(var/atom/A, var/datum/bluespace_revenant/revenant)
	if(isnull(A) || !istype(A))
		return

	if(!istype(revenant))
		return

	var/list/possible_spawns = list(
		/mob/living/simple_animal/hostile/scarybat/cult,
		/mob/living/simple_animal/hostile/faithless/cult
	)

	if(prob(1))
		// minor easter egg
		possible_spawns.Add(/mob/living/simple_animal/hostile/urist/imp)

	. = bsrevenant_veiltear_helper(A, "anomalous", possible_spawns)

	return



/mob/proc/bsrevenant_veil_rip()
	set category = "Anomalous Powers"
	set name = "Veil Rip"
	set desc = "Open a dark portal to summon monsters from beyond. WARNING: they are NOT friendly!"

	var/atom/A = get_turf(src)

	if(isnull(A) || !istype(A))
		return

	var/list/possible_spawns = list(
		/mob/living/simple_animal/hostile/creature/cult,
		/mob/living/simple_animal/hostile/faithless/cult
	)

	. = bsrevenant_veiltear_helper(A, "anomalous", possible_spawns)

	var/datum/bluespace_revenant/revenant = src.mind?.bluespace_revenant
	if(istype(revenant))
		revenant.total_distortion += BSR_DISTORTION_GROWTH_OVER_MINUTES(10, BSR_DEFAULT_DISTORTION_PER_TICK, BSR_DEFAULT_DECISECONDS_PER_TICK)
		to_chat(src, SPAN_WARNING("You're feeling significantly less *real*..."))

	return


/datum/power/revenant/bs_power/veil_tear
	flavor_tags = list(
		BSR_FLAVOR_OCCULT,
		BSR_FLAVOR_CULTIST,
		BSR_FLAVOR_DEMONIC
	)
	name = "Rip the Veil"
	activate_message = ("<span class='notice'>You realize creatures from beyond are creeping on the edges of reality, just waiting for someone to reach out and invite them over.</span>")
	isVerb = TRUE
	verbpath = /mob/proc/bsrevenant_veil_rip
