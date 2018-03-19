//Snowflake proc for railings
/obj/structure/proc/neighbor_turf_passable()
	var/turf/T = get_step(src, src.dir)
	if(!T || !istype(T))
		return 0
	if(T.density)
		return 0
	for(var/obj/O in T.contents)
		if(istype(O,/obj/structure))
			if(istype(O,/obj/structure/railing))
				return 1
			else if(O.density)
				return 0
	return 1

//actually railing code
/obj/structure/railing
	name = "railing"
	desc = "A standard steel railing. Prevents human stupidity."
	icon = 'icons/obj/railing.dmi'
	density = 1
	throwpass = 1
	//layer = 3.2//Just above doors 	//Layers mean nothing.
	plane = ABOVE_HUMAN_PLANE // They go ontop of humans.
	anchored = 1
	atom_flags = ATOM_FLAG_CHECKS_BORDER | ATOM_FLAG_CLIMBABLE
	icon_state = "railing0"
	var/health=70
	var/maxhealth=70
	var/check = 0

/obj/structure/railing/New(loc, constructed=0)
	..()
	if (constructed)	//player-constructed railings
		anchored = 0
	if(src.anchored)
		spawn(5)
			update_icon(0)

/obj/structure/railing/Destroy()
	for(var/obj/structure/railing/R in oview(src, 1))
		R.update_icon()
	. = ..()


//32 ? 4 - ? ??? ?? ??????

/obj/structure/railing/examine(mob/user)
	. = ..()
	if(health < maxhealth)
		switch(health / maxhealth)
			if(0.0 to 0.5)
				user << "<span class='warning'>It looks severely damaged!</span>"
			if(0.25 to 0.5)
				user << "<span class='warning'>It looks damaged!</span>"
			if(0.5 to 1.0)
				user << "<span class='notice'>It has a few scrapes and dents.</span>"

/obj/structure/railing/proc/take_damage(amount)
	health -= amount
	if(health <= 0)
		visible_message("<span class='warning'>\The [src] breaks down!</span>")
		playsound(loc, 'sound/effects/grillehit.ogg', 50, 1)
		new /obj/item/stack/rods(get_turf(usr))
		qdel(src)

/obj/structure/railing/proc/NeighborsCheck(var/UpdateNeighbors = 1)
	check = 0
	//if (!anchored) return
	var/Rturn = turn(src.dir, -90)
	var/Lturn = turn(src.dir, 90)
//Thanks ruskies, comments that i don't understand
	for(var/obj/structure/railing/R in src.loc)// ?????? ??????, ??? ????????? ??? ??????
		if ((R.dir == Lturn) && R.anchored)//???????? ????? ???????
			//src.LeftSide[1] = 1
			check |= 32
			if (UpdateNeighbors)
				R.update_icon(0)
		if ((R.dir == Rturn) && R.anchored)//???????? ?????? ???????
			//src.RightSide[1] = 1
			check |= 2
			if (UpdateNeighbors)
				R.update_icon(0)

	for (var/obj/structure/railing/R in get_step(src, Lturn))//?????? ????? ?????? ?? ??????????? ???????
		if ((R.dir == src.dir) && R.anchored)
			//src.LeftSide[2] = 1
			check |= 16
			if (UpdateNeighbors)
				R.update_icon(0)
	for (var/obj/structure/railing/R in get_step(src, Rturn))//?????? ?????? ?????? ?? ??????????? ???????
		if ((R.dir == src.dir) && R.anchored)
			//src.RightSide[2] = 1
			check |= 1
			if (UpdateNeighbors)
				R.update_icon(0)

	for (var/obj/structure/railing/R in get_step(src, (Lturn + src.dir)))//?????? ????????-????? ????????? ???????????? ??????????? ???????.
		if ((R.dir == Rturn) && R.anchored)
			check |= 64
			if (UpdateNeighbors)
				R.update_icon(0)
	for (var/obj/structure/railing/R in get_step(src, (Rturn + src.dir)))//?????? ????????-?????? ????????? ???????????? ??????????? ???????.
		if ((R.dir == Lturn) && R.anchored)
			check |= 4
			if (UpdateNeighbors)
				R.update_icon(0)


/*	for(var/obj/structure/railing/R in get_step(src, src.dir))
		if ((R.dir == Lturn) && R.anchored)//???????? ????? ???????
			src.LeftSide[3] = 1
		if ((R.dir == Rturn) && R.anchored)//???????? ?????? ???????
			src.RightSide[3] = 1*/
	//check <<"check: [check]"
	//world << "dir = [src.dir]"
	//world << "railing[LeftSide[1]][LeftSide[2]][LeftSide[3]]-[RightSide[1]][RightSide[2]][RightSide[3]]"

