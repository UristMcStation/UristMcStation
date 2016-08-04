

/datum/map/glloydstation
	allowed_jobs = list(/datum/job/captain, /datum/job/hop, /datum/job/chef, /datum/job/qm, /datum/job/cargo_tech,
						/datum/job/janitor, /datum/job/lawyer,
						/datum/job/chief_engineer, /datum/job/engineer,
						/datum/job/ai, /datum/job/cyborg,
						/datum/job/hos, /datum/job/warden, /datum/job/detective, /datum/job/officer,
						/datum/job/cmo, /datum/job/doctor, /datum/job/chemist, /datum/job/chaplain,
						/datum/job/rd, /datum/job/scientist, /datum/job/mining, /datum/job/blueshield,
						/datum/job/mime, /datum/job/clown, /datum/job/xenobiologist
						)

//Resource Technician et al

/datum/job/mining
	title = "Resource Technician"
	department = "Cargo"
	department_flag = CIV
	faction = "Station"
	total_positions = 4
	spawn_positions = 4
	supervisors = "the quartermaster and the head of personnel"
	selection_color = "#515151"
	economic_modifier = 5
	access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_qm, access_mining, access_mining_station)
	minimal_access = list(access_mining, access_mining_station, access_mailsorting)
	alt_titles = list(
		"Shaft Miner" = /decl/hierarchy/outfit/job/cargo/mining,
		"Drill Technician" = /decl/hierarchy/outfit/job/cargo/mining,
		"Prospector" = /decl/hierarchy/outfit/job/cargo/mining,
		"Lumberjack" = /decl/hierarchy/outfit/job/cargo/mining/woodsman,
		//"Hunter" = /decl/hierarchy/outfit/job/cargo/mining/woodsman
		"Carpenter" = /decl/hierarchy/outfit/job/cargo/mining/woodsman)
	outfit_type = /decl/hierarchy/outfit/job/cargo/mining/tech

/decl/hierarchy/outfit/job/cargo/mining/woodsman
	name = OUTFIT_JOB_NAME("Carpenter")
	uniform = /obj/item/clothing/under/urist/rank/carpenter
	head = /obj/item/clothing/head/urist/toque

/decl/hierarchy/outfit/job/cargo/mining/tech
	name = OUTFIT_JOB_NAME("Resource Technician")
	uniform = /obj/item/clothing/under/overalls

//Mime

/decl/hierarchy/outfit/job/mime
	name = OUTFIT_JOB_NAME("Mime")
	uniform = /obj/item/clothing/under/mime
	head = /obj/item/clothing/head/beret
	mask = /obj/item/clothing/mask/gas/mime
	gloves = /obj/item/clothing/gloves/white
	shoes = /obj/item/clothing/shoes/black
	suit = /obj/item/clothing/suit/suspenders
	pda_type = /obj/item/device/pda/mime

/datum/job/mime
	title = "Mime"
	department = "Civilian"
	department_flag = CIV
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of personnel"
	selection_color = "#515151"
	economic_modifier = 1
	access = list(access_mime, access_theatre, access_maint_tunnels)
	minimal_access = list(access_mime, access_theatre)
	minimal_player_age = 10
	outfit_type = /decl/hierarchy/outfit/job/mime

/datum/job/mime/equip(var/mob/living/carbon/human/H)
	. = ..()
	if(.)
		H.miming = 1

//Clown :^)

/decl/hierarchy/outfit/job/clown
	name = OUTFIT_JOB_NAME("Clown")
	uniform = /obj/item/clothing/under/rank/clown
	mask = /obj/item/clothing/mask/gas/clown_hat
	shoes = /obj/item/clothing/shoes/clown_shoes
	backpack_contents = list(/obj/item/weapon/reagent_containers/food/snacks/grown/banana = 1, /obj/item/weapon/bikehorn = 1,
		/obj/item/weapon/stamp/clown = 1, /obj/item/weapon/pen/crayon/rainbow = 1, /obj/item/weapon/storage/fancy/crayons = 1,
		/obj/item/toy/waterflower = 1)
	back = /obj/item/weapon/storage/backpack/clown
	pda_type = /obj/item/device/pda/clown

/datum/job/clown
	title = "Clown"
	department = "Civilian"
	department_flag = CIV
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of personnel"
	selection_color = "#515151"
	economic_modifier = 1
	access = list(access_clown, access_theatre, access_maint_tunnels)
	minimal_access = list(access_clown, access_theatre)
	minimal_player_age = 10
	outfit_type = /decl/hierarchy/outfit/job/clown

///datum/job/clown/equip(var/mob/living/carbon/human/H)
//	. = ..()
//	if(.)
//		H.mutations.Add(CLUMSY)

/datum/job/blueshield
	title = "Blueshield"
	department_flag = SEC|COM
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "whichever head you protect. Remember, you are NOT security. Ultimately, you report to Nanotrasen, but if unavailable, defer to the Captain."
	selection_color = "#ddddff"
	req_admin_notify = 1
	minimal_player_age = 8
	economic_modifier = 15
	access = list(access_security, access_sec_doors, access_court, access_forensics_lockers,
			            access_medical, access_engine, access_ai_upload, access_eva, access_heads,
			            access_all_personal_lockers, access_maint_tunnels, access_bar, access_janitor, access_construction, access_morgue,
			            access_crematorium, access_kitchen, access_cargo, access_cargo_bot, access_mailsorting, access_qm, access_hydroponics, access_lawyer,
			            access_theatre, access_chapel_office, access_library, access_research, access_mining, access_heads_vault, access_mining_station,
			            access_clown, access_mime, access_RC_announce, access_keycard_auth, access_gateway, access_blueshield)
	minimal_access = list(access_security, access_sec_doors, access_court, access_forensics_lockers,
			            access_medical, access_engine, access_eva, access_heads,
			            access_all_personal_lockers, access_maint_tunnels, access_bar, access_janitor, access_construction, access_morgue,
			            access_crematorium, access_kitchen, access_cargo, access_cargo_bot, access_mailsorting, access_qm, access_hydroponics, access_lawyer,
			            access_theatre, access_chapel_office, access_library, access_research, access_mining, access_heads_vault, access_mining_station,
			            access_clown, access_mime, access_RC_announce, access_keycard_auth, access_gateway, access_blueshield)

/decl/hierarchy/outfit/job/blueshield
	name = OUTFIT_JOB_NAME("Blueshield")
	uniform = /obj/item/clothing/under/rank/centcom
	suit = /obj/item/clothing/suit/armor/vest/deus_blueshield
	l_ear = /obj/item/device/radio/headset/heads/hop
	shoes = /obj/item/clothing/shoes/jackboots
	id_type = /obj/item/weapon/card/id/centcom/station
	pda_type = /obj/item/device/pda/heads/hop
	backpack = /obj/item/weapon/storage/backpack/security
	satchel_one = /obj/item/weapon/storage/backpack/satchel
	backpack_contents = list(/obj/item/weapon/storage/box/deathimp = 1)
	gloves = /obj/item/clothing/gloves/combat