//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/machinery/computer/prisoner
	name = "prisoner management console"
	icon = 'icons/obj/machines/computer.dmi'
	icon_keyboard = "security_key"
	icon_screen = "explosive"
	light_color = "#a91515"
	req_access = list(access_armory)
	machine_name = "prison management console"
	machine_desc = "Prison management consoles display a readout of active tracking and chemical implants, and allows for remote activation of them."
	var/id = 0.0
	var/temp = null
	var/status = 0
	var/timeleft = 60
	var/stop = 0.0
	var/screen = 0 // 0 - No Access Denied, 1 - Access allowed


/obj/machinery/computer/prisoner/attack_ai(mob/user as mob)
	if(!ai_can_interact(user))
		return
	return src.attack_hand(user)

/obj/machinery/computer/prisoner/attack_hand(mob/user as mob)
	if(..())
		return
	user.set_machine(src)
	var/dat
	dat += "<B>Prisoner Implant Manager System</B><BR>"
	if(screen == 0)
		dat += "<HR><A href='byond://?src=\ref[src];lock=1'>Unlock Console</A>"
	else if(screen == 1)
		dat += "<HR>Chemical Implants<BR>"
		var/turf/Tr = null
		for(var/obj/item/implant/chem/C in world)
			Tr = get_turf(C)
			if((Tr) && !AreConnectedZLevels(Tr.z, src.z))	continue // Out of range
			if(!C.implanted) continue
			dat += "[C.imp_in.name] | Remaining Units: [C.reagents.total_volume] | Inject: "
			dat += "<A href='byond://?src=\ref[src];inject1=\ref[C]'>([SPAN_COLOR("red", "(1)")])</A>"
			dat += "<A href='byond://?src=\ref[src];inject5=\ref[C]'>([SPAN_COLOR("red", "(5))")]</A>"
			dat += "<A href='byond://?src=\ref[src];inject10=\ref[C]'>([SPAN_COLOR("red", "(10)")])</A><BR>"
			dat += "********************************<BR>"
		dat += "<HR>Tracking Implants<BR>"
		for(var/obj/item/implant/tracking/T in world)
			Tr = get_turf(T)
			if((Tr) && !AreConnectedZLevels(Tr.z, src.z))	continue // Out of range
			if(!T.implanted) continue
			var/loc_display = "Space"
			var/mob/living/carbon/M = T.imp_in
			if(!istype(M.loc, /turf/space))
				var/turf/mob_loc = get_turf(M)
				loc_display = mob_loc.loc
			if(T.malfunction)
				loc_display = pick(teleportlocs)
			dat += "ID: [T.id] | Location: [loc_display]<BR>"
			dat += "<A href='byond://?src=\ref[src];warn=\ref[T]'>([SPAN_COLOR("red", "<i>Message Holder</i>")])</A> |<BR>"
			dat += "********************************<BR>"
		dat += "<HR><A href='byond://?src=\ref[src];lock=1'>Lock Console</A>"

	show_browser(user, dat, "window=computer;size=400x500")
	onclose(user, "computer")
	return


/obj/machinery/computer/prisoner/Process()
	if(!..())
		src.updateDialog()
	return


/obj/machinery/computer/prisoner/Topic(href, href_list)
	if(..())
		return
	if((usr.contents.Find(src) || (in_range(src, usr) && isturf(loc))) || (istype(usr, /mob/living/silicon)))
		usr.set_machine(src)

		if(href_list["inject1"])
			var/obj/item/implant/I = locate(href_list["inject1"])
			if(I)	I.activate(1)

		else if(href_list["inject5"])
			var/obj/item/implant/I = locate(href_list["inject5"])
			if(I)	I.activate(5)

		else if(href_list["inject10"])
			var/obj/item/implant/I = locate(href_list["inject10"])
			if(I)	I.activate(10)

		else if(href_list["lock"])
			if(src.allowed(usr))
				screen = !screen
			else
				to_chat(usr, "Unauthorized Access.")

		else if(href_list["warn"])
			var/warning = sanitize(input(usr,"Message:","Enter your message here!",""))
			if(!warning) return
			var/obj/item/implant/I = locate(href_list["warn"])
			if((I)&&(I.imp_in))
				var/mob/living/carbon/R = I.imp_in
				to_chat(R, SPAN_NOTICE("You hear a voice in your head saying: '[warning]'"))

	src.updateUsrDialog()
	return
