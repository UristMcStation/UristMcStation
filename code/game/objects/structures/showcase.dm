/obj/structure/showcase
	name = "showcase"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "showcase_1"
	desc = "A stand with the empty body of a cyborg bolted to it."
	density = 1
	anchored = 1
	unacidable = 1//temporary until I decide whether the borg can be removed. -veyveyr

/obj/structure/showcase/blob_hazard
	name = "Hyper Capacity Silicon Depolarization Quantum Relay"
	desc = "You're not sure what this does, but it does something, probably."
	icon_state = "relay"
	health = 100
	var/obj/machinery/button/alternate/biohazard/reset_button

/obj/structure/showcase/blob_hazard/Initialize()
	. = ..()
	var/area/A = loc
	reset_button = locate(/obj/machinery/button/alternate/biohazard) in A

/obj/structure/showcase/blob_hazard/take_damage(var/damage)
	health -= damage
	if(health < 0)
		reset_button.activate(null, TRUE)
		health = 100

/obj/structure/showcase/blob_hazard/attackby(var/obj/item/weapon/W, var/mob/user)
	if(isWelder(W))
		var/obj/item/weapon/weldingtool/WT = W
		to_chat(user, "<span class = 'notice'You begin to repair \the [src].</span>")
		if(do_after(user, 10 SECONDS))
			if(WT.remove_fuel(10))
				health += 25
				to_chat(user, "<span class = 'notice'You repair some damage on \the [src].</span>")
			else
				to_chat(user, "<span class = 'notice'You don't have enough welding fuel to repair this.</span>")
				return
		else
			to_chat(user, "<span class = 'notice'Stand still while repairing \the [src].</span>")
			return
	..()