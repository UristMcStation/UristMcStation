/obj/structure/closet/crate
	name = "crate"
	desc = "A rectangular steel crate."
	closet_appearance = /singleton/closet_appearance/crate
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_CLIMBABLE
	obj_flags = OBJ_FLAG_CAN_TABLE
	setup = 0
	storage_types = CLOSET_STORAGE_ITEMS
	var/points_per_crate = 5
	var/rigged = 0

/obj/structure/closet/crate/open()
	if((atom_flags & ATOM_FLAG_OPEN_CONTAINER) && !opened && can_open())
		object_shaken()
	. = ..()
	if(.)
		if(rigged)
			visible_message(SPAN_DANGER("There are wires attached to the lid of [src]..."))
			for(var/obj/item/device/assembly_holder/H in src)
				H.process_activation(usr)
			for(var/obj/item/device/assembly/A in src)
				A.activate()

/obj/structure/closet/crate/examine(mob/user)
	. = ..()
	if(rigged && opened)
		var/list/devices = list()
		for(var/obj/item/device/assembly_holder/H in src)
			devices += H
		for(var/obj/item/device/assembly/A in src)
			devices += A
		to_chat(user,"There are some wires attached to the lid, connected to [english_list(devices)].")


/obj/structure/closet/crate/use_tool(obj/item/tool, mob/user, list/click_params)
	// Below interactions only apply if the crate is closed
	if (opened)
		return ..()

	// Assembly - Attach to rigged crate
	if (istype(tool, /obj/item/device/assembly_holder) || istype(tool, /obj/item/device/assembly))
		if (!rigged)
			USE_FEEDBACK_FAILURE("\The [src] needs to be rigged with wiring before you can attach \the [tool].")
			return TRUE
		if (!user.unEquip(tool, src))
			FEEDBACK_UNEQUIP_FAILURE(user, tool)
			return TRUE
		user.visible_message(
			SPAN_NOTICE("\The [user] attaches \a [tool] to \the [src]."),
			SPAN_NOTICE("You attach \the [tool] to \the [src].")
		)
		return TRUE

	// Cable Coil - Rig crate
	if (isCoil(tool))
		if (rigged)
			USE_FEEDBACK_FAILURE("\The [src] is already rigged.")
			return TRUE
		var/obj/item/stack/cable_coil/cable = tool
		if (!cable.use(1))
			USE_FEEDBACK_STACK_NOT_ENOUGH(cable, 1, "to rig \the [src].")
			return TRUE
		rigged = TRUE
		user.visible_message(
			SPAN_NOTICE("\The [user] adds some wiring to \the [src] with [cable.get_vague_name(FALSE)]."),
			SPAN_NOTICE("You rig \the [src] with [cable.get_exact_name(1)].")
		)
		return TRUE

	// Wirecutters - Remove wiring
	if (isWirecutter(tool))
		if (!rigged)
			USE_FEEDBACK_FAILURE("\The [src] has no wiring to cut.")
			return TRUE
		rigged = FALSE
		new /obj/item/stack/cable_coil(loc, 1)
		playsound(src, 'sound/items/Wirecutter.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] cuts \the [src]'s wiring with \a [tool]."),
			SPAN_NOTICE("You cuts \the [src]'s wiring with \the [tool].")
		)
		return TRUE

	return ..()


/obj/structure/closet/crate/secure
	desc = "A secure crate."
	name = "secure crate"
	closet_appearance = /singleton/closet_appearance/crate/secure
	setup = CLOSET_HAS_LOCK
	locked = TRUE
	health_max = 200
	health_min_damage = 5

/obj/structure/closet/crate/secure/Initialize()
	. = ..()
	update_icon()

/obj/structure/closet/crate/plastic
	name = "plastic crate"
	desc = "A rectangular plastic crate."
	points_per_crate = 1
	closet_appearance = /singleton/closet_appearance/crate/plastic
	material = MATERIAL_PLASTIC

/obj/structure/closet/crate/internals
	name = "internals crate"
	desc = "A internals crate."

/obj/structure/closet/crate/internals/fuel
	name = "fuel tank crate"
	desc = "A fuel tank crate."

/obj/structure/closet/crate/internals/fuel/WillContain()
	return list(/obj/item/tank/hydrogen = 4)

/obj/structure/closet/crate/trashcart
	name = "trash cart"
	desc = "A heavy, metal trashcart with wheels."
	closet_appearance = /singleton/closet_appearance/cart/trash

/obj/structure/closet/crate/medical
	name = "medical crate"
	desc = "A medical crate."
	closet_appearance = /singleton/closet_appearance/crate/medical

/obj/structure/closet/crate/rcd
	name = "\improper RCD crate"
	desc = "A crate with rapid construction device."

