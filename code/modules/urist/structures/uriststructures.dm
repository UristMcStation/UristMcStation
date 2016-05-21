 /*										*****New space to put all UristMcStation Structures*****

Please keep it tidy, by which I mean put comments describing the item before the entry.I may or may not move couches and flora here. -Glloyd*/


//THA MAP

/obj/structure/sign/uristmap
	name = "station map"
	icon = 'icons/urist/structures&machinery/structures.dmi'
	desc = "A framed picture of the station."

/obj/structure/sign/uristmap/left
	icon_state = "umap_left"

/obj/structure/sign/uristmap/right
	icon_state = "umap_right"

//signnnnnnnnnssssssssssss

/obj/structure/sign/urist
	icon = 'icons/urist/structures&machinery/structures.dmi'

//Department signs, icons based off the ones from Para station

/obj/structure/sign/urist/deptsigns
	name = "departmental sign"

/obj/structure/sign/urist/deptsigns/sec
	desc = "A sign leading to Security."
	icon_state = "sec"

/obj/structure/sign/urist/deptsigns/sci
	desc = "A sign leading to Research."
	icon_state = "sci"

/obj/structure/sign/urist/deptsigns/eng
	desc = "A sign leading to Engineering."
	icon_state = "eng"

/obj/structure/sign/urist/deptsigns/med
	desc = "A sign leading to Medbay."
	icon_state = "med"

/obj/structure/sign/urist/deptsigns/esc
	desc = "A sign leading to Escape."
	icon_state = "esc"

/obj/structure/sign/urist/deptsigns/arm
	desc = "A sign leading to the Armory."
	icon_state = "arm"

/obj/structure/sign/urist/deptsigns/shut
	desc = "A sign leading to the shuttles."
	icon_state = "shut"

/obj/structure/sign/urist/deptsigns/squads
	desc = "A sign showing the squad number."
	icon_state = "squads"

/obj/structure/sign/urist/deptsigns/lead
	desc = "A sign leading to the squad leaders area."
	icon_state = "lead"

//nt4lyfe

/obj/structure/sign/urist/nt
	name = "Nanotrasen Sign"
	desc = "A large sign proudly displaying the logo of Nanotrasen."
	icon_state = "ntsign"

//ads

/obj/structure/sign/urist/ad/sign1
	icon_state = "sign1"
	name = "Cosmetic Surgery advertisement"
	desc = "An advertisment for Nanotrasen Cosmetic Surgery. Their catchy jingle is still stuck in your head: 'Hate yourself? So do we! Don't choose a bullet, choose Nanotrasen surgery!'"
/obj/structure/sign/urist/ad/sign2
	icon_state = "sign2"
	name = "Luna advertisement"
	desc = "An advertisement for Nanotrasen's offices on Luna. The picture shows an image of Luna before it was terraformed."

/obj/structure/sign/urist/ad/sign3
	icon_state = "sign3"
	name = "5555 Lotto advertisement"
	desc = "An advertisement for the Nanotrasen run 5555 Lotto. You suddenly feel an impulse to buy a ticket next time you're back here."

/obj/structure/sign/urist/ad/sign4
	name = "Space Beer advertisement"
	desc = "An advertisement for Space Beer. The text reads 'Best beer this side of Tau Ceti!'"
	icon_state = "sign4"

/obj/structure/sign/urist/ad/sign5
	name = "Cheesy Honkers advertisement"
	desc = "An advertisement for Cheesy Honkers. The text reads 'Cheesy Honkers! Guaranteed not to give you a miscarriage!'"
	icon_state = "sign5"

//transitmap

/obj/structure/sign/urist/transitmap
	name = "transit map"
	desc = "A handy map giving directions through Central Command's extensive transit network."
	icon_state = "transitmap"

//hacky, but I don't give a fuck. nicer beds

/obj/structure/bed/nice
	name = "bed"
	icon = 'icons/urist/structures&machinery/structures.dmi'
	desc = "This is used to lie in, sleep in or strap on. Looks comfortable."
	icon_state = "bed"
	base_icon = "bed"

/obj/structure/bed/nice/update_icon() //GLLOYDTODO: comeback to this
	return

///obj/structure/bed/nice/New(var/newloc)
//	..(newloc,"plastic","cotton")

//poker tables GLLOYDTODO: Come back to this, maybe trmove this

/obj/structure/table/poker //No specialties, Just a mapping object.
	name = "gambling table"
	desc = "A seedy table for seedy dealings in seedy places."
	icon = 'icons/urist/structures&machinery/structures.dmi'
	icon_state = "pokertable_table"
	parts = /obj/item/weapon/table_parts/poker
	health = 50

/obj/item/weapon/table_parts/poker
	name = "poker table parts"
	desc = "Keep away from fire, and keep near seedy dealers."
	icon = 'icons/urist/items/tgitems.dmi'
	icon_state = "poker_tableparts"
	flags = null

/*/obj/item/weapon/table_parts/wood/attackby(var/obj/item/I, mob/user as mob)
	..()
	if(istype(I, /obj/item/stack/tile/grass))
		var/obj/item/stack/tile/grass/R = I
		var/obj/item/weapon/table_parts/poker/H = new /obj/item/weapon/table_parts/poker
		R.use(1)

		user.remove_from_mob(src)

		user.put_in_hands(H)
		user << "<span class='notice'>You strap a sheet of metal to the hazard vest. Now to tighten it in.</span>" //wut

		qdel(src)
		qdel(I)*/

//shuttle chairs

/obj/structure/bed/chair/urist
	icon = 'icons/urist/structures&machinery/structures.dmi'

/obj/structure/bed/chair/urist/update_icon()
	return

