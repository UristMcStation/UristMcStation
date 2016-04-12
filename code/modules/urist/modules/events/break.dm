/datum/event/breaktime	//NOTE: Times are measured in master controller ticks!
	announceWhen		= 5

/datum/event/breaktime/setup()
	endWhen = 300

///datum/event/breaktime/start()

/datum/event/breaktime/announce()
	command_announcement.Announce("Central Command has allotted the next ten minutes as a break period in accordance with company regulations. Feel free to make use of the station's many leisure facilities.", "Automated Break Announcement", new_sound = 'sound/AI/commandreport.ogg')

/datum/event/breaktime/end()
	command_announcement.Announce("This announcement marks the end of the allotted break period. Please return to your workstations at your earliest convenience.", "Automated Break End Announcement", new_sound = 'sound/AI/commandreport.ogg')

