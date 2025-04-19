//smithing stuff rescued from king and country

/obj/structure/blacksmithingfurnace
	name = "furnace"
	desc = "The furnace wall, warm to the touch."
	icon = 'icons/urist/king/furnace.dmi'
	icon_state = "furnace"
	density = FALSE
	anchored = TRUE

/obj/structure/blacksmithingfurnace/furnace
	name = "furnace"
	desc = "A pretty hot furnance. Be careful while using it."
	icon = 'icons/urist/king/blacksmithing.dmi'
	icon_state = "furnace"
	density = FALSE
	anchored = TRUE

/obj/structure/blacksmithingfurnace/furnace/use_tool(obj/item/W, mob/living/user, list/click_params)
	if(istype(W, /obj/item/ore/iron))
		user.drop_item(W)
		playsound(loc, 'sound/urist/furnace.ogg', 100, 5, 5)
		qdel(W)
		sleep(180)
		visible_message("<span class='notice'>The ore finished smelting.</span>")
		new /obj/item/ore/hot/iron(get_turf(src))

	else if(istype(W, /obj/item/ore/gold))
		user.drop_item(W)
		playsound(loc, 'sound/urist/furnace.ogg', 100, 5, 5)
		qdel(W)
		sleep(200)
		visible_message("<span class='notice'>The ore finished smelting.</span>")
		new /obj/item/ore/hot/gold(get_turf(src))

	else if(istype(W, /obj/item/ore/silver))
		user.drop_item(W)
		playsound(loc, 'sound/urist/furnace.ogg', 100, 5, 5)
		qdel(W)
		sleep(190)
		visible_message("<span class='notice'>The ore finished smelting.</span>")
		new /obj/item/ore/hot/silver(get_turf(src))

	else if(istype(W, /obj/item/ore/diamond))
		user.drop_item(W)
		playsound(loc, 'sound/urist/furnace.ogg', 100, 5, 5)
		qdel(W)
		sleep(220)
		visible_message("<span class='notice'>The ore finished smelting.</span>")
		new /obj/item/stack/material/diamond(get_turf(src))

//	else if(istype(W, /obj/item/ore/glass))
//		user.drop_item(W)
//		playsound(loc, 'sound/urist/furnace.ogg', 100, 5, 5)
//		qdel(W)
//		sleep(150)
//		visible_message("<span class='notice'>The ore finished smelting.</span>")
//		var/obj/item/stack/material/sandstone/I = new /obj/item/stack/material/sandstone(get_turf(src))

	else
		..()

//
//Hammer
//

/obj/item/hammer
	name = "hammer"
	desc = "Hmmm, it's shaped like a hammer, I wonder what it could be?"
	icon = 'icons/urist/king/items.dmi'
	icon_state = "hammer"
	slot_flags = SLOT_BELT
	force = 9.0
	throwforce = 5.0
	w_class = ITEM_SIZE_SMALL
	origin_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 300, "wood" = 400)
	center_of_mass = "x=17;y=16"
	attack_verb = list("bashed", "battered", "bludgeoned", "whacked")

/obj/item/hammer/smithing
	name = "smithing hammer"
	icon_state = "hammers"
	w_class = 3

/obj/item/stack/material/var/list/techniques = list()

/obj/item/stack/material/proc/metal_technique(mob/user)

	var/technique = input("Select an item to forge..","Techniques") as null|anything in techniques

	var/list/build_data = techniques[technique]
	if(!islist(build_data) || !ispath(build_data["path"]))
		return

	if(get_amount() < build_data["cost"])
		to_chat(user, "There is not enough material in this stack to make that.")
		return

	if(!do_after(user, 300, src))
		return

	var/building_path = build_data["path"]
	new building_path(get_turf(src), material.name)
	use(build_data["cost"])

