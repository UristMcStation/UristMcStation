////////////////////////////////////////////////////////////////////////////////
/// Pills.
////////////////////////////////////////////////////////////////////////////////
/obj/item/reagent_containers/pill
	name = "pill"
	desc = "A pill."
	icon = 'icons/obj/pills.dmi'
	icon_state = null
	item_state = "pill"
	randpixel = 7
	possible_transfer_amounts = null
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_EARS
	volume = 30
	item_flags = ITEM_FLAG_CAN_HIDE_IN_SHOES

/obj/item/reagent_containers/pill/New()
	..()
	if(!icon_state)
		icon_state = "pill[rand(1, 5)]" //preset pills only use colour changing or unique icons

/obj/item/reagent_containers/pill/use_before(mob/M as mob, mob/user as mob)
	. = FALSE
	if (!istype(M))
		return FALSE

	if (M == user)
		if (!M.can_eat(src))
			return TRUE

		M.visible_message(SPAN_NOTICE("[M] swallows a pill."), SPAN_NOTICE("You swallow \the [src]."), null, 2)
		if (reagents.total_volume)
			reagents.trans_to_mob(M, reagents.total_volume, CHEM_INGEST)
		qdel(src)
		return TRUE

	if (ishuman(M))
		if (!M.can_force_feed(user, src))
			return TRUE

		user.visible_message(SPAN_WARNING("[user] attempts to force [M] to swallow \the [src]."))
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		if (!do_after(user, 3 SECONDS, M, DO_MEDICAL))
			return TRUE

		if (user.get_active_hand() != src)
			return TRUE

		user.visible_message(SPAN_WARNING("[user] forces [M] to swallow \the [src]."))
		var/contained = reagentlist()
		if (reagents.should_admin_log())
			admin_attack_log(user, M, "Fed the victim with [name] (Reagents: [contained])", "Was fed [src] (Reagents: [contained])", "used [src] (Reagents: [contained]) to feed")
		if (reagents.total_volume)
			reagents.trans_to_mob(M, reagents.total_volume, CHEM_INGEST)
		qdel(src)
		return TRUE

/obj/item/reagent_containers/pill/use_after(atom/target, mob/living/user, click_parameters)
	if (target.is_open_container() && target.reagents)
		if (!target.reagents.total_volume)
			to_chat(user, SPAN_NOTICE("\The [target] is empty. Can't dissolve \the [src]."))
			return TRUE

		to_chat(user, SPAN_NOTICE("You dissolve \the [src] in \the [target]."))

		if (reagents.should_admin_log())
			admin_attacker_log(user, "spiked \a [target] with a pill. Reagents: [reagentlist()]")
		reagents.trans_to(target, reagents.total_volume)
		for(var/mob/O in viewers(2, user))
			O.show_message(SPAN_WARNING("\The [user] puts something in \the [target]."), 1)
		qdel(src)
		return TRUE
	else return FALSE

////////////////////////////////////////////////////////////////////////////////
/// Pills. END
////////////////////////////////////////////////////////////////////////////////

//We lied - it's pills all the way down
/obj/item/reagent_containers/pill/antitox
	name = "Dylovene (25u)"
	desc = "Neutralizes many common toxins."
	icon_state = "pill1"
/obj/item/reagent_containers/pill/antitox/New()
	..()
	reagents.add_reagent(/datum/reagent/dylovene, 25)
	color = reagents.get_color()


/obj/item/reagent_containers/pill/tox
	name = "toxins pill"
	desc = "Highly toxic."
	icon_state = "pill4"
	volume = 50
/obj/item/reagent_containers/pill/tox/New()
	..()
	reagents.add_reagent(/datum/reagent/toxin, 50)
	color = reagents.get_color()


/obj/item/reagent_containers/pill/cyanide
	name = "cyanide pill"
	desc = "It's marked 'KCN'. Smells vaguely of almonds."
	icon_state = "pillC"
	volume = 50
/obj/item/reagent_containers/pill/cyanide/New()
	..()
	reagents.add_reagent(/datum/reagent/toxin/cyanide, 50)


/obj/item/reagent_containers/pill/adminordrazine
	name = "Adminordrazine pill"
	desc = "It's magic. We don't have to explain it."
	icon_state = "pillA"

/obj/item/reagent_containers/pill/adminordrazine/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/adminordrazine, 1)

/obj/item/reagent_containers/pill/stox
	name = "Soporific (15u)"
	desc = "Commonly used to treat insomnia."
	icon_state = "pill3"
/obj/item/reagent_containers/pill/stox/New()
	..()
	reagents.add_reagent(/datum/reagent/soporific, 15)
	color = reagents.get_color()


/obj/item/reagent_containers/pill/kelotane
	name = "Kelotane (15u)"
	desc = "Used to treat burns."
	icon_state = "pill2"
/obj/item/reagent_containers/pill/kelotane/New()
	..()
	reagents.add_reagent(/datum/reagent/kelotane, 15)
	color = reagents.get_color()


