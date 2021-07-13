/obj/structure/scrap
	name = "scrap pile"
	desc = "Someone met an unfortunate fate. Better see what's left."
	anchored = 1
	opacity = 0
	density = 0
	icon_state = "small"
	icon = 'icons/urist/structures&machinery/scrap/base.dmi'
	var/obj/item/weapon/storage/internal/updating/loot	//the visible loot
	var/loot_min = 2
	var/loot_max = 6
	var/list/loot_list = list(
		/obj/item/stack/rods/scrap,
		/obj/item/vehicle_part/tire,
		/obj/item/stack/material/plastic/scrap,
		/obj/item/stack/material/steel/scrap,
		/obj/item/stack/material/glass/scrap,
		/obj/item/stack/material/plasteel/scrap,
		/obj/item/weapon/material/shard,
		/obj/item/weapon/material/shard/phoron,
		/obj/item/weapon/material/shard/shrapnel,
		/obj/item/pipe,
		/obj/item/stack/material/r_wood/scrap,
		/obj/item/stack/cable_coil/scrap,
		/obj/item/stack/material/wood/scrap,
		/obj/item/trash/tray,
		/obj/item/weapon/cell/crap/empty,
		/obj/item/weapon/cell/super/empty,
		/obj/item/weapon/crowbar,
		/obj/item/weapon/stock_parts/console_screen,
		/obj/item/weapon/stock_parts/capacitor,
		/obj/item/weapon/stock_parts/matter_bin,
		/obj/item/weapon/stock_parts/manipulator,
		/obj/item/weapon/stool,
		/obj/item/weapon/tape_roll,
		/obj/item/weapon/table_parts,
		/obj/item/frame/air_alarm,
		/obj/item/frame/apc,
		/obj/item/frame/light,
		)

	var/parts_icon = 'icons/urist/structures&machinery/scrap/trash.dmi'
	var/base_min = 3	//min and max number of random pieces of base icon
	var/base_max = 7
	var/base_spread = 8	//limits on pixel offsets of base pieces

/obj/structure/scrap/New()
	var/amt = rand(loot_min, loot_max)
	for(var/x = 1 to amt)
		var/loot_path = pick(loot_list)
		new loot_path(src)
	loot = new(src)
	loot.master_item = src
	loot.max_w_class = 5
	loot.max_storage_space = loot_min*4
	shuffle_loot()
	update_icon(1)
	..()

/obj/structure/scrap/Destroy()
	QDEL_NULL(loot)
	. = ..()

/obj/structure/scrap/proc/shuffle_loot()
	if(loot.atom_flags & ATOM_FLAG_INITIALIZED)
		loot.close_all()
	for(var/A in loot)
		loot.remove_from_storage(A,src)
	if(contents.len)
		contents = shuffle(contents)
		var/num = rand(1,loot_min)
		var/size = 0
		for(var/obj/item/O in contents)
			if(O == loot)
				continue
			if(num == 0)
				break
			if(O.get_storage_cost() > loot.max_storage_space)
				break
			size += O.get_storage_cost()
			O.forceMove(loot)
			num--
	update_icon()

/obj/structure/scrap/proc/randomize_image(var/image/I)
	I.pixel_x = rand(-base_spread,base_spread)
	I.pixel_y = rand(-base_spread,base_spread)
	var/matrix/M = matrix()
	M.Turn(pick(0,90.180,270))
	I.transform = M
	return I

/obj/structure/scrap/update_icon(var/rebuild_base=0)
	if(rebuild_base)
		overlays.Cut()
		var/num = rand(base_min,base_max)
		for(var/i=1 to num)
			var/image/I = image(parts_icon,pick(icon_states(parts_icon)))
			overlays |= randomize_image(I)

	underlays.Cut()
	for(var/obj/O in loot.contents)
		var/image/I = image(O.icon,O.icon_state)
		I.color = O.color
		underlays |= randomize_image(I)

/obj/structure/scrap/attack_hand(mob/user)
	loot.open(user)
	..(user)

/obj/structure/scrap/MouseDrop(obj/over_object)
	..(over_object)

