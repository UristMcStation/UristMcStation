/obj/urist_intangible/mapmanip
	layer = POINTER_LAYER

/obj/urist_intangible/mapmanip/Initialize(mapload)
	. = ..()
	return INITIALIZE_HINT_QDEL

/obj/urist_intangible/mapmanip/marker
	name = "mapmanip marker"

/obj/urist_intangible/mapmanip/marker/submap/extract
	name = "mapmanip marker, extract submap"
	icon = 'icons/urist/effects/map_effects_96x96.dmi'
	icon_state = "mapmanip_extract"
	pixel_x = -32
	pixel_y = -32

/obj/urist_intangible/mapmanip/marker/submap/insert
	name = "mapmanip marker, insert submap"
	icon = 'icons/urist/effects/map_effects_96x96.dmi'
	icon_state = "mapmanip_insert"
	pixel_x = -32
	pixel_y = -32

/obj/urist_intangible/mapmanip/marker/helper
	name = "marker helper"

/obj/urist_intangible/mapmanip/marker/helper/submap_edge
	name = "mapmanip helper marker, edge of submap"
	icon = 'icons/urist/effects/map_effects.dmi'
	icon_state = "mapmanip_submap_edge"
