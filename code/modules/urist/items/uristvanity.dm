/*										*****New space to put all Urist Mcstation Vanity items*****

Please keep it tidy, by which I mean put comments describing the item before the entry. -Glloyd*/

//vanity lighters, stolen from the custom items.//WHY. WHYYYYY -scrdest

/obj/item/flame/lighter/zippo/vanity/on_update_icon()
	var/datum/extension/base_icon_state/bis = get_extension(src, /datum/extension/base_icon_state)

	if(lit)
		icon_state = "[bis.base_icon_state]_open"
		item_state = "[bis.base_icon_state]_open"
	else
		icon_state = "[bis.base_icon_state]"
		item_state = "[bis.base_icon_state]"

/obj/item/flame/lighter/zippo/vanity/blue
	name = "blue zippo"
	desc = "A zippo lighter made of some blue metal."
	icon = 'icons/urist/items/old_bay_custom_items.dmi'
	icon_state = "bluezippo"

/obj/item/flame/lighter/zippo/vanity/gold
	name = "gold zippo"
	desc = "A golden lighter, engraved with some ornaments."
	icon = 'icons/urist/items/old_bay_custom_items.dmi'
	icon_state = "guessip"

/obj/item/flame/lighter/zippo/vanity/black
	name = "black zippo"
	desc = "A black zippo lighter."
	icon = 'icons/urist/items/old_bay_custom_items.dmi'
	icon_state = "blackzippo"

/obj/item/flame/lighter/zippo/vanity/red
	name = "black and red zippo"
	desc = "A black and red zippo lighter."
	icon = 'icons/urist/items/old_bay_custom_items.dmi'
	icon_state = "gonzozippo"

/obj/item/flame/lighter/zippo/vanity/engraved
	name = "engraved zippo"
	desc = "A intricately engraved zippo lighter."
	icon = 'icons/urist/items/old_bay_custom_items.dmi'
	icon_state = "engravedzippo"

/obj/item/flame/lighter/zippo/vanity/redwhitered
	name = "red striped zippo"
	desc = "A red and white striped zippo lighter."
	icon = 'icons/urist/items/old_bay_custom_items.dmi'
	icon_state = "redzippo"

/obj/item/flame/lighter/zippo/vanity/butterfly
	name = "butterfly lighter"
	desc = "A custom-made zippo lighter, looks rather expensive. On one of its sides, a butterfly is engraved in gold and silver."
	icon = 'icons/urist/items/old_bay_custom_items.dmi'
	icon_state = "che_zippo"

//nanotrasen shiiiiit for the nt vending machine

/obj/item/crowbar/nanotrasen //nt crowbar
	item_icons = DEF_URIST_INHANDS
	name = "NanoTrasen crowbar"
	desc = "A crowbar in the NanoTrasen colours."
	icon = 'icons/urist/items/tools.dmi'
	icon_state = "ncrowbar"
	item_state = "ncrowbar"

/obj/item/device/flashlight/nanotrasen //nt flashlight
	name = "NanoTrasen flashlight"
	desc = "A hand-held emergency light in the NanoTrasen colours with a white NT embossed on the side."
	icon = 'icons/urist/items/tools.dmi'
	icon_state = "flashlight"
	item_state = "flashlight"

/obj/item/storage/toolbox/nanotrasen //nt toolbox
	name = "NanoTrasen toolbox"
	desc = "A tooldbox in the NanoTrasen colours with a white NT emblazoned on the side."
	icon = 'icons/urist/items/tools.dmi'
	icon_state = "ntoolbox"
	item_state = "toolbox_blue"

/obj/item/storage/toolbox/nanotrasen/New()
	..()
	new /obj/item/screwdriver(src)
	new /obj/item/wrench(src)
	new /obj/item/crowbar/nanotrasen(src)
	new /obj/item/device/flashlight/nanotrasen(src)



//light cigs

/obj/item/storage/fancy/smokable/urist/lights
	name = "pack of 'Lights' cigarettes"
	desc = "The cigarettes for those who like things on the light side."
	icon = 'icons/urist/uristicons.dmi'
	icon_state = "Lpacket"
	item_state = "Lpacket"

//watches

/obj/item/clothing/accessory/watch
	item_icons = URIST_ALL_ONMOBS
	icon = 'icons/urist/items/clothes/ties.dmi'

/obj/item/clothing/accessory/watch/wrist
	name = "wrist watch"
	desc = "A black plastic analog wristwatch."
	icon_state = "w_watch"
	//item_color = "w_watch"

/obj/item/clothing/accessory/watch/pocket
	name = "pocket watch"
	desc = "A fancy brass analog pocketwatch."
	icon_state = "p_watch"
	//item_color = "p_watch"

/obj/item/clothing/accessory/watch/examine()
	to_chat(usr, "[desc] The time reads [stationtime2text()].")

//comb

