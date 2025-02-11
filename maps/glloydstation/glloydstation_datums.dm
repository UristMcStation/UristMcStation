/*/datum/design/circuit/tcomms_relay
	name = "telecomms relay"
	id = "telecomms_relay"
	req_tech = list(TECH_ENGINEERING = 1)
	build_path = /obj/item/stock_parts/circuitboard/tcomms_relay
	sort_string = "GLTEL"*/

/datum/design/circuit/turbine_control
	name = "turbine control console"
	id = "turbine_console"
	req_tech = list(TECH_ENGINEERING = 1)
	build_path = /obj/item/stock_parts/circuitboard/turbine_control
	sort_string = "GLTUR"

/datum/design/circuit/area_atmos_control
	name = "area atmos control console"
	id = "area_atmos_console"
	req_tech = list(TECH_DATA = 2)
	build_path = /obj/item/stock_parts/circuitboard/area_atmos
	sort_string = "GLATM"

/datum/design/circuit/telesci_control
	name = "telepad control console"
	id = "telepad_console"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3, TECH_POWER = 3)
	build_path = /obj/item/stock_parts/circuitboard/telesci_control
	sort_string = "GLTLS"
