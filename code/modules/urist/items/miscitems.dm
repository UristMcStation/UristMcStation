//misc items that need a home

/obj/item/weapon/staff/necrostaff
	item_icons = DEF_URIST_INHANDS
	name = "necromancer's staff"
	desc = "A staff that emits a threatening aura of death."
	icon = 'icons/urist/items/misc.dmi'
	icon_state = "necrostaff"
	item_state = "necrostaff"

//glowsticks dunno where else to put thiese
/* Bay has'em now too
/obj/item/device/flashlight/glowstick //this should never be seen
	name = "glowstick"
	desc = "A glowstick, provides a small amount of light when it "
	icon = 'icons/urist/items/misc.dmi'
	brightness_on = 2
	light_power = 2
	icon_state = "glowstick"
	item_state = "glowstick"
	var/fuel = 0
	action = null
	w_class = 2

/obj/item/device/flashlight/glowstick/New()
	fuel = rand(800, 1000)
	..()

/obj/item/device/flashlight/glowstick/process()
	fuel = max(fuel - 1, 0)
	if(!fuel || !on)
		on = 0
		update_icon()
		if(!fuel)
			src.icon_state = "[initial(icon_state)]-empty"
			name = "dead glowstick"
		processing_objects -= src

/obj/item/device/flashlight/glowstick/attack_self(mob/user)

	if(!fuel)
		user << "<span class='notice'>The glowstick is dead.</span>"
		return
	if(on)
		return

	. = ..()
	// All good, turn it on.
	if(.)
		user.visible_message("<span class='notice'>[user] cracks the glowstick!</span>", "<span class='notice'>You crack the glowstick, activating it!</span>")
		processing_objects += src

/obj/item/device/flashlight/glowstick/random
	var/red = 0
	var/green = 0
	var/blue = 0


/obj/item/device/flashlight/glowstick/random/New() //IT COULD BE ANYTHING
	red = rand(0,255)
	green = rand(0,255)
	blue = rand(0,255)
	color = rgb(red,green,blue)
	light_color = color
	..()

/obj/item/device/flashlight/glowstick/red
	light_color = "#e60000"
	color = "#e60000"

/obj/item/device/flashlight/glowstick/blue
	light_color = "#0000ff"
	color = "#0000ff"*/

/obj/item/device/flashlight/glowstick/green
	//light_color = "#00b300"
	color = "#00b300"

/obj/item/device/flashlight/glowstick/purple
	//light_color = "#ac00e6"
	color = "#ac00e6"
/*
/obj/item/device/flashlight/glowstick/orange
	light_color = "#ff8000"
	color = "#ff8000"

/obj/item/device/flashlight/glowstick/yellow
	light_color = "#ffff00"
	color = "#ffff00"*/

/obj/item/weapon/storage/box/glowsticks
	name = "box of glowsticks"
	desc = "Contains seven different coloured glowsticks."
	icon = 'icons/urist/items/misc.dmi'
	icon_state = "gsbox"


/obj/item/weapon/storage/box/glowsticks/New()
		..()
		new /obj/item/device/flashlight/glowstick/green(src)
		new /obj/item/device/flashlight/glowstick/red(src)
		new /obj/item/device/flashlight/glowstick/blue(src)
		new /obj/item/device/flashlight/glowstick/orange(src)
		new /obj/item/device/flashlight/glowstick/purple(src)
		new /obj/item/device/flashlight/glowstick/yellow(src)
		new /obj/item/device/flashlight/glowstick/random(src)

//wood stuff

/obj/item/weapon/material/minihoe/wood/New()
	..()
	icon = 'icons/urist/items/wood.dmi'
	matter = list(DEFAULT_WALL_MATERIAL = 400, "wood" = 250)

/obj/item/weapon/material/hatchet/wood/New()
	..()
	icon = 'icons/urist/items/wood.dmi'
	matter = list(DEFAULT_WALL_MATERIAL = 350, "wood" = 250)

/obj/item/weapon/reagent_containers/food/drinks/woodcup
	name = "cup"
	desc = "A simple wooden cup."
	icon = 'icons/urist/items/wood.dmi'
	icon_state = "cup"
	volume = 30
	center_of_mass = list("x"=15, "y"=13)
	matter = list("wood" = 50)

