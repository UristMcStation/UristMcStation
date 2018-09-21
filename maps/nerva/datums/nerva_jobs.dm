/datum/map/nerva
	allowed_jobs = list(/datum/job/captain, /datum/job/firstofficer, /datum/job/hop, /datum/job/blueshield,
						/datum/job/cook, /datum/job/janitor, /datum/job/assistant,
						/datum/job/qm, /datum/job/cargo_tech,
						/datum/job/chief_engineer, /datum/job/engineer,
						/datum/job/hos, /datum/job/officer,
						/datum/job/cmo, /datum/job/doctor,
						/datum/job/scientist,
						/datum/job/merchant,
						/datum/job/ai, /datum/job/cyborg
						)


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
	access = list(access_security, access_sec_doors, access_court, access_forensics_lockers,
			            access_medical, access_engine, access_ai_upload, access_eva, access_heads,
			            access_all_personal_lockers, access_maint_tunnels, access_construction, access_morgue,
			            access_cargo, access_mailsorting, access_qm, access_lawyer,
			            access_theatre, access_research, access_mining, access_mining_station,
			            access_clown, access_mime, access_RC_announce, access_keycard_auth, access_blueshield)
	minimal_access = list(access_security, access_sec_doors, access_court, access_forensics_lockers,
			            access_medical, access_engine, access_eva, access_heads,
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
	access = list()
	minimal_access = list()

/datum/job/firstofficer/get_access()
	get_all_station_access()
	access -= access_captain
	return

/datum/job/firstofficer/get_description_blurb()
	return "You are the First Officer, and second in command of the ICS Nerva. As the clear second in command of the ship, your job is to work with the captain to run the ship, and take charge of navigation according to the captain's orders. Moreover, if there is no second officer, your job is also to oversee personnel issues. In the event of combat, your job is to work with the Chief of Security to coordinate the ship's defence."

/datum/job/captain
	supervisors = "yourself, as you are the owner of this ship and the sole arbiter of its destiny. However, be careful not to anger Nanotrasen and the other factions that have set up outposts in this sector, or your own staff for that matter. It could lead to your undoing."
	minimal_player_age = 21
	outfit_type = /decl/hierarchy/outfit/job/nerva/captain
	economic_power = 24

/datum/job/captain/get_description_blurb()
	return "You are the Captain and owner of the ICS Nerva. You are the top dog. Your backstory and destiny is your own to decide, however, you are ultimately responsible for all that happens onboard. Your job is to make sure the that Nerva survives its time in this sector, and turns a profit for you. Delegate to your First Officer, the Second Officer, and your department heads to effectively manage the ship, and listen to and trust their expertise. It might be the difference between life and death. Oh, and watch out for pirates. The ship only has a small complement of weapons at first, which can be upgraded at certain stations in the sector. Good luck."

/datum/job/hop
	title = "Second Officer"
	supervisors = "the captain and the first officer."

/datum/job/hos
	title = "Chief of Security"
	supervisors = "the captain and the first officer."
	outfit_type = /decl/hierarchy/outfit/job/security/nervacos

/datum/job/cmo
	supervisors = "the captain and the first officer."

/datum/job/chief_engineer
	supervisors = "the captain and the first officer."

/datum/job/qm
	supervisors = "the captain and the first officer."
	outfit_type = /decl/hierarchy/outfit/job/nerva/qm

/datum/job/assistant
	alt_titles = list(
	"Technical Assistant","Medical Intern","Cargo Assistant",
	"Botanist" = /decl/hierarchy/outfit/job/service/gardener,
	"Clown" = /decl/hierarchy/outfit/job/clown,
	"Mime" = /decl/hierarchy/outfit/job/mime
	)

/datum/job/cargo_tech
	title = "Supply Technician"
	supervisors = "the quartermaster"
	alt_titles = list("Cargo Technician", "Resource Technician", "Fabrication Technician", "Salvage Technician",
	"Roboticist" = /decl/hierarchy/outfit/job/science/roboticist)
	total_positions = 6 //because we're replacing science
	spawn_positions = 4
	outfit_type = /decl/hierarchy/outfit/job/nerva/supplytech

/datum/job/officer
	supervisors = "the chief of security."
	alt_titles = list("Detective")
	outfit_type = /decl/hierarchy/outfit/job/security/nervasecofficer

/datum/job/doctor
	access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_chemistry, access_virology, access_genetics, access_cmo)
	alt_titles = list("Chemist" = /decl/hierarchy/outfit/job/medical/doctor/chemist,
		"Surgeon" = /decl/hierarchy/outfit/job/medical/doctor/surgeon,
		"Emergency Physician" = /decl/hierarchy/outfit/job/medical/doctor/emergency_physician,
		"Psychologist" = /decl/hierarchy/outfit/job/medical/psychiatrist/psychologist
		)

/datum/job/cook
	alt_titles = list("Bartender" = /decl/hierarchy/outfit/job/service/bartender)
	supervisors = "the quartermaster."

/datum/job/janitor
	supervisors = "the second officer."
	total_positions = 1
	spawn_positions = 1

/datum/job/engineer
	total_positions = 5
	spawn_positions = 3

/datum/job/scientist
	title = "Nanotrasen Scientist"
	supervisors = "Nanotrasen Central Command and the captain."
	total_positions = 2
	spawn_positions = 2
	outfit_type = /decl/hierarchy/outfit/job/nerva/scientist

/datum/job/scientist/get_description_blurb()
	return "You are a Nanotrasen scientist, working aboard the ICS Nerva under contract. The captain has provided space on the ship for you to do research, in exchange for a nice payout from Nanotrasen, and access to Nanotrasen research contracts. This unique arrangement is owing to Nanotrasen's weak position in the outer sector. Thus, you are not fully part of the Nerva's crew, and answer to Nanotrasen Central Command above all else. However, while on the ship, you are expected to answer to the captain or the ranking officer."

/datum/job/merchant
	total_positions = 1
	spawn_positions = 1