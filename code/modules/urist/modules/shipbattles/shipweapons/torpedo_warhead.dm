//TORPEDO WARHEAD BEGIN//
//Torpedo IEDs begin
#define CIRCUITRY_EXPOSED 2
#define CIRCUITRY_MODIFIED 3
#define CIRCUITRY_RIGGED 4
//Torpedo IEDs end
/obj/item/shipweapons/torpedo_warhead
	name = "torpedo warhead"
	desc = "It's a big warhead for a big torpedo. Shove it in a torpedo casing and you've got yourself a torpedo." //torpedo
	icon = 'icons/urist/items/ship_projectiles.dmi'
	icon_state = "torpedowarhead"
	var/safety = 1 //Integrated safeties are functioning as intended. This thing's inert.
	var/is_rigged = 0 //Has this thing been jerry-rigged?
	var/riggedstate = 0 //What stage of rigging are we in?
	var/obj/item/device/attached_device //Whatever is attached that'll detonate us.
	var/datum/wires/torpedowarhead/wires = null
	var/shield_damage = 0
	var/hull_damage = 0
	var/pass_shield = FALSE
	var/component_hit = 0
	var/ammo_name //for naming the torpedo
	var/component_modifier_low = 0.2
	var/component_modifier_high = 0.5

/obj/item/shipweapons/torpedo_warhead/New()
	..()
	wires = new/datum/wires/torpedowarhead(src)

/obj/item/shipweapons/torpedo_warhead/Destroy()
	QDEL_NULL(wires)
	QDEL_NULL(attached_device)
	. = ..()

/obj/item/shipweapons/torpedo_warhead/examine(mob/user)
	..(user)
	switch(riggedstate)
		if(CIRCUITRY_EXPOSED) to_chat(user, "<span class='notice'>It's control circuitry is exposed.</span>")
		if(CIRCUITRY_MODIFIED) to_chat(user, "<span class='notice'>It's control circuitry is exposed, and the internal wiring appears to have been modified.</span>")
		if(CIRCUITRY_RIGGED) to_chat(user, "<span class='notice'>It's control circuitry is exposed, the internal wiring appears to have been modified, and a wire has been rigged to \The [attached_device].</span>")
	switch(safety)
		if(0) to_chat(user, "<span class='warning'>The safeties have been disabled.</span>")
		if(1) to_chat(user, "<span class='notice'>The safeties are enabled.</span>")
	if(is_rigged)
		to_chat(user, "<span class='warning'>There is \a [attached_device] attached to the warhead.</span>")

