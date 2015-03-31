/obj/item/scom/science //a generic holder for science shit
	name = "alien technology"

/obj/structure/scom/science //a generic holder for science shit
	name = "alien technology"
	var/scomtechlvl = 0
	var/beenharvested = 0
	var/scommoney = 0

/obj/structure/scom/science/attack_hand(mob/user as mob)
	if(beenharvested = 0)
		var/obj/item/scom/science/S = new/obj/item/scom/science

		S.scomtechlvl = scomtechlvl
		S.scommoney = scommoney
		beenharvested = 1

		user.put_in_hands(S)
		user << "<span class='notice'>You salvage from usable objects from the alien technology.</span>"
	else
		return
