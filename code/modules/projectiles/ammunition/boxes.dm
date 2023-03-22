/obj/item/ammo_magazine/a44
	name = "speed loader (.44 Magnum)"
	desc = "A speed loader for revolvers."
	icon = 'icons/urist/items/ammo.dmi'
	icon_state = "44"
	caliber = ".44"
	ammo_type = /obj/item/ammo_casing/a44
	matter = list(MATERIAL_STEEL = 1260)
	max_ammo = 6
	multiple_sprites = 1

/obj/item/ammo_magazine/c50
	name = "speed loader (.50)"
	desc = "A speed loader for revolvers."
	icon = 'icons/urist/items/ammo.dmi'
	icon_state = "50"
	caliber = ".50"
	ammo_type = /obj/item/ammo_casing/a50
	matter = list(MATERIAL_STEEL = 1440)
	max_ammo = 6
	multiple_sprites = 1

/obj/item/ammo_magazine/c357
	name = "speed loader (.357 Magnum)"
	desc = "A speed loader for revolvers."
	icon = 'icons/urist/items/ammo.dmi'
	icon_state = "38"
	ammo_type = /obj/item/ammo_casing/c357
	matter = list(MATERIAL_STEEL = 450)
	caliber = ".357"
	max_ammo = 6
	multiple_sprites = 1

/obj/item/ammo_magazine/c357/rubber
	name = "speed loader (.357 Magnum, rubber)"
	icon_state = "38_r"
	ammo_type = /obj/item/ammo_casing/c357/rubber

/obj/item/ammo_magazine/c38
	name = "speed loader (.38)"
	desc = "A speed loader for revolvers."
	icon = 'icons/urist/items/ammo.dmi'
	icon_state = "38"
	caliber = ".38"
	matter = list(MATERIAL_STEEL = 360)
	ammo_type = /obj/item/ammo_casing/c38
	max_ammo = 6
	multiple_sprites = 1

/obj/item/ammo_magazine/c38/rubber
	name = "speed loader (.38, rubber)"
	icon_state = "38_r"
	ammo_type = /obj/item/ammo_casing/c38/rubber

/obj/item/ammo_magazine/c44
	name = "speed loader (.44 Magnum)"
	desc = "A speed loader for revolvers."
	icon = 'icons/urist/items/ammo.dmi'
	icon_state = "44"
	ammo_type = /obj/item/ammo_casing/c44
	matter = list(DEFAULT_WALL_MATERIAL = 450)
	caliber = ".44"
	max_ammo = 6
	multiple_sprites = 1

/obj/item/ammo_magazine/c44/rubber
	name = "speed loader (.44 magnum, rubber)"
	icon_state = "44_r"
	ammo_type = /obj/item/ammo_casing/c44/rubber

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
	if(length(stored_ammo) <= 1)
		user.drop_from_inventory(src, null)
		if(length(stored_ammo))
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

/obj/item/ammo_magazine/bundle/shotbundle
	name = "fistful of shotgun shells"
	desc = "A fistful of shotgun shells."
	icon = 'icons/urist/items/shotbundle.dmi'
	icon_state = "slshell-1"
	caliber = "shotgun"
	ammo_type = /obj/item/ammo_casing/shotgun

/obj/item/ammo_magazine/c45m
	name = "magazine (.45)"
	icon = 'icons/urist/items/ammo.dmi'
	icon_state = "45"
/obj/item/ammo_magazine/speedloader/rubber
	labels = list("rubber")
	ammo_type = /obj/item/ammo_casing/pistol/rubber

/obj/item/ammo_magazine/speedloader/magnum
	icon_state = "spdloader_magnum"
	caliber = CALIBER_PISTOL_MAGNUM
	ammo_type = /obj/item/ammo_casing/pistol/magnum
	matter = list(MATERIAL_STEEL = 1440)
	max_ammo = 6
	multiple_sprites = 1

/obj/item/ammo_magazine/speedloader/small
	name = "speed loader"
	icon_state = "spdloader_small"
	caliber = CALIBER_PISTOL_SMALL
	ammo_type = /obj/item/ammo_casing/pistol/small
	matter = list(MATERIAL_STEEL = 1060)
	max_ammo = 6
	multiple_sprites = 1

