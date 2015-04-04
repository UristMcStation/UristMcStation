/obj/item/scom/science //a generic holder for science shit
	name = "alien technology"
	icon = 'icons/obj/stock_parts.dmi'

/obj/item/scom/science/New()
	icon_state = pick("capacitor", "micro_laser", "micro_mani", "matter_bin", "scan_module")

/obj/structure/scom/science //a generic holder for science shit
	name = "alien technology"
	icon = 'icons/urist/turf/scomturfs.dmi'
	var/scomtechlvl = 0
	var/beenharvested = 0
	var/scommoney = 0

/obj/structure/scom/science/attack_hand(mob/user as mob)
	if(beenharvested == 0)
		var/obj/item/scom/science/S = new/obj/item/scom/science

		S.scomtechlvl = scomtechlvl
		S.scommoney = scommoney
		beenharvested = 1

		user.put_in_hands(S)
		user << "<span class='notice'>You salvage some usable objects from the alien technology.</span>"
	else if(beenharvested == 1)
		user << "<span class='notice'>You've already salvaged this alien technology!</span>"
		return

/obj/structure/scom/fuckitall
	name = "mothership central computer"
	icon = 'icons/urist/turf/scomturfs.dmi'
	icon_state = "9,8"
	var/fuckitall = 0

/obj/structure/scom/fuckitall/attack_hand(mob/user as mob)
	var/want = input("Start the self destruct countdown? You will have 3 minutes to escape.", "Your Choice", "Cancel") in list ("Cancel", "Yes")
	switch(want)
		if("Cancel")
			return
		if("Yes")
			spawn(1800)
			for(var/mob/living/M in /area/scom/mission)
				M.apply_damage(rand(1000,2000), BRUTE) //KILL THEM ALL
				M << ("\red The explosion tears you apart!")
			sploded = 1
