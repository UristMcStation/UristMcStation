//tanning racks and etc

/*/obj/structure/tanningrack
	name = "tanning rack"
	desc = "It's a tanning rack. Nothing too special, place hides or gut on it and leave them to dry."
	icon = 'icons/urist/structures&machinery/structures.dmi'
	icon_state = "drying-rack"*/

/obj/machinery/smartfridge/tanningrack
	name = "\improper Tanning Rack"
	desc = "A machine for tanning hides."
	icon = 'icons/urist/structures&machinery/machinery.dmi'
	icon_state = "drying_rack"
	icon_on = "drying_rack_on"
	icon_off = "drying_rack"

/obj/machinery/smartfridge/tanningrack/accept_check(var/obj/item/O as obj)
	if(istype(O, /obj/item/stack/hide/hairless))
		return 1

/obj/machinery/smartfridge/tanningrack/process()
	..()
	if(inoperable())
		return
	for(var/datum/stored_items/I in item_records)
		if(I.instances.len)
			dry()
			update_icon()

/obj/machinery/smartfridge/tanningrack/update_icon()
	overlays.Cut()
	if(inoperable())
		icon_state = icon_off
	else
		icon_state = icon_on
	for(var/datum/stored_items/I in item_records)
		if(I.instances.len)
			overlays += "drying_rack_filled"
			if(!inoperable())
				overlays += "drying_rack_drying"

/obj/machinery/smartfridge/tanningrack/proc/dry()
	for(var/datum/stored_items/I in item_records)
		for(var/obj/item/stack/hide/hairless/S in I.instances)
			if(S.dried >= 40)
				S.dried = 0
				var/obj/item/stack/material/leather/L = new/obj/item/stack/material/leather(src)
				L.amount = S.amount
				I.instances.Remove(S)
				qdel(S)
				stock_item(L)
				GLOB.nanomanager.update_uis(src)
				return

			else
				S.dried += 1

/obj/machinery/smartfridge/tanningrack/New()
	..()
	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/tanningrack(src)
	component_parts += new /obj/item/stack/material/wood(src, 4)
	component_parts += new /obj/item/weapon/stock_parts/scanning_module(src)
	component_parts += new /obj/item/weapon/stock_parts/console_screen(src)
	component_parts += new /obj/item/stack/cable_coil(src, 5)

/obj/machinery/smartfridge/tanningrack/attackby(var/obj/item/I, mob/user as mob)
	if(default_deconstruction_screwdriver(user, I))
		return
	if(default_deconstruction_crowbar(user, I))
		return
	if(default_part_replacement(user, I))
		return

	..()

//hide

/obj/item/stack/hide //the old hide stuff is garbage and makes no sense. why did bay make them materials? we will never know, and I don't want the potential of hairless hide barricades because fucking hell Zuhayr.
	icon = 'icons/obj/items.dmi' //so then, to make things make sense, we're making new things. But we're keeping the steps mostly the same.

/obj/item/stack/hide/animalhide
	name = "animal hide"
	icon_state = "sheet-hide"
	max_amount = 10

//step two is dehairing. We actually soak it first, then dehair it, then put it on our magical tanning rack.
//we're skipping curing and going straight to soaking. Skipping liming and going straight to dehairing, and skipping all the stages with the chemicals and just going straight to our tanning rack.

/obj/item/stack/hide/wet/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(is_sharp(W))
		if(!busy)
		//visible message on mobs is defined as visible_message(var/message, var/self_message, var/blind_message)
			busy = 1
			user.visible_message("<span class='notice'>\The [user] starts cutting hair off \the [src]</span>", "<span class='notice'>You start cutting the hair off \the [src]</span>", "You hear the sound of a knife rubbing against flesh")

			if(do_after(user,10))
				to_chat(user, "<span class='notice'>You cut the hair from the wet animal hide.</span>")
				//Try locating an exisitng stack on the tile and add to there if possible
				/*for(var/obj/item/stack/hide/hairless/HS in user.loc) //fucking legacy code
					if(HS.amount != HS.max_amount)
						HS.amount += 1
						src.use(1)
						break*/
				//If it gets to here it means it did not find a suitable stack on the tile.
				var/obj/item/stack/hide/hairless/HS = new(user.loc)
				HS.amount = 1
				src.use(1)
				busy = 0
	else
		..()

/obj/item/stack/hide/hairless
	name = "hairless hide"
	icon_state = "sheet-hairlesshide"
	max_amount = 10
	var/dried = 0

