
/obj/effect/spawner/carbon/human
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
	var/clothing             // /decl/hierarchy/outfit
	var/rank                 // Outfit rank
	var/assignment           // Outfit assignment
	var/killed               // Brain dead on spawn
	var/list/damage          // Use BP defines = damage
	var/post_setup           // Do everything except qdel self

	var/mob/living/carbon/human/H

/obj/effect/spawner/carbon/human/Initialize()
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
		else if(islist(tone) && tone.len >= 1)
			var/rand_tone = pick(tone)
			H.change_skin_tone(rand_tone)

	else if(skin_color) //TODO: Three-dimensional array for random alien skin coloring
		H.change_skin_color(skin_color[1],skin_color[2],skin_color[3])

	if(eye_color)
		H.change_eye_color(eye_color[1],eye_color[2],eye_color[3])

	if(hair_color)
		if(hair_color == "RAND")
			hair_color = random_hair_color()
		else
			H.change_hair_color(hair_color[1],hair_color[2],hair_color[3])
			H.change_facial_hair_color(hair_color[1],hair_color[2],hair_color[3])

	if(clothing)
		var/decl/hierarchy/outfit/O = outfit_by_type(clothing)
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
			if(T && E && E.wounds.len)
				var/obj/item/weapon/arrow/rod/R = new(H)
				H.set_dir(GLOB.reverse_dir[dir])
				H.loc = T
				H.anchored = 1
				H.pinned += R
				var/datum/wound/W = E.wounds[1]
				W.embedded_objects += R

	var/turf/T = get_turf(src)
	var/obj/structure/bed/B = locate() in T.contents
	if(B in T.contents)
		B.buckle_mob(H)

	if(!post_setup)
		qdel(src)

//Humans

/obj/effect/spawner/carbon/human/grayson/miner
	clothing = /decl/hierarchy/outfit/grayson/miner

/obj/effect/spawner/carbon/human/grayson/miner/crystal
	killed = TRUE
	damage = list("damage_all_brute" = 50, "damage_all_burn" = 0)

/obj/effect/spawner/carbon/human/grayson/miner/brokenarm
	damage = list("r_arm" = 35)

/obj/effect/spawner/carbon/human/virus
	post_setup = TRUE
	var/severity = 3

/obj/effect/spawner/carbon/human/virus/Initialize()
	. = ..()
	var/datum/disease2/disease/V = new /datum/disease2/disease
	V.makerandom(severity)
	infect_virus2(H,V,1)
	qdel(src)

/obj/effect/spawner/carbon/human/pcrc
	clothing = /decl/hierarchy/outfit/pcrc

/obj/effect/spawner/carbon/human/patient
	clothing = /decl/hierarchy/outfit/patient

/obj/effect/spawner/carbon/human/vaultrich
	killed = TRUE
	clothing = /decl/hierarchy/outfit/vaultrich

//Nanotrasen

/obj/effect/spawner/carbon/human/virus/ntsci
	clothing = /decl/hierarchy/outfit/nanotrasensci

/obj/effect/spawner/carbon/human/nt
	clothing = /decl/hierarchy/outfit/nanotrasensci

/obj/effect/spawner/carbon/human/nt/hurt
	damage = list("damage_all_brute" = 50, "damage_all_burn" = 50)

/obj/effect/spawner/carbon/human/nt/hurt/loot
	clothing = /decl/hierarchy/outfit/nanotrasensci/loot

/obj/effect/spawner/carbon/human/nt/exec
	clothing = /decl/hierarchy/outfit/nanotrasensci/exec

/obj/effect/spawner/carbon/human/nt/exec/armed
	clothing = /decl/hierarchy/outfit/nanotrasensci/exec/armed

//Vox

/obj/effect/spawner/carbon/human/vox
	species = SPECIES_VOX
	hair_color = list()

/obj/effect/spawner/carbon/human/vox/robed
	clothing = /decl/hierarchy/outfit/vox/robes

/obj/effect/spawner/carbon/human/vox/medic
	clothing = /decl/hierarchy/outfit/vox/medic

/obj/effect/spawner/carbon/human/vox/stealth
	clothing = /decl/hierarchy/outfit/vox/stealth

/obj/effect/spawner/carbon/human/vox/assault
	clothing = /decl/hierarchy/outfit/vox/assault

//Skrell castes

/obj/effect/spawner/carbon/human/skrell
	species = SPECIES_SKRELL
	var/list/caste_colors

/obj/effect/spawner/carbon/human/skrell/Initialize()
	if(caste_colors)
		var/caste = pick(caste_colors)
		caste[1] += rand(-7,7)
		caste[2] += rand(-7,7)
		caste[3] += rand(-7,7)
		skin_color = list(caste[1],caste[2],caste[3])
		hair_color = list(caste[1],caste[2],caste[3])
	. = ..()

/obj/effect/spawner/carbon/human/skrell/katish
	caste_colors = list(1 = list(51, 153, 51))

/obj/effect/spawner/carbon/human/skrell/malish
	caste_colors = list(1 = list(0, 153, 255), 2 = list(51, 153, 102), 3 = list(128, 128, 0))

/obj/effect/spawner/carbon/human/skrell/malish/veymed
	clothing = /decl/hierarchy/outfit/veymed

/obj/effect/spawner/carbon/human/skrell/malish/veymed/head
	clothing = /decl/hierarchy/outfit/veymed/head

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

//Diona

/obj/effect/spawner/carbon/human/diona
	species = SPECIES_DIONA

//IPCs/Synths

//Spawner Outfits

/decl/hierarchy/outfit/nanotrasensci
	name = "Nanotrasen scientist"
	uniform = /obj/item/clothing/under/rank/scientist
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/science/nanotrasen
	shoes = /obj/item/clothing/shoes/white
	back = /obj/item/weapon/storage/backpack/nt
	l_ear = /obj/item/device/radio/headset/headset_sci

/decl/hierarchy/outfit/nanotrasensci/loot
	name = "NT Scientist - Random Loot"
	backpack_contents = list(/obj/random/material, /obj/random/material, /obj/random/material, /obj/random/loot)

/decl/hierarchy/outfit/nanotrasensci/exec
	name = "NT Senior Scientist"
	uniform = /obj/item/clothing/under/rank/scientist/executive
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/rd
	gloves = /obj/item/clothing/gloves/white

/decl/hierarchy/outfit/nanotrasensci/exec/armed
	name = "NT Senior Scientist - Armed"
	backpack_contents = list(/obj/random/energy, /obj/item/weapon/archaeological_find)

/decl/hierarchy/outfit/vaultrich
	name = "Banker"
	uniform = /obj/item/clothing/under/det/black
	shoes = /obj/item/clothing/shoes/laceup
	gloves = /obj/item/clothing/gloves/white
