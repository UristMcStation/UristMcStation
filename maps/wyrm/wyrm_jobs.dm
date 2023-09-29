/datum/map/wyrm
	allowed_jobs = list(
		/datum/job/captain,
		/datum/job/hop,
		/datum/job/hos,
		/datum/job/logistics,
		/datum/job/logistics/salvage,
		/datum/job/scientist,
		/datum/job/scientist/roboticist,
		/datum/job/doctor/surgeon,
		/datum/job/doctor,
		/datum/job/engineer/head,
		/datum/job/engineer,
		//datum/job/ai,
		/datum/job/cyborg
		)

/datum/job/chief_engineer
	title = "Senior Engineer"

/datum/job/assistant
	alt_titles = list(
	"Technical Assistant","Medical Intern","Research Assistant", "Chef", "Botanist",
	"Clown" = /singleton/hierarchy/outfit/job/clown,
	"Mime" = /singleton/hierarchy/outfit/job/mime
	)

/datum/job/cargo_tech
	alt_titles = list("Resource Technician")

/datum/job/officer
	alt_titles = list("Detective")

/datum/job/doctor
	access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_chemistry, access_virology, access_cmo)
	alt_titles = list("Chemist" = /singleton/hierarchy/outfit/job/medical/doctor/chemist,
		"Surgeon" = /singleton/hierarchy/outfit/job/medical/doctor/surgeon,
		"Emergency Physician" = /singleton/hierarchy/outfit/job/medical/doctor/emergency_physician,
		"Psychologist" = /singleton/hierarchy/outfit/job/medical/psychiatrist
		)

/datum/job/scientist
	alt_titles = list("Xenobiologist", "Xenoarcheologist", "Xenobotanist", "Anomalist",
		"Roboticist" = /singleton/hierarchy/outfit/job/science/roboticist)

/singleton/hierarchy/outfit/job/mime
	name = OUTFIT_JOB_NAME("Mime")
	uniform = /obj/item/clothing/under/mime
	head = /obj/item/clothing/head/beret
	mask = /obj/item/clothing/mask/gas/mime
	gloves = /obj/item/clothing/gloves/white
	shoes = /obj/item/clothing/shoes/black
	suit = /obj/item/clothing/suit/suspenders
	pda_type = /obj/item/modular_computer/pda/mime
	id_types = list(/obj/item/card/id/civilian/mime)

/singleton/hierarchy/outfit/job/clown
	name = OUTFIT_JOB_NAME("Clown")
	uniform = /obj/item/clothing/under/rank/clown
	mask = /obj/item/clothing/mask/gas/clown_hat
	shoes = /obj/item/clothing/shoes/clown_shoes
	backpack_contents = list(/obj/item/reagent_containers/food/snacks/grown/banana = 1, /obj/item/bikehorn = 1,
		/obj/item/stamp/clown = 1, /obj/item/pen/crayon/rainbow = 1, /obj/item/storage/fancy/crayons = 1,
		/obj/item/reagent_containers/spray/waterflower = 1)
	back = /obj/item/storage/backpack/clown
	pda_type = /obj/item/modular_computer/pda/clown
	id_types = list(/obj/item/card/id/civilian/clown)

/obj/item/card/id/civilian/clown
	name = "identification card"
	desc = "A card issued to the ship's clown."
	icon_state = "clown"
	job_access_type = /datum/job/assistant

/obj/item/card/id/civilian/mime
	name = "identification card"
	desc = "A card issued to the ship's mime."
	icon_state = "mime"
	job_access_type = /datum/job/assistant

/datum/job/merchant
	total_positions = 1
	spawn_positions = 2

/datum/job/blueshield
	title = "Bodyguard"
	department_flag = SEC|COM
	total_positions = 1
	spawn_positions = 1
	supervisors = "whichever head you're protecting. Remember, you are NOT security. Ultimately, you report to the Captain."
	selection_color = "#004a7f"
	req_admin_notify = 1
	minimal_player_age = 8
	outfit_type = /singleton/hierarchy/outfit/job/bodyguard
	access = list(access_security, access_sec_doors, access_court, access_forensics_lockers,
			            access_medical, access_engine, access_ai_upload, access_eva, access_heads,
			            access_all_personal_lockers, access_maint_tunnels, access_construction, access_morgue,
			            access_cargo, access_mailsorting, access_qm, access_lawyer,
			            access_theatre, access_research, access_mining, access_mining_station,
			            access_clown, access_mime, access_RC_announce, access_keycard_auth, access_blueshield)

/singleton/hierarchy/outfit/job/bodyguard
	name = OUTFIT_JOB_NAME("Bodyguard")
	uniform = /obj/item/clothing/under/bodyguard
	suit = /obj/item/clothing/suit/armor/pcarrier/deus_blueshield
	l_ear = /obj/item/device/radio/headset/heads/hop
	shoes = /obj/item/clothing/shoes/jackboots
	id_types = list(/obj/item/card/id/bodyguard)
	pda_type = /obj/item/modular_computer/pda/heads/hop
	backpack_contents = list(/obj/item/storage/box/deathimp = 1)
	gloves = /obj/item/clothing/gloves/thick/combat

/singleton/hierarchy/outfit/job/bodyguard/New()
	..()
	BACKPACK_OVERRIDE_SECURITY

/obj/item/clothing/under/bodyguard
	name = "Bodyguard's Uniform"
	desc = "A black uniform made from a durable, slightly laser-resistant, fabric."
	icon_state = "combat"
	item_state = "combat"
	worn_state = "combat"
	armor = list(melee = 10, bullet = 0, laser = 10,energy = 0, bomb = 0, bio = 0, rad = 0)

/obj/item/card/id/bodyguard
	name = "identification card"
	desc = "A card issued to those crazy enough to put their life on the line for the Heads of Staff."
	icon_state = "centcom"
	job_access_type = /datum/job/blueshield