/obj/item/stack/hide/wet
	name = "wet hide"
	icon_state = "sheet-wetleather"
	max_amount = 10
	var/busy = 0

/material/leather/generate_recipes()
	recipes = list()

	recipes += new/datum/stack_recipe_list("holsters", list( \
		new/datum/stack_recipe("hip holster", /obj/item/clothing/accessory/holster/hip, 2, time = 40), \
		new/datum/stack_recipe("waist holster", /obj/item/clothing/accessory/holster/waist, 2, time = 40), \
		new/datum/stack_recipe("armpit holster", /obj/item/clothing/accessory/holster/armpit, 2, time = 40), \
		))
	recipes += new/datum/stack_recipe("tool belt", /obj/item/weapon/storage/belt/utility, 3, time = 45)
	recipes += new/datum/stack_recipe("briefcase", /obj/item/weapon/storage/briefcase, 1, time = 30)
	recipes += new/datum/stack_recipe("wallet", /obj/item/weapon/storage/wallet/leather, 1, time = 30)
	recipes += new/datum/stack_recipe("knife harness", /obj/item/clothing/accessory/storage/knifeharness, 1, time = 30)
	recipes += new/datum/stack_recipe("eyepatch", /obj/item/clothing/glasses/eyepatch, 1, time = 30)
	recipes += new/datum/stack_recipe("botanist leather gloves", /obj/item/clothing/gloves/botanic_leather, 2, time = 40)
	recipes += new/datum/stack_recipe("leather work gloves", /obj/item/clothing/gloves/urist/leather, 3, time = 45)
	recipes += new/datum/stack_recipe("leather shoes", /obj/item/clothing/gloves/botanic_leather, 2, time = 30)
	recipes += new/datum/stack_recipe("jungle boots", /obj/item/clothing/shoes/jungleboots, 2, time = 40)
	recipes += new/datum/stack_recipe("laceup shoes", /obj/item/clothing/gloves/botanic_leather, 2, time = 30)
	recipes += new/datum/stack_recipe("leather work boots", /obj/item/clothing/shoes/urist/leather, 4, time = 45)
	recipes += new/datum/stack_recipe("cowboy hat", /obj/item/clothing/head/urist/cowboy, 2, time = 35)
	recipes += new/datum/stack_recipe("flatcap", /obj/item/clothing/head/flatcap, 2, time = 25)
	recipes += new/datum/stack_recipe_list("coats", list( \
		new/datum/stack_recipe("duster", /obj/item/clothing/suit/storage/urist/coat/duster, 5, time = 50), \
		new/datum/stack_recipe("leather coat", /obj/item/clothing/suit/storage/urist/coat/leather, 5, time = 50), \
		new/datum/stack_recipe("black leather jacket", /obj/item/clothing/suit/coat/jacket/leather, 4, time = 45), \
		new/datum/stack_recipe("alternate black leather jacket", /obj/item/clothing/suit/storage/leather_jacket, 4, time = 45), \
		new/datum/stack_recipe("Nanotrasen black leather jacket", /obj/item/clothing/suit/storage/leather_jacket/nanotrasen, 4, time = 45), \
		new/datum/stack_recipe("leather trenchcoat", /obj/item/clothing/suit/leathercoat, 4, time = 45), \
		new/datum/stack_recipe("brown leather jacket", /obj/item/clothing/suit/storage/toggle/brown_jacket, 4, time = 45), \
		new/datum/stack_recipe("Nanotrasen brown leather jacket", /obj/item/clothing/suit/storage/toggle/brown_jacket/nanotrasen, 4, time = 45), \
		))
	recipes += new/datum/stack_recipe("leather protective suit", /obj/item/clothing/suit/storage/hooded/sandsuit, 6, time = 60)
	recipes += new/datum/stack_recipe("leather pants", /obj/item/clothing/under/pants/urist/leatherpants, 2, time = 35)
	recipes += new/datum/stack_recipe("leather overalls", /obj/item/clothing/suit/storage/urist/overalls/leather, 3, time = 40)
	recipes += new/datum/stack_recipe("factory worker's apron", /obj/item/clothing/suit/storage/urist/apron, 3, time = 40)
	recipes += new/datum/stack_recipe("welder apron", /obj/item/clothing/suit/urist/welderapron, 2, time = 30)
	recipes += new/datum/stack_recipe("leather mask", /obj/item/clothing/mask/bandana/leather, 1, time = 30)