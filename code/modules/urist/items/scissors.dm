//All of the scissor stuff <-- TGameCo
/obj/item/weapon/scissors //DON'T USE THIS FOR THE GAME! THIS IS FOR ORGINIZATIONAL THINGS ONLY!!
	name = "Scissors"
	desc = "Those are scissors. Don't run with them!"
	icon = 'icons/urist/uristicons.dmi'
	icon_state = "scissor"
	item_state = "scissor"
	force = 5
	matter = list("metal" = 35)
	sharp = 1
	edge = 1
	w_class = 2
	urist_only = 1
	attack_verb = list("slices", "cuts", "stabs", "jabs")
	var/childpart = /obj/item/weapon/improvised/scissorknife //This is so any thing made is specified. It's helpful for things

	/*suicide_act(mob/user)
		viewers(user) << pick("\red <b>[user] is slitting \his wrists with the [src]! It looks like \he's trying to commit suicide.</b>", \
							"\red <b>[user] is slitting \his throat with the [src]! It looks like \he's trying to commit suicide.</b>")
		return (BRUTELOSS)*/

/obj/item/weapon/scissors/attackby(var/obj/item/I, mob/user as mob) //Seperation of the scissors
	if(istype(I, /obj/item/weapon/screwdriver))

		var/obj/item/weapon/improvised/scissorknife/N = new childpart
		var/obj/item/weapon/improvised/scissorknife/N2 = new childpart

		user.remove_from_mob(src)
		user.drop_from_inventory(src)

		user.put_in_hands(N)
		user.put_in_hands(N2)
		user << "<span class='notice'>You seperate the parts of the [src]</span>"

		qdel(src)
	..()

/obj/item/weapon/improvised/scissorsassembly //So you can put it together!
	name = "Scissor Assembly"
	desc = "Two parts of a scissor loosely combined"
	icon = 'icons/urist/uristicons.dmi'
	icon_state = "scissor"
	item_state = "scissor"
	matter = list("metal" = 35)
	force = 3
	edge = 1
	w_class = 2
	urist_only = 1
	attack_verb = list("slices", "cuts", "stabs", "jabs")
	var/parentscissor = /obj/item/weapon/scissors

/obj/item/weapon/improvised/scissorsassembly/barber
	icon_state = "bscissor"
	item_state = "bscissor"
	attack_verb = list("beautifully slices", "artistically cuts", "smoothly stabs", "quickly jabs")
	parentscissor = /obj/item/weapon/scissors/bscissors

/obj/item/weapon/improvised/scissorsassembly/attackby(var/obj/item/I, mob/user as mob) //Putting it together
	if(istype(I, /obj/item/weapon/screwdriver))

		var/obj/item/weapon/scissors/N = new parentscissor

		user.remove_from_mob(src)

		user.put_in_hands(N)
		user << "<span class='notice'>You tighten the screw on the screwdriver assembley</span>"

		qdel(src)
	..()

//Makes scissors cut hair, special thanks to Miauw and Xerux -Nien
/obj/item/weapon/scissors/bscissors/attack(mob/living/carbon/M as mob, mob/user as mob)
	if(user.a_intent != "help")
		..()
		return
	if(!(M in view(1))) //Adjacency test
		..()
		return
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		//see code/modules/mob/new_player/preferences.dm at approx line 545 for comments!
		//this is largely copypasted from there.
		//handle facial hair (if necessary)
		var/list/species_facial_hair = list()
		if(H.gender == MALE)
			if(H.species)
				for(var/i in facial_hair_styles_list)
					var/datum/sprite_accessory/facial_hair/tmp_facial = facial_hair_styles_list[i]
					if(H.species.name in tmp_facial.species_allowed)
						species_facial_hair += i
			else
				species_facial_hair = facial_hair_styles_list
		var/f_new_style = input(user, "Select a facial hair style", "Grooming")  as null|anything in species_facial_hair
		//handle normal hair
		var/list/species_hair = list()
		if(H.species)
			for(var/i in hair_styles_list)
				var/datum/sprite_accessory/hair/tmp_hair = hair_styles_list[i]
				if(H.species.name in tmp_hair.species_allowed)
					species_hair += i
		else
			species_hair = hair_styles_list
		var/h_new_style = input(user, "Select a hair style", "Grooming")  as null|anything in species_hair
		user.visible_message("[user] starts cutting [M]'s hair!", "You start cutting [M]'s hair!", "You hear the sound of scissors.") //arguments for this are: 1. what others see 2. what the user sees 3. what blind people hear. --Fixed grammar, (TGameCo)
		if(do_after(user, 50)) //this is the part that adds a delay. delay is in deciseconds. --Made it 5 seconds, because hair isn't cut in one second in real life, and I want at least a little bit longer time, (TGameCo)
			if(!(M in view(1))) //Adjacency test
				user.visible_message("[user] stops cutting [M]'s hair.", "You stop cutting [M]'s hair.", "The sounds of scissors stop")
				return
			if(f_new_style)
				H.f_style = f_new_style
			if(h_new_style)
				H.h_style = h_new_style

		H.update_hair()
		user.visible_message("[user] finishes cutting [M]'s hair!")

//Subests of the scissors
/obj/item/weapon/scissors/bscissors //Scissors used for barbering
	name = "Barber's Scissors"
	desc = "A pair of scissors used by the barber."
	icon_state = "bscissor"
	item_state = "bscissor"
	attack_verb = list("beautifully slices", "artistically cuts", "smoothly stabs", "quickly jabs")
	childpart = /obj/item/weapon/improvised/scissorknife/barber

/obj/item/weapon/scissors/pscissors //Scissors used for papercrafts
	desc = "A pair of scissors used for arts and crafts"