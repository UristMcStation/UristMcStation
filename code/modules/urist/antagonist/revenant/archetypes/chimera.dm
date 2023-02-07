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
		src << "<span class='warning'>Your hands are full.  Drop something first.</span>"
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


//Grows a scary, and powerful arm blade.
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
	activate_message = "<span class='notice'>You realize that anatomy is more of a suggestion than a hard rule for you. You can now twist your flesh into a vicious arm-blade - but it won't be pleasant and it will increase your Distortion.</span>"
	name = "Arm Blade"
	isVerb = TRUE
	verbpath = /mob/proc/bsrevenant_arm_blade



/datum/power/revenant/distortion/wallrot
	// will make an *IN*voluntary one as a Distortion  later
	flavor_tags = list(
		BSR_FLAVOR_CHIMERA,
		BSR_FLAVOR_GENERIC,
		BSR_FLAVOR_SCIFI,
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
