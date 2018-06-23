#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/weapon/circuitboard/drone_fab
	name = T_BOARD("drone fabricator")
	build_path = /obj/machinery/drone_fabricator
	board_type = "machine"
	origin_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 4)
	req_components = list(
							/obj/item/weapon/stock_parts/capacitor = 1,
							/obj/item/weapon/stock_parts/micro_laser = 1,
							/obj/item/weapon/stock_parts/matter_bin = 3,
							/obj/item/weapon/stock_parts/manipulator = 2,
							/obj/item/stack/cable_coil = 10)

/obj/item/weapon/circuitboard/adv_drone_fab
	name = T_BOARD("advanced drone fabricator")
	build_path = /obj/machinery/drone_fabricator/construction
	board_type = "machine"
	origin_tech = list(TECH_DATA = 7, TECH_ENGINEERING = 6)
	req_components = list(
							/obj/item/weapon/stock_parts/capacitor/super = 1,
							/obj/item/weapon/stock_parts/micro_laser/ultra = 1,
							/obj/item/weapon/stock_parts/matter_bin/super = 3,
							/obj/item/weapon/stock_parts/manipulator/pico = 2,
							/obj/item/stack/cable_coil = 20,
							/obj/item/stack/material/plasteel = 15)