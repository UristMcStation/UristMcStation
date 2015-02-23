/*										*****New space to put all UristMcStation medicine*****

Space for all Urist-done, non-pill medical items. Please keep it tidy, as usual. */

//Anti-rad autoinjectors for the engineers: for when you're above hoarding vodka bottles.

/obj/item/weapon/reagent_containers/hypospray/autoinjector/rad
	name = "anti-radiation autoinjector"
	desc = "An autoinjector with a small concotion of drugs designed to treat radiation poisoning. A label says: <b>Warning!</b> this product contains arithrazine."
	icon = 'icons/urist/items/misc.dmi'
	icon_state = "radinjector"
	item_state = "autoinjector"

/obj/item/weapon/reagent_containers/hypospray/autoinjector/rad/New()
	..()
	reagents.remove_reagent("inaprovaline", 5)
	reagents.add_reagent("arithrazine", 3)
	reagents.add_reagent("anti_toxin", 2)
	update_icon()
	return

/obj/item/weapon/storage/firstaid/rad
	name = "radiation first aid kit"
	desc = "A first aid kit loaded with medicine for radiation treatment."
	icon_state = "radfirstaid3"
	item_state = "firstaid-advanced"

	New()
		..()
		if (empty) return

		icon_state = pick("radfirstaid","radfirstaid2","radfirstaid3")

		new /obj/item/weapon/reagent_containers/hypospray/autoinjector/rad( src )
		new /obj/item/weapon/reagent_containers/hypospray/autoinjector/rad( src )
		new /obj/item/weapon/reagent_containers/hypospray/autoinjector/rad( src )
		new /obj/item/weapon/reagent_containers/hypospray/autoinjector/rad( src )
		new /obj/item/weapon/reagent_containers/hypospray/autoinjector/rad( src )
		new /obj/item/weapon/reagent_containers/syringe/antitoxin( src )
		new /obj/item/device/healthanalyzer( src )
		return

//Rags from torn clothes, a quick and, literally, dirty way to stop the bleeding... eventually.

/obj/item/weapon/clothesrag
	name = "rag"
	desc = "The sad remains of a piece of clothing. Could be used to press wounds to stop them from bleeding, but it might take some time and is of dubious cleanliness."
	w_class = 1
	icon = 'icons/obj/toy.dmi'
	icon_state = "rag"
	var/bloodvolume = 0 //how much blood has the rag soaked up
	var/bloodcapacity = 5 //how many times the rag can soak up blood
	var/soaked = 0 //if the rag has reached its capacity

/obj/item/weapon/clothesrag/proc/checkvolume()
	if(src.bloodvolume >= src.bloodcapacity)
		src.soaked = 1
	else
		src.soaked = 0
	if(soaked)
		usr << "The rag has reached its capacity!"
		src.name = "bloody rag"
		src.desc = "The sad remains of a piece of clothing. It has soaked up too much blood to be useful for stopping bleeding, better wash it!"
		icon_state = "rag"
	else
		src.name = "rag"
		src.desc = "The sad remains of a piece of clothing. Could be used to press wounds to stop them from bleeding, but it might take some time and is of dubious cleanliness."
		icon_state = "rag"

/obj/item/weapon/clothesrag/clean_blood()
	..()
	src.bloodvolume = 0
	src.checkvolume()

