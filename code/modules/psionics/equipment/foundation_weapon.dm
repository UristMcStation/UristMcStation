/obj/item/weapon/gun/projectile/revolver/foundation
	name = "\improper Foundation revolver"
	icon = 'icons/obj/guns/foundation.dmi'
	icon_state = "foundation"
	desc = "The CF 'Troubleshooter', a compact plastic-composite weapon designed for concealed carry by Cuchulain Foundation field agents. Smells faintly of copper."
	ammo_type = /obj/item/ammo_casing/c44/nullglass

/obj/item/weapon/gun/projectile/revolver/foundation/disrupts_psionics()
	return FALSE

/obj/item/weapon/storage/briefcase/foundation
	name = "\improper Foundation briefcase"
	desc = "A handsome black leather briefcase embossed with the Cuchulain Foundation logo."
	icon_state = "fbriefcase"
	item_state = "fbriefcase"

/obj/item/weapon/storage/briefcase/foundation/disrupts_psionics()
	return FALSE

/obj/item/weapon/storage/briefcase/foundation/New()
	..()
	new /obj/item/ammo_magazine/c44/nullglass(src)
	new /obj/item/weapon/gun/projectile/revolver/foundation(src)
	make_exact_fit()
