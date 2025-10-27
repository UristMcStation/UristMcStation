/obj/machinery/carpentry
	var/sheets = 0
	var/busy = 0
	use_power = 1
	idle_power_usage = 10
	anchored = TRUE
	density = TRUE
	icon = 'icons/urist/structures&machinery/machinery.dmi'


/obj/machinery/carpentry/woodprocessor
	name = "pulp and paper processor"
	desc = "A machine used for processing wood into cardboard or paper."
	icon_state = "paper"
	active_power_usage = 800
	construct_state = /singleton/machine_construction/default/panel_closed

/obj/machinery/carpentry/woodprocessor/use_tool(obj/item/I, mob/living/user, list/click_params)

	if(istype(I, /obj/item/stack/material/wood))
		if(busy)
			to_chat(user, SPAN_WARNING("Can not do that while [src] is in use."))

		else if(anchored && !busy)
			to_chat(user, SPAN_NOTICE("You feed the wood into the [src]."))
			update_use_power(2)
			busy = 1
			spawn(10)
				flick("paper_anim",src)
				var/obj/item/stack/material/R = I
				sheets += R.amount
				R.use(R.amount)
				busy = 0
				update_use_power(1)

	if(istype(I, /obj/item/wrench))
		if(busy)
			to_chat(user, SPAN_WARNING("Can not do that while [src] is in use."))

		else
			if(anchored)
				anchored = FALSE
			else
				anchored = TRUE
			playsound(loc, 'sound/items/Ratchet.ogg', 100, 1)
			if(anchored)
				user.visible_message("[user] secures [src] to the floor.", "You secure [src] to the floor.")
			else
				user.visible_message("[user] unsecures [src] from the floor.", "You unsecure [src] from the floor.")

	else
		..()


/obj/machinery/carpentry/woodprocessor/attack_hand(mob/user as mob)
	if(sheets)

		var/t = "<B>Wood Processor</B><br><br>Stored Sheets: [sheets]<br>"
		t += "<A href='byond://?src=\ref[src];on1=Cardboard'>Cardboard</A><br>"
		t += "<A href='byond://?src=\ref[src];on2=PackageWrap'>Package Wrap</A><br>"
		t += "<A href='byond://?src=\ref[src];on3=Paper'>Paper</A><br>"
		t += "<A href='byond://?src=\ref[src];on4=RollingPapers'>Rolling Papers</A><br>"

		show_browser(user, t, "window=woodprocessor;size=300x300")

	else
		to_chat(user, SPAN_NOTICE("There's no wood stored in the [src]!"))

/obj/machinery/carpentry/woodprocessor/Topic(href, href_list) //still instantly creates stuff, but eh. Space magic.
	..()

	if(anchored && !busy)
		if(sheets)
			if( href_list["on1"] )
				var/obj/item/stack/material/cardboard/W = new /obj/item/stack/material/cardboard(src.loc)
				if(sheets >= 50)
					sheets -= 50
					W.amount = 50
				else
					W.amount = sheets
					sheets -= W.amount
					return

			if( href_list["on2"] )
				var/obj/item/stack/package_wrap/W = new(get_turf(src))
				if(sheets >= 25)
					sheets -= 25
					W.amount = 25
				else
					W.amount = sheets
					sheets -= W.amount
					return

			if( href_list["on3"] )
				new /obj/item/paper(get_turf(src))
				sheets -= 1
				return

			if( href_list["on4"] )
				new /obj/item/storage/fancy/rollingpapers(get_turf(src))
				sheets -= 1
				return
		else
			to_chat(usr, SPAN_NOTICE("There's no wood stored in the [src]!"))

	else if(busy)
		to_chat(usr, SPAN_NOTICE("The pulp and paper processor is busy right now."))

/obj/machinery/carpentry/woodprocessor/dismantle()
	var/obj/item/stack/material/wood/W = new /obj/item/stack/material/wood(src.loc)
	W.amount = sheets
	..()
