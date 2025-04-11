//Holds items added specifically for the Paranoia mode

//Jet Fuel: silly replacement for C4 as a proof-of-concept
/obj/item/storage/box/syndie_kit/jetfuel
	name = "jet fuel kit"
	desc = "Certified chemical demolitions kit. May or may not melt steel beams."

/obj/item/storage/box/syndie_kit/jetfuel/New()
	..()
	new /obj/item/reagent_containers/glass/beaker/vial/random/jetfuel(src)

/obj/item/reagent_containers/glass/beaker/vial/random/jetfuel
	random_reagent_list = list(
		list(/datum/reagent/fuel = 15, /datum/reagent/thermite = 15)	= 9,
		list(/datum/reagent/fuel = 30)	 = 1,) //10% chance, the mix cannot, in fact, melt steel beams.

/obj/item/reagent_containers/glass/beaker/vial/random/jetfuel/New()
	..()
	desc = "Contains jet fuel. Warning: results may vary!"

/obj/item/conspiracyintel
	name = "intel"
	desc = "A file containing top-secret data."
	gender = NEUTER
	icon = 'icons/urist/items/misc.dmi'
	icon_state = "conspiracyfolder"
	item_state = "paper"
	throwforce = 0
	w_class = 2
	throw_range = 2
	throw_speed = 1
	layer = 4
	var/value = 2 //how many TC it grants
	var/upload_id //for persistent uploads
	var/basedesc = "A file containing top-secret data."
	var/faction = "Broken Code Initiative"

/obj/item/conspiracyintel/New(loc = src.loc, presetconspiracy)
	..()
	if(presetconspiracy)
		faction = presetconspiracy
	var/datatype = pick("blueprints","financial records","operational reports","experimental data","access codes","personnel files","schematics","operation plans","communication frequencies")
	var/valuedesc
	value = pick(2,4,6)
	switch(value)
		if(2) valuedesc = "confidential"
		if(4) valuedesc = "secret"
		if(6) valuedesc = "top-secret"

	desc = "A file containing [valuedesc] [datatype]."
	basedesc = desc
	if(faction)
		desc = "[basedesc] It seems to concern the assets of \the [faction]."

		/*icon = 'icons/obj/bureaucracy.dmi' //reenable this for faction-specific folder icons
		switch(faction)
			if("Buildaborg Group")
				icon_state = "folder_blue
			if("Freemesons")
				icon_state = "folder_red
			if("Men in Grey")
				icon_state = "folder_white
			if("Aliuminati")
				icon_state = "folder_yellow*/

/obj/item/conspiracyintel/buildaborg
	faction = "Buildaborg Group"

/obj/item/conspiracyintel/freemesons
	faction = "Freemesons"

/obj/item/conspiracyintel/mig
	faction = "Men in Grey"

/obj/item/conspiracyintel/aliuminati
	faction = "Aliuminati"

/obj/item/conspiracyintel/random

/obj/item/conspiracyintel/random/New()

	faction = pick("Buildaborg Group","Freemesons","Men in Grey","Aliuminati")
	..()

/obj/item/device/inteluplink
	name		= "Laptop Computer"
	desc		= "A clamshell portable computer. It is closed."
	icon		= 'icons/urist/items/misc.dmi'
	icon_state	=  "adv-laptop-closed"
	item_state	=  "laptop-inhand"
	pixel_x		= 2
	pixel_y		= -3
	w_class		= 3
	var/open = 0
	var/uploading = 0
	var/stored_crystals = 0
	var/faction = "You shouldn't see this" 		//which faction receives the uploaded file - so the teams can't upload their own intel, as num
	var/alliedf = "You shouldn't see this" 		//one of the other factions, whose intel is not currently needed, as num
	var/cached_progress = 0 					//persistent progress - if you stop uploading, you can resume it later if it's the same file
	var/progress = 0 							//temporary progress
	var/lastuploaded = -1 						//caches id of the last intel item

/obj/item/device/inteluplink/AltClick()
	if(Adjacent(usr))
		if(!open)
			open_computer()
		else if(open)
			close_computer()

/obj/item/device/inteluplink/New(maker)
	..()
	if(maker)
		faction = maker

/obj/item/device/inteluplink/verb/open_computer()
	set name = "Open Laptop"
	set category = "Object"
	set src in view(1)

	if(open)
		return

	if(usr.stat || usr.restrained() || usr.lying || !istype(usr, /mob/living))
		to_chat(usr, "<span class='warning'>You can't do that.</span>")
		return

	if(!Adjacent(usr))
		to_chat(usr, "You can't reach it.")
		return

	if(!istype(loc,/turf))
		to_chat(usr, "[src] is too bulky!  You'll have to set it down.")
		return

	to_chat(usr, "You open \the [src].")
	open = 1
	w_class = 4
	update_icon()

/obj/item/device/inteluplink/verb/close_computer()
	set name = "Close Laptop"
	set category = "Object"
	set src in view(1)

	if(!open)
		return

	if(usr.stat || usr.restrained() || usr.lying || !istype(usr, /mob/living))
		to_chat(usr, "<span class='warning'>You can't do that.</span>")
		return

	if(!Adjacent(usr))
		to_chat(usr, "You can't reach it.")
		return

	if(!istype(loc,/turf))
		to_chat(usr, "[src] is too bulky!  You'll have to set it down.")
		return

	to_chat(usr, "You close \the [src].")
	open = 0
	w_class = 3
	update_icon()

