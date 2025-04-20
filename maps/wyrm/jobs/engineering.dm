/datum/job/engineer
	title = "Junior Engineer"
	supervisors = "the Head Engineer"
	total_positions = 2
	spawn_positions = 2
	hud_icon = "hudengineer"
	outfit_type = /singleton/hierarchy/outfit/job/wyrm/hand/engine
	department_flag = ENG
	selection_color = "#5b4d20"
	minimal_player_age = 7
	access = list(
		access_eva,
		access_engine,
		access_engine_equip,
		access_tech_storage,
		access_maint_tunnels,
		access_external_airlocks,
		access_construction,
		access_atmospherics,
		access_emergency_storage
	)
	min_skill = list(
		SKILL_LITERACY     = SKILL_ADEPT,
		SKILL_COMPUTER     = SKILL_BASIC,
		SKILL_EVA          = SKILL_BASIC,
		SKILL_CONSTRUCTION = SKILL_ADEPT,
		SKILL_ELECTRICAL   = SKILL_BASIC,
		SKILL_ATMOS        = SKILL_BASIC,
		SKILL_ENGINES      = SKILL_BASIC,
		SKILL_WEAPONS      = SKILL_ADEPT,
		SKILL_COMBAT       = SKILL_ADEPT
	)
	max_skill = list(
		SKILL_CONSTRUCTION = SKILL_MAX,
		SKILL_ELECTRICAL   = SKILL_MAX,
		SKILL_ATMOS        = SKILL_MAX,
		SKILL_ENGINES      = SKILL_MAX
	)
	skill_points = 20
	alt_titles = list(
		"Engine Specialist",
		"Atmospherics Technician"
	)

/datum/job/engineer/head
	title = "Head Engineer"
	head_position = 1
	department_flag = ENG|COM
	total_positions = 1
	spawn_positions = 1
	outfit_type = /singleton/hierarchy/outfit/job/wyrm/chief_engineer
	selection_color = "#7f6e2c"
	req_admin_notify = 1
	economic_power = 10
	ideal_character_age = 50
	access = list(
		access_engine,
		access_engine_equip,
		access_tech_storage,
		access_maint_tunnels,
		access_heads,
		access_teleporter,
		access_external_airlocks,
		access_atmospherics,
		access_emergency_storage,
		access_eva,
		access_bridge,
		access_construction, access_sec_doors,
		access_ce,
		access_RC_announce,
		access_keycard_auth,
		access_tcomsat,
		access_ai_upload
	)
	minimal_player_age = 14
	supervisors = "the Captain"
	min_skill = list(
		SKILL_LITERACY     = SKILL_ADEPT,
		SKILL_COMPUTER     = SKILL_ADEPT,
		SKILL_EVA          = SKILL_ADEPT,
		SKILL_CONSTRUCTION = SKILL_ADEPT,
		SKILL_ELECTRICAL   = SKILL_ADEPT,
		SKILL_ATMOS        = SKILL_ADEPT,
		SKILL_WEAPONS      = SKILL_ADEPT,
		SKILL_COMBAT       = SKILL_ADEPT,
		SKILL_ENGINES      = SKILL_EXPERT
	)
	max_skill = list(
		SKILL_CONSTRUCTION = SKILL_MAX,
		SKILL_ELECTRICAL   = SKILL_MAX,
		SKILL_ATMOS        = SKILL_MAX,
		SKILL_ENGINES      = SKILL_MAX
	)
	skill_points = 30
	alt_titles = list()
