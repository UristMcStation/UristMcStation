//moving these here from the casino away because they're needed for hostile mobs

//========================used bullet casings=======================
/obj/item/ammo_casing/rifle/used/Initialize()
	. = ..()
	expend()
	pixel_x = rand(-10, 10)
	pixel_y = rand(-10, 10)


/obj/item/ammo_casing/pistol/used/Initialize()
	. = ..()
	expend()
	pixel_x = rand(-10, 10)
	pixel_y = rand(-10, 10)

/obj/item/ammo_casing/a50/used/Initialize()
	. = ..()
	expend()
	pixel_x = rand(-10, 10)
	pixel_y = rand(-10, 10)

/obj/item/ammo_casing/rifle/military/used/Initialize()
	. = ..()
	expend()
	pixel_x = rand(-10, 10)
	pixel_y = rand(-10, 10)

/obj/item/ammo_casing/pistol/small/used/Initialize()
	. = ..()
	expend()
	pixel_x = rand(-10, 10)
	pixel_y = rand(-10, 10)
