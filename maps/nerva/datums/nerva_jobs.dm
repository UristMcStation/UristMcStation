/datum/map/nerva
	allowed_jobs = list(/datum/job/captain, /datum/job/firstofficer, /datum/job/hop, /datum/job/blueshield,
						/datum/job/chef, /datum/job/janitor, /datum/job/assistant,
						/datum/job/qm, /datum/job/cargo_tech,
						/datum/job/chief_engineer, /datum/job/engineer,
						/datum/job/hos, /datum/job/officer,
						/datum/job/cmo, /datum/job/doctor,
						/datum/job/scientist, /datum/job/chaplain,
						/datum/job/merchant, /datum/job/stowaway,
						/datum/job/ai, /datum/job/cyborg
						)

//general command

/datum/job/blueshield
	title = "Bodyguard"
	department_flag = SEC|COM
	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain, who hired you to protect them. If the captain is not present, follow the chain of command as to who you will be protecting."
	selection_color = "#004a7f"
	req_admin_notify = 1
	minimal_player_age = 8
	economic_power = 7
	outfit_type = /decl/hierarchy/outfit/job/bodyguard
	hud_icon = "hudbodyguard"
	access = list(access_security, access_sec_doors, access_court, access_forensics_lockers,
			            access_medical, access_engine, access_ai_upload, access_eva, access_heads, access_bridge,
			            access_all_personal_lockers, access_maint_tunnels, access_construction, access_morgue,
			            access_cargo, access_mailsorting, access_qm, access_lawyer,
			            access_theatre, access_research, access_mining, access_mining_station,
			            access_clown, access_mime, access_RC_announce, access_keycard_auth, access_blueshield,
			            )
	minimal_access = list(access_security, access_sec_doors, access_court, access_forensics_lockers,
			            access_medical, access_engine, access_eva, access_heads, access_bridge,
			            access_all_personal_lockers, access_maint_tunnels, access_construction, access_morgue,
			            access_cargo, access_mailsorting, access_qm, access_lawyer,
			            access_theatre, access_research, access_mining, access_mining_station,
			            access_clown, access_mime, access_RC_announce, access_keycard_auth, access_blueshield)

/datum/job/firstofficer
	title = "First Officer"
	supervisors = "the captain"
	department_flag = COM
	total_positions = 1
	spawn_positions = 1
	selection_color = "#004a7f"
	req_admin_notify = 1
	minimal_player_age = 18
	economic_power = 15
	outfit_type = /decl/hierarchy/outfit/job/nerva/firstofficer
	hud_icon = "hudheadofpersonnel"
	access = list(access_security, access_sec_doors, access_brig, access_forensics_lockers, access_heads,
			            access_engine, access_change_ids, access_ai_upload, access_eva, access_bridge,
			            access_all_personal_lockers, access_maint_tunnels, access_bar, access_janitor, access_construction, access_morgue,
			            access_crematorium, access_kitchen, access_cargo, access_cargo_bot, access_mailsorting, access_qm, access_hydroponics, access_lawyer,
			            access_chapel_office, access_library, access_research, access_mining, access_heads_vault, access_mining_station,
			            access_hop, access_RC_announce, access_keycard_auth, access_gateway,
			            access_expedition_shuttle_helm, access_expedition, access_fo, access_teleporter,
			            access_tcomsat, access_engine_equip, access_tech_storage, access_ce, access_external_airlocks, access_atmospherics, access_emergency_storage, access_construction,
			            access_medical, access_medical_equip, access_morgue, access_genetics,
						access_chemistry, access_virology, access_cmo, access_surgery,
						access_robotics, access_research, access_armory, access_hos,
						access_tox, access_tox_storage, access_xenobiology, access_xenoarch, access_psychiatrist
						)
	minimal_access = list(access_security, access_sec_doors, access_brig, access_forensics_lockers, access_heads,
			            access_engine, access_change_ids, access_ai_upload, access_eva, access_bridge,
			            access_all_personal_lockers, access_maint_tunnels, access_bar, access_janitor, access_construction, access_morgue,
			            access_crematorium, access_kitchen, access_cargo, access_cargo_bot, access_mailsorting, access_qm, access_hydroponics, access_lawyer,
			            access_chapel_office, access_library, access_research, access_mining, access_heads_vault, access_mining_station,
			            access_hop, access_RC_announce, access_keycard_auth, access_gateway,
			            access_expedition_shuttle_helm, access_expedition, access_fo, access_teleporter,
			            access_tcomsat, access_engine_equip, access_tech_storage, access_ce, access_external_airlocks, access_atmospherics, access_emergency_storage, access_construction,
			            access_medical, access_medical_equip, access_morgue, access_genetics,
						access_chemistry, access_virology, access_cmo, access_surgery,
						access_robotics, access_research, access_armory, access_hos,
						access_tox, access_tox_storage, access_xenobiology, access_xenoarch, access_psychiatrist
						)

