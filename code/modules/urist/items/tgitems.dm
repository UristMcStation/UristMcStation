/*										*****New space to put all /tg/station small item ports*****

Please keep it tidy, by which I mean put comments describing the item before the entry. Icons go to 'icons/urist/items/tgitems.dmi'
Please only put items here that don't have a huge definition - Glloyd																*/

//seclite flashlight

/obj/item/device/flashlight/seclite
	item_icons = DEF_URIST_INHANDS
	name = "seclite"
	desc = "A robust flashlight used by security."
	icon = 'icons/urist/items/tgitems.dmi'
	icon_state = "seclite"
	item_state = "seclite"
	force = 9 // Not as good as a stun baton.
	brightness_on = 5 // A little better than the standard flashlight.

//Fucking powergamers

/obj/item/weapon/book/manual/security_space_law/tg
	name = "Space Law"
	desc = "A set of Nanotrasen guidelines for keeping law and order on their space stations."
	icon_state = "bookSpaceLaw"
	author = "Nanotrasen"
	title = "Space Law"

	dat = {"

		<html><head>
		</head>

		<body>
		<iframe width='100%' height='97%' src="http://www.tgstation13.org/wiki/Space_Law?title=Space_Law&printable=yes&remove_links=1" frameborder="0" id="main_frame"></iframe>
		</body>

		</html>

		"}

//technically /vg/, but not warrenting its own .dm

/obj/item/weapon/book/manual/security_space_law/urist
	name = "Corporate Regulations"
	desc = "A set of NanoTrasen guidelines for keeping law and order on their space stations."
	icon_state = "bookSpaceLaw"
	author = "NanoTrasen"
	title = "Corporate Regulations"

/obj/item/weapon/book/manual/security_space_law/urist/New()
	..()

	/* Use this as a template for other in-game manuals. This allows you to store the file locally rather then on a file, which
	reduces space tremendously, allowing you to create much more complex and interesting books (such as a googlespreadsheet.)
	Just replace the var with your own bookname, and point the var into the right direction. - Skeeve2 */

	var/seclaw = file2text('ingame_manuals/corporate_regulations.html')
	if(!seclaw)
		seclaw = "Error loading help (file /ingame_manuals/corporate_regulations.html is probably missing). Please report this to server administration staff."

	dat = seclaw


/obj/effect/decal/warning_stripes/urist
	name = "warning decal"
	icon = 'icons/urist/items/uristdecals.dmi'

/obj/effect/decal/warning_stripes/urist/arrow
	name = "guide arrow"
	icon_state = "arrow"

// -----------------------------
//           Book bag
// -----------------------------

/obj/item/weapon/storage/bag/books
	name = "book bag"
	desc = "A bag for books."
	icon = 'icons/urist/items/tgitems.dmi'
	icon_state = "bookbag"
	storage_slots = 7
	max_storage_space = 21 //check values!
	max_w_class = 3
	w_class = 4 //Bigger than a book because physics
	can_hold = list(/obj/item/weapon/book, /obj/item/weapon/spellbook) //No bibles, consistent with bookcase

//moo000ooo000ooo

/obj/item/weapon/veilrender //WTF, it was removed for now discernible reason in the spellsystem port
	name = "veil render"
	desc = "A wicked curved blade of alien origin, recovered from the ruins of a vast city."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "render"
	item_state = "render"
	force = 15
	throwforce = 10
	w_class = 3
	var/charged = 1


/obj/effect/rend
	name = "Tear in the fabric of reality"
	desc = "You should run now"
	icon = 'icons/obj/wizard.dmi'
	icon_state = "rift"
	density = 1
	unacidable = 1
	anchored = 1.0


/obj/effect/rend/New()
	spawn(50)
		new /obj/singularity/narsie/wizard(get_turf(src))
		qdel(src)
		return
	return


/obj/item/weapon/veilrender/attack_self(mob/user as mob)
	if(charged == 1)
		new /obj/effect/rend(get_turf(usr))
		charged = 0
		visible_message("<span class='danger'>[src] hums with power as [usr] deals a blow to reality itself!</span>")
	else
		user << "<span class='warning'> The unearthly energies that powered the blade are now dormant</span>"

/obj/item/weapon/veilrender/vealrender
	name = "veal render"
	desc = "A wicked curved blade of alien origin, recovered from the ruins of a vast farm."

/obj/item/weapon/veilrender/vealrender/attack_self(mob/user as mob)
	if(charged)
		new /obj/effect/rend/cow(get_turf(usr))
		charged = 0
		visible_message("<span class='danger'>[src] hums with power as [usr] deals a blow to hunger itself!</span>")
	else
		user << "<span class='warning'> The unearthly energies that powered the blade are now dormant.</span>"

/obj/effect/rend/cow
	desc = "Reverberates with the sound of ten thousand moos."
	var/cowsleft = 20

/obj/effect/rend/cow/New()
	processing_objects.Add(src)
	return

/obj/effect/rend/cow/process()
	if(locate(/mob) in loc) return
	new /mob/living/simple_animal/cow(loc)
	cowsleft--
	if(cowsleft <= 0)
		qdel(src)

/obj/effect/rend/cow/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/weapon/nullrod))
		visible_message("<span class='danger'>[I] strikes a blow against \the [src], banishing it!</span>")
		spawn(1)
			qdel(src)
		return
	..()

