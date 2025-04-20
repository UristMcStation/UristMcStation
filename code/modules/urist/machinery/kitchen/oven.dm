/obj/machinery/cooking
	name = "oven"
	desc = "Cookies are ready, dear."
	icon = 'icons/urist/kitchen.dmi'
	icon_state = "oven_off"
	var/orig = "oven"
	var/production_meth = "cooking"
	layer = 2.9
	density = TRUE
	anchored = TRUE
	use_power = 1
	var/grown_only = 0
	idle_power_usage = 5
	var/on = FALSE	//Is it making food already?
	var/list/food_choices = list()
/obj/machinery/cooking/New()
	..()
	updatefood()

/obj/machinery/cooking/use_tool(obj/item/I, mob/living/user, list/click_params)
	SHOULD_CALL_PARENT(FALSE)
	if(on)
		to_chat(user, "The machine is already running.")
		return TRUE
	if(!istype(I,/obj/item/reagent_containers/food/snacks))
		to_chat(user, "That isn't food.")
		return TRUE
	if(!istype(I,/obj/item/reagent_containers/food/snacks/grown) && grown_only)
		to_chat(user, "You can only still grown items.")
		return TRUE
	else
		var/obj/item/reagent_containers/food/snacks/F = I
		var/obj/item/reagent_containers/food/snacks/customizable/C
		C = input("Select food to make.", "Cooking", C) in food_choices
		if(!C)
			return TRUE
		else
			to_chat(user, "You put [F] into [src] for [production_meth].")
			user.drop_item()
			F.loc = src
			on = TRUE
			icon_state = "[orig]_on"
			sleep(100)
			on = FALSE
			icon_state = "[orig]_off"
			C.loc = get_turf(src)
			C.use_tool(F, user, click_params)
			playsound(loc, 'sound/machines/ding.ogg', 50, 1)
			updatefood()
			return TRUE

/obj/machinery/cooking/proc/updatefood()
	return

/obj/machinery/cooking/oven
	name = "oven"
	desc = "Cookies are ready, dear."
	icon_state = "oven_off"

/obj/machinery/cooking/oven/updatefood()
	for(var/U in food_choices)
		food_choices.Remove(U)
	for(var/U in typesof(/obj/item/reagent_containers/food/snacks/customizable/cook)-(/obj/item/reagent_containers/food/snacks/customizable/cook))
		var/obj/item/reagent_containers/food/snacks/customizable/cook/V = new U
		src.food_choices += V
	return

/obj/machinery/cooking/candy
	name = "candy machine"
	desc = "Get yer box of deep fried deep fried deep fried deep fried cotton candy cereal sandwich cookies here!"
	icon_state = "mixer_off"
	orig = "mixer"
	production_meth = "candizing"

/obj/machinery/cooking/candy/updatefood()
	for(var/U in food_choices)
		food_choices.Remove(U)
	for(var/U in typesof(/obj/item/reagent_containers/food/snacks/customizable/candy)-(/obj/item/reagent_containers/food/snacks/customizable/candy))
		var/obj/item/reagent_containers/food/snacks/customizable/candy/V = new U
		src.food_choices += V
	return


/obj/machinery/cooking/still
	name = "still"
	desc = "Alright, so, t'make some moonshine, fust yo' gotta combine some of this hyar egg wif th' deep fried sausage."
	icon_state = "still_off"
	orig = "still"
	grown_only = 1
	production_meth = "brewing"

/obj/machinery/cooking/still/updatefood()
	for(var/U in food_choices)
		food_choices.Remove(U)
	for(var/U in typesof(/obj/item/reagent_containers/food/drinks/bottle/customizable)-(/obj/item/reagent_containers/food/drinks/bottle/customizable))
		var/obj/item/reagent_containers/food/drinks/bottle/customizable/V = new U
		src.food_choices += V
	return
