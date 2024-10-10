/obj/structure/pit
	name = "pit"
	desc = "Watch your step, partner."
	icon = 'icons/urist/structures&machinery/structures.dmi'
	icon_state = "pit1"
//	blend_mode = BLEND_MULTIPLY
	density = FALSE
	anchored = TRUE
	var/open = 1
	var/punji = 0
	var/animal_safe

/obj/structure/pit/attackby(obj/item/W, mob/user)
	if( istype(W,/obj/item/shovel) )
		if(punji)
			to_chat(user, "<span class='notice'>Remove the sharpened sticks before filling it up.</span>")
		visible_message("<span class='notice'>\The [user] starts [open ? "filling" : "digging open"] \the [src]</span>")
		if( do_after(user, 50) )
			visible_message("<span class='notice'>\The [user] [open ? "fills" : "digs open"] \the [src]!</span>")
			if(open)
				close(user)
			else
				open()
		else
			to_chat(user, "<span class='notice'>You stop shoveling.</span>")
		return
	if (!open && istype(W,/obj/item/stack/material/wood))
		if(locate(/obj/structure/gravemarker) in src.loc)
			to_chat(user, "<span class='notice'>There's already a grave marker here.</span>")
		else
			visible_message("<span class='notice'>\The [user] starts making a grave marker on top of \the [src]</span>")
			if( do_after(user, 50) )
				visible_message("<span class='notice'>\The [user] finishes the grave marker</span>")
				var/obj/item/stack/material/wood/plank = W
				plank.use(1)
				new/obj/structure/gravemarker(src.loc)
			else
				to_chat(user, "<span class='notice'>You stop making a grave marker.</span>")
		return
	if(istype(W,/obj/item/sharpwoodrod))
		if(open)
			if(punji == 6)
				to_chat(user, "<span class='notice'>There are too many sharpened sticks in there.</span>")
				return
			else
				to_chat(user, "<span class='notice'>You stick a sharpened wooden shaft into the side of the pit.</span>")
				punji += 1
				src.overlays += image('icons/urist/structures&machinery/structures.dmi', "punji[punji]", layer=3.7)
				qdel(W)
				user.regenerate_icons()
	..()

/obj/structure/pit/on_update_icon()
	icon_state = "pit[open]"
//	if(istype(loc,/turf/simulated/floor/water) || istype(loc,/turf/simulated/floor/grass))
//		icon_state="pit[open]mud"
//		blend_mode = BLEND_OVERLAY

/obj/structure/pit/Crossed(O as mob)
	if(punji)
		if(istype(O, /mob/living) && !(animal_safe && istype(O, /mob/living/simple_animal)))
			var/mob/living/M = O
			M.visible_message("<span class='warning'>[M] falls into the pit and impales themselves on sharpened sticks!</span>", \
			"<span class='danger'>You step into the pit and hurt yourself on the sharpened sticks within!</span>")
			var/punjidamage = rand(8,12) //Damage ranges from 16 to 72 spread out among all the organs.
			for(var/punji = rand(min(2,punji),punji) to 1)
				M.apply_damage(punjidamage)
			M.Stun(punji) //stunned for more with more sticks. doesn't make a huge different, but w/e
			M.Weaken(punji)


/obj/structure/pit/attack_hand(mob/user as mob)
	if(punji)
		to_chat(user, "You yank out one of the sharpened sticks from the pit.")
		new /obj/item/sharpwoodrod(src.loc)
		src.overlays -= image('icons/urist/structures&machinery/structures.dmi', "punji[punji]")
		punji -= 1

/obj/structure/pit/examine()
	if(punji)
		to_chat(usr, "[desc] There are [punji] sharpened sticks in the pit. Be careful.")
	else
		..()

/obj/structure/pit/proc/open()
	name = "pit"
	desc = "Watch your step, partner."
	open = 1
	for(var/atom/movable/A in src)
		A.forceMove(src.loc)
	update_icon()

/obj/structure/pit/proc/close(user)
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
	to_chat(escapee, "<span class='warning'>You start digging your way out of \the [src] (this will take about [breakout_time] minute\s)</span>")
	visible_message("<span class='danger'>Something is scratching its way out of \the [src]!</span>")

	for(var/i in 1 to (6*breakout_time * 2)) //minutes * 6 * 5seconds * 2
		playsound(src.loc, 'sound/weapons/bite.ogg', 100, 1)

		if(!do_after(escapee, 50))
			to_chat(escapee, "<span class='warning'>You have stopped digging.</span>")
			return
		if(!escapee || escapee.stat || escapee.loc != src)
			return
		if(open)
			return

		if(i == 6*breakout_time)
			to_chat(escapee, "<span class='warning'>Halfway there...</span>")

	to_chat(escapee, "<span class='warning'>You successfuly dig yourself out!</span>")
	visible_message("<span class='danger'>\the [escapee] emerges from \the [src]!</span>")
	playsound(src.loc, 'sound/effects/squelch1.ogg', 100, 1)
	open()

