var/global/remaininglactera = 40 //we'll tweak this in testing
var/global/gamemode_endstate = 0
var/global/remaininggens = 6

/datum/game_mode/assault
	name = "Assault"
	config_tag = "assault"
	round_description = "Nyx has been threatened by the ongoing Galactic Crisis, and a large lactera strike force stands ready to assault Urist McStation. As a member of the station, it's your job to defend the station's shield generator against the strike force until all lactera are defeated. For those who late-join, you will be lactera, whose goal is to destroy the shield generator, or wipe out all the station's crew. This is a team gamemode, work with your team to accomplish your goal."
	required_players = 1 //15
	var/humansurvivors = 0
	var/aliensurvivors = 0
	votable = 0 //WEW
	auto_recall_shuttle = 1
	var/maptype = 0 //0 = station, 1 = planet
	var/defencearea = "the station"

/datum/game_mode/assault/pre_setup()
	report_progress("Setting up Assault, this may take a minute or two.")
	if(maptype == 1)
		defencearea = "the planet"
	return 1

/datum/game_mode/assault/post_setup()

	respawntime = 100 //ten second respawn time, instant action

	for(var/obj/urist_intangible/trigger/template_loader/gamemode/assault/L in landmarks_list)
		if(maptype == L.maptype)
			L.Load()

	for(var/obj/machinery/computer/shuttle_control/S in SSmachines.machinery)
		if(S.shuttle_tag == "Mining" || S.shuttle_tag == "Engineering" || S.shuttle_tag == "Research" || S.shuttle_tag == "Security" || S.shuttle_tag == "Planet")
			new /obj/machinery/computer(S.loc)
			qdel(S)

	for(var/obj/structure/reagent_dispensers/fueltank/S in world) //what we've done here is remove the consoles that can get people off the station. All of assault takes place on the station.
		qdel(S)

	for(var/mob/living/carbon/human/M in GLOB.living_players)
		if(prob(16))
	//		if(M.Species == "Human")

			for (var/obj/item/I in M)
				if (istype(I, /obj/item/implant) || istype(I, /obj/item/organ) || istype(I, /obj/item/clothing/glasses))
					continue

				else
					qdel(I)

			M.equip_to_slot_or_del(new /obj/item/device/radio/headset/heads/captain(M), slot_l_ear)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/urist/anfor(M), slot_w_uniform)
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/urist/armor/anfor/marine(M), slot_wear_suit)
			M.equip_to_slot_or_del(new /obj/item/clothing/gloves/thick/swat(M), slot_gloves)
			M.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/urist/anfor(M), slot_head)

			M.equip_to_slot_or_del(new /obj/item/storage/backpack/security(M), slot_back)
			M.equip_to_slot_or_del(new /obj/item/storage/box/survival(M), slot_in_backpack)

			M.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/a7(M), slot_in_backpack)
			M.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular(M), slot_in_backpack)
			M.equip_to_slot_or_del(new /obj/item/device/flashlight(M), slot_in_backpack)
			M.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/a22(M), slot_in_backpack)
			M.equip_to_slot_or_del(new /obj/item/device/radio(M), slot_in_backpack)
			M.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/a22(M), slot_in_backpack)
			M.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/a22(M), slot_l_store)
			M.equip_to_slot_or_del(new /obj/item/material/knife/combat(M), slot_r_store)
			M.equip_to_slot_or_del(new /obj/item/gun/projectile/colt/a7(M), slot_s_store)

			M.equip_to_slot_or_del(new /obj/item/gun/projectile/automatic/a22(M), slot_r_hand)

			var/obj/item/card/id/W = new(M)
			W.name = "[M.real_name]'s ID Card"
			W.icon_state = "centcom"
			W.access = get_all_accesses()
			W.access += access_cent_general
			W.assignment = "ANFOR Marine"
			W.registered_name = M.real_name
			M.equip_to_slot_or_del(W, slot_wear_id)

			for(var/obj/landmark/assault/marinespawn/H in landmarks_list)
				M.loc = H.loc
