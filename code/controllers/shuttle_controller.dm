var/global/datum/shuttle_controller/shuttle_controller


/datum/shuttle_controller
	var/list/shuttles	//maps shuttle tags to shuttle datums, so that they can be looked up.
	var/list/process_shuttles	//simple list of shuttles, for processing
	var/missionloc1 = /area/shuttle/scom/s1
	var/missionloc2 = /area/shuttle/scom/s2

/datum/shuttle_controller/proc/process()
	//process ferry shuttles
	for (var/datum/shuttle/ferry/shuttle in process_shuttles)
		if (shuttle.process_state)
			shuttle.process()

	for (var/datum/shuttle/ferry/scom/s1/SO in process_shuttles)
		missionloc1 = SO.missionloc
		SO.area_offsite = locate(missionloc1)
		SO.process()

	for (var/datum/shuttle/ferry/scom/s2/ST in process_shuttles)
		missionloc2 = ST.missionloc
		ST.area_offsite = locate(missionloc2)
		ST.process()

//This is called by gameticker after all the machines and radio frequencies have been properly initialized
/datum/shuttle_controller/proc/setup_shuttle_docks()
	for(var/shuttle_tag in shuttles)
		var/datum/shuttle/shuttle = shuttles[shuttle_tag]
		shuttle.init_docking_controllers()
		shuttle.dock() //makes all shuttles docked to something at round start go into the docked state

	for(var/obj/machinery/embedded_controller/C in machines)
		if(istype(C.program, /datum/computer/file/embedded_program/docking))
			C.program.tag = null //clear the tags, 'cause we don't need 'em anymore

