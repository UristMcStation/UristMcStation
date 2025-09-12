
// Nerva - Deck 1

// Nerva - Deck 2

// Chapel Maintenance

/datum/map_template/submap/nerva/chapel_maint
	id = "nerva_chapel_maintenance"
	name = "nerva_chapel_maintenance"
	mappaths = list('maps/nerva/submap_templates/nerva_chapel_maintenance.dmm')

/obj/urist_intangible/triggers/template_loader/on_init/submap/nerva/chapel_maint
	mapfile = "nerva_chapel_maintenance"

/obj/urist_intangible/mapmanip/marker/submap/extract/nerva/chapel_maint
	name = "Chapel Maintenance"

/obj/urist_intangible/mapmanip/marker/submap/insert/nerva/chapel_maint
	name = "Chapel Maintenance"


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
