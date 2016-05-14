//stuff that doesn't go anywhere else.

/obj/effect/stop/Uncross(atom/movable/O)
	if(victim == O)
		return 0
	return 1

//vg color setup stuff

var/default_colour_matrix = list(1,0,0,0,\
								 0,1,0,0,\
								 0,0,1,0,\
								 0,0,0,1)

var/global/list/NOIRMATRIX = list(0.66,0.33,0.33,0,\
				 				  0.33,0.33,0.33,0,\
								  0.33,0.33,0.33,0,\
								  0.00,0.00,0.00,1,\
								  0.00,0.00,0.00,0)


var/global/list/bad_changing_colour_ckeys = list()

/var/global/respawntime = 12000 //default 20 mins, adding the var so we can change it for different roundtypes. gotta keep the action rollin'

/obj/effect/landmark/costume/monkeysuit/Initialize()
	. = ..()
	new /obj/item/clothing/suit/monkeysuit(src.loc)
	return INITIALIZE_HINT_QDEL