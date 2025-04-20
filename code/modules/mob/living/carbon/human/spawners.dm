
/*/obj/spawner/carbon/human
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x"
	invisibility = 0
	var/species = SPECIES_HUMAN
	var/language = LANGUAGE_GALCOM
	var/new_name
	var/new_gender
	var/hair_style           // /datum/sprite_accessory/hair name var
	var/facial_hair          // /datum/sprite_accessory/facial_hair
	var/list/tone = "RAND"   // 0-255, multiple leads to randomized
	var/list/skin_color      // RGB
	var/list/eye_color       // RGB
	var/list/hair_color = "RAND" // RGB
	var/clothing             // /singleton/hierarchy/outfit
	var/rank                 // Outfit rank
	var/assignment           // Outfit assignment
	var/killed               // Brain dead on spawn
	var/list/damage          // Use BP defines = damage
	var/post_setup           // Do everything except qdel self

	var/mob/living/carbon/human/H

/obj/spawner/carbon/human/Initialize()
	. = ..()
	H = new /mob/living/carbon/human(loc)
	H.set_dir(dir)
	H.set_species(species)

	var/datum/language/L = all_languages[language]

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

	if(facial_hair)
		if(!H.change_facial_hair(facial_hair))
			log_debug("Invalid facial hair [facial_hair]")

	if(new_name)
		H.real_name = new_name
	else
		H.real_name = L.get_random_name(H.gender)

	if(tone && !skin_color)
		if(tone == "RAND")
			H.change_skin_tone(random_skin_tone())
		else if(islist(tone) && length(tone) >= 1)
			var/rand_tone = pick(tone)
			H.change_skin_tone(rand_tone)

	else if(skin_color) //TODO: Three-dimensional array for random alien skin coloring
		H.change_skin_color(skin_color[1],skin_color[2],skin_color[3])

	if(eye_color)
		H.change_eye_color(eye_color[1],eye_color[2],eye_color[3])

	if(hair_color)
		if(hair_color == "RAND")
			var/singleton/species/target_species = all_species[species]
			hair_color = target_species.get_random_hair_color()
		H.change_hair_color(hair_color[1],hair_color[2],hair_color[3])
		H.change_facial_hair_color(hair_color[1],hair_color[2],hair_color[3])

	if(clothing)
		var/singleton/hierarchy/outfit/O = outfit_by_type(clothing)
		O.equip(H)

	if(killed)
		H.setBrainLoss(H.maxHealth)

	if(damage)
		if(damage["damage_all_brute"] || damage["damage_all_burn"])
			H.take_overall_damage(damage["damage_all_brute"], damage["damage_all_burn"])
		else
			for(var/limb in damage)
				var/obj/item/organ/external/O = H.organs_by_name[limb]
				if(O)
					O.take_external_damage(damage[limb])

		if(damage["impale"])
			var/turf/T = H.near_wall(dir,2)
			var/obj/item/organ/external/E = H.organs_by_name[damage["impale"]]
			if(T && E && length(E.wounds))
				var/obj/item/arrow/rod/R = new(H)
				H.set_dir(GLOB.reverse_dir[dir])
				H.loc = T
				H.anchored = TRUE
				H.pinned += R
				var/datum/wound/W = E.wounds[1]
				W.embedded_objects += R

	var/turf/T = get_turf(src)
	var/obj/structure/bed/B = locate() in T.contents
	if(B in T.contents)
		B.buckle_mob(H)

	if(!post_setup)
		qdel(src)*/

//Humans

/obj/landmark/corpse/graysonminer
	corpse_outfits = list(/singleton/hierarchy/outfit/grayson/miner)
	damage = list("damage_all_brute" = 50, "damage_all_burn" = 0)

/obj/landmark/corpse/graysonminer/brokenarm
	damage = list("r_arm" = 35)

/obj/landmark/corpse/pcrc
	corpse_outfits = list(/singleton/hierarchy/outfit/pcrc)

/obj/landmark/corpse/patient
	corpse_outfits = list(/singleton/hierarchy/outfit/patient)

/obj/landmark/corpse/vaultrich
	corpse_outfits = list(/singleton/hierarchy/outfit/vaultrich)

//Nanotrasen

