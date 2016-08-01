
//Added by TGameCo
//My first thing in ss13, based on the dresser we used in /tg/
//Note: The basics took me ~1 hour. The attack_hand proc took me the rest of the day...

/obj/structure/dresser/
	name = "Dresser"
	desc = "A wooden closet full of undergarments."
	icon = 'icons/urist/structures&machinery/structures.dmi'
	icon_state = "dresser"
	density = 1
	anchored = 1

//Do the thing!


/*/obj/structure/dresser/attack_hand(mob/user as mob)
	src.add_fingerprint(user)
	var/mob/living/carbon/human/H = user
	if(!ishuman(user) || (H.species && !(H.species.flags & HAS_UNDERWEAR)))
		user << "<span class='warning'>Sadly there's nothing in here for you to wear.</span>"
		return 0

	var/utype = alert("Which section do you want to pick from?",,"Male underwear", "Female underwear", "Undershirts")
	var/list/selection
	switch(utype)
		if("Underwear")
			selection = global_underwear
		if("Undershirts")
			selection = undershirt_t
	var/pick = input("Select the style") as null|anything in selection
	if(pick)
		if(get_dist(src,user) > 1)
			return
		if(utype == "Undershirts")
			H.undershirt = undershirt_t[pick]
		else
			H.underwear = selection[pick]
		H.update_body(1)

	return 1*/ //undies_wardrobe does the same thing natively

/*/obj/structure/dresser/attack_hand(mob/user as mob)

	if(!Adjacent(user)) //No magic flying underwear
		return

	if(!ishuman(user))
		return

	var/mob/living/carbon/human/H = user //Easier defines
	var/new_undies_num //Local variables, for easy reference
	var/new_undershirt_num
		//Checks gender
	if(H.gender == MALE) //Male underwear for males
		//H << "Is male"
		var/new_undies = input(user, "Choose your underwear", "Changing") as null|anything in underwear_m //This part converts the string into the number accepted by the update_body proc
		for(var/i, i <= underwear_m.len, i++)
			if(new_undies == underwear_m[i])
				new_undies_num = i
				break
	else if (H.gender == FEMALE) //Female underwear for females
		var/new_undies = input(user, "Choose your underwear", "Changing") as null|anything in underwear_f //This part converts the string into the number accepted by the update_body proc
		for(var/i, i <= underwear_f.len, i++)
			if(new_undies == underwear_f[i])
				new_undies_num = i
				//H << i
				break
	else //Return if the user dosn't have a gender...
		return
	var/new_undershirt = input(user, "Choose your Undershirt", "Changing") as null|anything in undershirt_t //This part converts the string into the number accepted by the update_body proc
	for(var/i, i <= undershirt_t.len, i++)
		if(new_undershirt == undershirt_t[i])
			new_undershirt_num = i
			//H << i <-- Old debug code
			break
	if(!Adjacent(user)) //Prevents tele-wearing
		return
	if(new_undies_num) // Checking if the user chose underwear
		H.underwear = new_undies_num
	if(new_undershirt_num) // Checking if the user chose an undershirt
		H.undershirt = new_undershirt_num
	add_fingerprint(H) // Addind stuff for detectives
	H.update_body() // Putting on the underclothes
	//H << "Done" <--Debug code
*/
/obj/structure/dresser/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/wrench))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		var/obj/item/stack/material/wood/S = new /obj/item/stack/material/wood(src.loc)
		S.amount = 5
		qdel(src)
	else
		..()