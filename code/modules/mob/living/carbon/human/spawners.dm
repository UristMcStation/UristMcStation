
/obj/effect/spawner/carbon/human
	var/species = SPECIES_HUMAN
	var/new_name
	var/new_gender
	var/hair_style           // Regular name
	var/list/skin_color      // RGB
	var/list/tone
	var/list/eye_color       // RGB
	var/list/hair_color      // RGB
	var/clothing             // /decl/hierarchy/outfit
	var/rank
	var/assignment
	var/killed
	var/list/damage

/obj/effect/spawner/carbon/human/New()
	..()
	var/mob/living/carbon/human/H = new /mob/living/carbon/human(src.loc)
	var/datum/species/real_species = all_species[species]
	H.set_species(species)

	if(new_gender)
		H.change_gender(new_gender)
	else
		var/rand_gender = pick("male","female")
		H.change_gender(rand_gender)

	if(hair_style)
		if(!H.change_hair(hair_style))
			log_debug("Invalid hairstyle [hair_style].")
			H.reset_hair()
	else
		H.reset_hair()

	if(new_name)
		H.real_name = new_name
	else
		H.real_name = real_species.get_random_name(H.gender)

	if(tone)
		if(tone.len > 1)
			var/rand_tone = pick(tone)
			H.change_skin_tone(rand_tone)
		else
			H.change_skin_tone(tone)
	else if(skin_color) //TODO: Three-dimensional array for random alien skin coloring
		H.change_skin_color(skin_color[1],skin_color[2],skin_color[3])

	if(eye_color)
		H.change_eye_color(eye_color[1],eye_color[2],eye_color[3])

	if(hair_color)
		H.change_hair_color(hair_color[1],hair_color[2],hair_color[3])

	if(clothing)
		var/decl/hierarchy/outfit/O = outfit_by_type(clothing)
		O.equip(H)

	if(killed)
		H.setBrainLoss(200)

	if(damage)
		if(damage["damage_all"])
			for(var/obj/item/organ/external/O in H.organs_by_name)
				O.take_damage(damage["damage_all"])
		else
			for(var/limb in damage)
				var/obj/item/organ/external/O = H.organs_by_name[limb]
				O.take_damage(damage[limb])

	qdel(src)

//Humans

/obj/effect/spawner/carbon/human/grayson/miner
	clothing = /decl/hierarchy/outfit/grayson/miner

/obj/effect/spawner/carbon/human/grayson/miner/crystal
	killed = TRUE
	damage = list("damage_all" = 25)

/obj/effect/spawner/carbon/human/grayson/miner/brokenarm
	damage = list("r_arm" = 35)

//Vox

/obj/effect/spawner/carbon/human/vox
	species = SPECIES_VOX

//Skrell castes

/obj/effect/spawner/carbon/human/skrell
	species = SPECIES_SKRELL
	var/list/caste_colors

/obj/effect/spawner/carbon/human/skrell/New()
	if(caste_colors)
		var/caste = pick(caste_colors)
		caste[1] += rand(-5,5)
		caste[2] += rand(-5,5)
		caste[3] += rand(-5,5)
		skin_color = list(caste[1],caste[2],caste[3])
		hair_color = list(caste[1],caste[2],caste[3])
	..()

/obj/effect/spawner/carbon/human/skrell/katish
	caste_colors = list(1 = list(51, 153, 51))

/obj/effect/spawner/carbon/human/skrell/malish
	caste_colors = list(1 = list(0, 153, 255), 2 = list(51, 153, 102), 3 = list(128, 128, 0))

/obj/effect/spawner/carbon/human/skrell/malish/veymed
	clothing = /decl/hierarchy/outfit/veymed

/obj/effect/spawner/carbon/human/skrell/kanin
	caste_colors = list(1 = list(153, 102, 0), 2 = list(153, 0, 0), 3 = list(128, 128, 0), 4 = list(0, 0, 0))

/obj/effect/spawner/carbon/human/skrell/talum //Worst caste
	caste_colors = list(1 = list(102, 0, 255), 2 = list(51, 102, 255), 3 = list(153, 0, 204), 4 = list(150, 150, 150))


//Unathi clans

/obj/effect/spawner/carbon/human/unathi
	species = SPECIES_UNATHI

//Teshari

/obj/effect/spawner/carbon/human/teshari
	species = SPECIES_RESOMI

//IPCs/Synths

/obj/effect/spawner/carbon/human/machine
//	species = SPECIES_MACHINE
