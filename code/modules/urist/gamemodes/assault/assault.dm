var/global/remaininglactera = 40 //we'll tweak this in testing
var/global/gamemode_endstate = 0
var/global/remaininggens = 6

/datum/game_mode/assault
	name = "assault"
	config_tag = "assault"
	required_players = 1 //15
	var/humansurvivors = 0
	var/aliensurvivors = 0
	votable = 0 //WEW
	auto_recall_shuttle = 1

/datum/game_mode/assault/announce()
	world << "<B>The current game mode is - Assault!</B>"
	world << "<B>Nyx has been threatened by the ongoing Galactic Crisis, and a large lactera strike force stands ready to assault Urist McStation. As a member of the station, it's your job to defend the station's shield generator against the strike force until all lactera are defeated. For those who late-join, you will be lactera, whose goal is to destroy the shield generator, or wipe out all the station's crew. This is a team gamemode, work with your team to accomplish your goal.</B>"


/datum/game_mode/assault/pre_setup()
	world << "<span class='warning'> Setting up Assault, this may take a minute or two.</span>"

	return 1

/datum/game_mode/assault/post_setup()

	respawntime = 100 //ten second respawn time, instant action

	for(var/obj/effect/template_loader/gamemode/L in world) //disabling this for now because fuck dealing with the runtimes. i'll just manually spawnt hem for the test
		L.Load()

	for(var/obj/machinery/computer/shuttle_control/S in machines)
		if(S.shuttle_tag == "Mining" || S.shuttle_tag == "Engineering" || S.shuttle_tag == "Research" || S.shuttle_tag == "Security")
			new /obj/structure/computerframe(S.loc)
			qdel(S)

	for(var/obj/machinery/computer/supply/S in machines)
		new /obj/structure/computerframe(S.loc)
		qdel(S)

	for(var/obj/structure/reagent_dispensers/fueltank/S in world) //what we've done here is remove the consoles that can get people off the station. All of assault takes place on the station.
		qdel(S)

	for(var/mob/living/carbon/human/M in living_mob_list_)
		if(prob(16))
	//		if(M.Species == "Human")

			for (var/obj/item/I in M)
				if (istype(I, /obj/item/weapon/implant) || istype(I, /obj/item/organ) || istype(I, /obj/item/clothing/glasses))
					continue

				else
					qdel(I)

			M.equip_to_slot_or_del(new /obj/item/device/radio/headset/heads/captain(M), slot_l_ear)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/urist/anfor(M), slot_w_uniform)
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/clothing/suit/urist/armor/anfor/marine(M), slot_wear_suit)
			M.equip_to_slot_or_del(new /obj/item/clothing/gloves/thick/swat(M), slot_gloves)
			M.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/urist/anfor(M), slot_head)

			M.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/security(M), slot_back)
			M.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(M), slot_in_backpack)

			M.equip_to_slot_or_del(new /obj/item/ammo_magazine/c45m/a7(M), slot_in_backpack)
			M.equip_to_slot_or_del(new /obj/item/weapon/storage/firstaid/regular(M), slot_in_backpack)
			M.equip_to_slot_or_del(new /obj/item/device/flashlight(M), slot_in_backpack)
			M.equip_to_slot_or_del(new /obj/item/ammo_magazine/a556/a22(M), slot_in_backpack)
			M.equip_to_slot_or_del(new /obj/item/device/radio(M), slot_in_backpack)
			M.equip_to_slot_or_del(new /obj/item/ammo_magazine/a556/a22(M), slot_in_backpack)
			M.equip_to_slot_or_del(new /obj/item/ammo_magazine/a556/a22(M), slot_l_store)
			M.equip_to_slot_or_del(new /obj/item/weapon/material/hatchet/tacknife(M), slot_r_store)
			M.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/colt/a7(M), slot_s_store)

			M.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/a22(M), slot_r_hand)

			var/obj/item/weapon/card/id/W = new(M)
			W.name = "[M.real_name]'s ID Card"
			W.icon_state = "centcom"
			W.access = get_all_accesses()
			W.access += access_cent_general
			W.assignment = "ANFOR Marine"
			W.registered_name = M.real_name
			M.equip_to_slot_or_del(W, slot_wear_id)

			for(var/obj/effect/landmark/assault/marinespawn/H in world)
				M.loc = H.loc
//				qdel(H)

			M << "<span class='warning'>You are an ANFOR (Allied Naval Forces) marine, part of a joint Nanotrasen/Terran Confederacy task force sent here to defend the station at all costs. It is your job to rally the remaining crewmembers and to stave off the impending attack. Good luck soldier.</span>"

	//		else
	//			return
	spawn(300)
		command_announcement.Announce("ATTENTION URIST MCSTATION: As you are well aware, large alien forces are en route. They've broken through ANFOR defences, and while they are weakened, they still pose a severe threat to Nyx. Your station is the last chance to head off this attack so reinforcements can get here. It's up to you and your complement of marines to stop them. Good luck, don't let them destroy your shield generators in the centre of your station.", "ANFOR Nyx Command")
		spawn(600)
			command_announcement.Announce("ATTENTION URIST MCSTATION: Looks like the alien forces are about four minutes out. Get ready, and good luck.", "ANFOR Nyx Command")
			sleep(rand(2000,2400))
			command_announcement.Announce("ATTENTION URIST MCSTATION: We're detecting multiple ships pulling into orbit of your station. Looks like they're here. We'll do our best to take out as many as we can, but expect hostile contacts imminently.", "ANFOR Nyx Command")
			for(var/obj/machinery/computer/shuttle_control/assault/A in machines)
				A.readytogo = 1 //it's go time bois

