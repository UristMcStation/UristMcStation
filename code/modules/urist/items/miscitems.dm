//misc items that need a home

/obj/item/staff/necrostaff
	item_icons = DEF_URIST_INHANDS
	name = "necromancer's staff"
	desc = "A staff that emits a threatening aura of death."
	icon = 'icons/urist/items/misc.dmi'
	icon_state = "necrostaff"
	item_state = "necrostaff"

/obj/item/card/id/blueshield
	name = "identification card"
	desc = "A card issued to the station's blueshield."
	color = COLOR_GRAY40
	detail_color = COLOR_COMMAND_BLUE
	extra_details = list("goldstripe")
	job_access_type = /datum/job/blueshield

/obj/item/storage/box/glowsticks
	name = "box of glowsticks"
	desc = "Contains seven different coloured glowsticks."
	icon = 'icons/urist/items/misc.dmi'
	icon_state = "gsbox"

	startswith = list(
		/obj/item/device/flashlight/flare/glowstick/green,
		/obj/item/device/flashlight/flare/glowstick/red,
		/obj/item/device/flashlight/flare/glowstick/blue,
		/obj/item/device/flashlight/flare/glowstick/orange,
		/obj/item/device/flashlight/flare/glowstick/purple,
		/obj/item/device/flashlight/flare/glowstick/yellow,
		/obj/item/device/flashlight/flare/glowstick/random
		)

//wood stuff

/obj/item/material/minihoe/wood/New()
	..()
	icon = 'icons/urist/items/wood.dmi'
	matter = list(DEFAULT_WALL_MATERIAL = 400, "wood" = 250)

/obj/item/material/hatchet/wood/New()
	..()
	icon = 'icons/urist/items/wood.dmi'
	matter = list(DEFAULT_WALL_MATERIAL = 350, "wood" = 250)

/obj/item/reagent_containers/food/drinks/woodcup
	name = "cup"
	desc = "A simple wooden cup."
	icon = 'icons/urist/items/wood.dmi'
	icon_state = "cup"
	volume = 30
	center_of_mass = list("x"=15, "y"=13)
	matter = list("wood" = 50)

/obj/item/dice/wood
	name = "d6"
	matter = list("wood" = 30)
	icon = 'icons/urist/items/wood.dmi'

/obj/item/mop/wood
	icon = 'icons/urist/items/wood.dmi'
	matter = list(DEFAULT_WALL_MATERIAL = 150, "wood" = 200)

/obj/item/pickaxe/old
	name = "pickaxe"
	desc = "The most basic of mining tools, for short excavations and small mineral extractions."
	icon = 'icons/urist/items/wood.dmi'
	icon_state = "pickaxe"
	item_state = "pickaxe"
	matter = list(DEFAULT_WALL_MATERIAL = 2000, "wood" = 900)

/obj/item/shovel/spade/wood
	name = "spade"
	desc = "A small tool for digging and moving dirt. It has a wooden handle"
	icon = 'icons/urist/items/wood.dmi'
	matter = list(DEFAULT_WALL_MATERIAL = 300, "wood" = 300)

/obj/item/material/ashtray/wood/New(newloc)
	..(newloc, "wood")

//for the blueshield

/obj/item/storage/box/deathimp
	name = "death alarm implant kit"
	desc = "Box of life sign monitoring implants."
	icon_state = "implant"

/obj/item/storage/box/deathimp/New()
	..()
	new /obj/item/implantcase/death_alarm(src)
	new /obj/item/implantcase/death_alarm(src)
	new /obj/item/implantcase/death_alarm(src)
	new /obj/item/implantcase/death_alarm(src)
	new /obj/item/implantcase/death_alarm(src)
	new /obj/item/implanter(src)
	new /obj/item/implantpad(src)

/*/obj/item/stack/woodrods //bay has these
	name = "wood shafts"
	desc = "Some wood shafts. Can be used for some shit probably."
	singular_name = "wood shaft"
	icon = 'icons/urist/items/misc.dmi'
	icon_state = "woodrods"
	w_class = 4
	force = 8.0
	throwforce = 10
	throw_speed = 5
	throw_range = 20
	matter = list("wood" = 200)
	max_amount = 100
	center_of_mass = null
	attack_verb = list("hit", "bludgeoned", "whacked")

/obj/item/stack/woodrods/New()
	..()
	update_icon()*/

