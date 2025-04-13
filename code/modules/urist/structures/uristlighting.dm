///////////////////////////////////////////////////////////////////////////
//                                                                       //
//                        URIST CUSTOM LIGHTS                            //
//    put both lightbulb-style obj/weapons and light machinery here      //
//                                                                       //
///////////////////////////////////////////////////////////////////////////

//spoopy red maint lights, Alien-style
/obj/machinery/light/small/red/maintenance
	icon_state = "firelight1"
	active_power_usage = 2
	name = "Maintenance light fixture"
	desc = "A small, low-power lighting fixture used for maintenance lighting."
	light_type = /obj/item/light/bulb/red/maintenance

/obj/item/light/bulb/red/maintenance
	name = "light bulb (maintenance)"
	desc = "A replacement light bulb. This one has a red filter and is designed for usage in Maintenance."
	b_outer_range = 6
	b_colour = "#b12525"

//cold, blue tint; feedback was good on putting it in Medbay
/obj/machinery/light/coldtint
	light_type = /obj/item/light/tube/tinted/coldtint

/obj/item/light/tube/tinted
	name = "light tube (tinted)"
	desc = "A replacement light tube."
	b_colour = "#f0008c" //PANK. Shouldn't show up normally, so it's a telltale color something's wrong.
	random_tone = FALSE

/obj/item/light/tube/tinted/coldtint
	name = "light tube (cold-light)"
	desc = "A replacement light tube. This one emits soothing high-Kelvin light."
	icon_state = "ltube"
	base_state = "ltube"
	item_state = "c_tube"
	b_colour = "#b0dcea"

//super warm tint (color literally stolen from candles), for the Bar
/obj/machinery/light/warmtint
	light_type = /obj/item/light/tube/tinted/warmtint

//spotlight version of the above for a larger area
/obj/machinery/light/spot/warmtint
	light_type = /obj/item/light/tube/large/tinted/warmtint

/obj/item/light/tube/tinted/warmtint
	name = "light tube (incandescent)"
	desc = "A replacement light tube. This one emits amber low-Kelvin light."
	icon_state = "ltube"
	base_state = "ltube"
	item_state = "c_tube"
	b_colour = "#e09d37"

/obj/item/light/tube/large/tinted/warmtint
	name = "large light tube (incandescent)"
	desc = "A replacement light tube. This one emits a lot of amber low-Kelvin light."
	icon_state = "ltube"
	base_state = "ltube"
	item_state = "c_tube"
	b_colour = "#e09d37"

//green tint
/obj/machinery/light/greentint
	light_type = /obj/item/light/tube/tinted/greentint

/obj/item/light/tube/tinted/greentint
	name = "light tube (green)"
	desc = "A replacement light tube. This one has an integrated green filter for vibrant green light."
	icon_state = "ltube"
	base_state = "ltube"
	item_state = "c_tube"
	b_colour ="#a8ffb1"

/obj/item/light/tube/tinted/redtint
	name = "light tube (red)"
	desc = "A replacement light tube. This one has an integrated red filter."
	icon_state = "ltube"
	base_state = "ltube"
	item_state = "c_tube"
	b_colour ="#b12525"

//because the train lamp sprite is nice
/obj/item/device/flashlight/lamp/lantern
	name = "lantern"
	desc = "An apparently old-school portable kerosene lamp, using modern technology to provide an extremely long-lasting flame with no fire hazard."
	icon = 'icons/urist/events/train.dmi'
	icon_state = "wolfflight"
	item_state = "lamp"
	flashlight_power = 0.5
	light_color = "#e09d37"
	w_class = 4
	obj_flags = OBJ_FLAG_CONDUCTIBLE

	on = 0

/obj/item/storage/box/lights/mixedtint
	name = "box of replacement tinted lights"
	icon_state = "lightmixed"

/obj/item/storage/box/lights/mixedtint/New()
	for(var/i = 0; i < 21; i++)
		var/variant = pick((typesof(/obj/item/light/tube/tinted)) - (/obj/item/light/tube/tinted))
		new variant(src)
	..()

/obj/item/storage/box/lights/redbulbs
	name = "box of replacement red bulbs"

/obj/item/storage/box/lights/redbulbs/New()
	for(var/i = 0; i < 21; i++)
		new /obj/item/light/bulb/red(src)
	..()

//experiment - object-based sunlight.
/obj/urist_intangible/sun
	name = "sun"
	desc = "You really shouldn't be seeing this."
	invisibility = 101
	anchored = TRUE
	light_color = "#fcfcb6"
	light_power = 1
	light_range = 127

/obj/machinery/light/chromatic
	name = "chromatic light"
	id_tag = 1
	var/freq = 1343

/obj/machinery/light/chromatic/Initialize()
	. = ..()
	radio_controller.add_object(src, freq, RADIO_CHROMATIC)

/obj/machinery/light/chromatic/receive_signal(datum/signal/signal, receive_method, receive_param)
	if(signal.data["tag"] == id_tag)
		if(signal.data["color"])
			lightbulb.b_colour = signal.data["color"]
			update_icon()

/obj/machinery/light/broken/Initialize()
	. = ..()
	broken()

/obj/item/storage/box/lights/incandescent
	name = "box of replacement incandescent lights"
	icon = 'icons/obj/boxes.dmi'
	icon_state = "lighttube"
	startswith = list(/obj/item/light/tube/tinted/warmtint = 7,
					/obj/item/light/tube/tinted/coldtint = 7,
					/obj/item/light/tube/large/tinted/warmtint = 4)
