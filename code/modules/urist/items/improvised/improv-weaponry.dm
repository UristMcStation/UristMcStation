//Improvised weaponry, some from /tg/, some by me

//begin /tg/ weapons

/*/obj/item/weapon/wirerod
	item_icons = DEF_URIST_INHANDS
	name = "Wired rod"
	desc = "A rod with some wire wrapped around the top. It'd be easy to attach something to the top bit."
	icon = 'icons/urist/items/improvised.dmi'
	icon_state = "wiredrod"
	item_state = "rods"
	flags = CONDUCT
	force = 9
	throwforce = 10
	w_class = 3
	attack_verb = list("hit", "bludgeoned", "whacked", "bonked")

/obj/item/weapon/wirerod/attackby(var/obj/item/I, mob/user as mob)
	..()
	if(istype(I, /obj/item/weapon/shard))
		var/obj/item/weapon/material/twohanded/spear/S = new /obj/item/weapon/material/twohanded/spear

		user.remove_from_mob(I)
		user.remove_from_mob(src)

		user.put_in_hands(S)
		user << "<span class='notice'>You fasten the glass shard to the top of the rod with the cable.</span>"
		qdel(I)
		qdel(src)

	else if(istype(I, /obj/item/weapon/wirecutters))
		var/obj/item/weapon/melee/baton/cattleprod/P = new /obj/item/weapon/melee/baton/cattleprod

		user.remove_from_mob(I)
		user.remove_from_mob(src)

		user.put_in_hands(P)
		user << "<span class='notice'>You fasten the wirecutters to the top of the rod with the cable, prongs outward.</span>"
		qdel(I)
		qdel(src)

	else if(istype(I, /obj/item/stack/rods))

		var/obj/item/stack/rods/R = I
		var/obj/item/weapon/material/twohanded/quarterstaff/S = new /obj/item/weapon/material/twohanded/quarterstaff
		R.use(1)

		user.remove_from_mob(src)

		user.put_in_hands(S)
		user << "<span class='notice'>You fasten the two rods together tightly with the cable.</span>"

		qdel(src)

/obj/item/weapon/handcuffs/cable/attackby(var/obj/item/I, mob/user as mob)
	..()
	if(istype(I, /obj/item/stack/rods))
		var/obj/item/stack/rods/R = I
		var/obj/item/weapon/wirerod/W = new /obj/item/weapon/wirerod
		R.use(1)

		user.remove_from_mob(src)

		user.put_in_hands(W)
		user << "<span class='notice'>You wrap the cable restraint around the top of the rod.</span>"

		qdel(src)*/

//spears
/obj/item/weapon/material/twohanded/spear
	item_icons = DEF_URIST_INHANDS
//	icon = 'icons/urist/items/improvised.dmi'
	icon_state = "spearglass0"
	name = "spear"
	desc = "A haphazardly-constructed yet still deadly weapon of ancient design."
	force_divisor = 0.33
	unwielded_force_divisor = 0.20
	w_class = 4.0
	slot_flags = SLOT_BACK
	throwforce = 15
	//flags = NOSHIELD
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("attacked", "poked", "jabbed", "torn", "gored")
	edge = 1
	sharp = 1
	base_icon = "spearglass"

//Makeshift stun baton. Replacement for stun gloves.
/obj/item/weapon/melee/baton/cattleprod
	name = "stunprod"
	desc = "An improvised stun baton."
	icon_state = "stunprod_nocell"
	item_state = "prod"
	force = 3
	throwforce = 5
	stunforce = 0
	agonyforce = 60	//same force as a stunbaton, but uses way more charge.
	hitcost = 20
	slot_flags = null

/obj/item/weapon/melee/baton/cattleprod/update_icon()
	if(status)
		icon_state = "stunprod_active"
	else
		icon_state = "stunprod"

//END /tg/ stuff

//begin Urist stuff

//quarterstaff

/obj/item/weapon/material/twohanded/quarterstaff
	item_icons = DEF_URIST_INHANDS
	icon = 'icons/urist/items/improvised.dmi'
	item_state = "qstaff0"
	icon_state = "qstaff0"
	name = "quarterstaff"
	desc = "A haphazardly-constructed yet still deadly weapon... Looks to be little more than two metal rods tied together."
	w_class = 4.0
	slot_flags = SLOT_BACK
	force_divisor = 0.23 //13.5
	unwielded_force_divisor = 0.15 //9
	throwforce = 8
	//flags = NOSHIELD
	attack_verb = list("attacked", "smashed", "bashed", "smacked", "beaten")

/obj/item/weapon/material/twohanded/quarterstaff/update_icon()
	item_icons = DEF_URIST_INHANDS
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
	force = 12
	throwforce = 5
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("stabbed", "slashed", "sliced", "cut", "shanked")
	w_class = 2.0
	sharp = 1
	edge = 1

