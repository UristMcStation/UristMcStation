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

/obj/item/weapon/circuitboard/diseaseanalyser
	name = T_BOARD("disease analyzer")
	build_path = /obj/machinery/disease2/diseaseanalyser
	board_type = "machine"
	origin_tech = list(TECH_DATA = 3, TECH_BIO = 2)
	req_components = list(
							/obj/item/weapon/stock_parts/console_screen = 1,
							/obj/item/weapon/stock_parts/manipulator = 1,
							/obj/item/stack/cable_coil = 5)

/obj/item/weapon/circuitboard/antibodyanalyser
	name = T_BOARD("antibody analyzer")
	build_path = /obj/machinery/disease2/antibodyanalyser
	board_type = "machine"
	origin_tech = list(TECH_DATA = 3, TECH_BIO = 2)
	req_components = list(
							/obj/item/weapon/stock_parts/console_screen = 1,
							/obj/item/weapon/stock_parts/manipulator = 1,
							/obj/item/stack/cable_coil = 5)

/obj/item/weapon/circuitboard/incubator
	name = T_BOARD("pathogenic incubator")
	build_path = /obj/machinery/disease2/incubator
	board_type = "machine"
	origin_tech = list(TECH_MAGNETIC = 3, TECH_BIO = 3)
	req_components = list(
							/obj/item/weapon/stock_parts/matter_bin = 1,
							/obj/item/weapon/stock_parts/micro_laser = 1,
							/obj/item/stack/material/glass/reinforced = 2)

/obj/item/weapon/circuitboard/centrifuge
	name = T_BOARD("isolation centrifuge")
	build_path = /obj/machinery/disease2/centrifuge
	board_type = "machine"
	origin_tech = list(TECH_BIO = 4)
	req_components = list(
							/obj/item/weapon/stock_parts/micro_laser = 2,
							/obj/item/stack/cable_coil = 5,
							/obj/item/stack/material/glass = 5)

/obj/item/weapon/circuitboard/isolater
	name = T_BOARD("pathogenic isolater")
	build_path = /obj/machinery/disease2/isolator
	board_type = "machine"
	origin_tech = list(TECH_DATA = 1, TECH_BIO = 3)
	req_components = list(
							/obj/item/weapon/stock_parts/console_screen = 1,
							/obj/item/weapon/stock_parts/manipulator = 2)
