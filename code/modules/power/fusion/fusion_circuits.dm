/obj/item/stock_parts/circuitboard/fusion/core_control
	name = "circuit board (fusion core controller)"
	build_path = /obj/machinery/computer/fusion/core_control
	origin_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4)

/obj/item/stock_parts/circuitboard/kinetic_harvester
	name = "circuit board (kinetic harvester)"
	build_path = /obj/machinery/kinetic_harvester
	board_type = "machine"
	origin_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4, TECH_MATERIAL = 4)
	req_components = list(
		/obj/item/stock_parts/manipulator/pico = 2,
		/obj/item/stock_parts/matter_bin/super = 1,
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stack/cable_coil = 5
		)

/obj/item/stock_parts/circuitboard/fusion_fuel_compressor
	name = "circuit board (fusion fuel compressor)"
	build_path = /obj/machinery/fusion_fuel_compressor
	board_type = "machine"
	origin_tech = list(TECH_POWER = 3, TECH_ENGINEERING = 4, TECH_MATERIAL = 4)
	req_components = list(
							/obj/item/stock_parts/manipulator/pico = 2,
							/obj/item/stock_parts/matter_bin/super = 2,
							/obj/item/stock_parts/console_screen = 1,
							/obj/item/stack/cable_coil = 5
							)

/obj/item/stock_parts/circuitboard/fusion_fuel_control
	name = "circuit board (fusion fuel controller)"
	build_path = /obj/machinery/computer/fusion/fuel_control
	origin_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4)

/obj/item/stock_parts/circuitboard/gyrotron_control
	name = "circuit board (gyrotron controller)"
	build_path = /obj/machinery/computer/fusion/gyrotron
	origin_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4)

/obj/item/stock_parts/circuitboard/fusion_core
	name = "circuit board (fusion core)"
	build_path = /obj/machinery/power/fusion_core
	board_type = "machine"
	origin_tech = list(TECH_BLUESPACE = 2, TECH_MAGNET = 4, TECH_POWER = 4)
	req_components = list(
							/obj/item/stock_parts/manipulator/pico = 2,
							/obj/item/stock_parts/micro_laser/ultra = 1,
							/obj/item/stock_parts/subspace/crystal = 1,
							/obj/item/stock_parts/console_screen = 1,
							/obj/item/stack/cable_coil = 5
							)

/obj/item/stock_parts/circuitboard/fusion_injector
	name = "circuit board (fusion fuel injector)"
	build_path = /obj/machinery/fusion_fuel_injector
	board_type = "machine"
	origin_tech = list(TECH_POWER = 3, TECH_ENGINEERING = 4, TECH_MATERIAL = 4)
	req_components = list(
							/obj/item/stock_parts/manipulator/pico = 2,
							/obj/item/stock_parts/scanning_module/phasic = 1,
							/obj/item/stock_parts/matter_bin/super = 1,
							/obj/item/stock_parts/console_screen = 1,
							/obj/item/stack/cable_coil = 5
							)

/obj/item/stock_parts/circuitboard/gyrotron
	name = "circuit board (gyrotron)"
	build_path = /obj/machinery/power/emitter/gyrotron
	board_type = "machine"
	origin_tech = list(TECH_POWER = 4, TECH_ENGINEERING = 4)
	req_components = list(
							/obj/item/stack/cable_coil = 20,
							/obj/item/stock_parts/micro_laser/ultra = 2
							)

/datum/design/circuit/fusion
	name = "fusion core control console"
	id = "fusion_core_control"
	build_path = /obj/item/stock_parts/circuitboard/fusion/core_control
	sort_string = "LAAAD"
	req_tech = list(TECH_POWER = 3, TECH_ENGINEERING = 3, TECH_MATERIAL = 3)
	category = "Computer Circuitry"

/datum/design/circuit/fusion/fuel_compressor
	name = "fuel compressor"
	id = "fusion_fuel_compressor"
	build_path = /obj/item/stock_parts/circuitboard/fusion_fuel_compressor
	sort_string = "LAAAE"
	category = "Machinery Circuitry"

/datum/design/circuit/fusion/fuel_control
	name = "fusion fuel control console"
	id = "fusion_fuel_control"
	build_path = /obj/item/stock_parts/circuitboard/fusion_fuel_control
	sort_string = "LAAAF"
	category = "Computer Circuitry"

/datum/design/circuit/fusion/gyrotron_control
	name = "gyrotron control console"
	id = "gyrotron_control"
	build_path = /obj/item/stock_parts/circuitboard/gyrotron_control
	sort_string = "LAAAG"
	category = "Computer Circuitry"

/datum/design/circuit/fusion/gyrotron
	name = "gyrotron"
	id = "gyrotron"
	build_path = /obj/item/stock_parts/circuitboard/gyrotron
	sort_string = "GYROT"
	category = "Machinery Circuitry"

/datum/design/circuit/fusion/core
	name = "fusion core"
	id = "fusion_core"
	build_path = /obj/item/stock_parts/circuitboard/fusion_core
	sort_string = "LAAAH"
	category = "Machinery Circuitry"

/datum/design/circuit/fusion/injector
	name = "fusion fuel injector"
	id = "fusion_injector"
	build_path = /obj/item/stock_parts/circuitboard/fusion_injector
	sort_string = "LAAAI"
	category = "Machinery Circuitry"

/datum/design/circuit/fusion/kinetic_harvester
	name = "fusion toroid kinetic harvester"
	id = "fusion_kinetic_harvester"
	build_path = /obj/item/stock_parts/circuitboard/kinetic_harvester
	sort_string = "LAAAJ"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4, TECH_MATERIAL = 4)

/datum/design/circuit/fusion/gyrotron
	name = "gyrotron"
	id = "gyrotron"
	build_path = /obj/item/stock_parts/circuitboard/gyrotron
	sort_string = "LAAAK"
