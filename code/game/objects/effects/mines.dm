/obj/structure/mine
	name = "Mine"
	desc = "I Better stay away from that thing."
	density = FALSE
	anchored = TRUE
	layer = OBJ_LAYER
	icon = 'icons/obj/weapons/other.dmi'
	icon_state = "uglymine"
	var/triggerproc = "explode" //name of the proc thats called when the mine is triggered
	var/triggered = 0


/obj/structure/mine/Initialize()
	. = ..()
	icon_state = "uglyminearmed"


/obj/structure/mine/Crossed(AM as mob|obj)
	Bumped(AM)

/obj/structure/mine/Bumped(mob/M as mob|obj)

	if(triggered) return

	if(istype(M, /mob/living))
		for(var/mob/O in viewers(world.view, src.loc))
			to_chat(O, SPAN_WARNING("\The [M] triggered the [icon2html(src, O)] [src]"))
		triggered = 1
		call(src,triggerproc)(M)

/obj/structure/mine/proc/triggerrad(obj)
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread()
	s.set_up(3, 1, src)
	s.start()
	obj:radiation += 50
	randmutb(obj)
	domutcheck(obj,null)
	spawn(0)
		qdel(src)

/obj/structure/mine/proc/triggerstun(obj)
	if(ismob(obj))
		var/mob/M = obj
		M.Stun(30)
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread()
	s.set_up(3, 1, src)
	s.start()
	spawn(0)
		qdel(src)

/obj/structure/mine/proc/triggern2o(obj)
	//example: n2o triggerproc
	//note: im lazy

	for (var/turf/simulated/floor/target in range(1,src))
		if(!target.blocks_air)
			target.assume_gas(GAS_N2O, 30)

	spawn(0)
		qdel(src)

/obj/structure/mine/proc/triggerphoron(obj)
	for (var/turf/simulated/floor/target in range(1,src))
		if(!target.blocks_air)
			target.assume_gas(GAS_PHORON, 30)

			target.hotspot_expose(1000, CELL_VOLUME)

	spawn(0)
		qdel(src)

/obj/structure/mine/proc/triggerkick(obj)
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(3, 1, src)
	s.start()
	qdel(obj:client)
	spawn(0)
		qdel(src)

/obj/structure/mine/proc/explode(obj)
	explosion(loc, 3, EX_ACT_HEAVY)
	spawn(0)
		qdel(src)

/obj/structure/mine/dnascramble
	name = "Radiation Mine"
	icon_state = "uglymine"
	triggerproc = "triggerrad"

/obj/structure/mine/phoron
	name = "Phoron Mine"
	icon_state = "uglymine"
	triggerproc = "triggerphoron"

/obj/structure/mine/kick
	name = "Kick Mine"
	icon_state = "uglymine"
	triggerproc = "triggerkick"

/obj/structure/mine/n2o
	name = "N2O Mine"
	icon_state = "uglymine"
	triggerproc = "triggern2o"

/obj/structure/mine/stun
	name = "Stun Mine"
	icon_state = "uglymine"
	triggerproc = "triggerstun"

/obj/structure/mine/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover) && mover.checkpass(PASS_FLAG_GRILLE))
		return 1
	else
		return ..()
