/* CONTAINS:
RPD
*/

#define PIPE_CARDINAL 1
#define PIPE_CORNERDIR 2
//Typed as visible for convenience, hidden/visible changes later on.

GLOBAL_LIST_INIT(atmos_pipe_recipes, list(
	"Universal Pipes" = list(
	new /datum/pipe_info/pipe("Straight Pipe", 0, PIPE_CARDINAL),
	new /datum/pipe_info/pipe("Corner Pipes", 1, PIPE_CORNERDIR),
	new /datum/pipe_info/pipe("Manifold",	5, PIPE_CARDINAL),
	new /datum/pipe_info/pipe("4-Way Manifold", 19, PIPE_CARDINAL),
	new /datum/pipe_info/pipe("Pipe cap", 20, PIPE_CARDINAL),
	),
	"Scrubber Pipes" = list(
	new /datum/pipe_info/pipe("Straight Pipe", 31, PIPE_CARDINAL),
	new /datum/pipe_info/pipe("Corner Pipe", 32, PIPE_CORNERDIR),
	new /datum/pipe_info/pipe("Manifold", 34, PIPE_CARDINAL),
	new /datum/pipe_info/pipe("4-Way Manifold", 36, PIPE_CARDINAL),
	new /datum/pipe_info/pipe("Pipe cap", 42, PIPE_CARDINAL),
	),
	"Supply Pipes" = list(
	new /datum/pipe_info/pipe("Straight Pipe", 29, PIPE_CARDINAL),
	new /datum/pipe_info/pipe("Corner Pipe", 30, PIPE_CORNERDIR),
	new /datum/pipe_info/pipe("Manifold", 33, PIPE_CARDINAL),
	new /datum/pipe_info/pipe("4-Way Manifold", 35, PIPE_CARDINAL),
	new /datum/pipe_info/pipe("Pipe cap", 41, PIPE_CARDINAL),
	),
	"Fuel Pipes" = list(
	new /datum/pipe_info/pipe("Straight Pipe", 45, PIPE_CARDINAL),
	new /datum/pipe_info/pipe("Corner Pipe", 46, PIPE_CORNERDIR),
	new /datum/pipe_info/pipe("Manifold", 47, PIPE_CARDINAL),
	new /datum/pipe_info/pipe("4-Way Manifold", 48, PIPE_CARDINAL),
	new /datum/pipe_info/pipe("Pipe cap", 51, PIPE_CARDINAL),
	),
	"Heat Exchange Pipes" = list(
	new /datum/pipe_info/pipe("Straight Pipe", 2, PIPE_CARDINAL),
	new /datum/pipe_info/pipe("Corner Pipe", 3, PIPE_CORNERDIR),
	new /datum/pipe_info/pipe("Junction", 6, PIPE_CARDINAL),
	),
	"Devices" = list(
	new /datum/pipe_info/pipe("Universal Connector", 28, PIPE_CARDINAL),
	new /datum/pipe_info/pipe("Omni Filter", 27, PIPE_CARDINAL),
	new /datum/pipe_info/pipe("Omni Mixer", 26, PIPE_CARDINAL),
	new /datum/pipe_info/pipe("Portable Connector", 4, PIPE_CARDINAL),
	new /datum/pipe_info/pipe("Valve", 8, PIPE_CARDINAL),
	new /datum/pipe_info/pipe("T-Valve", 18, PIPE_CARDINAL),
	new /datum/pipe_info/pipe("Digital Valve", 9, PIPE_CARDINAL),
	new /datum/pipe_info/pipe("Shutoff Valve", 44, PIPE_CARDINAL),
	new /datum/pipe_info/pipe("Pump", 10, PIPE_CARDINAL),
	new /datum/pipe_info/pipe("High Powered Pump", 16, PIPE_CARDINAL),
	new /datum/pipe_info/pipe("Pressure Regulator", 15, PIPE_CARDINAL),
	new /datum/pipe_info/pipe("Vent", 7, PIPE_CARDINAL),
	new /datum/pipe_info/pipe("Scrubber", 11, PIPE_CARDINAL),
	)
))