/obj/item/stack/material/rods/use_tool(obj/item/W, mob/living/user, list/click_params)
	var/obj/item/stack/material/rods/R = src

	if(W.sharp && W.edge && !sharp)

		if(!istype(R.material, /material/wood))
			to_chat(user, SPAN_NOTICE("This is too hard to sharpen - try a wooden rod."))
			return
		else
			to_chat(user, SPAN_WARNING("You use the edge of [W] to sharpen the tip of the shaft."))
			new /obj/item/sharpwoodrod(user.loc)
			src.use(1)


	if(istype(W, /obj/item/reagent_containers/glass/rag))
//		var/obj/item/reagent_containers/glass/rag/R = W
		var/obj/item/flame/torch/T = new /obj/item/flame/torch(get_turf(user))
		to_chat (user, SPAN_NOTICE("You wrap the rag around the shaft forming an improvised torch."))
		src.use(1)
		user.drop_from_inventory(W)
		qdel(W)

		user.put_in_hands(T)

	else if(istype(W, /obj/item/improv/axe_head))
		var/obj/item/carpentry/axe/T = new /obj/item/carpentry/axe(get_turf(user))
		to_chat (user, SPAN_NOTICE("You fit the axe head onto the wooden rod.."))
		src.use(1)
		user.drop_from_inventory(W)
		qdel(W)

		user.put_in_hands(T)

	else if(istype(W, /obj/item/improv/pickaxe_head))
		var/obj/item/pickaxe/old/T = new /obj/item/pickaxe/old(get_turf(user))
		to_chat (user, SPAN_NOTICE("You fit the pickaxe head onto the wooden rod.."))
		src.use(1)
		user.drop_from_inventory(W)
		qdel(W)

		user.put_in_hands(T)
	else
		..()
/*/obj/item/stack/woodrods/attack_self(mob/user as mob)
	src.add_fingerprint(user)

	if(!isturf(user.loc)) return 0

	if (locate(/obj/structure/grille/wood, usr.loc))
		for(var/obj/structure/grille/wood/G in usr.loc)
			if (G.destroyed)
				G.health = 6
				G.density = TRUE
				G.destroyed = 0
				G.icon_state = "grille"
				use(1)
			else
				return 1

	else if(!in_use)
		if(get_amount() < 2)
			to_chat(user, "<span class='warning'>You need at least two wood shafts to do this.</span>")
			return
		to_chat(user, "<span class='notice'>Assembling grille...</span>")
		in_use = 1
		if (!do_after(usr, 10))
			in_use = 0
			return
		var/obj/structure/grille/wood/F = new /obj/structure/grille/wood/ ( usr.loc )
		to_chat(user, "<span class='notice'>You assemble a wooden grille</span>")
		in_use = 0
		F.add_fingerprint(usr)
		use(2)
	return

/obj/item/stack/woodrods/on_update_icon()
	if(amount == 1)
		icon_state = "woodrod"
	else
		icon_state = initial(icon_state)

/obj/item/stack/woodrods/use()
	. = ..()
	update_icon()

/obj/item/stack/woodrods/add()
	. = ..()
	update_icon()
*/
/obj/item/sharpwoodrod
	icon = 'icons/urist/items/misc.dmi'
//	item_state = "sharpwoodrod"
	icon_state = "sharpwoodrod"
	name = "sharpened wooden shaft"
	desc = "A haphazardly sharpened shaft of wood"
	force = 10
	w_class = 3.0
	throwforce = 10
	attack_verb = list("attacked", "stabbed")
	sharp = 1