/obj/item/stack/material/iron
	techniques = list(
	"Longsword" = list("path" = /obj/item/material/sword/urist/basic,  "cost" = 9),
	"Sabre" = list("path" = /obj/item/material/sword/urist/sabre, "cost" = 7),
	"Knife" = list("path" = /obj/item/material/knife/hunting, "cost" = 3),
	"Pickaxe Head" = list("path" = /obj/item/improv/pickaxe_head, "cost" = 7),
	"Axe Head" = list("path" = /obj/item/improv/axe_head, "cost" = 10),
	"Rapier" = list("path" = /obj/item/material/sword/urist/rapier, "cost" = 7),
//	"large musket ball" = list("path" = /obj/item/projectile/bullet/rifle/king, "cost" = 2),
//	"musket ball" = list("path" = /obj/item/projectile/bullet/rifle/king/short, "cost" = 2),
//	"small musket ball" = list("path" = /obj/item/projectile/bullet/rifle/king/flintlock, "cost" = 1),
	"long musket barrel" = list("path" = /obj/item/gunsmith/barrel/long,  "cost" = 15),
	"short musket barrel" = list("path" = /obj/item/gunsmith/barrel/short, "cost" = 12),
	"flintlock pistol barrel" = list("path" = /obj/item/gunsmith/barrel/flintlock, "cost" = 10),
	"gun parts" = list("path" = /obj/item/gunsmith/parts, "cost" = 5),
	"large musket shot" = list("path" = /obj/item/ammo_casing/musket, "cost" = 1),
	"musket shot" = list("path" = /obj/item/ammo_casing/musket/short, "cost" = 1),
	"flintlock pistol shot" = list("path" = /obj/item/ammo_casing/musket/flintlock, "cost" = 1)
	)

/obj/item/stack/material/steel
	techniques = list(
	"Longsword" = list("path" = /obj/item/material/sword/urist/basic,  "cost" = 9),
	"Sabre" = list("path" = /obj/item/material/sword/urist/sabre, "cost" = 7),
	"Knife" = list("path" = /obj/item/material/knife/hunting, "cost" = 3),
	"Pickaxe Head" = list("path" = /obj/item/improv/pickaxe_head, "cost" = 7),
	"Axe Head" = list("path" = /obj/item/improv/axe_head, "cost" = 10),
	"Rapier" = list("path" = /obj/item/material/sword/urist/rapier, "cost" = 7),
	"long musket barrel" = list("path" = /obj/item/gunsmith/barrel/long,  "cost" = 15),
	"short musket barrel" = list("path" = /obj/item/gunsmith/barrel/short, "cost" = 12),
	"flintlock pistol barrel" = list("path" = /obj/item/gunsmith/barrel/flintlock, "cost" = 10),
	"gun parts" = list("path" = /obj/item/gunsmith/parts, "cost" = 5)
	)

/obj/item/stack/material/plasteel
	techniques = list(
	"Longsword" = list("path" = /obj/item/material/sword/urist/basic,  "cost" = 9),
	"Sabre" = list("path" = /obj/item/material/sword/urist/sabre, "cost" = 7),
	"Knife" = list("path" = /obj/item/material/knife/hunting, "cost" = 3),
	"Shield" = list("path" = /obj/item/shield/riot/metal, "cost" = 10)
	)

/obj/item/stack/material/silver
	techniques = list(
	"Longsword" = list("path" = /obj/item/material/sword/urist/basic,  "cost" = 9),
	)

//THANKS TO NAX FOR DOING MAJORITY OF THE STUFF.

//
//ORE
//
/obj/item/ore/hot
	name = "hot ingot"
	desc = "A hot ingot. Duh."
	icon = 'icons/urist/king/blacksmithing.dmi'
	icon_state = "iron"
	var/busy
	var/output

/obj/item/ore/hot/New()
	..()
	spawn(2400) //Four minutes
		new output(get_turf(src))
		qdel(src)


