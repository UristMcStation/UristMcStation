/obj/item/clothing/suit/armor/vest/bomb_vest
	name = "bomb vest"
	desc = "An armored vest with a phoron tank rigged to it."
	icon_state = "bombvest"
	var/obj/item/tank/phoron/onetankbomb/bomb

/obj/item/clothing/suit/armor/vest/bomb_vest/loaded/New()
	..()
	bomb = new /obj/item/tank/phoron/onetankbomb

/obj/item/clothing/suit/armor/vest/bomb_vest/attackby(obj/item/W as obj, mob/user as mob)
	bomb.ignite()

/obj/item/clothing/under/guard/wyrm
	name = "blue security guard uniform"
	desc = "A durable uniform worn by the Wyrm's security officer."
	icon = 'maps/wyrm/icons/guard.dmi'
	icon_state = "blueguard"
	item_state = "blueguard"
	item_icons = list(slot_w_uniform_str = 'maps/wyrm/icons/guard.dmi')
