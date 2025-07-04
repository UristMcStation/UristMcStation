/datum/grab/normal/neck
	state_name = NORM_NECK

	upgrab_name = NORM_KILL
	downgrab_name = NORM_AGGRESSIVE

	drop_headbutt = 0

	shift = -10


	stop_move = 1
	force_stand = TRUE
	reverse_facing = 1
	can_absorb = 1
	shield_assailant = 1
	point_blank_mult = 2
	damage_stage = 2
	same_tile = 1
	can_throw = 1
	force_danger = 1
	restrains = 1

	icon_state = "kill"

	break_chance_table = list(8, 20, 40, 60, 100)

/datum/grab/normal/neck/process_effect(obj/item/grab/G)
	var/mob/living/carbon/human/affecting = G.affecting
	var/mob/living/carbon/human/assailant = G.assailant
	var/datum/pronouns/pronouns = assailant.choose_from_pronouns()

	if (assailant.incapacitated(INCAPACITATION_ALL))
		affecting.visible_message(SPAN_WARNING("\The [assailant] lets go of [pronouns.his] grab!"))
		qdel(G)
		return

	affecting.drop_l_hand()
	affecting.drop_r_hand()

	if(affecting.lying)
		affecting.Weaken(4)

	if(affecting.stat != CONSCIOUS)
		force_stand = FALSE
		shield_assailant = FALSE

	else
		force_stand = TRUE
		shield_assailant = TRUE

	affecting.adjustOxyLoss(1)
