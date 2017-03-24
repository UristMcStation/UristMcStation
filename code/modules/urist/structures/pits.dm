/obj/structure/pit
	name = "pit"
	desc = "Watch your step, partner."
	icon = 'icons/urist/structures&machinery/structures.dmi'
	icon_state = "pit1"
//	blend_mode = BLEND_MULTIPLY
	density = 0
	anchored = 1
	var/open = 1
	var/punji = 0

/obj/structure/pit/attackby(obj/item/weapon/W, mob/user)
	if( istype(W,/obj/item/weapon/shovel) )
		if(punji)
			user << "<span class='notice'>Remove the sharpened sticks before filling it up.</span>"
		visible_message("<span class='notice'>\The [user] starts [open ? "filling" : "digging open"] \the [src]</span>")
		if( do_after(user, 50) )
			visible_message("<span class='notice'>\The [user] [open ? "fills" : "digs open"] \the [src]!</span>")
			if(open)
				close(user)
			else
				open()
		else
			user << "<span class='notice'>You stop shoveling.</span>"
		return
	if (!open && istype(W,/obj/item/stack/material/wood))
		if(locate(/obj/structure/gravemarker) in src.loc)
			user << "<span class='notice'>There's already a grave marker here.</span>"
		else
			visible_message("<span class='notice'>\The [user] starts making a grave marker on top of \the [src]</span>")
			if( do_after(user, 50) )
				visible_message("<span class='notice'>\The [user] finishes the grave marker</span>")
				var/obj/item/stack/material/wood/plank = W
				plank.use(1)
				new/obj/structure/gravemarker(src.loc)
			else
				user << "<span class='notice'>You stop making a grave marker.</span>"
		return
	if(istype(W,/obj/item/weapon/material/sharpwoodrod))
		if(open)
			if(punji == 6)
				return
			else
				user << "<span class='notice'>You stick a sharpened wooden shaft into the side of the pit.</span>"
				punji += 1
				src.overlays -= image('icons/urist/structures&machinery/structures.dmi', "punji[punji]", layer=2.1)
	..()

/obj/structure/pit/update_icon()
	icon_state = "pit[open]"
//	if(istype(loc,/turf/simulated/floor/water) || istype(loc,/turf/simulated/floor/grass))
//		icon_state="pit[open]mud"
//		blend_mode = BLEND_OVERLAY

/obj/structure/pit/Crossed(O as mob)
	if(punji)
		if(istype(O, /mob/living/))
			var/mob/living/M = O
			M << "You step into the pit and hurt yourself on the sharpened sticks within!"
			var/punjidamage = rand(2,5) //maximum damage of 30 with 6 sticks (this probably needs balancing)
			punjidamage *= punji
			M.apply_damage(punjidamage, BRUTE, sharp=1)
			M.Stun(punji) //stunned for more with more sticks. doesn't make a huge different, but w/e
			M.Weaken(punji)


/obj/structure/pit/attack_hand(var/mob/user as mob)
	if(punji)
		user << "You yank out one of the sharpened sticks from the pit."
		punji -= 1
		new /obj/item/weapon/material/sharpwoodrod(src.loc)

/obj/structure/pit/examine()
	if(punji)
		usr << "[desc] There are [punji] sharpened sticks in the pit. Be careful."
	else
		..()

/obj/structure/pit/proc/open()
	name = "pit"
	desc = "Watch your step, partner."
	open = 1
	for(var/atom/movable/A in src)
		A.forceMove(src.loc)
	update_icon()

/obj/structure/pit/proc/close(var/user)
	name = "mound"
	desc = "Some things are better left buried."
	open = 0
	for(var/atom/movable/A in src.loc)
		if(!A.anchored && A != user)
			A.forceMove(src)
	update_icon()

/obj/structure/pit/return_air()
	return open

/obj/structure/pit/proc/digout(mob/escapee)
	var/breakout_time = 1 //2 minutes by default

	if(open)
		return

	if(escapee.stat || escapee.restrained())
		return

