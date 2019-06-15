
//holojanisign

/obj/item/weapon/holosign_creator
	name = "holographic sign projector"
	desc = "A handy-dandy projector that displays a janitorial sign."
	icon = 'icons/urist/items/hologram_creator.dmi'
	icon_state = "signmaker"
	item_state = "electronic"
	force = 5
	w_class = 2
	throwforce = 0
	throw_speed = 3
	throw_range = 7
	origin_tech = "programming=3"
	var/list/signs = list()
	var/max_signs = 10
	var/creation_time = 0
	var/holosign_type = /obj/structure/hologramsign

/obj/item/weapon/holosign_creator/afterattack(atom/target, mob/user, flag)
	if(flag)
		var/turf/T = get_turf(target)
		var/obj/structure/hologramsign/H = locate() in T
		if(istype(H, holosign_type))
			to_chat(user, "<span class='notice'>You use [src] to destroy [H].</span>")
			signs -= H
			qdel(H)
		else
			if(signs.len < max_signs)
				if(do_after(user, creation_time, src))
					H = new holosign_type (get_turf(target))
					signs += H
					to_chat(user, "<span class='notice'>You create \a [H] with [src].</span>")
			else
				to_chat(user, "<span class='notice'>[src] is projecting at max capacity!</span>")

/obj/item/weapon/holosign_creator/attack(mob/living/carbon/human/M, mob/user)
	return

/obj/item/weapon/holosign_creator/attack_self(mob/user)
	if(signs.len)
		var/list/L = signs.Copy()
		for(var/sign in L)
			qdel(sign)
			signs -= sign
		user << "<span class='notice'>You clear all active holograms.</span>"


/obj/structure/hologramsign
	name = "wet floor sign"
	desc = "The words flicker as if they mean nothing."
	icon = 'icons/urist/items/hologram_creator.dmi'
	icon_state = "holosign"
	anchored = 1
	density = 0

/obj/structure/hologramsign/barrier
	name = "holobarrier"
	desc = "A holographic barrier with security in mind."
	icon_state = "holosign_sec"

/obj/structure/hologramsign/barrier/ //Just a definition so this shows up in the tree.


/obj/structure/hologramsign/barrier/walk/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(!ismob(mover))
		return ..()
	var/mob/M = mover
	if(M.move_intent.flags & MOVE_INTENT_DELIBERATE)
		return ..()
	to_chat(M, "<span class = 'notice' >Slow down, if you intend to blatantly violate this posted warning!</span>")
	return FALSE

/obj/item/weapon/holosign_creator/security
	name = "security holobarrier projector"
	desc = "A holographic projector that creates holographic security barriers."
	icon_state = "signmaker_sec"
	holosign_type = /obj/structure/hologramsign/barrier/walk
	creation_time = 30
	max_signs = 6

/obj/item/weapon/holosign_creator/engineering
	name = "engineering holobarrier projector"
	desc = "A holographic projector that creates holographic engineering barriers."
	icon_state = "signmaker_engi"
	holosign_type = /obj/structure/hologramsign/barrier/walk/engineering
	creation_time = 30
	max_signs = 6

/obj/structure/hologramsign/barrier/walk/engineering
	name = "engineering holobarrier"
	desc = "A holographic barrier with a certain engineering interest."
	icon_state = "holosign_engi"

/obj/item/weapon/holosign_creator/atmos
	name = "ATMOS holofan projector"
	desc = "A holographic projector that creates holographic barriers that prevent changes in atmosphere conditions."
	icon_state = "signmaker_atmos"
	holosign_type = /obj/structure/hologramsign/barrier/atmos
	creation_time = 0
	max_signs = 3

/obj/structure/hologramsign/barrier/atmos
	name = "ATMOS holofan"
	icon_state = "holo_fan"
	desc = "A holographic barrier that prevent changes in atmosphere conditions. <b>Not safe to stand in!</b>"


/obj/structure/hologramsign/barrier/atmos/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(!height || air_group) return 0
	else return ..()

/obj/structure/hologramsign/barrier/atmos/Destroy()
	SSair.mark_for_update(get_turf(src))
	..()