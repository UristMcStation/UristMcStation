/material/cloth/generate_recipes(reinforce_material)
	. = ..()
	if(reinforce_material)	//recipies below don't support composite materials
		return

	. += new/datum/stack_recipe/makeshiftbandage(src)
	. += new/datum/stack_recipe/makeshiftmask(src)
	. += new/datum/stack_recipe/rag(src)
	. += new/datum/stack_recipe/bedsheet(src)
	. += new/datum/stack_recipe/footwraps(src)
	. += new/datum/stack_recipe/gloves(src)
	. += new/datum/stack_recipe/taqiyah(src)
	. += new/datum/stack_recipe/turban(src)
	. += new/datum/stack_recipe/hijab(src)
	. += new/datum/stack_recipe/kippa(src)
	. += new/datum/stack_recipe/scarf(src)

	. += new/datum/stack_recipe/mummy(src)
//now with space magic dye included
	. += new/datum/stack_recipe_list("jumpsuits", list(
		new/datum/stack_recipe/jumpsuit/white(src),
		new/datum/stack_recipe/jumpsuit/black(src),
		new/datum/stack_recipe/jumpsuit/blackjumpshorts(src),
		new/datum/stack_recipe/jumpsuit/blackjumpskirt(src),
		new/datum/stack_recipe/jumpsuit/grey(src),
		new/datum/stack_recipe/jumpsuit/blue(src),
		new/datum/stack_recipe/jumpsuit/pink(src),
		new/datum/stack_recipe/jumpsuit/red(src),
		new/datum/stack_recipe/jumpsuit/green(src),
		new/datum/stack_recipe/jumpsuit/yellow(src),
		new/datum/stack_recipe/jumpsuit/lightpurple(src),
		new/datum/stack_recipe/jumpsuit/brown(src)
		))

	. += new/datum/stack_recipe_list("tunics", list(
		new/datum/stack_recipe/tunic/yellow(src),
		new/datum/stack_recipe/tunic/blue(src),
		new/datum/stack_recipe/tunic/red(src),
		new/datum/stack_recipe/tunic/white(src),
		new/datum/stack_recipe/tunic/red2(src),
		new/datum/stack_recipe/tunic/blue2(src),
		new/datum/stack_recipe/tunic/roman(src)
	))

	. += new/datum/stack_recipe_list("dresses", list(
		new/datum/stack_recipe/dress/green(src),
		new/datum/stack_recipe/dress/red(src),
		new/datum/stack_recipe/dress/blue(src),
		new/datum/stack_recipe/dress/brown(src)
	))

	. += new/datum/stack_recipe_list("shirt and trousers", list(
		new/datum/stack_recipe/shirt/black(src),
		new/datum/stack_recipe/shirt/red(src),
		new/datum/stack_recipe/shirt/red2(src),
		new/datum/stack_recipe/shirt/blue(src),
		new/datum/stack_recipe/shirt/baggy(src),
		new/datum/stack_recipe/shirt/tank(src)
	))

	. += new/datum/stack_recipe_list("capes", list(
		new/datum/stack_recipe/cape/black(src),
		new/datum/stack_recipe/cape/grey(src),
		new/datum/stack_recipe/cape/sec(src),
		new/datum/stack_recipe/cape/command(src),
		new/datum/stack_recipe/cape/med(src),
		new/datum/stack_recipe/cape/eng(src),
		new/datum/stack_recipe/cape/sci(src),
		new/datum/stack_recipe/cape/cargo(src),
		new/datum/stack_recipe/cape/green(src),
		new/datum/stack_recipe/cape/indigo(src),
		new/datum/stack_recipe/cape/crimson(src),
		new/datum/stack_recipe/cape/orange(src),
		new/datum/stack_recipe/cape/rose(src),
	))


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
	result_type = /obj/item/reagent_containers/glass/rag
	req_amount = 1
	time = 5

/datum/stack_recipe/bedsheet
	title = "bedsheet"
	result_type = /obj/item/bedsheet
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

/datum/stack_recipe/mummy
	title = "mummy wraps"
	result_type = /obj/item/clothing/under/urist/historic/mummy
	req_amount = 8
	time = 10

/datum/stack_recipe/jumpsuit
	req_amount = 8
	time = 20

/datum/stack_recipe/jumpsuit/white
	title = "white jumpsuit"
	result_type = /obj/item/clothing/under/color/white

/datum/stack_recipe/jumpsuit/black
	title = "black jumpsuit"
	result_type = /obj/item/clothing/under/color/black

/datum/stack_recipe/jumpsuit/blackjumpshorts
	title = "black jumpshorts"
	result_type = /obj/item/clothing/under/color/blackjumpshorts

/datum/stack_recipe/jumpsuit/blackjumpskirt
	title = "black jumpskirt"
	result_type = /obj/item/clothing/under/blackjumpskirt

/datum/stack_recipe/jumpsuit/grey
	title = "grey jumpsuit"
	result_type = /obj/item/clothing/under/color/grey

/datum/stack_recipe/jumpsuit/blue
	title = "blue jumpsuit"
	result_type = /obj/item/clothing/under/color/blue

/datum/stack_recipe/jumpsuit/pink
	title = "pink jumpsuit"
	result_type = /obj/item/clothing/under/color/pink

