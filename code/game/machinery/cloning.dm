//Cloning revival method.
//The pod handles the actual cloning while the computer manages the clone profiles

//Potential replacement for genetics revives or something I dunno (?)

#define CLONE_BIOMASS 150

/obj/item/stock_parts/circuitboard/clonepod
	name = T_BOARD("cloning pod")
	build_path = /obj/machinery/clonepod
	board_type = "machine"
	origin_tech = list(TECH_ENGINEERING = 2, TECH_BIO = 4, TECH_DATA = 4)
	req_components = list (
		/obj/item/stock_parts/scanning_module = 2,
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/console_screen = 1
	)

/obj/machinery/clonepod
	name = "cloning pod"
	desc = "An electronically-lockable pod for growing organic tissue."
	density = TRUE
	anchored = TRUE
	icon = 'icons/obj/machines/medical/cloning.dmi'
	icon_state = "pod_0"
	req_access = list(access_medical) //For premature unlocking.
	construct_state = /singleton/machine_construction/default/panel_closed
	var/mob/living/occupant
	var/heal_level = 20 // The clone is released once its health reaches this percentage.
	var/heal_rate = 1
	var/locked = FALSE
	var/obj/machinery/computer/cloning/connected = null //So we remember the connected clone machine.
	var/mess = FALSE //Need to clean out it if it's full of exploded clone.
	var/attempting = FALSE //One clone attempt at a time thanks
	var/eject_wait = FALSE //Don't eject them as soon as they are created fuckkk
	var/biomass = CLONE_BIOMASS * 3

/obj/machinery/clonepod/New()
	set_extension(src, /datum/extension/interactive/multitool, /datum/extension/interactive/multitool/store)
	..()

	update_icon()

/obj/machinery/clonepod/RefreshParts()
	..()
	var/rating = 0
	for(var/obj/item/stock_parts/P in component_parts)
		if(istype(P, /obj/item/stock_parts/scanning_module) || istype(P, /obj/item/stock_parts/manipulator))
			rating += P.rating

	heal_level = rating * 10 - 20
	heal_rate = round(rating / 4)

/obj/machinery/clonepod/Destroy()
	if(connected)
		connected.release_pod(src)
	return ..()

/obj/machinery/clonepod/attack_ai(mob/user as mob)
	if(!ai_can_interact(user))
		return
	add_hiddenprint(user)
	return attack_hand(user)

/obj/machinery/clonepod/attack_hand(mob/user)
	if((stat & MACHINE_STAT_NOPOWER) || !occupant || occupant.stat == DEAD)
		return
	to_chat(user, "Current clone cycle is [round(GetCloneReadiness())]% complete.")

//Clonepod

//Start growing a human clone in the pod!
/obj/machinery/clonepod/proc/growclone(datum/dna2/record/R)
	if(mess || attempting)
		return FALSE
	var/datum/mind/clonemind

	if(!config.use_cortical_stacks)
		clonemind = locate(R.mind)
		if(!istype(clonemind, /datum/mind))	//not a mind
			return FALSE
	else
		for(var/mob/observer/ghost/G in GLOB.player_list)
			if(G.ckey == R.ckey)
				if(G.can_reenter_corpse)
					break
				else
					return FALSE

	attempting = TRUE //One at a time!!
	locked = TRUE

	eject_wait = TRUE
	spawn(30 SECONDS)
		eject_wait = FALSE

	var/mob/living/carbon/human/H = new /mob/living/carbon/human(src, R.dna.species)
	occupant = H

	if(!R.dna.real_name /*|| config.use_cortical_stacks*/)	//to prevent null names
		R.dna.real_name = "clone ([rand(0,999)])"
	H.real_name = R.dna.real_name

	//Get the clone body ready
	H.adjustCloneLoss(H.maxHealth/2) // We want to put them exactly at the crit level, so we deal this much clone damage
	H.Paralyse(4)

	//Here let's calculate their health so the pod doesn't immediately eject them!!!
	H.updatehealth()

	if(clonemind)
		clonemind.transfer_to(H)
		if(R.ckey)
			H.ckey = R.ckey
			to_chat(H, "<span class='notice'><b>Consciousness slowly creeps over you as your body regenerates.</b><br><i>So this is what cloning feels like?</i></span>")

	// -- Mode/mind specific stuff goes here
	callHook("clone", list(H))
	update_antag_icons(H.mind)
	// -- End mode specific stuff

	if(!R.dna)
		H.dna = new /datum/dna()
		H.dna.real_name = H.real_name
	else
		H.dna = R.dna
	H.UpdateAppearance()
	H.sync_organ_dna()
	if(heal_level < 60)
		randmutb(H) //Sometimes the clones come out wrong.
		H.dna.UpdateSE()
		H.dna.UpdateUI()

	H.set_cloned_appearance()
	update_icon()

	for(var/datum/language/L in R.languages)
		H.add_language(L.name)
	H.flavor_texts = R.flavor.Copy()
	attempting = FALSE
	return TRUE

