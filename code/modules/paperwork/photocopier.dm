/obj/machinery/photocopier
	name = "photocopier"
	icon = 'icons/obj/machines/bureaucracy/photocopier.dmi'
	icon_state = "photocopier"
	var/insert_anim = "photocopier_animation"
	anchored = TRUE
	density = TRUE
	idle_power_usage = 30
	active_power_usage = 200
	power_channel = EQUIP
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_CLIMBABLE
	obj_flags = OBJ_FLAG_ANCHORABLE
	var/obj/item/copyitem = null	//what's in the copier!
	var/copies = 1	//how many copies to print!
	var/toner = 30 //how much toner is left! woooooo~
	var/maxcopies = 10	//how many copies can be copied at once- idea shamelessly stolen from bs12's copier!

/obj/machinery/photocopier/interface_interact(mob/user)
	interact(user)
	return TRUE

/obj/machinery/photocopier/interact(mob/user)
	user.set_machine(src)

	var/dat = "Photocopier<BR><BR>"
	if(copyitem)
		dat += "<a href='byond://?src=\ref[src];remove=1'>Remove Item</a><BR>"
		if(toner)
			dat += "<a href='byond://?src=\ref[src];copy=1'>Copy</a><BR>"
			dat += "Printing: [copies] copies."
			dat += "<a href='byond://?src=\ref[src];min=1'>-</a> "
			dat += "<a href='byond://?src=\ref[src];add=1'>+</a><BR><BR>"
	else if(toner)
		dat += "Please insert something to copy.<BR><BR>"
	if(istype(user,/mob/living/silicon))
		dat += "<a href='byond://?src=\ref[src];aipic=1'>Print photo from database</a><BR><BR>"
	dat += "Current toner level: [toner]"
	if(!toner)
		dat +="<BR>Please insert a new toner cartridge!"
	show_browser(user, dat, "window=copier")
	onclose(user, "copier")
	return

/obj/machinery/photocopier/OnTopic(user, href_list, state)
	if(href_list["copy"])
		for(var/i = 0, i < copies, i++)
			if(toner <= 0)
				break
			if (istype(copyitem, /obj/item/paper))
				copy(copyitem, 1)
				sleep(15)
			else if (istype(copyitem, /obj/item/photo))
				photocopy(copyitem)
				sleep(15)
			else if (istype(copyitem, /obj/item/paper_bundle))
				var/obj/item/paper_bundle/B = bundlecopy(copyitem)
				sleep(15*length(B.pages))
			else if (istype(copyitem, /obj/item/sample/print))
				fpcopy(copyitem)
				sleep(15)
			else
				to_chat(user, SPAN_WARNING("\The [copyitem] can't be copied by \the [src]."))
				break

			use_power_oneoff(active_power_usage)
		return TOPIC_REFRESH

	if(href_list["remove"])
		OnRemove(user)
		return TOPIC_REFRESH

	if(href_list["min"])
		if(copies > 1)
			copies--
		return TOPIC_REFRESH

	else if(href_list["add"])
		if(copies < maxcopies)
			copies++
		return TOPIC_REFRESH

	if(href_list["aipic"])
		if(!istype(user,/mob/living/silicon)) return

		if(toner >= 5)
			var/mob/living/silicon/tempAI = user
			var/obj/item/device/camera/siliconcam/camera = tempAI.silicon_camera

			if(!camera)
				return
			var/obj/item/photo/selection = camera.selectpicture()
			if (!selection)
				return

			var/obj/item/photo/p = photocopy(selection)
			if (p.desc == "")
				p.desc += "Copied by [tempAI.name]"
			else
				p.desc += " - Copied by [tempAI.name]"
			toner -= 5
			sleep(15)
		return TOPIC_REFRESH

/obj/machinery/photocopier/proc/OnRemove(mob/user)
	if(copyitem)
		user.put_in_hands(copyitem)
		to_chat(user, SPAN_NOTICE("You take \the [copyitem] out of \the [src]."))
		copyitem = null

/obj/machinery/photocopier/use_tool(obj/item/O, mob/living/user, list/click_params)
	if(istype(O, /obj/item/paper) || istype(O, /obj/item/photo) || istype(O, /obj/item/paper_bundle) || istype(O, /obj/item/sample/print))
		if(!copyitem)
			if(!user.unEquip(O, src))
				return TRUE
			copyitem = O
			to_chat(user, SPAN_NOTICE("You insert \the [O] into \the [src]."))
			flick(insert_anim, src)
			updateUsrDialog()
		else
			to_chat(user, SPAN_NOTICE("There is already something in \the [src]."))
		return TRUE

	if (istype(O, /obj/item/device/toner))
		if(toner <= 10) //allow replacing when low toner is affecting the print darkness
			if(!user.unEquip(O, src))
				return TRUE
			to_chat(user, SPAN_NOTICE("You insert the toner cartridge into \the [src]."))
			var/obj/item/device/toner/T = O
			toner += T.toner_amount
			qdel(O)
			updateUsrDialog()
		else
			to_chat(user, SPAN_NOTICE("This cartridge is not yet ready for replacement! Use up the rest of the toner."))
		return TRUE

	return ..()

