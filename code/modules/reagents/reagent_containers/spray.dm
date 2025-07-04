/obj/item/reagent_containers/spray
	name = "spray bottle"
	desc = "A spray bottle, with an unscrewable top."
	icon = 'icons/obj/janitor_tools.dmi'
	icon_state = "cleaner"
	item_state = "cleaner"
	item_flags = ITEM_FLAG_NO_BLUDGEON
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	slot_flags = SLOT_BELT
	throwforce = 3
	w_class = ITEM_SIZE_SMALL
	throw_speed = 2
	throw_range = 10
	amount_per_transfer_from_this = 10
	unacidable = TRUE
	possible_transfer_amounts = "5;10" //Set to null instead of list, if there is only one.
	var/spray_size = 3
	var/list/spray_sizes = list(1,3)
	var/step_delay = 10 // lower is faster
	volume = 250

/obj/item/reagent_containers/spray/New()
	..()
	src.verbs -= /obj/item/reagent_containers/verb/set_amount_per_transfer_from_this

/obj/item/reagent_containers/spray/afterattack(atom/A as mob|obj, mob/user as mob, proximity)
	if(istype(A, /obj/item/storage) || istype(A, /obj/structure/table) || istype(A, /obj/structure/closet) || istype(A, /obj/item/reagent_containers) || istype(A, /obj/structure/hygiene/sink) || istype(A, /obj/structure/janitorialcart))
		return

	if(istype(A, /spell))
		return

	if(proximity)
		if(standard_dispenser_refill(user, A))
			return

	if(reagents.total_volume < amount_per_transfer_from_this)
		to_chat(user, SPAN_NOTICE("\The [src] is empty!"))
		return

	Spray_at(A, user, proximity)

	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
	return

/obj/item/reagent_containers/spray/proc/Spray_at(atom/A as mob|obj, mob/user as mob, proximity)
	playsound(src.loc, 'sound/effects/spray2.ogg', 50, 1, -6)
	if (reagents.should_admin_log())
		var/contained = reagents.get_reagents()
		if (ismob(A))
			admin_attack_log(user, A, "Used \the [src] containing [contained] to spray the victim", "Was sprayed by \the [src] containing [contained]", "used \the [src] containing [contained] to spray")
		else
			admin_attacker_log(user, "Used \the [name] containing [contained] to spray \the [A]")
	if (A.density && proximity)
		reagents.splash(A, amount_per_transfer_from_this)
		if(A == user)
			A.visible_message(SPAN_NOTICE("\The [user] sprays themselves with \the [src]."))
		else
			A.visible_message(SPAN_NOTICE("\The [user] sprays \the [A] with \the [src]."))
	else
		spawn(0)
			var/obj/effect/water/chempuff/D = new/obj/effect/water/chempuff(get_turf(src))
			var/turf/my_target = get_turf(A)
			D.create_reagents(amount_per_transfer_from_this)
			if(!src)
				return
			reagents.trans_to_obj(D, amount_per_transfer_from_this)
			D.set_up(my_target, spray_size, step_delay)
	return

/obj/item/reagent_containers/spray/attack_self(mob/user)
	if(!possible_transfer_amounts)
		return
	amount_per_transfer_from_this = next_in_list(amount_per_transfer_from_this, cached_number_list_decode(possible_transfer_amounts))
	spray_size = next_in_list(spray_size, spray_sizes)
	to_chat(user, SPAN_NOTICE("You adjusted the pressure nozzle. You'll now use [amount_per_transfer_from_this] units per spray."))

/obj/item/reagent_containers/spray/examine(mob/user, distance)
	. = ..()
	if(distance > 0)
		return

	if(length(reagents?.reagent_list))
		to_chat(user, SPAN_NOTICE("It contains [round(reagents.total_volume)] units of liquid."))
	else
		to_chat(user, SPAN_NOTICE("It is empty."))

/obj/item/reagent_containers/spray/verb/empty()

	set name = "Empty Spray Bottle"
	set category = "Object"
	set src in usr

	if (alert(usr, "Are you sure you want to empty that?", "Empty Bottle:", "Yes", "No") != "Yes")
		return
	if(isturf(usr.loc))
		to_chat(usr, SPAN_NOTICE("You empty \the [src] onto the floor."))
		reagents.splash(usr.loc, reagents.total_volume)

//space cleaner
/obj/item/reagent_containers/spray/cleaner
	name = "space cleaner"
	desc = "BLAM!-brand non-foaming space cleaner!"
	step_delay = 6

/obj/item/reagent_containers/spray/cleaner/New()
	..()
	reagents.add_reagent(/datum/reagent/space_cleaner, volume)

/obj/item/reagent_containers/spray/sterilizine
	name = "sterilizine"
	desc = "Great for hiding incriminating bloodstains and sterilizing scalpels."

/obj/item/reagent_containers/spray/sterilizine/New()
	..()
	reagents.add_reagent(/datum/reagent/sterilizine, volume)

