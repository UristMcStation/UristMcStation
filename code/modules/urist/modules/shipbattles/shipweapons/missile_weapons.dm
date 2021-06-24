
//missiles

/obj/machinery/shipweapons/missile
	icon = 'icons/urist/96x96.dmi'
	passshield = 1
	var/loaded = 0
	var/maxload = 1 //in case we have missile arrays

/obj/machinery/shipweapons/missile/Fire()
	if(loaded)	//Console calls this proc directly so let's check for ammo
		loaded -= 1
		if(!loaded)
			UpdateStatus() //Update the status to show out of ammo
		..()
	else
		to_chat(usr, "<span class='warning'>The [src.name] isn't loaded!</span>")
		return

/obj/machinery/shipweapons/missile/attack_hand(mob/user as mob)
	if(loaded)
		..()

	else
		user << "<span class='warning'>The [src.name] isn't loaded!</span>"
		return


//torpedo

/obj/structure/shipammo/torpedo //TODO: Make this generic
	name = "torpedo casing"
	density = 0
	anchored = 0
	icon = 'icons/urist/items/ship_projectiles48x48.dmi'
	icon_state = "bigtorpedo-unloaded"
	var/loaded = 0
	var/obj/item/shipweapons/torpedo_warhead/warhead = null
	matter = list(DEFAULT_WALL_MATERIAL = 2500)
	dir = 4

/obj/structure/shipammo/torpedo/New()
	..()
	pixel_y = rand(-20,2)
	if(ispath(warhead))
		warhead = new warhead(src)

/obj/structure/shipammo/torpedo/attackby(var/obj/item/I, mob/user as mob)
	if(istype(I, /obj/item/shipweapons/torpedo_warhead))
		if(!src.loaded && user.unEquip(I, src))

			icon_state = "bigtorpedo"
			loaded = 1

			warhead = I

			user << "<span class='notice'>You insert the torpedo warhead into the torpedo casing, arming the torpedo.</span>" //torpedo

		else
			user << "<span class='notice'>This torpedo already has a warhead in it!</span>" //torpedo

	else if(isCrowbar(I))
		if(warhead)
			warhead.dropInto(loc)
			to_chat(user, "<span class='notice'>You remove the torpedo warhead.</span>")
			warhead = null
			loaded = 0
			icon_state = "bigtorpedo-unloaded"
	else
		..()

/obj/structure/shipammo/torpedo/loaded
	name = "loaded torpedo"
	loaded = 1
	icon = 'icons/urist/items/ship_projectiles48x48.dmi'
	icon_state = "bigtorpedo"
	warhead = /obj/item/shipweapons/torpedo_warhead

/obj/machinery/shipweapons/missile/torpedo
	name = "torpedo launcher"
	icon_state = "torpedo"
	hulldamage = 350 //maybe
	active_power_usage = 2500
	component_hit = 25
	rechargerate = 16 SECONDS
	projectile_type = /obj/item/projectile/bullet/ship/missile/bigtorpedo
	fire_sound = 'sound/weapons/railgun.ogg'

/obj/machinery/shipweapons/missile/torpedo/Bumped(atom/movable/M as mob|obj)
	..()
	if(istype(M, /obj/structure/shipammo/torpedo))
		var/obj/structure/shipammo/torpedo/L = M
		if(L.loaded && !src.loaded) //no need for maxload here, because fuck it
			qdel(L)
			src.loaded += 1
			src.UpdateStatus()

/obj/machinery/shipweapons/missile/torpedo/Crossed(O as obj)
	..()
	if(istype(O, /obj/structure/shipammo/torpedo))
		var/obj/structure/shipammo/torpedo/L = O
		if(L.loaded && !src.loaded) //no need for maxload here, because fuck it
			qdel(L)
			src.loaded += 1
			src.UpdateStatus()

/obj/machinery/shipweapons/missile/torpedo/update_icon()
	..()

	if(charged && loaded)
		icon_state = "[initial(icon_state)]-loaded"