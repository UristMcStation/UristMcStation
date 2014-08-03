//Improvised weaponry, some from /tg/, some by me

//begin /tg/ weapons

/obj/item/weapon/wirerod
	urist_only = 1
	name = "Wired rod"
	desc = "A rod with some wire wrapped around the top. It'd be easy to attach something to the top bit."
	icon = 'icons/urist/items/improvised.dmi'
	icon_state = "wiredrod"
	item_state = "rods"
	flags = FPRINT | TABLEPASS | CONDUCT
	force = 9
	throwforce = 10
	w_class = 3
	attack_verb = list("hit", "bludgeoned", "whacked", "bonked")

/obj/item/weapon/wirerod/attackby(var/obj/item/I, mob/user as mob)
	..()
	if(istype(I, /obj/item/weapon/shard))
		var/obj/item/weapon/twohanded/spear/S = new /obj/item/weapon/twohanded/spear

		user.before_take_item(I)
		user.before_take_item(src)

		user.put_in_hands(S)
		user << "<span class='notice'>You fasten the glass shard to the top of the rod with the cable.</span>"
		del(I)
		del(src)

	else if(istype(I, /obj/item/weapon/wirecutters))
		var/obj/item/weapon/melee/baton/cattleprod/P = new /obj/item/weapon/melee/baton/cattleprod

		user.before_take_item(I)
		user.before_take_item(src)

		user.put_in_hands(P)
		user << "<span class='notice'>You fasten the wirecutters to the top of the rod with the cable, prongs outward.</span>"
		del(I)
		del(src)

	else if(istype(I, /obj/item/stack/rods))
		var/obj/item/weapon/twohanded/quarterstaff/S = new /obj/item/weapon/twohanded/quarterstaff

		user.before_take_item(I)
		user.before_take_item(src)

		user.put_in_hands(S)
		user << "<span class='notice'>You fasten the two rods together tightly with the cable.</span>"
		del(I)
		del(src)

/obj/item/weapon/handcuffs/cable/attackby(var/obj/item/I, mob/user as mob)
	..()
	if(istype(I, /obj/item/stack/rods))
		var/obj/item/stack/rods/R = I
		var/obj/item/weapon/wirerod/W = new /obj/item/weapon/wirerod
		R.use(1)

		user.before_take_item(src)

		user.put_in_hands(W)
		user << "<span class='notice'>You wrap the cable restraint around the top of the rod.</span>"

		del(src)

//spears
/obj/item/weapon/twohanded/spear
	urist_only = 1
	icon = 'icons/urist/items/improvised.dmi'
	icon_state = "spearglass0"
	name = "spear"
	desc = "A haphazardly-constructed yet still deadly weapon of ancient design."
	force = 12
	w_class = 4.0
	slot_flags = SLOT_BACK
	force_unwielded = 12
	force_wielded = 20 // Was 13, Buffed - RR
	throwforce = 15
	flags = NOSHIELD
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("attacked", "poked", "jabbed", "torn", "gored")

/obj/item/weapon/twohanded/spear/update_icon()
	icon_state = "spearglass[wielded]"
	return

//Makeshift stun baton. Replacement for stun gloves.
/obj/item/weapon/melee/baton/cattleprod
	name = "stunprod"
	desc = "An improvised stun baton."
	icon_state = "stunprod_nocell"
	item_state = "prod"
	force = 3
	throwforce = 5
	stunforce = 5
	hitcost = 2500
	slot_flags = null

/obj/item/weapon/melee/baton/cattleprod/update_icon()
	if(status)
		icon_state = "stunprod_active"
	else
		icon_state = "stunprod"

//END /tg/ stuff

//begin Urist stuff

//quarterstaff

/obj/item/weapon/twohanded/quarterstaff
	urist_only = 1
	icon = 'icons/urist/items/improvised.dmi'
	item_state = "qstaff0"
	icon_state = "qstaff0"
	name = "quarterstaff"
	desc = "A haphazardly-constructed yet still deadly weapon... Looks to be little more than two metal rods tied together."
	force = 8
	w_class = 4.0
	slot_flags = SLOT_BACK
	force_unwielded = 8
	force_wielded = 14
	throwforce = 8
	flags = NOSHIELD
	attack_verb = list("attacked", "smashed", "bashed", "smacked", "beaten")

/obj/item/weapon/twohanded/quarterstaff/update_icon()
	urist_only = 1
	icon = 'icons/urist/items/improvised.dmi'
	icon_state = "qstaff[wielded]"
	item_state = "qstaff[wielded]"
	return

/*/obj/item/weapon/twohanded/quarterstaff/shitavalin //need to find a halfway decent way to do this.
	name = "improvised javelin"
	desc = "A haphazardly-constructed yet still deadly weapon... Looks to be little more than two metal rods tied together and sharpened on one end."
	throwforce = 15	*/

/obj/item/weapon/shiv
	name = "shiv"
	desc = "A small improvised blade made out of a glass shard. Looks like it could do some damage to a kidney or two..."
	icon = 'icons/urist/items/improvised.dmi'
	icon_state = "shiv"
	item_state = "shard-glass"
	force = 11
	throwforce = 5
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("stabbed", "slashed", "sliced", "cut")
	w_class = 2.0
	sharp = 1

	suicide_act(mob/user)
		viewers(user) << pick("\red <b>[user] is slitting \his wrists with the shard of glass! It looks like \he's trying to commit suicide.</b>", \
							"\red <b>[user] is slitting \his throat with the shard of glass! It looks like \he's trying to commit suicide.</b>")
		return (BRUTELOSS)

/obj/item/weapon/shard/attackby(var/obj/item/I, mob/user as mob)
	..()
	if(istype(I, /obj/item/weapon/bedsheet))
		var/obj/item/weapon/shiv/S = new /obj/item/weapon/shiv
		user.before_take_item(I)
		user.before_take_item(src)

		user.put_in_hands(S)
		user << "<span class='notice'>You carefully wrap the bedsheet around the shard to form a crude grip.</span>"
		del(I)
		del(src)

//scrapper

/obj/item/weapon/shield/riot/scrapper
	urist_only = 1
	name = "scrapper shield"
	desc = "A large rectangular shield made out of hastily assembled chuncks of plasteel."
	icon = 'icons/urist/items/improvised.dmi'
	icon_state = "scrappershield"
	item_state = "scrappershield"

//end Urist stuff

