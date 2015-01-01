//Tape-based weapons

//Paper Knifeplane
/obj/item/weapon/improvised/knifeplane
	name = "Paper Knifeplane"
	desc = "A Paper Knifeplane. This will poke people's eyes out."
	icon = 'icons/urist/items/papercrafts.dmi'
	icon_state = "knifeplane"
	item_state = "airplane"
	force = 8
	throwforce = 30
	throw_speed = 1 //Makes a nice slow movement
	throw_range = 15 //Airplanes go a decent distance
	sharp = 1
	edge = 1
	w_class = 2
	urist_only = 1

	suicide_act(mob/user)
		viewers(user) << pick("\red <b>[user] is slitting \his wrists with the [src]! It looks like \he's trying to commit suicide.</b>", \
							"\red <b>[user] is slitting \his throat with the [src]! It looks like \he's trying to commit suicide.</b>")
		return (BRUTELOSS)

/obj/item/weapon/improvised/knifeplane/throw_impact(atom/hit_atom)
	..()
	src.visible_message("<span class='alert'>The [src] hits the [hit_atom], breaking</span>")
	var/obj/O = new /obj/item/weapon/improvised/bknifeplane(src.loc) //Creates the broken airplane where the thing is
	O.dir = src.dir //Transfers the direction
	O.fingerprints = src.fingerprints //Fingerprint transfers for detectives
	O.fingerprintshidden = src.fingerprintshidden
	O.fingerprintslast = src.fingerprintslast
	del src

//Broken Knifeplane
/obj/item/weapon/improvised/bknifeplane
	name = "Paper Knifeplane"
	desc = "A Paper Knifeplane. This will poke people's eyes out. This one's broken"
	icon = 'icons/urist/items/papercrafts.dmi'
	icon_state = "brokenknifeplane"
	item_state = "airplane"
	force = 5
	throwforce = 2
	throw_speed = 1
	throw_range = 2
	sharp = 1
	edge = 1
	w_class = 2
	urist_only = 1

	suicide_act(mob/user)
		viewers(user) << pick("\red <b>[user] is slitting \his wrists with the [src]! It looks like \he's trying to commit suicide.</b>", \
							"\red <b>[user] is slitting \his throat with the [src]! It looks like \he's trying to commit suicide.</b>")
		return (BRUTELOSS)
//End of knifeplane

//Cargo Plane
/obj/item/weapon/storage/box/cargoplane
	name = "Paper Cargoplane"
	desc = "A Paper Cargoplane. This can carry small stuff."
	icon = 'icons/urist/items/papercrafts.dmi'
	icon_state = "cargoplane"
	item_state = "airplane"
	force = 1
	throwforce = 2
	throw_speed = 1 //Makes a nice slow movement
	throw_range = 15 //Airplanes go a decent distance
	foldable = "this isn't a path" //This prevents the user from unfolding it. If you look in storage.dm, It'll return if foldable isn't a path

//Airplane assemblies
/obj/item/weapon/papercrafts/airplane/attackby(var/obj/item/I, mob/user as mob)
	if(istype(I, /obj/item/weapon/tape/tape_piece) && !taped) //Taping the thingy
		taped = 1 //Letting the game know if it has been taped
		icon_state = initial(icon_state) + "_taped"
		del I
		user.visible_message("[user] attaches the [I] to the [src]")
		return

	if(!taped) return //If it isn't taped, leave
	//Insert things that can be attached here
	var/obj/item/newplane

	if(istype(I, /obj/item/weapon/improvised/scissorknife)) //Knifeplane
		newplane = new /obj/item/weapon/improvised/knifeplane
		goto createPlane

	if(istype(I, /obj/item/weapon/storage/box/papercrafts)) //Cargo Plane
		newplane = new /obj/item/weapon/storage/box/cargoplane
		goto createPlane

	return
	createPlane //Tag for creating plane

	user.visible_message("[user] tapes the [I] to the [src]")
	newplane.dir = src.dir
	newplane.fingerprints = src.fingerprints //Fingerprint transfers for detectives
	newplane.fingerprintshidden = src.fingerprintshidden
	newplane.fingerprintslast = src.fingerprintslast
	user.drop_from_inventory(src)
	user.put_in_hands(newplane)
	del I
	del src
	return