/obj/item/reagent_containers/pill/paracetamol
	name = "Paracetamol (15u)"
	desc = "A painkiller for the ages. Chewables!"
	icon_state = "pill3"
/obj/item/reagent_containers/pill/paracetamol/New()
	..()
	reagents.add_reagent(/datum/reagent/paracetamol, 15)
	color = reagents.get_color()


/obj/item/reagent_containers/pill/tramadol
	name = "Tramadol (15u)"
	desc = "A simple painkiller."
	icon_state = "pill3"
/obj/item/reagent_containers/pill/tramadol/New()
	..()
	reagents.add_reagent(/datum/reagent/tramadol, 15)
	color = reagents.get_color()


/obj/item/reagent_containers/pill/inaprovaline
	name = "Inaprovaline (30u)"
	desc = "Used to stabilize patients."
	icon_state = "pill1"
/obj/item/reagent_containers/pill/inaprovaline/New()
	..()
	reagents.add_reagent(/datum/reagent/inaprovaline, 30)
	color = reagents.get_color()


/obj/item/reagent_containers/pill/dexalin
	name = "Dexalin (15u)"
	desc = "Used to treat oxygen deprivation."
	icon_state = "pill1"
/obj/item/reagent_containers/pill/dexalin/New()
	..()
	reagents.add_reagent(/datum/reagent/dexalin, 15)
	color = reagents.get_color()


/obj/item/reagent_containers/pill/dexalin_plus
	name = "Dexalin Plus (15u)"
	desc = "Used to treat extreme oxygen deprivation."
	icon_state = "pill2"
/obj/item/reagent_containers/pill/dexalin_plus/New()
	..()
	reagents.add_reagent(/datum/reagent/dexalinp, 15)
	color = reagents.get_color()


/obj/item/reagent_containers/pill/dermaline
	name = "Dermaline (15u)"
	desc = "Used to treat burn wounds."
	icon_state = "pill2"
/obj/item/reagent_containers/pill/dermaline/New()
	..()
	reagents.add_reagent(/datum/reagent/dermaline, 15)
	color = reagents.get_color()


/obj/item/reagent_containers/pill/dylovene
	name = "Dylovene (15u)"
	desc = "A broad-spectrum anti-toxin."
	icon_state = "pill1"
/obj/item/reagent_containers/pill/dylovene/New()
	..()
	reagents.add_reagent(/datum/reagent/dylovene, 15)
	color = reagents.get_color()


/obj/item/reagent_containers/pill/bicaridine
	name = "Bicaridine (20u)"
	desc = "Used to treat physical injuries."
	icon_state = "pill2"
/obj/item/reagent_containers/pill/bicaridine/New()
	..()
	reagents.add_reagent(/datum/reagent/bicaridine, 20)
	color = reagents.get_color()


/obj/item/reagent_containers/pill/happy
	name = "happy pill"
	desc = "Happy happy joy joy!"
	icon_state = "pill4"
/obj/item/reagent_containers/pill/happy/New()
	..()
	reagents.add_reagent(/datum/reagent/drugs/hextro, 15)
	reagents.add_reagent(/datum/reagent/sugar, 15)
	color = reagents.get_color()


/obj/item/reagent_containers/pill/zoom
	name = "zoom pill"
	desc = "Zoooom!"
	icon_state = "pill4"
/obj/item/reagent_containers/pill/zoom/New()
	..()
	reagents.add_reagent(/datum/reagent/impedrezene, 10)
	reagents.add_reagent(/datum/reagent/synaptizine, 5)
	reagents.add_reagent(/datum/reagent/hyperzine, 5)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/three_eye
	name = "strange pill"
	desc = "The surface of this unlabelled pill crawls against your skin."
	icon_state = "pill2"

/obj/item/reagent_containers/pill/three_eye/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drugs/three_eye, 10)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/spaceacillin
	name = "Spaceacillin (10u)"
	desc = "Contains antiviral agents."
	icon_state = "pill3"
/obj/item/reagent_containers/pill/spaceacillin/New()
	..()
	reagents.add_reagent(/datum/reagent/spaceacillin, 10)
	color = reagents.get_color()


/obj/item/reagent_containers/pill/diet
	name = "diet pill"
	desc = "Guaranteed to get you slim!"
	icon_state = "pill4"
/obj/item/reagent_containers/pill/diet/New()
	..()
	reagents.add_reagent(/datum/reagent/lipozine, 2)
	color = reagents.get_color()


/obj/item/reagent_containers/pill/noexcutite
	name = "Noexcutite (15u)"
	desc = "Feeling jittery? This should calm you down."
	icon_state = "pill4"
/obj/item/reagent_containers/pill/noexcutite/New()
	..()
	reagents.add_reagent(/datum/reagent/noexcutite, 15)
	color = reagents.get_color()


/obj/item/reagent_containers/pill/antidexafen
	name = "Antidexafen (15u)"
	desc = "Common cold mediciation. Safe for babies!"
	icon_state = "pill4"