/obj/item/ore/hot/use_tool(obj/item/W, mob/living/user, list/click_params)
	if((istype(W, /obj/item/hammer)) && (locate(/obj/structure/anvil) in loc))
		if(!busy)
			busy = 1
			playsound(loc, 'sound/urist/metalsmack.ogg', 100, 20, 20)
			if(do_after(user, 10, src)) //One second
				to_chat(usr, "<font color='red'>You hit the [name]!</font>")

				if(prob(25))
					new output(get_turf(src))
					to_chat(usr, "<font color='red'>The [name] forms.</font>")
					qdel(src)

				else if(prob(2))
					new /obj/item/ore/slag(get_turf(src))
					to_chat(usr, "<font color='red'>The [name] forms into a block of slag...</font>")
					qdel(src)

			else
				to_chat(usr, "<font color='red'>You must stand still while hammering the [name]!</font>")

		busy = 0
		return TRUE

	return ..()

/obj/item/ore/hot/iron
	name = "hot iron"
	desc = "A hot piece of iron. Duh."
	output = /obj/item/stack/material/iron

/obj/item/ore/hot/gold
	name = "hot gold"
	desc = "A hot piece of gold. Duh."
	icon_state = "gold"
	output = /obj/item/stack/material/gold

/obj/item/ore/hot/silver
	name = "hot silver"
	desc = "A hot piece of silver. Duh."
	icon_state = "silver"
	output = /obj/item/stack/material/silver

//
//Anvil
//

/obj/structure/anvil
	name = "anvil"
	icon = 'icons/urist/king/blacksmithing.dmi'
	icon_state = "anvil"
	density = TRUE
	anchored = TRUE
	var/busy = 0

/obj/structure/anvil/use_tool(obj/item/W, mob/living/user, list/click_params)
	if(istype(W,/obj/item/ore/hot) || istype(W,/obj/item/stack/material))
		user.drop_from_inventory(W, src.loc)
		return TRUE

	if(istype(W,/obj/item/weldingtool))
		var/obj/item/weldingtool/WT = W
		if (WT.remove_fuel(0,user))
			playsound(src.loc, 'sound/items/Welder2.ogg', 50, 1)
			user.visible_message("[user.name] starts to disassemble the anvil.", \
				"You start to disassemble the anvil.", \
				"You hear welding")
			if (do_after(user,30,src))
				if(!src || !WT.isOn()) return
				var/obj/item/stack/material/iron/I = new /obj/item/stack/material/iron(src.loc)
				I.amount = 5
				qdel(src)
				to_chat(user, "You disassemble the anvil.")
		else
			to_chat(user, "<span class='warning'>You need more welding fuel to complete this task.</span>")
		return TRUE

	return ..()

//gunsmithing

//PARTS

/obj/item/gunsmith
	icon = 'icons/urist/king/gunsmith.dmi'

/obj/item/gunsmith/stock
	name = "error"
	icon_state = null
	slot_flags = SLOT_BELT
	force = 4.0
	throwforce = 3.0

/obj/item/gunsmith/stock/long
	name = "long rifle stock"
	desc = "It's a stock, for a rifle."
	icon_state = "longrifle1"

/obj/item/gunsmith/stock/short
	name = "short rifle stock"
	desc = "It's a stock, for a rifle."
	icon_state = "shortrifle1"

/obj/item/gunsmith/stock/flintlock
	name = "flintlock stock"
	desc = "It's a stock, for a flintlock."
	icon_state = "flintlock1"

/////////////////////////////////////

/obj/item/gunsmith/barrel
	name = "error"
	icon_state = null
	slot_flags = SLOT_BELT
	force = 5.0
	throwforce = 3.0

/obj/item/gunsmith/barrel/long
	name = "long rifle barrel"
	desc = "It's a barrel, for a rifle."
	icon_state = "riflebarrel"

/obj/item/gunsmith/barrel/short
	name = "short rifle barrel"
	desc = "It's a barrel, for a rifle."
	icon_state = "riflebarrel"