/obj/item/shipweapons/torpedo_warhead/use_tool(obj/item/I, mob/living/user, list/click_params)
	if(istype(I, /obj/item/crowbar))
		if(riggedstate == CIRCUITRY_EXPOSED && !attached_device) // can't close it if it's got something it's not supposed to have.
			to_chat(user, "<span class='notice'>You carefully close the warhead's circuitry panel.</span>")
			riggedstate = 0
			playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)
			icon_state = initial(icon_state)
		else if(!riggedstate)
			to_chat(user, "<span class='notice'>You carefully lever open the warhead's circuitry panel.</span>")
			riggedstate = CIRCUITRY_EXPOSED
			playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)
			icon_state = "torpedowarhead-open"
		else
			to_chat(user, "<span class='notice'>You can't close the panel. Remove the [attached_device] first.</span>")

	else if(istype(I, /obj/item/wirecutters))
		if(is_rigged && attached_device)
			to_chat(user, "<span class='notice'>You carefully begin to remove [attached_device] from the warhead's internals.</span>")
			if(do_after(user,4 SECONDS))
				to_chat(user, "<span class='notice'>You carefully remove [attached_device] from the warhead's internals.</span>")
				var/obj/item/device/assembly/A = attached_device
				A.forceMove(get_turf(user))
				A.holder = null
				attached_device = null
				is_rigged = 0
				playsound(src.loc, 'sound/items/Wirecutter.ogg', 50, 1)
				icon_state = "torpedowarhead-open-mod"
		else if(riggedstate == CIRCUITRY_RIGGED)
			to_chat(user, "<span class='notice'>You snip the wire attached to the warhead's detonation circuit.</span>")
			riggedstate = CIRCUITRY_MODIFIED
			playsound(src.loc, 'sound/items/Wirecutter.ogg', 50, 1)
			icon_state = "torpedowarhead-open-mod"
		else if(riggedstate == CIRCUITRY_MODIFIED)
			to_chat(user, "<span class='notice'>You carefully undo the modifications to the warhead's circuitry.</span>")
			riggedstate = CIRCUITRY_EXPOSED
			playsound(src.loc, 'sound/items/Wirecutter.ogg', 50, 1)
			icon_state = "torpedowarhead-open"
		else if(riggedstate == CIRCUITRY_EXPOSED)
			to_chat(user, "<span class='notice'>You begin to carefully modify the circuitry of the warhead.</span>")
			if(do_after(user,4 SECONDS))
				to_chat(user, "<span class='notice'>You have modified the torpedo warhead's internal circuitry. It can now be wired up and attached to something.</span>")
				riggedstate = CIRCUITRY_MODIFIED
				playsound(src.loc, 'sound/items/Wirecutter.ogg', 50, 1)
				icon_state = "torpedowarhead-open-mod"
		return TRUE
	else if(istype(I, /obj/item/device/multitool))
		if(riggedstate == CIRCUITRY_EXPOSED)
			wires.Interact(user)
	else if(istype(I, /obj/item/stack/cable_coil) && riggedstate == CIRCUITRY_MODIFIED)
		to_chat(user, "<span class='notice'>You rig a wire from the torpedo warhead's detonator circuit. You can now attach something to it to detonate it remotely.</span>")
		riggedstate = CIRCUITRY_RIGGED
		playsound(src.loc, 'sound/items/Wirecutter.ogg', 50, 1)
	else if(istype(I, /obj/item/device/assembly))
		if(riggedstate == CIRCUITRY_RIGGED)
			var/obj/item/device/assembly/A = I
			to_chat(user, "<span class='warning'>You rig the [A] to the torpedo warhead's detonator circuit!</span>")
			is_rigged = 1
			if(!user.unEquip(A, src))
				return
			A.forceMove(src)
			attached_device = I
			A.holder = src
			log_and_message_admins("has rigged a torpedo IED.",  user)
			playsound(src.loc, 'sound/items/Wirecutter.ogg', 50, 1)
			icon_state = "torpedowarhead-open-mod-armed"

	return ..()

/obj/item/shipweapons/torpedo_warhead/attack_self(mob/user as mob)
	..()
	if(riggedstate == CIRCUITRY_EXPOSED)
		wires.Interact(user)

/obj/item/shipweapons/torpedo_warhead/proc/process_activation() // uh oh, time to boom
	detonate()

/obj/item/shipweapons/torpedo_warhead/proc/detonate(forced = 0)
	playsound(src.loc, 'sound/machines/buttonbeep.ogg', 25, 0, 10)
	if(safety && !forced)
		visible_message("<span class='danger'>[src] beeps stubbornly, refusing to detonate!</span>")
		playsound(src.loc, 'sound/machines/buzz-sigh.ogg', 25, 0, 10)
	if(!safety || forced)
		if(!forced && prob(15)) // Small chance for the warhead's safeties to engage briefly.
			visible_message("<span class='danger'>[src] beeps stubbornly, refusing to detonate!</span>")
			playsound(src.loc, 'sound/machines/buzz-sigh.ogg', 25, 0, 10)
			return
		visible_message("<span class='danger'>[src] pings, begining a short countdown!</span>")
		playsound(src.loc, 'sound/machines/ping.ogg', 25, 0, 10)
		playsound(src.loc, 'sound/items/countdown.ogg', 25, 0, 10)
		spawn(4 SECONDS)
			if(!forced && safety) //if the madlads somehow disarm this thing BEFORE detonation ...
				visible_message("<span class='danger'>[src] beeps stubbornly, refusing to detonate!</span>")
				playsound(src.loc, 'sound/machines/buzz-sigh.ogg', 25, 0, 10)
				return
			do_explosion()
			qdel(src)

/obj/item/shipweapons/torpedo_warhead/proc/do_explosion()
	explosion(get_turf(src), 7, EX_ACT_HEAVY, 1)

/datum/wires/torpedowarhead
	holder_type = /obj/item/shipweapons/torpedo_warhead
	random = 1
	wire_count = 7

var/global/const/TWARHEAD_SAFE		= 1
var/global/const/TWARHEAD_SAFE_2	= 2
var/global/const/TWARHEAD_DETONATE = 4

/datum/wires/torpedowarhead/GetInteractWindow()
	var/obj/item/shipweapons/torpedo_warhead/N = holder
	. += ..()
	. += "Amid the various components, you see the safety interlocks are [N.safety ? "engaged" : "disengaged"].<BR>"

