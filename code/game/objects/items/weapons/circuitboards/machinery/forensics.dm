#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/weapon/circuitboard/microscope
	name = T_BOARD("microscope")
	build_path = /obj/machinery/microscope
	board_type = "machine"
	origin_tech = list(TECH_DATA = 1, TECH_POWER = 1, TECH_ENGINEERING = 1)
	req_components = list(
							/obj/item/weapon/stock_parts/capacitor = 1,
							/obj/item/weapon/stock_parts/scanning_module = 1,
							/obj/item/weapon/stock_parts/manipulator = 1,
							/obj/item/stack/material/glass = 3)

/obj/item/weapon/circuitboard/dnaforensics
	name = T_BOARD("DNA analyzer")
	build_path = /obj/machinery/dnaforensics
	board_type = "machine"
	origin_tech = list(TECH_DATA = 2, TECH_BIO = 1)
	req_components = list(
							/obj/item/weapon/stock_parts/console_screen = 1,
							/obj/item/weapon/stock_parts/scanning_module = 1,
							/obj/item/weapon/stock_parts/manipulator = 1,
							/obj/item/stack/material/glass = 1)