/obj/machinery/clonepod/proc/GetCloneReadiness() // Returns a number between 0 and 100
	if(!occupant)
		return

	if(occupant.getCloneLoss() == 0) // Rare case, but theoretically possible
		return 100

	return clamp(100, 0 * ((occupant.maxHealth/2 - occupant.getCloneLoss()) / (heal_level / (occupant.maxHealth/2 / 100))), 100)

//Grow clones to maturity then kick them out.  FREELOADERS
/obj/machinery/clonepod/Process()

	if(stat & MACHINE_STAT_NOPOWER) //Autoeject if power is lost
		if(occupant)
			locked = FALSE
			go_out()
		return

	if((occupant) && (occupant.loc == src))
		if((occupant.stat == DEAD))  //Autoeject corpses
			locked = FALSE
			go_out()
			connected_message("Clone Rejected: Deceased.")
			return

		if(GetCloneReadiness() >= 100 && !eject_wait)
			playsound(src.loc, 'sound/machines/ding.ogg', 50, 1)
			src.audible_message("\The [src] signals that the cloning process is complete.")
			connected_message("Cloning Process Complete.")
			locked = FALSE
			go_out()
			return

		occupant.Paralyse(4)

		//Slowly get that clone healed and finished.
		occupant.adjustCloneLoss(-2 * heal_rate)

		//Premature clones may have brain damage.
		occupant.adjustBrainLoss(-(ceil(0.5*heal_rate)))

		//So clones don't die of oxyloss in a running pod.
		if(occupant.reagents.get_reagent_amount(/datum/reagent/inaprovaline) < 30)
			occupant.reagents.add_reagent(/datum/reagent/inaprovaline, 60)
		occupant.Sleeping(30)
		//Also heal some oxyloss ourselves because inaprovaline is so bad at preventing it!!
		occupant.adjustOxyLoss(-4)

		use_power_oneoff(7500, EQUIP) //This might need tweaking.
		return

	else if((!occupant) || (occupant.loc != src))
		occupant = null
		if(locked)
			locked = FALSE
		return

	return

/obj/machinery/clonepod/components_are_accessible(path)
	return isnull(occupant) && ..()

/obj/machinery/clonepod/cannot_transition_to(state_path)
	if(occupant)
		return SPAN_NOTICE("\The [src] is currently occupied.")

//Let's unlock this early I guess.  Might be too early, needs tweaking.
/obj/machinery/clonepod/use_tool(obj/item/W as obj, mob/user as mob)
	var/id = W.GetIdCard()
	if(id)
		if(!check_access(id))
			to_chat(user, SPAN_NOTICE("Access Denied."))
			return
		if((!locked) || (isnull(occupant)))
			return
		if((occupant.health < -20) && (occupant.stat != 2))
			to_chat(user, SPAN_WARNING("Access Refused."))
			return
		else
			locked = FALSE
			to_chat(user, "System unlocked.")
	else if(istype(W, /obj/item/reagent_containers/food/snacks/meat))
		to_chat(user, SPAN_NOTICE("\The [src] processes \the [W]."))
		biomass += 50
		user.drop_item()
		qdel(W)
		return
	else if(istype(W, /obj/item/wrench))
		if(locked && (anchored || occupant))
			to_chat(user, SPAN_WARNING("Can not do that while [src] is in use."))
		else
			if(anchored)
				anchored = FALSE
				connected.pods -= src
				connected = null
			else
				anchored = TRUE
			playsound(loc, 'sound/items/Ratchet.ogg', 100, 1)
			if(anchored)
				user.visible_message("[user] secures [src] to the floor.", "You secure [src] to the floor.")
			else
				user.visible_message("[user] unsecures [src] from the floor.", "You unsecure [src] from the floor.")
	else
		..()

/obj/machinery/clonepod/emag_act(remaining_charges, var/mob/user)
	if(isnull(occupant))
		return NO_EMAG_ACT
	to_chat(user, "You force an emergency ejection.")
	locked = FALSE
	go_out()
	return TRUE

