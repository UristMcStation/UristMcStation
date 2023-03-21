#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/circuitboard/tanningrack
	name = T_BOARD("tanning rack")
	build_path = /obj/machinery/smartfridge/tanningrack
	board_type = "machine"
	origin_tech = list(TECH_BIO = 1, TECH_ENGINEERING = 1)
	req_components = list(
							/obj/item/stock_parts/scanning_module = 1,
							/obj/item/stack/material/wood = 4,
							/obj/item/stack/cable_coil = 5,
							/obj/item/stock_parts/console_screen = 1)

/obj/item/circuitboard/carpentryplaner
	name = T_BOARD("wood processor")
	build_path = /obj/machinery/carpentry/planer
	board_type = "machine"
	origin_tech = list(TECH_ENGINEERING = 1)
	req_components = list(
							/obj/item/stack/cable_coil = 2,
							/obj/item/stock_parts/manipulator = 1)

/obj/item/circuitboard/woodprocessor
	name = T_BOARD("pulp and paper processor")
	build_path = /obj/machinery/carpentry/woodprocessor
	board_type = "machine"
	origin_tech = list(TECH_ENGINEERING = 1)
	req_components = list(
							/obj/item/stock_parts/manipulator = 1,
							/obj/item/stack/cable_coil = 5,
							/obj/item/stock_parts/console_screen = 1,
							/obj/item/stock_parts/matter_bin = 1)

/obj/item/circuitboard/drying_rack
	name = T_BOARD("drying rack")
	build_path = /obj/machinery/smartfridge/drying_rack
	board_type = "machine"
	origin_tech = list(TECH_BIO = 1, TECH_ENGINEERING = 1)
	req_components = list(
							/obj/item/stock_parts/scanning_module = 1,
							/obj/item/stack/material/wood = 4,
							/obj/item/stack/cable_coil = 5,
							/obj/item/stock_parts/console_screen = 1)

/obj/item/circuitboard/washing_machine
	name = T_BOARD("washing machine")
	build_path = /obj/machinery/washing_machine
	board_type = "machine"
	origin_tech = list(TECH_ENGINEERING = 1)
	req_components = list(
							/obj/item/stack/cable_coil = 5,
							/obj/item/stock_parts/capacitor = 1,
							/obj/item/reagent_containers/glass/beaker = 1)
