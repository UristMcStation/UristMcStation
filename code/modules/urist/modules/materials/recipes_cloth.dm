/material/cloth/generate_recipes(var/reinforce_material)
	..()

	recipes += new/datum/stack_recipe/makeshiftbandage(src)
	recipes += new/datum/stack_recipe/makeshiftmask(src)
	recipes += new/datum/stack_recipe/rag(src)
	recipes += new/datum/stack_recipe/bedsheet(src)
	recipes += new/datum/stack_recipe/footwraps(src)
	recipes += new/datum/stack_recipe/gloves(src)
	recipes += new/datum/stack_recipe/taqiyah(src)
	recipes += new/datum/stack_recipe/turban(src)
	recipes += new/datum/stack_recipe/hijab(src)
	recipes += new/datum/stack_recipe/kippa(src)
	recipes += new/datum/stack_recipe/scarf(src)
	recipes += new/datum/stack_recipe/uniform(src)

/datum/stack_recipe/makeshiftbandage
	title = "makeshift bandage"
	result_type = /obj/item/stack/medical/bruise_pack/makeshift_bandage
	req_amount = 1
	time = 10

/datum/stack_recipe/makeshiftmask
	title = "makeshift mask"
	result_type = /obj/item/clothing/mask/surgical/makeshift_mask
	req_amount = 1
	time = 10

/datum/stack_recipe/rag
	title = "rag"
	result_type = /obj/item/weapon/reagent_containers/glass/rag
	req_amount = 1
	time = 5

/datum/stack_recipe/bedsheet
	title = "bedsheet"
	result_type = /obj/item/weapon/bedsheet
	req_amount = 3
	time = 15

/datum/stack_recipe/footwraps
	title = "foot wraps"
	result_type = /obj/item/clothing/shoes/urist/footwraps
	req_amount = 2
	time = 10

/datum/stack_recipe/gloves
	title = "gloves"
	result_type = /obj/item/clothing/gloves/white
	req_amount = 2
	time = 10

/datum/stack_recipe/taqiyah
	title = "taqiyah"
	result_type = /obj/item/clothing/head/taqiyah
	req_amount = 2
	time = 6

/datum/stack_recipe/turban
	title = "turban"
	result_type = /obj/item/clothing/head/turban
	req_amount = 2
	time = 6

/datum/stack_recipe/hijab
	title = "hijab"
	result_type = /obj/item/clothing/head/hijab
	req_amount = 2
	time = 6

/datum/stack_recipe/kippa
	title = "kippa"
	result_type = /obj/item/clothing/head/kippa
	req_amount = 2
	time = 6

/datum/stack_recipe/scarf
	title = "scarf"
	result_type = /obj/item/clothing/accessory/scarf
	req_amount = 3
	time = 8

/datum/stack_recipe/uniform
	title = "uniform"
	result_type = /obj/item/clothing/under/color/white
	req_amount = 8
	time = 20