/*	suicide_act(mob/user)
		viewers(user) << pick("<span class='danger'>[user] is slitting \his wrists with the [src]! It looks like \he's trying to commit suicide.</span>", \
							"<span class='danger'>[user] is slitting \his throat with the [src]! It looks like \he's trying to commit suicide.</span>")
		return (BRUTELOSS)*/

/obj/item/weapon/material/shard/attackby(var/obj/item/I, mob/user as mob)
	..()
	if(istype(I, /obj/item/weapon/bedsheet))
		var/obj/item/weapon/shiv/S = new /obj/item/weapon/shiv
		user.remove_from_mob(I)
		user.remove_from_mob(src)

		user.put_in_hands(S)
		user << "<span class='notice'>You carefully wrap the bedsheet around the shard to form a crude grip.</span>"
		qdel(I)
		qdel(src)

//scrapper

/obj/item/weapon/shield/riot/scrapper
	item_icons = DEF_URIST_INHANDS
	name = "scrapper shield"
	desc = "A large rectangular shield made out of hastily assembled chuncks of plasteel."
	icon = 'icons/urist/items/improvised.dmi'
	icon_state = "scrappershield"
	item_state = "scrappershield"

//Baseball bat with nails

/obj/item/weapon/baseballbat/nailed
	name = "nailed baseball bat"
	desc = "A wooden baseball bat with a bunch of sharpened rods attached to it."
	icon = 'icons/urist/items/improvised.dmi'
	icon_state = "nailed"
	item_state = "nailed"
	force = 18
	sharp = 1
	edge = 0
	w_class = 3
	item_icons = DEF_URIST_INHANDS

/obj/item/weapon/baseballbat/attackby(var/obj/item/I, mob/user as mob)
	..()
	if(istype(I, /obj/item/stack/rods))
		var/obj/item/stack/rods/R = I
		var/obj/item/weapon/baseballbat/nailed/S = new /obj/item/weapon/baseballbat/nailed
		R.use(3)

		user.remove_from_mob(I)
		user.remove_from_mob(src)

		user.put_in_hands(S)
		user << "<span class='notice'>You jam the rods into the wooden bat.</span>"

		qdel(src)

//Half of a scissor... Ow

/obj/item/weapon/improvised/scissorknife
	name = "Knife"
	desc = "The seperated part of a scissor. Where's the other half?"
	icon = 'icons/urist/items/improvised.dmi'
	icon_state = "scissors_knife"
	item_state = "scissors" // Sure, it's the same icon as the whole one, but at that scale it doesn't matter too much
	force = 11
	throwforce = 10.0
	throw_speed = 4
	throw_range = 10
	attack_verb = list("sliced", "cut", "stabbed", "jabbed")
	sharp = 1
	edge = 1
	w_class = 2
	item_icons = DEF_URIST_INHANDS
	var/parentassembly = /obj/item/weapon/improvised/scissorsassembly

	/*suicide_act(mob/user)
		viewers(user) << pick("<span class='danger'>[user] is slitting \his wrists with the [src]! It looks like \he's trying to commit suicide.</span>", \
							"<span class='danger'>[user] is slitting \his throat with the [src]! It looks like \he's trying to commit suicide.</span>")
		return (BRUTELOSS)*/

/obj/item/weapon/improvised/scissorknife/attackby(var/obj/item/I, mob/user as mob)
	..()
	if((istype(I, /obj/item/weapon/improvised/scissorknife) && istype(src, I))) //If they're both scissor knives
		var/obj/item/weapon/improvised/scissorsassembly/N = new src.parentassembly

		user.remove_from_mob(I)
		user.remove_from_mob(src)
		user.drop_from_inventory(I)
		user.drop_from_inventory(src)


		user.put_in_hands(N)
		user << "<span class='notice'>You slide one knife into another, forming a loose pair of scissors</span>"

		qdel(I)
		qdel(src)

/obj/item/weapon/improvised/scissorknife/barber
	desc = "The seperated part of a scissor. Where's the other half? This one is from barber's scissors"
	icon_state = "scissors_knife_barber"
	item_state = "scissors_barber" // Same reasoning as the main knife. Looks identical
	attack_verb = list("beautifully slices", "artistically cuts", "smoothly stabs", "quickly jabs")
	parentassembly = /obj/item/weapon/improvised/scissorsassembly/barber

/obj/item/weapon/improvised/scissorknife/craft
	name = "\"Knife\""
	desc = "The seperated part of a scissor. Where's the other half? This one is from children's craft scissors"
	icon_state = "scissors_knife_craft_left" //Left/Right is determined by the attackby proc in weapon/scissors
	item_state = "scissors_knife_craft_left" //This tiny scale does matter when it comes to color. The full assembly has two colors, a knife has one
	force = 0 // Totally harmless. It's pretty much just edgeless plastic garbage
	throwforce = 0
	attack_verb = list("pokes", "prods", "nudges", "annoys")
	sharp = 0
	edge = 0
	parentassembly = /obj/item/weapon/improvised/scissorsassembly/craft

