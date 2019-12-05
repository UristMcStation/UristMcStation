//Biosuit complete with shoes (in the item sprite)
/obj/item/clothing/head/bio_hood
	name = "bio hood"
	icon_state = "bio"
	item_state_slots = list(
		slot_l_hand_str = "bio_hood",
		slot_r_hand_str = "bio_hood",
		)
	desc = "A hood that protects the head and face from biological comtaminants."
	permeability_coefficient = 0
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 100, rad = 20)
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|BLOCKHAIR
	item_flags = ITEM_FLAG_THICKMATERIAL
	body_parts_covered = HEAD|FACE|EYES
	siemens_coefficient = 0.9

/obj/item/clothing/suit/bio_suit
	name = "bio suit"
	desc = "A suit that protects against biological contamination."
	icon_state = "bio"
	item_state_slots = list(
		slot_l_hand_str = "bio_suit",
		slot_r_hand_str = "bio_suit",
	)
	w_class = ITEM_SIZE_HUGE//bulky item
	gas_transfer_coefficient = 0
	permeability_coefficient = 0
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	allowed = list(/obj/item/weapon/tank/emergency,/obj/item/weapon/pen,/obj/item/device/flashlight/pen,/obj/item/device/healthanalyzer,/obj/item/device/ano_scanner,/obj/item/clothing/head/bio_hood,/obj/item/clothing/mask/gas)
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 100, rad = 20)
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL
	item_flags = ITEM_FLAG_THICKMATERIAL
	siemens_coefficient = 0.9

/obj/item/clothing/suit/bio_suit/New()
	..()
	slowdown_per_slot[slot_wear_suit] = 1.0

//Standard biosuit, orange stripe
/obj/item/clothing/head/bio_hood/general
	icon_state = "bio_general"
	body_parts_covered = HEAD|FACE|EYES

/obj/item/clothing/suit/bio_suit/general
	icon_state = "bio_general"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS|HANDS|FEET
	flags_inv = HIDEJUMPSUIT|HIDETAIL|HIDEGLOVES|HIDESHOES

//Virology biosuit, green stripe
/obj/item/clothing/head/bio_hood/virology
	icon_state = "bio_virology"

/obj/item/clothing/suit/bio_suit/virology
	icon_state = "bio_virology"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS|HANDS|FEET
	flags_inv = HIDEJUMPSUIT|HIDETAIL|HIDEGLOVES|HIDESHOES

//Security biosuit, grey with red stripe across the chest
/obj/item/clothing/head/bio_hood/security
	icon_state = "bio_security"

/obj/item/clothing/suit/bio_suit/security
	icon_state = "bio_security"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS|HANDS|FEET
	flags_inv = HIDEJUMPSUIT|HIDETAIL|HIDEGLOVES|HIDESHOES

//Janitor's biosuit, grey with purple arms
/obj/item/clothing/head/bio_hood/janitor
	icon_state = "bio_janitor"

/obj/item/clothing/suit/bio_suit/janitor
	icon_state = "bio_janitor"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS|HANDS|FEET
	flags_inv = HIDEJUMPSUIT|HIDETAIL|HIDEGLOVES|HIDESHOES


//Scientist's biosuit, white with a pink-ish hue
/obj/item/clothing/head/bio_hood/scientist
	icon_state = "bio_scientist"

/obj/item/clothing/suit/bio_suit/scientist
	icon_state = "bio_scientist"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS|HANDS|FEET
	flags_inv = HIDEJUMPSUIT|HIDETAIL|HIDEGLOVES|HIDESHOES

//CMO's biosuit, blue stripe
/obj/item/clothing/suit/bio_suit/cmo
	icon_state = "bio_cmo"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS|HANDS|FEET
	flags_inv = HIDEJUMPSUIT|HIDETAIL|HIDEGLOVES|HIDESHOES

/obj/item/clothing/head/bio_hood/cmo
	icon_state = "bio_cmo"