/datum/job/firstofficer/get_description_blurb()
	return "You are the First Officer, and second in command of the ICS Nerva. As the clear second in command of the ship, your job is to work with the captain to run the ship, and take charge of navigation according to the captain's orders. Moreover, if there is no second officer, your job is also to oversee personnel issues and organize away missions. In the event of combat, your job is to work with the Chief of Security to coordinate the ship's defence."

/datum/job/captain
	supervisors = "yourself and your counterpart, as you are the owner of this ship and the sole arbiter of its destiny, alongside your counterpart.. However, be careful not to anger NanoTrasen and the other factions that have set up outposts in this sector, or your own staff for that matter. It could lead to your undoing"
	minimal_player_age = 21
	outfit_type = /decl/hierarchy/outfit/job/nerva/captain
	economic_power = 24

/datum/job/captain/get_description_blurb()
	return "You are the Captain and owner of the ICS Nerva. You are the top dog. Your backstory and destiny is your own to decide, however, you are ultimately responsible for all that happens onboard. Your job is to make sure the that Nerva survives its time in this sector, and turns a profit for you. Delegate to your First Officer, the Second Officer, and your department heads to effectively manage the ship, and listen to and trust their expertise. It might be the difference between life and death. Oh, and watch out for pirates. The ICS Nerva only has a small complement of weapons at first, which can be upgraded at certain stations in the sector. Good luck."

/datum/job/hop
	title = "Second Officer"
	supervisors = "the captain and the first officer."
	outfit_type = /decl/hierarchy/outfit/job/nerva/secondofficer
	hud_icon = "hudheadofpersonnel"
	access = list(access_security, access_sec_doors, access_brig, access_forensics_lockers, access_heads,
			            access_medical, access_engine, access_change_ids, access_ai_upload, access_eva, access_bridge,
			            access_all_personal_lockers, access_maint_tunnels, access_janitor, access_construction, access_morgue,
			            access_crematorium, access_cargo, access_hydroponics, access_lawyer,
			            access_chapel_office, access_library, access_research, access_heads_vault,
			            access_hop, access_RC_announce, access_keycard_auth, access_gateway,
			            access_expedition_shuttle_helm, access_expedition)
	minimal_access = list(access_security, access_sec_doors, access_brig, access_forensics_lockers, access_heads,
			            access_medical, access_engine, access_change_ids, access_ai_upload, access_eva, access_bridge,
			            access_all_personal_lockers, access_maint_tunnels, access_janitor, access_construction, access_morgue,
			            access_crematorium, access_cargo, access_hydroponics, access_lawyer,
			            access_chapel_office, access_library, access_research, access_heads_vault,
			            access_hop, access_RC_announce, access_keycard_auth, access_gateway,
			            access_expedition_shuttle_helm, access_expedition)

/datum/job/firstofficer/get_description_blurb()
	return "You are the Second Officer, third in command, after the First Officer and the Captain. As the Second Officer, it is your job to oversee personnel issues, which includes managing access, delegating crew grievances, and ensuring the proper upkeep and operation of the ship's recreational and mess facilities. Thus, you are the direct supervisor for the janitorial staff, as well as the culinary and hydroponics staff. As Second Officer, it is also your job to organize and lead awaymissions, and in cases where there is no First Officer present, to pilot the ICS Nerva."


//eng

/datum/job/chief_engineer
	supervisors = "the captain and the first officer."
	access = list(access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels, access_heads,
			            access_teleporter, access_external_airlocks, access_atmospherics, access_emergency_storage, access_eva,
			            access_bridge, access_construction, access_sec_doors,
			            access_ce, access_RC_announce, access_keycard_auth, access_tcomsat, access_ai_upload,
			            access_expedition_shuttle_helm, access_expedition)
	minimal_access = list(access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels, access_heads,
			            access_teleporter, access_external_airlocks, access_atmospherics, access_emergency_storage, access_eva,
			            access_bridge, access_construction, access_sec_doors,
			            access_ce, access_RC_announce, access_keycard_auth, access_tcomsat, access_ai_upload,
			            access_expedition_shuttle_helm, access_expedition)