/*/obj/item/material/woodwirerod
	name = "wired shaft"
	desc = "A rod with some wire wrapped around the top. It'd be easy to attach something to the top bit."
	icon_state = "wiredrod"
	item_state = "rods"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	force_multiplier = 0.55
	throwforce = 10
	w_class = 3
	attack_verb = list("hit", "bludgeoned", "whacked", "bonked")
	default_material = "wood"

/obj/item/material/woodwirerod/use_tool(obj/item/I, mob/living/user, list/click_params)
	..()
	var/obj/item/finished
	if(istype(I, /obj/item/material/shard) || istype(I, /obj/item/material/small_blade) || istype(I, /obj/item/material/large_blade))
		var/obj/item/material/tmp_shard = I

		var/want = input("What would you like to make?", "Weapon construction", "Cancel") in list ("Cancel", "Spear", "Makeshift Arrow")
		switch(want)
			if("Cancel")
				return
			if("Spear")
				finished = new /obj/item/material/twohanded/woodspear(get_turf(user), tmp_shard.material.name)
				to_chat(user, "<span class='notice'>You fasten \the [I] to the top of the shaft with the cable.</span>")
			if("Makeshift Arrow")
				finished = new /obj/item/arrow/improv (get_turf(user), tmp_shard.material.name)
				to_chat(user, "<span class='notice'>You fasten \the [I] to the top of the shaft with the cable.</span>")

	else if(istype(I, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/R = I
		if (R.use(1))
			finished = new /obj/item/fishingrod/improvised(get_turf(user))
			to_chat(user, "<span class='notice'>You tie in the length of cable, forming an improvised fishing rod.</span>")

	/*else if(istype(I, /obj/item/stack/woodrods))
		var/obj/item/stack/woodrods/R = I
		if (R.use(1))
			finished = new /obj/item/material/twohanded/woodquarterstaff(get_turf(user))
			to_chat(user, "<span class='notice'>You fasten the two rods together tightly with the cable.</span>")*/

	else if(istype(I, /obj/item/stack/material/steel))
		var/obj/item/stack/material/steel/R = I
		if (R.use(1))
			finished = new /obj/item/shovel/improvised(get_turf(user))
			to_chat(user, "<span class='notice'>You fasten the metal sheet to the shaft, forming an improvised shovel.</span>")

	else if(istype(I, /obj/item/material/hatchet))
		finished = new /obj/item/material/twohanded/imppoleaxe(get_turf(user))
		to_chat(user, "<span class='notice'>You fasten the hatchet to the shaft, forming an improvised poleaxe.</span>")

	if(finished)
		user.drop_from_inventory(src)
		user.drop_from_inventory(I)
		qdel(I)
		qdel(src)
		user.put_in_hands(finished)
	update_icon(user)*/

/obj/item/flame/torch
	name = "torch"
	desc = "An improvised torch, used for lighting up dark areas and cosplaying as Indiana Jones."
	icon = 'icons/urist/items/misc.dmi'
	icon_state = "torch_unlit"
	item_state = "torch0"
	var/burnt = 0
	var/smoketime = 500
	w_class = 3.0
	force = 7
	origin_tech = list(TECH_MATERIAL = 1)
	attack_verb = list("hit", "bashed", "smacked")
	light_color = "#e09d37"

/obj/item/flame/torch/New()
	smoketime = rand(500, 600)
	..()

/obj/item/flame/torch/Process()
	if(isliving(loc))
		var/mob/living/M = loc
		M.IgniteMob()
	var/turf/location = get_turf(src)
	smoketime--
	if(smoketime < 1)
		burn_out()
		return
	if(location)
		location.hotspot_expose(700, 5)
		return

/obj/item/flame/torch/use_tool(obj/item/W, mob/living/user, list/click_params)
	..()
	if(burnt || lit)
		return

	else
		if(istype(W, /obj/item/weldingtool))
			var/obj/item/weldingtool/WT = W
			if(WT.isOn()) //Badasses dont get blinded by lighting their torch with a welding tool
				light("<span class='notice'>\The [user] casually lights the [name] with [W].</span>")
		else if(istype(W, /obj/item/flame))
			var/obj/item/flame/L = W
			if(L.lit)
				light()

/obj/item/flame/torch/proc/light(flavor_text = "<span class='notice'>\The [usr] lights the [name].</span>")
	if(!lit)
		lit = 1
		src.damtype = "fire"
		for(var/mob/O in viewers(usr, null))
			O.show_message(flavor_text, 1)
		set_light(CANDLE_LUM)
		START_PROCESSING(SSobj, src)
		attack_verb = list("hit", "burnt", "singed")
		w_class = 4
		icon_state = "torch_lit"
		item_state = "torch1"
		usr.regenerate_icons()


