/*
CONTAINS:
BEDSHEETS
LINEN BINS
*/

/obj/item/weapon/bedsheet
	name = "bedsheet"
	desc = "A surprisingly soft linen bedsheet."
	icon = 'icons/urist/items/tgitems.dmi'
	icon_override = 'icons/uristmob/back.dmi'
	icon_state = "sheetwhite"
	item_state = "bedsheet"
	slot_flags = SLOT_BACK
	layer = 4.0
	throwforce = 1
	throw_speed = 1
	throw_range = 2
	w_class = 1.0

	var/on = 1

/obj/item/weapon/bedsheet/attack_self(mob/user as mob)
	user.drop_item()
	if(layer == initial(layer))
		layer = 5
	else
		layer = initial(layer)
	add_fingerprint(user)
	return

/obj/item/weapon/bedsheet/white
	icon_state = "sheetwhite"
	//item_color = "white" //rip item_color, we hardly knew ye... unless it's reverted.

/obj/item/weapon/bedsheet/blue
	icon_state = "sheetblue"
	//item_color = "blue"

/obj/item/weapon/bedsheet/green
	icon_state = "sheetgreen"
	//item_color = "green"

/obj/item/weapon/bedsheet/orange
	icon_state = "sheetorange"
	//item_color = "orange"

/obj/item/weapon/bedsheet/purple
	icon_state = "sheetpurple"
	//item_color = "purple"

/obj/item/weapon/bedsheet/rainbow
	name = "rainbow bedsheet"
	desc = "A multicolored blanket.  It's actually several different sheets cut up and sewn together."
	icon_state = "sheetrainbow"
	//item_color = "rainbow"

/obj/item/weapon/bedsheet/red
	icon_state = "sheetred"
	//item_color = "red"

/obj/item/weapon/bedsheet/yellow
	icon_state = "sheetyellow"
	//item_color = "yellow"

/obj/item/weapon/bedsheet/mime
	name = "mime's blanket"
	desc = "A very soothing striped blanket.  All the noise just seems to fade out when you're under the covers in this."
	icon_state = "sheetmime"
	//item_color = "mime"

/obj/item/weapon/bedsheet/clown
	name = "clown's blanket"
	desc = "A rainbow blanket with a clown mask woven in.  It smells faintly of bananas."
	icon_state = "sheetclown"
	//item_color = "clown"

/obj/item/weapon/bedsheet/captain
	name = "captain's bedsheet"
	desc = "It has a Nanotrasen symbol on it, and was woven with a revolutionary new kind of thread guaranteed to have 0.01% permeability for most non-chemical substances, popular among most modern captains."
	icon_state = "sheetcaptain"
	//item_color = "captain"

/obj/item/weapon/bedsheet/rd
	name = "research director's bedsheet"
	desc = "It appears to have a beaker emblem, and is made out of fire-resistant material, although it probably won't protect you in the event of fires you're familiar with every day."
	icon_state = "sheetrd"
	//item_color = "director"

/obj/item/weapon/bedsheet/medical
	name = "medical blanket"
	desc = "It's a sterilized* blanket commonly used in the Medbay.  *Sterilization is voided if a virologist is present onboard the station."
	icon_state = "sheetmedical"
	//item_color = "medical"

/obj/item/weapon/bedsheet/cmo
	name = "chief medical officer's bedsheet"
	desc = "It's a sterilized blanket that has a cross emblem.  There's some cat fur on it, likely from Runtime."
	icon_state = "sheetcmo"
	//item_color = "cmo"

/obj/item/weapon/bedsheet/hos
	name = "head of security's bedsheet"
	desc = "It is decorated with a shield emblem.  While crime doesn't sleep, you do, but you are still THE LAW!"
	icon_state = "sheethos"
	//item_color = "hosred"

/obj/item/weapon/bedsheet/hop
	name = "head of personnel's bedsheet"
	desc = "It is decorated with a key emblem.  For those rare moments when you can rest and cuddle with Ian without someone screaming for you over the radio."
	icon_state = "sheethop"
	//item_color = "hop"

/obj/item/weapon/bedsheet/ce
	name = "chief engineer's bedsheet"
	desc = "It is decorated with a wrench emblem.  It's highly reflective and stain resistant, so you don't need to worry about ruining it with oil."
	icon_state = "sheetce"
	//item_color = "chief"

