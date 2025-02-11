//i know this isn't machinery. Shut up.

/obj/item/reagent_containers/food/snacks/bun/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/reagent_containers/food/snacks))
		var/obj/item/reagent_containers/food/snacks/customizable/burger/S = new(get_turf(user))
		S.attackby(W,user)
		qdel(src)
	..()

/obj/item/reagent_containers/food/snacks/sliceable/flatdough/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/reagent_containers/food/snacks))
		var/obj/item/reagent_containers/food/snacks/customizable/pizza/S = new(get_turf(user))
		S.attackby(W,user)
		qdel(src)
	..()

/obj/item/reagent_containers/food/snacks/boiledspagetti/attackby(obj/item/W as obj, mob/user as mob)

	if(istype(W,/obj/item/reagent_containers/food/snacks))
		var/obj/item/reagent_containers/food/snacks/customizable/pasta/S = new(get_turf(user))
		S.attackby(W,user)
		qdel(src)

/obj/item/trash/plate/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/reagent_containers/food/snacks))
		var/obj/item/reagent_containers/food/snacks/customizable/fullycustom/S = new(get_turf(user))
		S.attackby(W,user)
		qdel(src)

/obj/item/trash/bowl
	name = "bowl"
	desc = "An empty bowl. Put some food in it to start making a soup."
	icon = 'icons/urist/kitchen.dmi'
	icon_state = "soup"

/obj/item/trash/bowl/attackby(obj/item/W as obj, mob/user as mob)

	if(istype(W,/obj/item/material/shard) || istype(W,/obj/item/reagent_containers/food/snacks))
		var/obj/item/reagent_containers/food/snacks/customizable/soup/S = new(get_turf(user))
		S.attackby(W,user)
		qdel(src)
	..()

/obj/item/reagent_containers/food/snacks/customizable //leaving BS12's sandwich in it's own thing, but leaving this here because meh. lazy.
	name = "sandwich"
	desc = "A sandwich! A timeless classic."
	icon = 'icons/urist/kitchen.dmi'
	icon_state = "breadslice"
	var/baseicon = "sandwich"
	var/basename = "sandwich"
	var/top = 1	//Do we have a top?
	var/add_overlays = 1	//Do we stack?
//	var/offsetstuff = 1 //Do we offset the overlays?
	var/ingredient_limit = 10
	var/fullycustom = 0
	trash = /obj/item/trash/plate
	bitesize = 2
	filling_color = null

	var/list/ingredients = list()

/obj/item/reagent_containers/food/snacks/customizable/New()
	..()
	reagents.add_reagent(/datum/reagent/nutriment, 8)

/obj/item/reagent_containers/food/snacks/customizable/pizza
	name = "personal pizza"
	desc = "A personalized pan pizza meant for only one person."
	icon_state = "personal_pizza"
	baseicon = "personal_pizza"
	basename = "personal pizza"
	add_overlays = 0
	top = 0

/obj/item/reagent_containers/food/snacks/customizable/pasta
	name = "spagetti"
	desc = "Noodles. With stuff. Delicious."
	icon_state = "pasta_bot"
	baseicon = "pasta_bot"
	basename = "spagetti"
	add_overlays = 0
	top = 0

/obj/item/reagent_containers/food/snacks/customizable/cook/bread
	name = "bread"
	desc = "Tasty bread."
	icon_state = "breadcustom"
	baseicon = "breadcustom"
	basename = "bread"
	add_overlays = 0
	top = 0

/obj/item/reagent_containers/food/snacks/customizable/cook/pie
	name = "pie"
	desc = "Tasty pie."
	icon_state = "piecustom"
	baseicon = "piecustom"
	basename = "pie"
	add_overlays = 0
	top = 0

/obj/item/reagent_containers/food/snacks/customizable/cook/cake
	name = "cake"
	desc = "A popular band."
	icon_state = "cakecustom"
	baseicon = "cakecustom"
	basename = "cake"
	add_overlays = 0
	top = 0

/obj/item/reagent_containers/food/snacks/customizable/cook/jelly
	name = "jelly"
	desc = "Totally jelly."
	icon_state = "jellycustom"
	baseicon = "jellycustom"
	basename = "jelly"
	add_overlays = 0
	top = 0