/obj/item/vanity/comb
	name = "purple comb"
	desc = "A pristine purple comb made from flexible plastic."
	w_class = 2.0
	icon = 'icons/obj/lavatory.dmi'
	icon_state = "comb"
	item_state = "comb"
	color = "#9932cc"

/obj/item/vanity/comb/attack_self(mob/user)
	if(user.r_hand == src || user.l_hand == src)
		for(var/mob/O in viewers(user, null))
			O.show_message(text("<span class='warning'> [] uses [] to comb their hair with incredible style and sophistication. Wow, that's pretty suave.</span>", user, src), 1)
	return

//unathi doll and doll parent type

/obj/item/vanity/doll
	icon = 'icons/urist/items/urist_plushie.dmi'
	w_class = 2
	item_icons = DEF_URIST_INHANDS

/obj/item/vanity/doll/unathi/attack_self(mob/user as mob)
	user.visible_message("<span class='notice'>[user] hugs [src], [src] hisses! How cute! </span>",\
						 "<span class='notice'>You hug [src], [src] hisses! Awww! </span>")

/obj/item/vanity/doll/unathi/green
	name = "unathi doll"
	desc = "A fluffy version of everyone's favorite giant lizards! This one is lime green."
	icon_state = "greenunathi"
	item_state = "greenunathi"

/obj/item/vanity/doll/unathi/red
	name = "unathi doll"
	desc = "A fluffy version of everyone's favorite giant lizards! This one is dark red."
	icon_state = "redunathi"
	item_state = "redunathi"

/obj/item/vanity/doll/unathi/lightblue
	name = "unathi doll"
	desc = "A fluffy version of everyone's favorite giant lizards! This one is cyan blue."
	icon_state = "lightblueunathi"
	item_state = "lightblueunathi"

/obj/item/vanity/doll/unathi/black
	name = "unathi doll"
	desc = "A fluffy version of everyone's favorite giant lizards! This one is a shiny black."
	icon_state = "blackunathi"
	item_state = "blackunathi"


/obj/item/vanity/doll/unathi/yellow
	name = "unathi doll"
	desc = "A fluffy version of everyone's favorite giant lizards! This one is a Royal's yellow!"
	icon_state = "yellowunathi"
	item_state = "yellowunathi"

/obj/item/vanity/doll/unathi/white
	name = "unathi doll"
	desc = "A fluffy version of everyone's favorite giant lizards! This one is a bleached white."
	icon_state = "whiteunathi"
	item_state = "whiteunathi"

/obj/item/vanity/doll/unathi/purple
	name = "unathi doll"
	desc = "A fluffy version of everyone's favorite giant lizards! This one is a dark purple."
	icon_state = "purpleunathi"
	item_state = "purpleunathi"

/obj/item/vanity/doll/unathi/purple/attack_self(mob/user as mob)
	user.visible_message("<span class='notice'>[user] hugs [src], [src] hisses, 'Lovingsss yousss, lovingsss messs?' How cute! </span>",\
						 "<span class='notice'>You hug [src], [src] hisses, 'Lovingsss yousss, lovingsss messs?' Awww! </span>")


/obj/item/vanity/doll/unathi/orange
	name = "unathi doll"
	desc = "A fluffy version of everyone's favorite giant lizards! This one is a earthen orange."
	icon_state = "orangeunathi"
	item_state = "orangeunathi"

/obj/item/vanity/doll/unathi/brown
	name = "unathi doll"
	desc = "A fluffy version of everyone's favorite giant lizards! This one is a dark brown."
	icon_state = "brownunathi"
	item_state = "brownunathi"

//leather wallet for recipes_leather.dm, flower crowns for loadout
/obj/item/storage/wallet/leather
	color = COLOR_SEDONA

/obj/item/clothing/ears/flower
	name = "flower crown"
	desc = "A crown of flowers. You're not sure how it never decays."
	icon = 'icons/urist/items/misc.dmi'
	item_icons = URIST_ALL_ONMOBS

/obj/item/clothing/ears/flower/Initialize()
	. = ..()
	name = "[icon_state] [name]"

/obj/item/clothing/ears/flower/poppy
	icon_state = "poppy"

/obj/item/clothing/ears/flower/sunflower
	icon_state = "sunflower"

/obj/item/clothing/ears/flower/moonflower
	icon_state = "moonflower"

/obj/item/clothing/ears/flower/novaflower
	icon_state = "novaflower"

/obj/item/clothing/ears/flower/ambrosiavulgaris
	icon_state = "ambrosia vulgaris"

/obj/item/clothing/ears/flower/ambrosiadeus
	icon_state = "ambrosia deus"

/obj/item/clothing/ears/flower/ambrosia_gaia
	icon_state = "ambrosia gaia"

/obj/item/clothing/ears/flower/lily
	icon_state = "lily"

/obj/item/clothing/ears/flower/geranium
	icon_state = "geranium"
