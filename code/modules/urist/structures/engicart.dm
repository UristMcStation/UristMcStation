/obj/structure/engineeringcart //icons http://puu.sh/cHtzk/dc132f1aa6.dmi
	name = "engineering cart"
	desc = "A cart for storing engineering items."
	icon = 'icons/urist/structures&machinery/engicart.dmi'
	icon_state = "cart"
	anchored = FALSE
	density = TRUE
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	//copypaste sorry
	var/amount_per_transfer_from_this = 5 //shit I dunno, adding this so syringes stop runtime erroring. --NeoFite
	var/obj/item/stack/material/glass/myglass = null
	var/obj/item/stack/material/steel/mymetal = null
	var/obj/item/stack/material/plasteel/myplasteel = null
	var/obj/item/device/flashlight/myflashlight = null
	var/obj/item/storage/toolbox/mechanical/mybluetoolbox = null
	var/obj/item/storage/toolbox/electrical/myyellowtoolbox = null
	var/obj/item/storage/toolbox/emergency/myredtoolbox = null
	var/obj/item/taperoll/engineering/myengitape = null
	var/obj/item/storage/briefcase/inflatable/myinflate = null

/obj/structure/engineeringcart/proc/put_in_cart(obj/item/I, mob/user)
	user.drop_item()
	I.loc = src
	updateUsrDialog()
	to_chat(user, "<span class='notice'>You put [I] into [src].</span>")
	return

/obj/structure/engineeringcart/use_tool(obj/item/I, mob/living/user, list/click_params)
	var/fail_msg = "<span class='notice'>There is already one of those in [src].</span>"
	if(istype(I, /obj/item/stack/material/glass))
		if(!myglass)
			put_in_cart(I, user)
			myglass=I
			update_icon()
		else
			to_chat(user, fail_msg)

	else if(istype(I, /obj/item/stack/material/steel))
		if(!mymetal)
			put_in_cart(I, user)
			mymetal=I
			update_icon()
		else
			to_chat(user, fail_msg)

	else if(istype(I, /obj/item/stack/material/plasteel))
		if(!myplasteel)
			put_in_cart(I, user)
			myplasteel=I
			update_icon()
		else
			to_chat(user, fail_msg)

	else if(istype(I, /obj/item/device/flashlight))
		if(!myflashlight)
			put_in_cart(I, user)
			myflashlight=I
			update_icon()
		else
			to_chat(user, fail_msg)

	else if(istype(I, /obj/item/storage/toolbox/mechanical))
		if(!mybluetoolbox)
			put_in_cart(I, user)
			mybluetoolbox=I
			update_icon()
		else
			to_chat(user, fail_msg)

	else if(istype(I, /obj/item/storage/toolbox/electrical))
		if(!myyellowtoolbox)
			put_in_cart(I, user)
			myyellowtoolbox=I
			update_icon()
		else
			to_chat(user, fail_msg)

	else if(istype(I, /obj/item/storage/toolbox/emergency))
		if(!myredtoolbox)
			put_in_cart(I, user)
			myredtoolbox=I
			update_icon()
		else
			to_chat(user, fail_msg)

	else if(istype(I, /obj/item/taperoll/engineering))
		if(!myengitape)
			put_in_cart(I, user)
			myengitape=I
			update_icon()
		else
			to_chat(user, fail_msg)

	else if(istype(I, /obj/item/storage/briefcase/inflatable))
		if(!myinflate)
			put_in_cart(I, user)
			myinflate=I
			update_icon()
		else
			to_chat(user, fail_msg)

