
// Nerva - Deck 1

/datum/map_template/submap/nerva/abandoned_warehouse
	id = "nerva_abandoned_warehouse"
	name = "nerva_abandoned_warehouse"
	mappaths = list('maps/nerva/submap_templates/nerva_abandoned_warehouse.dmm')

/obj/urist_intangible/triggers/template_loader/on_init/submap/nerva/abandoned_warehouse
	mapfile = "nerva_abandoned_warehouse"

/obj/urist_intangible/mapmanip/marker/submap/extract/nerva/abandoned_warehouse
	name = "Abandoned Warehouse"

/obj/urist_intangible/mapmanip/marker/submap/insert/nerva/abandoned_warehouse
	name = "Abandoned Warehouse"

// Nerva - Deck 3

/datum/map_template/submap/nerva/cargo_storage
	id = "nerva_cargo_storage"
	name = "nerva_cargo_storage"
	mappaths = list('maps/nerva/submap_templates/nerva_cargo_storage.dmm')

/obj/urist_intangible/triggers/template_loader/on_init/submap/nerva/cargo_storage
	mapfile = "nerva_cargo_storage"

/obj/urist_intangible/mapmanip/marker/submap/extract/nerva/cargo_storage
	name = "Cargo Bay Storage"

/obj/urist_intangible/mapmanip/marker/submap/insert/nerva/cargo_storage
	name = "Cargo Bay Storage"
