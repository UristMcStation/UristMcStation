/mob/living/simple_animal/hostile/sound
	var/list/last_saw

/mob/living/simple_animal/hostile/sound/Initialize()
	. = ..()
	last_saw = list()

/mob/living/simple_animal/hostile/sound/hear_say(var/message, var/verb = "says", var/datum/language/language = null, var/alt_name = "",var/italics = 0, var/mob/speaker = null, var/sound/speech_sound, var/sound_vol)
	if(speaker)
		target = speaker
		visible_message("<span class = 'danger'>[src] screeches at [speaker]!</span>")
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
	visible_message("<span class = 'danger'><font size = 3>[src] screeches at [youmessedup]!</font></span>")
	return pick(moved)