/obj/structure/pit/punji6
	punji = 6

/obj/structure/pit/punji6/New()
	..()
	src.overlays += image('icons/urist/structures&machinery/structures.dmi', "punji1", layer=3.7)
	src.overlays += image('icons/urist/structures&machinery/structures.dmi', "punji2", layer=3.7)
	src.overlays += image('icons/urist/structures&machinery/structures.dmi', "punji3", layer=3.7)
	src.overlays += image('icons/urist/structures&machinery/structures.dmi', "punji4", layer=3.7)
	src.overlays += image('icons/urist/structures&machinery/structures.dmi', "punji5", layer=3.7)
	src.overlays += image('icons/urist/structures&machinery/structures.dmi', "punji6", layer=3.7)

/obj/structure/pit/punji6/hidden
	icon_state = "hiddentrap"
	layer = 3.8
	animal_safe = TRUE

/obj/structure/pit/punji6/hidden/dull
	icon_state = "hiddentrapdull"

/obj/structure/pit/closed
	name = "mound"
	desc = "Some things are better left buried."
	open = 0

/obj/structure/pit/closed/Initialize()
	close()
	. = ..()

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

/obj/structure/pit/closed/grave/random/Initialize()
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
		/obj/item/clothing/suit/poncho/colored
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
//			/obj/item/clothing/accessory/medal/solgov/mil/silver_sword,
			/obj/item/clothing/accessory/medal/gold,
//			/obj/item/clothing/accessory/medal/solgov/mil/medal_of_honor
			)
		loot = pick(misc)
		new loot(C)

	var/obj/structure/gravemarker/random/R = new(src.loc)
	R.generate()
	. = ..()

/obj/structure/pit/closed/grave/spaghettiwestern/Initialize()
	var/obj/structure/closet/coffin/C = new(src.loc)

	var/obj/item/remains/human/bones = new(C)
	bones.layer = MOB_LAYER

	new /obj/item/clothing/head/urist/cowboy2(C)
	new /obj/item/clothing/under/urist/cowboy(C)
	new /obj/item/clothing/suit/urist/poncho(C)
	new /obj/item/clothing/accessory/storage/holster/hip(C)
	new /obj/item/gun/projectile/revolver/capgun(C)

	var/obj/structure/gravemarker/cross/R = new(src.loc)
	R.message = "Here lies a man who had no name. Died fighting for a fistful of dollars." //memes
	. = ..()

/obj/structure/gravemarker
	name = "grave marker"
	desc = "You're not the first."
	icon = 'icons/urist/structures&machinery/structures.dmi'
	icon_state = "wood"
	pixel_x = 15
	pixel_y = 8
	anchored = TRUE
	var/message = "Unknown."

/obj/structure/gravemarker/cross
	icon_state = "cross"

/obj/structure/gravemarker/examine()
	..()
	to_chat(usr, message)

/obj/structure/gravemarker/random/New()
	generate()
	..()

/obj/structure/gravemarker/random/proc/generate()
	icon_state = pick("wood","cross")

	var/datum/language/L = all_languages[LANGUAGE_GALCOM]
	var/nam = L.get_random_name(pick(MALE,FEMALE))
	var/cur_year = text2num(time2text(world.timeofday, "YYYY"))+544
	var/born = cur_year - rand(5,150)
	var/died = max(cur_year - rand(0,70),born)

	message = "Here lies [nam], [born] - [died]."

/obj/structure/gravemarker/attackby(obj/item/W, mob/user)
	if(istype(W,/obj/item/material/hatchet))
		visible_message("<span class = 'warning'>\The [user] starts hacking away at \the [src] with \the [W].</span>")
		if(!do_after(user, 30))
			visible_message("<span class = 'warning'>\The [user] hacks \the [src] apart.</span>")
			new /obj/item/stack/material/wood(src)
			qdel(src)
	if(istype(W,/obj/item/pen))
		var/msg = sanitize(input(user, "What should it say?", "Grave marker", message) as text|null)
		if(msg)
			message = msg
