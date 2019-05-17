#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif
/obj/item/weapon/circuitboard/pipelayer
	name = T_BOARD("pipe layer")
	board_type = "machine"
	build_path = /obj/machinery/pipelayer
	origin_tech = list(TECH_DATA = 2, TECH_POWER = 2, TECH_ENGINEERING = 2)
	req_components = list(
							/obj/item/weapon/stock_parts/matter_bin = 1,
							/obj/item/weapon/stock_parts/manipulator = 2)