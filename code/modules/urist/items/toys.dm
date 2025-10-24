/* Urist Toys, Plushies, Figures, etc.
 * Contains:
 *		Plushies
 *		Action figures
 */



//unathi doll and doll parent type

/obj/item/toy/plushie/unathi
	icon = 'icons/urist/items/plushies.dmi'
	w_class = 2
	item_icons = DEF_URIST_INHANDS

/obj/item/toy/plushie/unathi/attack_self(mob/user as mob)
	user.visible_message("<span class='notice'>[user] hugs [src], [src] hisses! How cute! </span>",\
						 "<span class='notice'>You hug [src], [src] hisses! Awww! </span>")

/obj/item/toy/plushie/unathi/green
	name = "unathi doll"
	desc = "A fluffy version of everyone's favorite giant lizards! This one is lime green."
	icon_state = "greenunathi"
	item_state = "greenunathi"

/obj/item/toy/plushie/unathi/red
	name = "unathi doll"
	desc = "A fluffy version of everyone's favorite giant lizards! This one is dark red."
	icon_state = "redunathi"
	item_state = "redunathi"

/obj/item/toy/plushie/unathi/lightblue
	name = "unathi doll"
	desc = "A fluffy version of everyone's favorite giant lizards! This one is cyan blue."
	icon_state = "lightblueunathi"
	item_state = "lightblueunathi"

/obj/item/toy/plushie/unathi/black
	name = "unathi doll"
	desc = "A fluffy version of everyone's favorite giant lizards! This one is a shiny black."
	icon_state = "blackunathi"
	item_state = "blackunathi"


/obj/item/toy/plushie/unathi/yellow
	name = "unathi doll"
	desc = "A fluffy version of everyone's favorite giant lizards! This one is a Royal's yellow!"
	icon_state = "yellowunathi"
	item_state = "yellowunathi"

/obj/item/toy/plushie/unathi/white
	name = "unathi doll"
	desc = "A fluffy version of everyone's favorite giant lizards! This one is a bleached white."
	icon_state = "whiteunathi"
	item_state = "whiteunathi"

/obj/item/toy/plushie/unathi/orange
	name = "unathi doll"
	desc = "A fluffy version of everyone's favorite giant lizards! This one is a earthen orange."
	icon_state = "orangeunathi"
	item_state = "orangeunathi"

/obj/item/toy/plushie/unathi/brown
	name = "unathi doll"
	desc = "A fluffy version of everyone's favorite giant lizards! This one is a dark brown."
	icon_state = "brownunathi"
	item_state = "brownunathi"

/obj/item/toy/plushie/unathi/purple
	name = "unathi doll"
	desc = "A fluffy version of everyone's favorite giant lizards! This one is a dark purple."
	icon_state = "purpleunathi"
	item_state = "purpleunathi"

/obj/item/toy/plushie/unathi/attack_self(mob/user as mob)
	user.visible_message("<span class='notice'>[user] hugs [src], [src] hisses, 'Lovingsss yousss, lovingsss messs?' How cute! </span>",\
						 "<span class='notice'>You hug [src], [src] hisses, 'Lovingsss yousss, lovingsss messs?' Awww! </span>")

// Anime Plushies

/obj/item/toy/plushie/loot
	name = "old cartoon doll"
	desc = "A cute doll of an old cartoon from early in the millennium."
	icon = 'icons/urist/items/plushies.dmi'
	icon_state = "rareplush1"

/obj/item/toy/plushie/loot/pink
	icon_state = "rareplush2"

/obj/item/toy/plushie/loot/blue
	icon_state = "rareplush3"

/obj/item/toy/plushie/loot/neet
	icon_state = "rareplush4"

/obj/item/toy/plushie/loot/goat
	icon_state = "goat"

/obj/item/toy/plushie/loot/scug
	name = "slugcat plush"
	desc = "A cute doll based off a sleeping slugcat."
	icon_state = "scugplush"

// ACTION FIGURES:

/obj/item/toy/figure/blueshield
	name = "Blueshield action figure"
	desc = "A \"Space Life\" brand Blueshield action figure."
	icon = 'icons/urist/items/figures.dmi' // yeah it's a dmi with one icon in, im sorry...
	icon_state = "blueshield"
