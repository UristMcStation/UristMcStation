/*IT'S PARTY TIME*/

/sound/turntable/test
	file = 'sound/turntable/TestLoop1.ogg'
	falloff = 2
	repeat = 1

/obj/machinery/party/turntable
	name = "turntable"
	desc = "A turntable used for parties and shit."
	icon = 'icons/urist/items/effects.dmi'
	icon_state = "turntable"
//	var/playing = 0
	anchored = TRUE
	var/track = null

/obj/machinery/party/mixer
	name = "mixer"
	desc = "A mixing board for mixing music"
	icon = 'icons/urist/items/effects.dmi'
	icon_state = "mixer"
	anchored = TRUE


/obj/machinery/party/turntable/New()
	..()
	sleep(2)
	new /sound/turntable/test(src)
	return

/obj/machinery/party/turntable/attack_hand(mob/user as mob)

	var/t = "<B>Turntable Interface</B><br><br>"
	//t += "<A href='byond://?src=\ref[src];on=1'>On</A><br>"
	t += "<A href='byond://?src=\ref[src];off=1'>Off</A><br><br>"
	t += "<A href='byond://?src=\ref[src];on1=Testloop1'>One</A><br>"
	t += "<A href='byond://?src=\ref[src];on2=Testloop2'>TestLoop2</A><br>"
	t += "<A href='byond://?src=\ref[src];on3=Testloop3'>TestLoop3</A><br>"

	show_browser(user, t, "window=turntable;size=420x700")


/obj/machinery/party/turntable/Topic(href, href_list)
	..()
	if( href_list["on1"] )
		track = 'sound/turntable/TestLoop1.ogg'
		playmusic()

	if( href_list["on2"] )
		track = 'sound/turntable/TestLoop2.ogg'
		playmusic()

	if( href_list["on3"] )
		track = 'sound/turntable/TestLoop3.ogg'
		playmusic()

	if( href_list["off"] )
//		if(src.playing == 1)
		track = null
		var/sound/S = sound(null)
		S.channel = 10
		S.wait = 1
//		playing = 0
		var/area/A = src.loc.loc
		for(var/obj/machinery/party/lasermachine/L in A)
			L.turnoff()
		var/area/main_area = get_area(src)
		for(var/mob/living/M in mobs_in_area(main_area))
			sound_to(M, sound(null, channel = 1))

			main_area.forced_ambience = null

/obj/machinery/party/turntable/proc/playmusic()
//	if(src.playing == 0)

	var/sound/S = sound(track)
	S.repeat = 1
	S.channel = 10
	S.falloff = 2
	S.wait = 1
	S.environment = 0
	//for(var/mob/M in world)
	//	if(M.loc.loc == src.loc.loc && M.music == 0)
	//		log_debug("Found the song...")
	//		to_target(M, S)
	//		M.music = 1
	var/area/A = src.loc.loc

	for(var/obj/machinery/party/lasermachine/L in A)
		L.turnon()
//	playing = 1
	var/area/main_area = get_area(src)
	main_area.forced_ambience = list(track)
	for(var/mob/living/M in mobs_in_area(main_area))
		if(M.mind)
			main_area.play_ambience(M)
			spawn(10)
			return





/obj/machinery/party/lasermachine
	name = "laser machine"
	desc = "A laser machine that shoots lasers."
	icon = 'icons/urist/items/effects.dmi'
	icon_state = "lasermachine"
	anchored = TRUE
	var/mirrored = 0

/obj/urist_intangible/effects/laser
	name = "laser"
	desc = "A laser..."
	icon = 'icons/urist/items/effects.dmi'
	icon_state = "laserred1"
	anchored = TRUE
	layer = 4

/obj/item/lasermachine/New()
	..()

/obj/machinery/party/lasermachine/proc/turnon()
	var/wall = 0
	var/cycle = 1
	var/area/A = get_area(src)
	var/X = 1
	var/Y = 0
	if(mirrored == 0)
		while(wall == 0)
			if(cycle == 1)
				var/obj/urist_intangible/effects/laser/F = new/obj/urist_intangible/effects/laser(src)
				F.x = src.x+X
				F.y = src.y+Y
				F.z = src.z
				F.icon_state = "laserred1"
				var/area/AA = get_area(F)
				var/turf/T = get_turf(F)
				if(T.density == 1 || AA.name != A.name)
					qdel(F)
					return
				cycle++
				if(cycle > 3)
					cycle = 1
				X++
			if(cycle == 2)
				var/obj/urist_intangible/effects/laser/F = new/obj/urist_intangible/effects/laser(src)
				F.x = src.x+X
				F.y = src.y+Y
				F.z = src.z
				F.icon_state = "laserred2"
				var/area/AA = get_area(F)
				var/turf/T = get_turf(F)
				if(T.density == 1 || AA.name != A.name)
					qdel(F)
					return
				cycle++
				if(cycle > 3)
					cycle = 1
				Y++
			if(cycle == 3)
				var/obj/urist_intangible/effects/laser/F = new/obj/urist_intangible/effects/laser(src)
				F.x = src.x+X
				F.y = src.y+Y
				F.z = src.z
				F.icon_state = "laserred3"
				var/area/AA = get_area(F)
				var/turf/T = get_turf(F)
				if(T.density == 1 || AA.name != A.name)
					qdel(F)
					return
				cycle++
				if(cycle > 3)
					cycle = 1
				X++
	if(mirrored == 1)
		while(wall == 0)
			if(cycle == 1)
				var/obj/urist_intangible/effects/laser/F = new/obj/urist_intangible/effects/laser(src)
				F.x = src.x+X
				F.y = src.y-Y
				F.z = src.z
				F.icon_state = "laserred1m"
				var/area/AA = get_area(F)
				var/turf/T = get_turf(F)
				if(T.density == 1 || AA.name != A.name)
					qdel(F)
					return
				cycle++
				if(cycle > 3)
					cycle = 1
				Y++
			if(cycle == 2)
				var/obj/urist_intangible/effects/laser/F = new/obj/urist_intangible/effects/laser(src)
				F.x = src.x+X
				F.y = src.y-Y
				F.z = src.z
				F.icon_state = "laserred2m"
				var/area/AA = get_area(F)
				var/turf/T = get_turf(F)
				if(T.density == 1 || AA.name != A.name)
					qdel(F)
					return
				cycle++
				if(cycle > 3)
					cycle = 1
				X++
			if(cycle == 3)
				var/obj/urist_intangible/effects/laser/F = new/obj/urist_intangible/effects/laser(src)
				F.x = src.x+X
				F.y = src.y-Y
				F.z = src.z
				F.icon_state = "laserred3m"
				var/area/AA = get_area(F)
				var/turf/T = get_turf(F)
				if(T.density == 1 || AA.name != A.name)
					qdel(F)
					return
				cycle++
				if(cycle > 3)
					cycle = 1
				X++



/obj/machinery/party/lasermachine/proc/turnoff()
	var/area/A = src.loc.loc
	for(var/obj/urist_intangible/effects/laser/F in A)
		qdel(F)
