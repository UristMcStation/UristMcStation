
/mob/living/simple_animal/passive/npc/New()
	..()
	if(prob(50))
		gender = FEMALE
	else
		gender = MALE

	my_species = new species_type()
	create_base_icon()

	var/datum/species/S = all_species[my_species.name]
	var/singleton/cultural_info/culture/C = SSculture.get_culture(S.default_cultural_info[TAG_CULTURE])
	if(istype(C))
		real_name = C.get_random_name(gender)

	else
		real_name = random_name(gender) //fallback

	species_language = all_languages[C.default_language]

	if(npc_job_title)
		name = "[real_name] ([npc_job_title])"

	else
		name = "[real_name] (NPC)"

	var/image/res = image('icons/mob/human_races/species/human/hair.dmi',"bald_s")
	var/image/res2 = image('icons/mob/human_races/species/human/facial.dmi',"bald_s")

	h_style(res)
	f_style(res2)

	overlays += res
	overlays += res2

	equip_gear()

	//update_interact_icon()

//	trade_controller_debug = trade_controller

//this proc does not check the simple animal type! only use it on human type mobs
/mob/living/simple_animal/passive/npc/proc/create_base_icon()
	icon = 'npc.dmi'
	if(src.gender == FEMALE)
		icon_state = "[my_species.name]_f"
	else
		icon_state = "[my_species.name]_m"

	icon_dead = icon_state

/mob/living/simple_animal/passive/npc/proc/equip_gear()
	if(length(jumpsuits))
		var/newtype = pick(jumpsuits)
		var/new_item = new newtype(src)
		sprite_equip(new_item,slot_w_uniform_str)

	if(length(shoes))
		var/newtype = pick(shoes)
		var/new_item = new newtype(src)
		sprite_equip(new_item,slot_shoes_str)

	if(length(gloves) && prob(glove_chance))
		var/newtype = pick(gloves)
		var/new_item = new newtype(src)
		sprite_equip(new_item,slot_gloves_str)

	if(length(suits) && prob(suit_chance))
		var/newtype = pick(suits)
		var/new_item = new newtype(src)
		sprite_equip(new_item,slot_wear_suit_str)

	if(length(masks) && prob(mask_chance))
		var/newtype = pick(masks)
		var/new_item = new newtype(src)
		sprite_equip(new_item,slot_wear_mask_str)

	if(length(glasses) && prob(glasses_chance))
		var/newtype = pick(glasses)
		var/new_item = new newtype(src)
		sprite_equip(new_item,slot_glasses_str)

	if(length(hats) && prob(hat_chance))
		var/newtype = pick(hats)
		var/new_item = new newtype(src)
		sprite_equip(new_item,slot_head_str)

//repository/images/proc/overlay_image(var/icon, var/icon_state, var/alpha, var/appearance_flags, var/color, var/dir, var/plane = FLOAT_PLANE, var/layer = FLOAT_LAYER)
/mob/living/simple_animal/passive/npc/var/list/overlay_images = list()
/mob/living/simple_animal/passive/npc/proc/sprite_equip(obj/item/I, var/slot)
	overlays += I.get_mob_overlay(src, slot)
	overlay_images += I.get_mob_overlay(src, slot)

/mob/living/simple_animal/passive/npc/proc/h_style(image/res)
	//appearance_flags = SPECIES_APPEARANCE_HAS_HAIR_COLOR | HAS_SKIN_TONE | HAS_LIPS | HAS_UNDERWEAR | SPECIES_APPEARANCE_HAS_EYE_COLOR
	var/h_style
	if(length(hats) && prob(hat_chance))
		var/newtype = pick(hats)
		var/new_item = new newtype(src)
		sprite_equip(new_item,slot_head_str)
	else
		//give them some head hair
		h_style = random_hair_style(gender, my_species.name)
		var/datum/sprite_accessory/hair/hair_style = GLOB.hair_styles_list[h_style]
		/*if(owner.head && (owner.head.flags_inv & BLOCKHEADHAIR))
			if(!hair_style.veryshort)
				hair_style = hair_styles_list["Short Hair"]*/
		var/icon/hair_s = new/icon("icon" = hair_style.icon, "icon_state" = "[hair_style.icon_state]_s")
		/*if(hair_style.do_colouration && islist(h_col) && length(h_col) >= 3)
			hair_s.Blend(rgb(h_col[1], h_col[2], h_col[3]), ICON_ADD)*/
		res.overlays |= hair_s

/mob/living/simple_animal/passive/npc/proc/f_style(image/res2)
	//give them some facial hair
	var/f_style = random_facial_hair_style(gender, my_species.name)
	var/datum/sprite_accessory/facial_hair_style = GLOB.facial_hair_styles_list[f_style]
	if(facial_hair_style)
		var/icon/facial_s = new/icon("icon" = facial_hair_style.icon, "icon_state" = "[facial_hair_style.icon_state]_s")
		/*if(facial_hair_style.do_colouration)
			facial_s.Blend(rgb(owner.r_facial, owner.g_facial, owner.b_facial), ICON_ADD)*/
		res2.overlays |= facial_s

/mob/living/simple_animal/passive/npc/proc/update_interact_icon()
	src.dir = SOUTH
	interact_icon = getFlatIcon(src)

/mob/living/simple_animal/passive/npc/Initialize()
	. = ..()
	generate_trade_items()
