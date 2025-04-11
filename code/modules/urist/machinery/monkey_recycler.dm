/* TODO: Update to refactored grab system
/obj/machinery/monkey_recycler
	name = "monkey recycler"
	desc = "A machine used for recycling dead monkeys into monkey cubes. It requires 5 monkeys per cube."
	icon = 'icons/obj/machines/kitchen.dmi'
	icon_state = "grinder"
	layer = 2.9
	density = TRUE
	anchored = TRUE
	use_power = 1
	idle_power_usage = 5
	active_power_usage = 50
	var/grinded = 0


/obj/machinery/monkey_recycler/attackby(obj/item/O as obj, var/mob/user as mob)

	if (src.stat != 0) //NOPOWER etc
		return
	if (istype(O, /obj/item/grab))
		var/obj/item/grab/G = O
		var/grabbed = G.affecting
		if(istype(grabbed, /mob/living/carbon/human/monkey))
			var/mob/living/carbon/human/monkey/target = grabbed
			if(target.stat == 0)
				to_chat(user, "<span class='warning'> The monkey is struggling far too much to put it in the recycler.</span>")
			else
				user.drop_item()
				qdel(target)
				to_chat(user, "<span class='notice'> You stuff the monkey in the machine.</span>")
				playsound(src.loc, 'sound/machines/juicer.ogg', 50, 1)
				use_power(500)
				src.grinded++
				to_chat(user, "<span class='notice'> The machine now has [grinded] monkey\s worth of material stored.</span>")

		else
			to_chat(user, "<span class='warning'> The machine only accepts monkeys!</span>")
	return

/obj/machinery/monkey_recycler/attack_hand(mob/user as mob)
	if (src.stat != 0) //NOPOWER etc
		return
	if(grinded >= 5)
		to_chat(user, "<span class='notice'> The machine hisses loudly as it condenses the grinded monkey meat. After a moment, it dispenses a brand new monkey cube.</span>")
		playsound(src.loc, 'sound/machines/hiss.ogg', 50, 1)
		grinded -= 5
		new /obj/item/reagent_containers/food/snacks/monkeycube/wrapped(src.loc)
		to_chat(user, "<span class='notice'> The machine's display flashes that it has [grinded] monkeys worth of material left.</span>")
	else
		to_chat(user, "<span class='warning'> The machine needs at least 5 monkeys worth of material to produce a monkey cube. It only has [grinded].</span>")
	return
*/
