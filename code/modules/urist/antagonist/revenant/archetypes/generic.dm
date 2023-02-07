/*
// Just for organization - cross-cutting power stuff that didn't make sense anywhere particular
*/


/obj/effect/effect/smoke/mist
	name = "fog"
	opacity = 0
	alpha = 128
	time_to_live = 1000


/datum/effect/effect/system/smoke_spread/mist
	smoke_type = /obj/effect/effect/smoke/mist


/datum/power/revenant/distortion/fogweaver
	flavor_tags = list(
		BSR_FLAVOR_OCCULT,
		BSR_FLAVOR_CULTIST,
		BSR_FLAVOR_DEMONIC,
		BSR_FLAVOR_GENERIC
	)
	name = "DISTORTION: Fogweaver"


/datum/power/revenant/distortion/fogweaver/Apply(var/atom/A, var/datum/bluespace_revenant/revenant)
	if(isnull(A) || !istype(A))
		return

	var/turf/T = get_turf(A)
	if(!istype(T))
		return

	// There's a reason behind this varname and it's horrible. --scr
	var/datum/effect/effect/system/smoke_spread/mist/funfog = new()
	funfog.set_up(5, 0, T)
	funfog.start()

	return TRUE



/datum/power/revenant/distortion/techbane
	flavor_tags = list(
		BSR_FLAVOR_GENERIC,
		BSR_FLAVOR_SCIFI,
		BSR_FLAVOR_BLUESPACE
	)
	name = "DISTORTION: Techbane"


/datum/power/revenant/distortion/techbane/Apply(var/atom/A, var/datum/bluespace_revenant/revenant)
	if(isnull(A) || !istype(A))
		return

	var/turf/T = get_turf(A)
	if(!istype(T))
		return

	empulse(T, 0, 1)

	return TRUE
