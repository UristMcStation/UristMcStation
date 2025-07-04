/obj/item/forensics
	icon = 'icons/obj/forensics.dmi'
	w_class = ITEM_SIZE_TINY

//This is the output of the stringpercent(print) proc, and means about 80% of
//the print must be there for it to be complete.  (Prints are 32 digits)
var/global/const/FINGERPRINT_COMPLETE = 6
/proc/is_complete_print(print)
	return stringpercent(print) <= FINGERPRINT_COMPLETE

/// LAZYLIST of mobs that have touched/used the atom. Used for staff investigation. Each entry includes a timestamp and name of the mob that generated the fingerprint. Do not modify directly. See `add_hiddenprint()`.
/atom/var/list/fingerprintshidden
/// String. The last ckey to generate fingerprints on this atom. Used to reduce the number of duplicate `fingerprintshidden` entries.
/atom/var/fingerprintslast

/// LAZYLIST of clothing fibers persent on the atom. Do not modify directly. See `add_fibers()` and `transfer_fingerprints_to()`.
/atom/var/list/suit_fibers
/// LAZYLIST of fingerprints present on the atom. Index is the full print, value is either the full print or a starred version of the full print as a partial. Do not modify directly. See `add_fingerprint()`, `add_partial_print()`, and `transfer_fingerprints_to()`.
/atom/var/list/fingerprints
/// LAZYLIST of gunshot residue present on the atom. Each entry contains the caliber of ammunition that generated the residue. Updated by `/obj/item/ammo_casing/proc/put_residue_on()`.
/atom/var/list/gunshot_residue
/obj/item/var/list/trace_DNA

/**
 * Adds fingerprint logs to the atom's hidden prints.
 *
 * **Parameters**:
 * - `M` - The mob to add fingerprints from.
 *
 * Returns boolean.
 */
/atom/proc/add_hiddenprint(mob/M)
	if(!M || !M.key)
		return
	if(fingerprintslast == M.key)
		return
	fingerprintslast = M.key
	if(!fingerprintshidden)
		fingerprintshidden = list()
	if (ishuman(M))
		var/mob/living/carbon/human/H = M
		if (H.gloves)
			src.fingerprintshidden += "\[[time_stamp()]\] (Wearing gloves). Real name: [H.real_name], Key: [H.key]"
			return 0

	src.fingerprintshidden += "\[[time_stamp()]\] Real name: [M.real_name], Key: [M.key]"
	return 1


/**
 * Adds fingerprints to an atom from a mob.
 *
 * **Parameters**:
 * - `M` - The mob to add fingerprints from.
 * - `ignoregloves` (boolean) - Whether or not the proc should ignore the presence of gloves on the mob.
 * - `tool` - The tool in the mob's active hand. Used to check if the tool should prevent fingerprints.
 *
 * Returns boolean. `TRUE` if fingerprints were added, `FALSE` otherwise.
 */
/atom/proc/add_fingerprint(mob/M, ignoregloves, obj/item/tool)
	if(isnull(M)) return
	if(isAI(M)) return
	if(!M || !M.key)
		return
	if(istype(tool) && (tool.item_flags & ITEM_FLAG_NO_PRINT))
		return

	add_hiddenprint(M)
	add_fibers(M)

	if(!fingerprints)
		fingerprints = list()

	//Hash this shit.
	var/full_print = M.get_full_print(ignoregloves)
	if(!full_print)
		return

	//Using prints from severed hand items!
	var/obj/item/organ/external/E = M.get_active_hand()
	if(src != E && istype(E) && E.get_fingerprint())
		full_print = E.get_fingerprint()
		ignoregloves = 1

	if(!ignoregloves && ishuman(M))
		var/mob/living/carbon/human/H = M
		if (H.gloves && H.gloves.body_parts_covered & HANDS && H.gloves != src)
			if(istype(H.gloves, /obj/item/clothing/gloves)) //Don't add prints if you are wearing gloves.
				var/obj/item/clothing/gloves/G = H.gloves
				if(!G.clipped) //Fingerless gloves leave prints.
					return 0
			else if(prob(75))
				return 0
			H.gloves.add_fingerprint(M)

	// Add the fingerprints
	add_partial_print(full_print)
	return 1


/**
 * Adds a partial print to the atom's fingerprints list.
 *
 * **Parameters**:
 * - `full_print` (string) - The full fingerprint to be converted to a partial.
 * - `bonus` (int) - Additional bonus to the chance of a more complete print.
 */
