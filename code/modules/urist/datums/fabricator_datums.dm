//datums for the autolathe

/datum/fabricator_recipe/voiceanalyser
	name = "voice analyser"
	path = /obj/item/device/assembly/voice
	category = "Devices and Components"

/datum/fabricator_recipe/scissors
	name = "scissors"
	path = /obj/item/scissors
	category = "General"

///obj/item/material/clipboard/matter = list("wood" = 30)

/datum/fabricator_recipe/clipboard
	name = "clipboard"
	path = /obj/item/material/clipboard
	category = "General"

/datum/fabricator_recipe/rollingpin
	name = "rolling pin"
	path = /obj/item/material/kitchen/rollingpin
	category = "General"

/obj/item/pickaxe/hand/matter = list(DEFAULT_WALL_MATERIAL = 1250, "wood" = 500)

/datum/fabricator_recipe/handpickaxe
	name = "hand pickaxe"
	path = /obj/item/pickaxe/hand
	category = "Tools"

/datum/fabricator_recipe/pickaxe
	name = "pickaxe"
	path = /obj/item/pickaxe/old
	category = "Tools"

/datum/fabricator_recipe/saw
	name = "hand saw"
	path = /obj/item/carpentry/saw
	category = "Tools"

/datum/fabricator_recipe/axe
	name = "wood axe"
	path = /obj/item/carpentry/axe
	category = "Tools"

/datum/fabricator_recipe/woodminihoe
	name = "wood minihoe"
	path = /obj/item/material/minihoe/wood
	category = "Tools"

/datum/fabricator_recipe/woodhatchet
	name = "wood handled hatchet"
	path = /obj/item/material/hatchet/wood
	category = "Tools"

/datum/fabricator_recipe/woodcup
	name = "wooden cup"
	path = /obj/item/reagent_containers/food/drinks/woodcup
	category = "General"

/datum/fabricator_recipe/wooddice
	name = "wooden d6"
	path = /obj/item/dice/wood
	category = "General"

/datum/fabricator_recipe/woodmop
	name = "wooden mop"
	path = /obj/item/mop/wood
	category = "Tools"

/datum/fabricator_recipe/woodspade
	name = "wood handled spade"
	path = /obj/item/shovel/spade/wood
	category = "Tools"

/datum/fabricator_recipe/shovel
	name = "shovel"
	path = /obj/item/shovel
	category = "Tools"

/datum/fabricator_recipe/cane
	name = "cane"
	path = /obj/item/cane
	category = "General"

/datum/fabricator_recipe/canesword
	name = "canesword"
	path = /obj/item/cane/concealed
	hidden = 1
	category = "Arms and Ammunition"

/datum/fabricator_recipe/magazine_556_stripper
	name = "hunting rifle ammo (5.56mm)"
	path = /obj/item/ammo_magazine/rifle/military/stripper
	category = "Arms and Ammunition"

/datum/fabricator_recipe/smithinghammer
	name = "smithing hammer"
	path = /obj/item/hammer/smithing
	category = "Tools"

/datum/fabricator_recipe/magazine_c20r_rubber
	name = "ammunition (10mm, rubber)"
	path = /obj/item/ammo_magazine/pistol/rubber
	hidden = 1
	category = "Arms and Ammunition"

/datum/fabricator_recipe/magazine_hi2521smg9mm
	name = "HI-2521 SMG ammo (7mm)"
	path = /obj/item/ammo_magazine/hi2521smg9mm
	hidden = 1
	category = "Arms and Ammunition"

/datum/fabricator_recipe/magazine_hi2521smg9mm_rubber
	name = "HI-2121 SMG ammo (7mm, rubber)"
	path = /obj/item/ammo_magazine/hi2521smg9mm/rubber
	category = "Arms and Ammunition"

//shipweapons

/datum/fabricator_recipe/torpedo_casing
	name = "torpedo casing"
	path = /obj/structure/shipammo/torpedo
	category = "Arms and Ammunition"

/datum/fabricator_recipe/light_autocannon_ap
	name = "light autocannon ammunition (armour-piercing)"
	path = /obj/structure/shipammo/light_autocannon/ap
	category = "Arms and Ammunition"

/datum/fabricator_recipe/light_autocannon_he
	name = "light autocannon ammunition (high-explosive)"
	path = /obj/structure/shipammo/light_autocannon/he
	category = "Arms and Ammunition"