/obj/item/weapon/clothesrag/attack(mob/living/carbon/M as mob, mob/user as mob) //copypasta ahoy!

	if(soaked)
		user << "<span class='warning'> \The [src] is too bloody!</span>"
		return 1

	if (!istype(M))
		user << "<span class='warning'> \The [src] cannot be applied to [M]!</span>"
		return 1

	if ( ! (istype(user, /mob/living/carbon/human) || \
			istype(user, /mob/living/silicon) || \
			istype(user, /mob/living/carbon/monkey)) )
		user << "<span class='warning'> You don't have the dexterity to do this!</span>"
		return 1

	if (istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		var/datum/organ/external/affecting = H.get_organ(user.zone_sel.selecting)

		if(affecting.display_name == "head")
			if(H.head && istype(H.head,/obj/item/clothing/head/helmet/space))
				user << "<span class='warning'> You can't apply [src] through [H.head]!</span>"
				return 1
		else
			if(H.wear_suit && istype(H.wear_suit,/obj/item/clothing/suit/space))
				user << "<span class='warning'> You can't apply [src] through [H.wear_suit]!</span>"
				return 1

		if(affecting.status & ORGAN_ROBOT)
			user << "<span class='warning'> This isn't useful at all on a robotic limb..</span>"
			return 1

		H.UpdateDamageIcon()

		if(affecting.open == 0)
			if(!affecting.bandage())
				user << "<span class='warning'>The wounds on [M]'s [affecting.display_name] have already been bandaged.</span>"
				return 1
			else
				for (var/datum/wound/W in affecting.wounds)
					if (W.internal)
						continue
					if (W.current_stage <= W.max_bleeding_stage)
						user.visible_message( 	"<span class='notice'> [user] presses [W.desc] on [M]'s [affecting.display_name] with the [src].</span>", \
										"<span class='notice'> You press [W.desc] on [M]'s [affecting.display_name] with the rag, trying to stop the bleeding.</span>" )
						src.bloodvolume += 1
						src.checkvolume()
						if(prob(33))
							W.germ_level += 1 //rags are rarely sanitary
						spawn(10)
							if(prob(20))
								affecting.status &= ~ORGAN_BLEEDING
								user.visible_message( 	"<span class='notice'> [user] stops the bleeding of [W.desc] on [M]'s [affecting.display_name] with the [src]!</span>", \
												"<span class='notice'> You manage to stop the bleeding of [W.desc] on [M]'s [affecting.display_name] with the [src]!</span>" )
							else return 0


					else
						user <<	"<span class='warning'> This wound is not bleeding, use more advanced medical gear to heal the [W.desc] on [M]'s [affecting.display_name].</span>"
						return 0
		else
			if (can_operate(H))        //Checks if mob is lying down on table for surgery
				if (do_surgery(H,user,src))
					return
			else
				user << "<span class='notice'>The [affecting.display_name] is cut open, you'll need more than a [src]!</span>"
				return 0


/obj/item/clothing/suit/verb/rip(mob/user as mob)
	set name = "Rip Apart Suit"
	set category = "Object"
	set src in usr

	var/mob/living/carbon/human/H = src.loc

	if(!usr.canmove || usr.stat || usr.restrained())
		return 0
	if(!istype(H))
		return 0
	if(H.wear_suit == src)
		user << "<span class='warning'>Deciding not to channel your inner barbarian, you think it's a good idea to take off your [src] first.</span>"
		return

	if(istype(src, /obj/item/clothing/suit/space) || istype(src, /obj/item/clothing/suit/armor) || istype(src, /obj/item/clothing/suit/wizrobe)) //add other protected instances as needed
		return 0
	else
		user.visible_message( 	"<span class='notice'> [user] starts ripping [src] apart into rags!</span>", \
											"<span class='notice'> You start ripping [src] apart into rags!</span>" )
		spawn(100)
			user << "<span class='notice'>You have ripped [src] into pieces, yielding two rags.</span>"

			playsound(src.loc, 'sound/weapons/cablecuff.ogg', 100, 1)
			spawn(5)
				playsound(src.loc, 'sound/weapons/cablecuff.ogg', 100, 1)

			new /obj/item/weapon/clothesrag(get_turf(src))
			new /obj/item/weapon/clothesrag(get_turf(src))

			del(src)

			H.update_inv_l_hand()
			H.update_inv_r_hand()


/obj/item/clothing/under/verb/rip(mob/user as mob)
	set name = "Rip Apart Jumpsuit"
	set category = "Object"
	set src in usr
	var/mob/living/carbon/human/H = src.loc

	if(!usr.canmove || usr.stat || usr.restrained())
		return 0
/*	if(istype(src, /obj/item/clothing/under/BADSTUFFGOESHERE //I couldn't think of any item types here that shouldn't work, but leaving it here in case it's needed later
		return 0*/
	if(!istype(H))
		return 0
	if(H.w_uniform == src)
		user << "<span class='warning'>Deciding not to channel your inner barbarian, you think it's a good idea to take off your [src] first.</span>"
		return

	else
		user.visible_message( 	"<span class='notice'> [user] starts ripping [src] apart into a rag!</span>", \
											"<span class='notice'> You start ripping [src] apart into a rag!</span>" )
		spawn(100)
			user << "<span class='notice'>You have ripped [src] into pieces, yielding a rag.</span>"

			playsound(src.loc, 'sound/weapons/cablecuff.ogg', 100, 1)
			spawn(5)
				playsound(src.loc, 'sound/weapons/cablecuff.ogg', 100, 1)

			new /obj/item/weapon/clothesrag(get_turf(src))

			del(src)

			H.update_inv_l_hand()
			H.update_inv_r_hand()