//Medals. Noone uses them, but I like them, so fuck you all.

/obj/item/weapon/storage/lockbox/medal
	name = "medal box"
	desc = "A locked box used to store medals of honor."
	icon = 'icons/urist/items/tgitems.dmi'
	icon_state = "medalbox+l"
	item_state = "syringe_kit"
	w_class = 3
	max_w_class = 2
	storage_slots = 7
	req_access = list(access_captain)
	icon_locked = "medalbox+l"
	icon_closed = "medalbox"
	icon_broken = "medalbox+b"

	New()
		..()
		new /obj/item/clothing/accessory/medal/silver(src)
		new /obj/item/clothing/accessory/medal/silver(src)
		new /obj/item/clothing/accessory/medal/bronze/nanotrasen(src)
		new /obj/item/clothing/accessory/medal/gold(src)
		new /obj/item/clothing/accessory/medal/iron(src)
		new /obj/item/clothing/accessory/medal/iron/nanotrasen(src)
		new /obj/item/clothing/accessory/medal/gold/nanotrasen(src)

//holojanisign

/obj/item/weapon/holosign_creator
	name = "holographic sign projector"
	desc = "A handy-dandy projector that displays a janitorial sign."
	icon = 'icons/urist/items/tgitems.dmi'
	icon_state = "signmaker"
	item_state = "electronic"
	force = 5
	w_class = 2
	throwforce = 0
	throw_speed = 3
	throw_range = 7
	origin_tech = "programming=3"
	var/list/signs = list()
	var/max_signs = 10

/obj/item/weapon/holosign_creator/afterattack(atom/target, mob/user, flag)
	if(flag)
		var/turf/T = get_turf(target)
		var/obj/effect/overlay/holograph/H = locate() in T
		if(H)
			user << "<span class='notice'>You use [src] to destroy [H].</span>"
			qdel(H)
		else
			if(signs.len < max_signs)
				H = new(get_turf(target))
				signs += H
				user << "<span class='notice'>You create \a [H] with [src].</span>"
			else
				user << "<span class='notice'>[src] is projecting at max capacity!</span>"

/obj/item/weapon/holosign_creator/attack(mob/living/carbon/human/M, mob/user)
	return

/obj/item/weapon/holosign_creator/attack_self(mob/user)
	if(signs.len)
		var/list/L = signs.Copy()
		for(var/sign in L)
			qdel(sign)
			signs -= sign
		user << "<span class='notice'>You clear all active holograms.</span>"