/obj/item/flame/torch/proc/burn_out()
	lit = 0
	burnt = 1
	damtype = "brute"
	icon_state = "torch_burnt"
	item_state = "woodrod"
	name = "burnt torch"
	desc = "A burnt out torch."
	STOP_PROCESSING(SSobj, src)
	w_class = 3
	force = 7
	attack_verb = list("hit", "bashed", "smacked")
	usr.regenerate_icons()

/obj/item/shovel/improvised
	name = "improvised shovel"
	desc = "A shitty improvised shovel, watch out though, might break."
	icon = 'icons/urist/items/improvised.dmi'
	icon_state = "impshovel"
	slot_flags = SLOT_BELT
	force = 8.0
	throwforce = 4.0
	item_state = "shovel"
	w_class = 5
	matter = list(DEFAULT_WALL_MATERIAL = 500, "wood" = 600)
	attack_verb = list("bashed", "bludgeoned", "thrashed", "whacked")
	edge = 1

/obj/item/shovel/improvised/afterattack(mob/user as mob)
	if(prob(5))
		to_chat(user, "<span class='notice'>The shovel falls apart in your hands!</span>")
//		new /obj/item/material/woodwirerod(user.loc)
		qdel(src)

	..()

/obj/item/paddle
	name = "paddle"
	desc = "A shaped piece of wood, best used for manually propelling waterborne objects."
	icon = 'icons/urist/items/misc.dmi'
	icon_state = "paddle"
	slot_flags = SLOT_BACK
	force = 8.0
	throwforce = 4.0
	item_state = "shovel"
	w_class = 4
	matter = list("wood" = 600)
	attack_verb = list("bashed", "bludgeoned", "thrashed", "whacked")

/obj/item/device/radio/medical
	name = "emergency medical radio"
	icon = 'icons/urist/items/misc.dmi'
	icon_state = "medradio"
	frequency = MED_I_FREQ

//jeez this file is a mess. anyways, here's an empty welder for merchants

/obj/item/weldingtool/empty
	tank = /obj/item/welder_tank/empty

/obj/item/welder_tank/empty
	max_fuel = 0


/obj/item/welder_tank/empty/Initialize()
	. = ..()
	max_fuel = 20 //this is a dumb hack and i hate it

//mapping object

/obj/item/trash/cigbutt/rand

/obj/item/trash/cigbutt/rand/New()
	pixel_x = rand(1,9)
	pixel_y = rand(1,9)
	..()

//pickaxe and axe heads

/obj/item/improv/axe_head
	name = "axe head"
	desc = "It's an axe head. Slam it on a wood rod and you got yourself an axe son."
	icon = 'icons/urist/items/improvised.dmi'
	icon_state = "axehead"

/obj/item/improv/axe_head/use_tool(obj/item/W, mob/living/user, list/click_params)
	..()

	if(istype(W, /obj/item/stack/material/rods))
		var/obj/item/stack/material/rods/R = W
		var/obj/item/carpentry/axe/T = new /obj/item/carpentry/axe(get_turf(user))
		if(!istype(R.material, /material/wood))
			to_chat(user, SPAN_NOTICE("This is too hard to work with - try a wooden rod."))
			return
		else
			to_chat(user, SPAN_NOTICE("You slam that axe head down onto the wood rod. You got yourself an axe son."))
		R.use(1)

		user.put_in_hands(T)

/obj/item/improv/pickaxe_head
	name = "pickaxe head"
	desc = "It's a pickaxe head. Slam it on a wood rod and you got yourself a pickaxe son."
	icon = 'icons/urist/items/improvised.dmi'
	icon_state = "pickaxehead"

/obj/item/improv/pickaxe_head/use_tool(obj/item/W, mob/living/user, list/click_params)
	..()

	if(istype(W, /obj/item/stack/material/rods))
		var/obj/item/stack/material/rods/R = W
		var/obj/item/pickaxe/old/T = new /obj/item/pickaxe/old(get_turf(user))
		if(!istype(R.material, /material/wood))
			to_chat(user, SPAN_NOTICE("This is too hard to work with - try a wooden rod."))
			return
		else
			to_chat(user, SPAN_NOTICE("You slam that pickaxe head down onto the wood rod. You got yourself a pickaxe son."))
		R.use(1)

		user.put_in_hands(T)