//Put messages in the connected computer's temp var for display.
/obj/machinery/clonepod/proc/connected_message(message)
	if((isnull(connected)) || (!istype(connected, /obj/machinery/computer/cloning)))
		return FALSE
	if(!message)
		return FALSE

	connected.temp = "[name] : [message]"
	connected.updateUsrDialog()
	return TRUE

/obj/machinery/clonepod/verb/eject()
	set name = "Eject Cloner"
	set category = "Object"
	set src in oview(1)

	if(usr.stat != 0)
		return
	go_out()
	add_fingerprint(usr)
	return

/obj/machinery/clonepod/proc/go_out()
	if(locked)
		return

	if(mess) //Clean that mess and dump those gibs!
		mess = FALSE
		gibs(loc)
		update_icon()
		return

	if(!(occupant))
		return

	if(occupant.client)
		occupant.client.eye = occupant.client.mob
		occupant.client.perspective = MOB_PERSPECTIVE
	occupant.forceMove(loc)
	eject_wait = FALSE //If it's still set somehow.
	domutcheck(occupant) //Waiting until they're out before possible transforming.
	occupant = null

	biomass -= CLONE_BIOMASS
	update_icon()
	return

/obj/machinery/clonepod/proc/malfunction()
	if(occupant)
		connected_message("Critical Error!")
		mess = TRUE
		update_icon()
		occupant.ghostize()
		spawn(5)
			qdel(occupant)
	return

/obj/machinery/clonepod/relaymove(mob/user as mob)
	if(user.stat)
		return
	go_out()
	return

/obj/machinery/clonepod/emp_act(severity)
	if(prob(100/severity))
		malfunction()
	..()

/obj/machinery/clonepod/ex_act(severity)
	switch(severity)
		if(1.0)
			for(var/atom/movable/A as mob|obj in src)
				A.dropInto(loc)
				ex_act(severity)
			qdel(src)
			return
		if(2.0)
			if(prob(50))
				for(var/atom/movable/A as mob|obj in src)
					A.dropInto(loc)
					ex_act(severity)
				qdel(src)
				return
		if(3.0)
			if(prob(25))
				for(var/atom/movable/A as mob|obj in src)
					A.dropInto(loc)
					ex_act(severity)
				qdel(src)
				return
		else
	return

/obj/machinery/clonepod/on_update_icon()
	..()
	icon_state = "pod_0"
	if (occupant && !(stat & MACHINE_STAT_NOPOWER))
		icon_state = "pod_1"
	else if (mess)
		icon_state = "pod_g"

//Health Tracker Implant

/obj/item/implant/health
	name = "health implant"
	var/healthstring = ""

/obj/item/implant/health/proc/sensehealth()
	if(!implanted)
		return "ERROR"
	else
		if(isliving(implanted))
			var/mob/living/L = implanted
			healthstring = "[round(L.getOxyLoss())] - [round(L.getFireLoss())] - [round(L.getToxLoss())] - [round(L.getBruteLoss())]"
		if(!healthstring)
			healthstring = "ERROR"
		return healthstring

//Disk stuff.
//The return of data disks?? Just for transferring between genetics machine/cloning machine.
//TO-DO: Make the genetics machine accept them.
/obj/item/disk/data
	name = "Cloning Data Disk"
	icon = 'icons/obj/datadisks.dmi'
	icon_state = "datadisk0" //Gosh I hope syndies don't mistake them for the nuke disk.
	item_state = "card-id"
	w_class = ITEM_SIZE_SMALL
	var/datum/dna2/record/buf = null
	var/read_only = FALSE //Well,it's still a floppy disk

/obj/item/disk/data/proc/initializeDisk()
	buf = new
	buf.dna=new

/obj/item/disk/data/demo
	name = "data disk - 'God Emperor of Mankind'"
	read_only = TRUE

/obj/item/disk/data/demo/New()
	..()
	initializeDisk()
	buf.types=DNA2_BUF_UE|DNA2_BUF_UI
	//data = "066000033000000000AF00330660FF4DB002690"
	//data = "0C80C80C80C80C80C8000000000000161FBDDEF" - Farmer Jeff
	buf.dna.real_name="God Emperor of Mankind"
	buf.dna.unique_enzymes = md5(buf.dna.real_name)
	buf.dna.UI=list(0x066,0x000,0x033,0x000,0x000,0x000,0xAF0,0x033,0x066,0x0FF,0x4DB,0x002,0x690)
	//buf.dna.UI=list(0x0C8,0x0C8,0x0C8,0x0C8,0x0C8,0x0C8,0x000,0x000,0x000,0x000,0x161,0xFBD,0xDEF) // Farmer Jeff
	buf.dna.UpdateUI()