/datum/shuttle_controller/New()
	shuttles = list()
	process_shuttles = list()

	var/datum/shuttle/ferry/shuttle

	// Escape shuttle and pods
	shuttle = new/datum/shuttle/ferry/emergency()
	shuttle.location = 1
	shuttle.warmup_time = 10
	shuttle.area_offsite = locate(/area/shuttle/escape/centcom)
	shuttle.area_station = locate(/area/shuttle/escape/station)
	shuttle.area_transition = locate(/area/shuttle/escape/transit)
	shuttle.docking_controller_tag = "escape_shuttle"
	shuttle.dock_target_station = "escape_dock"
	shuttle.dock_target_offsite = "centcom_dock"
	shuttle.transit_direction = NORTH
	shuttle.move_time = SHUTTLE_TRANSIT_DURATION_RETURN
	//shuttle.docking_controller_tag = "supply_shuttle"
	//shuttle.dock_target_station = "cargo_bay"
	shuttles["Escape"] = shuttle
	process_shuttles += shuttle

	shuttle = new/datum/shuttle/ferry/escape_pod()
	shuttle.location = 0
	shuttle.warmup_time = 0
	shuttle.area_station = locate(/area/shuttle/escape_pod1/station)
	shuttle.area_offsite = locate(/area/shuttle/escape_pod1/centcom)
	shuttle.area_transition = locate(/area/shuttle/escape_pod1/transit)
	shuttle.docking_controller_tag = "escape_pod_1"
	shuttle.dock_target_station = "escape_pod_1_berth"
	shuttle.dock_target_offsite = "escape_pod_1_recovery"
	shuttle.transit_direction = NORTH
	shuttle.move_time = SHUTTLE_TRANSIT_DURATION_RETURN + rand(-30, 60)	//randomize this so it seems like the pods are being picked up one by one
	process_shuttles += shuttle
	shuttles["Escape Pod 1"] = shuttle

	shuttle = new/datum/shuttle/ferry/escape_pod()
	shuttle.location = 0
	shuttle.warmup_time = 0
	shuttle.area_station = locate(/area/shuttle/escape_pod2/station)
	shuttle.area_offsite = locate(/area/shuttle/escape_pod2/centcom)
	shuttle.area_transition = locate(/area/shuttle/escape_pod2/transit)
	shuttle.docking_controller_tag = "escape_pod_2"
	shuttle.dock_target_station = "escape_pod_2_berth"
	shuttle.dock_target_offsite = "escape_pod_2_recovery"
	shuttle.transit_direction = NORTH
	shuttle.move_time = SHUTTLE_TRANSIT_DURATION_RETURN + rand(-30, 60)	//randomize this so it seems like the pods are being picked up one by one
	process_shuttles += shuttle
	shuttles["Escape Pod 2"] = shuttle

	shuttle = new/datum/shuttle/ferry/escape_pod()
	shuttle.location = 0
	shuttle.warmup_time = 0
	shuttle.area_station = locate(/area/shuttle/escape_pod3/station)
	shuttle.area_offsite = locate(/area/shuttle/escape_pod3/centcom)
	shuttle.area_transition = locate(/area/shuttle/escape_pod3/transit)
	shuttle.docking_controller_tag = "escape_pod_3"
	shuttle.dock_target_station = "escape_pod_3_berth"
	shuttle.dock_target_offsite = "escape_pod_3_recovery"
	shuttle.transit_direction = EAST
	shuttle.move_time = SHUTTLE_TRANSIT_DURATION_RETURN + rand(-30, 60)	//randomize this so it seems like the pods are being picked up one by one
	process_shuttles += shuttle
	shuttles["Escape Pod 3"] = shuttle

	//There is no pod 4, apparently.

	shuttle = new/datum/shuttle/ferry/escape_pod()
	shuttle.location = 0
	shuttle.warmup_time = 0
	shuttle.area_station = locate(/area/shuttle/escape_pod5/station)
	shuttle.area_offsite = locate(/area/shuttle/escape_pod5/centcom)
	shuttle.area_transition = locate(/area/shuttle/escape_pod5/transit)
	shuttle.docking_controller_tag = "escape_pod_5"
	shuttle.dock_target_station = "escape_pod_5_berth"
	shuttle.dock_target_offsite = "escape_pod_5_recovery"
	shuttle.transit_direction = EAST //should this be WEST? I have no idea.
	shuttle.move_time = SHUTTLE_TRANSIT_DURATION_RETURN + rand(-30, 60)	//randomize this so it seems like the pods are being picked up one by one
	process_shuttles += shuttle
	shuttles["Escape Pod 5"] = shuttle

	//give the emergency shuttle controller it's shuttles
	emergency_shuttle.shuttle = shuttles["Escape"]
	emergency_shuttle.escape_pods = list(
		shuttles["Escape Pod 1"],
		shuttles["Escape Pod 2"],
		shuttles["Escape Pod 3"],
		shuttles["Escape Pod 5"],
	)

	// Supply shuttle
	shuttle = new/datum/shuttle/ferry/supply()
	shuttle.location = 1
	shuttle.warmup_time = 10
	shuttle.area_offsite = locate(/area/supply/dock)
	shuttle.area_station = locate(/area/supply/station)
	shuttle.docking_controller_tag = "supply_shuttle"
	shuttle.dock_target_station = "cargo_bay"
	shuttles["Supply"] = shuttle
	process_shuttles += shuttle

	supply_controller.shuttle = shuttle

	// Admin shuttles.
	shuttle = new()
	shuttle.location = 1
	shuttle.warmup_time = 10
	shuttle.area_offsite = locate(/area/shuttle/transport1/centcom)
	shuttle.area_station = locate(/area/shuttle/transport1/station)
	shuttle.docking_controller_tag = "centcom_shuttle"
	shuttle.dock_target_station = "centcom_shuttle_dock_airlock"
	shuttle.dock_target_offsite = "centcom_shuttle_bay"
	shuttles["Centcom"] = shuttle
	process_shuttles += shuttle

	shuttle = new()
	shuttle.location = 1
	shuttle.warmup_time = 10	//want some warmup time so people can cancel.
	shuttle.area_offsite = locate(/area/shuttle/administration/centcom)
	shuttle.area_station = locate(/area/shuttle/administration/station)
	shuttle.docking_controller_tag = "admin_shuttle"
	shuttle.dock_target_station = "admin_shuttle_dock_airlock"
	shuttle.dock_target_offsite = "admin_shuttle_bay"
	shuttles["Administration"] = shuttle
	process_shuttles += shuttle

	shuttle = new()
	shuttle.area_offsite = locate(/area/shuttle/alien/base)
	shuttle.area_station = locate(/area/shuttle/alien/mine)
	shuttles["Alien"] = shuttle
	//process_shuttles += shuttle	//don't need to process this. It can only be moved using admin magic anyways.

	// Public shuttles
	shuttle = new()
	shuttle.warmup_time = 10
	shuttle.area_offsite = locate(/area/shuttle/constructionsite/site)
	shuttle.area_station = locate(/area/shuttle/constructionsite/station)
	shuttle.docking_controller_tag = "engineering_shuttle"
	shuttle.dock_target_station = "engineering_dock_airlock"
	shuttle.dock_target_offsite = "edock_airlock"
	shuttles["Engineering"] = shuttle
	process_shuttles += shuttle

	shuttle = new()
	shuttle.warmup_time = 10
	shuttle.area_offsite = locate(/area/shuttle/mining/outpost)
	shuttle.area_station = locate(/area/shuttle/mining/station)
	shuttle.docking_controller_tag = "mining_shuttle"
	shuttle.dock_target_station = "mining_dock_airlock"
	shuttle.dock_target_offsite = "mining_outpost_airlock"
	shuttles["Mining"] = shuttle
	process_shuttles += shuttle

	shuttle = new()
	shuttle.warmup_time = 10
	shuttle.area_offsite = locate(/area/shuttle/research/outpost)
	shuttle.area_station = locate(/area/shuttle/research/station)
	shuttle.docking_controller_tag = "research_shuttle"
	shuttle.dock_target_station = "research_dock_airlock"
	shuttle.dock_target_offsite = "research_outpost_dock"
	shuttles["Research"] = shuttle
	process_shuttles += shuttle

