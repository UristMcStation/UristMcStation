#include "noctis_areas.dm"
#include "noctis_jobs.dm"
#include "noctis_shuttle.dm"

/obj/effect/submap_landmark/joinable_submap/noctis
	name = "UXO Noctis"
	archetype = /decl/submap_archetype/derelict/noctis

/decl/submap_archetype/derelict/noctis
	descriptor = "derelict"
	map = "Pirate Ship"
	crew_jobs = list(
		/datum/job/submap/lost_pirate
	)

/datum/map_template/ruin/away_site/pirate_ship
	name = "Pirate Ship"
	id = "awaysite_pirate_ship"
	description = "An exploration vessel taken over by pirates."
	suffixes = list("noctis/noctis-1.dmm", "noctis/noctis-2.dmm")
	cost = 1
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/raptor)

/obj/effect/overmap/ship/noctis
	name = "exploration corvette"
	color = "#640000"
	vessel_mass = 40
	default_delay = 15 SECONDS
	speed_mod = 0.1 MINUTE
	burn_delay = 2 SECONDS
	initial_restricted_waypoints = list(
		"Raptor" = list("nav_noctis_raptor")
	)

/obj/effect/overmap/ship/noctis/New()
	name = "UXO [pick("Khan's Blade", "Liberator", "Serpentine", "Arachnophobia","Sailor's Delight","NULL")]"
	for(var/area/noctis/A)
		A.name = "\improper [name] - [A.name]"
		GLOB.using_map.area_purity_test_exempt_areas += A.type
	name = "[name], \an [initial(name)]"
	..()

/obj/effect/floor_decal/borderfloorgrey
	name = "border floor"
	icon_state = "borderfloor_white"
	color = "#8d8c8c"

/obj/effect/floor_decal/borderfloorgrey/corner
	icon_state = "borderfloorcorner_white"

/obj/effect/floor_decal/borderfloorgrey/corner2
	icon_state = "borderfloorcorner2_white"

/obj/effect/floor_decal/borderfloorgrey/full
	icon_state = "borderfloorfull_white"

/obj/effect/floor_decal/borderfloorgrey/cee
	icon_state = "borderfloorcee_white"

/obj/effect/paint/green_grey
	color = "#8daf6a"

