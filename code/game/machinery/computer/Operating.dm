//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/machinery/computer/operating
	name = "patient monitoring console"
	density = TRUE
	anchored = TRUE
	icon_keyboard = "med_key"
	icon_screen = "crew"
	machine_name = "patient monitoring console"
	machine_desc = "Displays a realtime health readout of a patient laid onto an adjacent operating table."
	var/mob/living/carbon/human/victim = null
	var/obj/machinery/optable/table = null
	var/obj/watching = null

/obj/machinery/computer/operating/New()
	..()
	for(var/D in list(NORTH,EAST,SOUTH,WEST))
		table = locate(/obj/machinery/optable, get_step(src, D))
		if (table)
			table.computer = src
			break

/obj/machinery/computer/operating/interface_interact(user)
	interact(user)
	return TRUE

/obj/machinery/computer/operating/interact(mob/user)
	if ( (get_dist(src, user) > 1 ) || (inoperable()) )
		if (!istype(user, /mob/living/silicon))
			user.unset_machine()
			close_browser(user, "window=op")
			return

	user.set_machine(src)
	var/dat = "<HEAD><TITLE>Operating Computer</TITLE><META HTTP-EQUIV='Refresh' CONTENT='10'></HEAD><BODY>\n"
	dat += "<A HREF='byond://?src=\ref[user];mach_close=op'>Close</A><br><br>" //| <A HREF='byond://?src=\ref[user];update=1'>Update</A>"
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
	show_browser(user, dat, "window=op")
	onclose(user, "op")

/obj/machinery/computer/operating/Process()
	if(operable())
		updateDialog()
