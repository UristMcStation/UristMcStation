//honks all the way down

/turf/simulated/mineral/ore
	var/mineralName = ""
	var/mineralAmt = 0
	var/spread = 0 //will the seam spread?
	var/spreadChance = 0 //the percentual chance of an ore spreading to the neighbouring tiles

/turf/simulated/mineral/ore/Initialize()
	. = ..()
	if (mineralName && mineralAmt && spread && spreadChance)
		for(var/dir in GLOB.cardinal)
			if(prob(spreadChance))
				var/turf/T = get_step(src, dir)
				if(istype(T, /turf/simulated/mineral/random))
					Spread(T)
	return

/turf/simulated/mineral/ore/proc/Spread(turf/T)
	new src.type(T)

/turf/simulated/mineral/ore/uranium
	name = "Uranium deposit"
	icon_state = "rock_Uranium"
	mineralName = "Uranium"
	mineralAmt = 5
	spreadChance = 10
	spread = 1

/turf/simulated/mineral/ore/iron
	name = "Iron deposit"
	icon_state = "rock_Iron"
	mineralName = "Iron"
	mineralAmt = 5
	spreadChance = 25
	spread = 1

/turf/simulated/mineral/ore/diamond
	name = "Diamond deposit"
	icon_state = "rock_Diamond"
	mineralName = "Diamond"
	mineralAmt = 5
	spreadChance = 10
	spread = 1

/turf/simulated/mineral/ore/gold
	name = "Gold deposit"
	icon_state = "rock_Gold"
	mineralName = "Gold"
	mineralAmt = 5
	spreadChance = 10
	spread = 1

/turf/simulated/mineral/ore/silver
	name = "Silver deposit"
	icon_state = "rock_Silver"
	mineralName = "Silver"
	mineralAmt = 5
	spreadChance = 10
	spread = 1

/turf/simulated/mineral/ore/plasma
	name = "Plasma deposit"
	icon_state = "rock_Plasma"
	mineralName = "Plasma"
	mineralAmt = 5
	spreadChance = 25
	spread = 1

/turf/simulated/mineral/ore/clown
	name = "Bananium deposit"
	icon_state = "rock_Clown"
	mineralName = "Clown"
	mineralAmt = 3
	spreadChance = 0
	spread = 0

//honk

/obj/item/ore/clown
	name = "Bananium ore"
	icon_state = "Clown ore"
	origin_tech = "materials=4"

//planet

/turf/simulated/floor/asteroid/planet
	initial_gas = list("oxygen" = MOLES_O2STANDARD, "nitrogen" = MOLES_N2STANDARD)
	temperature = 293.15

/turf/simulated/mineral/planet
	mined_turf = /turf/simulated/floor/asteroid/planet

/turf/simulated/mineral/random/planet
	mined_turf = /turf/simulated/floor/asteroid/planet

/turf/simulated/mineral/random/high_chance/planet
	mined_turf = /turf/simulated/floor/asteroid/planet

/turf/simulated/floor/asteroid/glloydplanet
	initial_gas = list(GAS_CO2 = MOLES_O2STANDARD, GAS_NITROGEN = MOLES_N2STANDARD, GAS_CO = 2, GAS_XENON = 8, GAS_SULFUR = 10, GAS_PHORON = 22) //just a shitty place to be in general
	temperature = 348.15 //75C

/turf/simulated/floor/plating/glloydplanet
	initial_gas = list(GAS_CO2 = MOLES_O2STANDARD, GAS_NITROGEN = MOLES_N2STANDARD, GAS_CO = 2, GAS_XENON = 8, GAS_SULFUR = 10, GAS_PHORON = 22) //just a shitty place to be in general
	temperature = 348.15 //75C