/* CHIMERA REVENANT ARCHETYPE
//
// This is meant to be more of a sci-fi/bio flavor.
//
// HUNGER: Should be fairly literal - eating meat, reagents or materials.
//
// POWERS: Ling- or genetics- like, body horror/regen, bizarre body parts.
//
// SPOOPS: Abnormal plant/animal behavior, weird growths, fungal/viral stuff.
*/

// This is a generic proc that should be called by other revenant weapon procs to equip them.
// Blatantly ripped off from Ling :^)
/mob/proc/bsrevenant_generic_weapon(var/weapon_type, var/make_sound = 1, var/cost = BSR_DISTORTION_GROWTH_OVER_MINUTES(5, BSR_DEFAULT_DISTORTION_PER_TICK, BSR_DEFAULT_DECISECONDS_PER_TICK), var/paincost = 50)
	var/datum/bluespace_revenant/revenant = src?.mind?.bluespace_revenant
	if(!revenant)
		return

	if(!ishuman(src))
		return 0

	var/mob/living/carbon/human/M = src

	if(M.l_hand && M.r_hand) //Make sure our hands aren't full.
		to_chat(src,SPAN_WARNING("Your hands are full.  Drop something first."))
		return 0

	var/obj/item/weapon/W = new weapon_type(src)
	src.put_in_hands(W)

	// The way Cost works for BSRs is that we increase their Total Distortion
	revenant.total_distortion += cost
	if(make_sound)
		playsound(src, 'sound/effects/blobattack.ogg', 30, 1)

	if(paincost > 0)
		M.custom_pain("Your tissues shift and twist unnaturally!", paincost)
	return 1


/* ARM BLADE - grows a scary, and powerful arm blade. Ling fakeout. */
/mob/proc/bsrevenant_arm_blade()
	set name = "Arm Blade"
	set category = "Anomalous Powers"
	set desc = "*Painfully* fleshcraft your arm into a vicious blade. Reality won't like this one bit."

	if(bsrevenant_generic_weapon(/obj/item/weapon/melee/arm_blade))
		return
	return


/datum/power/revenant/bs_power/voluntary_armblade
	// will make an *IN*voluntary one as a Distortion  later
	flavor_tags = list(
		BSR_FLAVOR_CHIMERA,
		BSR_FLAVOR_FLESH,
		BSR_FLAVOR_SCIFI,
	)
	activate_message = ("<span class='notice'>You realize that anatomy is more of a suggestion than a hard rule for you. You can now twist your flesh into a vicious arm-blade - but it won't be pleasant and it will increase your Distortion.</span>")
	name = "Arm Blade"
	isVerb = TRUE
	verbpath = /mob/proc/bsrevenant_arm_blade
	distortion_threshold = 72000 // 60 mins



/* WALLROT: Cause walls to sprout all sorts of fun guys */
/datum/power/revenant/distortion/wallrot
	flavor_tags = list(
		BSR_FLAVOR_CHIMERA,
		BSR_FLAVOR_GENERIC,
		BSR_FLAVOR_SCIFI,
		BSR_FLAVOR_DENTIST,
		BSR_FLAVOR_PLAGUE
	)
	name = "DISTORTION - Wallrot"


/datum/power/revenant/distortion/wallrot/Apply(var/atom/A, var/datum/bluespace_revenant/revenant)
	if(isnull(A) || !istype(A))
		return

	var/turf/T = get_turf(A)
	if(!istype(T))
		return

	var/turf/simulated/wall/W = T
	if(!istype(W))
		return

	W.rot()
	return TRUE



