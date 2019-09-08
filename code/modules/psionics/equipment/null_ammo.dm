/obj/item/projectile/bullet/nullglass
	name = "nullglass bullet"
	damage = 40
	shrapnel_type = /obj/item/weapon/material/shard/nullglass

/obj/item/projectile/bullet/nullglass/disrupts_psionics()
	return src

/obj/item/ammo_casing/c44/nullglass
	desc = "A revolver bullet casing with a nullglass coating."
	projectile_type = /obj/item/projectile/bullet/nullglass

/obj/item/ammo_casing/c44/nullglass/disrupts_psionics()
	return src

/obj/item/ammo_magazine/c44/nullglass
	ammo_type = /obj/item/ammo_casing/c44/nullglass