/obj/structure/closet/secure_closet/guncabinet
	name = "gun cabinet"
	req_access = list(access_armory)
	icon = 'icons/obj/structures/guncabinet.dmi'
	closet_appearance = null

/obj/structure/closet/secure_closet/guncabinet/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/structure/closet/secure_closet/guncabinet/LateInitialize()
	..()
	update_icon()

/obj/structure/closet/secure_closet/guncabinet/LateInitialize(mapload)
	..()
	update_icon()

/obj/structure/closet/secure_closet/guncabinet/toggle()
	..()
	update_icon()

/obj/structure/closet/secure_closet/guncabinet/open() //There are plenty of things that can open it that don't use toggle
	..()
	update_icon()

/obj/structure/closet/secure_closet/guncabinet/on_update_icon()
	ClearOverlays()
	if(opened)
		AddOverlays(icon(icon,"door_open"))
	else
		var/lazors = 0
		var/shottas = 0
		for (var/obj/item/gun/G in contents)
			if (istype(G, /obj/item/gun/energy))
				lazors++
			if (istype(G, /obj/item/gun/projectile))
				shottas++
		for (var/i = 0 to 2)
			if(lazors || shottas) // only make icons if we have one of the two types.
				var/image/gun = image(icon(src.icon))
				if (lazors > shottas)
					lazors--
					gun.icon_state = "laser"
				else if (shottas)
					shottas--
					gun.icon_state = "projectile"
				gun.pixel_x = i*4
				AddOverlays(gun)

		AddOverlays(icon(src.icon, "door"))

		if(welded)
			AddOverlays(icon(src.icon,"welded"))

		if(!broken)
			if(locked)
				AddOverlays(icon(src.icon,"locked"))
			else
				AddOverlays(icon(src.icon,"open"))