/datum/job/engineer
	total_positions = 5
	spawn_positions = 3

//cargo

/datum/job/qm
	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain and the first officer."
	outfit_type = /decl/hierarchy/outfit/job/nerva/qm
	access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_qm, access_mining, access_mining_station,
	access_expedition_shuttle_helm, access_expedition, access_robotics, access_research,
	access_RC_announce, access_keycard_auth, access_heads, access_eva, access_bridge, access_hydroponics, access_chapel_office, access_library, access_bar, access_kitchen, access_janitor)
	minimal_access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_qm, access_mining, access_mining_station,
	access_expedition_shuttle_helm, access_expedition, access_robotics, access_research,
	access_RC_announce, access_keycard_auth, access_heads, access_eva, access_bridge, access_hydroponics, access_chapel_office, access_library, access_bar, access_janitor)

/datum/job/cargo_tech
	title = "Supply Technician"
	supervisors = "the quartermaster"
	alt_titles = list("Cargo Technician", "Resource Technician", "Fabrication Technician", "Salvage Technician",
	"Roboticist" = /decl/hierarchy/outfit/job/science/nervaroboticist)
	total_positions = 6 //because we're replacing science
	spawn_positions = 4
	hud_icon = "hudcargotechnician"
	outfit_type = /decl/hierarchy/outfit/job/nerva/supplytech
	access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_mining, access_mining_station,
	access_expedition_shuttle_helm, access_expedition, access_robotics, access_research)
	minimal_access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_mining, access_mining_station,
	access_expedition_shuttle_helm, access_expedition, access_robotics, access_research)

//medbay

/datum/job/cmo
	supervisors = "the captain and the first officer."
	access = list(access_medical, access_medical_equip, access_morgue, access_genetics, access_bridge, access_heads,
			access_chemistry, access_virology, access_cmo, access_surgery, access_RC_announce,
			access_keycard_auth, access_sec_doors, access_psychiatrist, access_eva, access_maint_tunnels, access_external_airlocks,
			access_expedition_shuttle_helm, access_expedition)
	minimal_access = list(access_medical, access_medical_equip, access_morgue, access_genetics, access_bridge, access_heads,
			access_chemistry, access_virology, access_cmo, access_surgery, access_RC_announce,
			access_keycard_auth, access_sec_doors, access_psychiatrist, access_eva, access_maint_tunnels, access_external_airlocks,
			access_expedition_shuttle_helm, access_expedition)

/datum/job/doctor
	access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_chemistry, access_virology, access_genetics)
	minimal_access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_chemistry, access_virology, access_genetics)
	alt_titles = list("Chemist" = /decl/hierarchy/outfit/job/medical/doctor/chemist,
		"Surgeon" = /decl/hierarchy/outfit/job/medical/doctor/surgeon,
		"Emergency Physician" = /decl/hierarchy/outfit/job/medical/doctor/emergency_physician,
		)

//sec

/datum/job/hos
	title = "Chief of Security"
	supervisors = "the captain and the first officer."
	outfit_type = /decl/hierarchy/outfit/job/security/nervacos
	hud_icon = "hudheadofsecurity"
	access = list(access_security, access_eva, access_sec_doors, access_brig, access_armory, access_heads,
			            access_forensics_lockers, access_morgue, access_maint_tunnels, access_all_personal_lockers,
			            access_research, access_engine, access_mining, access_medical, access_construction, access_mailsorting,
			            access_bridge, access_hos, access_RC_announce, access_keycard_auth, access_gateway, access_external_airlocks,
			            access_expedition_shuttle_helm, access_expedition)
	minimal_access = list(access_security, access_eva, access_sec_doors, access_brig, access_armory, access_heads,
			            access_forensics_lockers, access_morgue, access_maint_tunnels, access_all_personal_lockers,
			            access_research, access_engine, access_mining, access_medical, access_construction, access_mailsorting,
			            access_bridge, access_hos, access_RC_announce, access_keycard_auth, access_gateway, access_external_airlocks,
			            access_expedition_shuttle_helm, access_expedition)

