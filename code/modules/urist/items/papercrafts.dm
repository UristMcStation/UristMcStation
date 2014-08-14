//////////////////////////////////////////
//		Arts and crafts system			//
//				TGameCo					//
//////////////////////////////////////////

//All of the scissor stuff <-- TGameCo
/obj/item/weapon/scissors
	name = "Scissors"
	desc = "Those are scissors. Don't run with them!"
	icon = 'icons/urist/uristicons.dmi'
	icon_state = "scissor"
	item_state = "scissor"
	force = 5
	sharp = 1
	w_class = 2
	urist_only = 1

/obj/item/weapon/scissors/attackby(var/obj/item/I, mob/user as mob)
	if(istype(I, /obj/item/weapon/screwdriver))

		var/obj/item/weapon/scissors/knife/N = new /obj/item/weapon/scissors/knife
		var/obj/item/weapon/scissors/knife/N2 = new /obj/item/weapon/scissors/knife

		user.before_take_item(I)
		user.before_take_item(src)

		user.put_in_hands(N)
		user.put_in_hands(N2)
		user << "<span class='notice'>You seperate the parts of the screwdriver</span>"

		del(src)
	..()

/obj/item/weapon/scissors/assembly //So you can put it together!
	name = "Scissor Assembley"
	desc = "Two parts of a scissor loosely combined"
	force = 3

/obj/item/weapon/scissors/assembly/attackby(var/obj/item/I, mob/user as mob)
	if(istype(I, /obj/item/weapon/screwdriver))

		var/obj/item/weapon/scissors/N = new /obj/item/weapon/scissors

		user.before_take_item(src)

		user.put_in_hands(N)
		user << "<span class='notice'>You tighten the screw on the screwdriver assembley</span>"

		del(src)
	..()

//Papercrafts definition
/obj/item/weapon/paper/papercrafts
	icon = 'icons/urist/items/papercrafts.dmi'

/obj/item/weapon/paper/papercrafts/square
	name = "Paper Square"
	icon_state = "paperSquare"

//What happens on paper... Oh my...
/obj/item/weapon/paper/attackby(var/obj/item/I, mob/user as mob)
	if(istype(I, /obj/item/weapon/scissors))
		var/obj/item/weapon/paper/papercrafts/square/S = new /obj/item/weapon/paper/papercrafts/square

		user.before_take_item(src)

		user.put_in_hands(S)
		user << "<span class='notice'>You trim the paper into a square</span>"

		del(src)
	..()