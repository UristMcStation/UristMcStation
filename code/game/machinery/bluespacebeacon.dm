GLOBAL_LIST_EMPTY(emergency_responses)

/obj/machinery/emergency_beacon
	name = "emergency bluespace beacon"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "bspacerelay"
	var/datum/announcement/beacon_announcer
	var/timer_id
	var/exploded

	var/possible_responses = list("Solgov","Vox","Russian","Local Police","Fake Police")
	var/rare_responses = list("Automated Response")

/obj/machinery/emergency_beacon/Initialize()
	. = ..()
	beacon_announcer = new(1,null,1)
	beacon_announcer.title = "Emergency Beacon Systems"
	update_status()

/obj/machinery/emergency_beacon/ex_act(serverity)
	. = ..()
	if(.)
		exploded = TRUE

/obj/machinery/emergency_beacon/Destroy()
	if(GLOB.using_map.active_beacon == src)
		GLOB.using_map.active_beacon = null
	if(SStimer.timer_id_dict["timerid[timer_id]"])
		deltimer(timer_id)
		if(!exploded)
			beacon_announcer.Announce("Critical error encountered, system shutting down.")
	. = ..()

/obj/machinery/emergency_beacon/proc/update_status()
	if(GLOB.using_map.active_beacon)
		if(GLOB.using_map.active_beacon == src)
			visible_message("<span class='notice>\The [src] flickers for a moment, but stays online.</span>")
		else
			visible_message("<span class='notice'>\The [src] buzzes as it displays \"Beacon signature already detected.\"</span>")
	else
		visible_message("<span class='notice'>\The [src] flickers to back to life.</span>")
		GLOB.using_map.active_beacon = src

/obj/machinery/emergency_beacon/proc/try_response_force()
	beacon_announcer.Announce("Emergency Rescue Sequence initiated, on standby for incoming signals.")
	timer_id = addtimer(CALLBACK(src, .proc/spawn_response_force), rand(2 MINUTES, 5 MINUTES), TIMER_UNIQUE|TIMER_STOPPABLE)

/obj/machinery/emergency_beacon/proc/spawn_response_force()
	for(var/obj/machinery/shipsensors/S in SSmachines.machinery)
		if (S.z in GetConnectedZlevels(z))
			. = TRUE
			break
/*
	var/choice
	if(rand(10))
		choice = pick(rare_responses)
	else
		choice = pick(possible_responses)
	for(var/datum/ghosttrap/GT in GLOB.emergency_responses[choice])
*/