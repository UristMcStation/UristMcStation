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


/obj/effect/rune/revenant_ward/New(var/loc, var/blcolor = "#c80000", var/nblood = "blood")
	. = ..(loc, blcolor, nblood)
	return


/obj/effect/rune/revenant_ward/cast(var/mob/living/user)
	if(!istype(user))
		return

	if(!isbsrevenant(user))
		return ..()

	var/phrase = pick("Maranax shaantitus!", "Vilomaxus hatanoceo!") // references?! in my ss13?!
	user.say(phrase)

	var/activated = src.register_ward(user.mind.bluespace_revenant)

	if(activated)
		user.visible_message("<span class='warning'>The [src.name] glows a bloody red!</span>")
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



/datum/power/revenant/bs_power/summon
	flavor_tags = list(
		BSR_FLAVOR_OCCULT,
		BSR_FLAVOR_GENERIC
	)
	name = "Summon Stuff"
	isVerb = TRUE
	verbpath = /mob/proc/revenant_draw_wards