// Survival Box + Other Gear.

/obj/item/storage/box/survivalkit
	name = "expedition survival kit"
	desc = "A medium sized water-proofed holding case, which contains multiple tools used for survival on an expedition."
	icon = 'icons/urist/items/misc.dmi'
	icon_state = "survivalkit"
	startswith = list(/obj/item/material/knife/survivalknife = 1,
					/obj/item/reagent_containers/food/drinks/survivalcanteen = 1,
					/obj/item/device/radio = 1,
					/obj/item/stack/medical/bruise_pack = 1,
					/obj/item/stack/medical/ointment = 1,
					/obj/item/device/flashlight/flare/glowstick = 1,
					/obj/item/reagent_containers/food/snacks/proteinbar = 1)

/obj/item/reagent_containers/food/drinks/survivalcanteen
	name = "survival canteen"
	desc = "A stainless steel screw-topped green survival canteen with a brown cover, which can hold a fair amount of liquid for travel."
	icon = 'icons/urist/items/misc.dmi'
	icon_state = "canteen"

// NT Stamp

/obj/item/stamp/nt
	name = "\improper NanoTrasen rubber stamp"
	icon_state = "stamp-intaff"

// Clown Stuff

/obj/item/card/id/fakecappy
	name = "captain identification card"
	desc = "A golden card which shows power and might?"
	color = "#d4c780"
	extra_details = list("goldstripe")

//Fake Replica Nuclear Authentication Disk, can't arm the nuke.
/obj/item/disk/fakenucleardisk
	name = "nuclear authentication disk"
	desc = "A nuclear authentication disk, used for arming the self-destruct system. On closer inspection, this appears to be some sort of dummy replica meant for training exercises, how did it end up here?"
	icon = 'icons/obj/datadisks.dmi'
	icon_state = "nucleardisk"
	item_state = "card-id"
	w_class = ITEM_SIZE_TINY

// Fake Plastic Cap Gun of the Colt Single Action
/obj/item/gun/projectile/revolver/coltsaa/fake
	desc = "A poorly made plastic replica of the Colt Single Action Army revolver dating from the late 19th century. It appears to shoot pop caps, with tactical plastic painted engravings that offer no tactical advantage."
	caliber = "caps"
	ammo_type = /obj/item/ammo_casing/cap

//Coptain
/obj/item/stamp/captain/fake
	name = "\improper coptain's rubber stamp"

//Chief Engineer
/obj/item/stamp/ce/fake
	name = "\improper chief enginoor rubber stamp"

//Senior Scientist
/obj/item/stamp/rd/fake
	name = "\improper senior citizenist rubber stamp"

//Chief Medical Officier
/obj/item/stamp/cmo/fake
	name = "\improper chef of medicine rubber stamp"

//Chief of Securrrrity
/obj/item/stamp/hos/fake
	name = "\improper chief of securrrity's rubber stamp"

//Centconk
/obj/item/stamp/centcomm/fake
	name = "\improper centconk rubber stamp"

//Nonotrasen
/obj/item/stamp/nt/fake
	name = "\improper NonoTrasen rubber stamp"

//Quarterbackmaster
/obj/item/stamp/qm/fake
	name = "quarterbackmaster's rubber stamp"

/obj/random/clown
	name = "Random Clown Item"
	desc = "This is a random clown item."
	icon = 'icons/obj/parcels.dmi'
	icon_state = "gift3"

/obj/random/clown/spawn_choices()
	return list(/obj/item/card/id/fakecappy,
				/obj/item/disk/fakenucleardisk,
				/obj/item/gun/projectile/revolver/coltsaa/fake,
				/obj/item/stamp/captain/fake,
				/obj/item/stamp/ce/fake,
				/obj/item/stamp/rd/fake,
				/obj/item/stamp/cmo/fake,
				/obj/item/stamp/hos/fake,
				/obj/item/stamp/centcomm/fake,
				/obj/item/stamp/nt/fake,
				/obj/item/stamp/qm/fake,
				)