/obj/item/ammo_magazine/speedloader/pclip
	name = "magnum pistol stripper clip"
	desc = "A stripper clip for pistol magnum caliber weapons."
	icon_state = "pclip"
	caliber = CALIBER_PISTOL_MAGNUM
	ammo_type = /obj/item/ammo_casing/pistol/magnum
	matter = list(MATERIAL_STEEL = 1300)
	max_ammo = 5
	multiple_sprites = 1

/obj/item/ammo_magazine/speedloader/hpclip
	name = "holdout pistol stripper clip"
	desc = "A stripper clip for pistol holdout caliber weapons."
	icon_state = "hpclip"
	caliber = CALIBER_PISTOL_SMALL
	ammo_type = /obj/item/ammo_casing/pistol/small
	matter = list(MATERIAL_STEEL = 1800)
	max_ammo = 10
	multiple_sprites = TRUE

/obj/item/ammo_magazine/speedloader/clip
	name = "rifle stripper clip"
	desc = "A stripper clip for rifle caliber weapons."
	icon_state = "clip"
	caliber = CALIBER_RIFLE
	ammo_type = /obj/item/ammo_casing/rifle
	matter = list(MATERIAL_STEEL = 1800)
	max_ammo = 5
	multiple_sprites = 1

/obj/item/ammo_magazine/shotholder
	name = "shotgun slug holder"
	desc = "A convenient pouch that holds 12 gauge shells."
	icon_state = "shotholder"
	caliber = CALIBER_SHOTGUN
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

/obj/item/ammo_magazine/shotholder/attack_hand(mob/user)
	if((user.a_intent == I_HURT) && (length(stored_ammo)))
		var/obj/item/ammo_casing/C = stored_ammo[length(stored_ammo)]
		stored_ammo-=C
		user.put_in_hands(C)
		user.visible_message("\The [user] removes \a [C] from [src].", SPAN_NOTICE("You remove \a [C] from [src]."))
		update_icon()
	else
		..()

/obj/item/ammo_magazine/shotholder/shell
	name = "shotgun shell holder"
	ammo_type = /obj/item/ammo_casing/shotgun/pellet
	marking_color = COLOR_RED_GRAY

/obj/item/ammo_magazine/shotholder/flechette
	name = "flechette shell holder"
	ammo_type = /obj/item/ammo_casing/shotgun/flechette
	marking_color = COLOR_BLUE

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

/obj/item/ammo_magazine/machine_pistol
	name = "stick magazine"
	icon_state = "machine_pistol"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/pistol
	matter = list(MATERIAL_STEEL = 1200)
	caliber = CALIBER_PISTOL
	max_ammo = 16
	multiple_sprites = 1

/obj/item/ammo_magazine/machine_pistol/empty
	initial_ammo = 0

/obj/item/ammo_magazine/pistol/rubber
	labels = list("rubber")
	ammo_type = /obj/item/ammo_casing/pistol/rubber

/obj/item/ammo_magazine/smg_top
	name = "top mounted magazine"
	icon_state = "smg_top"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/pistol/small
	matter = list(MATERIAL_STEEL = 1200)
	caliber = CALIBER_PISTOL_SMALL
	max_ammo = 20
	multiple_sprites = 1

/obj/item/ammo_magazine/smg_top/empty
	initial_ammo = 0

/obj/item/ammo_magazine/smg_top/rubber
	labels = list("rubber")
	ammo_type = /obj/item/ammo_casing/pistol/small/rubber

/obj/item/ammo_magazine/smg_top/practice
	labels = list("practice")
	ammo_type = /obj/item/ammo_casing/pistol/small/practice

/obj/item/ammo_magazine/c45m/rubber
	name = "magazine (.45, rubber)"
	ammo_type = /obj/item/ammo_casing/c45/rubber

/obj/item/ammo_magazine/c45m/practice
	name = "magazine (.45, practice)"
	ammo_type = /obj/item/ammo_casing/c45/practice

/obj/item/ammo_magazine/c45m/flash
	name = "magazine (.45, flash)"
	ammo_type = /obj/item/ammo_casing/c45/flash

/obj/item/ammo_magazine/c45mds
	name = "double-stack magazine (.45)"
	icon = 'icons/urist/items/ammo.dmi'
	icon_state = "45ds"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/pistol/small
	matter = list(MATERIAL_STEEL = 1200)
	caliber = CALIBER_PISTOL_SMALL
	max_ammo = 20
	multiple_sprites = 1

