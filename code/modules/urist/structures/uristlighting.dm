///////////////////////////////////////////////////////////////////////////
//                                                                       //
//                        URIST CUSTOM LIGHTS                            //
//    put both lightbulb-style obj/weapons and light machinery here      //
//                                                                       //
///////////////////////////////////////////////////////////////////////////

//spoopy red maint lights, Alien-style
/obj/machinery/light/small/red
	icon_state = "firelight1"
	construct_type = /obj/machinery/light/small
	brightness_range = 6
	brightness_power = 1
	active_power_usage = 2
	name = "Maintenance light fixture"
	desc = "A small, low-power lighting fixture used for maintenance lighting."
	light_type = /obj/item/weapon/light/bulb/red
	brightness_color = "#B12525"

/obj/machinery/light/small/red/New()
	..()
	icon_state = "firelight1"

/obj/item/weapon/light/bulb/red
	name = "light bulb (maintenance)"
	desc = "A replacement light bulb. This one has a red filter and is designed for usage in Maintenance."
	icon_state = "flight"
	base_state = "flight"
	item_state = "contvapour"
	brightness_range = 6
	brightness_power = 1
	brightness_color = "#B12525"

//cold, blue tint; feedback was good on putting it in Medbay
/obj/machinery/light/coldtint
	brightness_color = "#B0DCEA"

/obj/item/weapon/light/tube/tinted
	name = "light tube (tinted)"
	desc = "A replacement light tube."
	brightness_color = "#F0008C" //PANK. Shouldn't show up normally, so it's a telltale color something's wrong.

/obj/item/weapon/light/tube/tinted/coldtint
	name = "light tube (cold-light)"
	desc = "A replacement light tube. This one emits soothing high-Kelvin light."
	icon_state = "ltube"
	base_state = "ltube"
	item_state = "c_tube"
	brightness_color = "#B0DCEA"

//super warm tint (color literally stolen from candles), for the Bar
/obj/machinery/light/warmtint
	brightness_color = "#E09D37"

/obj/item/weapon/light/tube/tinted/warmtint
	name = "light tube (incandescent)"
	desc = "A replacement light tube. This one emits amber low-Kelvin light."
	icon_state = "ltube"
	base_state = "ltube"
	item_state = "c_tube"
	brightness_color = "#E09D37"

//green tint
/obj/machinery/light/greentint
	brightness_color = "#A8FFB1"

/obj/item/weapon/light/tube/tinted/greentint
	name = "light tube (green)"
	desc = "A replacement light tube. This one has an integrated green filter for vibrant green light."
	icon_state = "ltube"
	base_state = "ltube"
	item_state = "c_tube"
	brightness_color ="#A8FFB1"

/obj/item/weapon/light/tube/tinted/redtint
	name = "light tube (red)"
	desc = "A replacement light tube. This one has an integrated red filter."
	icon_state = "ltube"
	base_state = "ltube"
	item_state = "c_tube"
	brightness_color ="#B12525"

//because the train lamp sprite is nice
/obj/item/device/flashlight/lamp/lantern
	name = "lantern"
	desc = "An apparently old-school portable kerosene lamp, using modern technology to provide an extremely long-lasting flame with no fire hazard."
	icon = 'icons/urist/events/train.dmi'
	icon_state = "wolfflight"
	item_state = "lamp"
	brightness_on = 3
	light_color = "#E09D37"
	w_class = 4
	flags = CONDUCT
	light_range = 6

	on = 0

/obj/item/weapon/storage/box/lights/mixedtint
	name = "box of replacement tinted lights"
	icon_state = "lightmixed"

/obj/item/weapon/storage/box/lights/mixedtint/New()
	for(var/i = 0; i < 21; i++)
		var/variant = pick((typesof(/obj/item/weapon/light/tube/tinted)) - (/obj/item/weapon/light/tube/tinted))
		new variant(src)
	..()

/obj/item/weapon/storage/box/lights/redbulbs
	name = "box of replacement red bulbs"

/obj/item/weapon/storage/box/lights/redbulbs/New()
	for(var/i = 0; i < 21; i++)
		new /obj/item/weapon/light/bulb/red(src)
	..()

//experiment - object-based sunlight.
/obj/effect/sun
	name = "sun"
	desc = "You really shouldn't be seeing this."
	invisibility = 101
	anchored = 1
	light_color = "#fcfcb6"
	light_power = 1
	light_range = 127

/obj/machinery/light/chromatic
	name = "chromatic light"
	var/id_tag = 1
	var/freq = 1343

/obj/machinery/light/chromatic/Initialize()
	. = ..()
	radio_controller.add_object(src, freq, RADIO_CHROMATIC)

/obj/machinery/light/chromatic/receive_signal(datum/signal/signal, receive_method, receive_param)
	if(signal.data["tag"] == id_tag)
		if(signal.data["color"])
			brightness_color = signal.data["color"]
			update()

/obj/machinery/light/broken/Initialize()
	. = ..()
	broken()