//gloves for recipes_leather.dm
/obj/item/clothing/gloves/botanic_leather
	desc = "These leather work gloves protect against thorns, barbs, prickles, spikes and other harmful objects of floral origin."
	name = "botanist's leather gloves"
	icon_state = "leather"
	item_state = "ggloves"
	permeability_coefficient = 0.05
	siemens_coefficient = 0.50 //thick work gloves
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)

//replica boat
/obj/item/toy/torchmodel/urist
	name = "table-top replica ship"
	desc = "This is a replica of an unnamed exploration ship on a handsome wooden stand. Small lights blink on the hull and at the engine exhaust."

//old hand radio
/obj/item/device/radio/off/old
	icon = 'icons/urist/structures&machinery/machinery.dmi'
	icon_state = "portable_radio2"
	item_state = "portable_radio2"

//treasures meant as away loot, move some of these if they ever become a functional item like magic orbs/gems

/obj/item/treasure
	icon = 'icons/urist/items/misc.dmi'
	throwforce = 0
	throw_speed = 4
	throw_range = 20
	force = 0
	w_class = 2

/obj/item/treasure/tape
	name = "retro holotape"
	desc = "An old holotape cassette. Could be someone's mixtape or have valuable data."
	icon_state = "tape1"

/obj/item/treasure/tape/tape2
	icon_state = "tape5"

/obj/item/treasure/tape/tape3
	icon_state = "tape6"

/obj/item/material/coin/challenge/loot/copper
	name = "\improper old copper coin"
	desc = "A copper coin stamped with the image of a sailing ship."
	icon = 'icons/urist/items/misc.dmi'
	icon_state = "oldcoin4"
	default_material = MATERIAL_COPPER
	applies_material_name = FALSE

/obj/item/material/coin/challenge/loot/plat
	name = "\improper old platinum coin"
	desc = "A platinum coin stamped with the image of a king."
	icon = 'icons/urist/items/misc.dmi'
	icon_state = "oldcoin1"
	default_material = MATERIAL_PLATINUM
	applies_material_name = FALSE

/obj/item/material/coin/challenge/loot/gold
	name = "\improper old gold coin"
	desc = "A gold coin stamped with the image of a castle."
	icon = 'icons/urist/items/misc.dmi'
	icon_state = "oldcoin2"
	default_material = MATERIAL_GOLD
	applies_material_name = FALSE

/obj/item/material/coin/challenge/loot/silver
	name = "\improper old silver coin"
	desc = "A silver coin stamped with the image of a dragon."
	icon = 'icons/urist/items/misc.dmi'
	icon_state = "oldcoin3"
	default_material = MATERIAL_SILVER
	applies_material_name = FALSE

/obj/item/treasure/gem
	name = "astonishing amethyst"
	desc = "An amethyst crystal with the deepest purple."
	icon_state = "amethyst"

/obj/item/treasure/gem/pearl
	name = "portentious pearl"
	desc = "A particularly beautiful pearl."
	icon_state = "pearl"

/obj/item/treasure/gem/ruby
	name = "resplendent ruby"
	desc = "A ruby fit for a crown."
	icon_state ="ruby"

/obj/item/treasure/gem/sapphire
	name = "splendid sapphire"
	desc = "A sapphire that sparkles in the faintest light."
	icon_state = "sapphire"

/obj/item/treasure/gem/emerald
	name = "enticing emerald"
	desc = "An emerald cut with all the finest craftsmanship."
	icon_state = "emerald"

/obj/item/treasure/gem/prism
	name = "perfect prismatic crystal"
	desc = "A brilliantly colored gem"
	icon_state = "prismaticgem"

//thanks Grant for these names. I hate you so much <3
/obj/item/treasure/gem/opal
	name = "imperious opal"
	desc = "An extravagant multi-colored gem."
	icon_state = "opal"

/obj/item/treasure/gem/fancyquartz
	name = "polished pink star quartz"
	desc = "A normally common stone, this one has a lovely pink with an imperfection giving the appearance of a trapped star."
	icon_state = "starquartz"