/obj/item/ammo_magazine/smg_top/empty
	initial_ammo = 0

/obj/item/ammo_magazine/c45mds/rubber
	name = "double-stack magazine (.45, rubber)"
	icon_state = "R45ds"
	ammo_type = /obj/item/ammo_casing/c45/rubber

/obj/item/ammo_magazine/c45mds/practice
	name = "double-stack magazine (.45, practice)"
	ammo_type = /obj/item/ammo_casing/c45/practice

/obj/item/ammo_magazine/c45mds/flash
	name = "double-stack magazine (.45, flash)"
	icon_state = "F45ds"
	ammo_type = /obj/item/ammo_casing/c45/flash

/obj/item/ammo_magazine/c45uzi
	name = "stick magazine (.45)"
	icon = 'icons/urist/items/ammo.dmi'
	icon_state = "uzi45"
	origin_tech = list(TECH_COMBAT = 2)

/obj/item/ammo_magazine/smg/empty
	initial_ammo = 0

/obj/item/ammo_magazine/mc9mm
	name = "magazine (9mm)"
	icon = 'icons/urist/items/ammo.dmi'
	icon_state = "9x19p"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	caliber = CALIBER_PISTOL
	matter = list(MATERIAL_STEEL = 750)
	ammo_type = /obj/item/ammo_casing/pistol
	max_ammo = 8
	multiple_sprites = 1

/obj/item/ammo_magazine/pistol/empty
	initial_ammo = 0

/obj/item/ammo_magazine/mc9mm/flash
	name = "magazine (9mm, flash)"
	icon_state = "F9x19"
	ammo_type = /obj/item/ammo_casing/c9mm/flash

/obj/item/ammo_magazine/mc9mmds
	name = "double-stack magazine (9mm)"
	icon = 'icons/urist/items/ammo.dmi'
	icon_state = "9mmds"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/c9mm
	matter = list(MATERIAL_STEEL = 900)
	caliber = "9mm"
	max_ammo = 15
	multiple_sprites = 1

/obj/item/ammo_magazine/mc9mmds/empty
	initial_ammo = 0

/obj/item/ammo_magazine/mc9mmds/rubber
	name = "double-stack magazine (9mm, rubber)"
	icon_state = "R9mmds"
	ammo_type = /obj/item/ammo_casing/c9mm/rubber

/obj/item/ammo_magazine/pistol/double/rubber
	labels = list("rubber")
	ammo_type = /obj/item/ammo_casing/pistol/rubber

/obj/item/ammo_magazine/mc9mmds/flash
	name = "double-stack magazine (9mm, flash)"
	icon_state = "F9mmds"
	ammo_type = /obj/item/ammo_casing/c9mm/flash
/obj/item/ammo_magazine/pistol/double/practice
	labels = list("practice")
	ammo_type = /obj/item/ammo_casing/pistol/practice

/obj/item/ammo_magazine/pistol/small
	icon_state = "holdout"
	matter = list(MATERIAL_STEEL = 480)
	caliber = CALIBER_PISTOL_SMALL
	ammo_type = /obj/item/ammo_casing/pistol/small
	max_ammo = 8

/obj/item/ammo_magazine/pistol/small/empty
	initial_ammo = 0

/obj/item/ammo_magazine/magnum
	name = "magazine"
	icon_state = "magnum"
	origin_tech = list(TECH_COMBAT = 2)
	max_ammo = 10
	caliber = CALIBER_PISTOL_MAGNUM
	matter = list(MATERIAL_STEEL = 1680)
	ammo_type = /obj/item/ammo_casing/pistol/magnum
	max_ammo = 7
	multiple_sprites = 1
/obj/item/ammo_magazine/box/emp/c45
	name = "ammunition box (.45, haywire)"
	ammo_type = /obj/item/ammo_casing/c45/emp
	caliber = ".45"

/obj/item/ammo_magazine/box/emp/a10mm
	name = "ammunition box (10mm, haywire)"
	ammo_type = /obj/item/ammo_casing/a10mm/emp
	caliber = "10mm"

/obj/item/ammo_magazine/mc9mmt
	name = "top mounted magazine (9mm)"
	icon = 'icons/urist/items/ammo.dmi'
	icon_state = "9mmt"
	mag_type = MAGAZINE


