/obj/structure/alien/node
	name = "alien weed node"
	desc = "Some kind of strange, pulsating structure."
	icon_state = "weednode"
	health = 100
	layer = ABOVE_OBJ_LAYER
	opacity = 0

/obj/structure/alien/node/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/structure/alien/node/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/structure/alien/node/Process()
	if(locate(/obj/vine) in loc)
		return
	new/obj/vine(get_turf(src), SSplants.seeds["xenomorph"], start_matured = 1)
