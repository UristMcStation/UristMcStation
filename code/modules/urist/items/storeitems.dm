/////////////////////////////
// Store Item
/////////////////////////////
/datum/storeitem
	var/name="Thing"
	var/desc="It's a thing."
	var/typepath=/obj/item/weapon/storage/box
	var/cost=0

/datum/storeitem/proc/deliver(var/mob/usr)
	if(!istype(typepath,/obj/item/weapon/storage))
		var/obj/item/weapon/storage/box/box=new(usr.loc)
		new typepath(box)
		box.name="[name] package"
		box.desc="A special gift for doing your job."
		usr.put_in_hands(box)
	else
		var/thing = new typepath(usr.loc)
		usr.put_in_hands(thing)


/////////////////////////////
// Shit for robotics/science
/////////////////////////////

/*
/datum/storeitem/robotnik_labcoat
	name = "Robotnik's Research Labcoat"
	desc = "Join the empire and display your hatred for woodland animals."
	typepath = /obj/item/clothing/suit/storage/labcoat/custom/N3X15/robotics
	cost = 350

/datum/storeitem/robotnik_jumpsuit
	name = "Robotics Interface Suit"
	desc = "A modern black and red design with reinforced seams and brass neural interface fittings."
	typepath = /obj/item/clothing/under/custom/N3X15/robotics
	cost = 500*/


/////////////////////////////
// General
/////////////////////////////
/datum/storeitem/snap_pops
	name = "Snap-Pops"
	desc = "Ten-thousand-year-old chinese fireworks: IN SPACE"
	typepath = /obj/item/weapon/storage/box/snappops
	cost = 200

/datum/storeitem/crayons
	name = "Crayons"
	desc = "Let security know how they're doing by scrawling lovenotes all over their hallways."
	typepath = /obj/item/weapon/storage/fancy/crayons
	cost = 350

/datum/storeitem/beachball
	name="Beach Ball"
	desc="Summer up your office with this cheap vinyl beachball made by prisoners!"
	typepath=/obj/item/weapon/beach_ball
	cost = 500

/////////////////////////////////////////////////////////
// Vanity lighters. Fuck you and your custom items Bay.//
/////////////////////////////////////////////////////////


/datum/storeitem/zippoblue
	name="Blue Zippo"
	desc="A fancy blue zippo lighter made just for you!"
	typepath=/obj/item/weapon/lighter/zippo/vanity/blue
	cost = 650

/datum/storeitem/zippogold
	name="Gold Zippo"
	desc="An engraved gold zippo lighter made just for you!"
	typepath=/obj/item/weapon/lighter/zippo/vanity/gold
	cost = 650

/datum/storeitem/zippoblack
	name="Black Zippo"
	desc="A slick black zippo lighter made just for you!"
	typepath=/obj/item/weapon/lighter/zippo/vanity/black
	cost = 650

/datum/storeitem/zippored
	name="Red and Black Zippo"
	desc="A black zippo lighter with a red decal made just for you!"
	typepath=/obj/item/weapon/lighter/zippo/vanity/red
	cost = 650

/datum/storeitem/zippored
	name="Engraved Zippo"
	desc="A silver zippo lighter with intricate engravings made just for you!"
	typepath=/obj/item/weapon/lighter/zippo/vanity/engraved
	cost = 650

/////////////////////////////////////////////////////////
//                      A COMB.                        //
/////////////////////////////////////////////////////////

/datum/storeitem/combpurple
	name="Purple Comb"
	desc="A simple purple comb made out of flexible plastic."
	typepath=/obj/item/weapon/vanity/comb
	cost = 200

/////////////////////////////////////////////////////////
//                     Watches                         //
/////////////////////////////////////////////////////////

/datum/storeitem/pocketwatch
	name="Brass Pocket Watch"
	desc="A brass pocket watch, for keeping track of time in the cold dark void!"
	typepath=/obj/item/clothing/tie/watch/pocket
	cost = 300

/datum/storeitem/wristwatch
	name="Black Wrist Watch"
	desc="A black plastic wrist watch, for keeping track of time in the cold dark void!"
	typepath=/obj/item/clothing/tie/watch/wrist
	cost = 300

/////////////////////////////////////////////////////////
//                     Razor                           //
/////////////////////////////////////////////////////////

/datum/storeitem/razor
	name="Electric Razor"
	desc="An electric razor. The perfect thing for keeping your hair trimmed, and you looking classy."
	typepath=/obj/item/weapon/razor
	cost = 300

/////////////////////////////////////////////////////////
//                     Doll(s?)                        //
/////////////////////////////////////////////////////////

datum/storeitem/dollunathi
	name="Unathi Doll"
	desc="A cute little doll modeled after an ugly lizard!"
	typepath=/obj/item/weapon/vanity/unathi
	cost = 300

datum/storeitem/dollfarwa
	name="Farwa Doll"
	desc="A plush little farwa doll to keep you company in the lonely depths of space."
	typepath=/obj/item/weapon/fluff/farwadoll
	cost = 300
