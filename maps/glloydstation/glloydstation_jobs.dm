

/datum/map/glloydstation //RIP Geneticists, you're illegal now. - Vak
	allowed_jobs = list(
						/datum/job/captain, /datum/job/hop, /datum/job/chef, /datum/job/hydro,
						/datum/job/qm, /datum/job/cargo_tech,
						/datum/job/janitor, /datum/job/lawyer, /datum/job/librarian, /datum/job/psychiatrist,
						/datum/job/chief_engineer, /datum/job/engineer,
						/datum/job/ai, /datum/job/cyborg,
						/datum/job/hos, /datum/job/warden, /datum/job/detective, /datum/job/officer,
						/datum/job/cmo, /datum/job/doctor, /datum/job/chemist, /datum/job/chaplain,
						/datum/job/rd, /datum/job/scientist, /datum/job/roboticist, /datum/job/mining,
						/datum/job/blueshield, /datum/job/mime, /datum/job/clown, /datum/job/merchant
						)

/datum/job
	required_language = LANGUAGE_GALCOM

//Resource Technician et al

/datum/job/mining
	title = "Resource Technician"
	department = "Cargo"
	department_flag = CIV
	total_positions = 5
	spawn_positions = 5
	supervisors = "the quartermaster and the head of personnel"
	selection_color = "#515151"
	access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_qm, access_mining, access_mining_station)
	alt_titles = list(
		"Shaft Miner" = /singleton/hierarchy/outfit/job/cargo/mining,
		"Drill Technician" = /singleton/hierarchy/outfit/job/cargo/mining,
		"Prospector" = /singleton/hierarchy/outfit/job/cargo/mining,
		"Lumberjack" = /singleton/hierarchy/outfit/job/cargo/mining/woodsman,
		"Hunter" = /singleton/hierarchy/outfit/job/cargo/mining/hunter,
		"Carpenter" = /singleton/hierarchy/outfit/job/cargo/mining/woodsman)
	outfit_type = /singleton/hierarchy/outfit/job/cargo/mining/tech

/singleton/hierarchy/outfit/job/cargo/mining/woodsman
	name = OUTFIT_JOB_NAME("Carpenter")
	uniform = /obj/item/clothing/under/urist/rank/carpenter
	head = /obj/item/clothing/head/urist/toque

/singleton/hierarchy/outfit/job/cargo/mining/hunter
	name = OUTFIT_JOB_NAME("Hunter")
	uniform = /obj/item/clothing/under/urist/casual/suspenders
	suit = /obj/item/clothing/suit/storage/urist/overalls/leather
	head = /obj/item/clothing/head/urist/toque

/singleton/hierarchy/outfit/job/cargo/mining/tech
	name = OUTFIT_JOB_NAME("Resource Technician")
	uniform = /obj/item/clothing/under/overalls

//Mime

/datum/job/mime
	title = "Mime"
	department = "Civilian"
	department_flag = CIV
	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of personnel"
	selection_color = "#515151"
	access = list(access_maint_tunnels, access_mime, access_theatre)
	minimal_player_age = 10
	outfit_type = /singleton/hierarchy/outfit/job/mime

/* //This hasn't worked for a while,
/datum/job/mime/equip(mob/living/carbon/human/H)
	. = ..()
	if(.)
		H.miming = 1
		H.verbs += /client/proc/mimespeak
		H.verbs += /client/proc/mimewall
		H.mind.special_verbs += /client/proc/mimespeak
		H.mind.special_verbs += /client/proc/mimewall
*/

/singleton/hierarchy/outfit/job/mime
	name = OUTFIT_JOB_NAME("Mime")
	uniform = /obj/item/clothing/under/mime
	head = /obj/item/clothing/head/beret
	mask = /obj/item/clothing/mask/gas/mime
	gloves = /obj/item/clothing/gloves/white
	shoes = /obj/item/clothing/shoes/black
	backpack_contents = list(/obj/item/reagent_containers/food/drinks/bottle/bottleofnothing = 1, /obj/item/pen/crayon/mime = 1)
	suit = /obj/item/clothing/suit/suspenders
	pda_type = /obj/item/modular_computer/pda/mime
	id_types = list(/obj/item/card/id/civilian/mime)

//Clown :^)

/datum/job/clown
	title = "Clown"
	department = "Civilian"
	department_flag = CIV
	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of personnel"
	selection_color = "#515151"
	access = list(access_maint_tunnels, access_clown, access_theatre)
	minimal_player_age = 10
	outfit_type = /singleton/hierarchy/outfit/job/clown

/datum/job/clown/equip(mob/living/carbon/human/H)
	. = ..()
	if(.)
		H.mutations.Add(MUTATION_CLUMSY)

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

//rd
/datum/job/rd
	title = "Research Director"
//ids for the jobs

/obj/item/card/id/civilian/clown
	name = "identification card"
	desc = "A card issued to the station's clown."
	icon_state = "clown"
	job_access_type = /datum/job/clown

/obj/item/card/id/civilian/mime
	name = "identification card"
	desc = "A card issued to the station's mime."
	icon_state = "mime"
	job_access_type = /datum/job/mime

/singleton/hierarchy/outfit/job/glloydstation/ert
	name = OUTFIT_JOB_NAME("ERT - Glloydstation")
	uniform = /obj/item/clothing/under/syndicate/combat
	head = /obj/item/clothing/head/beret/centcom/officer
	gloves = /obj/item/clothing/gloves/thick
	id_types = list(/obj/item/card/id/centcom/ERT)
	pda_type = /obj/item/modular_computer/pda/ert
	l_ear = /obj/item/device/radio/headset/ert
	shoes = /obj/item/clothing/shoes/dutyboots

/singleton/hierarchy/outfit/job/glloydstation/ert/leader
	name = OUTFIT_JOB_NAME("ERT Leader - Glloydstation")
	uniform = /obj/item/clothing/under/rank/centcom
	head = /obj/item/clothing/head/beret/centcom/captain

/singleton/hierarchy/outfit/job/glloydstation/ert/suit
	name = OUTFIT_JOB_NAME("ERT Heavy - Glloydstation")
	back = /obj/item/rig/ert/assetprotection
	flags = OUTFIT_RESET_EQUIPMENT | OUTFIT_ADJUSTMENT_SKIP_BACKPACK
	head = null
	gloves = null
