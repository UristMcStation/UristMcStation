/obj/machinery/foodgrill
	name = "grill"
	desc = "Backyard grilling, IN SPACE."
	icon = 'icons/urist/kitchen.dmi'
	icon_state = "grill_off"
	layer = 2.9
	density = TRUE
	anchored = TRUE
	use_power = 1
	idle_power_usage = 5
	var/on = FALSE	//Is it grilling food already?

/obj/machinery/foodgrill/attackby(obj/item/I, mob/user)
	if(on)
		to_chat(user, "<span class='notice'>[src] is already processing, please wait.</span>")
		return
	if(istype(I, /obj/item/grab)||istype(I, /obj/item/tk_grab))
		to_chat(user, "<span class='warning'>That isn't going to fit.</span>")
		return
//	if(!user.unEquip(I))
//		to_chat(user, "<span class='warning'>You cannot grill [I].</span>")
//		return
	else
		to_chat(user, "<span class='notice'>You put [I] onto [src].</span>")
		on = TRUE
		user.drop_item()
		I.loc = src
		icon_state = "grill_on"

		var/image/img = new(I.icon, I.icon_state)
		img.pixel_y = 5
		AddOverlays(img)
		sleep(200)
		ClearOverlays()
		img.color = "#c28566"
		AddOverlays(img)
		sleep(200)
		ClearOverlays()
		img.color = "#a34719"
		AddOverlays(img)
		sleep(50)
		ClearOverlays()

		on = FALSE
		icon_state = "grill_off"

		if(istype(I, /obj/item/reagent_containers))
			var/obj/item/reagent_containers/food = I
			food.reagents.add_reagent(/datum/reagent/nutriment, 10)
			food.reagents.trans_to(I, food.reagents.total_volume)
		I.loc = get_turf(src)
		I.color = "#a34719"
		var/tempname = I.name
		I.name = "grilled [tempname]"
