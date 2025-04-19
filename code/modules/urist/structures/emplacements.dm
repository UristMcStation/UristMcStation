/mob/living/carbon/human
	var/obj/structure/emplacement/mounted

/mob/living/carbon/human/ClickOn(atom/A, params)
	if(mounted)
		if(mounted.loc == src.loc)
			if(A && mounted.nextshot <= world.time && mounted.anchored)
				mounted.shoot(get_turf(A))
		else
			mounted = null
	else
		..()


/obj/structure/emplacement
	name = "machine gun"
	desc = "A stationary machine gun."
	icon = 'icons/urist/structures&machinery/emplacements.dmi'
	icon_state = "mgun+barrier"
	var/fire_sound = 'sound/weapons/gunshot/gunshot_strong.ogg'
	var/empty_sound = 'sound/weapons/empty.ogg'
	var/ammo_type = /obj/item/projectile/bullet/rifle
	var/ammo = 500
	var/ammomax = 500
	var/list/row1 = list()
	var/list/row2 = list()
	var/list/row3 = list()
	var/mob/living/carbon/human/User
	var/nextshot = 0
	var/FIRETIME = 1 //tenths of seconds
	density = TRUE
	anchored = FALSE
	atom_flags = ATOM_FLAG_CHECKS_BORDER
	health_max = 500

/obj/structure/emplacement/AT
	name = "anti-tank gun"
	desc = "A stationary anti-tank gun."
	icon = 'icons/urist/structures&machinery/64x64machinery.dmi'
	icon_state = "ryclies_AT"
	bound_width = 64
	ammo = 25
	ammomax = 25
	FIRETIME = 250
	anchored = TRUE
	ammo_type = /obj/item/missile
	fire_sound = 'sound/effects/Explosion1.ogg'

/obj/structure/emplacement/laser
	name = "laser turret"
	desc = "A stationary laser turret."
	icon_state = "laser"
	icon = 'icons/urist/structures&machinery/emplacements.dmi'
	ammo = 500
	ammomax = 500
	FIRETIME = 10
	ammo_type = /obj/item/projectile/beam
	fire_sound = 'sound/weapons/Laser.ogg'

/obj/structure/emplacement/AT/New()
	..()
	update_rows()

/obj/structure/emplacement/Process()
	var/mob/living/carbon/human/U
	for(var/mob/living/carbon/human/H in range(0, src))
		if(H)
			U = H
	if(U)
		if(User && User != U)
			User.mounted = null
			User = null
		User = U
		User.mounted = src
	else
		if(User)
			User.mounted = null
			User = null
	sleep(1)
/obj/structure/emplacement/New()
	..()
	START_PROCESSING(SSobj, src)

/obj/structure/emplacement/proc/shoot(turf/T)
	if(ammo <= 0)
		if(User)
			playsound(src, empty_sound, 70, 1)
			to_chat(User, "This [src] is out of ammo!")

		return
	if(T && User && User.stat == CONSCIOUS && !User.stunned && !User.weakened)
		var/row = 0
		if(row1.Find(T))
			row = 1
		else if(row2.Find(T))
			row = 2
		else if(row3.Find(T))
			row = 3
		if(row)
			var/turf/shootfrom
			switch(row)
				if(1)
					shootfrom = get_step(src, turn(dir, 90))
				if(2)
					shootfrom = get_step(src, dir)
				if(3)
					shootfrom = get_step(src, turn(dir, 270))
			if(shootfrom)

				var/turf/curloc = get_turf(shootfrom)
				var/turf/targloc
				switch(row)
					if(1)
						targloc = row1[7]
					if(2)
						targloc = row2[7]
					if(3)
						targloc = row3[7]
				if (!istype(targloc) || !istype(curloc))
					return
				playsound(src, fire_sound, 50, 1)
				var/obj/item/projectile/B = new ammo_type(shootfrom)
				B.firer = User
				B.def_zone = User.zone_sel.selecting
				B.original = T
				B.loc = get_turf(shootfrom)
				B.starting = get_turf(shootfrom)
				B.shot_from = src
				B.silenced = 0
				B.current = curloc
				B.yo = targloc.y - curloc.y
				B.xo = targloc.x - curloc.x
				ammo = ammo - 1
				spawn()
					if(B)
						B.Process()
				nextshot = world.time + FIRETIME


