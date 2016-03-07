//Holds items added specifically for the Paranoia mode

//Jet Fuel: silly replacement for C4 as a proof-of-concept
/obj/item/weapon/storage/box/syndie_kit/jetfuel
	name = "jet fuel kit"
	desc = "Certified chemical demolitions kit. May or may not melt steel beams."

/obj/item/weapon/storage/box/syndie_kit/jetfuel/New()
	..()
	new /obj/item/weapon/reagent_containers/glass/beaker/vial/random/jetfuel(src)

/obj/item/weapon/reagent_containers/glass/beaker/vial/random/jetfuel
	random_reagent_list = list(
		list("fuel" = 15, "thermite" = 15)	= 9,
		list("fuel" = 30)	 = 1,) //10% chance, the mix cannot, in fact, melt steel beams.

/obj/item/weapon/reagent_containers/glass/beaker/vial/random/jetfuel/New()
	..()
	desc = "Contains jet fuel. Warning: results may vary!"

/obj/item/weapon/conspiracyintel
	name = "intel"
	desc = "A file containing top-secret data."
	gender = NEUTER
	icon = 'icons/urist/items/misc.dmi'
	icon_state = "folder"
	item_state = "paper"
	throwforce = 0
	w_class = 2
	throw_range = 2
	throw_speed = 1
	layer = 4
	pressure_resistance = 1
	var/uploaded = 0 //holds how many % of the file was uploaded
	var/value = 2 //how many TC it grants

/obj/item/weapon/conspiracyintel/New()
	..()
	var/datatype = pick("blueprints","financial records","operational reports","experimental data","access codes","personnel files")
	var/valuedesc
	value = pick(2,4,6)
	switch(value)
		if(2) valuedesc = "confidential"
		if(4) valuedesc = "secret"
		if(6) valuedesc = "top-secret"

	desc = "A file containing \a [valuedesc] [datatype]."

/obj/item/weapon/conspiracyintel/randomfaction
	var/faction

/obj/item/weapon/conspiracyintel/randomfaction/New()
	..()
	faction = pick("Buildaborg Group","Freemesons","Men in Grey","Aliuminati")

/*	icon = 'icons/obj/bureaucracy.dmi' //reenable this for faction-specific folder icons
	switch(faction)
		if("Buildaborg Group")
			icon_state = "folder_blue
		if("Freemesons")
			icon_state = "folder_red
		if("Men in Grey")
			icon_state = "folder_white
		if("Aliuminati")
			icon_state = "folder_yellow*/

	desc = "[desc] It seems to concern the assets of \the [faction]."

/obj/item/device/inteluplink
	name		= "Laptop Computer"
	desc		= "A clamshell portable computer. It is closed."
	icon		= 'icons/obj/computer3.dmi'
	icon_state	=  "adv-laptop-closed"
	item_state	=  "laptop-inhand"
	pixel_x		= 2
	pixel_y		= -3
	w_class		= 3
	var/open = 0
	var/uploading = 0
	var/stored_crystals = 0

/obj/item/device/inteluplink/verb/open_computer()
	set name = "Open Laptop"
	set category = "Object"
	set src in view(1)

	if(open)
		return

	if(usr.stat || usr.restrained() || usr.lying || !istype(usr, /mob/living))
		usr << "<span class='warning'>You can't do that.</span>"
		return

	if(!Adjacent(usr))
		usr << "You can't reach it."
		return

	if(!istype(loc,/turf))
		usr << "[src] is too bulky!  You'll have to set it down."
		return

	usr << "You open \the [src]."
	open = 1
	update_icon()

/obj/item/device/inteluplink/verb/close_computer()
	set name = "Close Laptop"
	set category = "Object"
	set src in view(1)

	if(!open)
		return

	if(usr.stat || usr.restrained() || usr.lying || !istype(usr, /mob/living))
		usr << "<span class='warning'>You can't do that.</span>"
		return

	if(!Adjacent(usr))
		usr << "You can't reach it."
		return

	if(!istype(loc,/turf))
		usr << "[src] is too bulky!  You'll have to set it down."
		return

	usr << "You close \the [src]."
	open = 0
	update_icon()

/obj/item/device/inteluplink/update_icon()
	if(open)
		icon_state = "adv-laptop"
		overlays.Cut()
		if(uploading)
			var/global/image/screen = image('icons/obj/computer3.dmi',icon_state="osod")
			overlays = list(screen)
			desc = "A clamshell portable computer. It is open."
		else
			var/global/image/screen = image('icons/obj/computer3.dmi',icon_state="command")
			overlays = list(screen)
			desc = "A clamshell portable computer. It is open. It seems that some kind of files are being transmitted."
	else
		icon_state = "adv-laptop-closed"
		desc = "A clamshell portable computer. It is closed."

/obj/item/device/inteluplink/attackby(var/obj/item/I,mob/user as mob)
	if(!open)
		return
	if(istype(I,/obj/item/weapon/conspiracyintel))
		var/obj/item/weapon/conspiracyintel/C = I
		uploading = 1
		update_icon()
		user.visible_message("<span class='notice'>[user] starts typing commands on the [src]'s keyboard frantically!.</span>","<span class='notice'>You start scanning and uploading the [C].</span>","<span class='notice'>You hear someone frantically typing on a keyboard.</span>")
		var/uploadamount = min(10,(100 - C.uploaded))
		while(do_after(user, 50))
			C.uploaded += uploadamount
			if(C.uploaded >= 100)
				qdel(C)
				uploading = 0
				update_icon()

				var/obj/item/device/uplink/hidden/suplink = user.mind.find_syndicate_uplink()
				var/crystals
				crystals = C.value
				if (!isnull(crystals))
					if(suplink)
						suplink.uses += crystals
					else
						stored_crystals += crystals

		if(C.uploaded < 100)
			user << "<span class='warning'>Upload aborted!</span>"

	if(stored_crystals)
		if(I.hidden_uplink)
			var/obj/item/device/uplink/hidden/suplink = I.hidden_uplink
			suplink.uses += stored_crystals
			stored_crystals = 0