/obj/item/reagent_containers/spray/hair_remover
	name = "hair remover"
	desc = "Very effective at removing hair, feathers, spines and horns."

/obj/item/reagent_containers/spray/hair_remover/New()
	..()
	reagents.add_reagent(/datum/reagent/toxin/hair_remover, volume)

/obj/item/reagent_containers/spray/pepper
	name = "pepperspray"
	desc = "Manufactured by Uhang Inc., it fires a mist of condensed capsaicin to blind and down an opponent quickly."
	icon = 'icons/obj/weapons/other.dmi'
	icon_state = "pepperspray"
	item_state = "pepperspray"
	possible_transfer_amounts = null
	volume = 60
	var/safety = 1
	step_delay = 1

/obj/item/reagent_containers/spray/pepper/New()
	..()
	reagents.add_reagent(/datum/reagent/capsaicin/condensed, 60)

/obj/item/reagent_containers/spray/pepper/examine(mob/user, distance)
	. = ..()
	if(distance <= 1)
		to_chat(user, "The safety is [safety ? "on" : "off"].")

/obj/item/reagent_containers/spray/pepper/attack_self(mob/user)
	safety = !safety
	to_chat(usr, SPAN_NOTICE("You switch the safety [safety ? "on" : "off"]."))

/obj/item/reagent_containers/spray/pepper/Spray_at(atom/A as mob|obj)
	if(safety)
		to_chat(usr, SPAN_WARNING("The safety is on!"))
		return
	..()

/obj/item/reagent_containers/spray/waterflower
	name = "water flower"
	desc = "A seemingly innocent sunflower...with a twist."
	icon = 'icons/obj/flora/sunflower.dmi'
	icon_state = "sunflower"
	item_state = "sunflower"
	amount_per_transfer_from_this = 1
	possible_transfer_amounts = null
	volume = 10

/obj/item/reagent_containers/spray/waterflower/New()
	..()
	reagents.add_reagent(/datum/reagent/water, 10)

/obj/item/reagent_containers/spray/chemsprayer
	name = "industrial chemical sprayer"
	desc = "A utility used to spray large amounts of reagent in a given area."
	icon = 'icons/obj/weapons/other.dmi'
	icon_state = "chemsprayer"
	item_icons = list(
		slot_r_hand_str = 'icons/mob/onmob/items/righthand.dmi',
		slot_l_hand_str = 'icons/mob/onmob/items/lefthand.dmi'
	)
	item_state = "chemsprayer"
	throwforce = 3
	w_class = ITEM_SIZE_LARGE
	possible_transfer_amounts = null
	volume = 600
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_ENGINEERING = 3)
	unacidable = 1
	step_delay = 8

/obj/item/reagent_containers/spray/chemsprayer/Spray_at(atom/A, mob/user, proximity)
	playsound(src.loc, 'sound/effects/spray.ogg', 50, 1, -6)
	var/direction = get_dir(src, A)
	var/turf/T = get_turf(A)
	var/turf/T1 = get_step(T,turn(direction, 90))
	var/turf/T2 = get_step(T,turn(direction, -90))
	var/list/the_targets = list(T, T1, T2)

	if (reagents.should_admin_log())
		var/contained = reagents.get_reagents()
		if (ismob(A))
			admin_attack_log(user, A, "Used \the [src] containing [contained] to spray the victim", "Was sprayed by \the [src] containing [contained]", "used \the [src] containing [contained] to spray")
		else
			admin_attacker_log(user, "Used \the [name] containing [contained] to spray \the [A]")

	for(var/a = 1 to 3)
		spawn(0)
			if(reagents.total_volume < 1) break
			var/obj/effect/water/chempuff/D = new/obj/effect/water/chempuff(get_turf(src))
			var/turf/my_target = the_targets[a]
			D.create_reagents(amount_per_transfer_from_this)
			if(!src)
				return
			reagents.trans_to_obj(D, amount_per_transfer_from_this)
			D.set_color()
			D.set_up(my_target, rand(6, 8), 2)
	return

/obj/item/reagent_containers/spray/plantbgone
	name = "Plant-B-Gone"
	desc = "Kills those pesky weeds!"
	icon = 'icons/obj/machines/hydroponics_machines.dmi'
	icon_state = "plantbgone"
	item_state = "plantbgone"
	volume = 100

/obj/item/reagent_containers/spray/plantbgone/New()
	..()
	reagents.add_reagent(/datum/reagent/toxin/plantbgone, 100)

/obj/item/reagent_containers/spray/plantbgone/afterattack(atom/A as mob|obj, mob/user as mob, proximity)
	if(!proximity) return

	if(istype(A, /obj/blob)) // blob damage in blob code
		return

	..()

/obj/item/reagent_containers/spray/cleaner/deodorant
	name = "deodorant"
	desc = "A can of Gold Standard spray deodorant - for when you're too lazy to shower."
	gender = PLURAL
	volume = 35
	icon = 'icons/obj/lavatory.dmi'
	icon_state = "deodorant"
	item_state = "deodorant"