/obj/item/reagent_containers/food/snacks/customizable/cook/donkpocket
	name = "donk pocket"
	desc = "You wanna put a bangin-Oh nevermind."
	icon_state = "donkcustom"
	baseicon = "donkcustom"
	basename = "donk pocket"
	add_overlays = 0
	top = 0

/obj/item/reagent_containers/food/snacks/customizable/cook/kebab
	name = "kebab"
	desc = "Kebab or Kabab?"
	icon_state = "kababcustom"
	baseicon = "kababcustom"
	basename = "kebab"
	add_overlays = 0
	top = 0

/obj/item/reagent_containers/food/snacks/customizable/cook/salad
	name = "salad"
	desc = "Very tasty."
	icon_state = "saladcustom"
	baseicon = "saladcustom"
	basename = "salad"
	add_overlays = 0
	top = 0

/obj/item/reagent_containers/food/snacks/customizable/cook/waffles
	name = "waffles"
	desc = "Made with love."
	icon_state = "wafflecustom"
	baseicon = "wafflecustom"
	basename = "waffles"
	add_overlays = 0
	top = 0

/obj/item/reagent_containers/food/snacks/customizable/candy/cookie
	name = "cookie"
	desc = "COOKIE!!1!"
	icon_state = "cookiecustom"
	baseicon = "cookiecustom"
	basename = "cookie"
	add_overlays = 0
	top = 0

/obj/item/reagent_containers/food/snacks/customizable/candy/cotton
	name = "flavored cotton candy"
	desc = "Who can take a sunrise, sprinkle it with dew,"
	icon_state = "cottoncandycustom"
	baseicon = "cottoncandycustom"
	basename = "flavored cotton candy"
	add_overlays = 0
	top = 0

/obj/item/reagent_containers/food/snacks/customizable/candy/gummybear
	name = "flavored gummy bear"
	desc = "Cover it in chocolate and a miracle or two,"
	icon_state = "gummybearcustom"
	baseicon = "gummybearcustom"
	basename = "flavored gummy bear"
	add_overlays = 0
	top = 0

/obj/item/reagent_containers/food/snacks/customizable/candy/gummyworm
	name = "flavored giant gummy worm"
	desc = "The Candy Man can 'cause he mixes it with love,"
	icon_state = "gummywormcustom"
	baseicon = "gummywormcustom"
	basename = "flavored giant gummy worm"
	add_overlays = 0
	top = 0

/obj/item/reagent_containers/food/snacks/customizable/candy/jellybean
	name = "flavored jelly bean"
	desc = "And makes the world taste good."
	icon_state = "jellybeancustom"
	baseicon = "jellybeancustom"
	basename = "flavored jelly bean"
	add_overlays = 0
	top = 0

/obj/item/reagent_containers/food/snacks/customizable/candy/jawbreaker
	name = "flavored jawbreaker"
	desc = "Who can take a rainbow, Wrap it in a sigh,"
	icon_state = "jawbreakercustom"
	baseicon = "jawbreakercustom"
	basename = "flavored jawbreaker"
	add_overlays = 0
	top = 0

/obj/item/reagent_containers/food/snacks/customizable/candy/candycane
	name = "flavored candy cane"
	desc = "Soak it in the sun and make strawberry-lemon pie,"
	icon_state = "candycanecustom"
	baseicon = "candycanecustom"
	basename = "flavored candy cane"
	add_overlays = 0
	top = 0

/obj/item/reagent_containers/food/snacks/customizable/candy/gum
	name = "flavored gum"
	desc = "The Candy Man can 'cause he mixes it with love and makes the world taste good. And the world tastes good 'cause the Candy Man thinks it should..."
	icon_state = "gumcustom"
	baseicon = "gumcustom"
	basename = "flavored gum"
	add_overlays = 0
	top = 0

/obj/item/reagent_containers/food/snacks/customizable/candy/donut
	name = "filled donut"
	desc = "Donut eat this!" // kill me
	icon_state = "donutcustom"
	baseicon = "donutcustom"
	basename = "filled donut"
	add_overlays = 0
	top = 0