/datum/stack_recipe/jumpsuit/red
	title = "red jumpsuit"
	result_type = /obj/item/clothing/under/color/red

/datum/stack_recipe/jumpsuit/green
	title = "green jumpsuit"
	result_type = /obj/item/clothing/under/color/green

/datum/stack_recipe/jumpsuit/yellow
	title = "yellow jumpsuit"
	result_type = /obj/item/clothing/under/color/yellow

/datum/stack_recipe/jumpsuit/lightpurple
	title = "light purple jumpsuit"
	result_type = /obj/item/clothing/under/color/lightpurple

/datum/stack_recipe/jumpsuit/brown
	title = "brown jumpsuit"
	result_type = /obj/item/clothing/under/color/brown


/datum/stack_recipe/tunic
	req_amount = 8
	time = 20

/datum/stack_recipe/tunic/yellow
	title = "yellow tunic"
	result_type = /obj/item/clothing/under/urist/historic

/datum/stack_recipe/tunic/blue
	title = "blue tunic"
	result_type = /obj/item/clothing/under/urist/historic/blue_tunic

/datum/stack_recipe/tunic/red
	title = "red tunic"
	result_type = /obj/item/clothing/under/urist/historic/red_tunic

/datum/stack_recipe/tunic/white
	title = "white tunic"
	result_type = /obj/item/clothing/under/urist/historic/white_tunic

/datum/stack_recipe/tunic/red2
	title = "red and yellow tunic"
	result_type = /obj/item/clothing/under/urist/historic/red_tunic2

/datum/stack_recipe/tunic/blue2
	title = "blue and white tunic"
	result_type = /obj/item/clothing/under/urist/historic/blue_tunic2

/datum/stack_recipe/tunic/roman
	title = "roman style tunic"
	result_type = /obj/item/clothing/under/urist/historic/roman


/datum/stack_recipe/dress
	req_amount = 8
	time = 20

/datum/stack_recipe/dress/green
	title = "green dress"
	result_type = /obj/item/clothing/under/urist/historic/dressg

/datum/stack_recipe/dress/red
	title = "red dress"
	result_type = /obj/item/clothing/under/urist/historic/dressr

/datum/stack_recipe/dress/blue
	title = "blue dress"
	result_type = /obj/item/clothing/under/urist/historic/dressbl

/datum/stack_recipe/dress/brown
	title = "brown dress"
	result_type = /obj/item/clothing/under/urist/historic/dressbr


/datum/stack_recipe/shirt
	req_amount = 8
	time = 20

/datum/stack_recipe/shirt/black
	title = "black striped shirt"
	result_type = /obj/item/clothing/under/urist/historic/pirate1

/datum/stack_recipe/shirt/red
	title = "red striped shirt"
	result_type = /obj/item/clothing/under/pirate

/datum/stack_recipe/shirt/red2
	title = "light red striped shirt"
	result_type = /obj/item/clothing/under/urist/historic/pirate2

/datum/stack_recipe/shirt/blue
	title = "blue striped shirt"
	result_type = /obj/item/clothing/under/urist/historic/pirate3

/datum/stack_recipe/shirt/baggy
	title = "yellow shirt with baggy trousers"
	result_type = /obj/item/clothing/under/urist/historic/pirate4

/datum/stack_recipe/shirt/tank
	title = "sleeveless shirt"
	result_type = /obj/item/clothing/under/urist/historic/pirate5


/datum/stack_recipe/cape
	req_amount = 6
	time = 20

/datum/stack_recipe/cape/black
	title = "black cape"
	result_type = /obj/item/clothing/head/urist/historic/light/cape

/datum/stack_recipe/cape/grey
	title = "grey cape"
	result_type = /obj/item/clothing/head/urist/historic/light/cape

/datum/stack_recipe/cape/sec
	title = "cochineal red cape"
	result_type = /obj/item/clothing/head/urist/historic/light/cape/sec

/datum/stack_recipe/cape/command
	title = "woad blue cape"
	result_type = /obj/item/clothing/head/urist/historic/light/cape/command

/datum/stack_recipe/cape/med
	title = "light blue cape"
	result_type = /obj/item/clothing/head/urist/historic/light/cape/med

/datum/stack_recipe/cape/eng
	title = "saffron yellow cape"
	result_type = /obj/item/clothing/head/urist/historic/light/cape/eng

/datum/stack_recipe/cape/sci
	title = "mauveine cape"
	result_type = /obj/item/clothing/head/urist/historic/light/cape/sci

/datum/stack_recipe/cape/cargo
	title = "catechu brown cape"
	result_type = /obj/item/clothing/head/urist/historic/light/cape/cargo

/datum/stack_recipe/cape/green
	title = "lincoln green cape"
	result_type = /obj/item/clothing/head/urist/historic/light/cape/green

/datum/stack_recipe/cape/indigo
	title = "indigo cape"
	result_type = /obj/item/clothing/head/urist/historic/light/cape/indigo

/datum/stack_recipe/cape/crimson
	title = "crimson cape"
	result_type = /obj/item/clothing/head/urist/historic/light/cape/crimson

/datum/stack_recipe/cape/orange
	title = "alder orange cape"
	result_type = /obj/item/clothing/head/urist/historic/light/cape/orange

/datum/stack_recipe/cape/rose
	title = "rose cape"
	result_type = /obj/item/clothing/head/urist/historic/light/cape/rose