/decl/prefab/ic_assembly/bluespace_radio
	assembly_name = "bluespace radio" 					//Beware, dragons below
	data = {"{'assembly':{'type':'type-c electronic assembly','name':'Bluespace Radio','detail_color':'#999875'},'components':\[{'type':'screen','name':'Device Owner'},{'type':'advanced integrated signaler','inputs':\[\[1,0,1357\],\[2,0,'BSNETGAMMA'\]\]},{'type':'microphone'},{'type':'text-to-speech circuit'},{'type':'text pad','name':'Assign New Owner'},{'type':'concatenator','inputs':\[\[2,0,': '\]\]},{'type':'and gate','name':'Microphone Check','inputs':\[\[1,0,0\]\]},{'type':'and gate','name':'Speaker Check','inputs':\[\[2,0,0\]\]},{'type':'toggle button','name':'Speaker Toggle'},{'type':'toggle button','name':'Microphone Toggle'},{'type':'slow ticker','inputs':\[\[1,0,1\]\]},{'type':'global positioning system'},{'type':'list constructor'},{'type':'len circuit','inputs':\[\[1,0,\[\]\]\]},{'type':'addition circuit','inputs':\[\[2,0,1\]\]},{'type':'join text circuit','inputs':\[\[1,0,\[\]\],\[2,0,', '\],\[4,0,5\]\]},{'type':'advanced integrated signaler','inputs':\[\[1,0,1357\],\[2,0,'GPSNETEPSILON'\]\]},{'type':'internal battery monitor'},{'type':'small screen','name':'Battery Charge'},{'type':'concatenator','inputs':\[\[2,0,'/'\],\[4,0,' ('\],\[6,0,'%)'\]\]},{'type':'number to string'},{'type':'number to string'},{'type':'number to string'}\],'wires':\[\[\[1,'I',1\],\[5,'O',1\]\],\[\[1,'A',1\],\[5,'A',1\]\],\[\[2,'I',3\],\[6,'O',1\]\],\[\[2,'O',1\],\[4,'I',1\]\],\[\[2,'O',1\],\[8,'I',1\]\],\[\[2,'A',1\],\[7,'A',2\]\],\[\[2,'A',3\],\[8,'A',1\]\],\[\[3,'O',1\],\[6,'I',1\]\],\[\[3,'O',2\],\[6,'I',3\]\],\[\[3,'A',1\],\[6,'A',1\]\],\[\[4,'A',1\],\[8,'A',2\]\],\[\[5,'O',1\],\[13,'I',4\]\],\[\[6,'O',1\],\[7,'I',2\]\],\[\[6,'A',2\],\[7,'A',1\]\],\[\[7,'I',1\],\[10,'O',1\]\],\[\[8,'I',2\],\[9,'O',1\]\],\[\[11,'A',1\],\[12,'A',1\]\],\[\[11,'A',1\],\[18,'A',1\]\],\[\[12,'O',1\],\[13,'I',1\]\],\[\[12,'O',2\],\[13,'I',2\]\],\[\[12,'O',3\],\[13,'I',3\]\],\[\[12,'A',2\],\[13,'A',1\]\],\[\[13,'O',1\],\[14,'I',1\]\],\[\[13,'O',1\],\[16,'I',1\]\],\[\[13,'A',2\],\[14,'A',1\]\],\[\[14,'O',1\],\[15,'I',1\]\],\[\[14,'A',2\],\[15,'A',1\]\],\[\[15,'O',1\],\[16,'I',4\]\],\[\[15,'A',2\],\[16,'A',1\]\],\[\[16,'O',1\],\[17,'I',3\]\],\[\[16,'A',2\],\[17,'A',1\]\],\[\[18,'O',1\],\[21,'I',1\]\],\[\[18,'O',2\],\[22,'I',1\]\],\[\[18,'O',3\],\[23,'I',1\]\],\[\[18,'A',2\],\[21,'A',1\]\],\[\[19,'I',1\],\[20,'O',1\]\],\[\[19,'A',1\],\[20,'A',2\]\],\[\[20,'I',1\],\[21,'O',1\]\],\[\[20,'I',3\],\[22,'O',1\]\],\[\[20,'I',5\],\[23,'O',1\]\],\[\[20,'A',1\],\[23,'A',2\]\],\[\[21,'A',2\],\[22,'A',1\]\],\[\[22,'A',2\],\[23,'A',1\]\]\]}"}
	power_cell_type = /obj/item/weapon/cell/standard	//End of dragon territory

/obj/prefab/bluespace_radio
	name = "bluespace radio"
	prefab_type = /decl/prefab/ic_assembly/bluespace_radio

/obj/structure/closet/secure_closet/engineering_electrical/noctis/WillContain()
	return list(
		/obj/item/clothing/gloves/insulated = 1,
		/obj/item/stack/cable_coil/blue = 3,
		/obj/item/weapon/wirecutters = 2,
		/obj/item/frame/apc = 2,
		/obj/item/weapon/module/power_control = 2,
		/obj/item/device/multitool = 2
	)

/obj/structure/closet/secure_closet/engineering_welding/noctis/WillContain()
	return list(
		/obj/item/clothing/head/welding/carp = 1,
		/obj/item/clothing/head/welding/fancy = 1,
		/obj/item/weapon/weldingtool = 1,
		/obj/item/weapon/weldingtool/experimental = 1,
		/obj/item/weapon/weldpack = 1,
		/obj/item/weapon/welder_tank = 3
	)

/obj/item/stack/material/titanium
	name = "titanium"
	icon_state = "sheet-silver"
	default_type = "titanium"
	apply_colour = 1