/obj/item/reagent_containers/food/snacks/customizable/candy/bar
	name = "flavored chocolate bar"
	desc = "Made in a factory downtown."
	icon_state = "barcustom"
	baseicon = "barcustom"
	basename = "flavored chocolate bar"
	add_overlays = 0
	top = 0

/obj/item/reagent_containers/food/snacks/customizable/candy/sucker
	name = "flavored sucker"
	desc = "Suck suck suck."
	icon_state = "suckercustom"
	baseicon = "suckercustom"
	basename = "flavored sucker"
	add_overlays = 0
	top = 0

/obj/item/reagent_containers/food/snacks/customizable/candy/cash
	name = "flavored chocolate cash"
	desc = "I got piles!"
	icon_state = "cashcustom"
	baseicon = "cashcustom"
	basename = "flavored cash"
	add_overlays = 0
	top = 0

/obj/item/reagent_containers/food/snacks/customizable/candy/coin
	name = "flavored chocolate coin"
	desc = "Clink, clink, clink."
	icon_state = "coincustom"
	baseicon = "coincustom"
	basename = "flavored coin"
	add_overlays = 0
	top = 0

/obj/item/reagent_containers/food/snacks/customizable/fullycustom // In the event you fuckers find something I forgot to add a customizable food for.
	name = "on a plate"
	desc = "A unique dish."
	icon_state = "fullycustom"
	baseicon = "fullycustom"
	basename = "on a plate"
	add_overlays = 0
	top = 0
	ingredient_limit = 20
	fullycustom = 1

/obj/item/reagent_containers/food/snacks/customizable/soup
	name = "soup"
	desc = "A bowl with liquid and... stuff in it."
	icon_state = "soup"
	baseicon = "soup"
	basename = "soup"
	add_overlays = 0
	trash = /obj/item/trash/bowl
	top = 0

/obj/item/reagent_containers/food/snacks/customizable/burger
	name = "burger bun"
	desc = "A bun for a burger. Delicious."
	icon_state = "burger"
	baseicon = "burger"
	basename = "burger"

/obj/item/reagent_containers/food/snacks/customizable/attackby(obj/item/W as obj, mob/user as mob)
	if(length(src.contents) > ingredient_limit)
		to_chat(user, "<span class='warning'>If you put anything else in or on [src] it's going to make a mess.</span>")
		return
	else if(istype(W,/obj/item/reagent_containers/food/snacks))
		to_chat(user, "<span class='notice'> You add [W] to [src].</span>")
		var/obj/item/reagent_containers/F = W
		F.reagents.trans_to(src, F.reagents.total_volume)
		user.drop_item()
		W.loc = src
		ingredients += W
		update()
		return
	..()

/obj/item/reagent_containers/food/snacks/customizable/proc/update()
	var/fullname = "" //We need to build this from the contents of the var.
	var/i = 0

	overlays.Cut()

	for(var/obj/item/reagent_containers/food/snacks/O in ingredients)

		i++
		if(i == 1)
			fullname += "[O.name]"
		else if(i == length(ingredients))
			fullname += " and [O.name]"
		else
			fullname += ", [O.name]"

		if(!fullycustom)
			var/image/I = new(src.icon, "[baseicon]_filling")
			if(add_overlays)
				I.color = O.filling_color
				I.pixel_x = pick(list(-1,0,1))
				I.pixel_y = (i*2)+1
				overlays += I
			else
				var/list/internalcolors //holds a rgb value of the current overlay
				if(src.filling_color)
					internalcolors = hex2rgblist(src.filling_color)
				var/list/externalcolors //same, added overlay
				if(O.filling_color)
					externalcolors = hex2rgblist(O.filling_color)
				if((!internalcolors) && (!externalcolors))
					src.filling_color = pick("#aa0000","#0000aa","#006600","#f0f000") //toned down
				else if((!internalcolors) && (externalcolors))
					src.filling_color = O.filling_color
				else if((internalcolors) && (!externalcolors))
					src.filling_color = src.filling_color //hacky, but I need to placate the great compiler gods and do SOMETHING here
				else
					internalcolors = SimpleRGBMix(internalcolors, externalcolors, 90, 700, 1)//no painfully black/white foods
					src.filling_color = rgb(internalcolors[1], internalcolors[2], internalcolors[3])
				I.color = src.filling_color
			overlays += I
		else
			var/image/F = new(O.icon, O.icon_state)
			F.pixel_x = pick(list(-1,0,1))
			F.pixel_y = pick(list(-1,0,1))
			overlays += F
			overlays += O.overlays

	if(top)
		var/image/T = new(src.icon, "[baseicon]_top")
		T.pixel_x = pick(list(-1,0,1))
		T.pixel_y = (length(ingredients) * 2)+1
		overlays += T

	name = lowertext("[fullname] [basename]")
	if(length(name) > 80) name = "[pick(list("absurd","colossal","enormous","ridiculous","massive","oversized","cardiac-arresting","pipe-clogging","edible but sickening","sickening","gargantuan","mega","belly-burster","chest-burster"))] [basename]"
	w_class = ceil(clamp((length(ingredients)/2),1,3))

