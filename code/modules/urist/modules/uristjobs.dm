//Urist jobs!

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

//for the blueshield

/obj/item/weapon/storage/box/deathimp
	name = "death alarm implant kit"
	desc = "Box of life sign monitoring implants."
	icon_state = "implant"

	New()
		..()
		new /obj/item/weapon/implantcase/death_alarm(src)
		new /obj/item/weapon/implantcase/death_alarm(src)
		new /obj/item/weapon/implantcase/death_alarm(src)
		new /obj/item/weapon/implantcase/death_alarm(src)
		new /obj/item/weapon/implantcase/death_alarm(src)
		new /obj/item/weapon/implanter(src)
		new /obj/item/weapon/implantpad(src)

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