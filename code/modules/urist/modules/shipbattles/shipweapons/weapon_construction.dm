/obj/structure/shipweapons
	var/shipid = null

/obj/structure/shipweapons/hardpoint
	name = "weapon hardpoint"
	desc = "A mounting for a powerful ship-to-ship weapon."
	icon = 'icons/urist/structures&machinery/64x64machinery.dmi'
	icon_state = "hardpoint"
	anchored = 1
	density = 0
	var/attached = FALSE

/obj/structure/shipweapons/hardpoint/nerva
	shipid = "nerva"

/obj/structure/shipweapons/incomplete_weapon
	name = "incomplete weapon"
	desc = "It's a ship-to-ship weapon assembly. Wrench it into a hardpoint to make it functional, or just chuck it out an airlock at an enemy vessel and see how far that gets you."
	icon = 'icons/urist/structures&machinery/64x64machinery.dmi'
	icon_state = "cannon_con"
	anchored = 0
	density = 1
	var/state = 0
	var/weapon_type = null

/obj/structure/shipweapons/incomplete_weapon/attackby(obj/item/W as obj, mob/living/user as mob)
	switch(state)

		if(0)
			var/turf/T = get_turf(src)
			if(isWrench(W) && locate(/obj/structure/shipweapons/hardpoint) in T)
				var/obj/structure/shipweapons/hardpoint/H = (locate(/obj/structure/shipweapons/hardpoint) in T)
				//qdel(H)
				if(!H.attached)
					H.attached = TRUE
					src.shipid = H.shipid
					playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
					to_chat(user, "You wrench the weapon into place on the hardpoint.")
					anchored = 1
					state = 1
					desc = "It's a ship-to-ship weapon assembly. It is missing external sheeting."
					update_icon()

		if(1)

			if(istype(W, /obj/item/stack/material) && W.get_material_name() == DEFAULT_WALL_MATERIAL)
				var/obj/item/stack/M = W
				if(M.use(2))
					to_chat(user, "<span class='notice'>You add some metal sheeting to the exterior frame.</span>")
					state = 2
					update_icon()
					desc = "It's a ship-to-ship weapon assembly. It has some loose external sheeting."
					return

			else if(isWrench(W))
				var/turf/T = get_turf(src)
				var/obj/structure/shipweapons/hardpoint/H = (locate(/obj/structure/shipweapons/hardpoint) in T)
				H.attached = FALSE
				playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
				to_chat(user, "You unattach the assembly from its place.")
				anchored = 0
				state = 0
				update_icon()
				desc = "It's a ship-to-ship weapon assembly. Wrench it into a hardpoint to make it functional, or just chuck it out an airlock at an enemy vessel and see how far that gets you."
				return

		if(2)

			if(isWelder(W))

				var/obj/item/weapon/weldingtool/F = W
				if(F.isOn())
					if(F.remove_fuel(0,user))
						playsound(src.loc, 'sound/items/Welder.ogg', 50, 1)
						if(do_after(user, 20, src))
							to_chat(user, "You weld the external sheeting securely into place.")
							state = 3
							update_icon()
							desc = "It's a ship-to-ship weapon assembly with secured external plating. It is missing wiring."
					return

			if(isCrowbar(W))
				playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)
				to_chat(user, "You pry off the external sheeting.")
				new /obj/item/stack/material/steel(get_turf(src), 2)
				desc = "It's a ship-to-ship weapon assembly. It is missing external sheeting."
				state = 1
				update_icon()
				return

		if(3)
			if(isCoil(W))
				var/obj/item/stack/cable_coil/C = W
				if(C.use(2))
					to_chat(user, "<span class='notice'>You add wires to the weapon assembly.</span>")
					state = 4
					update_icon()
					desc = "It's a ship-to-ship weapon assembly that is nearly complete. The wiring and external hatches need to be secured."
				else
					to_chat(user, "<span class='warning'>You need 2 coils of wire to wire the weapon assembly.</span>")
				return

			else if(isWelder(W))

				var/obj/item/weapon/weldingtool/F = W
				if(F.isOn())
					if(F.remove_fuel(0,user))
						playsound(src.loc, 'sound/items/Welder.ogg', 50, 1)
						if(do_after(user, 20, src))
							desc = "It's a ship-to-ship weapon assembly. It has some loose external sheeting."
							state = 2
							update_icon()
					return

		if(4)
			if(isScrewdriver(W))
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
				to_chat(user, "<span class='warning'>You secure the wires and screw down the external hatches: the weapon is ready to fire.</span>")
				var/obj/machinery/shipweapons/S = new weapon_type(get_turf(src))
				S.shipid = src.shipid
				qdel(src)

			else if(isWirecutter(W))

				new/obj/item/stack/cable_coil(get_turf(src), 2)
				playsound(src.loc, 'sound/items/Wirecutter.ogg', 50, 1)
				to_chat(user, "<span class='notice'>You cut the wires from the weapon assembly.</span>")
				desc = "It's a ship-to-ship weapon assembly with secured external plating. It is missing wiring."
				state = 3
				update_icon()
				return

/obj/structure/shipweapons/incomplete_weapon/update_icon()
	..()
	icon_state = "[initial(icon_state)][state]"

/obj/structure/shipweapons/incomplete_weapon/ion
	name = "ion cannon assembly"
	weapon_type = /obj/machinery/shipweapons/beam/ion

/obj/structure/shipweapons/incomplete_weapon/lightlaser
	name = "light laser cannon assembly"
	weapon_type = /obj/machinery/shipweapons/beam/lightlaser