/obj/structure/scrap/attackby(obj/item/W, mob/user)
	if(istype(W,/obj/item/weapon/shovel))
		var/list/ways = list("pokes around", "digs through", "rummages through", "goes through","picks through")
		visible_message("<span class='notice'>\The [user] [pick(ways)] \the [src].</span>")
		shuffle_loot()
		if(!(loot.contents.len || contents.len > 1))
			to_chat(user, "<span class='notice'>There doesn't seem to be anything of interest left in \the [src]...</span>")

	if(istype(W,/obj/item/weapon/weldingtool))
		if(!(loot.contents.len || contents.len > 1))
			var/obj/item/weapon/weldingtool/WT = W
			if (WT.remove_fuel(0,user))
				playsound(src.loc, 'sound/items/Welder2.ogg', 50, 1)
				user.visible_message("[user.name] starts to disassemble the scrap pile.", \
					"You start to disassemble the scrap pile.", \
					"You hear welding")
				if (do_after(user,30,src))
					if(!src || !WT.isOn()) return
					new /obj/item/stack/material/steel(src.loc)
					new /obj/item/stack/material/plastic(src.loc)
					new /obj/item/weapon/material/shard(src.loc)
					qdel(src)
					to_chat(user, "You disassemble the scrap pile.")
			else
				to_chat(user, "<span class='warning'>You need more welding fuel to complete this task.</span>")
		else
			to_chat(user, "<span class='warning'>There's too much stuff inside the scrap pile to disassemble it! Try digging it out with a shovel.</span>")
	..()

/obj/structure/scrap/vehicle
	name = "debris pile"
	parts_icon = 'icons/urist/structures&machinery/scrap/vehicle.dmi'
	loot_list = list(
		/obj/item/vehicle_part/battery,
		/obj/item/vehicle_part/tire,
		/obj/item/vehicle_part/transmission,
		/obj/item/stack/rods/scrap,
		/obj/item/stack/material/plastic/scrap,
		/obj/item/stack/material/steel/scrap,
		/obj/item/pipe,
		/obj/item/weapon/material/shard,
		/obj/item/weapon/cell/crap/empty
		)

/obj/structure/scrap/vehicle/New()
	if(prob(25))
		new /obj/structure/vehicle_frame/motorcycle(src.loc)
	..()

/obj/structure/scrap/large
	name = "large scrap pile"
	opacity = 1
	density = 1
	icon_state = "big"
	loot_min = 7
	loot_max = 15

	base_min = 9
	base_max = 15
	base_spread = 16

/obj/structure/scrap/random
	var/scrap_list = list(
		/obj/structure/scrap,
		/obj/structure/scrap/large
		)

/obj/structure/scrap/random/Initialize()
	. = ..()
	var/A = pick(scrap_list)
	new A(src.loc)
	return INITIALIZE_HINT_QDEL

/obj/item/weapon/storage/internal/updating/update_icon()
	if(master_item)
		master_item.update_icon()

/obj/item/stack/rods/scrap/New(var/newloc)
	..(newloc, rand(1,8))

/obj/item/stack/material/plastic/scrap/New(var/newloc)
	..(newloc, rand(1,10))

/obj/item/stack/material/steel/scrap/New(var/newloc)
	..(newloc, rand(1,10))

/obj/item/stack/material/glass/scrap/New(var/newloc)
	..(newloc, rand(1,10))

/obj/item/stack/material/plasteel/scrap/New(var/newloc)
	..(newloc, rand(1,3))

/obj/item/stack/material/wood/scrap/New(var/newloc)
	..(newloc, rand(1,6))

/obj/item/stack/cable_coil/scrap/New()
	amount = rand(1,6)

/obj/item/stack/material/r_wood/scrap/New()
	amount = rand(1,8)

/obj/item/vehicle_part
	name = "vehicle part"
	desc = "A part from a vehicle."
	icon_state = "engine"
	icon = 'icons/urist/items/vehicle_parts.dmi'
	w_class = 3

/obj/item/vehicle_part/random/Initialize()
	. = ..()
	var/part = pick(/obj/item/vehicle_part/battery, /obj/item/vehicle_part/transmission, /obj/item/weapon/engine/thermal, /obj/item/weapon/engine/electric, /obj/item/vehicle_part/tire)
	new part(src.loc)
	return INITIALIZE_HINT_QDEL

/obj/item/vehicle_part/battery
	name = "battery"
	desc = "A battery for a vehicle."
	icon_state = "plating"

/obj/item/vehicle_part/transmission
	name = "transmission"
	desc = "The transmission for a vehicle."
	icon_state = "Transmission"

/obj/item/vehicle_part/transmission/New()
	..()
	if(prob(50))
		icon_state = "Transmission2"

/obj/item/vehicle_part/tire
	name = "tire"
	desc = "A tire for a vehicle."
	icon_state = "tire"
	w_class = 4