/obj/structure/engineeringcart/attack_hand(mob/user)
	user.set_machine(src)
	var/dat
	if(myglass)
		dat += "<a href='?src=\ref[src];glass=1'>[myglass.name]</a><br>"
	if(mymetal)
		dat += "<a href='?src=\ref[src];metal=1'>[mymetal.name]</a><br>"
	if(myplasteel)
		dat += "<a href='?src=\ref[src];plasteel=1'>[myplasteel.name]</a><br>"
	if(myflashlight)
		dat += "<a href='?src=\ref[src];flashlight=1'>[myflashlight.name]</a><br>"
	if(mybluetoolbox)
		dat += "<a href='?src=\ref[src];bluetoolbox=1'>[mybluetoolbox.name]</a><br>"
	if(myredtoolbox)
		dat += "<a href='?src=\ref[src];redtoolbox=1'>[myredtoolbox.name]</a><br>"
	if(myyellowtoolbox)
		dat += "<a href='?src=\ref[src];yellowtoolbox=1'>[myyellowtoolbox.name]</a><br>"
	if(myengitape)
		dat += "<a href='?src=\ref[src];engitape=1'>[myengitape.name]</a><br>"
	if(myinflate)
		dat += "<a href='?src=\ref[src];inflate=1'>[myinflate.name]</a><br>"
	var/datum/browser/popup = new(user, "engicart", name, 240, 160)
	popup.set_content(dat)
	popup.open()

/obj/structure/engineeringcart/Topic(href, href_list)
	if(!in_range(src, usr))
		return
	if(!isliving(usr))
		return
	var/mob/living/user = usr
	if(href_list["glass"])
		if(myglass)
			user.put_in_hands(myglass)
			to_chat(user, "<span class='notice'>You take [myglass] from [src].</span>")
			myglass = null
	if(href_list["metal"])
		if(mymetal)
			user.put_in_hands(mymetal)
			to_chat(user, "<span class='notice'>You take [mymetal] from [src].</span>")
			mymetal = null
	if(href_list["plasteel"])
		if(myplasteel)
			user.put_in_hands(myplasteel)
			to_chat(user, "<span class='notice'>You take [myplasteel] from [src].</span>")
			myplasteel = null
	if(href_list["flashlight"])
		if(myflashlight)
			user.put_in_hands(myflashlight)
			to_chat(user, "<span class='notice'>You take [myflashlight] from [src].</span>")
			myflashlight = null
	if(href_list["bluetoolbox"])
		if(mybluetoolbox)
			user.put_in_hands(mybluetoolbox)
			to_chat(user, "<span class='notice'>You take [mybluetoolbox] from [src].</span>")
			mybluetoolbox = null
	if(href_list["redtoolbox"])
		if(myredtoolbox)
			user.put_in_hands(myredtoolbox)
			to_chat(user, "<span class='notice'>You take [myredtoolbox] from [src].</span>")
			myredtoolbox = null
	if(href_list["yellowtoolbox"])
		if(myyellowtoolbox)
			user.put_in_hands(myyellowtoolbox)
			to_chat(user, "<span class='notice'>You take [myyellowtoolbox] from [src].</span>")
			myyellowtoolbox = null
	if(href_list["engitape"])
		if(myengitape)
			user.put_in_hands(myengitape)
			to_chat(user, "<span class='notice'>You take [myengitape] from [src].</span>")
			myengitape = null
	if(href_list["inflate"])
		if(myinflate)
			user.put_in_hands(myinflate)
			to_chat(user, "<span class='notice'>You take [myinflate] from [src].</span>")
			myinflate = null

	update_icon()
	updateUsrDialog()

/obj/structure/engineeringcart/on_update_icon()
	overlays = null
	if(myglass)
		overlays += "cart_glass"
	if(mymetal)
		overlays += "cart_metal"
	if(myplasteel)
		overlays += "cart_plasteel"
	if(myflashlight)
		overlays += "cart_flashlight"
	if(mybluetoolbox)
		overlays += "cart_bluetoolbox"
	if(myredtoolbox)
		overlays += "cart_redtoolbox"
	if(myyellowtoolbox)
		overlays += "cart_yellowtoolbox"
	if(myengitape)
		overlays += "cart_engitape"
	if(myinflate)
		overlays += "cart_inflate"
