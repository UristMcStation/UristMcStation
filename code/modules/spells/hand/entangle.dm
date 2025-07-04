/spell/hand/charges/entangle
	name = "Entangle"
	desc = "This spell creates vines that immediately entangle a nearby victim."
	feedback = "ET"
	school = "transmutation"
	charge_max = 600
	spell_flags = NEEDSCLOTHES | SELECTABLE | IGNOREPREV
	invocation = "Bu-Ekel'Inas!"
	invocation_type = SpI_SHOUT
	range = 3
	max_casts = 1

	level_max = list(Sp_TOTAL = 2, Sp_SPEED = 2, Sp_POWER = 2)
	cooldown_min = 30 SECONDS
	duration = 3 SECONDS
	compatible_targets = list(/mob)

	hud_state = "wiz_entangle"
	cast_sound = 'sound/magic/staff_door.ogg'
	show_message = " points towards the ground, causing plants to erupt!"
	var/datum/seed/seed

/spell/hand/charges/entangle/New()
	..()
	seed = new()
	seed.set_trait(TRAIT_PLANT_ICON,"flower")
	seed.set_trait(TRAIT_PRODUCT_ICON,"flower2")
	seed.set_trait(TRAIT_PRODUCT_COLOUR,"#4d4dff")
	seed.set_trait(TRAIT_SPREAD,2)
	seed.name = "heirlooms"
	seed.seed_name = "heirloom"
	seed.display_name = "vines"
	seed.chems = list(/datum/reagent/nutriment = list(1,20))

/spell/hand/charges/entangle/cast_hand(mob/M,mob/user)
	var/turf/T = get_turf(M)
	var/obj/vine/single/P = new(T,seed, start_matured =1)
	P.can_buckle = TRUE

	if (!P.can_buckle(M))
		P.visible_message(SPAN_WARNING("\The [P] appear from the floor, attempting to wrap around \the [M], but slip free and disappear!"))
		qdel(src)
		return TRUE
	P.buckle_mob(M)
	M.set_dir(pick(GLOB.cardinal))
	M.visible_message(SPAN_DANGER("[P] appear from the floor, spinning around \the [M] tightly!"))
	return ..()

/spell/hand/charges/entangle/empower_spell()
	if(!..())
		return 0

	max_casts++

	return "This spell will now entangle [max_casts] times before running out."