/obj/structure/emplacement/proc/update_rows()
	row1 = list()
	row2 = list()
	row3 = list()
	//row1 + 90
	//row2 + 0
	//row3 - 90

	//row1
	var/turf/pos = get_step(src, dir)
	pos = get_step(pos, turn(dir, 90))
	row1.Add(pos)
	var/i
	for(i=2, i<8, i++)
		row1.Add(get_turf(get_step(row1[i - 1], dir)))
	//row2
	pos = get_step(src, dir)
	row2.Add(pos)
	for(i=2, i<8, i++)
		row2.Add(get_turf(get_step(row2[i - 1], dir)))
	//row3
	pos = get_step(src, dir)
	pos = get_step(pos, turn(dir, 270))
	row3.Add(pos)
	for(i=2, i<8, i++)
		row3.Add(get_turf(get_step(row3[i - 1], dir)))


/obj/structure/emplacement/machinegun/use_tool(obj/item/W, mob/living/user, list/click_params)
	var/obj/item/machinegunammo/Ammo = W
	if(istype(W, /obj/item/wrench))
		if(anchored)
			user.visible_message("<span class='notice'> \The [user] starts to unbolt \the [src] from the plating...</span>")
			if(!do_after(user,40))
				user.visible_message("<span class='notice'> \The [user] decides not to unbolt \the [src].</span>")
				return
			user.visible_message("<span class='notice'> \The [user] finishes unfastening \the [src]!</span>")
			anchored = FALSE
			return
		else
			user.visible_message("<span class='notice'> \The [user] starts to bolt \the [src] to the plating...</span>")
			if(!do_after(user,40))
				user.visible_message("<span class='notice'> \The [user] decides not to bolt \the [src].</span>")
				return
			user.visible_message("<span class='notice'> \The [user] finishes fastening down \the [src]!</span>")
			anchored = TRUE
			update_rows()
			return
	else if(Ammo)
		if(ammo < ammomax)
			var/amt = ammomax - ammo
			if(Ammo.count > amt)
				Ammo.count -= amt
				Ammo.desc = "Machine gun ammo. It has [Ammo.count] rounds remaining"
			else
				amt = Ammo.count
				qdel(Ammo)
			ammo = ammo + amt

	else
		return ..()

/obj/structure/emplacement/laser/use_tool(obj/item/W, mob/living/user, list/click_params)
	if(istype(W, /obj/item/wrench))
		if(anchored)
			user.visible_message("<span class='notice'> \The [user] starts to unbolt \the [src] from the plating...</span>")
			if(!do_after(user,40))
				user.visible_message("<span class='notice'> \The [user] decides not to unbolt \the [src].</span>")
				return
			user.visible_message("<span class='notice'> \The [user] finishes unfastening \the [src]!</span>")
			anchored = FALSE
			return
		else
			user.visible_message("<span class='notice'> \The [user] starts to bolt \the [src] to the plating...</span>")
			if(!do_after(user,40))
				user.visible_message("<span class='notice'> \The [user] decides not to bolt \the [src].</span>")
				return
			user.visible_message("<span class='notice'> \The [user] finishes fastening down \the [src]!</span>")
			anchored = TRUE
			update_rows()
			return
	else
		return ..()

/obj/structure/emplacement/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return 1
	if(istype(mover,/obj/item/projectile))
		return (check_cover(mover,target))
	if (get_dir(loc, target) == dir)
		return !density
	else
		return 1

//checks if projectile 'P' from turf 'from' can hit whatever is behind the table. Returns 1 if it can, 0 if bullet stops.
/obj/structure/emplacement/proc/check_cover(obj/item/projectile/P, turf/from)
	var/turf/cover = get_turf(src)
/*	if(istype(P, /obj/item/projectile/energy/acid))
		return 0*/
	if (get_dist(P.starting, loc) <= 1) //Tables won't help you if people are THIS close
		return 1
	if (get_turf(P.original) == cover)
		var/chance = 50
		if (ismob(P.original))
			var/mob/M = P.original
			if (M.lying)
				chance += 20				//Lying down lets you catch less bullets

		if(get_dir(loc, from) == dir)	//Flipped tables catch mroe bullets
			chance += 20
		else
			return 1					//But only from one side
		if(prob(chance))
			health_current -= P.damage/2
			if (health_current > 0)
				visible_message("<span class='warning'>[P] hits \the [src]!</span>")
				return 0
			else
				visible_message("<span class='warning'>[src] breaks down!</span>")
				qdel(src)
				return 1
	return 1

/obj/structure/emplacement/CheckExit(atom/movable/O as mob|obj, target as turf)

	if (get_dir(loc, target) == dir)
		return !density
	else
		return 1

/obj/item/machinegunammo
	icon = 'icons/urist/structures&machinery/emplacements.dmi'
	icon_state = "mgun_crate"
	name = "machinegun ammo"
	desc = "Machine gun ammo. It has 500 rounds remaining"
	var/count = 500
	w_class = 2
