/decl/hierarchy/outfit/nanotrasen
	hierarchy_type = /decl/hierarchy/outfit/nanotrasen
	uniform = /obj/item/clothing/under/rank/centcom
	shoes = /obj/item/clothing/shoes/laceup
	gloves = /obj/item/clothing/gloves/white
	l_ear = /obj/item/device/radio/headset/heads/hop
	glasses = /obj/item/clothing/glasses/sunglasses

	id_slot = slot_wear_id
	id_type = /obj/item/weapon/card/id/centcom/station
	pda_slot = slot_r_store
	pda_type = /obj/item/device/pda/heads

/decl/hierarchy/outfit/nanotrasen/representative
	name = "Nanotrasen representative"
	belt = /obj/item/weapon/clipboard
	id_pda_assignment = "NanoTrasen Navy Representative"

/decl/hierarchy/outfit/nanotrasen/officer
	name = "Nanotrasen officer"
	head = /obj/item/clothing/head/beret/centcom/officer
	l_ear = /obj/item/device/radio/headset/heads/captain
	belt = /obj/item/weapon/gun/energy/gun/small
	id_pda_assignment = "NanoTrasen Navy Officer"

/decl/hierarchy/outfit/nanotrasen/captain
	name = "Nanotrasen captain"
	uniform = /obj/item/clothing/under/rank/centcom_captain
	l_ear = /obj/item/device/radio/headset/heads/captain
	head = /obj/item/clothing/head/beret/centcom/captain
	belt = /obj/item/weapon/gun/energy/gun/small
	id_pda_assignment = "NanoTrasen Navy Captain"

/decl/hierarchy/outfit/nanotrasensci
	name = "Nanotrasen scientist"
	uniform = /obj/item/clothing/under/rank/scientist/nt
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/nt
	shoes = /obj/item/clothing/shoes/white
	back = /obj/item/weapon/storage/backpack/nt
	l_ear = /obj/item/device/radio/headset/headset_sci

/decl/hierarchy/outfit/nanotrasensci/loot
	backpack_contents = list(/obj/random/material, /obj/random/material, /obj/random/material, /obj/random/loot)

/decl/hierarchy/outfit/nanotrasensci/exec
	name = "Nanotrasen senior scientist"
	uniform = /obj/item/clothing/under/rank/scientist/executive
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/rd
	gloves = /obj/item/clothing/gloves/white

/decl/hierarchy/outfit/nanotrasensci/exec/armed
	backpack_contents = list(/obj/random/energy, /obj/item/weapon/archaeological_find)