//				qdel(H)

			to_chat(M, "<span class='warning'>You are an ANFOR (Allied Naval Forces) marine, part of a joint Nanotrasen/Terran Confederacy task force sent here to defend the station at all costs. It is your job to rally the remaining crewmembers and to stave off the impending attack. Good luck soldier.</span>")

	//		else
	//			return
	spawn(300)
		command_announcement.Announce("ATTENTION URIST MCSTATION: As you are well aware, large alien forces are en route. They've broken through ANFOR defences, and while they are weakened, they still pose a severe threat to Nyx. Thus, [defencearea] is the last chance to head off this attack so reinforcements can get here. It's up to you and your complement of marines to stop them. Good luck, don't let them destroy your shield generators in the centre of your station.", "ANFOR Nyx Command")
		spawn(600)
			command_announcement.Announce("ATTENTION URIST MCSTATION: Looks like the alien forces are about four minutes out. Get ready, and good luck.", "ANFOR Nyx Command")
			sleep(rand(2000,2400))
			command_announcement.Announce("ATTENTION URIST MCSTATION: We're detecting multiple ships pulling into orbit of [defencearea]. Looks like they're here. We'll do our best to take out as many as we can, but expect hostile contacts imminently.", "ANFOR Nyx Command")
			for(var/obj/machinery/computer/shuttle_control/assault/A in SSmachines.machinery)
				A.readytogo = 1 //it's go time bois

/datum/game_mode/assault/process()
	//Reset the survivor count to zero per process call.
	humansurvivors = 0
	aliensurvivors = 0

	//For each survivor, add one to the count. Should work accurately enough.
	for(var/mob/living/carbon/human/H in GLOB.living_players)
		if(H) //Prevent any runtime errors
			if(H.client && H.stat != DEAD && H.z == 1) // If they're connected/unghosted and alive, not debrained and on the station z
				if(H.species == "Xenomorph")
					aliensurvivors += 1
				else
					humansurvivors += 1 //Add them to the amount of people who're alive.

	if(remaininglactera == 0 && gamemode_endstate == 0)
		command_announcement.Announce("ATTENTION URIST MCSTATION: Our sensors have detected that they have run out of reinforcements. Good job, once you've mopped up the few remaining lactera, you can count this as a victory for humanity.", "ANFOR Nyx Command")
		remaininglactera = 0
		gamemode_endstate = 5 //we've won, but we haven't exactly won yet as long as those lizard fucks remain alive.
		config.enter_allowed = 0

	if(humansurvivors == 0)
		gamemode_endstate = 1

	if(aliensurvivors == 0 && remaininglactera == 0)
		gamemode_endstate = 2

	if(remaininggens == 0)
		gamemode_endstate = 3

	if(station_was_nuked)
		gamemode_endstate = 4

	if(gamemode_endstate && !sploded) //reusing vars because why not
		declare_completion()

/datum/game_mode/assault/declare_completion()
	if(sploded == 0)
		if(gamemode_endstate == 1)
			to_world(FONT_LARGE("<B>Alien major victory!</B>"))
			to_world("<B>The aliens have successfully wiped out the station crew and will make short work of the rest of Nyx!</B>")
		else if(gamemode_endstate == 2)
			to_world(FONT_LARGE("<B>Station major victory!</B>"))
			to_world("The station has managed to kill all of the invading lactera strike force, giving ANFOR a secure location in Nyx to defend against the alien threat.")
		else if(gamemode_endstate == 3)
			to_world(FONT_LARGE("<B>Alien major victory.</B>"))
			to_world("The station's shield generators have been destroyed! The alien battlecruisers will make short work of the station now.")
		else if(gamemode_endstate == 4)
			to_world(FONT_LARGE("<B>Draw.</B>"))
			to_world("The station has blown by a nuclear fission device... there are no winners!")
	sploded = 1

	..()
	return

/obj/landmark/assault/marinespawn
	name = "marinespawn"
	invisibility = 101

/obj/landmark/assault/lacteraspawn
	name = "lacteraspawn"
	invisibility = 101