/obj/structure/railing/update_icon(var/UpdateNeighgors = 1)
	NeighborsCheck(UpdateNeighgors)
	//icon_state = "railing[LeftSide[1]][LeftSide[2]][LeftSide[3]]-[RightSide[1]][RightSide[2]][RightSide[3]]"
	overlays.Cut()
	if (!check || !anchored)//|| !anchored
		icon_state = "railing0"
	else
		icon_state = "railing1"
		//????? ???????
		if (check & 32)
			overlays += image ('icons/obj/railing.dmi', src, "corneroverlay")
			//world << "32 check"
		if ((check & 16) || !(check & 32) || (check & 64))
			overlays += image ('icons/obj/railing.dmi', src, "frontoverlay_l")
			//world << "16 check"
		if (!(check & 2) || (check & 1) || (check & 4))
			overlays += image ('icons/obj/railing.dmi', src, "frontoverlay_r")
			//world << "no 4 or 2 check"
			if(check & 4)
				switch (src.dir)
					if (NORTH)
						overlays += image ('icons/obj/railing.dmi', src, "mcorneroverlay", pixel_x = 32)
					if (SOUTH)
						overlays += image ('icons/obj/railing.dmi', src, "mcorneroverlay", pixel_x = -32)
					if (EAST)
						overlays += image ('icons/obj/railing.dmi', src, "mcorneroverlay", pixel_y = -32)
					if (WEST)
						overlays += image ('icons/obj/railing.dmi', src, "mcorneroverlay", pixel_y = 32)

/obj/structure/railing/verb/rotate()
	set name = "Rotate Railing Counter-Clockwise"
	set category = "Object"
	set src in oview(1)

	if(usr.incapacitated())
		return 0

	if(anchored)
		usr << "It is fastened to the floor therefore you can't rotate it!"
		return 0

	set_dir(turn(dir, 90))
	update_icon()
	return

/obj/structure/railing/verb/revrotate()
	set name = "Rotate Railing Clockwise"
	set category = "Object"
	set src in oview(1)

	if(usr.incapacitated())
		return 0

	if(anchored)
		usr << "It is fastened to the floor therefore you can't rotate it!"
		return 0

	set_dir(turn(dir, -90))
	update_icon()
	return

/obj/structure/railing/verb/flip() // This will help push railing to remote places, such as open space turfs
	set name = "Flip Railing"
	set category = "Object"
	set src in oview(1)

	if(usr.incapacitated())
		return 0

	if(anchored)
		usr << "It is fastened to the floor therefore you can't flip it!"
		return 0

	if(!neighbor_turf_passable())
		usr << "You can't flip the [src] because something blocking it."
		return 0

	src.loc = get_step(src, src.dir)
	set_dir(turn(dir, 180))
	update_icon()
	return

/obj/structure/railing/attackby(obj/item/W as obj, mob/user as mob)
	// Dismantle
	if(istype(W, /obj/item/weapon/wrench) && !anchored)
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		if(do_after(user, 20, src))
			user.visible_message("<span class='notice'>\The [user] dismantles \the [src].</span>", "<span class='notice'>You dismantle \the [src].</span>")
			new /obj/item/stack/material/steel(get_turf(usr))
			new /obj/item/stack/material/steel(get_turf(usr))
			qdel(src)
			return

	// Repair
	if(health < maxhealth && istype(W, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/F = W
		if(F.welding)
			playsound(src.loc, 'sound/items/Welder.ogg', 50, 1)
			if(do_after(user, 20, src))
				user.visible_message("<span class='notice'>\The [user] repairs some damage to \the [src].</span>", "<span class='notice'>You repair some damage to \the [src].</span>")
				health = min(health+(maxhealth/2), maxhealth)//max(health+(maxhealth/2), maxhealth) // 50% repair per application
				return

	// Install
	if(istype(W, /obj/item/weapon/screwdriver))
		user.visible_message(anchored ? "<span class='notice'>\The [user] begins unscrew \the [src].</span>" : "<span class='notice'>\The [user] begins fasten \the [src].</span>" )
		playsound(loc, 'sound/items/Screwdriver.ogg', 75, 1)
		if(do_after(user, 10, src))
			user << (anchored ? "<span class='notice'>You have unfastened \the [src] from the floor.</span>" : "<span class='notice'>You have fastened \the [src] to the floor.</span>")
			anchored = !anchored
			update_icon()
			return

	// Handle grabs
	if(istype(W, /obj/item/grab))
		var/obj/item/grab/G = W
		if(istype(G.current_grab, /datum/grab/normal/aggressive))
			var/obj/occupied = turf_is_crowded()
			if(occupied)
				user << "<span class='danger'>There's \a [occupied] in the way.</span>"
				return
			if (get_dist(G.affecting,src)<2)
				G.affecting.forceMove(get_step(src, src.dir))
				visible_message("<span class='danger'>[G.assailant] throws [G.affecting] over \the [src]!</span>")
			else
				to_chat(user, "<span class='danger'>They're too far away to throw over.</span>")
			return

	else
		playsound(loc, 'sound/effects/grillehit.ogg', 50, 1)
		take_damage(W.force)

	return ..()

/obj/structure/railing/ex_act(severity)
	if(severity)
		qdel(src)

