/*										*****New space to put all /vg/station small item ports*****

Make sure you comment what above the items you add to keep it nice and tidy, Icons go to 'icons/urist/items/vgitems.dmi'
Please only put items here that don't have a huge definition - Glloyd																*/

/*
				Sound Synthesizer (For the Clown)
        Ported from /vg/station:
        https://github.com/vgstation-coders/vgstation13/blob/Bleeding-Edge/code/game/objects/items/devices/sound_synth.dm
*/

/obj/item/soundsynth
    name = "clown's noisemaker"
    desc = "A device used by the Clown to produce various sounds."
    icon = 'icons/obj/radio.dmi'
    icon_state = "radio"
    item_state = "radio"
    siemens_coefficient = 1
    var/tmp/spam_flag = 0 // Prevents sound spamming.
    var/selected_sound = "sound/items/bikehorn.ogg"
    var/shiftpitch = 1
    var/volume = 50

    var/list/sound_list = list(				//Some fun stuff for the Clown to play with, it'll be good for pranks.
    "Honk" = "selected_sound=sound/items/bikehorn.ogg&shiftpitch=1&volume=50",
    "Airhorn" = "selected_sound=sound/items/bikehorn.ogg&shiftpitch=1&volume=50",
    "Creepy Shriek" = "selected_sound=sound/urist/creepyshriek.ogg&shiftpitch=1&volume=50",
    "Energy Sword Swing" = "selected_sound=sound/weapons/blade1.ogg&shiftpitch=1&volume=50",
    "Restraining Sound" = "selected_sound=sound/weapons/cablecuff.ogg&shiftpitch=1&volume=50",
    "Gunshot" = "selected_sound=sound/weapons/gunshot/gunshot_pistol.ogg&shiftpitch=1&volume=50",
    "Boom" = "selected_sound=sound/effects/explosion1.ogg&shiftpitch=1&volume=50",
    "Boom from Afar" = "selected_sound=sound/effects/explosionfar.ogg&shiftpitch=1&volume=50",
    "Scary Sound" = "selected_sound=sound/effects/hallucinations/growl1.ogg&shiftpitch=1&volume=50",
    "Creepy Whisper" = "selected_sound=sound/hallucinations/turn_around1.ogg&shiftpitch=1&volume=50",
    "Mech Clang" = "selected_sound=sound/mecha/mechstep.ogg&shiftpitch=1&volume=50",
    "Sad Trombone" = "selected_sound=sound/misc/sadtrombone.ogg&shiftpitch=1&volume=50",
    "Grenade Beep" = "selected_sound=sound/weapons/armbomb.ogg&shiftpitch=1&volume=50",
    "Creaking Airlock" = "selected_sound=sound/machines/airlock_creaking.ogg&shiftpitch=1&volume=50",
    "Vent Crawl" = "selected_sound=sound/machines/ventcrawl.ogg&shiftpitch=0&volume=50",
    "Nymph Chirp" = "selected_sound=sound/misc/nymphchirp.ogg&shiftpitch=0&volume=50",
    "Welding Noises" = "selected_sound=sound/items/welder.ogg&shiftpitch=1&volume=50",
    "Glass Breaking" = "selected_sound=sound/effects/glassbr1.ogg&shiftpitch=1&volume=50",
    "Ticking Timer" = "selected_sound=sound/items/timer.ogg&shiftpitch=1&volume=50"
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

/obj/item/soundsynth/attack(mob/living/M as mob, mob/living/user as mob, def_zone)
    if(M == user)
        pick_sound()
    else if(spam_flag + 2 SECONDS < world.timeofday)
        M.playsound_local(get_turf(src), selected_sound, volume, shiftpitch)
        spam_flag = world.timeofday
        //to_chat(M, selected_sound) //this doesn't actually go to their chat very much at all.
