/obj/landmark
	name = "landmark"
	icon = 'icons/effects/landmarks.dmi'
	icon_state = "x2"
	anchored = TRUE
	unacidable = TRUE
	simulated = FALSE
	invisibility = INVISIBILITY_ABSTRACT
	var/can_copy = FALSE //If set, will allow the landmark to be copied via the area.copy_contents_to() proc. (For holodeck mob spawns)
	var/delete_me = 0

/obj/landmark/New()
	..()
	tag = "landmark*[name]"

	//TODO clean up this mess
	switch(name)			//some of these are probably obsolete
		if("monkey")
			GLOB.monkeystart += loc
			delete_me = 1
			return
		if("start")
			GLOB.newplayer_start += loc
			delete_me = 1
			return
		if("JoinLate")
			GLOB.latejoin += loc
			delete_me = 1
			return
		if("JoinLateGateway")
			GLOB.latejoin_gateway += loc
			delete_me = 1
			return
		if("JoinLateCryo")
			GLOB.latejoin_cryo += loc
			delete_me = 1
			return
		if("JoinLateCryo2")
			GLOB.latejoin_cryo2 += loc
			delete_me = 1
			return
		if("JoinLateCyborg")
			GLOB.latejoin_cyborg += loc
			delete_me = 1
			return
		if("prisonwarp")
			GLOB.prisonwarp += loc
			delete_me = 1
			return
		if("tdome1")
			GLOB.tdome1 += loc
		if("tdome2")
			GLOB.tdome2 += loc
		if("tdomeadmin")
			GLOB.tdomeadmin += loc
		if("tdomeobserve")
			GLOB.tdomeobserve += loc
		if("prisonsecuritywarp")
			GLOB.prisonsecuritywarp += loc
			delete_me = 1
			return
		if("endgame_exit")
			endgame_safespawns += loc
			delete_me = 1
			return
		if("bluespacerift")
			endgame_exits += loc
			delete_me = 1
			return

//urist stuff

		if("eventwarp1")
			eventwarp1 += loc
			delete_me = 1
			return

		if("eventwarp2")
			eventwarp2 += loc
			delete_me = 1
			return

		if("eventwarp3")
			eventwarp3 += loc
			delete_me = 1
			return

		if("scomspawn1")
			scomspawn1 += loc
			delete_me = 1
			return

		if("scomspawn2")
			scomspawn2 += loc
			delete_me = 1
			return

		if("scomspawn3")
			scomspawn3 += loc
			delete_me = 1
			return

//end urist stuff
	landmarks_list += src
	return 1

/obj/landmark/proc/delete()
	delete_me = 1

/obj/landmark/Initialize()
	. = ..()
	if(delete_me)
		return INITIALIZE_HINT_QDEL

/obj/landmark/Destroy()
	landmarks_list -= src
	return ..()

/obj/landmark/start
	name = "start"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x"
	anchored = TRUE
	invisibility = INVISIBILITY_ABSTRACT

/obj/landmark/start/New()
	..()
	tag = "start*[name]"
	return 1

//Costume spawner landmarks
/obj/landmark/costume //costume spawner, selects a random subclass and disappears
	delete_me = 1

/obj/landmark/costume/Initialize()
	. = ..()
	if (delete_me)
		return INITIALIZE_HINT_QDEL

/obj/landmark/costume/random/Initialize()
	var/list/landmarks = subtypesof(/obj/landmark/costume)
	landmarks -= /obj/landmark/costume/random
	var/landmark_path = pick(landmarks)
	new landmark_path(src.loc)
	. = ..()

//SUBCLASSES.  Spawn a bunch of items and disappear likewise
/obj/landmark/costume/chameleon/Initialize()
	new /obj/item/clothing/mask/chameleon(src.loc)
	new /obj/item/clothing/under/chameleon(src.loc)
	new /obj/item/clothing/glasses/chameleon(src.loc)
	new /obj/item/clothing/shoes/chameleon(src.loc)
	new /obj/item/clothing/gloves/chameleon(src.loc)
	new /obj/item/clothing/suit/chameleon(src.loc)
	new /obj/item/clothing/head/chameleon(src.loc)
	new /obj/item/storage/backpack/chameleon(src.loc)
	. = ..()

/obj/landmark/costume/gladiator/Initialize()
	new /obj/item/clothing/under/gladiator(src.loc)
	new /obj/item/clothing/head/helmet/gladiator(src.loc)
	. = ..()

/obj/landmark/costume/madscientist/Initialize()
	new /obj/item/clothing/under/gimmick/rank/captain/suit(src.loc)
	new /obj/item/clothing/head/flatcap(src.loc)
	new /obj/item/clothing/suit/storage/toggle/labcoat/mad(src.loc)
	new /obj/item/clothing/glasses/green(src.loc)
	. = ..()

/obj/landmark/costume/elpresidente/Initialize()
	new /obj/item/clothing/under/gimmick/rank/captain/suit(src.loc)
	new /obj/item/clothing/head/flatcap(src.loc)
	new /obj/item/clothing/mask/smokable/cigarette/cigar/havana(src.loc)
	new /obj/item/clothing/shoes/jackboots(src.loc)
	. = ..()

/obj/landmark/costume/nyangirl/Initialize()
	new /obj/item/clothing/under/schoolgirl(src.loc)
	new /obj/item/clothing/head/kitty(src.loc)
	. = ..()

