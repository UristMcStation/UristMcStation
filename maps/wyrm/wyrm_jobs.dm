/datum/map/skyestation
	allowed_jobs = list(/datum/job/captain, /datum/job/hop, /datum/job/chef, /datum/job/bartender, /datum/job/hydro,
						/datum/job/qm, /datum/job/cargo_tech,
						/datum/job/janitor, /datum/job/lawyer, /datum/job/librarian, /datum/job/psychiatrist,
						/datum/job/chief_engineer, /datum/job/engineer,
						/datum/job/ai, /datum/job/cyborg,
						/datum/job/hos, /datum/job/warden, /datum/job/detective, /datum/job/officer,
						/datum/job/cmo, /datum/job/doctor, /datum/job/chaplain,
						/datum/job/rd, /datum/job/scientist, /datum/job/mining,
						/datum/job/mime, /datum/job/clown, /datum/job/merchant
						)

//Mime

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
	access = list(access_maint_tunnels, access_mime, access_theatre)
	minimal_access = list(access_mime, access_theatre)
	minimal_player_age = 10
	outfit_type = /decl/hierarchy/outfit/job/mime

/datum/job/mime/equip(var/mob/living/carbon/human/H)
	. = ..()
	if(.)
		H.miming = 1
		H.verbs += /client/proc/mimespeak
		H.verbs += /client/proc/mimewall
		H.mind.special_verbs += /client/proc/mimespeak
		H.mind.special_verbs += /client/proc/mimewall

/decl/hierarchy/outfit/job/mime
	name = OUTFIT_JOB_NAME("Mime")
	uniform = /obj/item/clothing/under/mime
	head = /obj/item/clothing/head/beret
	mask = /obj/item/clothing/mask/gas/mime
	gloves = /obj/item/clothing/gloves/white
	shoes = /obj/item/clothing/shoes/black
	suit = /obj/item/clothing/suit/suspenders
	pda_type = /obj/item/device/pda/mime
	id_type = /obj/item/weapon/card/id/civilian/mime

//Clown :^)

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
	access = list(access_maint_tunnels, access_clown, access_theatre)
	minimal_access = list(access_clown, access_theatre)
	minimal_player_age = 10
	outfit_type = /decl/hierarchy/outfit/job/clown

/datum/job/clown/equip(var/mob/living/carbon/human/H)
	. = ..()
	if(.)
		H.mutations.Add(CLUMSY)

/decl/hierarchy/outfit/job/clown
	name = OUTFIT_JOB_NAME("Clown")
	uniform = /obj/item/clothing/under/rank/clown
	mask = /obj/item/clothing/mask/gas/clown_hat
	shoes = /obj/item/clothing/shoes/clown_shoes
	backpack_contents = list(/obj/item/weapon/reagent_containers/food/snacks/grown/banana = 1, /obj/item/weapon/bikehorn = 1,
		/obj/item/weapon/stamp/clown = 1, /obj/item/weapon/pen/crayon/rainbow = 1, /obj/item/weapon/storage/fancy/crayons = 1,
		/obj/item/weapon/reagent_containers/spray/waterflower = 1)
	back = /obj/item/weapon/storage/backpack/clown
	pda_type = /obj/item/device/pda/clown
	id_type = /obj/item/weapon/card/id/civilian/clown

/datum/job/merchant
	title = "Merchant"
	department = "Civilian"
	department_flag = CIV
	faction = "Station"
	total_positions = 0 //to be opened by admins when desired AT ROUNDSTART ONLY
	spawn_positions = 2
	supervisors = "the invisible hand of the market"
	selection_color = "#515151"
	ideal_character_age = 30
	minimal_player_age = 7
	create_record = 0
	outfit_type = /decl/hierarchy/outfit/job/merchant
	access = list(access_merchant)
	minimal_access = list(access_merchant)
	alt_titles = list(
	"Trader" = /decl/hierarchy/outfit/job/trader)

/decl/hierarchy/outfit/job/merchant
	name = OUTFIT_JOB_NAME("Merchant")
	uniform = /obj/item/clothing/under/color/black
	l_ear = /obj/item/device/radio/headset
	shoes = /obj/item/clothing/shoes/black
	pda_type = /obj/item/device/pda
	id_type = /obj/item/weapon/card/id/merchant

/decl/hierarchy/outfit/job/trader
	name = OUTFIT_JOB_NAME("Trader")
	uniform = /obj/item/clothing/under/terran/trader
	suit = /obj/item/clothing/suit/terran/trader
	head = /obj/item/clothing/head/terran/trader
	l_ear = /obj/item/device/radio/headset
	shoes = /obj/item/clothing/shoes/black
	pda_type = /obj/item/device/pda
	id_type = /obj/item/weapon/card/id/merchant

/obj/item/weapon/card/id/civilian/clown
	name = "identification card"
	desc = "A card issued to the station's clown."
	icon_state = "clown"
	job_access_type = /datum/job/clown

/obj/item/weapon/card/id/civilian/mime
	name = "identification card"
	desc = "A card issued to the station's mime."
	icon_state = "mime"
	job_access_type = /datum/job/mime

/obj/item/weapon/card/id/merchant
	desc = "An identification card issued to Merchants, indicating their right to sell and buy goods."
	icon_state = "trader"
	job_access_type = /datum/job/merchant