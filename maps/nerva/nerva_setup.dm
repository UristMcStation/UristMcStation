/datum/map/nerva/setup_map()
	var/month = text2num(time2text(world.timeofday, "MM"))
	if(month == 6) //stolen from rainbow background code
		lobby_screens = list('maps/nerva/nerva_rainbow_lobby.dmi')
	..()
	system_name = generate_system_name()
	minor_announcement = new(new_sound = sound('sound/AI/torch/commandreport.ogg', volume = 45))
	SSsupply.movetime = 600 //cutting it in half to reduce waiting at the trading station

/datum/map/nerva/get_map_info()
	. = list()
	. +=  "You're aboard the <b>ICS Nerva</b>, an independently contracted vessel owned by the Captain. Its primary mission is whatever the Captain dictates, which can include trading, scavenging or exploration."
	. +=  "The vessel is staffed with a mix of personnel, hailing from multiple different backgrounds and factions. While the ship itself is an independently contracted vessel, the crew may have their own loyalties."
	. +=  "This area of space is on the frontier, and is largely unsettled and unexplored. Any extensive settlements were destroyed during the Galactic Crisis."
	. +=  "You might encounter remote outposts, pirates, or drifting hulks, but no one faction can claim to fully control this sector."
	return jointext(., "<br>")

/datum/map/nerva/send_welcome()
	var/obj/effect/overmap/visitable/ship/combat/nerva = SSshuttle.ship_by_type(/obj/effect/overmap/visitable/ship/combat/nerva)
	contracts += new /datum/contract/nanotrasen/anomaly
	var/welcome_text = "<center><img src = [GLOB.using_map.logo]><br>"
	welcome_text += "<br /><font size = 3><b>ICS Nerva</b> Sensor Readings:</font><hr />"
	welcome_text += "Report generated on [stationdate2text()] at [stationtime2text()]</center><br /><br />"
	if(nerva)
		var/list/space_things = list()
		welcome_text += "Current system:<br /><b>[nerva ? system_name : "Unknown"]</b><br />"
		welcome_text += "Next system targeted for jump:<br /><b>[generate_system_name()]</b><br />"
		welcome_text += "Travel time to Sol:<br /><b>[rand(5,10)] days</b><br />"
		welcome_text += "Time since last port visit:<br /><b>[rand(30,50)] days</b><br />"
		welcome_text += "Scan results:<br />"
		//var/obj/effect/overmap/nerva = map_sectors["1"]
		for(var/zlevel in map_sectors)
			var/obj/effect/overmap/visitable/O = map_sectors[zlevel]
			if(O.name == nerva.name)
				continue
			if(istype(O, /obj/effect/overmap/visitable/ship/landable)) //Don't show shuttles
				continue
			if (O.hide_from_reports)
				continue
			space_things |= O

		var/list/distress_calls
		for(var/obj/effect/overmap/O in space_things)
			var/location_desc = " at present co-ordinates."
			if (O.loc != nerva.loc)
				var/bearing = round(90 - Atan2(O.x - nerva.x, O.y - nerva.y),5) //fucking triangles how do they work
				if(bearing < 0)
					bearing += 360
				location_desc = ", bearing [bearing]."
			welcome_text += "<li>\A <b>[O.name]</b>[location_desc]</li>"
		welcome_text += "<br>No distress calls logged.<br />"

		if(LAZYLEN(distress_calls))
			welcome_text += "<br><b>Distress calls logged:</b><br>[jointext(distress_calls, "<br>")]<br>"
		else
			welcome_text += "<br>No distress calls logged.<br />"
		welcome_text += "<hr>"

	post_comm_message("ICS Nerva Sensor Readings", welcome_text)
	minor_announcement.Announce(message = "New [GLOB.using_map.company_name] Update available at all communication consoles. Posted contracts for this sector have also been downloaded to [GLOB.using_map.full_name] computer systems.")