/obj/item/reagent_containers/pill/antidexafen/New()
	..()
	reagents.add_reagent(/datum/reagent/antidexafen, 10)
	reagents.add_reagent(/datum/reagent/drink/juice/lemon, 5)
	reagents.add_reagent(/datum/reagent/menthol, REM*0.2)
	color = reagents.get_color()

//Psychiatry pills.
/obj/item/reagent_containers/pill/methylphenidate
	name = "Methylphenidate (15u)"
	desc = "Improves the ability to concentrate."
	icon_state = "pill2"
/obj/item/reagent_containers/pill/methylphenidate/New()
	..()
	reagents.add_reagent(/datum/reagent/methylphenidate, 15)
	color = reagents.get_color()


/obj/item/reagent_containers/pill/citalopram
	name = "Citalopram (15u)"
	desc = "Mild anti-depressant."
	icon_state = "pill4"
/obj/item/reagent_containers/pill/citalopram/New()
	..()
	reagents.add_reagent(/datum/reagent/citalopram, 15)
	color = reagents.get_color()


/obj/item/reagent_containers/pill/paroxetine
	name = "Paroxetine (10u)"
	desc = "Before you swallow a bullet: try swallowing this!"
	icon_state = "pill4"
/obj/item/reagent_containers/pill/paroxetine/New()
	..()
	reagents.add_reagent(/datum/reagent/paroxetine, 10)
	color = reagents.get_color()


/obj/item/reagent_containers/pill/hyronalin
	name = "Hyronalin (10u)"
	desc = "Used to treat radiation poisoning."
	icon_state = "pill1"
/obj/item/reagent_containers/pill/hyronalin/New()
	..()
	reagents.add_reagent(/datum/reagent/hyronalin, 10)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/antirad
	name = "AntiRad"
	desc = "Used to treat radiation poisoning."
	icon_state = "yellow"
/obj/item/reagent_containers/pill/antirad/New()
	..()
	reagents.add_reagent(/datum/reagent/hyronalin, 5)
	reagents.add_reagent(/datum/reagent/dylovene, 10)


/obj/item/reagent_containers/pill/sugariron
	name = "Sugar-Iron (10u)"
	desc = "Used to help the body naturally replenish blood."
	icon_state = "pill1"
/obj/item/reagent_containers/pill/sugariron/New()
	..()
	reagents.add_reagent(/datum/reagent/iron, 5)
	reagents.add_reagent(/datum/reagent/sugar, 5)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/detergent
	name = "detergent pod"
	desc = "Put in water to get space cleaner. Do not eat. Really."
	icon_state = "pod21"
	var/smell_clean_time = 10 MINUTES

/obj/item/reagent_containers/pill/detergent/New()
	..()
	reagents.add_reagent(/datum/reagent/ammonia, 30)

/obj/item/reagent_containers/pill/pod
	name = "master flavorpod item"
	desc = "A cellulose pod containing some kind of flavoring."
	icon_state = "pill4"

/obj/item/reagent_containers/pill/pod/cream
	name = "creamer pod"

/obj/item/reagent_containers/pill/pod/cream/New()
	..()
	reagents.add_reagent(/datum/reagent/drink/milk, 5)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/pod/cream_soy
	name = "non-dairy creamer pod"

/obj/item/reagent_containers/pill/pod/cream_soy/New()
	..()
	reagents.add_reagent(/datum/reagent/drink/milk/soymilk, 5)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/pod/orange
	name = "orange flavorpod"

/obj/item/reagent_containers/pill/pod/orange/New()
	..()
	reagents.add_reagent(/datum/reagent/drink/juice/orange, 5)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/pod/mint
	name = "mint flavorpod"

/obj/item/reagent_containers/pill/pod/mint/New()
	..()
	reagents.add_reagent(/datum/reagent/nutriment/mint, 1) //mint is used as a catalyst in all reactions as of writing
	color = reagents.get_color()

// Chopping up pills

/obj/item/reagent_containers/pill/use_tool(obj/item/W, mob/living/user, list/click_params)
	if(is_sharp(W) || istype(W, /obj/item/card/id))
		user.visible_message(
			SPAN_WARNING("\The [user] starts to gently cut up \the [src] with \a [W]!"),
			SPAN_NOTICE("You start to gently cut up \the [src] with \the [W]."),
			SPAN_WARNING("You hear quiet grinding.")
		)
		playsound(loc, 'sound/effects/chop.ogg', 50, 1)
		if (!do_after(user, 5 SECONDS, src, DO_PUBLIC_UNIQUE))
			return TRUE

		var/obj/item/reagent_containers/powder/J = new /obj/item/reagent_containers/powder(loc)
		user.visible_message(
			SPAN_WARNING("\The [user] gently cuts up \the [src] with \a [W]!"),
			SPAN_NOTICE("You gently cut up \the [src] with \the [W].")
		)
		playsound(loc, 'sound/effects/chop.ogg', 50, 1)

		if(reagents)
			reagents.trans_to_obj(J, reagents.total_volume)
		J.get_appearance()
		qdel(src)
		return TRUE

	return ..()
