//surface planer, for "processing" wood. I know, I know. But nobody else knows anything about carpentry, so it's okay. -Glloyd

/obj/machinery/planer
	name = "surface planer"
	desc = "A surface planer, used for processing unprocessed wood." //*cringe*
	icon = 'icons/urist/structures&machinery/machinery.dmi'
	icon_state = "planer"
	var/sheets = 0
	anchored = 1
	density = 1
	var/busy = 0

/obj/machinery/planer/attackby(var/obj/item/I, mob/user as mob)
	if(istype(I, /obj/item/stack/material/wood/r_wood))

		if(busy)
			user << "<span class='notice'>The [src] is busy, you can't put in wood yet!.</span>"
			return

		else if(!busy)
			var/obj/item/stack/material/wood/r_wood/R = I
			busy = 1
			sheets = R.amount
			R.use(R.amount)

			user << "<span class='notice'>You feed the unprocessed wood into the [src].</span>"

			flick("planer_animate",src)

			sleep(15)

			var/obj/item/stack/material/wood/W = new /obj/item/stack/material/wood(src.loc)

			W.amount = sheets

			sheets = 0
			busy = 0

	else
		return


/obj/item/stack/material/wood/r_wood
	name = "unprocessed wooden planks"
//	desc = "A bunch of unprocessed wood planks."
	icon = 'icons/urist/items/wood.dmi'
	icon_state = "planks"
	singular_name = "unprocessed wood plank"