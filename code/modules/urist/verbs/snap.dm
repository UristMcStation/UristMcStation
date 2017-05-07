/mob/living/proc/do_snap_fingers()
	if(src.client.prefs.muted & MUTE_IC)
		src << "You cannot send IC messages (muted)."
		return
	src.visible_message("<span class='notice'>[src] snaps their fingers.</span>", "<span class='notice'>You snap your fingers.</span>", "<span class='notice'>You hear someone snapping their fingers.</span>")
	playsound(src.loc, 'sound/urist/snap1.ogg', 80, 13, 1) //volume, random, fade
/mob/living/carbon/human/verb/snap_fingers()
	set name = "Snap Fingers"
	set category = "IC"
	set desc = "Snap your fingers."
	src.verbs -= /mob/living/carbon/human/verb/snap_fingers
	spawn(10)
		src.verbs += /mob/living/carbon/human/verb/snap_fingers
	src.do_snap_fingers()
/mob/living/carbon/monkey/verb/snap_fingers()
	set name = "Snap Fingers"
	set category = "IC"
	set desc = "Snap your fingers."
	src.verbs -= /mob/living/carbon/monkey/verb/snap_fingers
	spawn(10)
		src.verbs += /mob/living/carbon/monkey/verb/snap_fingers
	src.do_snap_fingers()
