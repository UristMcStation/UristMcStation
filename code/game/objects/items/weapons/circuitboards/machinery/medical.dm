#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/weapon/circuitboard/sleeper
	name = T_BOARD("sleeper")
	build_path = /obj/machinery/sleeper
	board_type = "machine"
	origin_tech = list(TECH_BIO = 3)
	req_components = list(
							/obj/item/weapon/stock_parts/matter_bin = 1,
							/obj/item/weapon/stock_parts/manipulator = 2,
							/obj/item/weapon/reagent_containers/syringe = 1,
							/obj/item/stack/material/glass/reinforced = 5)

/obj/item/weapon/circuitboard/scanner_console
	name = T_BOARD("body scanner console")
	build_path = /obj/machinery/body_scanconsole
	board_type = "machine"
	origin_tech = list(TECH_DATA = 3, TECH_BIO = 2)
	req_components = list(
							/obj/item/weapon/stock_parts/console_screen = 1,
							/obj/item/stack/cable_coil = 5,
							/obj/item/stack/material/glass = 2)

/obj/item/weapon/circuitboard/body_scanner
	name = T_BOARD("body scanner")
	build_path = /obj/machinery/bodyscanner
	board_type = "machine"
	origin_tech = list(TECH_BIO = 4, TECH_MAGNETIC = 2)
	req_components = list(
							/obj/item/weapon/stock_parts/capacitor = 1,
							/obj/item/weapon/stock_parts/scanning_module/phasic = 3,
							/obj/item/stack/cable_coil = 5,
							/obj/item/stack/material/glass/reinforced = 5)
