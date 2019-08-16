/obj/machinery/computer/combatcomputer
	name = "weapons control computer"
	desc = "the control centre for the ship's weapons systems."
	anchored = 1
	var/shields = 0 //update this with the actual shields
	var/list/linkedweapons = list() //put the weapons in here on their init
	var/shipid = null
	var/target = null
	var/obj/effect/overmap/ship/combat/homeship

/obj/machinery/computer/combatcomputer/attack_hand(user as mob)
	if(..(user))
		return
	if(!allowed(user))
		to_chat(user, "<span class='warning'>Access Denied.</span>")
		return 1

	//quick and dirty hack below, make a real UI for this

	var/list/selectable = list()
	for(var/obj/machinery/shipweapons/SW in linkedweapons)
		if(SW.canfire)
			selectable |= SW

	if(target && homeship.incombat)
		var/obj/machinery/shipweapons/SW = input("Which charged weapon do you wish to fire?") as null|anything in selectable

		if(!istype(SW))
	//		to_chat(usr, "<font color='blue'><b>You don't do anything.</b></font>")
			return

		if(SW.charged && !SW.firing)
			SW.Fire()
			to_chat(user, "<span class='warning'>You fire the [SW.name].</span>")

		else
			to_chat(user, "<span class='warning'>The [SW.name] cannot be fired right now.</span>")

	else
		to_chat(user, "<span class='warning'>The ship is not in combat.</span>")

//	user.set_machine(src)
//	interact(user)
//	ui_interact(user)

/obj/machinery/computer/combatcomputer/Topic(href, href_list)
	if(..())
		return

//	user.set_machine(src)

/obj/machinery/computer/combatcomputer/nerva //different def just in case we have multiple ships that do combat. although, i think i might keep the cargo ship noncombat, fluff it as it being too small, slips right by the enemies. i dunno
	name = "ICS Nerva Combat Computer"
	shipid = "nerva"