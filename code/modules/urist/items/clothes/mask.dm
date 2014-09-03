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

//

/obj/item/clothing/mask/payday/dallas
	name = "clown mask"
	desc = "A ballistic mask modified to look like that of a clown's, painted to look like some old Terran nation's flag. It is airtight and has a valve slot for oxygen tanks."
	icon = 'icons/urist/items/clothes/masks.dmi'
	icon_override = 'icons/uristmob/mask.dmi'
	icon_state = "pddallas"
	item_state = "pddallas"
	flags = FPRINT | TABLEPASS | MASKCOVERSMOUTH | MASKCOVERSEYES | BLOCK_GAS_SMOKE_EFFECT | MASKINTERNALS
	flags_inv = HIDEEARS|HIDEEYES|HIDEFACE
	w_class = 3.0
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	siemens_coefficient = 0.9
	var/gas_filter_strength = 1			//For gas mask filters
	armor = list(melee = 30, bullet = 40, laser = 10, energy = 5, bomb = 20, bio = 10, rad = 5)

/obj/item/clothing/mask/payday/hoxton
	name = "clown mask"
	desc = "A ballistic mask modified to look like that of a clown's, painted to look like a thin-lipped clown. It is airtight and has a valve slot for oxygen tanks."
	icon = 'icons/urist/items/clothes/masks.dmi'
	icon_override = 'icons/uristmob/mask.dmi'
	icon_state = "pdhoxton"
	item_state = "pdhoxton"
	flags = FPRINT | TABLEPASS | MASKCOVERSMOUTH | MASKCOVERSEYES | BLOCK_GAS_SMOKE_EFFECT | MASKINTERNALS
	flags_inv = HIDEEARS|HIDEEYES|HIDEFACE
	w_class = 3.0
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	siemens_coefficient = 0.9
	var/gas_filter_strength = 1			//For gas mask filters
	armor = list(melee = 30, bullet = 40, laser = 10, energy = 5, bomb = 20, bio = 10, rad = 5)

/obj/item/clothing/mask/payday/wolf
	name = "clown mask"
	desc = "A ballistic mask modified to look like that of a clown's, painted to look like a half-skinned husk. It is airtight and has a valve slot for oxygen tanks."
	icon = 'icons/urist/items/clothes/masks.dmi'
	icon_override = 'icons/uristmob/mask.dmi'
	icon_state = "pdwolf"
	item_state = "pdwolf"
	flags = FPRINT | TABLEPASS | MASKCOVERSMOUTH | MASKCOVERSEYES | BLOCK_GAS_SMOKE_EFFECT | MASKINTERNALS
	flags_inv = HIDEEARS|HIDEEYES|HIDEFACE
	w_class = 3.0
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	siemens_coefficient = 0.9
	var/gas_filter_strength = 1			//For gas mask filters
	armor = list(melee = 30, bullet = 40, laser = 10, energy = 5, bomb = 20, bio = 10, rad = 5)

/obj/item/clothing/mask/payday/chains
	name = "clown mask"
	desc = "A ballistic mask modified to look like that of a clown's, painted to look like a thick-lipped mash of a clown and mime. It is airtight and has a valve slot for oxygen tanks."
	icon = 'icons/urist/items/clothes/masks.dmi'
	icon_override = 'icons/uristmob/mask.dmi'
	icon_state = "pdchains"
	item_state = "pdchains"
	flags = FPRINT | TABLEPASS | MASKCOVERSMOUTH | MASKCOVERSEYES | BLOCK_GAS_SMOKE_EFFECT | MASKINTERNALS
	flags_inv = HIDEEARS|HIDEEYES|HIDEFACE
	w_class = 3.0
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	siemens_coefficient = 0.9
	var/gas_filter_strength = 1			//For gas mask filters
	armor = list(melee = 30, bullet = 40, laser = 10, energy = 5, bomb = 20, bio = 10, rad = 5)