/obj/item/reagent_containers/food/snacks/customizable/Destroy()
	for(var/obj/item/O in ingredients)
		qdel(O)
	..()

/obj/item/reagent_containers/food/snacks/customizable/examine()
	..()
	var/whatsinside = pick(ingredients)

	to_chat(usr, "<span class='notice'> You think you can see [whatsinside] in there.</span>")

//cereals

/obj/item/reagent_containers/food/snacks/cereal
	name = "box of cereal"
	desc = "A box of cereal."
	icon = 'icons/urist/kitchen.dmi'
	icon_state = "cereal_box"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/cereal/New()
	..()
	reagents.add_reagent(/datum/reagent/nutriment, 30)

//deepfryer shit
/*
/obj/item/reagent_containers/food/snacks/deepfryholder
	name = "Deep Fried Foods Holder Obj"
	desc = "If you can see this description the code for the deep fryer fucked up."
	icon = 'icons/urist/kitchen.dmi'
	icon_state = "deepfried_holder_icon"
	bitesize = 2
	deepfried = 1
	New()
		..()
		reagents.add_reagent(/datum/reagent/nutriment, 30)*/

//////////////
//STILL SHIT//
//////////////

/obj/item/reagent_containers/food/drinks/bottle/customizable // Shamelessly stolen from original customizables, so that I can easily use the oven code.
	name = "Customizable Drink"
	desc = "If you can see this, tell a coder."
	icon = 'icons/urist/kitchen.dmi'
	icon_state = "vodkacustom"
	var/baseicon = "vodkacustom"
	var/basename = "hooch"
	var/top = 0	//Do we have a top? //why was this ever set to one
	var/add_overlays = 0	//Do we stack? //see above
	var/ingredient_limit = 1
	var/fullycustom = 0
	var/boozetype = /datum/reagent/ethanol/hooch
	volume = 100
	amount_per_transfer_from_this = 2

	var/list/ingredients = list()

/obj/item/reagent_containers/food/drinks/bottle/customizable/New()
	..()
	src.reagents.add_reagent(boozetype, 20)
	ferment(boozetype)


/obj/item/reagent_containers/food/drinks/bottle/customizable/wine
	name = "wine bottle"
	desc = "Tasty."
	icon_state = "winecustom"
	baseicon = "winecustom"
	basename = "wine bottle"
	add_overlays = 0
	top = 0
	boozetype = /datum/reagent/ethanol/wine

/obj/item/reagent_containers/food/drinks/bottle/customizable/whiskey
	name = "whiskey bottle"
	desc = "Tasty."
	icon_state = "whiskeycustom"
	baseicon = "whiskeycustom"
	basename = "whiskey bottle"
	add_overlays = 0
	top = 0
	boozetype = /datum/reagent/ethanol/whiskey

/obj/item/reagent_containers/food/drinks/bottle/customizable/vermouth
	name = "vermouth bottle"
	desc = "Tasty."
	icon_state = "vermouthcustom"
	baseicon = "vermouthcustom"
	basename = "vermouth bottle"
	add_overlays = 0
	top = 0
	boozetype = /datum/reagent/ethanol/vermouth

