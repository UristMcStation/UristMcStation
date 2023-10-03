/obj/effect/floor_decal/urist
	icon = 'icons/urist/decals/urist.dmi'

/obj/effect/floor_decal/urist/uristlogo
	icon_state = "1"

/obj/effect/floor_decal/urist/nervalogo
	icon_state = "nerva1"

/obj/effect/paint/green_grey
	color = "#8daf6a"

//trimline hell

/obj/effect/floor_decal/trimline
	alpha = 229
	icon_state = "trimline_box"
	icon = 'icons/urist/decals/floor_decals.dmi'

#define TRIMLINE_SUBTYPE_HELPER(path)\
##path/line {\
	icon_state = "trimline";\
}\
##path/corner {\
	icon_state = "trimline_corner";\
}\
##path/end {\
	icon_state = "trimline_end";\
}\
##path/arrow_cw {\
	icon_state = "trimline_arrow_cw";\
}\
##path/arrow_ccw {\
	icon_state = "trimline_arrow_ccw";\
}\
##path/warning {\
	icon_state = "trimline_warn";\
}\
##path/mid_joiner {\
	icon_state = "trimline_mid";\
}\
##path/filled {\
	icon_state = "trimline_box_fill";\
}\
##path/filled/line {\
	icon_state = "trimline_fill";\
}\
##path/filled/halfline {\
	icon_state = "trimline_half_fill";\
}\
##path/filled/corner {\
	icon_state = "trimline_corner_fill";\
}\
##path/filled/end {\
	icon_state = "trimline_end_fill";\
}\
##path/filled/arrow_cw {\
	icon_state = "trimline_arrow_cw_fill";\
}\
##path/filled/arrow_ccw {\
	icon_state = "trimline_arrow_ccw_fill";\
}\
##path/filled/warning {\
	icon_state = "trimline_warn_fill";\
}\
##path/filled/mid_joiner {\
	icon_state = "trimline_mid_fill";\
}\
##path/filled/shrink_cw {\
	icon_state = "trimline_shrink_cw";\
}\
##path/filled/shrink_ccw {\
	icon_state = "trimline_shrink_ccw";\
}

/// black trimlines
/obj/effect/floor_decal/trimline/black
	color = "#333333"

TRIMLINE_SUBTYPE_HELPER(/obj/effect/floor_decal/trimline/black)

/// White trimlines
/obj/effect/floor_decal/trimline/white
	color = COLOR_WHITE

TRIMLINE_SUBTYPE_HELPER(/obj/effect/floor_decal/trimline/white)

/// Red trimlines
/obj/effect/floor_decal/trimline/red
	color = COLOR_RED_GRAY

TRIMLINE_SUBTYPE_HELPER(/obj/effect/floor_decal/trimline/red)

/// pink trimlines
/obj/effect/floor_decal/trimline/pink
	color = COLOR_PALE_RED_GRAY

TRIMLINE_SUBTYPE_HELPER(/obj/effect/floor_decal/trimline/pink)

/// Green trimlines
/obj/effect/floor_decal/trimline/green
	color = COLOR_GREEN_GRAY

TRIMLINE_SUBTYPE_HELPER(/obj/effect/floor_decal/trimline/green)

/// Blue trimlines
/obj/effect/floor_decal/trimline/blue
	color = COLOR_BLUE_GRAY

TRIMLINE_SUBTYPE_HELPER(/obj/effect/floor_decal/trimline/blue)

/// Pale Blue trimlines
/obj/effect/floor_decal/trimline/paleblue
	color = COLOR_PALE_BLUE_GRAY

TRIMLINE_SUBTYPE_HELPER(/obj/effect/floor_decal/trimline/paleblue)

/// Dark blue trimlines
/obj/effect/floor_decal/trimline/dark_blue
	color = "#3f48cc"

TRIMLINE_SUBTYPE_HELPER(/obj/effect/floor_decal/trimline/dark_blue)

/// Faded blue trimlines
/obj/effect/floor_decal/trimline/fadeblue
	color = "#4f637d"

TRIMLINE_SUBTYPE_HELPER(/obj/effect/floor_decal/trimline/fadeblue)

/// Yellow trimlines
/obj/effect/floor_decal/trimline/yellow
	color = COLOR_BROWN

TRIMLINE_SUBTYPE_HELPER(/obj/effect/floor_decal/trimline/yellow)

/// Purple trimlines
/obj/effect/floor_decal/trimline/purple
	color = COLOR_PURPLE_GRAY

TRIMLINE_SUBTYPE_HELPER(/obj/effect/floor_decal/trimline/purple)

/// Beige trimlines
/obj/effect/floor_decal/trimline/brown
	color = COLOR_BEIGE

TRIMLINE_SUBTYPE_HELPER(/obj/effect/floor_decal/trimline/brown)

/// grey trimlines
/obj/effect/floor_decal/trimline/grey
	color = "#8d8c8c"

TRIMLINE_SUBTYPE_HELPER(/obj/effect/floor_decal/trimline/grey)

/// light grey trimlines
/obj/effect/floor_decal/trimline/lightgrey
	color = "#a8b2b6"

TRIMLINE_SUBTYPE_HELPER(/obj/effect/floor_decal/trimline/grey)

#undef TRIMLINE_SUBTYPE_HELPER