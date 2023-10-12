#ifdef ENABLE_FOV_CODE


/datum/hud/human/FinalizeInstantiation()
	. = ..()

	if(config.enable_fov_cones || mymob.force_fov)
		if(ishuman(mymob))
			var/mob/living/carbon/human/H = mymob
			H.BuildFovHud()

	return

/client
	var/list/hidden_atoms = null
	var/list/hidden_mobs = null

/mob
	// weird trinary override - null is respect config, 0 is force-disable, 1 is force-enabled
	var/force_fov = null

/mob/living
	var/list/in_vision_cones = null

/mob/living/Move()
	. = ..()

	var/mob/living/carbon/human/H = src
	var/has_human_fov_stuff = (ishuman(src) && (H.fov || H.fov_mask))

	if(src.force_fov || config.enable_fov_cones || has_human_fov_stuff)

		if(config.enable_fov_cones)
			// expensive, so only do it if ALL mobs have it on
			// might be wonky if two mobs have it selectively on and the rest has it off
			// oview() is also a hack here - we should likely cache viewership and do a broad-phase check
			for(var/mob/M in oview(src))
				M.update_vision_cone()

		update_vision_cone()

/mob/living/Move(var/client/C)
	. = ..()

	if(config.enable_fov_cones || src.force_fov)

		if(isnull(in_vision_cones))
			in_vision_cones = list()

		for(C in in_vision_cones)
			if(src in C.hidden_mobs)
				var/turf/T = get_turf(src)
				var/image/I = image('icons/urist/fov/footstepsound.dmi', loc = T, icon_state = "default", layer = 18)
				C.images += I
				spawn(4)
					if(C)
						C.images -= I
			else
				in_vision_cones.Remove(C)

/mob/living/set_dir()
	. = ..()

	var/mob/living/carbon/human/H = src
	var/has_human_fov_stuff = (ishuman(src) && (H.fov || H.fov_mask))

	if(config.enable_fov_cones || src.force_fov || has_human_fov_stuff)
		update_vision_cone()

/*
/client/Move(n, direct)
	. = ..()
	if(isturf(mob.loc))
		if(mob.grabbed_by)
			mob.dir = turn(mob.dir, 180)
			mob.update_vision_cone()
*/

/mob/UpdateLyingBuckledAndVerbStatus()
	. = ..()

	var/mob/living/carbon/human/H = src
	var/has_human_fov_stuff = (ishuman(src) && (H.fov || H.fov_mask))

	if(config.enable_fov_cones || src.force_fov || has_human_fov_stuff)
		update_vision_cone()

/mob/living/carbon/human
	var/obj/screen/fov = null
	var/obj/screen/fov_mask = null
	// NOTE: this is just a bookkeeping var, NOT a flag!!!
	var/usefov = TRUE

/mob/living/carbon/human/update_equipment_vision()
	. = ..()

	if(!client)
		return

	if(config.enable_fov_cones || src.force_fov)

		if(isnull(fov) || isnull(fov_mask))
			src.BuildFovHud()

		var/obj/item/clothing/headwear = get_equipped_item(slot_head_str)
		var/obj/item/clothing/maskwear = get_equipped_item(slot_head_str)
		var/obj/item/clothing/eyeswear = get_equipped_item(slot_head_str)

		var/use_original_cone = TRUE

		if(istype(headwear) && headwear.helmet_vision \
		|| istype(maskwear) && maskwear.helmet_vision \
		|| istype(eyeswear) && eyeswear.helmet_vision)
			use_original_cone = FALSE

		if(use_original_cone)
			fov_mask.icon_state = "combat_mask"
			fov.icon_state = "combat"
		else
			fov_mask.icon_state = "helmet_mask"
			fov.icon_state = "helmet"

/obj/item/clothing
	var/helmet_vision = FALSE

/obj/item/clothing/needs_vision_update()
	return ..() || helmet_vision

#endif
