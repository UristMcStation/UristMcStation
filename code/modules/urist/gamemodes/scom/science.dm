/obj/item/scom/science //a generic holder for science shit
	name = "alien technology"
	icon = 'icons/obj/stock_parts.dmi'
	w_class = 2

/obj/item/scom/science/New()
	icon_state = pick("capacitor", "micro_laser", "micro_mani", "matter_bin", "scan_module")

/obj/structure/scom
	anchored = 1
	density = 1

/obj/structure/scom/science //a generic holder for science shit
	name = "alien technology"
	icon = 'icons/urist/turf/scomturfs.dmi'
	var/scomtechlvl = 0
	var/scommoney = 0


/obj/structure/scom/science/attack_hand(mob/user as mob)
	var/obj/item/scom/science/S = new/obj/item/scom/science

	S.scomtechlvl = scomtechlvl
	S.scommoney = scommoney

	user.put_in_hands(S)
	user << "<span class='notice'>You salvage some usable objects from the alien technology.</span>"
	qdel(src)
	return

/obj/item/scom/aliengun
	name = "alien weapon"
	desc = "An inert alien weapon, dropped by the lactera."
	icon = 'icons/urist/items/guns.dmi'

/obj/item/scom/aliengun/a1
	icon_state = "xeno-pistol"
	scomtechlvl = 1
	scommoney = 100
	origin_tech = "combat=6;magnets=4;materials=3;engineering=1;powerstorage=3;"

/obj/item/scom/aliengun/a2
	icon_state = "xeno-carbine"
	scomtechlvl = 2
	scommoney = 250
	origin_tech = "combat=7;magnets=5;materials=4;engineering=2;powerstorage=4;"

/obj/item/scom/aliengun/a3
	scomtechlvl = 4
	scommoney = 600
	icon_state = "xeno-rifle"
	origin_tech = "combat=7;magnets=5;materials=5;engineering=3;powerstorage=5;"

/obj/item/scom/aliengun/a4
	scomtechlvl = 6
	scommoney = 1000
	icon_state = "xeno-hmg"
	origin_tech = "combat=8;magnets=5;materials=5;engineering=3;powerstorage=5;"

/obj/item/scom/borgmodkit
	name = "cyborg mod kit - Combat"
	desc = "A mod kit to convert a cyborg into a Combat Borg"
	icon = 'icons/urist/items/old_bay_custom_items.dmi'
	icon_state = "royce_kit"

/obj/item/scom/borgmodkit/attack(var/mob/living/silicon/robot/R)
//	R/var/module_sprites[0]
	R.module = new /obj/item/weapon/robot_module/security/combat/(src)
	R.modtype = "Combat"
//	R.module_sprites["Combat Android"] = "droid-combat"
	R.update_icon()
	qdel(src)
	return

/obj/item/organ/internal/xenos
	scomtechlvl = 2 //worth about as much as lactera rifles
	scommoney = 75 //each, so more in total