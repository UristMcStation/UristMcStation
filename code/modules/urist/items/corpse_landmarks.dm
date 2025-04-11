//corpse landmarks

//pirate corpses

/obj/landmark/corpse/newpirate
	spawn_flags = CORPSE_SPAWNER_RANDOM_NAME | CORPSE_SPAWNER_CUT_ID_PDA | CORPSE_SPAWNER_CUT_SURVIVAL

/obj/landmark/corpse/newpirate/laser
	name = "New Pirate - Laser"
	corpse_outfits = list(/singleton/hierarchy/outfit/newpirate)

/obj/landmark/corpse/newpirate/laser/elite
	name = "New Pirate - Laser Elite"
	corpse_outfits = list(/singleton/hierarchy/outfit/newpirate/elite)

/obj/landmark/corpse/newpirate/melee
	name = "New Pirate - Melee"
	corpse_outfits = list(/singleton/hierarchy/outfit/newpirate/melee)

/obj/landmark/corpse/newpirate/ballistic
	name = "New Pirate - Ballistic"
	corpse_outfits = list(/singleton/hierarchy/outfit/newpirate/ballistic)

/obj/landmark/corpse/newpirate/ballistic/space
	name = "New Pirate - Ballistic Space"
	corpse_outfits = list(/singleton/hierarchy/outfit/newpirate/ballistic/space)

//terran corpses

/obj/landmark/corpse/terran
	spawn_flags = CORPSE_SPAWNER_RANDOM_NAME | CORPSE_SPAWNER_CUT_ID_PDA | CORPSE_SPAWNER_CUT_SURVIVAL

/obj/landmark/corpse/terran/marine
	name = "Terran Marine"
	corpse_outfits = list(/singleton/hierarchy/outfit/terranmarine)

/obj/landmark/corpse/terran/marinespace
	name = "Terran Marine - Space"
	corpse_outfits = list(/singleton/hierarchy/outfit/terranmarine/space)

/obj/landmark/corpse/terran/officer
	name = "Terran Officer"
	corpse_outfits = list(/singleton/hierarchy/outfit/terranmarine/officer)


/obj/landmark/corpse/terran/marine_ground
	name = "Terran Marine - Ground Assault"
	corpse_outfits = list(/singleton/hierarchy/outfit/terranmarine/ground)

/obj/landmark/corpse/terran/marine_ground_space
	name = "Terran Marine - Ground Assault EVA"
	corpse_outfits = list(/singleton/hierarchy/outfit/terranmarine/groundspace)

/obj/landmark/corpse/terran/marine_ground_officer
	name = "Terran Officer - Ground Assault"
	corpse_outfits = list(/singleton/hierarchy/outfit/terranmarine/groundofficer)