/* Simple heal. Does NOT regrow limbs. */
/mob/proc/bsrevenant_minor_heal()
	set name = "Fleshmend"
	set category = "Anomalous Powers"
	set desc = "Heal minor damage, stop bleeding. Use multiple times per each wound."

	// if TRUE, we're still waiting for a handler
	var/pending = TRUE

	var/mob/living/carbon/human/H = src

	if(istype(H))
		if(pending)
			for(var/obj/item/organ/I in H.internal_organs)
				if(I.damage >= 5)
					I.damage = max(I.damage - 5, 0)
					to_chat(H, SPAN_NOTICE("Your [I.name] itches as you knit its wounds shut."))
					pending = FALSE
					break

		for(var/obj/item/organ/external/E in H.bad_external_organs)
			if(!pending)
				break

			if((E.status & ORGAN_ARTERY_CUT))
				to_chat(H, SPAN_NOTICE("You mend the torn artery in your [E.name], stemming the worst of the bleeding."))
				E.status &= ~ORGAN_ARTERY_CUT
				pending = FALSE
				break

			for(var/datum/wound/W in E.wounds)
				if(W.bleeding())
					W.bleed_timer = 0
					E.status &= ~ORGAN_BLEEDING
					to_chat(H, SPAN_NOTICE("You knit together severed veins, stemming the bleeding from your [E.name]."))
					pending = FALSE
					break

			if(E.damage >= 5)
				to_chat(H, SPAN_NOTICE("Your [E.name] itches as you knit its wounds shut."))
				pending = FALSE
				break

	if(!pending)
		var/datum/bluespace_revenant/revenant = src?.mind?.bluespace_revenant
		if(istype(revenant))
			revenant.total_distortion += BSR_DISTORTION_GROWTH_OVER_SECONDS(30, BSR_DEFAULT_DISTORTION_PER_TICK, BSR_DEFAULT_DECISECONDS_PER_TICK)

	return !pending


/datum/power/revenant/bs_power/minorheal
	flavor_tags = list(
		BSR_FLAVOR_CHIMERA,
		BSR_FLAVOR_VAMPIRE,
		BSR_FLAVOR_GENERIC,
		BSR_FLAVOR_FLESH,
		BSR_FLAVOR_SCIFI,
	)
	activate_message = "<span class='notice'>You have an uncanny healing factor. You can heal minor damage and even stop bleeding - all at the low low price of just a little bit of damage to the local laws of physics.</span>"
	name = "Fleshmend"
	isVerb = TRUE
	verbpath = /mob/proc/bsrevenant_minor_heal
	distortion_threshold = 24000 // 20 mins


/* HONGRY - burn calories for Suppression */
/mob/proc/revenant_hungryhippo()
	set category = "Anomalous Powers"
	set name = "Catabolic Stabilization"
	set desc = "Burn through all of your nutrition to suppress your Distortion (scales with amount)."

	var/mob/living/carbon/C = src

	if(!istype(C))
		to_chat(src, "Your current mob type does not allow this power, sorry! If this blocks you as an antag, ask an admin for help rerolling your Hunger.")
		return

	if(C.stat == DEAD)
		return

	// Since this is a more stealthable Hunger, this should be fairly inefficient
	var/suppression_per_unit = BSR_DISTORTION_GROWTH_OVER_DECISECONDS(5, BSR_DEFAULT_DISTORTION_PER_TICK, BSR_DEFAULT_DECISECONDS_PER_TICK)

	var/removed = FALSE
	var/added_suppression = 0

	var/available_amt = C.nutrition
	var/consume_amt = max(0, available_amt)

	if(consume_amt > 0)
		C.nutrition -= consume_amt
		removed = consume_amt

		if(removed)
			added_suppression = (consume_amt * suppression_per_unit)
			to_chat(src, SPAN_WARNING("Your anomalous metabolism works overtime stabilizing you in reality, burning through calories like a furnace!"))

	else
		to_chat(src, SPAN_WARNING("You are starving, you have nothing to digest!"))
		return removed

	if(isbsrevenant(src))
		// We'll allow the proc to run for non-Revenants for funminnery purposes, it
		// will just not have any positive effects for the user (pure RP)
		if(src.mind && src.mind.bluespace_revenant)
			var/datum/bluespace_revenant/revenant_data = src.mind.bluespace_revenant

			if(istype(revenant_data))
				revenant_data.suppressed_distortion += added_suppression

	return removed


