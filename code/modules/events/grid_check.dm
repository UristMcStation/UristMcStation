/datum/event/grid_check	//NOTE: Times are measured in master controller ticks!
	announceWhen		= 5

/datum/event/grid_check/setup()
	endWhen = rand(30,120)

/datum/event/grid_check/start()
	power_failure(0)
	for(var/obj/machinery/power/emitter/E in machines)
		E.active_power_usage = 0 //shitty hack to save the singulo

/datum/event/grid_check/announce()
	if (prob(30))
		command_announcement.Announce("Abnormal activity detected in [station_name()]'s powernet. As a precautionary measure, the station's power will be shut off for an indeterminate duration.", "Automated Grid Check", new_sound = 'sound/AI/poweroff.ogg')

/datum/event/grid_check/end()
	power_restore()
	for(var/obj/machinery/power/emitter/E in machines)
		E.active_power_usage = 30000