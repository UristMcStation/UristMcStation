/obj/item/clothing/suit/urist/armor/anfor
	name = "anfor armour"
	desc = "dammit admins, stop spawning the parent classes"
	icon_state = "heavyscom"
	armor = list(melee = 50, bullet = 60, laser = 40, energy = 25, bomb = 30, bio = 0, rad = 0)

/obj/item/clothing/suit/urist/armor/anfor/nco
	name = "ANFOR NCO armour"
	desc = "The M3 PPA, standard issue armour for ANFOR marines. This one has the markings of a Non-Commissioned Officer."
	icon_state = "m3_ppa_nco"

/obj/item/clothing/suit/urist/armor/anfor/marine
	name = "ANFOR Marine armour"
	desc = "The M3 PPA, standard issue armour for ANFOR marines. This one has the markings of a standard marine"
	icon_state = "m3_ppa"

/obj/item/clothing/suit/urist/armor/anfor/engi
	name = "ANFOR Engineering armour"
	desc = "The M3 PPA, standard issue armour for ANFOR marines. This one has the markings of a marine in the Engineering division."
	icon_state = "m3_ppa_enge"

/obj/item/clothing/suit/urist/armor/anfor/medic
	name = "ANFOR Medic armour"
	desc = "The M3 PPA, standard issue armour for ANFOR marines. This one has the markings of a field medic."
	icon_state = "m3_ppa_medic"

/obj/item/clothing/under/urist/anfor
	name = "ANFOR Marine BDU"
	desc = "An olive drab Battle Dress Uniform, standard issue for ANFOR marines."
	icon_state = "bdu_olive"
	item_state = "bdu_olive"

/obj/item/clothing/under/urist/anfor/verb/rollsleeves()
	set name = "Roll Sleeves"
	set category = "Object"
	set src in usr
	if(!usr.canmove || usr.stat || usr.restrained())
		return

	if(icon_state == "bdu_olive_shirt")
		src.icon_state = "bdu_olive"
		src.item_state = "bdu_olive"
		usr << "You roll down the sleeves of your BDU."
		usr.regenerate_icons()

	else
		src.icon_state = "bdu_olive_shirt"
		src.item_state = "bdu_olive_shirt"
		usr << "You roll up the sleeves of your BDU."
		usr.regenerate_icons()

/obj/item/clothing/head/helmet/urist/anfor
	name = "ANFOR Marine helmet"
	desc = "An olive drab M10 protective helmet, standard issue for all Anfor marines."
	icon_state = "m10_pbh"
