/datum/job/hos
	title = "Head of Security"
	head_position = 1
	department = "Security"
	department_flag = SEC|COM

	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain"
	selection_color = "#8e2929"
	req_admin_notify = 1
	economic_power = 10
	access = list(access_security, access_eva, access_sec_doors, access_brig, access_armory, access_heads,
			            access_forensics_lockers, access_morgue, access_maint_tunnels, access_all_personal_lockers,
			            access_research, access_engine, access_mining, access_medical, access_construction, access_mailsorting,
			            access_bridge, access_hos, access_RC_announce, access_keycard_auth, access_gateway, access_external_airlocks)
	minimal_player_age = 14
	outfit_type = /singleton/hierarchy/outfit/job/security/hos

/datum/job/hos/equip(mob/living/carbon/human/H)
	. = ..()
	if(.)
		H.implant_loyalty(H)

/datum/job/warden
	title = "Warden"
	department = "Security"
	department_flag = SEC

	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of security"
	selection_color = "#601c1c"
	economic_power = 5
	access = list(access_security, access_eva, access_sec_doors, access_brig, access_armory, access_maint_tunnels, access_morgue, access_external_airlocks)
	minimal_player_age = 7
	outfit_type = /singleton/hierarchy/outfit/job/security/warden

/datum/job/detective
	title = "Detective"
	department = "Security"
	department_flag = SEC

	total_positions = 2
	spawn_positions = 2
	supervisors = "the head of security"
	selection_color = "#601c1c"
	alt_titles = list("Forensic Technician" = /singleton/hierarchy/outfit/job/security/detective/forensic)
	economic_power = 5
	access = list(access_security, access_sec_doors, access_forensics_lockers, access_morgue, access_maint_tunnels)
	minimal_player_age = 7
	outfit_type = /singleton/hierarchy/outfit/job/security/detective

/datum/job/officer
	title = "Security Officer"
	department = "Security"
	department_flag = SEC

	total_positions = 4
	spawn_positions = 4
	supervisors = "the head of security"
	selection_color = "#601c1c"
	alt_titles = list("Junior Officer")
	economic_power = 4
	access = list(access_security, access_eva, access_sec_doors, access_brig, access_maint_tunnels, access_morgue, access_external_airlocks)
	minimal_player_age = 7
	outfit_type = /singleton/hierarchy/outfit/job/security/officer

/datum/job/blueshield
	title = "Blueshield"
	department_flag = SEC|COM
	total_positions = 2
	spawn_positions = 2
	supervisors = "whichever head you protect. Remember, you are NOT security. Ultimately, you report to Nanotrasen, but if unavailable, defer to the Captain."
	selection_color = "#ddddff"
	req_admin_notify = 1
	minimal_player_age = 8
	economic_power = 5
	hud_icon = "hudbodyguard"
	outfit_type = /singleton/hierarchy/outfit/job/blueshield
	access = list(access_security, access_sec_doors, access_court, access_forensics_lockers,
			            access_medical, access_engine, access_ai_upload, access_eva, access_heads,
			            access_all_personal_lockers, access_maint_tunnels, access_janitor, access_construction, access_morgue,
			            access_crematorium, access_kitchen, access_cargo, access_cargo_bot, access_mailsorting, access_qm, access_hydroponics, access_lawyer,
			            access_theatre, access_chapel_office, access_library, access_research, access_mining, access_heads_vault, access_mining_station,
			            access_clown, access_mime, access_RC_announce, access_keycard_auth, access_gateway, access_blueshield, access_heads, access_bridge)

//Urist Job, it's here for compatability with other maps.
/singleton/hierarchy/outfit/job/blueshield
	name = OUTFIT_JOB_NAME("Blueshield")
	uniform = /obj/item/clothing/under/rank/centcom
	suit = /obj/item/clothing/suit/armor/pcarrier/deus_blueshield
	l_ear = /obj/item/device/radio/headset/heads/hop
	shoes = /obj/item/clothing/shoes/jackboots
	id_types = list(/obj/item/card/id/blueshield)
	pda_type = /obj/item/modular_computer/pda/heads/hop
	backpack_contents = list(/obj/item/storage/box/deathimp = 1)
	gloves = /obj/item/clothing/gloves/thick/combat