/obj/item/reagent_containers/food/drinks/bottle/customizable/vodka
	name = "vodka"
	desc = "Tasty."
	icon_state = "vodkacustom"
	baseicon = "vodkacustom"
	basename = "vodka"
	add_overlays = 0
	top = 0
	boozetype = /datum/reagent/ethanol/vodka

/obj/item/reagent_containers/food/drinks/bottle/customizable/ale
	name = "ale"
	desc = "Strike the asteroid!"
	icon_state = "alecustom"
	baseicon = "alecustom"
	basename = "ale"
	add_overlays = 0
	top = 0
	boozetype = /datum/reagent/ethanol/ale

/obj/item/reagent_containers/food/drinks/bottle/customizable/attackby(obj/item/W as obj, mob/user as mob)
	if(length(src.contents) > ingredient_limit)
		to_chat(user, "<span class='warning'>If you put anything else in or on [src] it's going to make a mess.</span>")
		return
	else if(istype(W,/obj/item/reagent_containers/food/snacks))
		to_chat(user, "<span class='notice'> You add [W] to [src].</span>")
		var/obj/item/reagent_containers/F = W
		F.reagents.trans_to(src, F.reagents.total_volume)
		user.drop_item()
		W.loc = src
		ingredients += W
		update()
		return
	..()

/obj/item/reagent_containers/food/drinks/bottle/customizable/proc/update()
	var/fullname = "" //We need to build this from the contents of the var.
	var/i = 0

	overlays.Cut()

	for(var/obj/item/reagent_containers/food/snacks/O in ingredients)

		i++
		if(i == 1)
			fullname += "[O.name]"
		else if(i == length(ingredients))
			fullname += " and [O.name]"
		else
			fullname += ", [O.name]"

		if(!fullycustom)
			var/image/I = new(src.icon, "[baseicon]_filling")
			var/list/internalcolors //holds a rgb value of the current overlay
			if(src.filling_color)
				internalcolors = hex2rgblist(src.filling_color)
			var/list/externalcolors //same, added overlay
			if(O.filling_color)
				externalcolors = hex2rgblist(O.filling_color)
			if((!internalcolors) && (!externalcolors))
				src.filling_color = pick("#aa0000","#0000aa","#006600","#f0f000") //toned down
			else if((!internalcolors) && (externalcolors))
				src.filling_color = O.filling_color
			else if((internalcolors) && (!externalcolors))
				src.filling_color = src.filling_color //hacky, but I need to placate the great compiler gods and do SOMETHING here
			else
				internalcolors = SimpleRGBMix(internalcolors, externalcolors, 90, 700, 1)//no painfully black/white foods
				src.filling_color = rgb(internalcolors[1], internalcolors[2], internalcolors[3])
			I.color = src.filling_color
			overlays += I
		else
			var/image/F = new(O.icon, O.icon_state)
			F.pixel_x = pick(list(-1,0,1))
			F.pixel_y = pick(list(-1,0,1))
			overlays += F
			overlays += O.overlays

	name = lowertext("[fullname] [basename]")
	if(length(name) > 80) name = "incomprehensible mixture [basename]"
	w_class = 2
	if(src.reagents)
		ferment(src.boozetype)

/obj/item/reagent_containers/food/drinks/bottle/customizable/Destroy()
	for(var/obj/item/O in ingredients)
		qdel(O)
	..()

/obj/item/reagent_containers/food/drinks/bottle/customizable/examine()
	..()
	var/whatsinside = pick(ingredients)

	to_chat(usr, "<span class='notice'> You think you can see fermented chunks of \a [whatsinside] in there.</span>")

/obj/item/reagent_containers/food/drinks/bottle/customizable/proc/ferment(boozetype)
	if(!(boozetype))
		boozetype = /datum/reagent/ethanol/hooch
	var/datum/reagents/R = src.reagents
	var/nutrition = R.get_reagent_amount(/datum/reagent/nutriment)
	var/sweetness = R.get_reagent_amount(/datum/reagent/sugar)
	var/boozeamt = max(((nutrition * 10) + (sweetness * 20)), 10)
	R.remove_reagent(/datum/reagent/nutriment, nutrition)
	R.remove_reagent(/datum/reagent/sugar, sweetness)
	R.add_reagent(boozetype, boozeamt)
