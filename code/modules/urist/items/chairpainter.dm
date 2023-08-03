//chair painter

/obj/item/chair_painter
	name = "chair painter"
	desc = "An advanced autopainter used to change the colour of comfy chairs or couches. Select the colour you want, then use it on any comfy chair or couch."
	icon = 'icons/urist/items/tgitems.dmi'
	icon_state = "paint_sprayer"
	item_state = "paint_sprayer"

	w_class = 2.0

	origin_tech = "engineering=1"

	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT

	var/red = 0
	var/green = 0
	var/blue = 0

/obj/item/chair_painter/attack_self(mob/user)
	var/new_color = input("Please select chair colour.", "Colour Selection") as color
	if(new_color)
		red = hex2num(copytext(new_color, 2, 4))
		green = hex2num(copytext(new_color, 4, 6))
		blue = hex2num(copytext(new_color, 6, 8))

/obj/structure/bed/chair/comfy/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if(istype(W, /obj/item/chair_painter))
		var/obj/item/chair_painter/C = W
		color = rgb(C.red,C.green,C.blue)