/obj/item/weapon/bedsheet/qm
	name = "quartermaster's bedsheet"
	desc = "It is decorated with a crate emblem in silver lining.  It's rather tough, and just the thing to lie on after a hard day of pushing paper."
	icon_state = "sheetqm"
	//item_color = "qm"

/obj/item/weapon/bedsheet/brown
	icon_state = "sheetbrown"
	//item_color = "cargo"

/obj/item/weapon/bedsheet/centcom
	name = "\improper Centcom bedsheet"
	desc = "Woven with advanced nanothread for warmth as well as being very decorated, essential for all officials."
	icon_state = "sheetcentcom"
	//item_color = "centcom"

/obj/item/weapon/bedsheet/syndie
	name = "syndicate bedsheet"
	desc = "It has a syndicate emblem and it has an aura of evil."
	icon_state = "sheetsyndie"
	//item_color = "syndie"

/obj/item/weapon/bedsheet/cult
	name = "cultist's bedsheet"
	desc = "You might dream of Nar'Sie if you sleep with this.  It seems rather tattered and glows of an eldritch presence."
	icon_state = "sheetcult"
	//item_color = "cult"

/obj/item/weapon/bedsheet/wiz
	name = "wizard's bedsheet"
	desc = "A special fabric enchanted with magic so you can have an enchanted night.  It even glows!"
	icon_state = "sheetwiz"
	//item_color = "wiz"


/obj/structure/bedsheetbin
	name = "linen bin"
	desc = "It looks rather cosy."
	icon = 'icons/obj/structures.dmi'
	icon_state = "linenbin-full"
	anchored = 1
	var/amount = 10
	var/list/sheets = list()
	var/obj/item/hidden = null


/obj/structure/bedsheetbin/examine()
	..()
	if(amount < 1)
		usr << "There are no bed sheets in the bin."
		return
	if(amount == 1)
		usr << "There is one bed sheet in the bin."
		return
	usr << "There are [amount] bed sheets in the bin."


/obj/structure/bedsheetbin/update_icon()
	switch(amount)
		if(0)		icon_state = "linenbin-empty"
		if(1 to 5)	icon_state = "linenbin-half"
		else		icon_state = "linenbin-full"


/obj/structure/bedsheetbin/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/weapon/bedsheet))
		user.drop_item()
		I.loc = src
		sheets.Add(I)
		amount++
		user << "<span class='notice'>You put [I] in [src].</span>"
		update_icon()
	else if(amount && !hidden && I.w_class < 4)	//make sure there's sheets to hide it among, make sure nothing else is hidden in there.
		user.drop_item()
		I.loc = src
		hidden = I
		user << "<span class='notice'>You hide [I] among the sheets.</span>"


/obj/structure/bedsheetbin/attack_hand(mob/user as mob)
	if(amount >= 1)
		amount--

		var/obj/item/weapon/bedsheet/white/B
		if(sheets.len > 0)
			B = sheets[sheets.len]
			sheets.Remove(B)

		else
			B = new /obj/item/weapon/bedsheet/white(loc)

		B.loc = user.loc
		user.put_in_hands(B)
		user << "<span class='notice'>You take [B] out of [src].</span>"
		update_icon()

		if(hidden)
			hidden.loc = user.loc
			user << "<span class='notice'>[hidden] falls out of [B]!</span>"
			hidden = null


	add_fingerprint(user)
/obj/structure/bedsheetbin/attack_tk(mob/user as mob)
	if(amount >= 1)
		amount--

		var/obj/item/weapon/bedsheet/white/B
		if(sheets.len > 0)
			B = sheets[sheets.len]
			sheets.Remove(B)

		else
			B = new /obj/item/weapon/bedsheet/white(loc)

		B.loc = loc
		user << "<span class='notice'>You telekinetically remove [B] from [src].</span>"
		update_icon()

		if(hidden)
			hidden.loc = loc
			hidden = null


	add_fingerprint(user)

//bedsheet bandanas

/obj/item/weapon/bedsheet/verb/toggle_bandana()
	set name = "Fold Bandana"
	set category = "Object"
