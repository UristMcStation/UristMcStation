/*
CONTAINS:
BEDSHEETS
*/

/obj/item/bedsheet/urist
	icon = 'icons/urist/items/tgitems.dmi'
	icon_override = 'icons/uristmob/back.dmi'
	icon_state = "sheetwhite"
	item_state = "bedsheet"

/obj/item/bedsheet/urist/qm
	name = "quartermaster's bedsheet"
	desc = "It is decorated with a crate emblem in silver lining.  It's rather tough, and just the thing to lie on after a hard day of pushing paper."
	icon_state = "sheetqm"
	item_state = "sheetqm"
	//item_color = "qm"

/obj/item/bedsheet/urist/centcom
	name = "\improper Centcom bedsheet"
	desc = "Woven with advanced nanothread for warmth as well as being very decorated, essential for all officials."
	icon_state = "sheetcentcom"
	item_state = "sheetcentcom"
	//item_color = "centcom"

/obj/item/bedsheet/urist/syndie
	name = "syndicate bedsheet"
	desc = "It has a syndicate emblem and it has an aura of evil."
	icon_state = "sheetsyndie"
	item_state = "sheetsyndie"
	//item_color = "syndie"

/obj/item/bedsheet/urist/cult
	name = "cultist's bedsheet"
	desc = "You might dream of Nar'Sie if you sleep with this.  It seems rather tattered and glows of an eldritch presence."
	icon_state = "sheetcult"
	item_state = "sheetcult"
	//item_color = "cult"

/obj/item/bedsheet/urist/wiz
	name = "wizard's bedsheet"
	desc = "A special fabric enchanted with magic so you can have an enchanted night.  It even glows!"
	icon_state = "sheetwiz"
	item_state = "sheetwiz"
	//item_color = "wiz"

//bedsheet bandanas

/obj/item/bedsheet/verb/toggle_bandana()
	set name = "Fold Bandana"
	set category = "Object"