/datum/power/revenant/bs_hunger/hungryhippo
	flavor_tags = list(
		BSR_FLAVOR_BLUESPACE,
		BSR_FLAVOR_CHIMERA,
		BSR_FLAVOR_SCIFI,
		BSR_FLAVOR_DEMONIC,
		BSR_FLAVOR_FLESH,
		BSR_FLAVOR_DENTIST,
		BSR_FLAVOR_GENERIC
	)
	activate_message = ("<span class='notice'>You feel *insatiably* hungry. You can allow your metabolism to run wild, burning through all your stored nutrition as it stabilizes you in reality.</span>")
	name = "Catabolic Stabilization"
	isVerb = TRUE
	verbpath = /mob/proc/revenant_hungryhippo


/* GROSS - will spawn a bloody mess and make the Janitor cry */
/datum/power/revenant/distortion/gross
	flavor_tags = list(
		BSR_FLAVOR_CHIMERA,
		BSR_FLAVOR_GENERIC,
		BSR_FLAVOR_SCIFI,
		BSR_FLAVOR_FLESH,
		BSR_FLAVOR_DENTIST,
		BSR_FLAVOR_PLAGUE
	)
	name = "DISTORTION - Gross"


/datum/power/revenant/distortion/gross/Apply(var/atom/A, var/datum/bluespace_revenant/revenant)
	if(isnull(A) || !istype(A))
		return

	var/turf/T = get_turf(A)
	if(!istype(T))
		return

	var/picked_effect_type = pick(
		100; /obj/effect/decal/cleanable/mucus,
		100; /obj/effect/decal/cleanable/vomit,
		100; /obj/effect/decal/cleanable/greenglow
	)

	var/obj/effect/decal/cleanable/picked_effect = new picked_effect_type(T)

	if(istype(picked_effect))
		return TRUE

	return


/* BLOODYMESS - will spawn a bloody mess and make the Janitor cry */
/datum/power/revenant/distortion/bloodymess
	flavor_tags = list(
		// NOT Blood even though it's gory; Blood's meant to be more elegant
		BSR_FLAVOR_CHIMERA,
		BSR_FLAVOR_GENERIC,
		BSR_FLAVOR_SCIFI,
		BSR_FLAVOR_FLESH,
		BSR_FLAVOR_CULTIST,
		BSR_FLAVOR_DEMONIC,
		BSR_FLAVOR_OCCULT,
		BSR_FLAVOR_DENTIST,
		BSR_FLAVOR_PLAGUE
	)
	name = "DISTORTION - Bloody Mess"


/datum/power/revenant/distortion/bloodymess/Apply(var/atom/A, var/datum/bluespace_revenant/revenant)
	if(isnull(A) || !istype(A))
		return

	var/turf/T = get_turf(A)
	if(!istype(T))
		return

	var/obj/effect/gibspawner/generic/picked_effect = new(T)
	if(istype(picked_effect))
		return TRUE

	return


/* Mutation - strength */

/mob/proc/bsrevenant_mutate_stronk()
	set name = "-MUTATE STRENGTH-"
	set category = "Anomalous Powers"
	set desc = "Oops! You shouldn't be seeing this as a verb, please notify admins/coders!"

	var/mob/living/carbon/human/H = src

	if(!istype(H))
		return

	if(!istype(H.species))
		// just in case...
		H.species = new()

	H.species.strength = STR_VHIGH
	H.species.brute_mod *= 0.8
	H.species.stun_mod *= 0.8
	H.species.weaken_mod *= 0.8
	return TRUE


/datum/power/revenant/bs_power/mutate_stronk
	flavor_tags = list(
		BSR_FLAVOR_CHIMERA,
		BSR_FLAVOR_VAMPIRE,
		BSR_FLAVOR_DEMONIC,
		BSR_FLAVOR_FLESH
	)
	activate_message = "<span class='notice'>Your body has become unnaturally tough!</span>"
	name = "Unnatural Resilience"
	isVerb = FALSE
	verbpath = /mob/proc/bsrevenant_mutate_stronk
	distortion_threshold = 12000 // 10 mins
