/mob/living/carbon/human
	var/miming = 0

//TODO: put these somewhere else
/client/proc/mimewall()
	set category = "Mime"
	set name = "Invisible wall"
	set desc = "Create an invisible wall on your location."
	if(usr.stat)
		to_chat(usr, "Not when you're incapicated.")
		return
	if(!ishuman(usr))
		return

	var/mob/living/carbon/human/H = usr

	if(!H.miming)
		to_chat(usr, "You still haven't atoned for your speaking transgression. Wait.")
		return
	H.verbs -= /client/proc/mimewall
	spawn(300)
		H.verbs += /client/proc/mimewall
	for (var/mob/V in viewers(H))
		if(V!=usr)
			V.show_message("[H] looks as if a wall is in front of them.", 3, "", 2)
	to_chat(usr, "You form a wall in front of yourself.")
	new /obj/forcefield/mime(locate(usr.x,usr.y,usr.z))
	return

///////////Mimewalls///////////
/* //these are located in forcewall.dm, under wizard spells
/obj/forcefield/mime
	icon_state = "empty"
	name = "invisible wall"
	desc = "You have a bad feeling about this."
	var/timeleft = 300
	var/last_process = 0

/obj/forcefield/mime/New()
	..()
	last_process = world.time
	START_PROCESSING(SSobj, src)

/obj/forcefield/mime/Process()
	timeleft -= (world.time - last_process)
	if(timeleft <= 0)
		STOP_PROCESSING(SSobj, src)
		qdel(src)
*/
///////////////////////////////

/client/proc/mimespeak()
	set category = "Mime"
	set name = "Speech"
	set desc = "Toggle your speech."
	if(!ishuman(usr))
		return

	var/mob/living/carbon/human/H = usr

	if(H.miming)
		H.miming = 0
	else
		to_chat(H, "You'll have to wait if you want to atone for your sins.")
		spawn(3000)
			H.miming = 1
	return