/datum/pipe_info
	var/name
	var/id
	var/pipedir
	var/pipedirdefault
	var/pipecost = 1
	var/list/pipedirections = list()
	var/list/cardinal	 = list(NORTH, SOUTH, EAST, WEST)
	var/list/cornerdirs	 = list(NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)

/datum/pipe_info/pipe/New(var/labelname, var/obj/machinery/atmospherics/path, var/pdir)
	name = labelname
	id = path
	pipedir = pdir
	if(pipedir == PIPE_CARDINAL)
		pipedirections = cardinal
	if(pipedir == PIPE_CORNERDIR)
		pipedirections = cornerdirs
	if(name == "Corner Pipe")
		pipedirdefault = cornerdirs[1]
	if(name != "Corner Pipe")
		pipedirdefault = cardinal[1]

/obj/item/weapon/rpd
	name = "rapid piping device"
	desc = "A rapid piping device. It has a receptacle for metal sheets and a number of controls for selecting pipe types."
	icon = 'icons/obj/items.dmi'
	icon_state = "rcd"
	opacity = 0
	density = 0
	anchored = 0.0
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	force = 10.0
	throwforce = 10.0
	throw_speed = 1
	throw_range = 5
	w_class = ITEM_SIZE_NORMAL
	origin_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 2)
	matter = list(DEFAULT_WALL_MATERIAL = 50000)
	var/datum/effect/effect/system/spark_spread/spark_system
	var/datum/pipe_info/activedesign
	var/active_category
	var/active_direction

/obj/item/weapon/rpd/New()
	if(!activedesign)
		activedesign = GLOB.atmos_pipe_recipes[GLOB.atmos_pipe_recipes[1]][1]
	active_category = GLOB.atmos_pipe_recipes[1]
	active_direction = activedesign.pipedirdefault

/obj/item/weapon/rpd/attack_self(mob/user)
	active_category = next_in_list(active_category, GLOB.atmos_pipe_recipes)
	to_chat(user, "<span class='notice'>Selected [active_category].</span>")
	playsound(src.loc, 'sound/effects/pop.ogg', 50, 0)
	activedesign = GLOB.atmos_pipe_recipes[active_category][1]

/obj/item/weapon/rpd/AltClick(mob/user)
	activedesign = input(user, "Please select design") as null|anything in list(GLOB.atmos_pipe_recipes[active_category])
	to_chat(user, "<span class='notice'>Selected [activedesign.name].</span>")
	playsound(src.loc, 'sound/effects/pop.ogg', 50, 0)
	active_direction = activedesign.pipedirdefault




/*
/obj/item/weapon/rpd/AltClick(mob/user)
	activedesign = next_in_list(activedesign, GLOB.atmos_pipe_recipes[active_category])
	to_chat(user, "<span class='notice'>Selected [activedesign.name].</span>")
	playsound(src.loc, 'sound/effects/pop.ogg', 50, 0)
	active_direction = activedesign.pipedirdefault
*/
/obj/item/weapon/rpd/CtrlClick(mob/user)
	active_direction = next_in_list(active_direction, activedesign.pipedirections)
	var/directionname
	switch(active_direction)
		if(NORTH)
			directionname = "Vertical"
		if(SOUTH)
			directionname = "Vertical"
		if(EAST)
			directionname = "Horizontal"
		if(WEST)
			directionname = "Horizontal"
		if(NORTHEAST)
			directionname = "North-East"
		if(SOUTHEAST)
			directionname = "South-East"
		if(NORTHWEST)
			directionname = "North-West"
		if(SOUTHWEST)
			directionname = "South-West"
	to_chat(user, "<span class='notice'>Pipe Direction is now: [directionname].</span>")
	playsound(src.loc, 'sound/effects/pop.ogg', 50, 0)

/obj/item/weapon/rpd/afterattack(var/atom/A, var/mob/user, proximity, params)
	if(!proximity)
		return
	var/obj/item/weapon/wrench/W = new /obj/item/weapon/wrench(src) //This is such a hack, but pipecode is godawful.
	var/p_type = activedesign.id
	var/p_dir = active_direction
	var/obj/item/pipe/P = new (get_turf(A), pipe_type=p_type, dir=p_dir)
	P.update()
	P.attackby(W, user)
	qdel(W)
	if(P)
		qdel(P)