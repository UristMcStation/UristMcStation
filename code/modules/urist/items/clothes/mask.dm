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

//Paper flower, fits in the mouth, like tango

/obj/item/clothing/mask/flower
	name = "paper flower"
	icon = 'icons/urist/items/papercrafts.dmi'
	icon_override = 'icons/uristmob/mask.dmi'
	desc = "A Paper flower."
	item_state = "paperflower"
	icon_state = "paperflower"
	flags = FPRINT|TABLEPASS
	slot_flags = SLOT_MASK

/obj/item/clothing/mask/flower/attackby(var/obj/item/I, mob/user as mob)
	if(istype(I, /obj/item/weapon/scissors))
		var/obj/item/clothing/head/urist/paperflower/F = new /obj/item/clothing/head/urist/paperflower
		user.before_take_item(src)
		user.put_in_hands(F)
		user << "<span class='notice'>You snip the stem off the flower.</span>"
		del src
	..()