//	set src in usr

	var/mob/living/carbon/human/user = usr
	if(user.incapacitated())
		return 0

	if(icon_state == "sheetwhite")
		var/obj/item/clothing/mask/urist/bandana/bedsheet/white/B = new /obj/item/clothing/mask/urist/bandana/bedsheet/white

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You fold the bedsheet into a bandana.</span>")
		qdel(src)
	if(icon_state == "sheetblue")
		var/obj/item/clothing/mask/urist/bandana/bedsheet/blue/B = new /obj/item/clothing/mask/urist/bandana/bedsheet/blue

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You fold the bedsheet into a bandana.</span>")
		qdel(src)
	if(icon_state == "sheetorange")
		var/obj/item/clothing/mask/urist/bandana/bedsheet/orange/B = new /obj/item/clothing/mask/urist/bandana/bedsheet/orange

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You fold the bedsheet into a bandana.</span>")
		qdel(src)
	if(icon_state == "sheetred")
		var/obj/item/clothing/mask/urist/bandana/bedsheet/red/B = new /obj/item/clothing/mask/urist/bandana/bedsheet/red

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You fold the bedsheet into a bandana.</span>")
		qdel(src)
	if(icon_state == "sheetpurple")
		var/obj/item/clothing/mask/urist/bandana/bedsheet/purple/B = new /obj/item/clothing/mask/urist/bandana/bedsheet/purple

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You fold the bedsheet into a bandana.</span>")
		qdel(src)
	if(icon_state == "sheetgreen")
		var/obj/item/clothing/mask/urist/bandana/bedsheet/green/B = new /obj/item/clothing/mask/urist/bandana/bedsheet/green

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You fold the bedsheet into a bandana.</span>")
		qdel(src)
	if(icon_state == "sheetyellow")
		var/obj/item/clothing/mask/urist/bandana/bedsheet/yellow/B = new /obj/item/clothing/mask/urist/bandana/bedsheet/yellow

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You fold the bedsheet into a bandana.</span>")
		qdel(src)
	if(icon_state == "sheetrainbow")
		var/obj/item/clothing/mask/urist/bandana/bedsheet/rainbow/B = new /obj/item/clothing/mask/urist/bandana/bedsheet/rainbow

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You fold the bedsheet into a bandana.</span>")
		qdel(src)
	if(icon_state == "sheetbrown")
		var/obj/item/clothing/mask/urist/bandana/bedsheet/brown/B = new /obj/item/clothing/mask/urist/bandana/bedsheet/brown

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You fold the bedsheet into a bandana.</span>")
		qdel(src)
	if(icon_state == "sheetcaptain")
		var/obj/item/clothing/mask/urist/bandana/bedsheet/captain/B = new /obj/item/clothing/mask/urist/bandana/bedsheet/captain

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You fold the bedsheet into a bandana.</span>")
		qdel(src)
	if(icon_state == "sheethop")
		var/obj/item/clothing/mask/urist/bandana/bedsheet/hop/B = new /obj/item/clothing/mask/urist/bandana/bedsheet/hop

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You fold the bedsheet into a bandana.</span>")
		qdel(src)
	if(icon_state == "sheetce")
		var/obj/item/clothing/mask/urist/bandana/bedsheet/ce/B = new /obj/item/clothing/mask/urist/bandana/bedsheet/ce

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You fold the bedsheet into a bandana.</span>")
		qdel(src)
	if(icon_state == "sheethos")
		var/obj/item/clothing/mask/urist/bandana/bedsheet/hos/B = new /obj/item/clothing/mask/urist/bandana/bedsheet/hos

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You fold the bedsheet into a bandana.</span>")
		qdel(src)
	if(icon_state == "sheetmedical")
		var/obj/item/clothing/mask/urist/bandana/bedsheet/medical/B = new /obj/item/clothing/mask/urist/bandana/bedsheet/medical

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You fold the bedsheet into a bandana.</span>")
		qdel(src)
	if(icon_state == "sheetcmo")
		var/obj/item/clothing/mask/urist/bandana/bedsheet/cmo/B = new /obj/item/clothing/mask/urist/bandana/bedsheet/cmo

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You fold the bedsheet into a bandana.</span>")
		qdel(src)
	if(icon_state == "sheetrd")
		var/obj/item/clothing/mask/urist/bandana/bedsheet/rd/B = new /obj/item/clothing/mask/urist/bandana/bedsheet/rd

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You fold the bedsheet into a bandana.</span>")
		qdel(src)
	if(icon_state == "sheetqm")
		var/obj/item/clothing/mask/urist/bandana/bedsheet/qm/B = new /obj/item/clothing/mask/urist/bandana/bedsheet/qm

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You fold the bedsheet into a bandana.</span>")
		qdel(src)
	if(icon_state == "sheetcentcom")
		var/obj/item/clothing/mask/urist/bandana/bedsheet/centcom/B = new /obj/item/clothing/mask/urist/bandana/bedsheet/centcom

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You fold the bedsheet into a bandana.</span>")
		qdel(src)
	if(icon_state == "sheetsyndie")
		var/obj/item/clothing/mask/urist/bandana/bedsheet/syndie/B = new /obj/item/clothing/mask/urist/bandana/bedsheet/syndie

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You fold the bedsheet into a bandana.</span>")
		qdel(src)
	if(icon_state == "sheetcult")
		var/obj/item/clothing/mask/urist/bandana/bedsheet/cult/B = new /obj/item/clothing/mask/urist/bandana/bedsheet/cult

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You fold the bedsheet into a bandana.</span>")
		qdel(src)
	if(icon_state == "sheetwiz")
		var/obj/item/clothing/mask/urist/bandana/bedsheet/wiz/B = new /obj/item/clothing/mask/urist/bandana/bedsheet/wiz

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You fold the bedsheet into a bandana.</span>")
		qdel(src)
	if(icon_state == "sheetclown")
		var/obj/item/clothing/mask/urist/bandana/bedsheet/clown/B = new /obj/item/clothing/mask/urist/bandana/bedsheet/clown

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You fold the bedsheet into a bandana.</span>")
		qdel(src)
	if(icon_state == "sheetmime")
		var/obj/item/clothing/mask/urist/bandana/bedsheet/mime/B = new /obj/item/clothing/mask/urist/bandana/bedsheet/mime

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You fold the bedsheet into a bandana.</span>")
		qdel(src)

