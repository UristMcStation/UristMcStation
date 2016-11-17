/obj/item/device/saxophone
	name = "saxophone"
	desc = "A shiny bronze saxophone."
	icon = 'icons/urist/items/tools.dmi'
	icon_state = "saxophone"
	item_state = "saxophone"
	urist_only = 1
	force = 10
	attack_verb = list("played metal on", "crashed", "banged on")
	var/next_sound = 0
	var/use_sound = 'sound/urist/WAN1.ogg'

/obj/item/device/saxophone/attack_self(var/mob/user)
	if(world.time < next_sound)
		user << "You need time to catch your breath before you can play again."
		return
	playsound(user.loc, use_sound, 100, 1, 1)
	next_sound = world.time + 2400