/obj/food
	name = "food"
	icon = 'icons/obj/food.dmi'
	icon_state = "mysterysoup"
	var/satiety = 30


/obj/food/verb/ChangeIcon(state as text|null)
	set src in view(1)
	var/true_state = isnull(state) ? icon_state : state
	icon_state = true_state


/obj/desk
	name = "desk"
	icon = 'icons/obj/computer.dmi'
	icon_state = "syndicam"


/obj/vending
	name = "vending machine"
	icon = 'icons/obj/vending.dmi'
	icon_state = "snack"


/obj/bed
	name = "bed"
	icon = 'icons/obj/objects.dmi'
	icon_state = "bed"



