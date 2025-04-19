/* Keep it nice and tidy, this is for any items /vg/ related that we port over! - Lania */

// Noisemaker
/obj/item/soundsynth
	name = "clown's noisemaker"
	desc = "A garish pink device, with a plethora of sounds to play and annoy your fellow crew with. HONK!"
	icon = 'icons/urist/items/tgitems.dmi'	// Placed in TG for sake of avoiding another icon file.
	icon_state = "noisemaker"
	item_state = "radio"
	siemens_coefficient = 1
	var/spam_flag = 0 // Prevents sound spamming.
	var/selected_sound = "sound/items/bikehorn.ogg"
	var/shiftpitch = 1
	var/volume = 50

	var/list/sound_list = list(				//Some fun stuff for the Clown to play with, it'll be good for pranks.
	"Honk" = "selected_sound=sound/items/bikehorn.ogg&shiftpitch=1&volume=50",
	"Airhorn 1" = "selected_sound=sound/items/airhorn_1.ogg&shiftpitch=1&volume=50",
	"Airhorn 2" = "selected_sound=sound/items/airhorn_2.ogg&shiftpitch=1&volume=50",
	"Sad Trombone" = "selected_sound=sound/misc/sadtrombone.ogg&shiftpitch=1&volume=50",
	"Ding Ding Ding" = "selected_sound=sound/items/manydings.ogg&shiftpitch=1&volume=50",
	"Cowboy"  = "selected_sound=sound/effects/cowboysting.ogg&shiftpitch=1&volume=50",
	"Scary Sound" = "selected_sound=sound/items/effects/ghost2.ogg&shiftpitch=1&volume=50",
	"Creepy Shriek" = "selected_sound=sound/urist/creepyshriek.ogg&shiftpitch=1&volume=50",
	"Meteor Impact" = "selected_sound=sound/items/effects/meteorimpact.ogg&shiftpitch=1&volume=50",
	"Explosion Far Away"  = "selected_sound=sound/effects/explosionfar.ogg&shiftpitch=1&volume=50",
	"EMP Pulse"  = "selected_sound=sound/effects/EMPulse.ogg&shiftpitch=1&volume=50",
	"Glass Smashing"  = "selected_sound=sound/effects/Glassbr3.ogg&shiftpitch=1&volume=50",
	"Screwdriver" = "selected_sound=sound/items/Screwdriver.ogg&shiftpitch=1&volume=50",
	"Wirecutter Snip"= "selected_sound=sound/items/Wirecutter.ogg&shiftpitch=1&volume=50",
	"Welder"  = "selected_sound=sound/items/Welder.ogg&shiftpitch=1&volume=50",
	"Airlock Creaking" = "selected_sound=sound/machine/airlock_creaking.ogg&shiftpitch=1&volume=50",
	"Ventcrawl"  = "selected_sound=sound/machines/ventcrawl.ogg&shiftpitch=1&volume=50",
	"Arm Bomb" = "selected_sound=sound/weapons/armbomb.ogg&shiftpitch=1&volume=50",
	"Timer"  = "selected_sound=sound/items/timer.ogg&shiftpitch=1&volume=50",
	"E-Sword On" = "selected_sound=sound/weapons/saberon.ogg&shiftpitch=1&volume=50",
	"E-Sword Stab" = "selected_sound=sound/weapons/blade1.ogg&shiftpitch=1&volume=50",
	"Stab" = "selected_sound=sound/weapons/bladeslice.ogg&shiftpitch=1&volume=50",
	"Handcuffs" = "selected_sound=sound/weapons/handcuffs.ogg&shiftpitch=1&volume=50",
	"Taser" = "selected_sound=sound/weapons/Taser.ogg&shiftpitch=1&volume=50",
	"Pistol Shot"  = "selected_sound=sound/weapons/gunshot/gunshot_pistol.ogg&shiftpitch=1&volume=50",
	"Shotgun Shot"  = "selected_sound=sound/weapons/gunshot/shotgun.ogg&shiftpitch=1&volume=50",
	"Shotgun Pump" = "selected_sound=sound/weapons/shotgunpump.ogg&shiftpitch=1&volume=50",
	"Laser Fire" = "selected_sound=sound/weapons/Laser.ogg&shiftpitch=1&volume=50"

	)

/obj/item/soundsynth/verb/pick_sound()
	set category = "Object"
	set name = "Select Sound Playback"
	var/chosensound = input("Pick a sound:", null) as null|anything in sound_list
	if(!chosensound)
		return
	to_chat(usr, "Sound playback set to: [chosensound]!")
	var/list/finalsound = params2list(sound_list[chosensound])
	selected_sound = finalsound["selected_sound"]
	shiftpitch = text2num(finalsound["shiftpitch"])
	volume = text2num(finalsound["volume"])

/obj/item/soundsynth/attack_self(mob/user as mob)
	if(spam_flag + 2 SECONDS < world.timeofday)
		playsound(src, selected_sound, volume, shiftpitch)
		spam_flag = world.timeofday

/obj/item/soundsynth/use_before(mob/living/M as mob, mob/living/user as mob, def_zone)
	if(M == user)
		pick_sound()
		return TRUE

	else if(spam_flag + 2 SECONDS < world.timeofday)
		playsound(get_turf(M), selected_sound, volume, shiftpitch)
		spam_flag = world.timeofday
		//to_chat(M, selected_sound) //this doesn't actually go to their chat very much at all.
		return TRUE

	return FALSE


/obj/item/device/megaphone/clown
	name = "clown's megaphone"
	desc = "A device used to project your voice, it's painted to look like a child's toy."
	icon = 'icons/urist/items/tgitems.dmi'
	icon_state = "megaphone_clown"
	item_state = "radio"
	w_class = ITEM_SIZE_SMALL
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	insultmsg = list("HONK!", "HELP, SHITCURITY!", "HELP MAINT", "SHITSEC", "I AM IN A CONSTANT STATE OF SUFFERING, EACH EON SPENT ON THIS PLANE OF EXISTENCE ECHOES ONLY PURE PAIN TO MY MORTAL COIL. GOD HAS DIED, AND HE HAS ONLY LEFT ME SUFFERING. ", "MY FUNNY BONE!")
