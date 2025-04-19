/obj/item/stock_parts/circuitboard/constructable/radiation_collector
	name = "circuit board (radiation collector array)"
	build_path = /obj/machinery/power/rad_collector
	board_type = "machine"
	origin_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 2, TECH_MATERIAL = 4)
	req_components = list(
							/obj/item/stock_parts/manipulator = 2,
							/obj/item/stock_parts/matter_bin = 2,
							/obj/item/stock_parts/console_screen = 1,
							/obj/item/stack/cable_coil = 5,
							/obj/item/stack/material/glass/boron_reinforced = 2
							)

/obj/item/stock_parts/circuitboard/constructable/emitter
	name = "circuit board (emitter)"
	build_path = /obj/machinery/power/emitter
	board_type = "machine"
	origin_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 3, TECH_MAGNET = 4)
	req_components = list(
							/obj/item/stock_parts/capacitor = 2,
							/obj/item/stock_parts/micro_laser = 2,
							/obj/item/stack/cable_coil = 20,
							/obj/item/stack/material/plasteel = 15
							)

/obj/item/stock_parts/circuitboard/constructable/circulator
	name = "circuit board (circulator)"
	build_path = /obj/machinery/atmospherics/binary/circulator
	board_type = "machine"
	origin_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 2, TECH_MATERIAL = 2)
	req_components = list(
							/obj/item/stock_parts/manipulator = 4,
							/obj/item/stock_parts/matter_bin = 4,
							/obj/item/stock_parts/console_screen = 1,
							/obj/item/stack/cable_coil = 20,
							/obj/item/pipe = 6
							)

/obj/item/stock_parts/circuitboard/constructable/teg
	name = "circuit board (thermal generator)"
	build_path = /obj/machinery/power/generator
	board_type = "machine"
	origin_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 2, TECH_MATERIAL = 2)
	req_components = list(
							/obj/item/stock_parts/capacitor = 6,
							/obj/item/stock_parts/matter_bin = 2,
							/obj/item/stock_parts/console_screen = 1,
							/obj/item/stack/cable_coil = 60,
							/obj/item/stack/material/plasteel = 15
							)

/obj/item/stock_parts/circuitboard/constructable/smartfridge
	name = "circuit board (smartfridge)"
	build_path = /obj/machinery/smartfridge
	board_type = "machine"
	req_components = list(
							/obj/item/stock_parts/manipulator = 2,
							/obj/item/stock_parts/matter_bin = 6,
							/obj/item/stock_parts/console_screen = 1,
							/obj/item/stack/cable_coil = 5
							)

/obj/item/stock_parts/circuitboard/constructable/hydroponic_basin
	name = "circuit board (hydroponic basin)"
	build_path = /obj/machinery/portable_atmospherics/hydroponics
	board_type = "machine"
	req_components = list(
							/obj/item/stock_parts/matter_bin = 2,
							/obj/item/stock_parts/console_screen = 1,
							/obj/item/stack/cable_coil = 5
							)

/obj/item/stock_parts/circuitboard/constructable/honey_extractor
	name = "circuit board (honey extractor)"
	build_path = /obj/machinery/honey_extractor
	board_type = "machine"
	req_components = list(
							/obj/item/stock_parts/manipulator = 1,
							/obj/item/stock_parts/matter_bin = 1,
							/obj/item/stock_parts/console_screen = 1,
							/obj/item/stack/cable_coil = 5
							)
