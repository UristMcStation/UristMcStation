/obj/item/stock_parts/circuitboard/carpentryplaner
	name = "circuit board (wood processor)"
	build_path = /obj/machinery/carpentry/planer
	board_type = "machine"
	origin_tech = list(TECH_ENGINEERING = 1)
	req_components = list(
							/obj/item/stack/cable_coil = 2,
							/obj/item/stock_parts/manipulator = 1)

/obj/item/stock_parts/circuitboard/woodprocessor
	name = "circuit board (pulp and paper processor)"
	build_path = /obj/machinery/carpentry/woodprocessor
	board_type = "machine"
	origin_tech = list(TECH_ENGINEERING = 1)
	req_components = list(
							/obj/item/stock_parts/manipulator = 1,
							/obj/item/stack/cable_coil = 5,
							/obj/item/stock_parts/console_screen = 1,
							/obj/item/stock_parts/matter_bin = 1)

/obj/item/stock_parts/circuitboard/drying_rack
	name = "circuit board (drying rack)"
	build_path = /obj/machinery/smartfridge/drying_rack
	board_type = "machine"
	origin_tech = list(TECH_BIO = 1, TECH_ENGINEERING = 1)
	req_components = list(
							/obj/item/stock_parts/scanning_module = 1,
							/obj/item/stack/material/wood = 4,
							/obj/item/stack/cable_coil = 5,
							/obj/item/stock_parts/console_screen = 1)

/obj/item/stock_parts/circuitboard/tcomms_relay
	name = "circuit board (telecomms relay)"
	build_path = /obj/machinery/telecomms/relay/preset
	board_type = "machine"
	origin_tech = list(TECH_ENGINEERING = 1)
	req_components = list(
							/obj/item/stock_parts/scanning_module = 1,
							/obj/item/stack/material/wood = 4,
							/obj/item/stack/cable_coil = 5,
							/obj/item/stock_parts/console_screen = 1)

/obj/item/stock_parts/circuitboard/telesci_control
	name = "circuit board (telepad control console)"
	build_path = /obj/machinery/computer/telescience
	origin_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3, TECH_POWER = 3)
