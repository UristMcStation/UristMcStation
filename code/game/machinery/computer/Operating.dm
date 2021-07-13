//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/machinery/computer/operating
	name = "patient monitoring console"
	density = 1
	anchored = 1.0
	icon_keyboard = "med_key"
	icon_screen = "crew"
	circuit = /obj/item/weapon/circuitboard/operating
	var/mob/living/carbon/human/victim = null
	var/obj/watching = null

/obj/machinery/computer/operating/New()
	..()
	for(var/direction in GLOB.cardinal)
		for(var/obj/O in get_step(src, direction))
			if((O.obj_flags & OBJ_FLAG_SURGICAL) && (O.can_buckle || istype(O, /obj/machinery/optable)))
				watching = O
				return

/obj/machinery/computer/operating/attack_ai(mob/user)
	if(stat & (BROKEN|NOPOWER))
		return
	interact(user)


/obj/machinery/computer/operating/attack_hand(mob/user)
	..()
	if(stat & (BROKEN|NOPOWER))
		return
	interact(user)


/obj/machinery/computer/operating/interact(mob/user)
	victim = null
	if(!Adjacent(user) || (stat & (BROKEN|NOPOWER)))
		if(!istype(user, /mob/living/silicon))
			user.unset_machine()
			user << browse(null, "window=op")
			return

	user.set_machine(src)
	var/dat = "<HEAD><TITLE>Operating Computer</TITLE><META HTTP-EQUIV='Refresh' CONTENT='10'></HEAD><BODY>\n"
	dat += "<A HREF='?src=\ref[user];mach_close=op'>Close</A><br><br>" //| <A HREF='?src=\ref[user];update=1'>Update</A>"
	if(istype(watching, /obj/machinery/optable))
		var/obj/machinery/optable/OT = watching
		if(OT.victim)
			victim = OT.victim
	else if(watching.buckled_mob)
		victim = watching.buckled_mob
	if(victim)
		dat += {"
<B>Patient Information:</B><BR>
<BR>
[medical_scan_results(victim, 1)]
"}
	else
		dat += {"
<B>Patient Information:</B><BR>
<BR>
<B>No Patient Detected</B>
"}
	user << browse(dat, "window=op")
	onclose(user, "op")

/obj/machinery/computer/operating/Process()
	if(!inoperable())
		updateDialog()