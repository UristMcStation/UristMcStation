//fuck it, i can't do this without datum based missions

/datum/scommissions
	var/missionloc1 = /area/shuttle/scom/s1/mission //shuttle
	var/missionloc2 = /area/shuttle/scom/s2/mission //shuttle
	var/missionannounce = "If you're reading this, shit is fucked. Tell Glloyd"
	var/mission = 0
	var/basemission = 0
	var/missionloc11 = null
	var/missionloc12 = null

/datum/scommissions/m0
//	mission = 0
//	missionannounce = "If you're reading this, shit is fucked. Tell Glloyd"
//	missionloc1 = /area/shuttle/scom/s1/mission0
//	missionloc2 = /area/shuttle/scom/s2/mission0

//in the future, we pick from a list, 0, 9 and 10 (or whatever we end up going with. first 1 and last 2) will always be the same. set the missionannounce in New() to match the mission

/datum/scommissions/New()
//	if(basemission < 6 && mission > 1) //this is how it will be
	if(basemission < 5 && mission > 1)
		mission = (basemission + pick(0, 10))
	if(mission > 10)
		missionloc1 = missionloc11
		missionloc2 = missionloc12

/obj/shuttle_landmark/SCOM/S1/M0
	name = "Shuttle 1 - Mission 0"
	landmark_tag = "SCOM_S1_M0"

/obj/shuttle_landmark/SCOM/S2/M0
	name = "Shuttle 2 - Mission 0"
	landmark_tag = "SCOM_S2_M0"

/datum/scommissions/m1
	mission = 1
	basemission = 1
	missionannounce = "Get moving soldiers, a Terran Confederacy trading vessel has been hit moving through the Nyx system. Hope for survivors, but expect heavy resistance."
	missionloc1 = "SCOM_S1_M1"
	missionloc2 = "SCOM_S2_M1"
	missionloc11 = "SCOM_S1_M11"
	missionloc12 = "SCOM_S2_M11"

/obj/shuttle_landmark/SCOM/S1/M1
	name = "Shuttle 1 - Mission 1"
	landmark_tag = "SCOM_S1_M1"
	base_turf = /turf/unsimulated/floor/plating
	base_area = /area/scom/mission/nolighting

/obj/shuttle_landmark/SCOM/S2/M1
	name = "Shuttle 2 - Mission 1"
	landmark_tag = "SCOM_S2_M1"
	base_turf = /turf/unsimulated/floor/plating
	base_area = /area/scom/mission/nolighting

/obj/shuttle_landmark/SCOM/S1/M11
	name = "Shuttle 1 - Mission 11"
	landmark_tag = "SCOM_S1_M11"
	base_turf = /turf/unsimulated/floor/plating
	base_area = /area/scom/mission/nolighting

/obj/shuttle_landmark/SCOM/S2/M11
	name = "Shuttle 2 - Mission 11"
	landmark_tag = "SCOM_S2_M11"
	base_turf = /turf/unsimulated/floor/plating
	base_area = /area/scom/mission/nolighting

/datum/scommissions/m2
	mission = 2
	basemission = 2
	missionannounce = "Alright soldiers, it's time to go planetside. A Syndicate outpost on Leare has been hit, we've tried to regain contact, but haven't heard back from them. Get out there and find out what the hell happened."
	missionloc1 = "SCOM_S1_M2"
	missionloc2 = "SCOM_S2_M2"
	missionloc11 = "SCOM_S1_M12"
	missionloc12 = "SCOM_S2_M12"

/obj/shuttle_landmark/SCOM/S1/M2
	name = "Shuttle 1 - Mission 2"
	landmark_tag = "SCOM_S1_M2"
	base_turf = /turf/unsimulated/floor/snow
	base_area = /area/scom/mission/nolighting

/obj/shuttle_landmark/SCOM/S2/M2
	name = "Shuttle 2 - Mission 2"
	landmark_tag = "SCOM_S2_M2"
	base_turf = /turf/unsimulated/floor/snow
	base_area = /area/scom/mission/nolighting

/obj/shuttle_landmark/SCOM/S1/M12
	name = "Shuttle 1 - Mission 12"
	landmark_tag = "SCOM_S1_M12"
	base_turf = /turf/unsimulated/floor/snow
	base_area = /area/scom/mission/nolighting

/obj/shuttle_landmark/SCOM/S2/M12
	name = "Shuttle 2 - Mission 12"
	landmark_tag = "SCOM_S2_M12"
	base_turf = /turf/unsimulated/floor/snow
	base_area = /area/scom/mission/nolighting

/datum/scommissions/m3
	mission = 3
	basemission = 3
	missionannounce = "We're in luck soldiers. We've managed to shoot down two alien craft over a jungle planet located in the Nyx system. We need to salvage what we can from their ships, so we're sending you out. Good luck."
	missionloc1 = "SCOM_S1_M3"
	missionloc2 = "SCOM_S2_M3"
	missionloc11 = "SCOM_S1_M13"
	missionloc12 = "SCOM_S2_M13"

/obj/shuttle_landmark/SCOM/S1/M3
	name = "Shuttle 1 - Mission 3"
	landmark_tag = "SCOM_S1_M3"
	base_turf = /turf/simulated/floor/planet/jungle/clear/dark
	base_area = /area/scom/mission/nolighting