/obj/effect/overlay/holograph
	name = "wet floor sign"
	desc = "The words flicker as if they mean nothing."
	icon = 'icons/urist/items/tgitems.dmi'
	icon_state = "holosign"
	anchored = 1

/obj/item/weapon/grenade/chem_grenade/teargas
	name = "teargas grenade"
	desc = "Used for nonlethal riot control. Contents under pressure. Do not directly inhale contents."
	path = 1
	stage = 2

	New()
		..()
		var/obj/item/weapon/reagent_containers/glass/beaker/B1 = new(src)
		var/obj/item/weapon/reagent_containers/glass/beaker/B2 = new(src)

		B1.reagents.add_reagent("condensedcapsaicin", 25)
		B1.reagents.add_reagent("potassium", 25)
		B2.reagents.add_reagent("phosphorus", 25)
		B2.reagents.add_reagent("sugar", 25)

		detonator = new/obj/item/device/assembly_holder/timer_igniter(src)

		beakers += B1
		beakers += B2
		icon_state = "grenade"

/obj/item/weapon/storage/box/teargas
	name = "box of tear gas grenades (WARNING)"
	desc = "<B>WARNING: These devices are extremely dangerous and can cause blindness and skin irritation.</B>"
	icon_state = "flashbang"

//TG cigarettes
/obj/item/weapon/storage/fancy/cigarettes/urist
	name = "urist packet"
	desc = "The most dwarven of all cigarettes"
	icon = 'icons/urist/items/tgitems.dmi'
	w_class = 1
	throwforce = 2
	slot_flags = SLOT_BELT
	storage_slots = 6
	key_type = /obj/item/clothing/mask/smokable/cigarette


/obj/item/weapon/storage/fancy/cigarettes/urist/uplift
	name = "uplift smooth packet"
	desc = "Your favorite brand, now menthol flavored."
	icon_state = "upliftpacket"
	item_state = "upliftpacket"

/obj/item/weapon/storage/fancy/cigarettes/urist/devil
	name = "devil's premium packet"
	desc = "Smoked only by the baddest of the bad."
	icon_state = "devilpacket"
	item_state = "devilpacket"

/obj/item/weapon/storage/fancy/cigarettes/urist/carp
	name = "carp classic packet"
	desc = "Seems a little fishy."
	icon_state = "carppacket"
	item_state = "carppacket"

/obj/item/weapon/storage/fancy/cigarettes/urist/syndicate
	name = "cigarette packet"
	desc = "An obscure brand of cigarettes."
	icon_state = "syndiepacket"
	item_state = "syndiepacket"

/obj/item/weapon/storage/fancy/cigarettes/urist/syndicate/New()
	..()
	for(var/i = 1 to storage_slots)
		reagents.add_reagent("doctorsdelight",15)

/obj/item/weapon/storage/fancy/cigarettes/urist/midori
	name = "midori tabako packet"
	desc = "Does this packet smell funny to you?"
	icon_state = "midoripacket"
	item_state = "midoripacket"

/obj/item/weapon/storage/fancy/cigarettes/urist/shadyjim
	name = "shady jim packet"
	desc = "Shady Jim's super slim packets! Watch the fat burn away, guaranteed!"
	icon_state = "shadyjimpacket"
	item_state = "shadyjimpacket"

/obj/item/weapon/storage/fancy/cigarettes/urist/shadyjim/New()
	..()
	for(var/i = 1 to storage_slots)
		reagents.add_reagent("lipozine",4)
		reagents.add_reagent("ammonia",2)
		reagents.add_reagent("plantbgone",1)
		reagents.add_reagent("toxin",1.5)

// Smuggler's satchel from /tg/.

