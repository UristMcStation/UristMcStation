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


/datum/scommissions/m1
	mission = 1
	basemission = 1
	missionannounce = "Get moving soldiers, a Terran Confederacy trading vessel has been hit moving through the Nyx system. Hope for survivors, but expect heavy resistance."
	missionloc1 = /area/shuttle/scom/s1/mission1
	missionloc2 = /area/shuttle/scom/s2/mission1
	missionloc11 = /area/shuttle/scom/s1/mission11
	missionloc12 = /area/shuttle/scom/s2/mission11


/datum/scommissions/m2
	mission = 2
	basemission = 2
	missionannounce = "Alright soldiers, it's time to go planetside. A Syndicate outpost on Leare has been hit, we've tried to regain contact, but haven't heard back from them. Get out there and find out what the hell happened."
	missionloc1 = /area/shuttle/scom/s1/mission2
	missionloc2 = /area/shuttle/scom/s2/mission2
	missionloc11 = /area/shuttle/scom/s1/mission12
	missionloc12 = /area/shuttle/scom/s2/mission12

/datum/scommissions/m3
	mission = 3
	basemission = 3
	missionannounce = "We're in luck soldiers. We've managed to shoot down two alien craft over a jungle planet located in the Nyx system. We need to salvage what we can from their ships, so we're sending you out. Good luck."
	missionloc1 = /area/shuttle/scom/s1/mission3
	missionloc2 = /area/shuttle/scom/s2/mission3
	missionloc11 = /area/shuttle/scom/s1/mission13
	missionloc12 = /area/shuttle/scom/s2/mission13

/datum/scommissions/m4
	mission = 4
	basemission = 4
	missionannounce = "Alright, this is serious. An important Terran Confederacy industrial complex on the desert planet of Antipater has been hit. Luckily, it's on the outskirts of the city. Get there before the alien forces have a chance to hit the city."
	missionloc1 = /area/shuttle/scom/s1/mission4
	missionloc2 = /area/shuttle/scom/s2/mission4
	missionloc11 = /area/shuttle/scom/s1/mission14
	missionloc12 = /area/shuttle/scom/s2/mission14


/datum/scommissions/m5
	mission = 5
	basemission = 5
	missionannounce = "Alert, alert, all soldiers, gear up and get to the shuttles immediately. This is not a drill. The Ryclies system is reporting a number of alien contacts. We're sending you to a suburb on Ryclies II, where it's reported that a number of ships have landed. There will be civilians here, so watch your fire soldiers. Good luck, and godspeed."
	missionloc1 = /area/shuttle/scom/s1/mission5
	missionloc2 = /area/shuttle/scom/s2/mission5

/datum/scommissions/m6
	mission = 6
	basemission = 6
	missionannounce = "We've managed to track the alien presence in Nyx down to a single research facility under the name of 'Tajaran McERPStation'. Signals are typically erratic from this end of Nyx, so we haven't located them until now. Luckily, we don't think they know we're coming. Get in there fast, find the source of the infestation (suspected to be in the southern half of the station, wipe them out and get the hell out of there."
	missionloc1 = /area/shuttle/scom/s1/mission6
	missionloc2 = /area/shuttle/scom/s2/mission6

/datum/scommissions/m7
	mission = 7
	basemission = 7
	missionannounce = "This is it soldiers, we've finally managed to track the local alien mothership down, meaning that we can finally drive them out of the Nyx sector. Using the technology you've salvaged from their ships, we've managed to cloak the shuttles enough to avoid their sensors. This means we can get in, blow them to hell and then get out. Expect heavy resistance. Good luck and godspeed."
	missionloc1 = /area/shuttle/scom/s1/mission7
	missionloc2 = /area/shuttle/scom/s2/mission7