/obj/item/treasure/gem/fireopal
	name = "fabulous fire opal"
	desc = "A stone with a blaze inside. It won't keep you warm despite the name."
	icon_state = "fireopal"

/obj/item/treasure/gem/ruby/star
	name = "sensational star ruby"
	desc = "A fantastically red ruby with a star shaped imperfection."
	icon_state = "starruby"

/obj/item/treasure/gem/moonstone
	name = "majestic moonstone"
	desc = "A silvery blue gem that seems to demand your gaze."
	icon_state = "moonstone"

/obj/item/treasure/portrait
	name = "king's portrait"
	desc = "A painting of a king of old"
	icon_state = "king"

/obj/item/treasure/portrait/queen
	name = "portrait of a queen"
	desc = "A picture of a beautiful queen."
	icon_state = "queen"

/obj/item/treasure/portrait/knight
	name = "knight's painting"
	desc = "An image depicting a brave knight."
	icon_state = "knight"

/obj/item/treasure/portrait/jester
	name = "jester's caricature"
	desc = "A foolish jester's highly exagerated portrait."
	icon_state = "jester"

/obj/item/treasure/portrait/squire
	name = "picture of a squire"
	desc = "A picture of a young squire."
	icon_state = "squire"

/obj/item/toy/plushie/loot
	name = "old cartoon doll"
	desc = "A cute doll of an old cartoon from early in the millennium."
	icon = 'icons/urist/items/misc.dmi'
	icon_state = "rareplush1"

/obj/item/toy/plushie/loot/pink
	icon_state = "rareplush2"

/obj/item/toy/plushie/loot/blue
	icon_state = "rareplush3"

/obj/item/toy/plushie/loot/neet
	icon_state = "rareplush4"

/obj/item/toy/plushie/loot/goat
	icon_state = "goat"

/obj/item/toy/plushie/loot/scug
	name = "slugcat plush"
	desc = "A cute doll based off a sleeping slugcat."
	icon_state = "scugplush"

/obj/random/treasure
	name = "random treasure"
	desc = "This is some random loot."
	icon = 'icons/obj/parcels.dmi'
	icon_state = "gift3"

/obj/random/treasure/spawn_choices()
	return list(/obj/item/material/coin/challenge/loot/copper,
				/obj/item/material/coin/challenge/loot/silver,
				/obj/item/material/coin/challenge/loot/gold,
				/obj/item/treasure/gem/pearl,
				/obj/item/treasure/gem/sapphire,
				/obj/item/treasure/gem/ruby ,
				/obj/item/treasure/gem/emerald,
				/obj/item/treasure/gem/fancyquartz,
				/obj/item/treasure/gem/ruby/star,
				/obj/item/treasure/gem/moonstone,
				/obj/item/treasure/gem/opal,
				/obj/item/treasure/gem/fireopal)

/obj/random/treasure/plush
	name = "random treasure plush"
	desc = "This is some random loot."
	icon = 'icons/obj/parcels.dmi'
	icon_state = "gift3"

/obj/random/treasure/plush/spawn_choices()
	return list(/obj/item/toy/plushie/loot,
				/obj/item/toy/plushie/loot/pink,
				/obj/item/toy/plushie/loot/blue,
				/obj/item/toy/plushie/loot/neet,
				/obj/item/toy/plushie/loot/goat,
				/obj/item/toy/plushie/loot/scug)

/obj/random/treasure/portrait
	name = "random treasure portrait"
	desc = "This is some random loot."
	icon = 'icons/obj/parcels.dmi'
	icon_state = "gift3"

/obj/random/treasure/portrait/spawn_choices()
	return list(/obj/item/treasure/portrait,
				/obj/item/treasure/portrait/queen,
				/obj/item/treasure/portrait/knight,
				/obj/item/treasure/portrait/jester,
				/obj/item/treasure/portrait/squire)

/obj/random/cuteanimal
	name = "random cute animal"
	desc = "This is a random cute animal."
	icon = 'icons/mob/simple_animal/critter.dmi'
	icon_state = "lizard"

/obj/random/cuteanimal/spawn_choices()
	return list(/mob/living/simple_animal/passive/corgi/puppy,
				/mob/living/simple_animal/passive/cat/kitten,
				/mob/living/simple_animal/passive/lizard
				)