/obj/structure/closet/crate/rcd/WillContain()
	return list(
		/obj/item/rcd_ammo = 3,
		/obj/item/rcd
	)

/obj/structure/closet/crate/solar
	name = "solar pack crate"

/obj/structure/closet/crate/solar/WillContain()
	return list(
		/obj/item/solar_assembly = 14,
		/obj/item/stock_parts/circuitboard/solar_control,
		/obj/item/tracker_electronics,
		/obj/item/paper/solar
	)

/obj/structure/closet/crate/solar_assembly
	name = "solar assembly crate"

/obj/structure/closet/crate/solar_assembly/WillContain()
	return list(/obj/item/solar_assembly = 16)

/obj/structure/closet/crate/freezer
	name = "freezer"
	desc = "A freezer."
	temperature = -16 CELSIUS
	closet_appearance = /singleton/closet_appearance/crate/freezer

	var/target_temp = T0C - 40
	var/cooling_power = 40

/obj/structure/closet/crate/freezer/return_air()
	var/datum/gas_mixture/gas = (..())
	if(!gas)	return null
	var/datum/gas_mixture/newgas = new/datum/gas_mixture()
	newgas.copy_from(gas)
	if(newgas.temperature <= target_temp)	return

	if((newgas.temperature - cooling_power) > target_temp)
		newgas.temperature -= cooling_power
	else
		newgas.temperature = target_temp
	return newgas

/obj/structure/closet/crate/freezer/ProcessAtomTemperature()
	return PROCESS_KILL

/obj/structure/closet/crate/freezer/rations //For use in the escape shuttle
	name = "emergency rations"
	desc = "A crate of emergency rations."

/obj/structure/closet/crate/freezer/rations/WillContain()
	return list(
		/obj/random/mre = 6,
		/obj/item/storage/mre/menu9,
		/obj/item/storage/mre/menu10,
		/obj/item/reagent_containers/food/drinks/cans/waterbottle = 8
	)

/obj/structure/closet/crate/freezer/meat
	name = "meat crate"
	desc = "A crate of meat."

/obj/structure/closet/crate/freezer/meat/WillContain()
	return list(
		/obj/item/reagent_containers/food/snacks/meat/beef = 4,
		/obj/item/reagent_containers/food/snacks/meat/syntiflesh = 4,
		/obj/random/fish = 8
	)

/obj/structure/closet/crate/bin
	name = "large bin"
	desc = "A large bin."

/obj/structure/closet/crate/radiation
	name = "radioactive crate"
	desc = "A leadlined crate with a radiation sign on it."
	closet_appearance = /singleton/closet_appearance/crate/radiation

/obj/structure/closet/crate/radiation_gear
	name = "radioactive gear crate"
	desc = "A crate with a radiation sign on it."
	closet_appearance = /singleton/closet_appearance/crate/radiation

/obj/structure/closet/crate/radiation_gear/WillContain()
	return list(/obj/item/clothing/suit/radiation = 8, /obj/item/clothing/head/radiation = 8)

/obj/structure/closet/crate/secure/weapon
	name = "weapons crate"
	desc = "A secure weapons crate."
	closet_appearance = /singleton/closet_appearance/crate/secure/weapon

/obj/structure/closet/crate/secure/phoron
	name = "phoron crate"
	desc = "A secure phoron crate."
	closet_appearance = /singleton/closet_appearance/crate/secure/hazard

/obj/structure/closet/crate/secure/shuttle
	name = "storage compartment"
	desc = "A secure storage compartment bolted to the floor, to secure loose objects on Zero-G flights."
	anchored = TRUE
	closet_appearance = /singleton/closet_appearance/crate/secure/shuttle

/obj/structure/closet/crate/secure/gear
	name = "gear crate"
	desc = "A secure gear crate."
	closet_appearance = /singleton/closet_appearance/crate/secure/weapon

/obj/structure/closet/crate/secure/hydrosec
	name = "secure hydroponics crate"
	desc = "A crate with a lock on it, painted in the scheme of botany and botanists."
	closet_appearance = /singleton/closet_appearance/crate/secure/hydroponics

/obj/structure/closet/crate/large
	name = "large crate"
	desc = "A hefty metal crate."
	storage_capacity = 2 * MOB_LARGE
	storage_types = CLOSET_STORAGE_ITEMS|CLOSET_STORAGE_STRUCTURES
	closet_appearance = /singleton/closet_appearance/large_crate

/obj/structure/closet/crate/large/hydroponics
	closet_appearance = /singleton/closet_appearance/large_crate/hydroponics