/obj/landmark/costume/maid/Initialize()
	new /obj/item/clothing/under/blackskirt(src.loc)
	var/CHOICE = pick( /obj/item/clothing/head/beret , /obj/item/clothing/head/rabbitears )
	new CHOICE(src.loc)
	new /obj/item/clothing/glasses/blindfold(src.loc)
	. = ..()

/obj/landmark/costume/butler/Initialize()
	new /obj/item/clothing/accessory/waistcoat/black(src.loc)
	new /obj/item/clothing/under/suit_jacket(src.loc)
	new /obj/item/clothing/head/that(src.loc)
	. = ..()

/obj/landmark/costume/scratch/Initialize()
	new /obj/item/clothing/gloves/white(src.loc)
	new /obj/item/clothing/shoes/white(src.loc)
	new /obj/item/clothing/under/scratch(src.loc)
	if (prob(30))
		new /obj/item/clothing/head/cueball(src.loc)
	. = ..()

/obj/landmark/costume/prig/Initialize()
	new /obj/item/clothing/accessory/waistcoat/black(src.loc)
	new /obj/item/clothing/glasses/monocle(src.loc)
	var/CHOICE= pick( /obj/item/clothing/head/bowler, /obj/item/clothing/head/that)
	new CHOICE(src.loc)
	new /obj/item/clothing/shoes/black(src.loc)
	new /obj/item/cane(src.loc)
	new /obj/item/clothing/under/sl_suit(src.loc)
	new /obj/item/clothing/mask/fakemoustache(src.loc)
	. = ..()

/obj/landmark/costume/plaguedoctor/Initialize()
	new /obj/item/clothing/suit/bio_suit/plaguedoctorsuit(src.loc)
	new /obj/item/clothing/head/plaguedoctorhat(src.loc)
	. = ..()

/obj/landmark/costume/nightowl/Initialize()
	new /obj/item/clothing/under/owl(src.loc)
	new /obj/item/clothing/mask/gas/owl_mask(src.loc)
	. = ..()

/obj/landmark/costume/waiter/Initialize()
	new /obj/item/clothing/under/waiter(src.loc)
	var/CHOICE= pick( /obj/item/clothing/head/kitty, /obj/item/clothing/head/rabbitears)
	new CHOICE(src.loc)
	new /obj/item/clothing/suit/apron(src.loc)
	. = ..()

/obj/landmark/costume/pirate/Initialize()
	new /obj/item/clothing/under/pirate(src.loc)
	new /obj/item/clothing/suit/pirate(src.loc)
	var/CHOICE = pick( /obj/item/clothing/head/pirate , /obj/item/clothing/mask/bandana/red)
	new CHOICE(src.loc)
	new /obj/item/clothing/glasses/eyepatch(src.loc)
	. = ..()

/obj/landmark/costume/commie/Initialize()
	new /obj/item/clothing/under/soviet(src.loc)
	new /obj/item/clothing/head/ushanka(src.loc)
	. = ..()

/obj/landmark/costume/imperium_monk/Initialize()
	new /obj/item/clothing/suit/imperium_monk(src.loc)
	if (prob(25))
		new /obj/item/clothing/mask/gas/cyborg(src.loc)
	. = ..()

/obj/landmark/costume/holiday_priest/Initialize()
	new /obj/item/clothing/suit/holidaypriest(src.loc)
	. = ..()

/obj/landmark/costume/marisawizard/fake/Initialize()
	new /obj/item/clothing/head/wizard/marisa/fake(src.loc)
	new/obj/item/clothing/suit/wizrobe/marisa/fake(src.loc)
	. = ..()

/obj/landmark/costume/cutewitch/Initialize()
	new /obj/item/clothing/under/sundress(src.loc)
	new /obj/item/clothing/head/witchwig(src.loc)
	new /obj/item/staff/broom(src.loc)
	. = ..()

/obj/landmark/costume/fakewizard/Initialize()
	new /obj/item/clothing/suit/wizrobe/fake(src.loc)
	new /obj/item/clothing/head/wizard/fake(src.loc)
	new /obj/item/staff/(src.loc)
	. = ..()

/obj/landmark/costume/sexyclown/Initialize()
	new /obj/item/clothing/mask/gas/sexyclown(src.loc)
	new /obj/item/clothing/under/sexyclown(src.loc)
	. = ..()

/obj/landmark/costume/sexymime/Initialize()
	new /obj/item/clothing/mask/gas/sexymime(src.loc)
	new /obj/item/clothing/under/sexymime(src.loc)
	. = ..()

/obj/landmark/costume/savagehunter/Initialize()
	new /obj/item/clothing/mask/spirit(src.loc)
	new /obj/item/clothing/under/savage_hunter(src.loc)
	. = ..()

/obj/landmark/costume/savagehuntress/Initialize()
	new /obj/item/clothing/mask/spirit(src.loc)
	new /obj/item/clothing/under/savage_hunter/female(src.loc)
	. = ..()

/obj/landmark/ruin
	var/datum/map_template/ruin/ruin_template

/obj/landmark/ruin/New(loc, my_ruin_template)
	name = "ruin_[sequential_id(/obj/landmark/ruin)]"
	..(loc)
	ruin_template = my_ruin_template
	GLOB.ruin_landmarks |= src

/obj/landmark/ruin/Destroy()
	GLOB.ruin_landmarks -= src
	ruin_template = null
	. = ..()
