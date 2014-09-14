 /*										*****New space to put all UristMcStation Crates*****

All crates that cannot be ordered go here. Please keep it tidy, by which I mean put comments describing the item before the entry. -Glloyd*/


//A crate.

/obj/structure/closet/crate/secure/large/reinforced/singulo
	name = "Particle Accelerator Storage"
	desc = "A hefty, reinforced metal crate with an electronic locking system."
	req_access = list(access_ce)
	icon_state = "largermetal"
	icon_opened = "largermetalopen"
	icon_closed = "largermetal"

/obj/structure/closet/crate/secure/large/reinforced/singulo/New()
	..()
	new /obj/structure/particle_accelerator/end_cap(src)
	new /obj/structure/particle_accelerator/fuel_chamber(src)
	new /obj/structure/particle_accelerator/power_box(src)
	new /obj/structure/particle_accelerator/particle_emitter/center(src)
	new /obj/structure/particle_accelerator/particle_emitter/left(src)
	new /obj/structure/particle_accelerator/particle_emitter/right(src)

//
//                   ???
//

/obj/structure/largecrate/schrodinger
	name = "Schrodinger's Crate"
	desc = "What happens if you open it?"

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if(istype(W, /obj/item/weapon/crowbar))
			var/mob/living/simple_animal/cat/Cat1 = new(loc)
			Cat1.apply_damage(250)//,TOX)
			Cat1.name = "Schrodinger's Cat"
			Cat1.desc = "It seems it's been dead for a while."

			var/mob/living/simple_animal/cat/Cat2 = new(loc)
			Cat2.name = "Schrodinger's Cat"
			Cat2.desc = "It was alive the whole time!"
			sleep(2)
			if(prob(50))
				del Cat1
			else
				del Cat2
		..()