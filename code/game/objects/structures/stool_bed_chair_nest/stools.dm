/obj/structure/stool
	name = "stool"
	desc = "Apply butt."
	icon = 'icons/obj/objects.dmi'
	icon_state = "stool"
	anchored = 1.0
	var/style = 0 //0 is regular, 1 is bar, 2 is wood
	flags = FPRINT
	pressure_resistance = 15

/obj/structure/stool/ex_act(severity)
	switch(severity)
		if(1.0)
			del(src)
			return
		if(2.0)
			if (prob(50))
				del(src)
				return
		if(3.0)
			if (prob(5))
				del(src)
				return
	return

/obj/structure/stool/blob_act()
	if(prob(75))
		if(style == 2)
			new /obj/item/stack/sheet/wood(src.loc)
		else
			new /obj/item/stack/sheet/metal(src.loc)
		del(src)


/obj/structure/stool/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/wrench))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		if(style == 2)
			new /obj/item/stack/sheet/wood(src.loc)
		else
			new /obj/item/stack/sheet/metal(src.loc)
		del(src)
	return

/obj/structure/stool/MouseDrop(atom/over_object)
	if (istype(over_object, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = over_object
		if (H==usr && !H.restrained() && !H.stat && in_range(src, over_object))
			if(style == 0)
				var/obj/item/weapon/stool/S = new/obj/item/weapon/stool(src.loc)
				S.origin = src
				src.loc = S
				H.put_in_hands(S)
			if(style == 1)
				var/obj/item/weapon/stool/S = new/obj/item/weapon/stool/bar(src.loc)
				S.origin = src
				src.loc = S
				H.put_in_hands(S)
			if(style == 2)
				var/obj/item/weapon/stool/S = new/obj/item/weapon/stool/wood(src.loc)
				S.origin = src
				src.loc = S
				H.put_in_hands(S)

//			H.put_in_hands(S)
			H.visible_message("\red [H] grabs [src] from the floor!", "\red You grab [src] from the floor!")
			del(src)

/obj/item/weapon/stool
	name = "stool"
	desc = "Uh-hoh, bar is heating up."
	icon = 'icons/obj/objects.dmi'
	icon_state = "stool"
	force = 10
	throwforce = 10
	w_class = 5.0
	var/style = 0 //0 is regular, 1 is bar, 2 is wood
	var/obj/structure/stool/origin = null

/obj/item/weapon/stool/proc/deploy(var/mob/user)

	if(!origin)
		del src

	if(style == 0)
		var/obj/structure/stool/S = new/obj/structure/stool()
		S.loc = get_turf(src)
	if(style == 1)
		var/obj/structure/stool/S = new/obj/structure/stool/bar()
		S.loc = get_turf(src)
	if(style == 2)
		var/obj/structure/stool/S = new/obj/structure/stool/wood()
		S.loc = get_turf(src)

	if(user)
		user.u_equip(src)
		user.visible_message("\blue [user] puts [src] down.", "\blue You put [src] down.")

	del(src)

/obj/item/weapon/stool/dropped(mob/user as mob)
	..()
	if(istype(loc,/turf/))
		deploy(user)

/obj/item/weapon/stool/attack_self(mob/user as mob)
	..()
	deploy(user)

/obj/item/weapon/stool/attack(mob/M as mob, mob/user as mob)
	if (prob(5) && istype(M,/mob/living))
		user.visible_message("\red [user] breaks [src] over [M]'s back!")
		user.u_equip(src)
		if(style == 2)
			var/obj/item/stack/sheet/wood/m = new/obj/item/stack/sheet/wood
			m.loc = get_turf(src)
		else
			var/obj/item/stack/sheet/metal/m = new/obj/item/stack/sheet/metal
			m.loc = get_turf(src)
		del src
		var/mob/living/T = M
		T.Weaken(10)
		T.apply_damage(20)
		return
	..()