/obj/item/weapon/dice/wood
	name = "d6"
	matter = list("wood" = 30)
	icon = 'icons/urist/items/wood.dmi'

/obj/item/weapon/mop/wood
	icon = 'icons/urist/items/wood.dmi'
	matter = list(DEFAULT_WALL_MATERIAL = 150, "wood" = 200)

/obj/item/weapon/pickaxe/old
	name = "pickaxe"
	desc = "The most basic of mining tools, for short excavations and small mineral extractions."
	icon = 'icons/urist/items/wood.dmi'
	icon_state = "pickaxe"
	item_state = "pickaxe"
	matter = list(DEFAULT_WALL_MATERIAL = 2000, "wood" = 900)

/obj/item/weapon/shovel/spade/wood
	name = "spade"
	desc = "A small tool for digging and moving dirt. It has a wooden handle"
	icon = 'icons/urist/items/wood.dmi'
	matter = list(DEFAULT_WALL_MATERIAL = 300, "wood" = 300)

/obj/item/weapon/material/ashtray/wood/New(var/newloc)
	..(newloc, "wood")

/obj/item/weapon/wrench/New()
	..()

	if(prob(50))
		icon = 'icons/urist/items/tools.dmi'

//for the blueshield

/obj/item/weapon/storage/box/deathimp
	name = "death alarm implant kit"
	desc = "Box of life sign monitoring implants."
	icon_state = "implant"

	New()
		..()
		new /obj/item/weapon/implantcase/death_alarm(src)
		new /obj/item/weapon/implantcase/death_alarm(src)
		new /obj/item/weapon/implantcase/death_alarm(src)
		new /obj/item/weapon/implantcase/death_alarm(src)
		new /obj/item/weapon/implantcase/death_alarm(src)
		new /obj/item/weapon/implanter(src)
		new /obj/item/weapon/implantpad(src)

/obj/item/stack/woodrods
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
	update_icon()

/obj/item/stack/woodrods/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if(W.edge)
		user << "<span class='warning'>You use the edge of [W] to sharpen the tip of the shaft.</span>"
		new /obj/item/weapon/sharpwoodrod(user.loc)
		src.use(1)

	else if(istype(W, /obj/item/weapon/reagent_containers/glass/rag))
//		var/obj/item/weapon/reagent_containers/glass/rag/R = W
		var/obj/item/weapon/flame/torch/T = new /obj/item/weapon/flame/torch(get_turf(user))
		user << "<span class='notice'>You wrap the rag around the shaft forming an improvised torch.</span>"
		src.use(1)
		user.drop_from_inventory(W)
		qdel(W)

		user.put_in_hands(T)

/obj/item/stack/woodrods/attack_self(mob/user as mob)
	src.add_fingerprint(user)

	if(!istype(user.loc,/turf)) return 0

	if (locate(/obj/structure/grille/wood, usr.loc))
		for(var/obj/structure/grille/wood/G in usr.loc)
			if (G.destroyed)
				G.health = 6
				G.density = 1
				G.destroyed = 0
				G.icon_state = "grille"
				use(1)
			else
				return 1

	else if(!in_use)
		if(get_amount() < 2)
			user << "<span class='warning'>You need at least two wood shafts to do this.</span>"
			return
		user << "<span class='notice'>Assembling grille...</span>"
		in_use = 1
		if (!do_after(usr, 10))
			in_use = 0
			return
		var/obj/structure/grille/wood/F = new /obj/structure/grille/wood/ ( usr.loc )
		user << "<span class='notice'>You assemble a wooden grille</span>"
		in_use = 0
		F.add_fingerprint(usr)
		use(2)
	return

/obj/item/stack/woodrods/update_icon()
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

/obj/item/weapon/sharpwoodrod
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

/obj/item/weapon/material/woodwirerod
	name = "wired shaft"
	desc = "A rod with some wire wrapped around the top. It'd be easy to attach something to the top bit."
	icon_state = "wiredrod"
	item_state = "rods"
	flags = CONDUCT
	force_divisor = 0.55
	throwforce = 10
	w_class = 3
	attack_verb = list("hit", "bludgeoned", "whacked", "bonked")
	default_material = "wood"