//	set src in usr

	if(!usr.canmove || usr.stat || usr.restrained())
		return 0

	var/mob/living/carbon/human/user = usr
	if(icon_state == "sheetwhite")
		var/obj/item/clothing/mask/bandana/bedsheet/white/B = new /obj/item/clothing/mask/bandana/bedsheet/white

		user.remove_from_mob(src)

		user.put_in_hands(B)
		user << "<span class='notice'>You fold the bedsheet into a bandana.</span>"
		qdel(src)
	if(icon_state == "sheetblue")
		var/obj/item/clothing/mask/bandana/bedsheet/blue/B = new /obj/item/clothing/mask/bandana/bedsheet/blue

		user.remove_from_mob(src)

		user.put_in_hands(B)
		user << "<span class='notice'>You fold the bedsheet into a bandana.</span>"
		qdel(src)
	if(icon_state == "sheetorange")
		var/obj/item/clothing/mask/bandana/bedsheet/orange/B = new /obj/item/clothing/mask/bandana/bedsheet/orange

		user.remove_from_mob(src)

		user.put_in_hands(B)
		user << "<span class='notice'>You fold the bedsheet into a bandana.</span>"
		qdel(src)
	if(icon_state == "sheetred")
		var/obj/item/clothing/mask/bandana/bedsheet/red/B = new /obj/item/clothing/mask/bandana/bedsheet/red

		user.remove_from_mob(src)

		user.put_in_hands(B)
		user << "<span class='notice'>You fold the bedsheet into a bandana.</span>"
		qdel(src)
	if(icon_state == "sheetpurple")
		var/obj/item/clothing/mask/bandana/bedsheet/purple/B = new /obj/item/clothing/mask/bandana/bedsheet/purple

		user.remove_from_mob(src)

		user.put_in_hands(B)
		user << "<span class='notice'>You fold the bedsheet into a bandana.</span>"
		qdel(src)
	if(icon_state == "sheetgreen")
		var/obj/item/clothing/mask/bandana/bedsheet/green/B = new /obj/item/clothing/mask/bandana/bedsheet/green

		user.remove_from_mob(src)

		user.put_in_hands(B)
		user << "<span class='notice'>You fold the bedsheet into a bandana.</span>"
		qdel(src)
	if(icon_state == "sheetyellow")
		var/obj/item/clothing/mask/bandana/bedsheet/yellow/B = new /obj/item/clothing/mask/bandana/bedsheet/yellow

		user.remove_from_mob(src)

		user.put_in_hands(B)
		user << "<span class='notice'>You fold the bedsheet into a bandana.</span>"
		qdel(src)
	if(icon_state == "sheetrainbow")
		var/obj/item/clothing/mask/bandana/bedsheet/rainbow/B = new /obj/item/clothing/mask/bandana/bedsheet/rainbow

		user.remove_from_mob(src)

		user.put_in_hands(B)
		user << "<span class='notice'>You fold the bedsheet into a bandana.</span>"
		qdel(src)
	if(icon_state == "sheetbrown")
		var/obj/item/clothing/mask/bandana/bedsheet/brown/B = new /obj/item/clothing/mask/bandana/bedsheet/brown

		user.remove_from_mob(src)

		user.put_in_hands(B)
		user << "<span class='notice'>You fold the bedsheet into a bandana.</span>"
		qdel(src)
	if(icon_state == "sheetcaptain")
		var/obj/item/clothing/mask/bandana/bedsheet/captain/B = new /obj/item/clothing/mask/bandana/bedsheet/captain

		user.remove_from_mob(src)

		user.put_in_hands(B)
		user << "<span class='notice'>You fold the bedsheet into a bandana.</span>"
		qdel(src)
	if(icon_state == "sheethop")
		var/obj/item/clothing/mask/bandana/bedsheet/hop/B = new /obj/item/clothing/mask/bandana/bedsheet/hop

		user.remove_from_mob(src)

		user.put_in_hands(B)
		user << "<span class='notice'>You fold the bedsheet into a bandana.</span>"
		qdel(src)
	if(icon_state == "sheetce")
		var/obj/item/clothing/mask/bandana/bedsheet/ce/B = new /obj/item/clothing/mask/bandana/bedsheet/ce

		user.remove_from_mob(src)

		user.put_in_hands(B)
		user << "<span class='notice'>You fold the bedsheet into a bandana.</span>"
		qdel(src)
	if(icon_state == "sheethos")
		var/obj/item/clothing/mask/bandana/bedsheet/hos/B = new /obj/item/clothing/mask/bandana/bedsheet/hos

		user.remove_from_mob(src)

		user.put_in_hands(B)
		user << "<span class='notice'>You fold the bedsheet into a bandana.</span>"
		qdel(src)
	if(icon_state == "sheetmedical")
		var/obj/item/clothing/mask/bandana/bedsheet/medical/B = new /obj/item/clothing/mask/bandana/bedsheet/medical

		user.remove_from_mob(src)

		user.put_in_hands(B)
		user << "<span class='notice'>You fold the bedsheet into a bandana.</span>"
		qdel(src)
	if(icon_state == "sheetcmo")
		var/obj/item/clothing/mask/bandana/bedsheet/cmo/B = new /obj/item/clothing/mask/bandana/bedsheet/cmo

		user.remove_from_mob(src)

		user.put_in_hands(B)
		user << "<span class='notice'>You fold the bedsheet into a bandana.</span>"
		qdel(src)
	if(icon_state == "sheetrd")
		var/obj/item/clothing/mask/bandana/bedsheet/rd/B = new /obj/item/clothing/mask/bandana/bedsheet/rd

		user.remove_from_mob(src)

		user.put_in_hands(B)
		user << "<span class='notice'>You fold the bedsheet into a bandana.</span>"
		qdel(src)
	if(icon_state == "sheetqm")
		var/obj/item/clothing/mask/bandana/bedsheet/qm/B = new /obj/item/clothing/mask/bandana/bedsheet/qm

		user.remove_from_mob(src)

		user.put_in_hands(B)
		user << "<span class='notice'>You fold the bedsheet into a bandana.</span>"
		qdel(src)
	if(icon_state == "sheetcentcom")
		var/obj/item/clothing/mask/bandana/bedsheet/centcom/B = new /obj/item/clothing/mask/bandana/bedsheet/centcom

		user.remove_from_mob(src)

		user.put_in_hands(B)
		user << "<span class='notice'>You fold the bedsheet into a bandana.</span>"
		qdel(src)
	if(icon_state == "sheetsyndie")
		var/obj/item/clothing/mask/bandana/bedsheet/syndie/B = new /obj/item/clothing/mask/bandana/bedsheet/syndie

		user.remove_from_mob(src)

		user.put_in_hands(B)
		user << "<span class='notice'>You fold the bedsheet into a bandana.</span>"
		qdel(src)
	if(icon_state == "sheetcult")
		var/obj/item/clothing/mask/bandana/bedsheet/cult/B = new /obj/item/clothing/mask/bandana/bedsheet/cult

		user.remove_from_mob(src)

		user.put_in_hands(B)
		user << "<span class='notice'>You fold the bedsheet into a bandana.</span>"
		qdel(src)
	if(icon_state == "sheetwiz")
		var/obj/item/clothing/mask/bandana/bedsheet/wiz/B = new /obj/item/clothing/mask/bandana/bedsheet/wiz

		user.remove_from_mob(src)

		user.put_in_hands(B)
		user << "<span class='notice'>You fold the bedsheet into a bandana.</span>"
		qdel(src)
	if(icon_state == "sheetclown")
		var/obj/item/clothing/mask/bandana/bedsheet/clown/B = new /obj/item/clothing/mask/bandana/bedsheet/clown

		user.remove_from_mob(src)

		user.put_in_hands(B)
		user << "<span class='notice'>You fold the bedsheet into a bandana.</span>"
		qdel(src)
	if(icon_state == "sheetmime")
		var/obj/item/clothing/mask/bandana/bedsheet/mime/B = new /obj/item/clothing/mask/bandana/bedsheet/mime

		user.remove_from_mob(src)

		user.put_in_hands(B)
		user << "<span class='notice'>You fold the bedsheet into a bandana.</span>"
		qdel(src)

