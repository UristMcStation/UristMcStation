//////////////////////////////////////////
//		Arts and crafts system			//
//				TGameCo					//
//////////////////////////////////////////

//Scissor was moved to
//code/modules/urist/items/scissors


//Papercrafts definition
/obj/item/papercrafts
	w_class = 1
	item_icons = DEF_URIST_INHANDS
	icon = 'icons/urist/items/papercrafts.dmi'

/obj/item/papercrafts/proc/fold(obj/item/papercrafts/N, var/foldText, mob/user as mob) //So i don't have to write this over and over again
	user.remove_from_mob(src)
	user.put_in_hands(N)
	to_chat(user, foldText)
	qdel(src)
	return

/obj/item/papercrafts/square
	name = "Paper Square"
	icon_state = "paperSquare"
	item_state = "paper"

//What happens on a paper square
/obj/item/papercrafts/square/attack_self(mob/user as mob)
	var/want = input("Choose what you want to make", "Your Choice", "Cancel") in list ("Cancel", "Paper Swan", "Paper Plane", "Paper Box", "Paper Shuriken", "Paper Mask", "Paper Flower")
	switch(want)
		if("Cancel")
			return
		if("Paper Swan")
			var/obj/item/papercrafts/oragami/swan/N = new /obj/item/papercrafts/oragami/swan
			fold(N, "<span class='alert'>You fold the square into a swan.</span>", user)
		if("Paper Plane")
			var/obj/item/papercrafts/airplane/N = new /obj/item/papercrafts/airplane
			fold(N, "<span class='alert'>You fold the square into a paper airplane</span>", user)
		if("Paper Box")
			var/obj/item/storage/box/papercrafts/N = new /obj/item/storage/box/papercrafts
			fold(N, "<span class='alert'>You fold the square into a box</span>", user)
		if("Paper Shuriken")
			var/obj/item/papercrafts/oragami/shuriken/N = new /obj/item/papercrafts/oragami/shuriken
			fold(N, "<span class='alert'>You fold the square into a shuriken</span>", user)
		if("Paper Mask")
			var/obj/item/clothing/glasses/paper/N = new /obj/item/clothing/glasses/paper
			fold(N, "<span class='alert'>You fold the paper into a mask</span>", user)
		if("Paper Flower")
			var/obj/item/clothing/mask/flower/N = new /obj/item/clothing/mask/flower
			fold(N, "<span class='alert'>You fold the paper into a flower</span>", user)
		else
			return

//Oragami
/obj/item/papercrafts/oragami
	name = "Oragami"
	desc = "A Piece of Oragami"
	var/has_animate = 0 //If the thing has animations
	var/animated_state = "" //The animated icon to display to the person
	var/animated_message = "" //The animated message to display to the person

//Helper
/obj/item/papercrafts/oragami/attack_self(mob/user as mob)

	if(!ishuman(user)) //I don't want dogs or monkeys using the oragami
		return

	if(has_animate == 1) //If it has an animation
		flick(animated_state, src)  // I JUST FOUND THIS PROC AND I AM HAPPY !!!!1!!!
		playsound(src.loc, 'sound/effects/pageturn2.ogg', 50, 1) //Plays the paper shuffling sound
		to_chat(user, animated_message) //Send the animated message
	else
		return

//Paper Swan...
/obj/item/papercrafts/oragami/swan
	name = "paper swan"
	desc = "A Paper Swan. Honk."
	icon_state = "swan"
	item_state = "swan"
	has_animate = 1
	animated_state = "swan_move"
	animated_message = "You pull the swan's head, moving the wings."

//Paper Airplane
/obj/item/papercrafts/airplane
	name = "paper airplane"
	desc = "A Paper Airplane. Don't poke people's eyes out!"
	icon_state = "airplane"
	item_state = "airplane"
	force = 1 //It's made to be more annoying than anything
	throwforce = 2
	throw_speed = 1 //Makes a nice slow movement
	throw_range = 15 //Airplanes go a decent distance

//Paper Shuriken
/obj/item/papercrafts/oragami/shuriken
	name = "paper shuriken"
	desc = "A Paper Shuriken."
	icon_state = "shuriken"
	item_state = "paper"
	force = 1
	throwforce = 5
	throw_speed = 2
	throw_range = 5

//Paper Box
/obj/item/storage/box/papercrafts
	name = "paper box"
	desc = "A paper box. Store stuff in it!"
	icon_state = "box"
	foldable = /obj/item/papercrafts/square //Turns into a square paper when unfolded

// Cutting of paper for papercrafts. Square paper is traditionally used in oragami.
/obj/item/paper/attackby(obj/item/I, mob/user as mob)
	// Any type of scissor can be used on paper.
	if(istype(I, /obj/item/scissors))
		var/want = input("Choose what you want to make", "Your Choice", "Cancel") in list ("Cancel", "Paper Square", "Paper Hat")
		switch(want)
			if("Cancel")
				return
			if("Paper Square")
				var/obj/item/papercrafts/square/S = new /obj/item/papercrafts/square
				user.remove_from_mob(src)
				user.put_in_hands(S)
				to_chat(user, "<span class='notice'>You trim the paper into a square</span>")
				qdel(src)
			if("Paper Hat")
				var/obj/item/clothing/head/urist/papercrown/C = new /obj/item/clothing/head/urist/papercrown
				user.remove_from_mob(src)
				user.put_in_hands(C)
				to_chat(user, "<span class='notice'>You make a paper crown</span>")
				qdel(src)
			else
				return
	..()