/obj/item/disk/data/monkey
	name = "data disk - 'Mr. Muggles'"
	read_only = TRUE

/obj/item/disk/data/monkey/New()
	..()
	initializeDisk()
	buf.types=DNA2_BUF_SE
	var/list/new_SE=list(0x098,0x3E8,0x403,0x44C,0x39F,0x4B0,0x59D,0x514,0x5FC,0x578,0x5DC,0x640,0x6A4)
	for(var/i=length(new_SE);i<=DNA_SE_LENGTH;i++)
		new_SE += rand(1,1024)
	buf.dna.SE=new_SE
	buf.dna.SetSEValueRange(GLOB.MONKEYBLOCK,0xDAC, 0xFFF)

/obj/item/disk/data/New()
	..()
	var/diskcolor = pick(0,1,2)
	icon_state = "datadisk[diskcolor]"

/obj/item/disk/data/attack_self(mob/user as mob)
	read_only = !read_only
	to_chat(user, "You flip the write-protect tab to [read_only ? "protected" : "unprotected"].")

/obj/item/disk/data/examine(mob/user)
	. = ..(user)
	to_chat(user, text("The write-protect tab is set to [read_only ? "protected" : "unprotected"]."))
	return

/*
 *	Diskette Box
 */

/obj/item/storage/box/disks
	name = "Diskette Box"
	icon_state = "disk_kit"

/obj/item/storage/box/disks/New()
	..()
	new /obj/item/disk/data(src)
	new /obj/item/disk/data(src)
	new /obj/item/disk/data(src)
	new /obj/item/disk/data(src)
	new /obj/item/disk/data(src)
	new /obj/item/disk/data(src)
	new /obj/item/disk/data(src)

/*
 *	Manual -- A big ol' manual.
 */

/* /obj/item/paper/Cloning
	name = "H-87 Cloning Apparatus Manual"
	info = {"<h4>Getting Started</h4>
	Congratulations, your station has purchased the H-87 industrial cloning device!<br>
	Using the H-87 is almost as simple as brain surgery! Simply insert the target humanoid into the scanning chamber and select the scan option to create a new profile!<br>
	<b>That's all there is to it!</b><br>
	<i>Notice, cloning system cannot scan inorganic life or small primates.  Scan may fail if subject has suffered extreme brain damage.</i><br>
	<p>Clone profiles may be viewed through the profiles menu. Scanning implants a complementary HEALTH MONITOR IMPLANT into the subject, which may be viewed from each profile.
	Profile Deletion has been restricted to \[Head\] level access.</p>
	<h4>Cloning from a profile</h4>
	Cloning is as simple as pressing the CLONE option at the bottom of the desired profile.<br>
	Per your company's EMPLOYEE PRIVACY RIGHTS agreement, the H-87 has been blocked from cloning crewmembers while they are still alive.<br>
	<br>
	<p>The provided CLONEPOD SYSTEM will produce the desired clone.  Standard clone maturation times (With SPEEDCLONE technology) are roughly 90 seconds.
	The cloning pod may be unlocked early with any \[Medical Researcher\] ID after initial maturation is complete.</p><br>
	<i>Please note that resulting clones may have a small DEVELOPMENTAL DEFECT as a result of genetic drift.</i><br>
	<h4>Profile Management</h4>
	<p>The H-87 (as well as your station's standard genetics machine) can accept STANDARD DATA DISKETTES.
	These diskettes are used to transfer genetic information between machines and profiles.
	A load/save dialog will become available in each profile if a disk is inserted.</p><br>
	<i>A good diskette is a great way to counter aforementioned genetic drift!</i><br>
	<br>
	<font size=1>This technology produced under license from Thinktronic Systems, LTD.</font>"} */ //Hasn't been right ever since laces were added. -Vak

//SOME SCRAPS I GUESS
/* EMP grenade/spell effect
		if(istype(A, /obj/machinery/clonepod))
			A:malfunction()
*/

//Used for new human mobs created by cloning/goleming/etc.
/mob/living/carbon/human/proc/set_cloned_appearance()
	facial_hair_style = "Shaved"
	if(dna.species == SPECIES_HUMAN) //no more xenos losing ears/tentacles
		head_hair_style = pick("Bedhead", "Bedhead 2", "Bedhead 3")
	QDEL_NULL_LIST(worn_underwear)
	worn_underwear = list()
	regenerate_icons()