// Begin Urist shuttles

	shuttle = new()
	shuttle.location = 1
	shuttle.warmup_time = 10
	shuttle.area_offsite = locate(/area/shuttle/naval1/centcom)
	shuttle.area_station = locate(/area/shuttle/naval1/station)
//	shuttle.docking_controller_tag = "naval_shuttle"
//	shuttle.dock_target_station = "naval_shuttle_dock_airlock"
//	shuttle.dock_target_offsite = "naval_shuttle_bay"
	shuttles["Naval"] = shuttle
	process_shuttles += shuttle

/*	shuttle = new() //commented out for now.
	shuttle.location = 1
	shuttle.warmup_time = 10
	shuttle.area_offsite = locate(/area/shuttle/outpost/jungle)
	shuttle.area_station = locate(/area/shuttle/outpost/station)
//	shuttle.docking_controller_tag = "outpost_shuttle"
//	shuttle.dock_target_station = "outpost_shuttle_dock_airlock"
//	shuttle.dock_target_offsite = "outpost_shuttle_bay"
	shuttles["Outpost"] = shuttle
	process_shuttles += shuttle*/

	shuttle = new()
	shuttle.location = 1
	shuttle.warmup_time = 10
	shuttle.area_offsite = locate(/area/shuttle/train/stop)
	shuttle.area_station = locate(/area/shuttle/train/go)
	shuttles["Train"] = shuttle
	process_shuttles += shuttle

	shuttle = new()
	shuttle.location = 1
	shuttle.warmup_time = 10
	shuttle.area_offsite = locate(/area/shuttle/event1/l1)
	shuttle.area_station = locate(/area/shuttle/event1/l2)
	shuttles["Event1"] = shuttle
	process_shuttles += shuttle

	shuttle = new()
	shuttle.location = 1
	shuttle.warmup_time = 10
	shuttle.area_offsite = locate(/area/shuttle/event2/l1)
	shuttle.area_station = locate(/area/shuttle/event2/l2)
	shuttles["Event2"] = shuttle
	process_shuttles += shuttle

	shuttle = new/datum/shuttle/ferry/arrival()
	shuttle.location = 1
	shuttle.warmup_time = 10
	shuttle.area_offsite = locate(/area/shuttle/arrivals/centcom)
	shuttle.area_station = locate(/area/shuttle/arrivals/station)
	shuttle.area_transition = locate(/area/shuttle/arrivals/transit)
	shuttle.move_time = 20
	shuttle.docking_controller_tag = "arrival_shuttle"
	shuttle.dock_target_station = "arrival_dock"
	shuttle.dock_target_offsite = "transit_dock"
	shuttle.transit_direction = WEST
	shuttles["Arrival"] = shuttle
	process_shuttles += shuttle

	shuttle = new/datum/shuttle/ferry/scom/s1()
	shuttle.location = 0
	shuttle.warmup_time = 15
	shuttle.area_offsite = locate(missionloc1)
	shuttle.area_station = locate(/area/shuttle/scom/s1/base)
	shuttle.transit_direction = EAST
	shuttles["SCOM1"] = shuttle
	process_shuttles += shuttle

	shuttle = new/datum/shuttle/ferry/scom/s2()
	shuttle.location = 0
	shuttle.warmup_time = 15
	shuttle.area_offsite = locate(missionloc2)
	shuttle.area_station = locate(/area/shuttle/scom/s2/base)
	shuttle.transit_direction = EAST
	shuttles["SCOM2"] = shuttle
	process_shuttles += shuttle

	shuttle = new/datum/shuttle/ferry/elevator/mining()
	shuttle.location = 0
	shuttle.warmup_time = 5
	shuttle.area_offsite = locate(/area/shuttle/elevator/mining/underground)
	shuttle.area_station = locate(/area/shuttle/elevator/mining/surface)
	shuttles["MiningElevator"] = shuttle
	process_shuttles += shuttle

	shuttle = new/datum/shuttle/ferry/elevator/research()
	shuttle.location = 0
	shuttle.warmup_time = 5
	shuttle.area_offsite = locate(/area/shuttle/elevator/research/underground)
	shuttle.area_station = locate(/area/shuttle/elevator/research/surface)
	shuttles["ResearchElevator"] = shuttle
	process_shuttles += shuttle

	shuttle = new()
	shuttle.location = 0
	shuttle.warmup_time = 10
	shuttle.area_offsite = locate(/area/shuttle/securityoutpost/outpost)
	shuttle.area_station = locate(/area/shuttle/securityoutpost/station)
	shuttle.docking_controller_tag = "security_shuttle"
	shuttle.dock_target_station = "security_dock_airlock"
	shuttle.dock_target_offsite = "secdock_airlock"
	shuttles["Security"] = shuttle
	process_shuttles += shuttle

	shuttle = new/datum/shuttle/ferry/infestation()
	shuttle.location = 0
	shuttle.warmup_time = 20
	shuttle.area_offsite = locate(/area/shuttle/infestation/i1/station)
	shuttle.area_station = locate(/area/shuttle/infestation/i1/ship)
	shuttle.transit_direction = EAST
	shuttles["Infestation1"] = shuttle
	process_shuttles += shuttle

	shuttle = new/datum/shuttle/ferry/infestation()
	shuttle.location = 0
	shuttle.warmup_time = 20
	shuttle.area_offsite = locate(/area/shuttle/infestation/i2/station)
	shuttle.area_station = locate(/area/shuttle/infestation/i2/ship)
	shuttle.transit_direction = EAST
	shuttles["Infestation2"] = shuttle
	process_shuttles += shuttle

	shuttle = new()
	shuttle.location = 0
	shuttle.warmup_time = 30
	shuttle.area_offsite = locate(/area/shuttle/assault/a1/station)
	shuttle.area_station = locate(/area/shuttle/assault/a1/base)
	shuttles["Assault1"] = shuttle
	process_shuttles += shuttle

	shuttle = new()
	shuttle.location = 0
	shuttle.warmup_time = 30
	shuttle.area_offsite = locate(/area/shuttle/assault/a2/station)
	shuttle.area_station = locate(/area/shuttle/assault/a2/base)
	shuttles["Assault2"] = shuttle
	process_shuttles += shuttle