/obj/item/gunsmith/barrel/flintlock
	name = "flintlock barrel"
	desc = "It's a barrel, for a flintlock."
	icon_state = "flintlockbarrel"

/obj/item/gunsmith/parts
	name = "gun parts"
	desc = "Some finishing gun parts."
	icon_state = "parts"

/////////////////////////////////////

/obj/item/gunsmith/gun2
	name = "error"
	icon_state = null
	slot_flags = SLOT_BELT
	force = 4.0
	throwforce = 3.0

/obj/item/gunsmith/gun2/long
	name = "long rifle half-built"
	desc = "It's a half-built rifle."
	icon_state = "longrifle2"

/obj/item/gunsmith/gun2/short
	name = "short rifle half-built"
	desc = "It's a half-built rifle."
	icon_state = "shortrifle2"

/obj/item/gunsmith/gun2/flintlock
	name = "flintlock half-built"
	desc = "It's a half-built flintlock."
	icon_state = "flintlock2"

/////////////////////////////////////

//keeping the old stocks just incase i change my mind. but for now, we're just going to use the imp rifle stock

/obj/item/gunsmith/stock/long/use_tool(obj/item/W, mob/living/user, list/click_params)
	if(istype(W,/obj/item/gunsmith/barrel/long))
		var/obj/item/gunsmith/gun2/long/I = new /obj/item/gunsmith/gun2/long(get_turf(src))
		to_chat(user, "You put the barrel onto the stock.")
		qdel(W)
		qdel(src)

		user.put_in_hands(I)

	else
		..()

/obj/item/gunsmith/stock/short/use_tool(obj/item/W, mob/living/user, list/click_params)
	if(istype(W,/obj/item/gunsmith/barrel/short))
		var/obj/item/gunsmith/gun2/short/I = new /obj/item/gunsmith/gun2/short(get_turf(src))
		to_chat(user, "You put the barrel onto the stock.")
		qdel(W)
		qdel(src)

		user.put_in_hands(I)

	else
		..()


//////////////////////////////////////

/obj/item/gunsmith/stock/flintlock/use_tool(obj/item/W, mob/living/user, list/click_params)
	if(istype(W,/obj/item/gunsmith/barrel/flintlock))
		var/obj/item/gunsmith/gun2/flintlock/I = new /obj/item/gunsmith/gun2/flintlock(get_turf(src))
		to_chat(user, "You put the barrel onto the stock.")
		qdel(W)
		qdel(src)

		user.put_in_hands(I)

	else
		..()

/////////////////////////////////////

/obj/item/gunsmith/gun2/long/use_tool(obj/item/W, mob/living/user, list/click_params)
	if(istype(W,/obj/item/gunsmith/parts))
		var/obj/item/gun/projectile/manualcycle/musket/I = new /obj/item/gun/projectile/manualcycle/musket(get_turf(src))
		to_chat(user, "You put the parts onto the unfinished gun.")
		qdel(W)
		qdel(src)

		user.put_in_hands(I)

	else
		..()

/obj/item/gunsmith/gun2/short/use_tool(obj/item/W, mob/living/user, list/click_params)
	if(istype(W,/obj/item/gunsmith/parts))
		var/obj/item/gun/projectile/manualcycle/musket/short/I = new /obj/item/gun/projectile/manualcycle/musket/short(get_turf(src))
		to_chat(user, "You put the parts onto the unfinished gun.")
		qdel(W)
		qdel(src)

		user.put_in_hands(I)

	else
		..()

/obj/item/gunsmith/gun2/flintlock/use_tool(obj/item/W, mob/living/user, list/click_params)
	if(istype(W,/obj/item/gunsmith/parts))
		var/obj/item/gun/projectile/manualcycle/musket/flintlock/I = new /obj/item/gun/projectile/manualcycle/musket/flintlock(get_turf(src))
		to_chat(user, "You put the parts onto the unfinished gun.")
		qdel(W)
		qdel(src)

		user.put_in_hands(I)

	else
		..()
