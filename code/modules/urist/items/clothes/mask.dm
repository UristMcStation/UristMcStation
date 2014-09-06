//Totally not The Joker mask.

/obj/item/clothing/mask/jester
	icon = 'icons/urist/items/clothes/masks.dmi'
	icon_override = 'icons/uristmob/mask.dmi'
	desc = "The Jester's mask."
	item_state = "the_jester"
	icon_state = "the_jester"
	body_parts_covered = HEAD
	flags = FPRINT|TABLEPASS
	slot_flags = SLOT_MASK

/obj/item/clothing/mask/penguin
	icon = 'icons/urist/items/clothes/masks.dmi'
	icon_override = 'icons/uristmob/mask.dmi'
	desc = "The Penquin's mask."
	item_state = "penguincig"
	icon_state = "penguincig"
	body_parts_covered = HEAD
	flags = FPRINT|TABLEPASS
	slot_flags = SLOT_MASK


//It's Payday, guys.

/obj/item/clothing/mask/payday
    name = "clown mask"
    icon = 'icons/urist/items/clothes/masks.dmi'
    icon_override = 'icons/uristmob/mask.dmi'
    flags = FPRINT | TABLEPASS | MASKCOVERSMOUTH | MASKCOVERSEYES | BLOCK_GAS_SMOKE_EFFECT | MASKINTERNALS
    flags_inv = HIDEEARS|HIDEEYES|HIDEFACE
    w_class = 3.0
    gas_transfer_coefficient = 0.01
    permeability_coefficient = 0.01
    siemens_coefficient = 0.9
    armor = list(melee = 30, bullet = 40, laser = 10, energy = 5, bomb = 20, bio = 10, rad = 5)

/obj/item/clothing/mask/payday/clown/dallas
	desc = "A ballistic mask modified to look like that of a clown's, painted to look like some old Terran nation's flag. It is airtight and has a valve slot for oxygen tanks."
	icon_state = "pddallas"
	item_state = "pddallas"

/obj/item/clothing/mask/payday/clown/hoxton
	desc = "A ballistic mask modified to look like that of a clown's, painted to look like a thin-lipped clown. It is airtight and has a valve slot for oxygen tanks."
	icon_state = "pdhoxton"
	item_state = "pdhoxton"

/obj/item/clothing/mask/payday/clown/wolf
	desc = "A ballistic mask modified to look like that of a clown's, painted to look like a half-skinned husk. It is airtight and has a valve slot for oxygen tanks."
	icon_state = "pdwolf"
	item_state = "pdwolf"

/obj/item/clothing/mask/payday/clown/chains
	desc = "A ballistic mask modified to look like that of a clown's, painted to look like a thick-lipped mash of a clown and mime. It is airtight and has a valve slot for oxygen tanks."
	icon_state = "pdchains"
	item_state = "pdchains"