//	escapee.setClickCooldown(100)
	escapee << "<span class='warning'>You start digging your way out of \the [src] (this will take about [breakout_time] minute\s)</span>"
	visible_message("<span class='danger'>Something is scratching its way out of \the [src]!</span>")

	for(var/i in 1 to (6*breakout_time * 2)) //minutes * 6 * 5seconds * 2
		playsound(src.loc, 'sound/weapons/bite.ogg', 100, 1)

		if(!do_after(escapee, 50))
			escapee << "<span class='warning'>You have stopped digging.</span>"
			return
		if(!escapee || escapee.stat || escapee.loc != src)
			return
		if(open)
			return

		if(i == 6*breakout_time)
			escapee << "<span class='warning'>Halfway there...</span>"

	escapee << "<span class='warning'>You successfuly dig yourself out!</span>"
	visible_message("<span class='danger'>\the [escapee] emerges from \the [src]!</span>")
	playsound(src.loc, 'sound/effects/squelch1.ogg', 100, 1)
	open()

/obj/structure/pit/closed
	name = "mound"
	desc = "Some things are better left buried."
	open = 0

/obj/structure/pit/closed/initialize()
	..()
	close()

//invisible until unearthed first
/obj/structure/pit/closed/hidden
	invisibility = INVISIBILITY_OBSERVER

/obj/structure/pit/closed/hidden/open()
	..()
	invisibility = INVISIBILITY_LEVEL_ONE

//spoooky
/obj/structure/pit/closed/grave
	name = "grave"
	icon_state = "pit0"

/obj/structure/pit/closed/grave/initialize()
	var/obj/structure/closet/coffin/C = new(src.loc)

	var/obj/item/remains/human/bones = new(C)
	bones.layer = MOB_LAYER

	var/loot
	var/list/suits = list(
		/obj/item/clothing/suit/storage/toggle/bomber,
		/obj/item/clothing/suit/storage/leather_jacket,
		/obj/item/clothing/suit/storage/toggle/brown_jacket,
		/obj/item/clothing/suit/storage/toggle/hoodie,
		/obj/item/clothing/suit/storage/toggle/hoodie/black,
		/obj/item/clothing/suit/poncho
		)
	loot = pick(suits)
	new loot(C)

	var/list/uniforms = list(
		/obj/item/clothing/under/soviet,
		/obj/item/clothing/under/redcoat,
		/obj/item/clothing/under/serviceoveralls,
		/obj/item/clothing/under/captain_fly,
		/obj/item/clothing/under/det,
		/obj/item/clothing/under/color/brown,
		)
	loot = pick(uniforms)
	new loot(C)

	if(prob(30))
		var/list/misc = list(
			/obj/item/clothing/accessory/locket,
//			/obj/item/clothing/accessory/badge/marshal/old,
			/obj/item/clothing/accessory/horrible,
			/obj/item/clothing/accessory/medal,
			/obj/item/clothing/accessory/medal/iron,
			/obj/item/clothing/accessory/medal/silver,
			/obj/item/clothing/accessory/medal/silver/sword,
			/obj/item/clothing/accessory/medal/gold,
			/obj/item/clothing/accessory/medal/gold/crest
			)
		loot = pick(misc)
		new loot(C)

	var/obj/structure/gravemarker/random/R = new(src.loc)
	R.generate()
	..()

/obj/structure/gravemarker
	name = "grave marker"
	desc = "You're not the first."
	icon = 'icons/urist/structures&machinery/structures.dmi'
	icon_state = "wood"
	pixel_x = 15
	pixel_y = 8
	anchored = 1
	var/message = "Unknown."

/obj/structure/gravemarker/cross
	icon_state = "cross"

/obj/structure/gravemarker/examine()
	..()
	usr << message

/obj/structure/gravemarker/random/initialize()
	generate()
	..()

/obj/structure/gravemarker/random/proc/generate()
	icon_state = pick("wood","cross")

	var/datum/species/S = all_species["Human"]
	var/nam = S.get_random_name(pick(MALE,FEMALE))
	var/cur_year = text2num(time2text(world.timeofday, "YYYY"))+544
	var/born = cur_year - rand(5,150)
	var/died = max(cur_year - rand(0,70),born)

	message = "Here lies [nam], [born] - [died]."

/obj/structure/gravemarker/attackby(obj/item/weapon/W, mob/user)
	if(istype(W,/obj/item/weapon/material/hatchet))
		visible_message("<span class = 'warning'>\The [user] starts hacking away at \the [src] with \the [W].</span>")
		if(!do_after(user, 30))
			visible_message("<span class = 'warning'>\The [user] hacks \the [src] apart.</span>")
			new /obj/item/stack/material/wood(src)
			qdel(src)
	if(istype(W,/obj/item/weapon/pen))
		var/msg = sanitize(input(user, "What should it say?", "Grave marker", message) as text|null)
		if(msg)
			message = msg