//End Urist shuttles

	// ERT Shuttle
	var/datum/shuttle/ferry/multidock/specops/ERT = new()
	ERT.location = 0
	ERT.warmup_time = 10
	ERT.area_offsite = locate(/area/shuttle/specops/station)	//centcom is the home station, the Exodus is offsite
	ERT.area_station = locate(/area/shuttle/specops/centcom)
	ERT.docking_controller_tag = "specops_shuttle_port"
	ERT.docking_controller_tag_station = "specops_shuttle_port"
	ERT.docking_controller_tag_offsite = "specops_shuttle_fore"
	ERT.dock_target_station = "specops_centcom_dock"
	ERT.dock_target_offsite = "specops_dock_airlock"
	shuttles["Special Operations"] = ERT
	process_shuttles += ERT

	//Skipjack.
	var/datum/shuttle/multi_shuttle/VS = new/datum/shuttle/multi_shuttle()
	VS.origin = locate(/area/skipjack_station/start)

	VS.destinations = list(
		"Fore Starboard Solars" = locate(/area/skipjack_station/northeast_solars),
		"Fore Port Solars" = locate(/area/skipjack_station/northwest_solars),
		"Aft Starboard Solars" = locate(/area/skipjack_station/southeast_solars),
		"Aft Port Solars" = locate(/area/skipjack_station/southwest_solars),
		"Planet Surface" = locate(/area/skipjack_station/mining)
		)

	VS.announcer = "NMV Icarus"
	VS.arrival_message = "Attention, Exodus, we just tracked a small target bypassing our defensive perimeter. Can't fire on it without hitting the station - you've got incoming visitors, like it or not."
	VS.departure_message = "Your guests are pulling away, Exodus - moving too fast for us to draw a bead on them. Looks like they're heading out of the system at a rapid clip."
	VS.interim = locate(/area/skipjack_station/transit)

	VS.warmup_time = 0
	shuttles["Skipjack"] = VS

	//Nuke Ops shuttle.
	var/datum/shuttle/multi_shuttle/MS = new/datum/shuttle/multi_shuttle()
	MS.origin = locate(/area/syndicate_station/start)
	MS.start_location = "Mercenary Base"

	MS.destinations = list(
		"Northwest of the station" = locate(/area/syndicate_station/northwest),
		"North of the station" = locate(/area/syndicate_station/north),
		"Northeast of the station" = locate(/area/syndicate_station/northeast),
		"Southwest of the station" = locate(/area/syndicate_station/southwest),
		"South of the station" = locate(/area/syndicate_station/south),
		"Southeast of the station" = locate(/area/syndicate_station/southeast),
		"Abandoned Satellite" = locate(/area/syndicate_station/commssat),
		"Planet Surface" = locate(/area/syndicate_station/mining),
//		"Arrivals dock" = locate(/area/syndicate_station/arrivals_dock),
		)

//	MS.docking_controller_tag = "merc_shuttle"
//	MS.destination_dock_targets = list(
//		"Mercenary Base" = "merc_base",
//		"Arrivals dock" = "nuke_shuttle_dock_airlock",
//		)

	MS.announcer = "NMV Icarus"
	MS.arrival_message = "Attention, Exodus, you have a large signature approaching the station - looks unarmed to surface scans. We're too far out to intercept - brace for visitors."
	MS.departure_message = "Your visitors are on their way out of the system, Exodus, burning delta-v like it's nothing. Good riddance."
	MS.interim = locate(/area/syndicate_station/transit)

	MS.warmup_time = 0
	shuttles["Mercenary"] = MS

