/obj/item/scom/science //a generic holder for science shit
	name = "alien technology"
	icon = 'icons/obj/stock_parts.dmi'
	w_class = 2
	origin_tech = list(TECH_MAGNET = 7, TECH_MATERIAL = 6, TECH_ENGINEERING = 4, TECH_POWER=7)

/obj/item/scom/science/Initialize()
	. = ..()
	icon_state = pick("capacitor", "micro_laser", "micro_mani", "matter_bin", "scan_module")

/obj/structure/scom
	anchored = TRUE
	density = TRUE

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
	to_chat(user, "<span class='notice'>You salvage some usable objects from the alien technology.</span>")
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
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 1, TECH_MATERIAL = 1, TECH_POWER=2)

/obj/item/scom/aliengun/a2
	icon_state = "xeno-carbine"
	scomtechlvl = 2
	scommoney = 250
	origin_tech = list(TECH_COMBAT = 5, TECH_MAGNET = 2, TECH_MATERIAL = 2,  TECH_POWER=3)

/obj/item/scom/aliengun/a3
	scomtechlvl = 4
	scommoney = 600
	icon_state = "xeno-rifle"
	origin_tech = list(TECH_COMBAT = 6, TECH_MAGNET = 2, TECH_MATERIAL = 2,  TECH_POWER=4)

/obj/item/scom/aliengun/a4
	scomtechlvl = 6
	scommoney = 1000
	icon_state = "xeno-hmg"
	origin_tech = list(TECH_COMBAT = 7, TECH_MAGNET = 3, TECH_MATERIAL = 2, TECH_POWER=5)

/obj/item/scom/borgmodkit
	name = "cyborg mod kit - Combat"
	desc = "A mod kit to convert a cyborg into a Combat Borg"
	icon = 'icons/urist/items/old_bay_custom_items.dmi'
	icon_state = "royce_kit"

/obj/item/scom/borgmodkit/attack(mob/living/silicon/robot/R)
//	R/var/module_sprites[0]
	R.module = new /obj/item/robot_module/security/combat/(src)
	R.modtype = "Combat"
//	R.module_sprites["Combat Android"] = "droid-combat"
	R.update_icon()
	qdel(src)
	return

/obj/item/organ/internal/xenos
	scomtechlvl = 2 //worth about as much as lactera rifles
	scommoney = 75 //each, so more in total
