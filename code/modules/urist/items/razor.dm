/**********************\
|		 Razors		   |
\**********************/

/proc/get_location_accessible(mob/M, location)
	var/covered_locations	= 0	//based on body_parts_covered
	var/face_covered		= 0	//based on flags_inv
	var/eyesmouth_covered	= 0	//based on flags
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		for(var/obj/item/clothing/I in list(C.back, C.wear_mask))
			covered_locations |= I.body_parts_covered
			face_covered |= I.flags_inv
			eyesmouth_covered |= I.item_flags
		if(ishuman(C))
			var/mob/living/carbon/human/H = C
			for(var/obj/item/I in list(H.wear_suit, H.w_uniform, H.shoes, H.belt, H.gloves, H.glasses, H.head, H.r_ear, H.l_ear))
				covered_locations |= I.body_parts_covered
				face_covered |= I.flags_inv
				eyesmouth_covered |= I.item_flags

	switch(location)
		if("head")
			if(covered_locations & HEAD)
				return 0
		if("eyes")
			if(covered_locations & HEAD || covered_locations & EYES)
				return 0
		if("mouth")
			if(covered_locations & HEAD || covered_locations & FACE)
				return 0
		if("chest")
			if(covered_locations & UPPER_TORSO)
				return 0
		if("groin")
			if(covered_locations & LOWER_TORSO)
				return 0
		if("l_arm")
			if(covered_locations & ARM_LEFT)
				return 0
		if("r_arm")
			if(covered_locations & ARM_RIGHT)
				return 0
		if("l_leg")
			if(covered_locations & LEG_LEFT)
				return 0
		if("r_leg")
			if(covered_locations & LEG_RIGHT)
				return 0
		if("l_hand")
			if(covered_locations & HAND_LEFT)
				return 0
		if("r_hand")
			if(covered_locations & HAND_RIGHT)
				return 0
		if("l_foot")
			if(covered_locations & FOOT_LEFT)
				return 0
		if("r_foot")
			if(covered_locations & FOOT_RIGHT)
				return 0

	return 1

/obj/item/razor
	item_icons = DEF_URIST_INHANDS
	name = "electric razor"
	desc = "The latest and greatest power razor born from the science of shaving."
	icon = 'icons/urist/items/tgitems.dmi'
	icon_state = "razor"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	w_class = 1.0

/obj/item/razor/attack(mob/living/carbon/M as mob, mob/user as mob)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(user.zone_sel.selecting == "mouth")
			if(!get_location_accessible(H, "mouth"))
				to_chat(user, "<span class='warning'>The mask is in the way.</span>")
				return
			if(H.facial_hair_style == "Shaved")
				to_chat(user, "<span class='notice'>Already clean-shaven.</span>")
				return
			if(H == user) //shaving yourself
				user.visible_message("<span class='notice'>[user] starts to shave their facial hair with \the [src].</span>", \
				"<span class='notice'>You take a moment shave your facial hair with \the [src].</span>")
				if(do_after(user, 50))
					user.visible_message("<span class='notice'>[user] shaves his facial hair clean with the [src].</span>", \
					"<span class='notice'>You finish shaving with the [src]. Fast and clean!</span>")
					H.facial_hair_style = "Shaved"
					H.update_hair()
					playsound(src.loc, 'sound/items/Welder2.ogg', 20, 1)
			else
				var/turf/user_loc = user.loc
				var/turf/H_loc = H.loc
				user.visible_message("<span class='danger'>[user] tries to shave [H]'s facial hair with \the [src].</span>", \
				"<span class='warning'>You start shaving [H]'s facial hair.</span>")
				if(do_after(user, 50))
					if(user_loc == user.loc && H_loc == H.loc)
						user.visible_message("<span class='danger'>[user] shaves off [H]'s facial hair with \the [src].</span>", \
						"<span class='notice'>You shave [H]'s facial hair clean off.</span>")
						H.facial_hair_style = "Shaved"
						H.update_hair()
						playsound(src.loc, 'sound/items/Welder2.ogg', 20, 1)
		if(user.zone_sel.selecting == "head")
			if(!get_location_accessible(H, "head"))
				to_chat(user, "<span class='warning'>The headgear is in the way.</span>")
				return
			if(H.head_hair_style == "Bald" || H.head_hair_style == "Balding Hair" || H.head_hair_style == "Skinhead")
				to_chat(user, "<span class='notice'>There is not enough hair left to shave...</span>")
				return
			if(H == user) //shaving yourself
				user.visible_message("<span class='warning'>[user] starts to shave their head with \the [src].</span>", \
				"<span class='warning'>You start to shave your head with \the [src].</span>")
				if(do_after(user, 50))
					user.visible_message("<span class='notice'>[user] shaves his head with the [src].</span>", \
					"<span class='notice'>You finish shaving with the [src].</span>")
					H.head_hair_style = "Skinhead"
					H.update_hair()
					playsound(src.loc, 'sound/items/Welder2.ogg', 40, 1)
			else
				var/turf/user_loc = user.loc
				var/turf/H_loc = H.loc
				user.visible_message("<span class='danger'>[user] tries to shave [H]'s head with \the [src]!</span>", \
				"<span class='warning'>You start shaving [H]'s head.</span>")
				if(do_after(user, 50))
					if(user_loc == user.loc && H_loc == H.loc)
						user.visible_message("<span class='danger'>[user] shaves [H]'s head bald with \the [src]!</span>", \
						"<span class='warning'>You shave [H]'s head bald.</span>")
						H.head_hair_style = "Skinhead"
						H.update_hair()
						playsound(src.loc, 'sound/items/Welder2.ogg', 40, 1)
		else
			..()
	else
		..()