/datum/job/officer
	supervisors = "the chief of security."
	alt_titles = list("Detective")
	outfit_type = /decl/hierarchy/outfit/job/security/nervasecofficer
	access = list(access_security, access_forensics_lockers, access_eva, access_sec_doors, access_brig, access_maint_tunnels, access_morgue, access_external_airlocks, access_expedition, access_expedition_shuttle_helm)
	minimal_access = list(access_security, access_forensics_lockers, access_eva, access_sec_doors, access_brig, access_maint_tunnels, access_external_airlocks, access_expedition, access_expedition_shuttle_helm)

//sci

/datum/job/scientist
	title = "Nanotrasen Scientist"
	supervisors = "Nanotrasen Central Command and the captain."
	total_positions = 2
	spawn_positions = 2
	hud_icon = "hudblueshield"
	outfit_type = /decl/hierarchy/outfit/job/nerva/scientist
	access = list(access_tox, access_tox_storage, access_research, access_xenobiology, access_xenoarch, access_expedition)
	minimal_access = list(access_tox, access_tox_storage, access_research, access_xenoarch, access_xenobiology, access_expedition)

/datum/job/scientist/get_description_blurb()
	return "You are a NanoTrasen scientist, working aboard the ICS Nerva under contract. The captain has provided space on the ship for you to do research, in exchange for a nice payout from NanoTrasen, and access to NanoTrasen research contracts. This unique arrangement is owing to NanoTrasen's weak position in the outer sectors. Thus, you are not fully part of the Nerva's crew, and answer to NanoTrasen Central Command above all else. However, while on the ship, you are expected to answer to the captain or the ranking officer."

//misc

/datum/job/assistant
	alt_titles = list(
	"Technical Assistant","Medical Intern","Cargo Assistant",
	"Botanist" = /decl/hierarchy/outfit/job/service/gardener,
	"Clown" = /decl/hierarchy/outfit/job/clown,
	"Mime" = /decl/hierarchy/outfit/job/mime
	)

/datum/job/chef
	access = list(access_hydroponics, access_bar, access_kitchen)
	minimal_access = list(access_hydroponics, access_bar, access_kitchen)
	alt_titles = list("Bartender" = /decl/hierarchy/outfit/job/service/nervabartender)
	supervisors = "the quartermaster and the second officer."

/datum/job/janitor
	supervisors = "the second officer."
	total_positions = 1
	spawn_positions = 1

/datum/job/chaplain
	title = "Counselor"
	department = "Medical"
	department_flag = MED|CIV
	hud_icon = "hudchaplain"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the second officer and the chief medical officer"
	access = list(access_medical, access_morgue, access_chapel_office, access_crematorium, access_maint_tunnels, access_psychiatrist)
	minimal_access = list(access_medical, access_morgue, access_chapel_office, access_crematorium, access_maint_tunnels, access_psychiatrist)
	alt_titles = list(
	"Chaplain" = /decl/hierarchy/outfit/job/chaplain,
	"Morale Officer" = /decl/hierarchy/outfit/job/chaplain,
	"Psychiatrist" = /decl/hierarchy/outfit/job/medical/psychiatrist/nerva,
	"Psychologist" = /decl/hierarchy/outfit/job/medical/psychiatrist/psychologist/nerva)


	outfit_type = /decl/hierarchy/outfit/job/medical/psychiatrist/nerva

/datum/job/merchant
	total_positions = 0
	spawn_positions = 0

/datum/job/stowaway
	title = "Stowaway"
	department = "Civilian"
	department_flag = CIV
	hud_icon = "hudunknown"
	total_positions = 1
	spawn_positions = 1
	availablity_chance = 15
	supervisors = "yourself"
	selection_color = "#515151"
	ideal_character_age = 30
	minimal_player_age = 0
	create_record = 0
	account_allowed = 0
	outfit_type = /decl/hierarchy/outfit/job/nerva/stowaway
	latejoin_at_spawnpoints = 1
	announced = FALSE

//vox
/datum/map/nerva
	species_to_job_whitelist = list(
		/datum/species/vox = list(/datum/job/ai, /datum/job/cyborg, /datum/job/merchant, /datum/job/stowaway)
	)
