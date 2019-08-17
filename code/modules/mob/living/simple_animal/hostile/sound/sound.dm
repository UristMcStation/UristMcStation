/mob/living/simple_animal/hostile/sound
	var/list/last_saw
	var/list/alert_message = list("screeches at")
	var/list/alert_sound
	var/next_alert

/mob/living/simple_animal/hostile/sound/Initialize()
	. = ..()
	last_saw = list()

/mob/living/simple_animal/hostile/sound/hear_say(var/message, var/verb = "says", var/datum/language/language = null, var/alt_name = "",var/italics = 0, var/mob/speaker = null, var/sound/speech_sound, var/sound_vol)
	if(speaker)
		alerted(speaker)
	if(!client)
		MoveToTarget()
	..()

/mob/living/simple_animal/hostile/sound/PickTarget(var/list/visible)
	var/list/moved = list()
	if(!visible.len)
		return
	for(var/mob/living/V in visible)
		if(V.name in last_saw)
			var/mob/living/M = last_saw[V.name]["mob"]
			if(V.x != last_saw[V.name]["x"] || V.y != last_saw[V.name]["y"])
				moved += M
	last_saw = list()
	for(var/mob/VI in visible)
		last_saw[VI.name] = list("mob" = VI, "x" = VI.x, "y" = VI.y)
	if(!moved.len)
		return
	var/youmessedup = pick(moved)
	alerted(youmessedup)
	return youmessedup

/mob/living/simple_animal/hostile/sound/LoseAggro()
	..()
	last_saw = list()

/mob/living/simple_animal/hostile/sound/proc/alerted(var/mob/detected)
	if(islist(alert_message) && alert_message.len)
		if(next_alert > world.time)
			var/message = pick(alert_message)
			visible_message("<span class = 'danger'><font size = 3>[src] [message] [detected]!</font></span>")
			next_alert = world.time + 15 SECONDS
	if(islist(alert_sound) && alert_sound.len)
		var/sound = pick(alert_sound)
		playsound(src, sound, 100, 1)