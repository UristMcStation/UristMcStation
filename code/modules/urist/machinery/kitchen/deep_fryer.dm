/obj/machinery/deepfryer
	name = "deep fryer"
	desc = "Deep fried <i>everything</i>."
	icon = 'icons/urist/kitchen.dmi'
	icon_state = "fryer_off"
	layer = 2.9
	density = TRUE
	anchored = TRUE
	use_power = 1
	idle_power_usage = 5
	var/on = FALSE	//Is it deep frying already?
	var/obj/item/frying = null	//What's being fried RIGHT NOW?

/obj/machinery/deepfryer/examine()
	..()
	if(frying)
		to_chat(usr, "You can make out [frying] in the oil.")

/obj/machinery/deepfryer/attackby(obj/item/I, mob/user)
	if(on)
		to_chat(user, "<span class='notice'>[src] is still active!</span>")
		return
	if(!istype(I, /obj/item/reagent_containers/food/snacks))
		to_chat(user, "<span class='warning'>Budget cuts won't let you put that in there.</span>")
		return
	if(istype(I, /obj/item/reagent_containers/food/snacks/deepfryholder))
		to_chat(user, "<span class='userdanger'>You cannot doublefry.</span>")
		return
	else
		to_chat(user, "<span class='notice'>You put [I] into [src].</span>")
		on = TRUE
		user.drop_item()
		frying = I
		frying.loc = src
		icon_state = "fryer_on"
		sleep(200)

		if(frying && frying.loc == src)
			var/obj/item/reagent_containers/food/snacks/deepfryholder/S = new(get_turf(src))
			if(istype(frying, /obj/item/reagent_containers))
				var/obj/item/reagent_containers/food = frying
				food.reagents.trans_to(S, food.reagents.total_volume)
			S.color = "#ffad33"
			S.icon = frying.icon
			S.SetOverlays(I.overlays)
			S.icon_state = frying.icon_state
			S.name = "deep fried [frying.name]"
			S.desc = I.desc
			frying.loc = S	//this might be a bad idea.

		icon_state = "fryer_off"
		on = FALSE
		playsound(src.loc, 'sound/machines/ding.ogg', 50, 1)


/obj/machinery/deepfryer/attack_hand(mob/user)
	if(on && frying)
		to_chat(user, "<span class='notice'>You pull [frying] from [src]! It looks like you were just in time!</span>")
		user.put_in_hands(frying)
		frying = null
		return
	..()