/obj/random/pen
	name = "random pen"
	desc = "This is a random pen."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "pen"

/obj/random/pen/spawn_choices()
	return list(/obj/item/pen,
				/obj/item/pen/blue,
				/obj/item/pen/red,
				/obj/item/pen/fancy,
				/obj/item/pen/fancy/quill,
				/obj/item/pen/green,
				/obj/item/pen/multi,
				/obj/item/pen/retractable
				)

/obj/random/utensil
	name = "random utensil"
	desc = "This is a random utensil."
	icon = 'icons/obj/machines/kitchen.dmi'
	icon_state = "fork"

/obj/random/utensil/spawn_choices()
	return list(/obj/item/material/utensil/fork,
				/obj/item/material/utensil/spoon,
				/obj/item/material/utensil/spork
				)

/obj/random/officetoy
	name = "random office toy"
	desc = "This is a random toy for eggheads."
	icon = 'icons/obj/toy.dmi'
	icon_state = "fan"

/obj/random/officetoy/spawn_choices()
	return list(/obj/item/toy/desk/fan,
				/obj/item/toy/desk/officetoy,
				/obj/item/toy/desk/dippingbird,
				/obj/item/toy/desk/newtoncradle
				)

/obj/random/dice
	name = "random dice"
	desc = "These are random dice."
	icon = 'icons/obj/dice.dmi'
	icon_state = "d66"

/obj/random/dice/spawn_choices()
	return list(/obj/item/dice,
				/obj/item/dice/d10,
				/obj/item/dice/d100,
				/obj/item/dice/d12,
				/obj/item/dice/d4,
				/obj/item/dice/d8
				)

/obj/random/saintsandsins_packs
	name = "random Saints and Sins booster pack" // Builder pack not included.
	desc = "This is a random booster pack."
	icon = 'icons/urist/items/saintsandsins.dmi'
	icon_state = "card_pack_saintsandsins"

/obj/random/saintsandsins_packs/spawn_choices()
	return list(pick(prob(6);/obj/item/pack/saintsandsins/booster,
			prob(4);/obj/item/pack/saintsandsins/booster/alchemist,
			prob(2);/obj/item/pack/saintsandsins/booster/fatebringer))

/obj/item/bodyguardkit
	name = "bodyguard plate carrier kit"
	desc = "A secure box containing a plate carrier."
	icon = 'icons/obj/boxes.dmi'
	icon_state = "excavation"
	var/list/armor_options = list(
		"Classic - Blue Security Armor" = /obj/item/clothing/suit/armor/pcarrier/deus_blueshield,
		"Modern - Plate Carrier" = /obj/item/clothing/suit/armor/pcarrier
	)

/obj/item/bodyguardkit/attack_self(mob/user)
	var/choice = input(user, "What is your choice?") as null|anything in armor_options
	if (choice && user.use_sanity_check(src))
		var/new_armor_path = armor_options[choice]
		var/obj/item/new_armor = new new_armor_path(user.loc)
		user.drop_from_inventory(src)
		to_chat(user, SPAN_NOTICE("You take \the [new_armor] out of \the [src]. Remember to put an armor plate in!"))
		qdel(src)

/obj/item/device/flashlight/maglight/advanced// Essentially an upgraded maglight, good for seccies if techies/sci does their job
	name = "advanced flashlight"
	desc = "an advanced heavy duty flashlight, combining energy efficency and a strong light emitter."
	icon = 'icons/urist/items/tools.dmi'
	icon_state = "advlight"
	item_state = "advlight"
	force = 12
	base_parry_chance = 15
	attack_verb = list ("smacked", "thwacked", "thunked")
	matter = list(MATERIAL_STEEL = 100, MATERIAL_GLASS = 100, MATERIAL_PLASTIC = 150)
	hitsound = "swing_hit"
	flashlight_power = 0.75
	flashlight_range = 6

//blueshield action figure
/obj/item/toy/figure/blueshield
	name = "Blueshield action figure"
	desc = "A \"Space Life\" brand Blueshield action figure."
	icon = 'icons/urist/items/misc.dmi'
	icon_state = "blueshield"