/obj/structure/closet/crate/secure/large
	name = "large crate"
	desc = "A hefty metal crate with an electronic locking system."
	closet_appearance = /singleton/closet_appearance/large_crate/secure

	storage_capacity = 2 * MOB_LARGE
	storage_types = CLOSET_STORAGE_ITEMS|CLOSET_STORAGE_STRUCTURES

/obj/structure/closet/crate/secure/large/phoron
	closet_appearance = /singleton/closet_appearance/large_crate/secure/hazard

//fluff variant
/obj/structure/closet/crate/secure/large/reinforced
	desc = "A hefty, reinforced metal crate with an electronic locking system."

/obj/structure/closet/crate/hydroponics
	name = "hydroponics crate"
	desc = "All you need to destroy those pesky weeds and pests."
	closet_appearance = /singleton/closet_appearance/crate/hydroponics

/obj/structure/closet/crate/hydroponics/prespawned/WillContain()
	return list(
		/obj/item/reagent_containers/spray/plantbgone = 2,
		/obj/item/material/minihoe = 2,
		/obj/item/storage/plants = 2,
		/obj/item/material/hatchet = 2,
		/obj/item/wirecutters/clippers = 2,
		/obj/item/device/scanner/plant = 2
	)

/obj/structure/closet/crate/secure/biohazard
	name = "biohazard cart"
	desc = "A heavy cart with extensive sealing. You shouldn't eat things you find in it."
	open_sound = 'sound/items/Deconstruct.ogg'
	close_sound = 'sound/items/Deconstruct.ogg'
	req_access = list(access_xenobiology)
	closet_appearance = /singleton/closet_appearance/cart/biohazard
	storage_capacity = 2 * MOB_LARGE
	storage_types = CLOSET_STORAGE_ITEMS|CLOSET_STORAGE_MOBS|CLOSET_STORAGE_STRUCTURES

/obj/structure/closet/crate/secure/biohazard/blanks/WillContain()
	return list(/obj/structure/closet/body_bag/cryobag/blank)

/obj/structure/closet/crate/secure/biohazard/blanks/can_close()
	for(var/obj/structure/closet/closet in get_turf(src))
		if(closet != src && !(istype(closet, /obj/structure/closet/body_bag/cryobag)))
			return 0
	return 1

/obj/structure/closet/crate/secure/biohazard/alt
	name = "biowaste disposal cart"
	desc = "A heavy cart used for organ disposal with markings indicating the things inside are probably gross."
	req_access = list(access_surgery)
	closet_appearance = /singleton/closet_appearance/cart/biohazard/alt

/obj/structure/closet/crate/paper_refill
	name = "paper refill crate"
	desc = "A rectangular plastic crate, filled up with blank papers for refilling bins and printers. A bureaucrat's favorite."
	material = MATERIAL_PLASTIC

/obj/structure/closet/crate/paper_refill/WillContain()
	return list(/obj/item/paper = 30)

/obj/structure/closet/crate/uranium
	name = "fissibles crate"
	desc = "A crate with a radiation sign on it."
	closet_appearance = /singleton/closet_appearance/crate/radiation

/obj/structure/closet/crate/uranium/WillContain()
	return list(/obj/item/stack/material/uranium/ten = 5)

///Base ninja equipment
/obj/structure/closet/crate/ninja
	name = "ninja equipment crate"
	desc = "An ominous equipment crate."
	closet_appearance = /singleton/closet_appearance/crate/secure/weapon

/obj/structure/closet/crate/ninja/WillContain()
	return list(
		/obj/item/rig/light/ninja,
		/obj/item/material/sword/katana,
		/obj/item/storage/box/syndie_kit/silenced
	)

///Ninja equipment loadouts. Overwritten in torch/structures/closets.dm because of away/example check evils
/obj/structure/closet/crate/ninja/sol
	name = "sol equipment crate"
	desc = "A tactical equipment crate."

/obj/structure/closet/crate/ninja/sol/WillContain()
	return list(
		/obj/item/rig/light/ninja/sol
	)

/obj/structure/closet/crate/ninja/gcc
	name = "gcc equipment crate"
	desc = "A heavy equipment crate."

/obj/structure/closet/crate/ninja/gcc/WillContain()
	return list(
		/obj/item/rig/light/ninja/gcc
	)

/obj/structure/closet/crate/ninja/corpo
	name = "corporate equipment crate"
	desc = "A patented equipment crate."

/obj/structure/closet/crate/ninja/corpo/WillContain()
	return list(
		/obj/item/rig/light/ninja/corpo
	)

/obj/structure/closet/crate/ninja/merc
	name = "mercenary equipment crate"
	desc = "A traitorous equipment crate."

/obj/structure/closet/crate/ninja/merc/WillContain()
	return list(
		/obj/item/rig/merc/ninja
	)
