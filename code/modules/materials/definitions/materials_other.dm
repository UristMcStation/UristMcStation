/material/waste
	name = MATERIAL_WASTE
	stack_type = null
	icon_colour = "#2e3a07"
	sheet_icon_base = "puck"
	ore_name = "slag"
	ore_desc = "Someone messed up..."
	ore_icon_overlay = "lump"
	hidden_from_codex = TRUE

/material/cult
	name = MATERIAL_CULT
	display_name = "disturbing stone"
	wall_icon_base = "cult"
	wall_flags = FLAGS_OFF
	wall_blend_icons = list(
		"solid" = TRUE,
		"wood" = TRUE,
		"metal" = TRUE,
		"stone" = TRUE
	)
	icon_colour = "#402821"
	wall_icon_reinf = "reinf_cult"
	shard_type = SHARD_STONE_PIECE
	sheet_icon_base = "brick"
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	conductive = 0
	construction_difficulty = MATERIAL_NORMAL_DIY
	hidden_from_codex = TRUE

/material/cult/place_dismantled_girder(turf/target)
	new /obj/structure/girder/cult(target)

/material/cult/reinf
	name = MATERIAL_REINFORCED_CULT
	display_name = "runic inscriptions"

/material/resin
	name = MATERIAL_RESIN
	icon_colour = "#e85dd8"
	dooropen_noise = 'sound/effects/attackblob.ogg'
	door_icon_base = "resin"
	melting_point = T0C+300
	sheet_singular_name = "blob"
	sheet_plural_name = "blobs"
	conductive = 0
	stack_type = null
	hidden_from_codex = TRUE

/material/resin/can_open_material_door(mob/living/user)
	var/mob/living/carbon/M = user
	if(istype(M) && locate(/obj/item/organ/internal/xeno/hivenode) in M.internal_organs)
		return 1
	return 0
