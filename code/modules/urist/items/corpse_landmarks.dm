//corpse landmarks

//pirate corpses

/obj/effect/landmark/corpse/newpirate
	spawn_flags = CORPSE_SPAWNER_RANDOM_NAME | CORPSE_SPAWNER_CUT_ID_PDA | CORPSE_SPAWNER_CUT_SURVIVAL

/obj/effect/landmark/corpse/newpirate/laser
	name = "New Pirate - Laser"
	corpse_outfits = list(/decl/hierarchy/outfit/newpirate)

/obj/effect/landmark/corpse/newpirate/melee
	name = "New Pirate - Melee"
	corpse_outfits = list(/decl/hierarchy/outfit/newpirate/melee)

/obj/effect/landmark/corpse/newpirate/ballistic
	name = "New Pirate - Ballistic"
	corpse_outfits = list(/decl/hierarchy/outfit/newpirate/ballistic)

//terran corpses

/obj/effect/landmark/corpse/terran
	spawn_flags = CORPSE_SPAWNER_RANDOM_NAME | CORPSE_SPAWNER_CUT_ID_PDA | CORPSE_SPAWNER_CUT_SURVIVAL

/obj/effect/landmark/corpse/terran/marine
	name = "Terran Marine"
	corpse_outfits = list(/decl/hierarchy/outfit/terranmarine)

/obj/effect/landmark/corpse/terran/marinespace
	name = "Terran Marine - Space"
	corpse_outfits = list(/decl/hierarchy/outfit/terranmarine/space)

/obj/effect/landmark/corpse/terran/officer
	name = "Terran Officer"
	corpse_outfits = list(/decl/hierarchy/outfit/terranmarine/officer)


/obj/effect/landmark/corpse/terran/marine_ground
	name = "Terran Marine - Ground Assault"
	corpse_outfits = list(/decl/hierarchy/outfit/terranmarine/ground)

/obj/effect/landmark/corpse/terran/marine_ground_space
	name = "Terran Marine - Ground Assault EVA"
	corpse_outfits = list(/decl/hierarchy/outfit/terranmarine/groundspace)

/obj/effect/landmark/corpse/terran/marine_ground_officer
	name = "Terran Officer - Ground Assault"
	corpse_outfits = list(/decl/hierarchy/outfit/terranmarine/groundofficer)