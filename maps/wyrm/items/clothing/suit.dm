/obj/item/clothing/suit/armor/vest/bomb_vest
	name = "bomb vest"
	desc = "An armored vest with a phoron tank rigged to it."
	icon_state = "bombvest"
	var/obj/item/weapon/tank/phoron/onetankbomb/bomb

/obj/item/clothing/suit/armor/vest/bomb_vest/loaded/New()
	..()
	bomb = new /obj/item/weapon/tank/phoron/onetankbomb

/obj/item/clothing/suit/armor/vest/bomb_vest/attackby(obj/item/weapon/W as obj, mob/user as mob)
	bomb.ignite()