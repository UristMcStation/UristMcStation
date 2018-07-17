/obj/machinery/computer/combatcomputer
	name = "weapons control computer"
	desc = "the control centre for the ship's weapons systems."
	anchored = 1
	var/shields = 0 //update this with the actual shields
	var/list/linkedweapons = list() //put the weapons in here on their init
	var/shipid = null
	var/target = null

/obj/machinery/computer/combatcomputer/nerva //different def just in case we have multiple ships that do combat. although, i think i might keep the cargo ship noncombat, fluff it as it being too small, slips right by the enemies. i dunno
	shipid = "nerva"