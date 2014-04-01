/*Urist McStation Areas and turfs! Includes the entryscreen because yes, that's a turf.

Basically, if you need to add areas or turfs for UMcS, use this file -Glloyd */


//UMcS unique Areas

/area/tcommsat/pirate
	name = "\improper Pirate Server Room"
	icon_state = "tcomsatcham"

/area/shuttle/pirate1/centcom
	name = "\improper Pirate Ship Centcom" //WIP
	icon_state = "shuttle"

/area/shuttle/pirate1/station
	name = "\improper Pirate Ship"
	icon_state = "shuttle"

/area/shuttle/naval1/centcom
	name = "\improper Navy Ship Centcom" //Not a WIP any longer motherfuckers
	icon_state = "shuttle"

/area/shuttle/naval1/station
	name = "\improper Navy Ship"
	icon_state = "shuttle"

/area/crew_quarters/pool
	name = "\improper Pool"
	icon_state = "bluenew"

/area/crew_quarters/lounge
	name = "\improper Lounge"
	icon_state = "lounge"

/area/bridge/meeting_hall
	name = "\improper Meeting Hall"
	icon_state = "bridge"
	music = null

/area/crew_quarters/heads_dorms //Noble's Quarters, hehehe.
	name = "\improper Heads of Staff Dorms"
	icon_state = "head_quarters"

/area/storage/emergency3
	name = "\improper Escape Emergency Storage" //Because yolo
	icon_state = "emergencystorage"

/area/construction/assemblyline
	name = "\improper Abandoned Assembly Line"
	icon_state = "ass_line"

/area/crew_quarters/party //needs the crewquarters before it because of gamemode code
 	name = "\improper Party Room"
 	icon_state = "yellow"

/area/security/gaschamber //someday...
	name = "\improper Gas Chamber"
	icon_state = "brig"

/area/centcom/scom
	name = "\improper S-COM Headquarters"

/area/centcom/antag
	name = "\improper A.N.T.A.G Base"

/area/awaymission/snowventure
	name = "\improper Snowy Plains"
	icon_state = "away"
	requires_power = 0
	lighting_use_dynamic = 0

/area/derelict/satellite
	name = "\improper Abandoned Satellite"
	icon_state = "yellow"

/area/medical/lounge
	name = "\improper Medbay Lounge"
	icon_state = "medbay2"

/area/medical/psychoffice
	name = "\improper Psychologist's Office"
	icon_state = "medbay3"

/area/crew_quarters/sleep/sci
	name = "\improper Research Dormitories"
	icon_state = "Sleep"

/area/crew_quarters/sleep/med
	name = "\improper Medbay Dormitories"
	icon_state = "Sleep"

//fixing tcomms

/area/tcommsat/chamber/abandoned
	name = "\improper Abandoned Satellite"
	icon_state = "tcomsatcham"

/area/tcommsat/chamber/server
	name = "\improper Telecoms Server Room"
	icon_state = "tcomsatcham"


/*TURFS
********I SWEAR, IF ANYONE FUCKS WITH THIS, I WILL KILL YOU. -Glloyd********

Icons for uristturfs from Nienhaus, Glloyd and Lord Slowpoke*/

/turf/simulated/floor/uristturf
	name = "floor"
	icon = 'icons/urist/turf/uristturf.dmi'
	icon_state = "yellowdiag02"
	floor_tile = new/obj/item/stack/tile/plasteel

//Holy fuck. Anyways, this is pool turf, so we don't fuck up /tg/ .dmi's. ALSO, if there ARE turfs to add, add them above this.

/turf/simulated/floor/beach/pool
	name = "Pool"
	icon = 'icons/urist/turf/uristturf.dmi'
	icon_state = "water4"

turf/simulated/floor/beach/pool/New()
	..()
	overlays += image("icon"='icons/urist/turf/uristturf.dmi',"icon_state"="water2","layer"=MOB_LAYER+0.1)

//Space! Because fuck /tg/!

/turf/space/transit/west // moving to the west
	icon = 'icons/urist/turf/uristturf.dmi'
	pushdirection = EAST

	shuttlespace_ew1
		icon_state = "speedspace_ew_1"
	shuttlespace_ew2
		icon_state = "speedspace_ew_2"
	shuttlespace_ew3
		icon_state = "speedspace_ew_3"
	shuttlespace_ew4
		icon_state = "speedspace_ew_4"
	shuttlespace_ew5
		icon_state = "speedspace_ew_5"
	shuttlespace_ew6
		icon_state = "speedspace_ew_6"
	shuttlespace_ew7
		icon_state = "speedspace_ew_7"
	shuttlespace_ew8
		icon_state = "speedspace_ew_8"
	shuttlespace_ew9
		icon_state = "speedspace_ew_9"
	shuttlespace_ew10
		icon_state = "speedspace_ew_10"
	shuttlespace_ew11
		icon_state = "speedspace_ew_11"
	shuttlespace_ew12
		icon_state = "speedspace_ew_12"
	shuttlespace_ew13
		icon_state = "speedspace_ew_13"
	shuttlespace_ew14
		icon_state = "speedspace_ew_14"
	shuttlespace_ew15
		icon_state = "speedspace_ew_15"

//entryscreen for UMcS, done by Glloyd.

/turf/unsimulated/wall/uristscreen
	name = "Space Station 13"
	icon = 'icons/urist/entryscreen.dmi'
	icon_state = "title"
	layer = FLY_LAYER

//snow trail for the snow awaymap I'm making

/turf/simulated/floor/plating/snow/trail
	name = "snow covered trail"
	icon = 'icons/urist/turf/uristturf.dmi'
	icon_state = "snowpath"