/obj/item/ammo_magazine/magnum/empty
	initial_ammo = 0

/obj/item/ammo_magazine/mc9mmt/rubber
	name = "top mounted magazine (9mm, rubber)"
	icon_state = "R9mmt"
	ammo_type = /obj/item/ammo_casing/c9mm/rubber

/obj/item/ammo_magazine/mc9mmt/practice
	name = "top mounted magazine (9mm, practice)"
	ammo_type = /obj/item/ammo_casing/c9mm/practice

/obj/item/ammo_magazine/mc9mmt/flash
	name = "top mounted magazine (9mm, flash)"
	icon_state = "F9mmt"
	ammo_type = /obj/item/ammo_casing/c9mm/flash

/obj/item/ammo_magazine/box/smallpistol
	name = "ammunition box"
	icon_state = "smallpistol"
	origin_tech = list(TECH_COMBAT = 2)
	matter = list(MATERIAL_STEEL = 1800)
	caliber = CALIBER_PISTOL_SMALL
	ammo_type = /obj/item/ammo_casing/pistol/small
	max_ammo = 30

/obj/item/ammo_magazine/box/pistol
	name = "ammunition box"
	icon_state = "smallpistol"
	origin_tech = list(TECH_COMBAT = 2)
	caliber = CALIBER_PISTOL
	matter = list(MATERIAL_STEEL = 2250)
	ammo_type = /obj/item/ammo_casing/pistol
	max_ammo = 30

/obj/item/ammo_magazine/box/pistol/empty
	initial_ammo = 0

/obj/item/ammo_magazine/a10mm
	name = "submachine gun magazine (10mm)"
	icon = 'icons/urist/items/ammo.dmi'
	icon_state = "10mm"
	origin_tech = list(TECH_COMBAT = 2)
/obj/item/ammo_magazine/pistol/throwback
	name = "pistol magazine"
	caliber = CALIBER_PISTOL_ANTIQUE
	ammo_type = /obj/item/ammo_casing/pistol/throwback

/obj/item/ammo_magazine/box/emp/pistol
	name = "ammunition box"
	desc = "A box containing loose rounds of standard EMP ammo."
	labels = list("haywire")
	ammo_type = /obj/item/ammo_casing/pistol/emp
	caliber = CALIBER_PISTOL
	max_ammo = 15

/obj/item/ammo_magazine/box/emp/smallpistol
	name = "ammunition box"
	desc = "A box containing loose rounds of small EMP ammo."
	labels = list("haywire")
	ammo_type = /obj/item/ammo_casing/pistol/small/emp
	caliber = CALIBER_PISTOL_SMALL
	max_ammo = 8

/obj/item/ammo_magazine/proto_smg
	name = "submachine gun magazine"
	icon_state = CALIBER_PISTOL_FLECHETTE
	origin_tech = list(TECH_COMBAT = 4)
	mag_type = MAGAZINE
	caliber = CALIBER_PISTOL_FLECHETTE
	matter = list(MATERIAL_STEEL = 2000)
	ammo_type = /obj/item/ammo_casing/flechette
	max_ammo = 40
	multiple_sprites = 1

/obj/item/ammo_magazine/a10mm/empty
	initial_ammo = 0

/obj/item/ammo_magazine/p10mm
	name = "pistol magazine (10mm)"
	icon_state = "p10mm"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	caliber = "10mm"
	matter = list(MATERIAL_STEEL = 750)
	ammo_type = /obj/item/ammo_casing/a10mm
	max_ammo = 10
	multiple_sprites = 1

/obj/item/ammo_magazine/p10mm/empty
	initial_ammo = 0

/obj/item/ammo_magazine/c4mm
	name = "submachine gun magazine (4mm)"
	icon_state = "4mm"
	origin_tech = list(TECH_COMBAT = 4)
	mag_type = MAGAZINE
	caliber = "4mm"
	matter = list(MATERIAL_STEEL = 2000)
	ammo_type = /obj/item/ammo_casing/c4mm
	max_ammo = 40
	multiple_sprites = 1

/obj/item/ammo_magazine/a762
	name = "magazine (7.62mm)"
	icon = 'icons/urist/items/ammo.dmi'
	icon_state = "762"
	origin_tech = list(TECH_COMBAT = 2)

