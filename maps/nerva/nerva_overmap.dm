/obj/effect/overmap/ship/combat
	var/list/hostile_factions = list() //who hates us rn
	var/canfight = 0 //will this ship engage with the combat system? Why is this zero? well, if the ship moves, we're part of the combat system. this is to compensate for lowpop rounds where noone ever moves the ship, to avoid them getting fucked by chance
	var/incombat = 0 //are we fighting
	var/shipid = null

/obj/effect/overmap/ship/combat/nerva
	name = "ICS Nerva"
	shipid = "nerva"
	vessel_mass = 200 //bigger than wyrm, smaller than torch
	fore_dir = EAST
	start_x = 6
	start_y = 7

/*	generic_waypoints = list(
		"wyrm_prim_fore",
		"wyrm_prim_star",
		"wyrm_prim_port",
		"wyrm_prim_aft",
		"wyrm_sub_fore",
		"wyrm_sub_star",
		"wyrm_sub_port",
		"wyrm_sub_aft"
	)
	restricted_waypoints = list(
		"Hatchling" = list("wyrm_docked_hatchling"),
		"Rescue Pod" = list("wyrm_docked_rescue")
	)*/

	canfight = 1
	hostile_factions = list(
		"pirates",
		"xenos",
		"hostile"
	)

/obj/effect/overmap/ship/combat/Crossed(O as mob)
	..()
	if(!src.incombat)


		if(istype(O, /mob/living/simple_animal/hostile/overmapship))
			incombat = 1 //we're in combat now, so let's cancel out momentum
			var/mob/living/simple_animal/hostile/overmapship/L = O
			//let's cancel the momentum of the mob
//			L.combat


			for(var/obj/machinery/computer/combatcomputer/CC in SSmachines.machinery)//now we assign our targets to the combat computer (to show data)
				if(CC.shipid == src.shipid)
					CC.target = L
			for(var/obj/machinery/shipweapons/SW in SSmachines.machinery) //and to the weapons, so they do damage
				if(SW.shipid == src.shipid)
					SW.target = L

			return