/datum/game_mode/assault/process()
	//Reset the survivor count to zero per process call.
	humansurvivors = 0
	aliensurvivors = 0

	//For each survivor, add one to the count. Should work accurately enough.
	for(var/mob/living/carbon/human/H in living_mob_list_)
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
			feedback_set_details("round_end_result","alien major victory - station crew eliminated")
			world << "<span class='danger'> <FONT size = 4>Alien major victory!</font></span>"
			world << "<span class='danger'> <FONT size = 3>The aliens have successfully wiped out the station crew and will make short work of the rest of Nyx!</font></span>"
		else if(gamemode_endstate == 2)
			feedback_set_details("round_end_result","station major victory - lactera strike force eradicated")
			world << "<span class='danger'> <FONT size = 4>Station major victory!</FONT></span>"
			world << "<span class='danger'> <FONT size = 3>The station has managed to kill all of the invading lactera strike force, giving ANFOR a secure location in Nyx to defend against the alien threat.</FONT></span>"
		else if(gamemode_endstate == 3)
			feedback_set_details("round_end_result","alien major victory - the station shield generators have been destroyed.")
			world << "<span class='danger'> <FONT size = 3>Alien major victory.</FONT></span>"
			world << "<span class='danger'> <FONT size = 3>The station's shield generators have been destroyed! The alien battlecruisers will make short work of the station now.</FONT></span>"
		else if(gamemode_endstate == 4)
			feedback_set_details("round_end_result","draw - the station has been nuked")
			world << "<span class='danger'> <FONT size = 3>Draw.</FONT></span>"
			world << "<span class='danger'> <FONT size = 3>The station has blown by a nuclear fission device... there are no winners!</FONT></span>"

	..()

	sploded = 1

	spawn(5)
		world << "<span class='notice'> Rebooting in fourty five seconds.</span>"

		spawn(450)
			if(!ticker.delay_end)
				world.Reboot()
			else
				world << "<span class='notice'> <B>An admin has delayed the round end</B></span>"

	return 1

/obj/effect/landmark/assault/marinespawn
	name = "marinespawn"
	invisibility = 101

/obj/effect/landmark/assault/lacteraspawn
	name = "lacteraspawn"
	invisibility = 101


/*/mob/new_player/proc/AssaultRobotLateJoin(var/mob/living/silicon/L)
	if(L.mind.assigned_role == "Cyborg")
		L.loc = pick(scomspawn3)
		for(var/obj/item/weapon/cell/cell in L)
			cell.maxcharge = INFINITY
			cell.charge = INFINITY*/

/mob/new_player/proc/AssaultLateJoin(var/mob/living/L)
	if(remaininglactera <= 0)
		for(var/obj/effect/landmark/assault/lacteraspawn/S in world)
			var/mob/observer/H = new /mob/observer(S.loc)
			H.ckey = L.ckey

	else
		for(var/obj/effect/landmark/assault/lacteraspawn/S in world)
	//		L.loc = S.loc
			var/mob/living/carbon/human/lactera/H = new /mob/living/carbon/human/lactera(S.loc)
			H.ckey = L.ckey
			if(remaininglactera == 40 || remaininglactera == 20)
				H.equip_to_slot_or_del(new /obj/item/clothing/under/lactera(H), slot_w_uniform)
				H.equip_to_slot_or_del(new /obj/item/clothing/suit/lactera/officer(H), slot_wear_suit)
				H.equip_to_slot_or_del(new /obj/item/clothing/shoes/magboots/lactera(H), slot_shoes)
				H.equip_to_slot_or_del(new /obj/item/weapon/gun/energy/lactera/a1(H), slot_belt)
				H.equip_to_slot_or_del(new /obj/item/weapon/plastique/alienexplosive(H), slot_l_store)
				H.equip_to_slot_or_del(new /obj/item/weapon/grenade/aliengrenade(H), slot_r_store)
				H.equip_to_slot_or_del(new /obj/item/weapon/gun/energy/lactera/a3(H), slot_r_hand)
				H.equip_to_slot_or_del(new /obj/item/clothing/glasses/night(H), slot_glasses)

				H << "<B>You are a lactera officer. Born in a laboratory and raised for the sole purpose of killing, you are a creature genetically modified to be an ideal soldier. You do not feel pain, you do not need to breathe and your feet are implanted with a magnetic traction system. You are a slave to your hivemind, and must lead your fellow lactera to destroy the humans and their shield generator.</B>"

			else
				H.equip_to_slot_or_del(new /obj/item/clothing/under/lactera(H), slot_w_uniform)
				H.equip_to_slot_or_del(new /obj/item/clothing/suit/lactera/regular(H), slot_wear_suit)
				H.equip_to_slot_or_del(new /obj/item/clothing/shoes/magboots/lactera(H), slot_shoes)
				H.equip_to_slot_or_del(new /obj/item/weapon/gun/energy/lactera/a1(H), slot_belt)
				H.equip_to_slot_or_del(new /obj/item/weapon/plastique/alienexplosive(H), slot_l_store)
				H.equip_to_slot_or_del(new /obj/item/weapon/grenade/aliengrenade(H), slot_r_store)
				H.equip_to_slot_or_del(new /obj/item/weapon/gun/energy/lactera/a2(H), slot_r_hand)
				H.equip_to_slot_or_del(new /obj/item/clothing/glasses/night(H), slot_glasses)

				H << "<B>You are a lactera soldier. Born in a laboratory and raised for the sole purpose of killing, you are a creature genetically modified to be an ideal soldier. You do not feel pain, you do not need to breathe and your feet are implanted with a magnetic traction system. You are a slave to your hivemind, and must work with your fellow lactera to destroy the humans and their shield generator.</B>"

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