/obj/item/device/inteluplink/on_update_icon()
	overlays.Cut()
	if(open)
		icon_state = "laptop"
		light_outer_range = 3
		if(uploading)
			var/global/image/screen = image('icons/obj/computer.dmi',icon_state="command")
			overlays = list(screen)
			desc = "A clamshell portable computer. It is open. It seems that some kind of files are being transmitted."
		else
			var/global/image/screen = image('icons/obj/computer.dmi',icon_state="generic")
			overlays = list(screen)
			desc = "A clamshell portable computer. It is open."
	else
		light_outer_range = 0
		icon_state = "adv-laptop-closed"
		desc = "A clamshell portable computer. It is closed."

/obj/item/device/inteluplink/attackby(obj/item/I,mob/user as mob)
	if(!open)
		return
	if(istype(I,/obj/item/conspiracyintel))
		var/obj/item/conspiracyintel/C = I
		if(cmptext(C.faction,faction))
			to_chat(user, "<span class='notice'>\The [C] you are trying to upload belongs to the faction you're trying to send it to.</span>")
			return
		if(cmptext(C.faction,alliedf))
			to_chat(user, "<span class='notice'>\The [faction] does not need any more data on [C.faction].</span>")
			return
		if(!(C.upload_id))
			C.upload_id = rand(1,9999) //should be more than enough to be unique
		if(lastuploaded == C.upload_id)
			progress = cached_progress
		else
			progress = 0
		lastuploaded = C.upload_id
		uploading = 1
		update_icon()
		user.visible_message("<span class='notice'>[user] starts typing commands on \the [src]'s keyboard frantically!</span>","<span class='notice'>You start scanning and uploading \the [C] to the [faction]'s databases.</span>","<span class='notice'>You hear someone frantically typing on a keyboard.</span>")
		var/uploadamount = min(5,(100 - progress))
		var/initial_obj_loc = C.loc
		while(do_after(user, 50, src, 0, 5))
			if(!(C.loc == initial_obj_loc))
				break
			if(!(open))
				break
			progress += uploadamount
			if(progress == (round(progress, 10))) //kind of an odd method, but cuts down on the spam
				to_chat(user, "<span class='notice'>Upload progress at: [progress]%</span>")
			if(progress >= 100)
				user.visible_message("<span class='notice'>\The [src] buzzes and shreds the [C] as a progress bar reaches completion.</span>","<span class='notice'>\The [src] buzzes and shreds the [C] as a progress bar reaches completion.</span>","<span class='notice'>You hear a buzz and the sound of utterly annihilated paper.</span>")
				if(prob(50))
					alliedf = C.faction
					to_chat(user, "<span class='notice'>A message from \the [faction] arrives: \")Thank you for your service. We will have no need for more data on [alliedf] for a while.\".</span>")
				uploading = 0
				progress = 0
				cached_progress = 0
				update_icon()

				var/crystals
				crystals = C.value
				if (!isnull(crystals))
					new /obj/item/stack/telecrystal(src.loc, crystals)
				qdel(C)
		if(progress < 100)
			cached_progress = progress
			uploading = 0
			update_icon()
			to_chat(user, "<span class='warning'>\The [src] displays an error message: Upload halted at [cached_progress]%.</span>")
	..()

//a suit that looks like a black-haired human in a suit, for muh Reptilians and/or Thin Mints

/obj/item/clothing/suit/urist/fleshsuit
	name = "executive suit"
	desc = "REGULAR HUMAN suit. Nothing to see here, fellow human."
	item_state = "jensensuit"
	item_icons = URIST_ALL_ONMOBS
	icon = 'icons/urist/items/clothes/clothes.dmi'
	icon_state = "fleshsuit"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS|FEET|HANDS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL

//the mask for the full kit, straight out of the Uncanny Valley

/obj/item/clothing/mask/chameleon/voice/fleshmask
	icon = 'icons/urist/items/clothes/masks.dmi'
	icon_override = 'icons/uristmob/mask.dmi'
	name = "ugly green collar (?)" //for examining wearers
	desc = "AAAH! WHYYYYYY?"
	item_state = "fleshmask"
	icon_state = "fleshmask"
	body_parts_covered = FACE|HEAD
	flags_inv = HIDEEARS|HIDEFACE
	obj_flags = ITEM_FLAG_BLOCK_GAS_SMOKE_EFFECT | ITEM_FLAG_AIRTIGHT | BLOCKHAIR
	var/usedonce = 0 //can only set voice once, to prevent being superior to voice changer at the same cost

/obj/item/clothing/mask/chameleon/voice/fleshmask/Set_Voice(name as text)
	if(usedonce)
		to_chat(usr, "<span class='notice'>The modulator in the [src] cannot be reset!</span>")
		return
	..()
	usedonce = 1


/obj/item/storage/box/syndie_kit/fleshsuit
	name = "H. sapiens Imitation Suit"
	desc = "Contains a set of clothing to disguise nonhumans as humans: a full-body suit with special tail compartment, and an airtight, stretching mask with a non-resettable voice changer."

/obj/item/storage/box/syndie_kit/fleshsuit/New()
	..()
	new /obj/item/clothing/suit/urist/fleshsuit(src)
	new /obj/item/clothing/mask/chameleon/voice/fleshmask(src)
	make_exact_fit()

/obj/landmark/intelspawn
	icon_state = "x3"
	var/probability = 50 //so that it can be tweaked for areas with various amounts of traffic

/obj/landmark/intelspawn/Initialize()
	. = ..()
	invisibility = 101
	return