/obj/landmark/corpse/nt
	corpse_outfits = list(/singleton/hierarchy/outfit/nanotrasensci)

/obj/landmark/corpse/nt/hurt
	damage = list("damage_all_brute" = 50, "damage_all_burn" = 50)

/obj/landmark/corpse/nt/hurt/loot
	corpse_outfits = list(/singleton/hierarchy/outfit/nanotrasensci/loot)

/obj/landmark/corpse/nt/exec
	corpse_outfits = list(/singleton/hierarchy/outfit/nanotrasensci/exec)

/obj/landmark/corpse/nt/exec/armed
	corpse_outfits = list(/singleton/hierarchy/outfit/nanotrasensci/exec/armed)

//Vox

/obj/landmark/corpse/vox
	species = list(SPECIES_VOX)

/obj/landmark/corpse/vox/robed
	corpse_outfits = list(/singleton/hierarchy/outfit/vox/robes)

/obj/landmark/corpse/vox/medic
	corpse_outfits = list(/singleton/hierarchy/outfit/vox/medic)

/obj/landmark/corpse/vox/stealth
	corpse_outfits = list(/singleton/hierarchy/outfit/vox/stealth)

/obj/landmark/corpse/vox/assault
	corpse_outfits = list(/singleton/hierarchy/outfit/vox/assault)

//Skrell castes

/obj/landmark/corpse/skrell
	species = list(SPECIES_SKRELL)
	//var/list/caste_colors

/*/obj/landmark/corpse/skrell/Initialize()
	if(caste_colors)
		var/caste = pick(caste_colors)
		caste[1] += rand(-7,7)
		caste[2] += rand(-7,7)
		caste[3] += rand(-7,7)
		skin_color = list(caste[1],caste[2],caste[3])
		hair_color = list(caste[1],caste[2],caste[3])
	. = ..()*/

/obj/landmark/corpse/skrell/katish
	skin_colors_per_species = list(SPECIES_SKRELL = list(51, 153, 51))

/obj/landmark/corpse/skrell/malish
	skin_colors_per_species = list(SPECIES_SKRELL = list(0, 153, 255))

/obj/landmark/corpse/skrell/malish/veymed
	corpse_outfits = list(/singleton/hierarchy/outfit/veymed)

/obj/landmark/corpse/skrell/malish/veymed/head
	corpse_outfits = list(/singleton/hierarchy/outfit/veymed/head)

/obj/landmark/corpse/skrell/kanin
	skin_colors_per_species = list(SPECIES_SKRELL = list(153, 102, 0))

/obj/landmark/corpse/skrell/talum //Worst caste
	skin_colors_per_species = list(SPECIES_SKRELL = list(102, 0, 255))

//Unathi clans

/obj/landmark/corpse/unathi
	species = list(SPECIES_UNATHI)

//Teshari

/obj/landmark/corpse/teshari
	species = list(SPECIES_RESOMI)

//Diona

/obj/landmark/corpse/diona
	species = list(SPECIES_DIONA)

//IPCs/Synths

//Spawner Outfits

/singleton/hierarchy/outfit/nanotrasensci
	name = "Nanotrasen scientist"
	uniform = /obj/item/clothing/under/rank/scientist
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/science/nanotrasen
	shoes = /obj/item/clothing/shoes/white
	back = /obj/item/storage/backpack/corpsci
	l_ear = /obj/item/device/radio/headset/headset_sci

/singleton/hierarchy/outfit/nanotrasensci/loot
	name = "NT Scientist - Random Loot"
	backpack_contents = list(/obj/random/material, /obj/random/material, /obj/random/material, /obj/random/loot)

/singleton/hierarchy/outfit/nanotrasensci/exec
	name = "NT Senior Scientist"
	uniform = /obj/item/clothing/under/rank/scientist/executive
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/rd
	gloves = /obj/item/clothing/gloves/white

/singleton/hierarchy/outfit/nanotrasensci/exec/armed
	name = "NT Senior Scientist - Armed"
	backpack_contents = list(/obj/random/energy, /obj/item/archaeological_find)

/singleton/hierarchy/outfit/vaultrich
	name = "Banker"
	uniform = /obj/item/clothing/under/det/black
	shoes = /obj/item/clothing/shoes/laceup
	gloves = /obj/item/clothing/gloves/white
