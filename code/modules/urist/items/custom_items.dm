obj/item/weapon/custom_items/dostek
	name = "dostek doll"
	desc = "A fluffy version of everyone's favorite green lizard!"
	icon = 'icons/urist/items/misc.dmi'
	icon_state = "dostek"
	item_state = "dostek"
	w_class = 1

/obj/item/weapon/custom_items/dostek/attack_self(mob/user as mob)
	user.visible_message("<span class='notice'>[user] hugs [src], [src] screams, Isss Dossstek! How cute! </span>",\
						 "<span class='notice'>You hug [src], [src] screams Isss Dossstek! Awww! </span>")