//Plague Dr mask can be found in clothing/masks/gasmask.dm
/obj/item/clothing/suit/bio_suit/plaguedoctorsuit
	name = "Plague doctor suit"
	desc = "It protected doctors from the Black Death, back then. You bet your arse it's gonna help you against viruses."
	icon_state = "plaguedoctor"
	//item_state = "bio_suit"
	flags_inv = HIDEGLOVES|HIDEJUMPSUIT|HIDETAIL


// Big Bulky CEDA Suits. Hiss not included - Blue
/obj/item/clothing/head/biohazardhood
	name = "biohazard hood"
	icon = 'icons/urist/items/clothes/head.dmi'
	icon_override = 'icons/uristmob/head.dmi'
	body_parts_covered = FACE|EYES
	w_class = 3.0
	flags_inv = HIDEEARS
	item_flags = ITEM_FLAG_BLOCK_GAS_SMOKE_EFFECT
	armor = list(melee = 5, bullet = 5, laser = 0, energy = 0, bomb = 0, bio = 75, rad = 0)

/obj/item/clothing/suit/biohazardsuit
	name = "biohazard suit"
	icon = 'icons/urist/items/clothes/clothes.dmi'
	icon_override = 'icons/uristmob/clothes.dmi'
	body_parts_covered = FACE|EYES
	w_class = 3.0
	flags_inv = HIDEEARS
	item_flags = ITEM_FLAG_BLOCK_GAS_SMOKE_EFFECT
	armor = list(melee = 5, bullet = 5, laser = 0, energy = 0, bomb = 0, bio = 75, rad = 0)

// Big Bulky CEDA Suits. Hiss not included - Grey
/obj/item/clothing/head/biohazardhood/bulkybiogreyhood
	name = "grey bio hood"
	icon_state = "bulky_grey_hood"
	desc = "A bulky grey hood that protects the user from biohazardous materials."
	flags_inv = BLOCKHAIR
	body_parts_covered = HEAD|FACE|EYES
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 100, rad = 20)

/obj/item/clothing/suit/biohazardsuit/bulkybiogrey
	name = "grey bio suit"
	desc = "A bulky grey suit that protects against biological contamination."
	icon_state = "bulky_grey"
	item_state_slots = list(
		slot_l_hand_str = "bio_suit",
		slot_r_hand_str = "bio_suit",
	)
	w_class = ITEM_SIZE_HUGE//bulky item
	gas_transfer_coefficient = 0
	permeability_coefficient = 0
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	allowed = list(/obj/item/weapon/tank/emergency,/obj/item/weapon/pen,/obj/item/device/flashlight/pen,/obj/item/device/healthanalyzer,/obj/item/device/ano_scanner,/obj/item/clothing/head/bio_hood,/obj/item/clothing/mask/gas)
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 100, rad = 20)
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL
	item_flags = ITEM_FLAG_THICKMATERIAL
	siemens_coefficient = 0.9

/obj/item/clothing/head/biohazardhood/bulkybiobluehood
	name = "blue bio hood"
	icon_state = "bulky_blue_hood"
	desc = "A bulky grey hood that protects the user from biohazardous materials."
	flags_inv = BLOCKHAIR
	body_parts_covered = HEAD|FACE|EYES
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 100, rad = 20)

/obj/item/clothing/suit/biohazardsuit/bulkybioblue
	name = "blue bio suit"
	desc = "A bulky blue suit that protects against biological contamination."
	icon_state = "bulky_blue"
	item_state_slots = list(
		slot_l_hand_str = "bio_suit",
		slot_r_hand_str = "bio_suit",
	)
	w_class = ITEM_SIZE_HUGE//bulky item
	gas_transfer_coefficient = 0
	permeability_coefficient = 0
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	allowed = list(/obj/item/weapon/tank/emergency,/obj/item/weapon/pen,/obj/item/device/flashlight/pen,/obj/item/device/healthanalyzer,/obj/item/device/ano_scanner,/obj/item/clothing/head/bio_hood,/obj/item/clothing/mask/gas)
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 100, rad = 20)
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL
	item_flags = ITEM_FLAG_THICKMATERIAL
	siemens_coefficient = 0.9
