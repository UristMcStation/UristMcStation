/obj/machinery/deepfryer
	name = "deep fryer"
	icon = 'icons/obj/cooking_machines.dmi'
	desc = "Deep fried <i>everything</i>."
	icon_state = "fryer_off"
	layer = 2.9
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 5
	var/on = 0 // Is it deep frying already?

/obj/machinery/deepfryer/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(on)
		user << "The machine is already active, please wait."
		return
	if(istype(O, /obj/item/weapon/grab)||istype(O, /obj/item/tk_grab))
		user << "<span class='warning'>That isn't going to fit.</span>"
		return
	if(istype(O, /obj/item/weapon/reagent_containers/glass/))
		user << "That would probably break the deep fryer."
		return
	else
		user << "<span class='notice'>You put [O] into [src].</span>"
		on = 1
		user.drop_item()
		O.loc = src
		icon_state = "fryer_on"
		sleep(200)
		icon_state = "fryer_off"
		on = 0
		var/obj/item/weapon/reagent_containers/food/snacks/deepfryholder/S = new(get_turf(src))
		if(istype(O, /obj/item/weapon/reagent_containers/))
			var/obj/item/weapon/reagent_containers/food = O
			food.reagents.trans_to(S, food.reagents.total_volume)
		S.color = "#FFAD33"
		S.icon = O.icon
		S.icon_state = O.icon_state
		S.name = "deep fried [O.name]"
		S.desc = O.desc
		playsound(src.loc, 'sound/machines/ding.ogg', 50, 1)
		del(O)
		return