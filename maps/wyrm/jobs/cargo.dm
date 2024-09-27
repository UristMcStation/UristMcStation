/datum/job/logistics
	title = "Supply Tech"
	supervisors = "the First Mate"
	total_positions = 2
	spawn_positions = 2
	hud_icon = "hudcargotechnician"
	outfit_type = /singleton/hierarchy/outfit/job/wyrm/logistics
	department_flag = SUP
	selection_color = COLOR_BROWN
	access = list(
		access_maint_tunnels,
		access_external_airlocks,
		access_cargo,
		access_cargo_bot,
		access_eva,
		access_mailsorting,
		access_mining,
		access_mining_office,
		access_mining_station,
		access_emergency_storage
	)
	min_skill = list(
		SKILL_LITERACY     = SKILL_BASIC,
		SKILL_COMPUTER     = SKILL_BASIC,
		SKILL_EVA          = SKILL_ADEPT,
		SKILL_HAULING      = SKILL_ADEPT,
		SKILL_FINANCE      = SKILL_ADEPT,
		SKILL_WEAPONS      = SKILL_ADEPT,
		SKILL_COMBAT       = SKILL_ADEPT,
		SKILL_MECH         = HAS_PERK
	)
	max_skill = list(
		SKILL_FINANCE      = SKILL_MAX,
		SKILL_ELECTRICAL   = SKILL_MAX,
		SKILL_ATMOS        = SKILL_MAX,
		SKILL_ENGINES      = SKILL_MAX
	)
	skill_points = 20

/datum/job/logistics/salvage
	title = "Salvage Tech"
	supervisors = "the reseachers and the First Mate"
	hud_icon = "hudscientist"
	total_positions = 1
	spawn_positions = 1
	outfit_type = /singleton/hierarchy/outfit/job/wyrm/salvage
	department_flag = SUP|SCI
	selection_color = "#9c8443"
	min_skill = list(
		SKILL_LITERACY =     SKILL_ADEPT,
		SKILL_DEVICES  =     SKILL_BASIC,
		SKILL_EVA      =     SKILL_BASIC,
		SKILL_CONSTRUCTION = SKILL_ADEPT,
		SKILL_HAULING  =     SKILL_ADEPT,
		SKILL_WEAPONS  =     SKILL_ADEPT,
		SKILL_COMBAT   =     SKILL_ADEPT
	)
	max_skill = list(
		SKILL_DEVICES      = SKILL_MAX,
		SKILL_CONSTRUCTION = SKILL_MAX
	)
	access = list(
		access_research,
		access_xenoarch,
		access_maint_tunnels,
		access_external_airlocks,
		access_cargo,
		access_cargo_bot,
		access_eva
	)