/obj/item/ammo_magazine/gyrojet
	name = "microrocket magazine"
	icon_state = "gyrojet"
	mag_type = MAGAZINE
	caliber = CALIBER_GYROJET
	ammo_type = /obj/item/ammo_casing/gyrojet
	multiple_sprites = 1
	max_ammo = 4

/obj/item/ammo_magazine/gyrojet/empty
	initial_ammo = 0

/obj/item/ammo_magazine/a762/practice
	name = "magazine (7.62mm, practice)"
	ammo_type = /obj/item/ammo_casing/a762/practice

/obj/item/ammo_magazine/a50
	name = "magazine (.50)"
	icon = 'icons/urist/items/ammo.dmi'
	icon_state = "50ae"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	caliber = ".50"
	matter = list(MATERIAL_STEEL = 1680)
	ammo_type = /obj/item/ammo_casing/a50
	max_ammo = 7
/obj/item/ammo_magazine/box/machinegun
	name = "magazine box"
	icon_state = "machinegun"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	caliber = CALIBER_RIFLE
	matter = list(MATERIAL_STEEL = 4500)
	ammo_type = /obj/item/ammo_casing/rifle
	max_ammo = 50
	multiple_sprites = 1

/obj/item/ammo_magazine/box/machinegun/empty
	initial_ammo = 0

/obj/item/ammo_magazine/a75
	name = "ammo magazine (20mm)"
	icon = 'icons/urist/items/ammo.dmi'
	icon_state = "20mm"
/obj/item/ammo_magazine/rifle
	name = "assault rifle magazine"
	icon_state = "assault_rifle"
	mag_type = MAGAZINE
	caliber = CALIBER_RIFLE
	matter = list(MATERIAL_STEEL = 1800)
	ammo_type = /obj/item/ammo_casing/rifle
	max_ammo = 20
	multiple_sprites = 1

/obj/item/ammo_magazine/a75/empty
	initial_ammo = 0

/obj/item/ammo_magazine/box/a556
	name = "magazine box (5.56mm)"
	icon_state = "a556"
/obj/item/ammo_magazine/mil_rifle
	name = "assault rifle magazine"
	icon_state = "bullpup"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	caliber = CALIBER_RIFLE_MILITARY
	matter = list(MATERIAL_STEEL = 1800)
	ammo_type = /obj/item/ammo_casing/rifle/military
	max_ammo = 15
	multiple_sprites = 1

/obj/item/ammo_magazine/mil_rifle/heavy
	labels = list("heavy")

/obj/item/ammo_magazine/mil_rifle/heavy/empty
	initial_ammo = 0

/obj/item/ammo_magazine/c556
	name = "magazine (5.56mm)"
	icon = 'icons/urist/items/ammo.dmi'
	icon_state = "c556"
	mag_type = MAGAZINE
	caliber = "a556"
	matter = list(MATERIAL_STEEL = 1800)
	ammo_type = /obj/item/ammo_casing/a556
/obj/item/ammo_magazine/mil_rifle/heavy/practice
	labels = list("heavy, practice")
	ammo_type = /obj/item/ammo_casing/rifle/military/practice

/obj/item/ammo_magazine/mil_rifle/light
	icon_state = "bullpup_light"
	labels = list("light")
	ammo_type = /obj/item/ammo_casing/rifle/military/light
	max_ammo = 20

/obj/item/ammo_magazine/mil_rifle/light/empty
	initial_ammo = 0

/obj/item/ammo_magazine/mil_rifle/light/practice
	labels = list("light, practice")
	ammo_type = /obj/item/ammo_casing/rifle/military/practice

/obj/item/ammo_magazine/caps
	name = "speed loader"
	desc = "A cheap plastic speed loader for some kind of revolver."
	icon_state = "T38"
	caliber = CALIBER_CAPS
	ammo_type = /obj/item/ammo_casing/cap
	matter = list(MATERIAL_STEEL = 600)
	max_ammo = 7
	multiple_sprites = 1

/obj/item/ammo_magazine/iclipr
	name = "en-bloc clip"
	desc = "An en-bloc clip for the garand rifle."
	icon_state = "iclipr"
	caliber = CALIBER_RIFLE
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/rifle
	matter = list(MATERIAL_STEEL = 1500)
	max_ammo = 8
	multiple_sprites = TRUE
