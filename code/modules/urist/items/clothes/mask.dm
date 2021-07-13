//Totally not The Joker mask.

/obj/item/clothing/mask/jester
	icon = 'icons/urist/items/clothes/masks.dmi'
	icon_override = 'icons/uristmob/mask.dmi'
	desc = "The Jester's mask."
	item_state = "the_jester"
	icon_state = "the_jester"
	body_parts_covered = HEAD
	slot_flags = SLOT_MASK

/obj/item/clothing/mask/penguin
	icon = 'icons/urist/items/clothes/masks.dmi'
	icon_override = 'icons/uristmob/mask.dmi'
	desc = "The Penquin's mask."
	item_state = "penguincig"
	icon_state = "penguincig"
	body_parts_covered = HEAD
	slot_flags = SLOT_MASK

//Paper flower, fits in the mouth, like tango

/obj/item/clothing/mask/flower
	name = "paper flower"
	icon = 'icons/urist/items/papercrafts.dmi'
	icon_override = 'icons/uristmob/mask.dmi'
	desc = "A Paper flower."
	item_state = "paperflower"
	icon_state = "paperflower"
	slot_flags = SLOT_MASK

/obj/item/clothing/mask/flower/attackby(var/obj/item/I, mob/user as mob)
	if(istype(I, /obj/item/weapon/scissors))
		var/obj/item/clothing/head/urist/paperflower/F = new /obj/item/clothing/head/urist/paperflower
		user.remove_from_mob(src)
		user.put_in_hands(F)
		user << "<span class='notice'>You snip the stem off the flower.</span>"
		del src
	..()


//It's payday, guys.

/obj/item/clothing/mask/gas/payday
    name = "clown mask"
    icon = 'icons/urist/items/clothes/masks.dmi'
    icon_override = 'icons/uristmob/mask.dmi'
    item_flags = ITEM_FLAG_BLOCK_GAS_SMOKE_EFFECT
    flags_inv = HIDEEARS|HIDEEYES|HIDEFACE
    w_class = 3.0
    gas_transfer_coefficient = 0.01
    permeability_coefficient = 0.01
    siemens_coefficient = 0.9
    armor = list(melee = 30, bullet = 40, laser = 10, energy = 5, bomb = 20, bio = 10, rad = 5)

/obj/item/clothing/mask/gas/payday/dallas
	desc = "A ballistic mask modified to look like that of a clown's, painted to look like some old Terran nation's flag. It is airtight and has a valve slot for oxygen tanks."
	icon_state = "pddallas"
	item_state = "pddallas"

/obj/item/clothing/mask/gas/payday/hoxton
	desc = "A ballistic mask modified to look like that of a clown's, painted to look like a thin-lipped clown. It is airtight and has a valve slot for oxygen tanks."
	icon_state = "pdhoxton"
	item_state = "pdhoxton"

/obj/item/clothing/mask/gas/payday/wolf
	desc = "A ballistic mask modified to look like that of a clown's, painted to look like a half-skinned husk. It is airtight and has a valve slot for oxygen tanks."
	icon_state = "pdwolf"
	item_state = "pdwolf"

/obj/item/clothing/mask/gas/payday/chains
	desc = "A ballistic mask modified to look like that of a clown's, painted to look like a thick-lipped mash of a clown and mime. It is airtight and has a valve slot for oxygen tanks."
	icon_state = "pdchains"
	item_state = "pdchains"

//Luna's Men I'm using payday because it's easier

/obj/item/clothing/mask/gas/payday/luna
	desc = "A mask showing the support of Luna."
	icon_state = "lunamask"
	item_state = "lunamask"

/obj/item/clothing/mask/balaclava/skimask
	name = "ski mask"
	desc = "A balaclava with three separate holes instead of just one. This clearly makes it superior."
	icon = 'icons/urist/items/clothes/masks.dmi'
	icon_override = 'icons/uristmob/mask.dmi'
	icon_state = "skimask"
	item_state = "skimask"
	cold_protection = FACE
	min_cold_protection_temperature = 243.15

/obj/item/clothing/mask/urist/bandana/leather
	name = "leather mask"
	desc = "It's a simple leather mask. Hmmm, maybe if you get some glass you could turn this into some impromptu goggles."
	icon_state = "sandsuit"
	item_state = "sandsuit"
	min_cold_protection_temperature = 253.15
	cold_protection = FACE
	body_parts_covered = HEAD
	slot_flags = SLOT_MASK
	flags_inv = HIDEFACE

/obj/item/clothing/mask/urist/bandana/leather/attackby(var/obj/item/I, mob/user as mob)
	if(istype(I, /obj/item/stack/material/glass))
		var/obj/item/stack/material/glass/G = I
		G.use(1)
		var/obj/item/clothing/glasses/lgoggles/S = new /obj/item/clothing/glasses/lgoggles(src.loc)
		user.put_in_hands(S)
		to_chat(user, "<span class='notice'>You wrap the strip of leather around some pieces of glass, forming an improvised pair of goggles.</span>")

	..()

/obj/item/clothing/mask/gas/terranhalf
	item_icons = URIST_ALL_ONMOBS
	name = "face mask"
	desc = "A compact, durable gas mask that can be connected to an air supply."
	icon_override = 'icons/uristmob/mask.dmi'
	icon_state = "halfgas"
	item_state = "halfgas"
	siemens_coefficient = 0.7
	body_parts_covered = FACE
	w_class = ITEM_SIZE_SMALL
	armor = list(melee = 15, bullet = 10, laser = 10, energy = 0, bomb = 0, bio = 60, rad = 0)


/obj/item/clothing/mask/gas/biohazardrespirator
	name = "biohazard respirator"
	desc = "A fully enclosed respirator that can be connected to an air supply to filter out toxins. Filters harmful gases from the air while protecting the users face."
	icon = 'icons/urist/items/clothes/masks.dmi'
	icon_override = 'icons/uristmob/mask.dmi'
	icon_state = "biomask"
	item_state = "biomask"
	flags_inv = HIDEEARS
	body_parts_covered = FACE|EYES
	armor = list(melee = 5, bullet = 5, laser = 0, energy = 0, bomb = 0, bio = 75, rad = 0)