/obj/machinery/photocopier/ex_act(severity)
	switch(severity)
		if(EX_ACT_DEVASTATING)
			qdel(src)
		if(EX_ACT_HEAVY)
			if(prob(50))
				qdel(src)
			else
				if(toner > 0)
					new /obj/decal/cleanable/blood/oil(get_turf(src))
					toner = 0
		else
			if(prob(50))
				if(toner > 0)
					new /obj/decal/cleanable/blood/oil(get_turf(src))
					toner = 0
	return

/obj/machinery/photocopier/proc/copy(obj/item/paper/copy, need_toner = TRUE, copy_admin = FALSE)
	var/copy_type = copy.type
	if (istype(copy, /obj/item/paper/admin) && !copy_admin) // Edge case for admin faxes so that they don't show the editing form
		copy_type = /obj/item/paper

	var/obj/item/paper/c = new copy_type(loc, copy.text, copy.name, copy.metadata, copy.language)

	c.color = COLOR_WHITE

	c.info = "<span style='color: [toner > 10 ? "#101010" : "#808080"]'>"
	var/copied = copy.info
	copied = replacetext(copied, "<span style='font-family: [c.deffont]; color:", "<span style='font-family: [c.deffont]; nocolor:")	//state of the art techniques in action
	copied = replacetext(copied, "<span style='font-family: [c.crayonfont]; color:", "<span style='font-family: [c.crayonfont]; nocolor:")	//This basically just breaks the existing color tag, which we need to do because the innermost tag takes priority.
	c.info += copied
	c.info += "</span>"
	c.SetName(copy.name) // -- Doohl
	c.fields = copy.fields
	c.stamps = copy.stamps
	c.stamped = copy.stamped
	c.ico = copy.ico
	c.offset_x = copy.offset_x
	c.offset_y = copy.offset_y
	var/image/img                                //and puts a matching

	for (var/j = 1 to min(length(copy.overlays), length(copy.ico))) //gray overlay onto the copy
		if (findtext(copy.ico[j], "cap") || findtext(copy.ico[j], "cent"))
			img = image('icons/obj/bureaucracy.dmi', "paper_stamp-circle")
		else if (findtext(copy.ico[j], "deny"))
			img = image('icons/obj/bureaucracy.dmi', "paper_stamp-x")
		else
			img = image('icons/obj/bureaucracy.dmi', "paper_stamp-dots")
		img.pixel_x = copy.offset_x[j]
		img.pixel_y = copy.offset_y[j]
		c.AddOverlays(img)
	c.updateinfolinks()
	if(need_toner)
		toner--
	if(toner == 0)
		visible_message(SPAN_NOTICE("A red light on \the [src] flashes, indicating that it is out of toner."))
	c.update_icon()
	return c

/obj/machinery/photocopier/proc/photocopy(obj/item/photo/photocopy, need_toner=1)
	var/obj/item/photo/p = photocopy.copy()
	p.dropInto(loc)

	if(toner > 10)	//plenty of toner, go straight greyscale
		p.img.MapColors(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(0,0,0))//I'm not sure how expensive this is, but given the many limitations of photocopying, it shouldn't be an issue.
		p.update_icon()
	else			//not much toner left, lighten the photo
		p.img.MapColors(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(100,100,100))
		p.update_icon()
	if(need_toner)
		toner -= 5	//photos use a lot of ink!
	if(toner < 0)
		toner = 0
		visible_message(SPAN_NOTICE("A red light on \the [src] flashes, indicating that it is out of toner."))

	return p

//If need_toner is 0, the copies will still be lightened when low on toner, however it will not be prevented from printing. TODO: Implement print queues for fax machines and get rid of need_toner
/obj/machinery/photocopier/proc/bundlecopy(obj/item/paper_bundle/bundle, need_toner=1)
	var/obj/item/paper_bundle/p = new /obj/item/paper_bundle (src)
	for(var/obj/item/W in bundle.pages)
		if(toner <= 0 && need_toner)
			toner = 0
			visible_message(SPAN_NOTICE("A red light on \the [src] flashes, indicating that it is out of toner."))
			break

		if(istype(W, /obj/item/paper))
			W = copy(W, need_toner)
		else if(istype(W, /obj/item/photo))
			W = photocopy(W, need_toner)
		W.forceMove(p)
		p.pages += W

	p.dropInto(loc)
	p.update_icon()
	p.icon_state = "paper_words"
	p.SetName(bundle.name)
	return p

/obj/machinery/photocopier/proc/fpcopy(obj/item/sample/print/fpcard, need_toner = TRUE)
	var/obj/item/sample/print/p = new /obj/item/sample/print (src)
	p.dropInto(loc)
	p.SetName(fpcard.name)
	p.evidence = fpcard.evidence
	p.object = fpcard.object
	if(need_toner)
		toner--
	if(toner < 1)
		visible_message(SPAN_NOTICE("A red light on \the [src] flashes, indicating that it is out of toner."))
	p.update_icon()
	return p

/obj/item/device/toner
	name = "toner cartridge"
	icon = 'icons/obj/toner_cartridge.dmi'
	icon_state = "tonercartridge"
	var/toner_amount = 30
	var/charges = 5
	var/max_charges = 5