/atom/proc/add_partial_print(full_print, bonus)
	LAZYINITLIST(fingerprints)
	if(!fingerprints[full_print])
		fingerprints[full_print] = stars(full_print, rand(0, 20))	//Initial touch, not leaving much evidence the first time.
	else
		switch(stringpercent(fingerprints[full_print]))		//tells us how many stars are in the current prints.
			if(28 to 32)
				if(prob(1))
					fingerprints[full_print] = full_print 		// You rolled a one buddy.
				else
					fingerprints[full_print] = stars(full_print, rand(0,40)) // 24 to 32

			if(24 to 27)
				if(prob(3))
					fingerprints[full_print] = full_print     	//Sucks to be you.
				else
					fingerprints[full_print] = stars(full_print, rand(15, 55)) // 20 to 29

			if(20 to 23)
				if(prob(5))
					fingerprints[full_print] = full_print		//Had a good run didn't ya.
				else
					fingerprints[full_print] = stars(full_print, rand(30, 70)) // 15 to 25

			if(16 to 19)
				if(prob(5))
					fingerprints[full_print] = full_print		//Welp.
				else
					fingerprints[full_print]  = stars(full_print, rand(40, 100))  // 0 to 21

			if(0 to 15)
				if(prob(5))
					fingerprints[full_print] = stars(full_print, rand(0,50)) 	// small chance you can smudge.
				else
					fingerprints[full_print] = full_print

/**
 * Transfers this atom's fingerprints, fibres, DNA, etc to the target atom.
 *
 * **Parameters**:
 * - `A` - The atom to transfer data to.
 */
/atom/proc/transfer_fingerprints_to(atom/A)
	if(fingerprints)
		LAZYDISTINCTADD(A.fingerprints, fingerprints)
	if(fingerprintshidden)
		LAZYDISTINCTADD(A.fingerprintshidden, fingerprintshidden)
		A.fingerprintslast = fingerprintslast
	if(suit_fibers)
		LAZYDISTINCTADD(A.suit_fibers, suit_fibers)
	if(blood_DNA)
		LAZYDISTINCTADD(A.blood_DNA, blood_DNA)
	if(gunshot_residue)
		var/obj/item/clothing/C = A
		LAZYDISTINCTADD(C.gunshot_residue, gunshot_residue)

/obj/item/transfer_fingerprints_to(atom/A)
	..()
	if(istype(A,/obj/item) && trace_DNA)
		var/obj/item/I = A
		LAZYDISTINCTADD(I.trace_DNA, trace_DNA)


/**
 * Adds forensics fibers to the atom from clothing worn by a mob.
 *
 * **Parameters**:
 * - `M` - The mob to pull fibers from.
 */
/atom/proc/add_fibers(mob/living/carbon/human/M)
	if(!istype(M))
		return
	if(M.gloves && istype(M.gloves,/obj/item/clothing/gloves))
		var/obj/item/clothing/gloves/G = M.gloves
		if(G.blood_transfer_amount >= 1) //bloodied gloves transfer blood to touched objects
			var/taken = rand(1, G.blood_transfer_amount)
			if(add_blood_custom(G.blood_color, taken, G.blood_DNA)) //only reduces the bloodiness of our gloves if the item wasn't already bloody
				G.blood_transfer_amount -= taken
	else if(M.bloody_hands)
		var/taken = rand(1, M.bloody_hands)
		if(add_blood_custom(M.hand_blood_color, taken, M.hands_blood_DNA))
			M.bloody_hands -= taken

	var/fibertext
	var/item_multiplier = istype(src,/obj/item)?1.2:1
	var/suit_coverage = 0
	if(istype(M.wear_suit, /obj/item/clothing))
		var/obj/item/clothing/C = M.wear_suit
		fibertext = C.get_fibers()
		if(fibertext && prob(10*item_multiplier))
			LAZYDISTINCTADD(suit_fibers, fibertext)
		suit_coverage = C.body_parts_covered

	if(istype(M.w_uniform, /obj/item/clothing) && (M.w_uniform.body_parts_covered & ~suit_coverage))
		var/obj/item/clothing/C = M.w_uniform
		fibertext = C.get_fibers()
		if(fibertext && prob(15*item_multiplier))
			LAZYDISTINCTADD(suit_fibers, fibertext)

	if(istype(M.gloves, /obj/item/clothing) && (M.gloves.body_parts_covered & ~suit_coverage))
		var/obj/item/clothing/C = M.gloves
		fibertext = C.get_fibers()
		if(fibertext && prob(20*item_multiplier))
			LAZYDISTINCTADD(suit_fibers, fibertext)

/obj/item/proc/add_trace_DNA(mob/living/carbon/M)
	if(!istype(M))
		return
	if(M.isSynthetic())
		return
	if(istype(M.dna))
		LAZYDISTINCTADD(trace_DNA, M.dna.unique_enzymes)

/mob/proc/get_full_print()
	return FALSE

/mob/living/carbon/get_full_print()
	if (!dna || (mFingerprints in mutations))
		return FALSE
	return md5(dna.uni_identity)

/mob/living/carbon/human/get_full_print(ignoregloves)
	if(!..())
		return FALSE

	var/obj/item/organ/external/E = organs_by_name[hand ? BP_L_HAND : BP_R_HAND]
	if(E)
		return E.get_fingerprint()