/obj/item/weapon/improvised/mbrick
	name = "Millwall brick"
	desc = "two newspapers folded and rolled together to create an improvised blunt weapon."
	icon = 'icons/urist/items/improvised.dmi'
	icon_state = "mbrick"
	force = 8
	throwforce = 4
	attack_verb = list("bashed", "bludgeoned", "hit", "smacked")
	w_class = 2

/obj/item/weapon/improvised/mbrick/attack_self(mob/user as mob)
	..()

	new /obj/item/weapon/newspaper(get_turf(src))
	new /obj/item/weapon/newspaper(get_turf(src))

	qdel(src)

/obj/item/weapon/improvised/mbrick/attackby(var/obj/item/weapon/W, mob/user as mob)
	..()
	if(istype(W, /obj/item/weapon/material/shard) || istype(W, /obj/item/weapon/improvised/scissorknife))
		var/obj/item/weapon/improvised/mbrick/sharp/S = new /obj/item/weapon/improvised/mbrick/sharp

		user.remove_from_mob(W)
		user.remove_from_mob(src)

		user.put_in_hands(S)
		user << "<span class='notice'>You form the [src] around [W], creating a more lethal Millwall brick.</span>"
		W.loc = S

		qdel(src)

/obj/item/weapon/improvised/mbrick/sharp
	name = "sharp Millwall brick"
	desc = "two newspapers folded and rolled together around a sharp object to create an improvised weapon."
	icon = 'icons/urist/items/improvised.dmi'
	icon_state = "mbricks"
	force = 12
	throwforce = 6
	edge = 1
	sharp = 1
	attack_verb = list("bashed", "stabbed", "hit", "smacked")
	w_class = 2

/obj/item/weapon/improvised/mbrick/sharp/attack_self(mob/user as mob)

	for(var/obj/item/w in contents)
		w.loc = (get_turf(src))
	var/obj/item/weapon/improvised/mbrick/S = new /obj/item/weapon/improvised/mbrick
	user.put_in_hands(S)
	user << "<span class='notice'>You take the sharp object out of the Millwall brick..</span>"
	qdel(src)

//wood shit

/obj/item/weapon/material/twohanded/woodspear
	icon = 'icons/urist/items/improvised.dmi'
	icon_state = "woodspearglass0"
	item_state = "spearglass0"
	name = "spear"
	desc = "A haphazardly-constructed yet still deadly weapon of ancient design. It has a wooden shaft."
	w_class = 4
	slot_flags = SLOT_BACK
	force_divisor = 0.33 //16
	unwielded_force_divisor = 0.2 //10
	throwforce = 18
	throw_speed = 3
	edge = 0
	sharp = 1
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("attacked", "poked", "jabbed", "torn", "gored")
	default_material = "glass"
	applies_material_colour = 0

/obj/item/weapon/material/twohanded/woodspear/update_icon()
	item_state = "spearglass[wielded]"
	return

/obj/item/weapon/material/twohanded/woodquarterstaff
	item_icons = DEF_URIST_INHANDS
	icon = 'icons/urist/items/improvised.dmi'
	item_state = "woodqstaff0"
	icon_state = "qstaff0"
	name = "quarterstaff"
	desc = "A haphazardly-constructed yet still deadly weapon... Looks to be little more than two metal rods tied together."
	w_class = 4.0
	slot_flags = SLOT_BACK
	force_divisor = 0.8 //12
	unwielded_force_divisor = 0.5 //7.5
	throwforce = 8
	//flags = NOSHIELD
	attack_verb = list("attacked", "smashed", "bashed", "smacked", "beaten")
	default_material = "wood"
	applies_material_colour = 0

/obj/item/weapon/material/twohanded/woodquarterstaff/update_icon()
	item_state = "qstaff[wielded]"
	return

/obj/item/weapon/material/twohanded/imppoleaxe
	icon_state = "imppoleaxe0"
	item_state = "spearglass0"
	name = "improvised poleaxe"
	desc = "It's a pole. With an axe tied to it. Okay, why not."
	w_class = 5
	slot_flags = SLOT_BACK
	force_divisor = 1.1 //16.5
	unwielded_force_divisor = 0.7 //10.5
	throwforce = 8
	edge = 1
	sharp = 1
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("attacked", "slashed","torn")
	default_material = "wood"
	applies_material_colour = 0

/obj/item/weapon/material/twohanded/imppoleaxe/update_icon()
	item_state = "spearglass[wielded]"
	return

//end Urist stuff