/datum/wires/torpedowarhead/UpdatePulsed(index)
	var/obj/item/shipweapons/torpedo_warhead/N = holder
	switch(index)
		if(TWARHEAD_SAFE)
			if(IsIndexCut(TWARHEAD_SAFE_2) && !N.safety)
				N.visible_message("<span class='good'>[N]'s safety interlocks re-engage!</span>")
				N.safety = 1
				playsound(N.loc, 'sound/machines/BoltsDown.ogg', 25, 0, 10)
				N.icon_state = "torpedowarhead-open-mod[N.safety ? "" : "-armed"]"
			else
				N.visible_message("<span class='notice'>[N]'s safety interlocks whirr faintly.</span>")
		if(TWARHEAD_SAFE_2)
			if(N.safety)
				N.visible_message("<span class='warning'>[N]'s safety interlocks disengage!</span>")
				playsound(N.loc, 'sound/machines/BoltsUp.ogg', 25, 0, 10)
				N.safety = 0
				N.icon_state = "torpedowarhead-open-mod[N.safety ? "" : "-armed"]"
		if(TWARHEAD_DETONATE)
			N.detonate()

/datum/wires/torpedowarhead/UpdateCut(index, mended)
	var/obj/item/shipweapons/torpedo_warhead/N = holder
	switch(index)
		if(TWARHEAD_SAFE)
			if(!mended)
				N.visible_message("<span class='notice'>[N]'s safety interlocks whirr and clunk loudly.</span>")
		if(TWARHEAD_SAFE_2)
			if(!mended)
				N.visible_message( "<span class='notice'>[N]'s safety interlocks twitch towards the retracted position.</span>")
			else
				N.visible_message( "<span class='notice'>[N]'s safety interlocks whirr and clunk loudly.</span>")
		if(TWARHEAD_DETONATE)
			N.detonate(1)

//warhead types //damage values are in flux

/obj/item/shipweapons/torpedo_warhead/bluespace //this is the previous warhead, we pass through the shield, and do some damage.
	name = "bluespace torpedo warhead"
	desc = "It's a big bluespace-capable warhead for a big torpedo. Shove it in a torpedo casing and you've got yourself a torpedo." //torpedo
	icon_state = "bstorpedowarhead"
	hull_damage = 302 //18.875 dps
	pass_shield = TRUE
	component_hit = 65
	component_modifier_low = 0.3
	component_modifier_high = 0.675
	ammo_name = "bluespace"

/obj/item/shipweapons/torpedo_warhead/ap
	name = "armour-piercing torpedo warhead"
	desc = "It's a big armour-piercing warhead for a big torpedo. Shove it in a torpedo casing and you've got yourself a torpedo." //torpedo
	icon_state = "aptorpedowarhead"
	hull_damage = 620 //38.75 dps, currently the highest if the shields are down and you can score a hit
	component_hit = 5
	component_modifier_low = 0.1
	component_modifier_high = 0.25
	ammo_name = "armour-piercing"

/obj/item/shipweapons/torpedo_warhead/ap/do_explosion()
	explosion(get_turf(src), 4, EX_ACT_HEAVY, 1)

/obj/item/shipweapons/torpedo_warhead/he
	name = "high-explosive torpedo warhead"
	desc = "It's a big high-explosive warhead for a big torpedo. Shove it in a torpedo casing and you've got yourself a torpedo." //torpedo
	icon_state = "hetorpedowarhead"
	hull_damage = 390 //24.375 dps
	shield_damage = 100
	component_hit = 60
	component_modifier_low = 0.25
	component_modifier_high = 0.65
	ammo_name = "high-explosive"

/obj/item/shipweapons/torpedo_warhead/he/do_explosion()
	explosion(get_turf(src), 9, EX_ACT_DEVASTATING, 1)

/obj/item/shipweapons/torpedo_warhead/emp
	name = "EMP torpedo warhead"
	desc = "It's a big armour-piercing warhead for a big torpedo. Shove it in a torpedo casing and you've got yourself a torpedo." //torpedo
	icon_state = "emptorpedowarhead"
	shield_damage = 500 //31.25 dps, slightly below a heavy ion cannon, this might need tweaking
	component_hit = 52
	ammo_name = "EMP"

/obj/item/shipweapons/torpedo_warhead/emp/do_explosion()
	empulse(get_turf(src), 1, 6)

//TORPEDO WARHEAD END//
//Torpedo IEDs begin
#undef CIRCUITRY_EXPOSED
#undef CIRCUITRY_MODIFIED
#undef CIRCUITRY_RIGGED
//Torpedo IEDs end