/*oldcode, will delete if there are no issues with this.
//I KNOW THERE IS A BETTER WAY TO DO THIS USING COLOURS, BUT I'M DOING THIS QUICK AND DIRTY SO PEOPLE STOP BITCHING AT ME. I WILL RETURN TO CLEAN THIS UP.

/obj/item/weapon/bedsheet/white/verb/toggle_bandana()
	set name = "Fold Bandana"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/clothing/mask/bandana/bedsheet/white/B = new /obj/item/clothing/mask/bandana/bedsheet/white

		user.remove_from_mob(src)

		user.put_in_hands(B)
		user << "<span class='notice'>You fold the bedsheet into a bandana.</span>"
		qdel(src)

/obj/item/weapon/bedsheet/blue/verb/toggle_bandana()
	set name = "Fold Bandana"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/clothing/mask/bandana/bedsheet/blue/B = new /obj/item/clothing/mask/bandana/bedsheet/blue

		user.remove_from_mob(src)

		user.put_in_hands(B)
		user << "<span class='notice'>You fold the bedsheet into a bandana.</span>"
		qdel(src)

/obj/item/weapon/bedsheet/orange/verb/toggle_bandana()
	set name = "Fold Bandana"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/clothing/mask/bandana/bedsheet/orange/B = new /obj/item/clothing/mask/bandana/bedsheet/orange

		user.remove_from_mob(src)

		user.put_in_hands(B)
		user << "<span class='notice'>You fold the bedsheet into a bandana.</span>"
		qdel(src)

/obj/item/weapon/bedsheet/red/verb/toggle_bandana()
	set name = "Fold Bandana"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/clothing/mask/bandana/bedsheet/red/B = new /obj/item/clothing/mask/bandana/bedsheet/red

		user.remove_from_mob(src)

		user.put_in_hands(B)
		user << "<span class='notice'>You fold the bedsheet into a bandana.</span>"
		qdel(src)

/obj/item/weapon/bedsheet/purple/verb/toggle_bandana()
	set name = "Fold Bandana"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/clothing/mask/bandana/bedsheet/purple/B = new /obj/item/clothing/mask/bandana/bedsheet/purple

		user.remove_from_mob(src)

		user.put_in_hands(B)
		user << "<span class='notice'>You fold the bedsheet into a bandana.</span>"
		qdel(src)

/obj/item/weapon/bedsheet/green/verb/toggle_bandana()
	set name = "Fold Bandana"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/clothing/mask/bandana/bedsheet/green/B = new /obj/item/clothing/mask/bandana/bedsheet/green

		user.remove_from_mob(src)

		user.put_in_hands(B)
		user << "<span class='notice'>You fold the bedsheet into a bandana.</span>"
		qdel(src)

/obj/item/weapon/bedsheet/yellow/verb/toggle_bandana()
	set name = "Fold Bandana"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/clothing/mask/bandana/bedsheet/yellow/B = new /obj/item/clothing/mask/bandana/bedsheet/yellow

		user.remove_from_mob(src)

		user.put_in_hands(B)
		user << "<span class='notice'>You fold the bedsheet into a bandana.</span>"
		qdel(src)

/obj/item/weapon/bedsheet/rainbow/verb/toggle_bandana()
	set name = "Fold Bandana"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/clothing/mask/bandana/bedsheet/rainbow/B = new /obj/item/clothing/mask/bandana/bedsheet/rainbow

		user.remove_from_mob(src)

		user.put_in_hands(B)
		user << "<span class='notice'>You fold the bedsheet into a bandana.</span>"
		qdel(src)

/obj/item/weapon/bedsheet/brown/verb/toggle_bandana()
	set name = "Fold Bandana"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/clothing/mask/bandana/bedsheet/brown/B = new /obj/item/clothing/mask/bandana/bedsheet/brown

		user.remove_from_mob(src)

		user.put_in_hands(B)
		user << "<span class='notice'>You fold the bedsheet into a bandana.</span>"
		qdel(src)

/obj/item/weapon/bedsheet/captain/verb/toggle_bandana()
	set name = "Fold Bandana"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/clothing/mask/bandana/bedsheet/captain/B = new /obj/item/clothing/mask/bandana/bedsheet/captain

		user.remove_from_mob(src)

		user.put_in_hands(B)
		user << "<span class='notice'>You fold the bedsheet into a bandana.</span>"
		qdel(src)

/obj/item/weapon/bedsheet/hop/verb/toggle_bandana()
	set name = "Fold Bandana"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/clothing/mask/bandana/bedsheet/hop/B = new /obj/item/clothing/mask/bandana/bedsheet/hop

		user.remove_from_mob(src)

		user.put_in_hands(B)
		user << "<span class='notice'>You fold the bedsheet into a bandana.</span>"
		qdel(src)

/obj/item/weapon/bedsheet/ce/verb/toggle_bandana()
	set name = "Fold Bandana"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/clothing/mask/bandana/bedsheet/ce/B = new /obj/item/clothing/mask/bandana/bedsheet/ce

		user.remove_from_mob(src)

		user.put_in_hands(B)
		user << "<span class='notice'>You fold the bedsheet into a bandana.</span>"
		qdel(src)

/obj/item/weapon/bedsheet/hos/verb/toggle_bandana()
	set name = "Fold Bandana"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/clothing/mask/bandana/bedsheet/hos/B = new /obj/item/clothing/mask/bandana/bedsheet/hos

		user.remove_from_mob(src)

		user.put_in_hands(B)
		user << "<span class='notice'>You fold the bedsheet into a bandana.</span>"
		qdel(src)


/obj/item/weapon/bedsheet/medical/verb/toggle_bandana()
	set name = "Fold Bandana"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/clothing/mask/bandana/bedsheet/medical/B = new /obj/item/clothing/mask/bandana/bedsheet/medical

		user.remove_from_mob(src)

		user.put_in_hands(B)
		user << "<span class='notice'>You fold the bedsheet into a bandana.</span>"
		qdel(src)

/obj/item/weapon/bedsheet/cmo/verb/toggle_bandana()
	set name = "Fold Bandana"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/clothing/mask/bandana/bedsheet/cmo/B = new /obj/item/clothing/mask/bandana/bedsheet/cmo

		user.remove_from_mob(src)

		user.put_in_hands(B)
		user << "<span class='notice'>You fold the bedsheet into a bandana.</span>"
		qdel(src)

/obj/item/weapon/bedsheet/rd/verb/toggle_bandana()
	set name = "Fold Bandana"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/clothing/mask/bandana/bedsheet/rd/B = new /obj/item/clothing/mask/bandana/bedsheet/rd

		user.remove_from_mob(src)

		user.put_in_hands(B)
		user << "<span class='notice'>You fold the bedsheet into a bandana.</span>"
		qdel(src)

/obj/item/weapon/bedsheet/qm/verb/toggle_bandana()
	set name = "Fold Bandana"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/clothing/mask/bandana/bedsheet/qm/B = new /obj/item/clothing/mask/bandana/bedsheet/qm

		user.remove_from_mob(src)

		user.put_in_hands(B)
		user << "<span class='notice'>You fold the bedsheet into a bandana.</span>"
		qdel(src)

/obj/item/weapon/bedsheet/centcom/verb/toggle_bandana()
	set name = "Fold Bandana"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/clothing/mask/bandana/bedsheet/centcom/B = new /obj/item/clothing/mask/bandana/bedsheet/centcom

		user.remove_from_mob(src)

		user.put_in_hands(B)
		user << "<span class='notice'>You fold the bedsheet into a bandana.</span>"
		qdel(src)

/obj/item/weapon/bedsheet/syndie/verb/toggle_bandana()
	set name = "Fold Bandana"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/clothing/mask/bandana/bedsheet/syndie/B = new /obj/item/clothing/mask/bandana/bedsheet/syndie

		user.remove_from_mob(src)

		user.put_in_hands(B)
		user << "<span class='notice'>You fold the bedsheet into a bandana.</span>"
		qdel(src)

/obj/item/weapon/bedsheet/cult/verb/toggle_bandana()
	set name = "Fold Bandana"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/clothing/mask/bandana/bedsheet/cult/B = new /obj/item/clothing/mask/bandana/bedsheet/cult

		user.remove_from_mob(src)

		user.put_in_hands(B)
		user << "<span class='notice'>You fold the bedsheet into a bandana.</span>"
		qdel(src)

/obj/item/weapon/bedsheet/wiz/verb/toggle_bandana()
	set name = "Fold Bandana"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/clothing/mask/bandana/bedsheet/wiz/B = new /obj/item/clothing/mask/bandana/bedsheet/wiz

		user.remove_from_mob(src)

		user.put_in_hands(B)
		user << "<span class='notice'>You fold the bedsheet into a bandana.</span>"
		qdel(src)

/obj/item/weapon/bedsheet/clown/verb/toggle_bandana()
	set name = "Fold Bandana"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/clothing/mask/bandana/bedsheet/clown/B = new /obj/item/clothing/mask/bandana/bedsheet/clown

		user.remove_from_mob(src)

		user.put_in_hands(B)
		user << "<span class='notice'>You fold the bedsheet into a bandana.</span>"
		qdel(src)

/obj/item/weapon/bedsheet/mime/verb/toggle_bandana()
	set name = "Fold Bandana"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/clothing/mask/bandana/bedsheet/mime/B = new /obj/item/clothing/mask/bandana/bedsheet/mime

		user.remove_from_mob(src)

		user.put_in_hands(B)
		user << "<span class='notice'>You fold the bedsheet into a bandana.</span>"
		qdel(src)

*/