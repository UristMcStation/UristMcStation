//misc items that need a home

/obj/item/weapon/staff/necrostaff
	urist_only = 1
	name = "necromancer's staff"
	desc = "A staff that emits a threatening aura of death."
	icon = 'icons/urist/items/misc.dmi'
	icon_state = "necrostaff"
	item_state = "necrostaff"

//glowsticks dunno where else to put thiese

/obj/item/device/flashlight/flare/glowstick //this should never be seen
	name = "glowstick"
	desc = "A glowstick, provides a small amount of light when it "
	icon = 'icons/urist/items/misc.dmi'
	brightness_on = 2
	light_power = 2
	icon_state = "glowstick"
	item_state = "glowstick"
	on_damage = 0
	produce_heat = 0

/obj/item/device/flashlight/flare/glowstick/process()
	fuel = max(fuel - 1, 0)
	if(!fuel || !on)
		on = 0
		update_icon()
		if(!fuel)
			src.icon_state = "[initial(icon_state)]-empty"
			name = "dead glowstick"
		processing_objects -= src

/obj/item/device/flashlight/flare/glowstick/attack_self(mob/user)

	if(!fuel)
		user << "<span class='notice'>The glowstick is dead.</span>"
		return
	if(on)
		return

	. = ..()
	// All good, turn it on.
	if(.)
		user.visible_message("<span class='notice'>[user] cracks the glowstick!</span>", "<span class='notice'>You crack the glowstick, activating it!</span>")
		processing_objects += src

/obj/item/device/flashlight/flare/glowstick/random
	var/red = 0
	var/green = 0
	var/blue = 0


/obj/item/device/flashlight/flare/glowstick/random/New() //IT COULD BE ANYTHING
	red = rand(0,255)
	green = rand(0,255)
	blue = rand(0,255)
	color = rgb(red,green,blue)
	light_color = color
	..()

/obj/item/device/flashlight/flare/glowstick/red
	light_color = "#e60000"
	color = "#e60000"

/obj/item/device/flashlight/flare/glowstick/blue
	light_color = "#0000ff"
	color = "#0000ff"

/obj/item/device/flashlight/flare/glowstick/green
	light_color = "#00b300"
	color = "#00b300"

/obj/item/device/flashlight/flare/glowstick/purple
	light_color = "#ac00e6"
	color = "#ac00e6"

/obj/item/device/flashlight/flare/glowstick/orange
	light_color = "#ff8000"
	color = "#ff8000"

/obj/item/device/flashlight/flare/glowstick/yellow
	light_color = "#ffff00"
	color = "#ffff00"

/obj/item/weapon/storage/box/glowsticks
	name = "box of glowsticks"
	desc = "Contains seven different coloured glowsticks."
	icon = 'icons/urist/items/misc.dmi'
	icon_state = "gsbox"


	New()
		..()
		new /obj/item/device/flashlight/flare/glowstick/green(src)
		new /obj/item/device/flashlight/flare/glowstick/red(src)
		new /obj/item/device/flashlight/flare/glowstick/blue(src)
		new /obj/item/device/flashlight/flare/glowstick/orange(src)
		new /obj/item/device/flashlight/flare/glowstick/purple(src)
		new /obj/item/device/flashlight/flare/glowstick/yellow(src)
		new /obj/item/device/flashlight/flare/glowstick/random(src)

