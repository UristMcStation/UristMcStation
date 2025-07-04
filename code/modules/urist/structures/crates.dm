 /*										*****New space to put all UristMcStation Crates*****

All crates that cannot be ordered go here. Please keep it tidy, by which I mean put comments describing the item before the entry. -Glloyd*/


//A crate.

//CDN
/obj/structure/closet/crate/secure/large/reinforced/singulo
	name = "Particle Accelerator Storage"
	desc = "A hefty, reinforced metal crate with an electronic locking system."
	req_access = list(access_ce)

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

/obj/structure/largecrate/schrodinger/use_tool(obj/item/W, mob/living/user, list/click_params)
	if(istype(W, /obj/item/crowbar))
		var/mob/living/simple_animal/passive/cat/Cat1 = new(loc)
		Cat1.apply_damage(250)//,TOX)
		Cat1.name = "Schrodinger's Cat"
		Cat1.desc = "It seems it's been dead for a while."

		var/mob/living/simple_animal/passive/cat/Cat2 = new(loc)
		Cat2.name = "Schrodinger's Cat"
		Cat2.desc = "It was alive the whole time!"
		sleep(2)
		if(prob(50))
			del Cat1
		else
			del Cat2
	..()


/* Boobytrapped secure crates, only legit access to disarm. */

/obj/structure/closet/crate/secure/boobytrapped
	var/trapped = 1
	var/obj/trap //a mine, grenade or other physical effect; otherwise just kaboom
	var/triggered = 0 //insert tumblr joke here
	var/trap_delete_on_open = 1 //for balance, so Sec doesn't get free frags

/obj/structure/closet/crate/secure/boobytrapped/New()
	..()
	if(trapped && trap)
		trap = new trap(src)

/obj/structure/closet/crate/secure/boobytrapped/proc/trigger_trap()
	if(trapped && !(triggered))
		triggered = 1
		src.visible_message("<span class='warning'>[src] emits a quiet raising whine...</span>", "<span class='warning'>[src] emits a quiet raising whine...</span>", 5)
		sleep(10)
		if(trap)
			if(istype(trap, /obj/structure/mine))
				var/obj/structure/mine/M = trap
				M.activate()
			else if(istype(trap, /obj/item/grenade))
				var/obj/item/grenade/G = trap
				G.detonate()
		else
			explosion(loc, 0, 2, 4, 5)

/obj/structure/closet/crate/secure/boobytrapped/open()
	if(!(triggered))
		triggered = 1
		if(trap)
			if(isobj(trap) && trap_delete_on_open)
				qdel(trap) //no frags for you!
	..()

/*/obj/structure/closet/crate/secure/boobytrapped/damage(damage)
	/* full override since I'd rather not touch qdel(), keep this updated with closet's damage() */
	health_current -= damage
	if(health_current <= 0)
		trigger_trap()
		for(var/atom/movable/A in src)
			A.forceMove(src.loc)
		qdel(src)*/

/obj/structure/closet/crate/secure/boobytrapped/on_death()
	trigger_trap()
	for(var/atom/movable/A in src)
		A.forceMove(src.loc)
		qdel(src)

//CDN
/obj/structure/closet/crate/secure/boobytrapped/weapon
	name = "weapons crate"
	desc = "A secure weapons crate outfitted with an anti-tamper trap."
	trap = /obj/item/grenade/frag/high_yield
	trap_delete_on_open = 1
//CDN
/obj/structure/closet/crate/secure/boobytrapped/gear
	name = "gear crate"
	desc = "A secure gear crate outfitted with an anti-tamper trap."
	icon_state = "secgearcrate"
	trap = /obj/item/grenade/frag/high_yield
	trap_delete_on_open = 1

/obj/structure/closet/crate/secure/boobytrapped/weapon/random/New()
	if(prob(50))
		trap = null
		trap_delete_on_open = 0
	..()