/*/mob/new_player/proc/AssaultRobotLateJoin(mob/living/silicon/L)
	if(L.mind.assigned_role == "Cyborg")
		L.loc = pick(scomspawn3)
		for(var/obj/item/cell/cell in L)
			cell.maxcharge = INFINITY
			cell.charge = INFINITY*/

/mob/new_player/proc/AssaultLateJoin(mob/living/L)
	if(remaininglactera <= 0)
		for(var/obj/landmark/assault/lacteraspawn/S in landmarks_list)
			var/mob/observer/H = new /mob/observer(S.loc)
			H.ckey = L.ckey

	else
		for(var/obj/landmark/assault/lacteraspawn/S in landmarks_list)
	//		L.loc = S.loc
			var/mob/living/carbon/human/lactera/H = new /mob/living/carbon/human/lactera(S.loc)
			H.ckey = L.ckey
			if(remaininglactera == 40 || remaininglactera == 20)
				H.equip_to_slot_or_del(new /obj/item/clothing/under/lactera(H), slot_w_uniform)
				H.equip_to_slot_or_del(new /obj/item/clothing/suit/lactera/officer(H), slot_wear_suit)
				H.equip_to_slot_or_del(new /obj/item/clothing/shoes/magboots/lactera(H), slot_shoes)
				H.equip_to_slot_or_del(new /obj/item/gun/energy/lactera/a1(H), slot_belt)
				H.equip_to_slot_or_del(new /obj/item/plastique/alienexplosive(H), slot_l_store)
				H.equip_to_slot_or_del(new /obj/item/grenade/aliengrenade(H), slot_r_store)
				H.equip_to_slot_or_del(new /obj/item/gun/energy/lactera/a3(H), slot_r_hand)
				H.equip_to_slot_or_del(new /obj/item/clothing/glasses/night(H), slot_glasses)

				to_chat(H, "<B>You are a lactera officer. Born in a laboratory and raised for the sole purpose of killing, you are a creature genetically modified to be an ideal soldier. You do not feel pain, you do not need to breathe and your feet are implanted with a magnetic traction system. You are a slave to your hivemind, and must lead your fellow lactera to destroy the humans and their shield generator.</B>")

			else
				H.equip_to_slot_or_del(new /obj/item/clothing/under/lactera(H), slot_w_uniform)
				H.equip_to_slot_or_del(new /obj/item/clothing/suit/lactera/regular(H), slot_wear_suit)
				H.equip_to_slot_or_del(new /obj/item/clothing/shoes/magboots/lactera(H), slot_shoes)
				H.equip_to_slot_or_del(new /obj/item/gun/energy/lactera/a1(H), slot_belt)
				H.equip_to_slot_or_del(new /obj/item/plastique/alienexplosive(H), slot_l_store)
				H.equip_to_slot_or_del(new /obj/item/grenade/aliengrenade(H), slot_r_store)
				H.equip_to_slot_or_del(new /obj/item/gun/energy/lactera/a2(H), slot_r_hand)
				H.equip_to_slot_or_del(new /obj/item/clothing/glasses/night(H), slot_glasses)

				to_chat(H, "<B>You are a lactera soldier. Born in a laboratory and raised for the sole purpose of killing, you are a creature genetically modified to be an ideal soldier. You do not feel pain, you do not need to breathe and your feet are implanted with a magnetic traction system. You are a slave to your hivemind, and must work with your fellow lactera to destroy the humans and their shield generator.</B>")

			remaininglactera -= 1

			if(remaininglactera == 20)
				command_announcement.Announce("ATTENTION URIST MCSTATION: Looks like the alien forces are about half depleted. Good job!.", "ANFOR Nyx Command")

			qdel(L)

/client/proc/remaininglacterachange(rl as num)
	set category = "Fun"
	set name = "Change Remaining Lactera"

	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG|R_FUN))
		return

	remaininglactera = rl

	message_admins("[key_name_admin(usr)] changed the remaining lactera to [rl].")
