//improvised armour, just hazardvest for now, more later

//hazardvest

/obj/item/improv/hazardvest/step1
	name = "hazard vest with holes"
	desc = "A high-visibility vest used in work zones. There are some holes in it."
	icon_state = "vest_hole"
	item_state = "hazard"
	icon = 'icons/urist/items/improvised.dmi'

/obj/item/improv/hazardvest/step2
	name = "hazard vest with cables"
	desc = "A high-visibility vest used in work zones. There are some cables strapped to it."
	icon_state = "vest_hole_wire"
	item_state = "hazard"
	icon = 'icons/urist/items/improvised.dmi'

/obj/item/improv/hazardvest/step3
	name = "hazard vest with metal"
	desc = "A high-visibility vest used in work zones. There is a metal sheet strapped loosely to it."
	icon_state = "vest_wire_metal"
	item_state = "hazard"
	icon = 'icons/urist/items/improvised.dmi'

/obj/item/clothing/suit/storage/hazardvest/armor //fukken americans. it's armour, but conventions
	name = "hazard vest armor"
	desc = "A high-visibility vest used in work zones. It's been made into a rudimentary armored vest."	//armoured. fuck.
	icon_override = 'icons/uristmob/clothes.dmi'
	icon = 'icons/urist/items/improvised.dmi'
	icon_state = "vest_wire_tight_metal"
	item_state = "hazard"
	armor = list(melee = 27, bullet = 12, laser = 5, energy = 0, bomb = 5, bio = 0, rad = 0)//roughly half as effective as sec armour

/obj/item/clothing/suit/storage/hazardvest/use_tool(obj/item/I, mob/living/user, list/click_params)
	..()
	if(istype(I, /obj/item/wirecutters))
		for(var/obj/item/storage/internal/O in contents)
			var/turf/T = get_turf(src)
			for(var/obj/item/Z in O.contents)
				O.remove_from_storage(Z, T)
			qdel(O)

		var/obj/item/improv/hazardvest/step1/H = new /obj/item/improv/hazardvest/step1

		user.remove_from_mob(src)
		user.put_in_hands(H)
		to_chat(user, "<span class='notice'>You cut some holes in the hazard vest.</span>")

		qdel(src)

/obj/item/improv/hazardvest/step1/use_tool(obj/item/I, mob/living/user, list/click_params)
	..()
	if(istype(I, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/R = I
		var/obj/item/improv/hazardvest/step2/H = new /obj/item/improv/hazardvest/step2
		R.use(2)

		user.remove_from_mob(src)

		user.put_in_hands(H)
		to_chat(user, "<span class='notice'>You wrap the cables through the holes in the hazard vest.</span>")

		qdel(src)

/obj/item/improv/hazardvest/step2/use_tool(obj/item/I, mob/living/user, list/click_params)
	..()
	if(istype(I, /obj/item/stack/material/steel))
		var/obj/item/stack/material/steel/R = I
		var/obj/item/improv/hazardvest/step3/H = new /obj/item/improv/hazardvest/step3
		R.use(1)

		user.remove_from_mob(src)

		user.put_in_hands(H)
		to_chat(user, "<span class='notice'>You strap a sheet of metal to the hazard vest. Now to tighten it in.</span>")

		qdel(src)

/obj/item/improv/hazardvest/step3/use_tool(obj/item/I, mob/living/user, list/click_params)
	..()
	if(istype(I, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/R = I
		var/obj/item/clothing/suit/storage/hazardvest/armor/H = new /obj/item/clothing/suit/storage/hazardvest/armor
		R.use(1)

		user.remove_from_mob(src)

		user.put_in_hands(H)
		to_chat(user, "<span class='notice'>You tie the sheet of metal tightly to the hazard vest with the cable, forming a rudimentary armored vest.</span>")

		qdel(src)