/obj/item/weapon/storage/backpack/satchel_flat
	name = "smuggler's satchel"
	desc = "A very slim satchel that can easily fit into tight spaces."
	icon = 'icons/urist/items/tgitems.dmi'
	icon_override = 'icons/uristmob/back.dmi'
	icon_state = "satchel-flat"
	w_class = 3 //Can fit in backpacks itself.
	storage_slots = 5
	max_storage_space = 15 //check values!
	level = 1
	cant_hold = list(/obj/item/weapon/storage/backpack/satchel_flat) //muh recursive backpacks

/obj/item/weapon/storage/backpack/satchel_flat/hide(var/intact)
	if(intact)
		invisibility = 101
		anchored = 1 //otherwise you can start pulling, cover it, and drag around an invisible backpack.
		icon_state = "[initial(icon_state)]2"
	else
		invisibility = initial(invisibility)
		anchored = 0
		icon_state = initial(icon_state)

/obj/item/weapon/storage/backpack/satchel_flat/New()
	..()
	new /obj/item/weapon/crowbar(src)

// Rolling papers from /tg/

/obj/item/clothing/mask/smokable/cigarette/rollie
	icon = 'icons/urist/items/tgitems.dmi'
	icon_override = 'icons/uristmob/mask.dmi'

	name = "rollie"
	desc = "A roll of dried plant matter wrapped in thin paper."
	icon_state = "spliffoff"
	icon_on = "spliffon"
	type_butt = /obj/item/weapon/cigbutt/roach
	throw_speed = 0.5
	item_state = "spliffoff"
	smoketime = 180
	chem_volume = 50

/obj/item/clothing/mask/cigarette/rollie/New()
	..()
	src.pixel_x = rand(-5, 5)
	src.pixel_y = rand(-5, 5)

/obj/item/weapon/cigbutt/roach
	icon = 'icons/urist/items/tgitems.dmi'

	name = "roach"
	desc = "A manky old roach, or for non-stoners, a used rollup."
	icon_state = "roach"

/obj/item/weapon/cigbutt/roach/New()
	..()
	src.pixel_x = rand(-5, 5)
	src.pixel_y = rand(-5, 5)


/obj/item/weapon/rollingpaper
	name = "rolling paper"
	desc = "A thin piece of paper used to make fine smokeables."
	icon = 'icons/urist/items/tgitems.dmi'
	icon_state = "cig_paper"
	w_class = 1

/obj/item/weapon/rollingpaper/afterattack(atom/target, mob/user, proximity)
	if(!proximity)
		return
	if(istype(target, /obj/item/weapon/reagent_containers/food/snacks/grown))
		var/obj/item/weapon/reagent_containers/food/snacks/grown/O = target
		if(O.dry)
			user.unEquip(target, 1)
			user.unEquip(src, 1)
			var/obj/item/clothing/mask/smokable/cigarette/rollie/R = new /obj/item/clothing/mask/smokable/cigarette/rollie(user.loc)
			R.chem_volume = target.reagents.total_volume
			target.reagents.trans_to_holder(R.reagents, R.chem_volume)
			user.put_in_active_hand(R)
			user << "<span class='notice'>You roll the [target.name] into a rolling paper.</span>"
			R.desc = "Dried [target.name] rolled up in a thin piece of paper."
			qdel(target)
			qdel(src)
		else
			user << "<span class='warning'>You need to dry this first!</span>"
	else
		..()

/obj/item/weapon/storage/fancy/rollingpapers
	name = "rolling paper pack"
	desc = "A pack of NanoTrasen brand rolling papers."
	w_class = 1
	icon = 'icons/urist/items/tgitems.dmi'
	icon_state = "cig_paper_pack"
	storage_slots = 10
	key_type = /obj/item/weapon/rollingpaper
	can_hold = list(/obj/item/weapon/rollingpaper)
	startswith = list(/obj/item/weapon/rollingpaper = 10)


/obj/item/weapon/storage/fancy/rollingpapers/update_icon()
	overlays.Cut()
	if(!contents.len)
		overlays += "[icon_state]_empty"
	return