/obj/item/weapon/material/woodwirerod/attackby(var/obj/item/I, mob/user as mob)
	..()
	var/obj/item/finished
	if(istype(I, /obj/item/weapon/material/shard) || istype(I, /obj/item/weapon/material/butterflyblade))
		var/obj/item/weapon/material/tmp_shard = I

		var/want = input("What would you like to make?", "Weapon construction", "Cancel") in list ("Cancel", "Spear", "Makeshift Arrow")
		switch(want)
			if("Cancel")
				return
			if("Spear")
				finished = new /obj/item/weapon/material/twohanded/woodspear(get_turf(user), tmp_shard.material.name)
				user << "<span class='notice'>You fasten \the [I] to the top of the shaft with the cable.</span>"
			if("Makeshift Arrow")
				finished = new /obj/item/weapon/arrow/improv (get_turf(user), tmp_shard.material.name)
				user << "<span class='notice'>You fasten \the [I] to the top of the shaft with the cable.</span>"

	else if(istype(I, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/R = I
		if (R.use(1))
			finished = new /obj/item/weapon/fishingrod/improvised(get_turf(user))
			user << "<span class='notice'>You tie in the length of cable, forming an improvised fishing rod.</span>"

	else if(istype(I, /obj/item/stack/woodrods))
		var/obj/item/stack/woodrods/R = I
		if (R.use(1))
			finished = new /obj/item/weapon/material/twohanded/woodquarterstaff(get_turf(user))
			user << "<span class='notice'>You fasten the two rods together tightly with the cable.</span>"

	else if(istype(I, /obj/item/stack/material/steel))
		var/obj/item/stack/material/steel/R = I
		if (R.use(1))
			finished = new /obj/item/weapon/shovel/improvised(get_turf(user))
			user << "<span class='notice'>You fasten the metal sheet to the shaft, forming an improvised shovel.</span>"

	else if(istype(I, /obj/item/weapon/material/hatchet))
		finished = new /obj/item/weapon/material/twohanded/imppoleaxe(get_turf(user))
		user << "<span class='notice'>You fasten the hatchet to the shaft, forming an improvised poleaxe.</span>"

	if(finished)
		user.drop_from_inventory(src)
		user.drop_from_inventory(I)
		qdel(I)
		qdel(src)
		user.put_in_hands(finished)
	update_icon(user)

/obj/item/weapon/flame/torch
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
	light_color = "#E09D37"

/obj/item/weapon/flame/torch/New()
	smoketime = rand(500, 600)
	..()

/obj/item/weapon/flame/torch/process()
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

/obj/item/weapon/flame/torch/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if(burnt || lit)
		return

	else
		if(istype(W, /obj/item/weapon/weldingtool))
			var/obj/item/weapon/weldingtool/WT = W
			if(WT.isOn()) //Badasses dont get blinded by lighting their torch with a welding tool
				light("<span class='notice'>\The [user] casually lights the [name] with [W].</span>")
		else if(istype(W, /obj/item/weapon/flame))
			var/obj/item/weapon/flame/L = W
			if(L.lit)
				light()

/obj/item/weapon/flame/torch/proc/light(var/flavor_text = "<span class='notice'>\The [usr] lights the [name].</span>")
	if(!lit)
		lit = 1
		src.damtype = "fire"
		for(var/mob/O in viewers(usr, null))
			O.show_message(flavor_text, 1)
		set_light(CANDLE_LUM)
		processing_objects.Add(src)
		attack_verb = list("hit", "burnt", "singed")
		w_class = 4
		icon_state = "torch_lit"
		item_state = "torch1"
		usr.regenerate_icons()


/obj/item/weapon/flame/torch/proc/burn_out()
	lit = 0
	burnt = 1
	damtype = "brute"
	icon_state = "torch_burnt"
	item_state = "woodrod"
	name = "burnt torch"
	desc = "A burnt out torch."
	processing_objects.Remove(src)
	w_class = 3
	force = 7
	attack_verb = list("hit", "bashed", "smacked")
	usr.regenerate_icons()

/obj/item/weapon/shovel/improvised
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

/obj/item/weapon/shovel/improvised/afterattack(mob/user as mob)
	if(prob(5))
		user << "<span class='notice'>The shovel falls apart in your hands!</span>"
		new /obj/item/weapon/material/woodwirerod(user.loc)
		qdel(src)

	..()

/obj/item/weapon/paddle
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