/*oldcode, will delete if there are no issues with this.
//I KNOW THERE IS A BETTER WAY TO DO THIS USING COLOURS, BUT I'M DOING THIS QUICK AND DIRTY SO PEOPLE STOP BITCHING AT ME. I WILL RETURN TO CLEAN THIS UP.

/obj/item/bedsheet/verb/toggle_bandana()
	set name = "Fold Bandana"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/clothing/mask/urist/bandana/bedsheet/white/B = new /obj/item/clothing/mask/urist/bandana/bedsheet/white

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You fold the bedsheet into a bandana.</span>")
		qdel(src)

/obj/item/bedsheet/blue/verb/toggle_bandana()
	set name = "Fold Bandana"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/clothing/mask/urist/bandana/bedsheet/blue/B = new /obj/item/clothing/mask/urist/bandana/bedsheet/blue

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You fold the bedsheet into a bandana.</span>")
		qdel(src)

/obj/item/bedsheet/orange/verb/toggle_bandana()
	set name = "Fold Bandana"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/clothing/mask/urist/bandana/bedsheet/orange/B = new /obj/item/clothing/mask/urist/bandana/bedsheet/orange

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You fold the bedsheet into a bandana.</span>")
		qdel(src)

/obj/item/bedsheet/red/verb/toggle_bandana()
	set name = "Fold Bandana"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/clothing/mask/urist/bandana/bedsheet/red/B = new /obj/item/clothing/mask/urist/bandana/bedsheet/red

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You fold the bedsheet into a bandana.</span>")
		qdel(src)

/obj/item/bedsheet/purple/verb/toggle_bandana()
	set name = "Fold Bandana"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/clothing/mask/urist/bandana/bedsheet/purple/B = new /obj/item/clothing/mask/urist/bandana/bedsheet/purple

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You fold the bedsheet into a bandana.</span>")
		qdel(src)

/obj/item/bedsheet/green/verb/toggle_bandana()
	set name = "Fold Bandana"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/clothing/mask/urist/bandana/bedsheet/green/B = new /obj/item/clothing/mask/urist/bandana/bedsheet/green

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You fold the bedsheet into a bandana.</span>")
		qdel(src)

/obj/item/bedsheet/yellow/verb/toggle_bandana()
	set name = "Fold Bandana"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/clothing/mask/urist/bandana/bedsheet/yellow/B = new /obj/item/clothing/mask/urist/bandana/bedsheet/yellow

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You fold the bedsheet into a bandana.</span>")
		qdel(src)

/obj/item/bedsheet/rainbow/verb/toggle_bandana()
	set name = "Fold Bandana"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/clothing/mask/urist/bandana/bedsheet/rainbow/B = new /obj/item/clothing/mask/urist/bandana/bedsheet/rainbow

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You fold the bedsheet into a bandana.</span>")
		qdel(src)

/obj/item/bedsheet/brown/verb/toggle_bandana()
	set name = "Fold Bandana"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/clothing/mask/urist/bandana/bedsheet/brown/B = new /obj/item/clothing/mask/urist/bandana/bedsheet/brown

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You fold the bedsheet into a bandana.</span>")
		qdel(src)

/obj/item/bedsheet/captain/verb/toggle_bandana()
	set name = "Fold Bandana"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/clothing/mask/urist/bandana/bedsheet/captain/B = new /obj/item/clothing/mask/urist/bandana/bedsheet/captain

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You fold the bedsheet into a bandana.</span>")
		qdel(src)

/obj/item/bedsheet/hop/verb/toggle_bandana()
	set name = "Fold Bandana"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/clothing/mask/urist/bandana/bedsheet/hop/B = new /obj/item/clothing/mask/urist/bandana/bedsheet/hop

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You fold the bedsheet into a bandana.</span>")
		qdel(src)

/obj/item/bedsheet/ce/verb/toggle_bandana()
	set name = "Fold Bandana"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/clothing/mask/urist/bandana/bedsheet/ce/B = new /obj/item/clothing/mask/urist/bandana/bedsheet/ce

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You fold the bedsheet into a bandana.</span>")
		qdel(src)

/obj/item/bedsheet/hos/verb/toggle_bandana()
	set name = "Fold Bandana"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/clothing/mask/urist/bandana/bedsheet/hos/B = new /obj/item/clothing/mask/urist/bandana/bedsheet/hos

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You fold the bedsheet into a bandana.</span>")
		qdel(src)


/obj/item/bedsheet/medical/verb/toggle_bandana()
	set name = "Fold Bandana"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/clothing/mask/urist/bandana/bedsheet/medical/B = new /obj/item/clothing/mask/urist/bandana/bedsheet/medical

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You fold the bedsheet into a bandana.</span>")
		qdel(src)

/obj/item/bedsheet/cmo/verb/toggle_bandana()
	set name = "Fold Bandana"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/clothing/mask/urist/bandana/bedsheet/cmo/B = new /obj/item/clothing/mask/urist/bandana/bedsheet/cmo

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You fold the bedsheet into a bandana.</span>")
		qdel(src)

/obj/item/bedsheet/rd/verb/toggle_bandana()
	set name = "Fold Bandana"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/clothing/mask/urist/bandana/bedsheet/rd/B = new /obj/item/clothing/mask/urist/bandana/bedsheet/rd

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You fold the bedsheet into a bandana.</span>")
		qdel(src)

/obj/item/bedsheet/qm/verb/toggle_bandana()
	set name = "Fold Bandana"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/clothing/mask/urist/bandana/bedsheet/qm/B = new /obj/item/clothing/mask/urist/bandana/bedsheet/qm

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You fold the bedsheet into a bandana.</span>")
		qdel(src)

/obj/item/bedsheet/centcom/verb/toggle_bandana()
	set name = "Fold Bandana"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/clothing/mask/urist/bandana/bedsheet/centcom/B = new /obj/item/clothing/mask/urist/bandana/bedsheet/centcom

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You fold the bedsheet into a bandana.</span>")
		qdel(src)

/obj/item/bedsheet/syndie/verb/toggle_bandana()
	set name = "Fold Bandana"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/clothing/mask/urist/bandana/bedsheet/syndie/B = new /obj/item/clothing/mask/urist/bandana/bedsheet/syndie

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You fold the bedsheet into a bandana.</span>")
		qdel(src)

/obj/item/bedsheet/cult/verb/toggle_bandana()
	set name = "Fold Bandana"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/clothing/mask/urist/bandana/bedsheet/cult/B = new /obj/item/clothing/mask/urist/bandana/bedsheet/cult

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You fold the bedsheet into a bandana.</span>")
		qdel(src)

/obj/item/bedsheet/wiz/verb/toggle_bandana()
	set name = "Fold Bandana"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/clothing/mask/urist/bandana/bedsheet/wiz/B = new /obj/item/clothing/mask/urist/bandana/bedsheet/wiz

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You fold the bedsheet into a bandana.</span>")
		qdel(src)

/obj/item/bedsheet/clown/verb/toggle_bandana()
	set name = "Fold Bandana"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/clothing/mask/urist/bandana/bedsheet/clown/B = new /obj/item/clothing/mask/urist/bandana/bedsheet/clown

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You fold the bedsheet into a bandana.</span>")
		qdel(src)

/obj/item/bedsheet/mime/verb/toggle_bandana()
	set name = "Fold Bandana"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/clothing/mask/urist/bandana/bedsheet/mime/B = new /obj/item/clothing/mask/urist/bandana/bedsheet/mime

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You fold the bedsheet into a bandana.</span>")
		qdel(src)

*/
