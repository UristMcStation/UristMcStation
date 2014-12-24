//Tape-based weapons

//Paper Knifeplane
/obj/item/weapon/papercrafts/airplane/knife
	name = "Paper Knifeplane"
	desc = "A Paper Knifeplane. This will poke people's eyes out."
	icon_state = "knifeplane"
	item_state = "knifeplane"
	force = 8
	throwforce = 20
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

/obj/item/weapon/papercrafts/airplane/knife/throw_impact(atom/hit_atom)
	..()
	src.visible_message("<span class='alert'>The [src] hits the [hit_atom], breaking</span>")
	new /obj/item/weapon/papercrafts/airplane/bknife //Creates the broken airplane
	del src

//Broken Knifeplane
/obj/item/weapon/papercrafts/airplane/bknife
	name = "Paper Knifeplane"
	desc = "A Paper Knifeplane. This will poke people's eyes out. This one's broken"
	icon_state = "brokeknifeplane"
	item_state = "knifeplane"
	force = 8
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