/obj/shuttle_landmark/SCOM/S2/M3
	name = "Shuttle 2 - Mission 3"
	landmark_tag = "SCOM_S2_M3"
	base_turf = /turf/simulated/floor/planet/jungle/clear/dark
	base_area = /area/scom/mission/nolighting

/obj/shuttle_landmark/SCOM/S1/M13
	name = "Shuttle 1 - Mission 13"
	landmark_tag = "SCOM_S1_M13"
	base_turf = /turf/simulated/floor/planet/jungle/clear/dark
	base_area = /area/scom/mission/nolighting

/obj/shuttle_landmark/SCOM/S2/M13
	name = "Shuttle 2 - Mission 13"
	landmark_tag = "SCOM_S2_M13"
	base_turf = /turf/simulated/floor/planet/jungle/clear/dark
	base_area = /area/scom/mission/nolighting

/datum/scommissions/m4
	mission = 4
	basemission = 4
	missionannounce = "Alright, this is serious. An important Terran Confederacy industrial complex on the desert planet of Antipater has been hit. Luckily, it's on the outskirts of the city. Get there before the alien forces have a chance to hit the city."
	missionloc1 = "SCOM_S1_M4"
	missionloc2 = "SCOM_S2_M4"
	missionloc11 = "SCOM_S1_M14"
	missionloc12 = "SCOM_S2_M14"

/obj/shuttle_landmark/SCOM/S1/M4
	name = "Shuttle 1 - Mission 4"
	landmark_tag = "SCOM_S1_M4"
	base_turf = /turf/unsimulated/beach/sand
	base_area = /area/scom/mission/nolighting

/obj/shuttle_landmark/SCOM/S2/M4
	name = "Shuttle 2 - Mission 4"
	landmark_tag = "SCOM_S2_M4"
	base_turf = /turf/unsimulated/beach/sand
	base_area = /area/scom/mission/nolighting

/obj/shuttle_landmark/SCOM/S1/M14
	name = "Shuttle 1 - Mission 14"
	landmark_tag = "SCOM_S1_M14"
	base_turf = /turf/unsimulated/beach/sand
	base_area = /area/scom/mission/nolighting

/obj/shuttle_landmark/SCOM/S2/M14
	name = "Shuttle 2 - Mission 14"
	landmark_tag = "SCOM_S2_M14"
	base_turf = /turf/unsimulated/beach/sand
	base_area = /area/scom/mission/nolighting

/datum/scommissions/m5
	mission = 5
	basemission = 5
	missionannounce = "Alert, alert, all soldiers, gear up and get to the shuttles immediately. This is not a drill. The Ryclies system is reporting a number of alien contacts. We're sending you to a suburb on Ryclies II, where it's reported that a number of ships have landed. There will be civilians here, so watch your fire soldiers. Good luck, and godspeed."
	missionloc1 = "SCOM_S1_M5"
	missionloc2 = "SCOM_S2_M5"

/obj/shuttle_landmark/SCOM/S1/M5
	name = "Shuttle 1 - Mission 5"
	landmark_tag = "SCOM_S1_M5"
	base_turf = /turf/unsimulated/floor/uristturf/train/grass
	base_area = /area/scom/mission/nolighting

/obj/shuttle_landmark/SCOM/S2/M5
	name = "Shuttle 2 - Mission 5"
	landmark_tag = "SCOM_S2_M5"
	base_turf = /turf/unsimulated/floor/uristturf/train/grass
	base_area = /area/scom/mission/nolighting

/datum/scommissions/m6
	mission = 6
	basemission = 6
	missionannounce = "We've managed to track the alien presence in Nyx down to a single research facility under the name of 'Urist McStation'. Signals are typically erratic from this end of Nyx, so we haven't located them until now. Luckily, we don't think they know we're coming. Get in there fast, find the source of the infestation (suspected to be in the southern half of the station, wipe them out and get the hell out of there."
	missionloc1 = "SCOM_S1_M6"
	missionloc2 = "SCOM_S2_M6"

/obj/shuttle_landmark/SCOM/S1/M6
	name = "Shuttle 1 - Mission 6"
	landmark_tag = "SCOM_S1_M6"

/obj/shuttle_landmark/SCOM/S2/M6
	name = "Shuttle 2 - Mission 6"
	landmark_tag = "SCOM_S2_M6"

/datum/scommissions/m7
	mission = 7
	basemission = 7
	missionannounce = "This is it soldiers, we've finally managed to track the local alien mothership down, meaning that we can finally drive them out of the Nyx sector. Using the technology you've salvaged from their ships, we've managed to cloak the shuttles enough to avoid their sensors. This means we can get in, blow them to hell and then get out. Expect heavy resistance. Good luck and godspeed."
	missionloc1 = "SCOM_S1_M7"
	missionloc2 = "SCOM_S2_M7"

/obj/shuttle_landmark/SCOM/S1/M7
	name = "Shuttle 1 - Mission 7"
	landmark_tag = "SCOM_S1_M7"
	base_turf = /turf/unsimulated/floor/plating
	base_area = /area/scom/mission/nolighting

/obj/shuttle_landmark/SCOM/S2/M7
	name = "Shuttle 2 - Mission 7"
	landmark_tag = "SCOM_S2_M7"
	base_turf = /turf/unsimulated/floor/plating
	base_area = /area/scom/mission/nolighting
