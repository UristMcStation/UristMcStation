/obj/item/clothing/under/skirt
	name = "black skirt"
	desc = "A black skirt, very fancy!"
	icon_state = "blackskirt"
	item_state = "bl_suit"
	worn_state = "blackskirt"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	rolled_sleeves = -1

// discreet skirts, dont cover upper/arms etc
/obj/item/clothing/under/skirt/khaki
	name = "khaki skirt"
	desc = "A khaki skirt with a flare at the hem."
	icon_state = "skirt_khaki"
	worn_state = "skirt_khaki"
	body_parts_covered = LOWER_TORSO

/obj/item/clothing/under/skirt/swept
	name = "swept skirt"
	desc = "A skirt that is swept to one side."
	icon_state = "skirt_swept"
	worn_state = "skirt_swept"
	body_parts_covered = LOWER_TORSO

/obj/item/clothing/under/skirt/plaid_blue
	name = "blue plaid skirt"
	desc = "A preppy blue skirt with a white blouse."
	icon_state = "plaid_blue"
	worn_state = "plaid_blue"

/obj/item/clothing/under/skirt/plaid_red
	name = "red plaid skirt"
	desc = "A preppy red skirt with a white blouse."
	icon_state = "plaid_red"
	item_state = "kilt"
	worn_state = "plaid_red"

/obj/item/clothing/under/skirt/plaid_purple
	name = "blue purple skirt"
	desc = "A preppy purple skirt with a white blouse."
	icon_state = "plaid_purple"
	item_state = "kilt"
	worn_state = "plaid_purple"

// colour selection, needs to be different for loadout type selection

/obj/item/clothing/under/skirt_c
	name = "short skirt"
	desc = "A short skirt, made of some semi-gloss material."
	icon_state = "skirt_short"
	worn_state = "skirt_short"
	body_parts_covered = LOWER_TORSO

/obj/item/clothing/under/skirt_c/dress
	name = "short dress"
	desc = "A short plain sleeveless dress."
	icon_state = "shortdress"
	worn_state = "shortdress"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/under/skirt_c/dress/black
	name = "black short dress"
	color = "#181818"

/obj/item/clothing/under/skirt_c/dress/eggshell
	name = "eggshell short dress"
	color = "#f0ead6"

/obj/item/clothing/under/skirt_c/dress/mintcream
	name = "mint short dress"
	color = "#dcffed"

/obj/item/clothing/under/skirt_c/dress_long
	name = "maxi dress"
	desc = "A sleeveless dress that reaches the wearer's ankles."
	icon_state = "longdress"
	worn_state = "longdress"
	flags_inv = HIDESHOES
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET

/obj/item/clothing/under/skirt_c/dress_long/gown
	name = "silk gown"
	desc = "A long silky sleeveless gown with a flared hem."
	icon_state = "gowndress"
	worn_state = "gowndress"

/obj/item/clothing/under/skirt_c/dress_long/black
	name = "black maxi dress"
	color = "#181818"

/obj/item/clothing/under/skirt_c/dress_long/eggshell
	name = "eggshell maxi dress"
	color = "#f0ead6"

/obj/item/clothing/under/skirt_c/dress_long/mintcream
	name = "mint maxi dress"
	color = "#dcffed"

/obj/item/clothing/under/skirt_c/dress_elegant
		name = "elegant dress"
		desc = "A maxi length dress with side slits in the skirt and a fashionable view of the shoulders."
		icon_state = "dress_e"
		worn_state = "dress_e"
		body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS

/obj/item/clothing/under/skirt_c/dress_stripes
		name = "striped dress"
		desc = "A maxi length dress with side slits in the skirt, with stripes on the top."
		icon_state = "dress_stripes"
		worn_state = "dress_stripes"
		body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS

/obj/item/clothing/under/skirt_c/dress_flowers
		name = "flowery turtledress"
		desc = "A maxi length dress with side slits in the skirt, and a turtleneck top. It's covered in flowers."
		icon_state = "dress_flowers"
		worn_state = "dress_flowers"
		body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS

/obj/item/clothing/under/rank/security/skirt
	name = "security officer's jumpskirt"
	desc = "Standard feminine fashion for Security Officers.  It's made of sturdier material than the standard jumpskirts."
	icon_state = "secredf"
	item_state = "r_suit"
	worn_state = "secredf"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9

/obj/item/clothing/under/rank/security/warden/skirt
	desc = "Standard feminine fashion for a Warden. It is made of sturdier material than standard jumpskirts. It has the word \"Warden\" written on the shoulders."
	name = "warden's jumpskirt"
	icon_state = "wardenf"
	item_state = "r_suit"
	worn_state = "wardenf"

/obj/item/clothing/under/rank/security/head_of_security/skirt
	desc = "It's a fashionable jumpskirt worn by those few with the dedication to achieve the position of \"Head of Security\". It has additional armor to protect the wearer."
	name = "head of security's jumpskirt"
	icon_state = "hosredf"
	item_state = "r_suit"
	worn_state = "hosredf"