/obj/structure/bed/chair/urist/shuttle
	name = "shuttle chair"
	desc = "A specially padded chair made for shuttles."
	icon_state = "shuttlechair"
	var/image/armrest = null

/obj/structure/bed/chair/urist/shuttle/New()
	armrest = image('icons/urist/structures&machinery/structures.dmi', "shuttlechair_armrest")
	armrest.layer = MOB_LAYER + 0.1

	return ..()

/obj/structure/bed/chair/urist/shuttle/post_buckle_mob()
	if(buckled_mob)
		overlays += armrest
	else
		overlays -= armrest

//random benches

/obj/structure/bed/chair/urist/bench
	name = "bench"
	desc = "A grey bench. No matter how hard you try, you can't seem to get comfortable on it."

/obj/structure/bed/chair/urist/bench/bench1/left
	icon_state = "benchleft"

/obj/structure/bed/chair/urist/bench/bench1/right
	icon_state = "benchright"

/obj/structure/bed/chair/urist/bench/bench1/mid
	icon_state = "benchmid"

/obj/structure/bed/chair/urist/bench/bench2
	desc = "A blue bench found on the Central Command transit system. You'd think it would be padded, but your ass says otherwise."

/obj/structure/bed/chair/urist/bench/bench2/top
	icon_state = "bench2top"

/obj/structure/bed/chair/urist/bench/bench2/mid
	icon_state = "bench2mid"

/obj/structure/bed/chair/urist/bench/bench2/bot
	icon_state = "bench2bot"

//stools

/obj/item/weapon/stool/urist
	icon = 'icons/urist/structures&machinery/structures.dmi'

/obj/item/weapon/stool/urist/update_icon()
	return

/obj/item/weapon/stool/urist/bar
	name = "bar stool"
	icon_state = "barstool"
	item_state = "stool"

/*/obj/item/weapon/stool/urist/wood
	urist_only = 1
	name = "wood stool"
	icon_state = "woodstool"
	item_state = "stool"*/

//Barber

/obj/structure/bed/chair/urist/barber
	name = "barber chair"
	desc = "A soft raised chair that makes it easier for barbers to cut hair."
	icon_state = "barber_chair"

/obj/structure/sign/urist/barber
	name = "barber pole"
	icon = 'icons/urist/structures&machinery/structures.dmi'
	icon_state = "barber_pole"
	desc = "A spinning barber pole."

//more wood stuff GLLOYDTODO: put this to the new system

/obj/structure/filingcabinet/wood
	name = "filing cabinet"
	desc = "A large wood cabinet with drawers."
	icon = 'icons/urist/structures&machinery/structures.dmi'
	icon_state = "tallcabinet"

/obj/structure/filingcabinet/wood/attackby(var/obj/item/P, mob/user as mob)
	if(istype(P, /obj/item/weapon/screwdriver))
		playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
		user << "<span class='notice'>You disassemble \the [src].</span>"
		var/obj/item/stack/material/wood/S =  new /obj/item/stack/material/wood(src.loc)
		S.amount = 2
		for(var/obj/item/b in contents)
			b.loc = (get_turf(src))
		qdel(src)
	..()

//legacy reasons, all this does is create a new table frame somewhere. //i'm okay with this for now

/obj/item/weapon/table_parts
	name = "table parts"
	desc = "Parts of a table. Poor table."
	gender = PLURAL
	icon = 'icons/obj/items.dmi'
	icon_state = "table_parts"
	matter = list("metal" = 3750)
	flags = CONDUCT
	attack_verb = list("slammed", "bashed", "battered", "bludgeoned", "thrashed", "whacked")
	var/tabletype = /obj/structure/table/standard

/obj/item/weapon/table_parts/attack_self(mob/user as mob)
	if(locate(/obj/structure/table) in user.loc)
		user << "<span class='warning'>There is already a table here.</span>"
		return

	else

		new tabletype( user.loc )
		user.drop_item()
		qdel(src)
		return

/obj/item/weapon/table_parts/reinforced
	tabletype = /obj/structure/table/reinforced
	icon_state = "reinf_tableparts"
	name = "reinforced table parts"

/obj/item/weapon/table_parts/wood
	tabletype = /obj/structure/table/woodentable
	icon_state = "wood_tableparts"
	name = "wood table parts"

/obj/item/weapon/table_parts/rack
	name = "rack parts"
	desc = "Parts of a rack. Poor rack."
	tabletype = /obj/structure/table/rack
	icon_state = "rack_parts"

//woodrack

/obj/structure/table/rack/wood
	name = "wooden rack"
	icon = 'icons/urist/structures&machinery/structures.dmi'
	icon_state = "rack"

/obj/structure/table/rack/wood/attackby(var/obj/item/P, mob/user as mob)
	if(istype(P, /obj/item/weapon/wrench))
		playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
		user << "<span class='notice'>You disassemble \the [src].</span>"
		var/obj/item/stack/material/wood/S =  new /obj/item/stack/material/wood(src.loc)
		S.amount = 1
		qdel(src)
	else
		..()

//mapping objects

/obj/structure/table/standard/flipped
	climbable = 0

	flipped = 1
	icon_state = "flip0"

/obj/structure/table/standard/flipped/New()
	..()

	verbs -=/obj/structure/table/verb/do_flip
	verbs +=/obj/structure/table/proc/do_put
	flags |= ON_BORDER
	update_connections(1)
	update_icon()

/obj/structure/table/standard/flipped/n
	dir = 1

/obj/structure/table/standard/flipped/s
	dir = 2
	layer = 5

/obj/structure/table/standard/flipped/e
	dir = 4
	layer = 5

/obj/structure/table/standard/flipped/w
	dir = 8
	layer = 5