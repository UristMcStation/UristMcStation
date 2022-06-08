/material/leather/generate_recipes()
	recipes = list()

	recipes += new/datum/stack_recipe_list("holsters", list(
		new/datum/stack_recipe/holster/hip(src),
		new/datum/stack_recipe/holster/waist(src),
		new/datum/stack_recipe/holster/armpit(src)
		))
	recipes += new/datum/stack_recipe/toolbelt(src)
	recipes += new/datum/stack_recipe/briefcase(src)
	recipes += new/datum/stack_recipe/wallet(src)
	recipes += new/datum/stack_recipe/knifeharness(src)
	recipes += new/datum/stack_recipe/eyepatch(src)
	recipes += new/datum/stack_recipe/botanic_leather_gloves(src)
	recipes += new/datum/stack_recipe/leather_work_gloves(src)
	recipes += new/datum/stack_recipe/leather_shoes(src)
	recipes += new/datum/stack_recipe/jungle_boots(src)
	recipes += new/datum/stack_recipe/laceup_shoes(src)
	recipes += new/datum/stack_recipe/leather_boots(src)
	recipes += new/datum/stack_recipe/cowboy_hat(src)
	recipes += new/datum/stack_recipe/flatcap(src)
	recipes += new/datum/stack_recipe_list("coats", list( \
		new/datum/stack_recipe/coat/duster(src),
		new/datum/stack_recipe/coat/leather(src),
		new/datum/stack_recipe/coat/black_leather(src),
		new/datum/stack_recipe/coat/alt_black_leather(src),
		new/datum/stack_recipe/coat/nt_black_leather(src),
		new/datum/stack_recipe/coat/leather_trenchcoat(src),
		new/datum/stack_recipe/coat/brown_jacket(src),
		new/datum/stack_recipe/coat/nt_brown_jacket(src)
		))
	recipes += new/datum/stack_recipe/leather_sandsuit(src)
	recipes += new/datum/stack_recipe/leather_pants(src)
	recipes += new/datum/stack_recipe/leather_overalls(src)
	recipes += new/datum/stack_recipe/factory_apron(src)
	recipes += new/datum/stack_recipe/welder_apron(src)
	recipes += new/datum/stack_recipe/leather_mask(src)

/datum/stack_recipe/holster
	req_amount = 2
	time = 40

/datum/stack_recipe/holster/hip
	title = "hip holster"
	result_type = /obj/item/clothing/accessory/storage/holster/hip

/datum/stack_recipe/holster/waist
	title = "waist holster"
	result_type = /obj/item/clothing/accessory/storage/holster/waist

/datum/stack_recipe/holster/armpit
	title = "armpit holster"
	result_type = /obj/item/clothing/accessory/storage/holster/armpit

/datum/stack_recipe/toolbelt
	title = "tool belt"
	result_type = /obj/item/weapon/storage/belt/utility
	req_amount = 3
	time = 45

/datum/stack_recipe/briefcase
	title = "briefcase"
	result_type = /obj/item/weapon/storage/briefcase
	req_amount = 1
	time = 30

/datum/stack_recipe/wallet
	title = "leather wallet"
	result_type = /obj/item/weapon/storage/wallet/leather
	req_amount = 1
	time = 30

/datum/stack_recipe/knifeharness
	title = "knife harness"
	result_type = /obj/item/clothing/accessory/storage/knifeharness
	req_amount = 1
	time = 30

/datum/stack_recipe/eyepatch
	title = "eyepatch"
	result_type = /obj/item/clothing/glasses/eyepatch
	req_amount = 1
	time = 30

/datum/stack_recipe/botanic_leather_gloves
	title = "botanist leather gloves"
	result_type = /obj/item/clothing/gloves/botanic_leather
	req_amount = 2
	time = 40

/datum/stack_recipe/leather_work_gloves
	title = "leather work gloves"
	result_type = /obj/item/clothing/gloves/urist/leather
	req_amount = 3
	time = 45

/datum/stack_recipe/leather_shoes
	title = "leather shoes"
	result_type = /obj/item/clothing/shoes/leather
	req_amount = 2
	time = 30

/datum/stack_recipe/jungle_boots
	title = "jungle boots"
	result_type = /obj/item/clothing/shoes/jungleboots
	req_amount = 2
	time = 40

/datum/stack_recipe/laceup_shoes
	title = "laceup shoes"
	result_type = /obj/item/clothing/shoes/laceup
	req_amount = 2
	time = 30

/datum/stack_recipe/leather_boots
	title = "leather work gloves"
	result_type = /obj/item/clothing/shoes/urist/leather
	req_amount = 4
	time = 45

/datum/stack_recipe/cowboy_hat
	title = "cowboy hat"
	result_type = /obj/item/clothing/head/urist/cowboy
	req_amount = 2
	time = 35

/datum/stack_recipe/flatcap
	title = "flatcap"
	result_type = /obj/item/clothing/head/flatcap
	req_amount = 2
	time = 25

/datum/stack_recipe/coat
	req_amount = 4
	time = 45

/datum/stack_recipe/coat/duster
	title = "duster"
	result_type = /obj/item/clothing/suit/storage/urist/coat/duster
	req_amount = 5
	time = 50

/datum/stack_recipe/coat/leather
	title = "leather coat"
	result_type = /obj/item/clothing/suit/storage/urist/coat/leather
	req_amount = 5
	time = 50

/datum/stack_recipe/coat/black_leather
	title = "black leather jacket"
	result_type = /obj/item/clothing/suit/coat/jacket/leather

/datum/stack_recipe/coat/alt_black_leather
	title = "alternate black leather jacket"
	result_type = /obj/item/clothing/suit/storage/leather_jacket

/datum/stack_recipe/coat/nt_black_leather
	title = "NanoTrasen black leather jacket"
	result_type = /obj/item/clothing/suit/storage/leather_jacket/nanotrasen

/datum/stack_recipe/coat/leather_trenchcoat
	title = "leather trenchcoat"
	result_type = /obj/item/clothing/suit/leathercoat

/datum/stack_recipe/coat/brown_jacket
	title = "brown leather jacket"
	result_type = /obj/item/clothing/suit/storage/toggle/brown_jacket

/datum/stack_recipe/coat/nt_brown_jacket
	title = "NanoTrasen brown leather jacket"
	result_type = /obj/item/clothing/suit/storage/toggle/brown_jacket/nanotrasen

/datum/stack_recipe/leather_sandsuit
	title = "leather protective suit"
	result_type = /obj/item/clothing/suit/storage/hooded/sandsuit
	req_amount = 7
	time = 60

/datum/stack_recipe/leather_pants
	title = "leather pants"
	result_type = /obj/item/clothing/under/pants/urist/leatherpants
	req_amount = 2
	time = 35

/datum/stack_recipe/leather_overalls
	title = "leather overalls"
	result_type = /obj/item/clothing/suit/storage/urist/overalls/leather
	req_amount = 3
	time = 40

/datum/stack_recipe/factory_apron
	title = "factory worker's apron"
	result_type = /obj/item/clothing/suit/storage/urist/apron
	req_amount = 3
	time = 40

/datum/stack_recipe/welder_apron
	title = "welder apron"
	result_type = /obj/item/clothing/suit/urist/welderapron
	req_amount = 2
	time = 35

/datum/stack_recipe/leather_mask
	title = "leather mask"
	result_type = /obj/item/clothing/mask/urist/bandana/leather
	req_amount = 1
	time = 30
