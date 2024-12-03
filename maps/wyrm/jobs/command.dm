/datum/job/captain
	title = "Captain"
	supervisors = "the Benefactor, not that you're seeing them anytime soon"
	outfit_type = /singleton/hierarchy/outfit/job/wyrm/captain
	min_skill = list(
		SKILL_LITERACY = SKILL_ADEPT,
		SKILL_WEAPONS  = SKILL_ADEPT,
		SKILL_COMBAT   = SKILL_ADEPT,
		SKILL_SCIENCE  = SKILL_ADEPT,
		SKILL_PILOT    = SKILL_ADEPT
	)
	max_skill = list(
		SKILL_PILOT   = SKILL_MAX,
		SKILL_WEAPONS = SKILL_MAX
	)
	skill_points = 30
	head_position = 1
	department_flag = COM
	total_positions = 1
	spawn_positions = 1
	selection_color = "#1d1d4f"
	req_admin_notify = 1
	access = list()
	minimal_player_age = 14
	economic_power = 10
	ideal_character_age = 50
	//forced_spawnpoint = "Captain Compartment"

/datum/job/captain/get_access()
	return get_all_station_access()

/datum/job/hop
	title = "First Mate"
	supervisors = "the Captain"
	outfit_type = /singleton/hierarchy/outfit/job/wyrm/mate
	hud_icon = "hudheadofpersonnel"
	head_position = 1
	department_flag = COM|SUP
	total_positions = 1
	spawn_positions = 1
	selection_color = "#2f2f7f"
	req_admin_notify = 1
	minimal_player_age = 14
	economic_power = 10
	ideal_character_age = 40
	access = list(
		access_security,
		access_sec_doors,
		access_brig,
		access_forensics_lockers,
		access_heads,
		access_medical,
		access_engine,
		access_change_ids,
		access_ai_upload,
		access_eva,
		access_bridge,
		access_all_personal_lockers,
		access_maint_tunnels,
		access_janitor,
		access_construction,
		access_morgue,
		access_crematorium,
		access_kitchen,
		access_cargo,
		access_cargo_bot,
		access_mailsorting,
		access_qm,
		access_hydroponics,
		access_lawyer,
		access_chapel_office,
		access_library,
		access_research,
		access_mining,
		access_heads_vault,
		access_mining_station,
		access_hop,
		access_RC_announce,
		access_keycard_auth,
		access_gateway
	)
	min_skill = list(
		SKILL_LITERACY = SKILL_ADEPT,
		SKILL_WEAPONS  = SKILL_ADEPT,
		SKILL_COMBAT   = SKILL_ADEPT,
		SKILL_FINANCE  = SKILL_EXPERT,
		SKILL_PILOT    = SKILL_ADEPT
	)
	max_skill = list(
		SKILL_PILOT =   SKILL_MAX,
		SKILL_FINANCE = SKILL_MAX
	)
	skill_points = 30
	alt_titles = list()

/datum/job/hos
	title = "Security Officer"
	supervisors = "the Captain"
	total_positions = 1
	spawn_positions = 1
	selection_color = "#2f45c4"
	hud_icon = "hudheadofsecurity"
	head_position = 1
	req_admin_notify = 1
	minimal_player_age = 14
	economic_power = 10
	ideal_character_age = 40
	outfit_type = /singleton/hierarchy/outfit/job/wyrm/hos
	department_flag = COM
	max_skill = list(
		SKILL_WEAPONS   = SKILL_MAX,
		SKILL_COMBAT    = SKILL_MAX,
		SKILL_FORENSICS = SKILL_MAX
	)
	access = list(
		access_security,
		access_sec_doors,
		access_hos,
		access_armory,
		access_brig,
		access_bridge,
		access_medical,
		access_engine,
		access_ai_upload,
		access_eva,
		access_heads,
		access_all_personal_lockers,
		access_maint_tunnels,
		access_construction,
		access_morgue,
		access_cargo,
		access_mailsorting,
		access_qm,
		access_research,
		access_RC_announce,
		access_keycard_auth
	)
