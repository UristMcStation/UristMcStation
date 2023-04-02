/obj/item/ammo_magazine/pistol/rubber
	name = "magazine (10mm, rubber)"
	ammo_type = /obj/item/ammo_casing/pistol/rubber

/obj/item/ammo_magazine/pistol/flash
	name = "magazine (10mm, flash)"
	ammo_type = /obj/item/ammo_casing/pistol/flash

/obj/item/ammo_magazine/rifle/military/rubber
	name = "magazine (7.62mm, rubber)"
	ammo_type = /obj/item/ammo_casing/rifle/military/rubber

/obj/item/ammo_magazine/rifle/military/flash
	name = "magazine (7.62mm, flash)"
	ammo_type = /obj/item/ammo_casing/rifle/military/flash

/obj/item/ammo_magazine/rifle/rubber
	name = "magazine (5.56mm, rubber)"
	ammo_type = /obj/item/projectile/bullet/rifle/rubber

/obj/item/ammo_magazine/rifle/flash
	name = "magazine (5.56mm, flash)"
	ammo_type = /obj/item/ammo_casing/rifle/flash

/obj/item/ammo_casing/pistol/rubber
	desc = "A 10mm rubber bullet casing."
	projectile_type = /obj/item/projectile/bullet/pistol/rubber

/obj/item/ammo_casing/pistol/flash
	desc = "A 10mm flash shell casing."
	projectile_type = /obj/item/projectile/energy/flash

/obj/item/ammo_casing/rifle/flash
	desc = "A 5.56mm flash shell casing."
	projectile_type = /obj/item/projectile/energy/flash

/obj/item/ammo_casing/rifle/rubber
	desc = "A 5.56mm rubber bullet casing."
	projectile_type = /obj/item/projectile/bullet/rifle/rubber

/obj/item/ammo_casing/rifle/military/flash
	desc = "A 7.62mm flash shell casing."
	projectile_type = /obj/item/projectile/energy/flash

/obj/item/ammo_casing/rifle/military/rubber
	desc = "A 7.62mm rubber bullet casing."
	projectile_type = /obj/item/projectile/bullet/rifle/military/rubber

/obj/item/ammo_magazine/pistol/rubber
	ammo_type = /obj/item/ammo_casing/pistol/small/rubber

/obj/item/ammo_magazine/hi2521smg9mm/rubber
	name = "HI-2521-SMG magazine (9mm, rubber)"
	ammo_type = /obj/item/ammo_casing/pistol/small/rubber

/obj/item/ammo_magazine/a50
	name = "magazine (.50)"
	icon = 'icons/urist/items/ammo.dmi'
	icon_state = "50ae"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	caliber = CALIBER_PISTOL_MAGNUM
	matter = list(MATERIAL_STEEL = 1680)
	ammo_type = /obj/item/ammo_casing/a50
	max_ammo = 7
	multiple_sprites = 1

/obj/item/ammo_magazine/a50/empty
	initial_ammo = 0

/obj/item/ammo_magazine/a75
	name = "ammo magazine (20mm)"
	icon = 'icons/urist/items/ammo.dmi'
	icon_state = "20mm"
	mag_type = MAGAZINE
	caliber = "75"
	ammo_type = /obj/item/ammo_casing/a75
	multiple_sprites = 1
	max_ammo = 4

/obj/item/ammo_magazine/bundle/shotbundle
	name = "fistful of shotgun shells"
	desc = "A fistful of shotgun shells."
	icon = 'icons/urist/items/shotbundle.dmi'
	icon_state = "slshell-1"
	caliber = "shotgun"
	ammo_type = /obj/item/ammo_casing/shotgun

/obj/item/ammo_magazine/bundle
	initial_ammo = 0
	max_ammo = 4
	w_class = ITEM_SIZE_NORMAL
	matter = list(MATERIAL_STEEL = 0)
	multiple_sprites = 1

/obj/item/ammo_magazine/bundle/attack_hand(mob/user)
	. = ..()
	check_ammo_count(user)

/obj/item/ammo_magazine/bundle/proc/check_ammo_count(mob/user)
	if(stored_ammo.len <= 1)
		user.drop_from_inventory(src, null)
		if(stored_ammo.len)
			user.put_in_hands(stored_ammo[1])
			stored_ammo.Cut()
		qdel(src)

/obj/item/ammo_magazine/bundle/attack_self(mob/user)
	..()
	qdel(src)

/obj/item/ammo_magazine/bundle/on_update_icon()
	overlays.Cut()
	var/count = 1
	for(var/obj/item/ammo_casing/C in stored_ammo)
		overlays += image(src.icon, "[C.icon_state]-[count]")
		count++

/obj/item/ammo_magazine/shotholder
	name = "shotgun slug holder"
	desc = "A convenient pouch that holds 12 gauge shells."
	icon_state = "shotholder"
	caliber = "shotgun"
	ammo_type = /obj/item/ammo_casing/shotgun
	matter = list(MATERIAL_STEEL = 1440)
	max_ammo = 4
	multiple_sprites = 1
	var/marking_color

/obj/item/ammo_magazine/shotholder/on_update_icon()
	..()
	overlays.Cut()
	if(marking_color)
		var/image/I = image(icon, "shotholder-marking")
		I.color = marking_color
		overlays += I

/obj/item/ammo_magazine/shotholder/shell
	name = "shotgun shell holder"
	ammo_type = /obj/item/ammo_casing/shotgun/pellet
	marking_color = COLOR_RED_GRAY

/obj/item/ammo_magazine/shotholder/beanbag
	name = "beanbag shell holder"
	ammo_type = /obj/item/ammo_casing/shotgun/beanbag
	matter = list(MATERIAL_STEEL = 720)
	marking_color = COLOR_PAKISTAN_GREEN

/obj/item/ammo_magazine/shotholder/flash
	name = "illumination shell holder"
	ammo_type = /obj/item/ammo_casing/shotgun/flash
	matter = list(MATERIAL_STEEL = 360, MATERIAL_GLASS = 360)
	marking_color = COLOR_PALE_YELLOW

/obj/item/ammo_magazine/shotholder/stun
	name = "stun shell holder"
	ammo_type = /obj/item/ammo_casing/shotgun/stunshell
	matter = list(MATERIAL_STEEL = 1440, MATERIAL_GLASS = 2880)
	marking_color = COLOR_MUZZLE_FLASH

/obj/item/ammo_magazine/shotholder/empty
	name = "shotgun ammunition holder"
	matter = list(MATERIAL_STEEL = 250)
	initial_ammo = 0

/obj/item/ammo_casing/a75
	desc = "A 20mm bullet casing."
	caliber = "75"
	projectile_type = /obj/item/projectile/bullet/gyro
	icon = 'icons/urist/items/ammo.dmi'
	icon_state = "lcasing"
	spent_icon = "lcasing-spent"
