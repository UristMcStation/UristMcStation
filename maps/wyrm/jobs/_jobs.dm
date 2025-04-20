/datum/job/cyborg
	supervisors = "your laws and the Captain"
	total_positions = 1
	spawn_positions = 1
	alt_titles = list()

/datum/job/assistant
	title = "Assistant"
	supervisors = "the First Mate, if they ever asked"
	outfit_type = /singleton/hierarchy/outfit/job/wyrm/hand
	alt_titles = list(
		"Cook" = /singleton/hierarchy/outfit/job/wyrm/hand/cook,
		"Librarian" = /singleton/hierarchy/outfit/job/wyrm/librarian,
		"Journalist" = /singleton/hierarchy/outfit/job/wyrm/journalist,
		"Clown",
		"Mime")
	hud_icon = "hudcargotechnician"
	access = list(
		access_eva,
		access_maint_tunnels
	)
