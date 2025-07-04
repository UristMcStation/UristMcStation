#define ENERGY_PER_NUTRIMENT 30

/obj/item/reagent_containers/food/snacks
	name = "snack"
	desc = "Yummy!"
	icon = 'icons/obj/food/food.dmi'
	center_of_mass = "x=16;y=16"
	var/bitesize = 1
	var/bitecount = 0
	var/slice_path
	var/slices_num
	var/dried_type = null
	var/dry = 0
	var/nutriment_amt = 0
	var/list/nutriment_desc = list("food" = 1)
	var/list/eat_sound = 'sound/items/eatfood.ogg'
	var/obj/item/trash
	var/sushi_overlay
	var/can_use_cooker = TRUE


/obj/item/reagent_containers/food/snacks/Destroy()
	if (trash && !ispath(trash))
		QDEL_NULL(trash)
	return ..()


/obj/item/reagent_containers/food/snacks/Initialize()
	. = ..()
	if (nutriment_amt)
		reagents.add_reagent(/datum/reagent/nutriment, nutriment_amt, nutriment_desc)


/obj/item/reagent_containers/food/snacks/proc/OnConsume(mob/living/consumer, mob/living/feeder)
	if (reagents && reagents.total_volume)
		return
	if (consumer)
		consumer.visible_message(
			SPAN_ITALIC("\The [consumer] finishes eating \the [src]."),
			SPAN_ITALIC("You finish eating \the [src].")
		)
		consumer.update_personal_goal(/datum/goal/achievement/specific_object/food, type)
	if (feeder)
		feeder.drop_from_inventory(src, feeder.loc)
	if (loc && trash)
		if (ispath(trash))
			trash = new trash
		if (feeder)
			feeder.put_in_hands(trash)
		else
			trash.dropInto(loc)
		trash = null
	qdel(src)


/obj/item/reagent_containers/food/snacks/attack_self(mob/user as mob)
	return


/obj/item/reagent_containers/food/snacks/use_before(mob/M as mob, mob/user as mob)
	. = FALSE
	if (!istype(M, /mob/living/carbon))
		return FALSE
	if (!reagents || !reagents.total_volume)
		to_chat(user, SPAN_DANGER("None of [src] left!"))
		qdel(src)
		return TRUE
	if (!is_open_container())
		to_chat(user, SPAN_NOTICE("\The [src] isn't open!"))
		return TRUE

	//TODO: replace with standard_feed_mob() call.
	var/mob/living/carbon/C = M
	var/fullness = C.get_fullness()
	if (C == user)								//If you're eating it yourself
		if (istype(C,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = M
			if (!H.check_has_mouth())
				to_chat(user, "Where do you intend to put \the [src]? You don't have a mouth!")
				return TRUE
			var/obj/item/blocked = H.check_mouth_coverage()
			if (blocked)
				to_chat(user, SPAN_WARNING("\The [blocked] is in the way!"))
				return TRUE

		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)//puts a limit on how fast people can eat/drink things
		if (fullness <= 50)
			to_chat(C, SPAN_DANGER("You hungrily chew out a piece of [src] and gobble it!"))
		if (fullness > 50 && fullness <= 150)
			to_chat(C, SPAN_NOTICE("You hungrily begin to eat [src]."))
		if (fullness > 150 && fullness <= 350)
			to_chat(C, SPAN_NOTICE("You take a bite of [src]."))
		if (fullness > 350 && fullness <= 550)
			to_chat(C, SPAN_NOTICE("You unwillingly chew a bit of [src]."))
		if (fullness > 550)
			to_chat(C, SPAN_DANGER("You cannot force any more of [src] to go down your throat."))
			return TRUE
	else
		if(!M.can_force_feed(user, src))
			return TRUE

		if (fullness <= 550)
			user.visible_message(SPAN_DANGER("[user] attempts to feed [M] [src]."))
		else
			user.visible_message(SPAN_DANGER("[user] cannot force anymore of [src] down [M]'s throat."))
			return TRUE

		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		if (!do_after(user, 3 SECONDS, M, DO_DEFAULT | DO_USER_UNIQUE_ACT | DO_PUBLIC_PROGRESS))
			return TRUE

		if (user.get_active_hand() != src)
			return TRUE

		var/contained = reagentlist()
		admin_attack_log(user, M, "Fed the victim with [name] (Reagents: [contained])", "Was fed [src] (Reagents: [contained])", "used [src] (Reagents: [contained]) to feed")
		user.visible_message(SPAN_DANGER("[user] feeds [M] [src]."))

	if(reagents) //Handle ingestion of the reagent.
		if(eat_sound)
			playsound(M, pick(eat_sound), rand(10, 50), 1)
		if(reagents.total_volume)
			var/obj/item/organ/internal/cell/potato = C.internal_organs_by_name[BP_CELL]
			var/mob/living/carbon/human/H = M
			if(reagents.total_volume > bitesize)
				reagents.trans_to_mob(M, bitesize, CHEM_INGEST)
				if(potato && H.isFBP())
					potato.cell.give((reagents.get_reagent_amount(/datum/reagent/nutriment) / reagents.total_volume) * bitesize * ENERGY_PER_NUTRIMENT)
			else
				reagents.trans_to_mob(M, reagents.total_volume, CHEM_INGEST)
				if(potato && H.isFBP())
					potato.cell.give(reagents.get_reagent_amount(/datum/reagent/nutriment) * ENERGY_PER_NUTRIMENT)
			bitecount++
			OnConsume(M, user)
		return TRUE

/obj/item/reagent_containers/food/snacks/examine(mob/user, distance)
	. = ..()
	if(distance > 1)
		return
	if (bitecount==0)
		return
	else if (bitecount==1)
		to_chat(user, SPAN_NOTICE("\The [src] was bitten by someone!"))
	else if (bitecount<=3)
		to_chat(user, SPAN_NOTICE("\The [src] was bitten [bitecount] time\s!"))
	else
		to_chat(user, SPAN_NOTICE("\The [src] was bitten multiple times!"))

/obj/item/reagent_containers/food/snacks/use_tool(obj/item/W, mob/living/user, list/click_params)
	if(istype(W,/obj/item/storage))
		return ..()
	if(!is_open_container())
		to_chat(user, SPAN_WARNING("\The [src] isn't open!"))
		return TRUE
	// Eating with forks
	if(istype(W,/obj/item/material/utensil))
		var/obj/item/material/utensil/U = W
		if(U.scoop_food)
			if(!U.reagents)
				U.create_reagents(5)

			if (U.reagents.total_volume > 0)
				to_chat(user, SPAN_WARNING("You already have something on \the [U]."))
				return TRUE

			to_chat(user, SPAN_NOTICE("You scoop up some \the [src] with \the [U]!"))

			bitecount++
			U.ClearOverlays()
			U.loaded = "[src]"
			var/image/I = new(U.icon, "loadedfood")
			I.color = src.filling_color
			U.AddOverlays(I)

			if(!reagents)
				crash_with("A snack [type] failed to have a reagent holder when attacked with a [W.type]. It was [QDELETED(src) ? "" : "not"] being deleted.")
			else
				reagents.trans_to_obj(U, min(reagents.total_volume,5))
				if (reagents.total_volume <= 0)
					if (loc && trash)
						if (ispath(trash))
							trash = new trash
						trash.dropInto(loc)
						trash = null
					qdel(src)
			return TRUE

	if (is_sliceable())
		//these are used to allow hiding edge items in food that is not on a table/tray
		var/can_slice_here = isturf(src.loc) && ((locate(/obj/structure/table) in src.loc) || (locate(/obj/machinery/optable) in src.loc) || (locate(/obj/item/tray) in src.loc))
		var/hide_item = !has_edge(W) || !can_slice_here

		if (hide_item)
			if (W.w_class >= src.w_class || is_robot_module(W) || istype(W,/obj/item/reagent_containers/food/condiment))
				return ..()
			if(!user.unEquip(W, src))
				FEEDBACK_UNEQUIP_FAILURE(user, W)
				return TRUE

			to_chat(user, SPAN_WARNING("You slip \the [W] inside \the [src]."))
			W.forceMove(src)
			return TRUE

		if (has_edge(W))
			if (!can_slice_here)
				to_chat(user, SPAN_WARNING("You cannot slice \the [src] here! You need a table or at least a tray to do it."))
				return TRUE

			var/slices_lost = 0
			if (W.w_class > 3)
				user.visible_message(SPAN_NOTICE("\The [user] crudely slices \the [src] with [W]!"), SPAN_NOTICE("You crudely slice \the [src] with your [W]!"))
				slices_lost = rand(1,min(1,round(slices_num/2)))
			else
				user.visible_message(SPAN_NOTICE("\The [user] slices \the [src]!"), SPAN_NOTICE("You slice \the [src]!"))

			var/reagents_per_slice = reagents.total_volume/slices_num
			for(var/i=1 to (slices_num-slices_lost))
				var/obj/item/reagent_containers/food/snacks/S = new slice_path (src.loc)
				reagents.trans_to_obj(S, reagents_per_slice)

				if(istype(src, /obj/item/reagent_containers/food/snacks/sliceable/variable))
					S.SetName("[name] slice")
					S.filling_color = filling_color
					var/image/I = image(S.icon, "[S.icon_state]_filling")
					I.color = filling_color
					S.AddOverlays(I)

			qdel(src)
			return TRUE

	return ..()

/obj/item/reagent_containers/food/snacks/proc/is_sliceable()
	return (slices_num && slice_path && slices_num > 0)

/obj/item/reagent_containers/food/snacks/Destroy()
	if(contents)
		for(var/atom/movable/something in contents)
			something.dropInto(loc)
	. = ..()

/obj/item/reagent_containers/food/snacks/use_after(obj/item/reagent_containers/food/drinks/glass2/glass, mob/user)
	if(!istype(glass))
		return FALSE
	if(w_class != ITEM_SIZE_TINY)
		to_chat(user, SPAN_NOTICE("\The [src] is too big to properly dip in \the [glass]."))
		return TRUE

	var/transfered = glass.reagents.trans_to_obj(src, volume)
	if(transfered)	//if reagents were transfered, show the message
		to_chat(user, SPAN_NOTICE("You dip \the [src] into \the [glass]."))
	else			//if not, either the glass was empty, or the food was full
		if(!glass.reagents.total_volume)
			to_chat(user, SPAN_NOTICE("\The [glass] is empty."))
		else
			to_chat(user, SPAN_NOTICE("\The [src] is full."))
	return TRUE

////////////////////////////////////////////////////////////////////////////////
/// FOOD END
////////////////////////////////////////////////////////////////////////////////
/obj/item/reagent_containers/food/snacks/attack_animal(mob/living/user)
	if(!isanimal(user) && !isalien(user))
		return
	user.visible_message("<b>[user]</b> nibbles away at \the [src].","You nibble away at \the [src].")
	bitecount++
	if(reagents && user.reagents)
		reagents.trans_to_mob(user, bitesize, CHEM_INGEST)
	spawn(5)
		if(!src && !user.client)
			user.custom_emote(1,"[pick("burps", "cries for more", "burps twice", "looks at the area where the food was")]")
			qdel(src)
	OnConsume(user, user)

//////////////////////////////////////////////////
////////////////////////////////////////////Snacks
//////////////////////////////////////////////////
//Items in the "Snacks" subcategory are food items that people actually eat. The key points are that they are created
//	already filled with reagents and are destroyed when empty. Additionally, they make a "munching" noise when eaten.

//Notes by Darem: Food in the "snacks" subtype can hold a maximum of 50 units Generally speaking, you don't want to go over 40
//	total for the item because you want to leave space for extra condiments. If you want effect besides healing, add a reagent for
//	it. Try to stick to existing reagents when possible (so if you want a stronger healing effect, just use Tricordrazine). On use
//	effect (such as the old officer eating a donut code) requires a unique reagent (unless you can figure out a better way).

//The nutriment reagent and bitesize variable replace the old heal_amt and amount variables. Each unit of nutriment is equal to
//	2 of the old heal_amt variable. bitesize is the rate at which the reagents are consumed. So if you have 6 nutriment and a
//	bitesize of 2, then it'll take 3 bites to eat. Unlike the old system, the contained reagents are evenly spread among all
//	the bites. No more contained reagents = no more bites.

//Here is an example of the new formatting for anyone who wants to add more food items.
///obj/item/reagent_containers/food/snacks/meatburger			//Identification path for the object.
//	name = "Xenoburger"													//Name that displays in the UI.
//	desc = "Smells caustic. Tastes like heresy."						//Duh
//	icon_state = "xburger"												//Refers to an icon in food.dmi
//	New()																//Don't mess with this.
//		..()															//Same here.
//		reagents.add_reagent(/datum/reagent/xenomicrobes, 10)						//This is what is in the food item. you may copy/paste
//		reagents.add_reagent(/datum/reagent/nutriment, 2)							//	this line of code for all the contents.
//		bitesize = 3													//This is the amount each bite consumes.




/obj/item/reagent_containers/food/snacks/aesirsalad
	name = "aesir salad"
	desc = "Probably too incredible for mortal men to fully enjoy."
	icon_state = "aesirsalad"
	volume = 100
	trash = /obj/item/trash/snack_bowl
	filling_color = "#468c00"
	center_of_mass = "x=17;y=11"
	bitesize = 3
/obj/item/reagent_containers/food/snacks/aesirsalad/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/drink/doctor_delight, 4)
	reagents.add_reagent(/datum/reagent/tricordrazine, 4)


/obj/item/reagent_containers/food/snacks/egg
	name = "egg"
	desc = "An egg!"
	icon_state = "egg"
	filling_color = "#fdffd1"
	volume = 10
	center_of_mass = "x=16;y=13"

/obj/item/reagent_containers/food/snacks/egg/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/nutriment/protein/egg, 3)

/obj/item/reagent_containers/food/snacks/egg/use_after(obj/O, mob/living/user, click_parameters)
	if(istype(O,/obj/machinery/microwave))
		return FALSE
	if(!O.is_open_container())
		return TRUE
	to_chat(user, "You crack \the [src] into \the [O].")
	reagents.trans_to(O, reagents.total_volume)
	qdel(src)
	return TRUE

/obj/item/reagent_containers/food/snacks/egg/throw_impact(atom/hit_atom)
	if(QDELETED(src))
		return // Could potentially happen with unscupulous atoms on hitby() throwing again, etc.
	new/obj/decal/cleanable/egg_smudge(src.loc)
	reagents.splash(hit_atom, reagents.total_volume)
	visible_message(SPAN_WARNING("\The [src] has been squashed!"),SPAN_WARNING("You hear a smack."))
	..()
	qdel(src)

/obj/item/reagent_containers/food/snacks/egg/use_tool(obj/item/W, mob/living/user, list/click_params)
	if(istype(W, /obj/item/pen/crayon))
		var/obj/item/pen/crayon/C = W
		var/clr = C.colourName

		if(!(clr in list("blue","green","mime","orange","purple","rainbow","red","yellow")))
			to_chat(usr, SPAN_NOTICE("The egg refuses to take on this color!"))
			return TRUE

		to_chat(usr, SPAN_NOTICE("You color \the [src] [clr]"))
		icon_state = "egg-[clr]"
		return TRUE
	else
		return ..()

/obj/item/reagent_containers/food/snacks/egg/blue
	icon_state = "egg-blue"

/obj/item/reagent_containers/food/snacks/egg/green
	icon_state = "egg-green"

/obj/item/reagent_containers/food/snacks/egg/mime
	icon_state = "egg-mime"

/obj/item/reagent_containers/food/snacks/egg/orange
	icon_state = "egg-orange"

/obj/item/reagent_containers/food/snacks/egg/purple
	icon_state = "egg-purple"

/obj/item/reagent_containers/food/snacks/egg/rainbow
	icon_state = "egg-rainbow"

/obj/item/reagent_containers/food/snacks/egg/red
	icon_state = "egg-red"

/obj/item/reagent_containers/food/snacks/egg/yellow
	icon_state = "egg-yellow"

/obj/item/reagent_containers/food/snacks/egg/lizard
	name = "unathi egg"
	desc = "Large, slightly elongated egg with a thick shell."
	icon_state = "lizard_egg"
	w_class = ITEM_SIZE_SMALL

/obj/item/reagent_containers/food/snacks/egg/lizard/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/nutriment/protein/egg, 5)
	if(prob(30))	//extra nutriment
		reagents.add_reagent(/datum/reagent/nutriment/protein, 5)

/obj/item/reagent_containers/food/snacks/friedegg
	name = "fried egg"
	desc = "A fried egg, with a touch of salt and pepper."
	icon_state = "friedegg"
	filling_color = "#ffdf78"
	center_of_mass = "x=16;y=14"
	bitesize = 1
	sushi_overlay = "egg"


/obj/item/reagent_containers/food/snacks/boiledegg
	name = "boiled egg"
	desc = "A hard boiled egg."
	icon_state = "egg"
	filling_color = "#ffffff"

/obj/item/reagent_containers/food/snacks/organ
	name = "organ"
	desc = "It's good for you."
	icon = 'icons/obj/organs.dmi'
	icon_state = "appendix"
	filling_color = "#e00d34"
	center_of_mass = "x=16;y=16"
	bitesize = 3
/obj/item/reagent_containers/food/snacks/organ/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, rand(3,5))
	reagents.add_reagent(/datum/reagent/toxin, rand(1,3))


/obj/item/reagent_containers/food/snacks/tofu
	name = "tofu"
	icon_state = "tofu"
	desc = "We all love tofu."
	filling_color = "#fffee0"
	center_of_mass = "x=17;y=10"
	sushi_overlay = "tofu"
	bitesize = 3

/obj/item/reagent_containers/food/snacks/tofu/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/nutriment/softtofu, 6)


/obj/item/reagent_containers/food/snacks/stuffing
	name = "stuffing"
	desc = "Moist, peppery breadcrumbs for filling the body cavities of dead birds. Dig in!"
	icon_state = "stuffing"
	filling_color = "#c9ac83"
	center_of_mass = "x=16;y=10"
	nutriment_amt = 6
	nutriment_desc = list("dryness" = 3, "bread" = 3)
	bitesize = 1

/obj/item/reagent_containers/food/snacks/fishfingers
	name = "fish fingers"
	desc = "A finger of fish."
	icon_state = "fishfingers"
	filling_color = "#ffdefe"
	center_of_mass = "x=16;y=13"
	bitesize = 3
/obj/item/reagent_containers/food/snacks/fishfingers/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 4)

/obj/item/reagent_containers/food/snacks/hugemushroomslice
	name = "huge mushroom slice"
	desc = "A slice from a huge mushroom."
	icon_state = "hugemushroomslice"
	filling_color = "#e0d7c5"
	center_of_mass = "x=17;y=16"
	nutriment_amt = 3
	nutriment_desc = list("fleshy mushroom" = 2)
	bitesize = 6
/obj/item/reagent_containers/food/snacks/hugemushroomslice/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/drugs/psilocybin, 3)

/obj/item/reagent_containers/food/snacks/tomatomeat
	name = "tomato slice"
	desc = "A slice from a huge tomato."
	icon_state = "tomatomeat"
	filling_color = "#db0000"
	center_of_mass = "x=17;y=16"
	nutriment_amt = 3
	nutriment_desc = list("fleshy tomato" = 3)
	bitesize = 6

/obj/item/reagent_containers/food/snacks/bearmeat
	name = "bear meat"
	desc = "A very manly slab of meat."
	icon_state = "bearmeat"
	filling_color = "#db0000"
	center_of_mass = "x=16;y=10"
	bitesize = 3
/obj/item/reagent_containers/food/snacks/bearmeat/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 12)
	reagents.add_reagent(/datum/reagent/hyperzine, 5)

/obj/item/reagent_containers/food/snacks/spider
	name = "giant spider leg"
	desc = "An economical replacement for crab. In space! Would probably be a lot nicer cooked."
	icon_state = "spiderleg"
	filling_color = "#d5f5dc"
	center_of_mass = "x=16;y=10"
	bitesize = 3

/obj/item/reagent_containers/food/snacks/spider/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 9)

/obj/item/reagent_containers/food/snacks/spider/cooked
	name = "boiled spider meat"
	desc = "An economical replacement for crab. In space!"
	icon_state = "spiderleg_c"
	bitesize = 5

/obj/item/reagent_containers/food/snacks/xenomeat
	name = "meat"
	desc = "A slab of green meat. Smells like acid."
	icon_state = "xenomeat"
	filling_color = "#43de18"
	center_of_mass = "x=16;y=10"
	bitesize = 6
/obj/item/reagent_containers/food/snacks/xenomeat/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 6)
	reagents.add_reagent(/datum/reagent/acid/polyacid,6)

/obj/item/reagent_containers/food/snacks/meatball
	name = "meatball"
	desc = "A great meal all round."
	icon_state = "meatball"
	filling_color = "#db0000"
	center_of_mass = "x=16;y=16"
	bitesize = 2
/obj/item/reagent_containers/food/snacks/meatball/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 2)

/obj/item/reagent_containers/food/snacks/sausage
	name = "sausage"
	desc = "A piece of mixed, long meat."
	icon = 'icons/obj/food/food_ingredients.dmi'
	icon_state = "sausage"
	filling_color = "#db0000"
	center_of_mass = "x=16;y=16"
	bitesize = 2
/obj/item/reagent_containers/food/snacks/sausage/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 3)

/obj/item/reagent_containers/food/snacks/fatsausage
	name = "fat sausage"
	desc = "A piece of mixed, long meat, with some bite to it."
	icon_state = "sausage"
	filling_color = "#db0000"
	center_of_mass = "x=16;y=16"
	bitesize = 2
/obj/item/reagent_containers/food/snacks/fatsausage/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 5)





/obj/item/reagent_containers/food/snacks/brainburger
	name = "brainburger"
	desc = "A strange looking burger. It looks almost sentient."
	icon_state = "brainburger"
	filling_color = "#f2b6ea"
	center_of_mass = "x=15;y=11"
	bitesize = 2
	nutriment_amt = 3
	nutriment_desc = list("bun" = 2, "brain" = 3)

/obj/item/reagent_containers/food/snacks/brainburger/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 1)
	reagents.add_reagent(/datum/reagent/alkysine, 6)

/obj/item/reagent_containers/food/snacks/ghostburger
	name = "ghost burger"
	desc = "Spooky! It doesn't look very filling."
	icon_state = "ghostburger"
	filling_color = "#fff2ff"
	center_of_mass = "x=16;y=11"
	nutriment_desc = list("buns" = 3, "spookiness" = 3)
	nutriment_amt = 3
	bitesize = 2

/obj/item/reagent_containers/food/snacks/human
	var/hname = ""
	var/job = null
	filling_color = "#d63c3c"

/obj/item/reagent_containers/food/snacks/human/burger
	name = "-burger"
	desc = "A bloody burger."
	icon_state = "hburger"
	center_of_mass = "x=16;y=11"
	bitesize = 2
/obj/item/reagent_containers/food/snacks/human/burger/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 6)

//Exceptionally no nutriment_amt as this is created only by adding cheese to a burger; re-adding bun nutriment would double it up.
/obj/item/reagent_containers/food/snacks/cheeseburger
	name = "cheeseburger"
	desc = "The cheese adds a good flavor."
	icon_state = "cheeseburger"
	center_of_mass = "x=16;y=11"

/obj/item/reagent_containers/food/snacks/meatburger
	name = "burger"
	desc = "The cornerstone of every nutritious breakfast."
	icon_state = "hburger"
	filling_color = "#d63c3c"
	center_of_mass = "x=16;y=11"
	nutriment_desc = list("bun" = 2)
	nutriment_amt = 3
	bitesize = 2

/obj/item/reagent_containers/food/snacks/fishburger
	name = "fish sandwich"
	desc = "Almost like a carp is yelling somewhere... Give me back that fillet -o- carp, give me that carp."
	icon_state = "fishburger"
	filling_color = "#ffdefe"
	center_of_mass = "x=16;y=10"
	bitesize = 3
	nutriment_amt = 3
	nutriment_desc = list("bun" = 2)


/obj/item/reagent_containers/food/snacks/tofuburger
	name = "tofu burger"
	desc = "What.. is that meat?"
	icon_state = "tofuburger"
	filling_color = "#fffee0"
	center_of_mass = "x=16;y=10"
	nutriment_desc = list("bun" = 2, "pseudo-meat" = 3)
	nutriment_amt = 3
	bitesize = 2

/obj/item/reagent_containers/food/snacks/roburger
	name = "roburger"
	desc = "The lettuce is the only organic component. Beep."
	icon_state = "roburger"
	filling_color = COLOR_GRAY80
	center_of_mass = "x=16;y=11"
	nutriment_desc = list("bun" = 2, "metal" = 3)
	nutriment_amt = 3
	bitesize = 2

/obj/item/reagent_containers/food/snacks/roburger/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/nanites, 2)

/obj/item/reagent_containers/food/snacks/roburgerbig
	name = "roburger"
	desc = "This massive patty looks like poison. Beep."
	icon_state = "roburger"
	filling_color = COLOR_GRAY80
	volume = 100
	center_of_mass = "x=16;y=11"
	bitesize = 0.1
/obj/item/reagent_containers/food/snacks/roburgerbig/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/nanites, 100)

/obj/item/reagent_containers/food/snacks/clownburger
	name = "clown burger"
	desc = "This tastes funny..."
	icon_state = "clownburger"
	filling_color = "#ff00ff"
	center_of_mass = "x=17;y=12"
	nutriment_desc = list("bun" = 2)
	nutriment_amt = 3
	bitesize = 2

/obj/item/reagent_containers/food/snacks/clownburger/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/carbon, 3)

/obj/item/reagent_containers/food/snacks/mimeburger
	name = "mime burger"
	desc = "Its taste defies language."
	icon_state = "mimeburger"
	filling_color = "#ffffff"
	center_of_mass = "x=16;y=11"
	nutriment_desc = list("bun" = 2)
	nutriment_amt = 3
	bitesize = 2

/obj/item/reagent_containers/food/snacks/mimeburger/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/colored_hair_dye/white, 3)

/obj/item/reagent_containers/food/snacks/omelette
	name = "cheese omelette"
	desc = "Omelette with cheese!"
	icon_state = "omelette"
	trash = /obj/item/trash/plate
	filling_color = "#fff9a8"
	center_of_mass = "x=16;y=13"
	bitesize = 1

/obj/item/reagent_containers/food/snacks/muffin
	name = "muffin"
	desc = "A delicious and spongy little cake."
	icon_state = "muffin"
	filling_color = "#e0cf9b"
	center_of_mass = "x=17;y=4"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/bananapie
	name = "banana cream pie"
	desc = "Just like back home, on clown planet! HONK!"
	icon_state = "pie"
	trash = /obj/item/trash/plate
	filling_color = "#fbffb8"
	center_of_mass = "x=16;y=13"
	nutriment_desc = list("pie" = 2)
	nutriment_amt = 3
	bitesize = 3

/obj/item/reagent_containers/food/snacks/pie/throw_impact(atom/hit_atom)
	..()
	new/obj/decal/cleanable/pie_smudge(src.loc)
	src.visible_message(SPAN_DANGER("\The [src.name] splats."),SPAN_DANGER("You hear a splat."))
	qdel(src)

/obj/item/reagent_containers/food/snacks/berryclafoutis
	name = "berry clafoutis"
	desc = "No black birds, this is a good sign."
	icon_state = "berryclafoutis"
	trash = /obj/item/trash/plate
	center_of_mass = "x=16;y=13"
	nutriment_desc = list("pie" = 2)
	nutriment_amt = 3
	bitesize = 3

/obj/item/reagent_containers/food/snacks/waffles
	name = "waffles"
	desc = "Mmm, waffles."
	icon_state = "waffles"
	trash = /obj/item/trash/waffles
	filling_color = "#e6deb5"
	center_of_mass = "x=15;y=11"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/pancakesblu
	name = "blueberry pancakes"
	desc = "Pancakes with blueberries, delicious."
	icon_state = "pancakes_berry"
	trash = /obj/item/trash/plate
	center_of_mass = "x=15;y=11"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/pancakes
	name = "pancakes"
	desc = "Pancakes without blueberries, still delicious."
	icon_state = "pancakes"
	trash = /obj/item/trash/plate
	center_of_mass = "x=15;y=11"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/eggplantparm
	name = "eggplant parmigiana"
	desc = "The only good recipe for eggplant."
	icon_state = "eggplantparm"
	trash = /obj/item/trash/plate
	filling_color = "#4d2f5e"
	center_of_mass = "x=16;y=11"
	nutriment_desc = list("cheese" = 3, "eggplant" = 3)
	nutriment_amt = 6
	bitesize = 2

/obj/item/reagent_containers/food/snacks/soylentgreen
	name = "soylent green"
	desc = "Not made of people. Honest."
	icon_state = "soylent_green"
	trash = /obj/item/trash/waffles
	filling_color = "#b8e6b5"
	center_of_mass = "x=15;y=11"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/soylenviridians
	name = "soylen virdians"
	desc = "Not made of people. Honest."
	icon_state = "soylent_yellow"
	trash = /obj/item/trash/waffles
	filling_color = "#e6fa61"
	center_of_mass = "x=15;y=11"
	nutriment_desc = list("some sort of protein" = 10)
	nutriment_amt = 10
	bitesize = 2

/obj/item/reagent_containers/food/snacks/meatpie
	name = "meat-pie"
	icon_state = "meatpie"
	desc = "An old barber recipe, very delicious!"
	trash = /obj/item/trash/plate
	filling_color = "#948051"
	center_of_mass = "x=16;y=13"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/tofupie
	name = "tofu-pie"
	icon_state = "meatpie"
	desc = "A delicious tofu pie."
	trash = /obj/item/trash/plate
	filling_color = "#fffee0"
	center_of_mass = "x=16;y=13"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/amanita_pie
	name = "amanita pie"
	desc = "Sweet and tasty poison pie."
	icon_state = "amanita_pie"
	filling_color = "#ffcccc"
	center_of_mass = "x=17;y=9"
	nutriment_desc = list("mushroom" = 1, "pie" = 2)
	nutriment_amt = 3
	bitesize = 3
/obj/item/reagent_containers/food/snacks/amanita_pie/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/drugs/psilocybin, 1)

/obj/item/reagent_containers/food/snacks/plump_pie
	name = "plump pie"
	desc = "I bet you love stuff made out of plump helmets!"
	icon_state = "plump_pie"
	filling_color = "#b8279b"
	center_of_mass = "x=17;y=9"
	nutriment_desc = list("heartiness" = 2, "mushroom" = 3, "pie" = 3)
	nutriment_amt = 8
	bitesize = 2
/obj/item/reagent_containers/food/snacks/plump_pie/Initialize()
	.=..()
	if(prob(10))
		name = "exceptional plump pie"
		desc = "Microwave is taken by a fey mood! It has cooked an exceptional plump pie!"
		reagents.add_reagent(/datum/reagent/tricordrazine, 5)

/obj/item/reagent_containers/food/snacks/meatkabob
	name = "meat-kabob"
	icon_state = "kabob"
	desc = "Delicious meat, on a stick."
	trash = /obj/item/stack/material/rods
	filling_color = "#a85340"
	center_of_mass = "x=17;y=15"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/tofukabob
	name = "tofu-kabob"
	icon_state = "kabob"
	desc = "Vegan meat, on a stick."
	trash = /obj/item/stack/material/rods
	filling_color = "#fffee0"
	center_of_mass = "x=17;y=15"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/cubancarp
	name = "cuban carp"
	desc = "A sandwich that burns your tongue and then leaves it numb!"
	icon_state = "cubancarp"
	trash = /obj/item/trash/plate
	filling_color = "#e9adff"
	center_of_mass = "x=12;y=5"
	bitesize = 3

/obj/item/reagent_containers/food/snacks/popcorn
	name = "popcorn"
	desc = "Now let's find some cinema."
	icon_state = "popcorn"
	trash = /obj/item/trash/popcorn
	filling_color = "#fffad4"
	center_of_mass = "x=16;y=8"
	nutriment_desc = list("popcorn" = 3)
	nutriment_amt = 2
	bitesize = 0.1

/obj/item/reagent_containers/food/snacks/loadedbakedpotato
	name = "loaded baked potato"
	desc = "Totally baked."
	icon_state = "loadedbakedpotato"
	filling_color = "#9c7a68"
	center_of_mass = "x=16;y=10"
	nutriment_desc = list("baked potato" = 3)
	nutriment_amt = 3
	bitesize = 2

/obj/item/reagent_containers/food/snacks/fries
	name = "space fries"
	desc = "AKA: French Fries, Freedom Fries, etc."
	icon_state = "fries"
	trash = /obj/item/trash/plate
	filling_color = "#eddd00"
	center_of_mass = "x=16;y=11"
	nutriment_desc = list("fresh fries" = 3)
	nutriment_amt = 3
	bitesize = 2

/obj/item/reagent_containers/food/snacks/onionrings
	name = "onion rings"
	desc = "Like circular fries but better."
	icon_state = "onionrings"
	filling_color = "#eddd00"
	center_of_mass = "x=16;y=11"
	nutriment_desc = list("fried onions" = 5)
	nutriment_amt = 5
	bitesize = 2

/obj/item/reagent_containers/food/snacks/soydope
	name = "soy dope"
	desc = "Dope from a soy."
	icon_state = "soydope"
	trash = /obj/item/trash/plate
	filling_color = "#c4bf76"
	center_of_mass = "x=16;y=10"
	nutriment_desc = list("slime" = 2, "soy" = 2)
	nutriment_amt = 2
	bitesize = 2

/obj/item/reagent_containers/food/snacks/spagetti
	name = "spaghetti"
	desc = "A bundle of raw spaghetti."
	icon_state = "spagetti"
	filling_color = "#eddd00"
	center_of_mass = "x=16;y=16"
	nutriment_desc = list("noodles" = 2)
	nutriment_amt = 1
	bitesize = 1

/obj/item/reagent_containers/food/snacks/spagetti/on_reagent_change()
	. = ..()
	if (!reagents.has_reagent(/datum/reagent/nutriment/protein))
		name = "soy spaghetti"
	else
		name = initial(name)

/obj/item/reagent_containers/food/snacks/cheesyfries
	name = "cheesy fries"
	desc = "Fries. Covered in cheese. Duh."
	icon_state = "cheesyfries"
	trash = /obj/item/trash/plate
	filling_color = "#eddd00"
	center_of_mass = "x=16;y=11"
	nutriment_desc = list("fresh fries" = 2, "cheese" = 2)
	nutriment_amt = 4
	bitesize = 2

/obj/item/reagent_containers/food/snacks/badrecipe
	name = "burned mess"
	desc = "Someone should be demoted from chef for this."
	icon_state = "badrecipe"
	filling_color = "#211f02"
	center_of_mass = "x=16;y=12"
	bitesize = 2
/obj/item/reagent_containers/food/snacks/badrecipe/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/toxin, 1)
	reagents.add_reagent(/datum/reagent/carbon, 3)

/obj/item/reagent_containers/food/snacks/plainsteak
	name = "plain steak"
	desc = "A piece of cooked meat."
	icon_state = "meatsteak"
	slice_path = /obj/item/reagent_containers/food/snacks/cutlet
	slices_num = 3
	filling_color = "#7a3d11"
	center_of_mass = "x=16;y=13"
	bitesize = 3
/obj/item/reagent_containers/food/snacks/plainsteak/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 3)

/obj/item/reagent_containers/food/snacks/plainsteak/synthetic
	name = "meaty steak"
	desc = "A piece of hot spicy pseudo-meat."

/obj/item/reagent_containers/food/snacks/loadedsteak
	name = "loaded steak"
	desc = "A steak slathered in sauce with sauteed onions and mushrooms."
	icon_state = "meatsteak"
	filling_color = "#7a3d11"
	center_of_mass = "x=16;y=13"
	bitesize = 3

/obj/item/reagent_containers/food/snacks/spacylibertyduff
	name = "spacy liberty duff"
	desc = "Jello gelatin, from Alfred Hubbard's cookbook."
	icon_state = "spacylibertyduff"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#42b873"
	center_of_mass = "x=16;y=8"
	bitesize = 3

/obj/item/reagent_containers/food/snacks/amanitajelly
	name = "amanita jelly"
	desc = "Looks curiously toxic."
	icon_state = "amanitajelly"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#ed0758"
	center_of_mass = "x=16;y=5"
	bitesize = 3

/obj/item/reagent_containers/food/snacks/poppypretzel
	name = "poppy pretzel"
	desc = "It's all twisted up!"
	icon_state = "poppypretzel"
	bitesize = 2
	filling_color = "#916e36"
	center_of_mass = "x=16;y=10"
	nutriment_desc = list("poppy seeds" = 3, "pretzel" = 3)
	nutriment_amt = 6
	bitesize = 2

/obj/item/reagent_containers/food/snacks/meatballsoup
	name = "meatball soup"
	desc = "You've got balls kid, BALLS!"
	icon_state = "meatballsoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#785210"
	center_of_mass = "x=16;y=8"
	bitesize = 5
	eat_sound = list('sound/items/eatfood.ogg', 'sound/items/drink.ogg')

/obj/item/reagent_containers/food/snacks/slimesoup
	name = "slime soup"
	desc = "If no water is available, you may substitute tears."
	icon_state = "slimesoup"//nonexistant?
	filling_color = "#c4dba0"
	bitesize = 5
	eat_sound = 'sound/items/drink.ogg'

/obj/item/reagent_containers/food/snacks/bloodsoup
	name = "tomato soup"
	desc = "Smells like copper."
	icon_state = "tomatosoup"
	filling_color = "#ff0000"
	center_of_mass = "x=16;y=7"
	bitesize = 5
	eat_sound = 'sound/items/drink.ogg'

/obj/item/reagent_containers/food/snacks/bloodsoup/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 2)

/obj/item/reagent_containers/food/snacks/clownstears
	name = "clown's tears"
	desc = "Not very funny."
	icon_state = "clownstears"
	filling_color = "#c4fbff"
	center_of_mass = "x=16;y=7"
	nutriment_desc = list("salt" = 1, "the worst joke" = 3)
	nutriment_amt = 4
	bitesize = 5
	eat_sound = 'sound/items/drink.ogg'

/obj/item/reagent_containers/food/snacks/clownstears/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/drink/juice/banana, 5)
	reagents.add_reagent(/datum/reagent/water, 10)

/obj/item/reagent_containers/food/snacks/onionsoup
	name = "onion soup"
	desc = "Best enjoyed with some bread and cheese."
	icon_state = "onionsoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#af8e5a"
	center_of_mass = "x=16;y=8"
	bitesize = 5
	eat_sound = list('sound/items/eatfood.ogg', 'sound/items/drink.ogg')

/obj/item/reagent_containers/food/snacks/vegetablesoup
	name = "vegetable soup"
	desc = "A highly nutritious blend of vegetative goodness. Guaranteed to leave you with a, er, \"souped-up\" sense of wellbeing."
	icon_state = "vegetablesoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#afc4b5"
	center_of_mass = "x=16;y=8"
	nutriment_desc = list("eggplant" = 5)
	nutriment_amt = 5
	bitesize = 5
	eat_sound = list('sound/items/eatfood.ogg', 'sound/items/drink.ogg')

/obj/item/reagent_containers/food/snacks/nettlesoup
	name = "nettle soup"
	desc = "A mean, green, calorically lean dish derived from a poisonous plant. It has a rather acidic bite to its taste."
	icon_state = "nettlesoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#afc4b5"
	center_of_mass = "x=16;y=7"
	bitesize = 5
	eat_sound = list('sound/items/eatfood.ogg', 'sound/items/drink.ogg')

/obj/item/reagent_containers/food/snacks/nettlesoup/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/tricordrazine, 5)

/obj/item/reagent_containers/food/snacks/mysterysoup
	name = "mystery soup"
	desc = "The mystery is, why aren't you eating it?"
	icon_state = "mysterysoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#f082ff"
	center_of_mass = "x=16;y=6"
	nutriment_desc = list("backwash" = 1)
	nutriment_amt = 1
	bitesize = 5
	eat_sound = 'sound/items/drink.ogg'

/obj/item/reagent_containers/food/snacks/mysterysoup/Initialize()
	.=..()
	switch(rand(1,10))
		if(1)
			reagents.add_reagent(/datum/reagent/nutriment, 6)
			reagents.add_reagent(/datum/reagent/capsaicin, 3)
			reagents.add_reagent(/datum/reagent/drink/juice/tomato, 2)
		if(2)
			reagents.add_reagent(/datum/reagent/nutriment, 6)
			reagents.add_reagent(/datum/reagent/frostoil, 3)
			reagents.add_reagent(/datum/reagent/drink/juice/tomato, 2)
		if(3)
			reagents.add_reagent(/datum/reagent/nutriment, 5)
			reagents.add_reagent(/datum/reagent/water, 5)
			reagents.add_reagent(/datum/reagent/tricordrazine, 5)
		if(4)
			reagents.add_reagent(/datum/reagent/nutriment, 5)
			reagents.add_reagent(/datum/reagent/water, 10)
		if(5)
			reagents.add_reagent(/datum/reagent/nutriment, 2)
			reagents.add_reagent(/datum/reagent/drink/juice/banana, 10)
		if(6)
			reagents.add_reagent(/datum/reagent/nutriment, 6)
			reagents.add_reagent(/datum/reagent/blood, 10)
		if(7)
			reagents.add_reagent(/datum/reagent/slimejelly, 10)
			reagents.add_reagent(/datum/reagent/water, 10)
		if(8)
			reagents.add_reagent(/datum/reagent/carbon, 10)
			reagents.add_reagent(/datum/reagent/toxin, 10)
		if(9)
			reagents.add_reagent(/datum/reagent/nutriment, 5)
			reagents.add_reagent(/datum/reagent/drink/juice/tomato, 10)
		if(10)
			reagents.add_reagent(/datum/reagent/nutriment, 6)
			reagents.add_reagent(/datum/reagent/drink/juice/tomato, 5)
			reagents.add_reagent(/datum/reagent/imidazoline, 5)

/obj/item/reagent_containers/food/snacks/wishsoup
	name = "wish soup"
	desc = "I wish this was soup."
	icon_state = "wishsoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#d1f4ff"
	center_of_mass = "x=16;y=11"
	bitesize = 5
	eat_sound = 'sound/items/drink.ogg'

/obj/item/reagent_containers/food/snacks/wishsoup/Initialize()
	.=..()
	if(prob(25))
		src.desc = "A wish come true!"
		reagents.add_reagent(/datum/reagent/nutriment, 8, list("something good" = 8))

/obj/item/reagent_containers/food/snacks/hotchili
	name = "hot chili"
	desc = "A five alarm Texan chili!"
	icon_state = "hotchili"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#ff3c00"
	center_of_mass = "x=15;y=9"
	bitesize = 5

/obj/item/reagent_containers/food/snacks/coldchili
	name = "cold chili"
	desc = "This slush is barely a liquid!"
	icon_state = "coldchili"
	filling_color = "#2b00ff"
	center_of_mass = "x=15;y=9"
	trash = /obj/item/trash/snack_bowl
	bitesize = 5

//cubed animals!

/obj/item/reagent_containers/food/snacks/monkeycube
	name = "monkey cube"
	desc = "Just add water!"
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_OPEN_CONTAINER
	icon_state = "monkeycube"
	bitesize = 12
	filling_color = "#adac7f"
	center_of_mass = "x=16;y=14"

	var/wrapped = FALSE
	var/growing = FALSE
	var/monkey_type = /mob/living/carbon/human/monkey

/obj/item/reagent_containers/food/snacks/monkeycube/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 10)

/obj/item/reagent_containers/food/snacks/monkeycube/attack_self(mob/user)
	if(wrapped)
		Unwrap(user)

/obj/item/reagent_containers/food/snacks/monkeycube/proc/Expand()
	if(!growing)
		growing = TRUE
		src.visible_message(SPAN_NOTICE("\The [src] expands!"))
		var/mob/monkey = new monkey_type
		monkey.dropInto(src.loc)
		qdel(src)

/obj/item/reagent_containers/food/snacks/monkeycube/proc/Unwrap(mob/user)
	icon_state = "monkeycube"
	desc = "Just add water!"
	to_chat(user, SPAN_NOTICE("You unwrap \the [src]."))
	wrapped = FALSE
	atom_flags |= ATOM_FLAG_OPEN_CONTAINER
	var/trash = new /obj/item/trash/cubewrapper(get_turf(user))
	user.put_in_hands(trash)

/obj/item/reagent_containers/food/snacks/monkeycube/OnConsume(mob/living/consumer, mob/living/feeder)
	set waitfor = FALSE
	..()
	if (ishuman(consumer))
		var/mob/living/carbon/human/human = consumer
		to_chat(human, FONT_LARGE(SPAN_DANGER("Something is very wrong ...")))
		var/obj/item/organ/external/organ = human.get_organ(BP_CHEST)
		sleep(3 SECONDS)
		organ.fracture()
		sleep(3 SECONDS)
		human.visible_message(
			SPAN_DANGER("A screeching creature bursts out of \the [human]'s chest!"),
			FONT_HUGE(SPAN_DANGER("Something claws its way out through your [organ]!"))
		)
		organ.take_external_damage(50, 0, FLAGS_OFF, "Live animal escaping the body")
		organ.damage_internal_organs(50, 0, FLAGS_OFF)
		human.AdjustWeakened(5)
		human.AdjustStunned(5)
	else
		consumer.kill_health()
	var/mob/monkey = new monkey_type
	monkey.dropInto(consumer.loc)

/obj/item/reagent_containers/food/snacks/monkeycube/on_reagent_change()
	if(reagents.has_reagent(/datum/reagent/water))
		Expand()

/obj/item/reagent_containers/food/snacks/monkeycube/wrapped
	desc = "Still wrapped in some paper."
	icon_state = "monkeycubewrap"
	item_flags = 0
	obj_flags = 0
	wrapped = TRUE

/obj/item/reagent_containers/food/snacks/monkeycube/farwacube
	name = "farwa cube"
	monkey_type = /mob/living/carbon/human/farwa

/obj/item/reagent_containers/food/snacks/monkeycube/wrapped/farwacube
	name = "farwa cube"
	monkey_type = /mob/living/carbon/human/farwa

/obj/item/reagent_containers/food/snacks/monkeycube/stokcube
	name = "stok cube"
	monkey_type = /mob/living/carbon/human/stok

/obj/item/reagent_containers/food/snacks/monkeycube/wrapped/stokcube
	name = "stok cube"
	monkey_type = /mob/living/carbon/human/stok

/obj/item/reagent_containers/food/snacks/monkeycube/neaeracube
	name = "neaera cube"
	monkey_type = /mob/living/carbon/human/neaera

/obj/item/reagent_containers/food/snacks/monkeycube/wrapped/neaeracube
	name = "neaera cube"
	monkey_type = /mob/living/carbon/human/neaera


//Spider cubes, all that's left of the cube PR

/obj/item/reagent_containers/food/snacks/monkeycube/spidercube
	name = "spider cube"
	monkey_type = /obj/spider/spiderling

/obj/item/reagent_containers/food/snacks/monkeycube/wrapped/spidercube
	name = "spider cube"
	monkey_type = /obj/spider/spiderling

/obj/item/reagent_containers/food/snacks/monkeycube/pikecube
	name = "strange-looking monkey cube"
	monkey_type = /mob/living/simple_animal/hostile/carp/pike

/obj/item/reagent_containers/food/snacks/monkeycube/wrapped/pikecube
	name = "strange-looking monkey cube"
	monkey_type = /mob/living/simple_animal/hostile/carp/pike

/obj/item/reagent_containers/food/snacks/spellburger
	name = "spell burger"
	desc = "This is absolutely Ei Nath."
	icon_state = "spellburger"
	filling_color = "#d505ff"
	nutriment_desc = list("magic" = 3, "buns" = 3)
	nutriment_amt = 6
	bitesize = 2

//corpse cube for the antag item
/obj/item/reagent_containers/food/snacks/corpse_cube
	name = "odd fleshy cube"
	desc = "A strangely large, veiny and deformed monkey cube that pulsates and writhes disturbingly"
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_OPEN_CONTAINER
	icon_state = "corpsecube"
	bitesize = 12
	filling_color = "#adac7f"
	center_of_mass = "x=16;y=14"

	var/wrapped = FALSE
	var/growing = FALSE
	var/spawn_type = /mob/living/carbon/human

/obj/item/reagent_containers/food/snacks/corpse_cube/use_tool(obj/item/device/dna_sampler/W, mob/user)
	if(istype(W))
		if (W.loaded == 1)
			to_chat(user, "You inject the DNA sample into the cube.")
			CorpseExpand(W.src_dna,W.src_name,W.src_species,W.src_pronouns,W.src_faction,W.src_flavor)
			W.loaded = FALSE
			W.icon_state = "dnainjector0"
			W.src_dna = null
			W.src_pronouns = ""
			W.src_faction = ""
			W.src_name = ""
			W.src_species = ""
			W.src_flavor = ""
		else
			to_chat(user,"The cube doesn't so much as twitch without a DNA sample.")
		return TRUE
	return ..()


/obj/item/reagent_containers/food/snacks/corpse_cube/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 10)

/obj/item/reagent_containers/food/snacks/corpse_cube/proc/CorpseExpand(source_DNA,source_name,source_species,source_pronouns, source_faction, source_flavor)
	if(!growing)
		growing = TRUE
		var/mob/living/carbon/human/H = new spawn_type
		H.dna = source_DNA
		playsound(loc, 'sound/effects/corpsecube.ogg', 60)
		H.faction = source_faction
		H.real_name = source_name
		H.SetName(source_name)
		H.dna.real_name = source_name
		H.pronouns = source_pronouns
		H.change_pronouns(source_pronouns)
		H.change_species(source_species)
		H.flavor_texts = source_flavor
		src.visible_message(SPAN_WARNING("[src] transforms, the dummy body's features twisting and cracking as it imitates the provided blood!"))
		H.dropInto(src.loc)
		H.setBrainLoss(200)
		H.adjustOxyLoss(H.maxHealth)
		domutcheck(H, null)
		H.UpdateAppearance()
		qdel(src)

/obj/item/reagent_containers/food/snacks/corpse_cube/OnConsume(mob/living/consumer, mob/living/feeder)
	set waitfor = FALSE
	..()
	if (ishuman(consumer))
		var/mob/living/carbon/human/human = consumer
		to_chat(human, FONT_LARGE(SPAN_DANGER("You feel something shifting and slithering throughout your body ...")))
		var/obj/item/organ/external/organ = human.get_organ(BP_CHEST)
		var/obj/item/organ/external/unluckylimb1 = human.get_organ(pick(BP_ALL_LIMBS))
		var/obj/item/organ/external/unluckylimb2 = human.get_organ(pick(BP_ALL_LIMBS))
		sleep(3 SECONDS)
		organ.add_pain(30)
		organ.fracture()
		sleep(3 SECONDS)
		unluckylimb1.add_pain(50)
		unluckylimb1.fracture()
		unluckylimb2.add_pain(50)
		unluckylimb2.fracture()
		organ.take_external_damage(50, 0, FLAGS_OFF, "Agonizing pain")
		organ.damage_internal_organs(50, 0, FLAGS_OFF)
		human.AdjustWeakened(5)
		human.AdjustStunned(5)

	else
		consumer.kill_health()

/obj/item/reagent_containers/food/snacks/bigbiteburger
	name = "big bite burger"
	desc = "Forget the Luna Burger! THIS is the future!"
	icon_state = "bigbiteburger"
	filling_color = "#e3d681"
	center_of_mass = "x=16;y=11"
	nutriment_desc = list("buns" = 4)
	nutriment_amt = 4
	bitesize = 3

/obj/item/reagent_containers/food/snacks/enchiladas
	name = "enchiladas"
	desc = "Viva La Space Mexico!"
	icon_state = "enchiladas"
	trash = /obj/item/trash/tray
	filling_color = "#a36a1f"
	center_of_mass = "x=16;y=13"
	nutriment_desc = list("tortilla" = 2)
	nutriment_amt = 2
	bitesize = 4

/obj/item/reagent_containers/food/snacks/monkeysdelight
	name = "monkey's delight"
	desc = "Eeee Eee!"
	icon_state = "monkeysdelight"
	trash = /obj/item/trash/tray
	filling_color = "#5c3c11"
	center_of_mass = "x=16;y=13"
	nutriment_amt = 5
	nutriment_desc = list("chewy meat" = 5)
	bitesize = 6

/obj/item/reagent_containers/food/snacks/baguette
	name = "baguette"
	desc = "Bon appetit!"
	icon_state = "baguette"
	filling_color = "#e3d796"
	center_of_mass = "x=18;y=12"
	nutriment_desc = list("french bread" = 6)
	nutriment_amt = 6
	bitesize = 3

/obj/item/reagent_containers/food/snacks/fishandchips
	name = "fish and chips"
	desc = "I do say so myself chap."
	icon_state = "fishandchips"
	filling_color = "#e3d796"
	center_of_mass = "x=16;y=16"
	nutriment_desc = list("fresh chips" = 3)
	nutriment_amt = 3
	bitesize = 3

/obj/item/reagent_containers/food/snacks/sandwich
	name = "sandwich"
	desc = "A grand creation of meat, cheese, bread, and several leaves of lettuce! Arthur Dent would be proud."
	icon_state = "sandwich"
	filling_color = "#d9be29"
	center_of_mass = "x=16;y=4"
	nutriment_desc = list("bread" = 3)
	nutriment_amt = 3
	bitesize = 2

/obj/item/reagent_containers/food/snacks/toastedsandwich
	name = "toasted sandwich"
	desc = "Now if you only had a pepper bar."
	icon_state = "toastedsandwich"
	filling_color = "#d9be29"
	center_of_mass = "x=16;y=4"
	nutriment_desc = list("toasted bread" = 3)
	nutriment_amt = 3
	bitesize = 2
/obj/item/reagent_containers/food/snacks/toastedsandwich/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/carbon, 2)

/obj/item/reagent_containers/food/snacks/grilledcheese
	name = "grilled cheese sandwich"
	desc = "Goes great with Tomato soup!"
	icon_state = "toastedsandwich"
	filling_color = "#d9be29"
	nutriment_desc = list("toasted bread" = 3)
	nutriment_amt = 3
	bitesize = 2

/obj/item/reagent_containers/food/snacks/tomatosoup
	name = "tomato soup"
	desc = "Drinking this feels like being a vampire! A tomato vampire..."
	icon_state = "tomatosoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#d92929"
	center_of_mass = "x=16;y=7"
	nutriment_desc = list("soup" = 5)
	nutriment_amt = 5
	bitesize = 3
	eat_sound = 'sound/items/drink.ogg'

/obj/item/reagent_containers/food/snacks/rofflewaffles
	name = "roffle waffles"
	desc = "Waffles from Roffle. Co."
	icon_state = "rofflewaffles"
	trash = /obj/item/trash/waffles
	filling_color = "#ff00f7"
	center_of_mass = "x=15;y=11"
	bitesize = 4

/obj/item/reagent_containers/food/snacks/stew
	name = "stew"
	desc = "A nice and warm stew. Healthy and strong."
	icon_state = "stew"
	trash = /obj/item/trash/pot
	filling_color = "#9e673a"
	center_of_mass = "x=16;y=5"
	nutriment_desc = list("eggplant" = 3, "mushroom" = 3)
	nutriment_amt = 6
	bitesize = 10

/obj/item/reagent_containers/food/snacks/jelliedtoast
	name = "jellied toast"
	desc = "A slice of bread covered with delicious jam."
	icon_state = "jellytoast"
	filling_color = "#b572ab"
	center_of_mass = "x=16;y=8"
	nutriment_desc = list("toasted bread" = 2)
	nutriment_amt = 2
	bitesize = 3

/obj/item/reagent_containers/food/snacks/pbtoast
	name = "peanut butter toast"
	desc = "A slice of bread covered with peanut butter."
	icon_state = "pbtoast"
	filling_color = "#b572ab"
	center_of_mass = "x=16;y=8"
	nutriment_desc = list("toasted bread" = 2)
	nutriment_amt = 2
	bitesize = 3

/obj/item/reagent_containers/food/snacks/ntella_bread
	name = "NTella bread slice"
	desc = "A slice of bread covered with delicious chocolate-nut spread."
	icon_state = "chocobread"
	filling_color = "#4b270f"
	center_of_mass = "x=16;y=8"
	nutriment_desc = list("bread" = 2)
	nutriment_amt = 2
	bitesize = 3

/obj/item/reagent_containers/food/snacks/jellyburger
	name = "jelly burger"
	desc = "Culinary delight..?"
	icon_state = "jellyburger"
	filling_color = "#b572ab"
	center_of_mass = "x=16;y=11"
	nutriment_desc = list("buns" = 3)
	nutriment_amt = 3
	bitesize = 2

/obj/item/reagent_containers/food/snacks/milosoup
	name = "miso soup"
	desc = "Miso paste, dashi, and tofu."
	icon_state = "misosoup"
	trash = /obj/item/trash/snack_bowl
	center_of_mass = "x=16;y=7"
	nutriment_desc = list("savory soy broth" = 8)
	nutriment_amt = 8
	bitesize = 4
	eat_sound = 'sound/items/drink.ogg'

/obj/item/reagent_containers/food/snacks/stewedsoymeat
	name = "stewed soy meat"
	desc = "Even non-vegetarians will LOVE this!"
	icon_state = "stewedsoymeat"
	trash = /obj/item/trash/plate
	center_of_mass = "x=16;y=10"
	nutriment_desc = list("soy" = 8)
	nutriment_amt = 8
	bitesize = 2

/obj/item/reagent_containers/food/snacks/boiledspagetti
	name = "boiled spaghetti"
	desc = "A plain dish of noodles, this sucks."
	icon_state = "spagettiboiled"
	trash = /obj/item/trash/plate
	filling_color = "#fcee81"
	center_of_mass = "x=16;y=10"
	nutriment_desc = list("noodles" = 2)
	nutriment_amt = 2
	bitesize = 2

/obj/item/reagent_containers/food/snacks/boiledrice
	name = "boiled rice"
	desc = "A boring dish of boring rice."
	icon_state = "boiledrice"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#fffbdb"
	center_of_mass = "x=17;y=11"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/boiledrice/use_tool(obj/item/reagent_containers/food/snacks/W as obj, mob/user as mob)
	if(istype(W) && W.sushi_overlay)
		new /obj/item/reagent_containers/food/snacks/sushi(get_turf(src), src, W)
		return TRUE
	return ..()

/obj/item/reagent_containers/food/snacks/boiledrice/chazuke
	name = "chazuke"
	desc = "An ancient way of using up day-old rice, this dish is composed of plain green tea poured over plain white rice. Hopefully you have something else to put in."
	icon_state = "chazuke"
	filling_color = "#f1ffdb"
	bitesize = 3

/obj/item/reagent_containers/food/snacks/katsucurry
	name = "katsu curry"
	desc = "An oriental curry dish made from apples, potatoes, and carrots. Served with rice and breaded chicken."
	icon_state = "katsu"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#faa005"
	center_of_mass = "x=17;y=11"
	nutriment_desc = list("bread" = 5)
	nutriment_amt = 5
	bitesize = 2

/obj/item/reagent_containers/food/snacks/ricepudding
	name = "rice pudding"
	desc = "Where's the jam?"
	icon_state = "rpudding"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#fffbdb"
	center_of_mass = "x=17;y=11"
	nutriment_desc = list("rice" = 2)
	nutriment_amt = 4
	bitesize = 2

/obj/item/reagent_containers/food/snacks/pastatomato
	name = "spaghetti & tomato"
	desc = "Spaghetti and crushed tomatoes. Just like your abusive father used to make!"
	icon_state = "pastatomato"
	trash = /obj/item/trash/plate
	filling_color = "#de4545"
	center_of_mass = "x=16;y=10"
	nutriment_desc = list("noodles" = 2)
	nutriment_amt = 2
	bitesize = 4

/obj/item/reagent_containers/food/snacks/nanopasta
	name = "nanopasta"
	desc = "Nanomachines, son!"
	icon_state = "nanopasta"
	trash = /obj/item/trash/plate
	filling_color = "#535e66"
	center_of_mass = "x=16;y=10"
	nutriment_desc = list("noodles" = 2)
	nutriment_amt = 2
	bitesize = 4
/obj/item/reagent_containers/food/snacks/nanopasta/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/nanites, 10)

/obj/item/reagent_containers/food/snacks/meatballspagetti
	name = "spaghetti & meatballs"
	desc = "Now thats a nic'e meatball!"
	icon_state = "meatballspagetti"
	trash = /obj/item/trash/plate
	filling_color = "#de4545"
	center_of_mass = "x=16;y=10"
	nutriment_desc = list("noodles" = 2)
	nutriment_amt = 2
	bitesize = 2

/obj/item/reagent_containers/food/snacks/spesslaw
	name = "spesslaw"
	desc = "A lawyers favourite."
	icon_state = "spesslaw"
	filling_color = "#de4545"
	center_of_mass = "x=16;y=10"
	nutriment_desc = list("noodles" = 2)
	nutriment_amt = 2
	bitesize = 2

/obj/item/reagent_containers/food/snacks/carrotfries
	name = "carrot fries"
	desc = "Tasty fries from fresh carrots."
	icon_state = "carrotfries"
	trash = /obj/item/trash/plate
	filling_color = "#faa005"
	center_of_mass = "x=16;y=11"
	nutriment_desc = list("carrot" = 3, "salt" = 1)
	nutriment_amt = 3
	bitesize = 2
/obj/item/reagent_containers/food/snacks/carrotfries/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/imidazoline, 3)

/obj/item/reagent_containers/food/snacks/superbiteburger
	name = "super bite burger"
	desc = "This is a mountain of a burger. FOOD!"
	icon_state = "superbiteburger"
	filling_color = "#cca26a"
	center_of_mass = "x=16;y=3"
	nutriment_desc = list("buns" = 4)
	nutriment_amt = 4
	volume = 100
	bitesize = 10

/obj/item/reagent_containers/food/snacks/candiedapple
	name = "candied apple"
	desc = "An apple coated in sugary sweetness."
	icon_state = "candiedapple"
	filling_color = "#f21873"
	center_of_mass = "x=15;y=13"
	nutriment_desc = list("apple" = 2, "caramel" = 2)
	nutriment_amt = 4
	bitesize = 3

/obj/item/reagent_containers/food/snacks/applepie
	name = "apple pie"
	desc = "A pie containing sweet sweet love... or apple."
	icon_state = "applepie"
	filling_color = "#e0edc5"
	center_of_mass = "x=16;y=13"
	nutriment_desc = list("apple" = 2, "crust" = 2)
	nutriment_amt = 4
	bitesize = 3

/obj/item/reagent_containers/food/snacks/cherrypie
	name = "cherry pie"
	desc = "Taste so good, make a grown man cry."
	icon_state = "cherrypie"
	filling_color = "#ff525a"
	center_of_mass = "x=16;y=11"
	nutriment_desc = list("pie" = 2)
	nutriment_amt = 3
	bitesize = 3

/obj/item/reagent_containers/food/snacks/twobread
	name = "two bread"
	desc = "It is very bitter and winy."
	icon_state = "twobread"
	filling_color = "#dbcc9a"
	center_of_mass = "x=15;y=12"
	nutriment_desc = list("sourness" = 1, "bread" = 2)
	nutriment_amt = 3
	bitesize = 3

/obj/item/reagent_containers/food/snacks/threebread
	name = "three bread"
	desc = "Is such a thing even possible?"
	icon_state = "threebread"
	filling_color = "#dbcc9a"
	center_of_mass = "x=15;y=12"
	nutriment_desc = list("sourness" = 2, "bread" = 3)
	nutriment_amt = 5
	bitesize = 4

/obj/item/reagent_containers/food/snacks/jellysandwich
	name = "jelly sandwich"
	desc = "You wish you had some peanut butter to go with this..."
	icon_state = "jellysandwich"
	trash = /obj/item/trash/plate
	filling_color = "#9e3a78"
	center_of_mass = "x=16;y=8"
	nutriment_desc = list("bread" = 3)
	nutriment_amt = 3
	bitesize = 3

/obj/item/reagent_containers/food/snacks/pbjsandwich
	name = "pbj sandwich"
	desc = "A staple classic lunch of gooey jelly and peanut butter."
	icon_state = "pbjsandwich"
	trash = /obj/item/trash/plate
	filling_color = "#bb6a54"
	center_of_mass = "x=16;y=8"
	nutriment_desc = list("bread" = 3)
	nutriment_amt = 3
	bitesize = 3

/obj/item/reagent_containers/food/snacks/boiledslimecore
	name = "boiled slime core"
	desc = "A boiled red thing."
	icon_state = "boiledslimecore"//nonexistant?
	bitesize = 3

/obj/item/reagent_containers/food/snacks/mint
	name = "mint"
	desc = "A tasty after-dinner mint. It is only wafer thin."
	icon_state = "mint"
	filling_color = "#f2f2f2"
	center_of_mass = "x=16;y=14"
	bitesize = 1
/obj/item/reagent_containers/food/snacks/mint/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/nutriment/mint, 1)


/obj/item/reagent_containers/food/snacks/mushroomsoup
	name = "chantrelle soup"
	desc = "A delicious and hearty mushroom soup."
	icon_state = "mushroomsoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#e386bf"
	center_of_mass = "x=17;y=10"
	nutriment_desc = list("mushroom" = 8)
	nutriment_amt = 8
	bitesize = 3
	eat_sound = list('sound/items/eatfood.ogg', 'sound/items/drink.ogg')

/obj/item/reagent_containers/food/snacks/plumphelmetbiscuit
	name = "plump helmet biscuit"
	desc = "This is a finely-prepared plump helmet biscuit. The ingredients are exceptionally minced plump helmet, and well-minced dwarven wheat flour."
	icon_state = "phelmbiscuit"
	filling_color = "#cfb4c4"
	center_of_mass = "x=16;y=13"
	nutriment_desc = list("mushroom" = 5)
	nutriment_amt = 5
	bitesize = 2
/obj/item/reagent_containers/food/snacks/plumphelmetbiscuit/Initialize()
	.=..()
	if(prob(10))
		name = "exceptional plump helmet biscuit"
		desc = "Microwave is taken by a fey mood! It has cooked an exceptional plump helmet biscuit!"
		reagents.add_reagent(/datum/reagent/nutriment, 3)
		reagents.add_reagent(/datum/reagent/tricordrazine, 5)


/obj/item/reagent_containers/food/snacks/chawanmushi
	name = "chawanmushi"
	desc = "A legendary egg custard that makes friends out of enemies. Probably too hot for a cat to eat."
	icon_state = "chawanmushi"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#f0f2e4"
	center_of_mass = "x=17;y=10"
	nutriment_amt = 4
	nutriment_desc = list("mushroom" = 4)
	bitesize = 1

/obj/item/reagent_containers/food/snacks/beetsoup
	name = "beet soup"
	desc = "Wait, how do you spell it again..?"
	icon_state = "beetsoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#fac9ff"
	center_of_mass = "x=15;y=8"
	nutriment_desc = list("beet" = 4)
	nutriment_amt = 4
	bitesize = 2
	eat_sound = 'sound/items/drink.ogg'

/obj/item/reagent_containers/food/snacks/beetsoup/Initialize()
	.=..()
	name = pick(list("borsch","bortsch","borstch","borsh","borshch","borscht"))


/obj/item/reagent_containers/food/snacks/tossedsalad
	name = "tossed salad"
	desc = "A proper salad, basic and simple, with little bits of carrot, tomato and apple intermingled. Vegan!"
	icon_state = "herbsalad"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#76b87f"
	center_of_mass = "x=17;y=11"
	bitesize = 3

/obj/item/reagent_containers/food/snacks/validsalad
	name = "valid salad"
	desc = "It's just a salad of questionable 'herbs' with meatballs and fried potato slices. Nothing suspicious about it."
	icon_state = "validsalad"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#76b87f"
	center_of_mass = "x=17;y=11"
	nutriment_desc = list("100% real salad")
	nutriment_amt = 3
	bitesize = 3

/obj/item/reagent_containers/food/snacks/appletart
	name = "golden apple streusel tart"
	desc = "A tasty dessert that won't make it through a metal detector."
	icon_state = "gappletart"
	trash = /obj/item/trash/plate
	filling_color = "#ffff00"
	center_of_mass = "x=16;y=18"
	nutriment_desc = list("apple" = 4)
	nutriment_amt = 4
	bitesize = 3

/////////////////////////////////////////////////Sliceable////////////////////////////////////////
// All the food items that can be sliced into smaller bits like meatbread and cheesewheels

// sliceable is just an organization type path, it doesn't have any additional code or variables tied to it.

/obj/item/reagent_containers/food/snacks/sliceable
	volume = 150
	w_class = ITEM_SIZE_NORMAL //whole pizzas and cakes shouldn't fit in a pocket, you can slice them if you want to do that.

/**
 *  A food item slice
 *
 *  This path contains some extra code for spawning slices pre-filled with
 *  reagents.
 */
/obj/item/reagent_containers/food/snacks/slice
	name = "slice of... something"
	var/whole_path // path for the item from which this slice comes
	var/filled = FALSE // should the slice spawn with any reagents

/**
 *  Spawn a new slice of food
 *
 *  If the slice's filled is TRUE, this will also fill the slice with the
 *  appropriate amount of reagents. Note that this is done by spawning a new
 *  whole item, transferring the reagents and deleting the whole item, which may
 *  have performance implications.
 */
/obj/item/reagent_containers/food/snacks/slice/Initialize()
	.=..()
	if(filled)
		var/obj/item/reagent_containers/food/snacks/whole = new whole_path()
		if(whole && whole.slices_num)
			var/reagent_amount = whole.reagents.total_volume/whole.slices_num
			whole.reagents.trans_to_obj(src, reagent_amount)
		qdel(whole)

/obj/item/reagent_containers/food/snacks/sliceable/meatbread
	name = "meatbread loaf"
	desc = "The culinary base of every self-respecting eloquen/tg/entleman."
	icon_state = "meatbread"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/meatbread
	slices_num = 5
	filling_color = "#ff7575"
	center_of_mass = "x=19;y=9"
	nutriment_desc = list("bread" = 10)
	nutriment_amt = 10
	bitesize = 2
/obj/item/reagent_containers/food/snacks/sliceable/meatbread/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 20)

/obj/item/reagent_containers/food/snacks/slice/meatbread
	name = "meatbread slice"
	desc = "A slice of delicious meatbread."
	icon_state = "meatbreadslice"
	filling_color = "#ff7575"
	bitesize = 2
	center_of_mass = "x=16;y=13"
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/meatbread

/obj/item/reagent_containers/food/snacks/slice/meatbread/filled
	filled = TRUE

/obj/item/reagent_containers/food/snacks/sliceable/bananabread
	name = "banana bread"
	desc = "A heavenly and filling treat."
	icon_state = "bananabread"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/bananabread
	slices_num = 5
	filling_color = "#ede5ad"
	center_of_mass = "x=16;y=9"
	nutriment_desc = list("bread" = 5)
	nutriment_amt = 10
	bitesize = 2

/obj/item/reagent_containers/food/snacks/slice/bananabread
	name = "banana bread slice"
	desc = "A slice of delicious banana bread."
	icon_state = "bananabreadslice"
	filling_color = "#ede5ad"
	bitesize = 2
	center_of_mass = "x=16;y=8"
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/bananabread

/obj/item/reagent_containers/food/snacks/slice/bananabread/filled
	filled = TRUE

/obj/item/reagent_containers/food/snacks/sliceable/tofubread
	name = "tofubread"
	desc = "Like meatbread but for vegetarians. Not guaranteed to give superpowers."
	icon_state = "tofubread"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/tofubread
	slices_num = 5
	filling_color = "#f7ffe0"
	center_of_mass = "x=16;y=9"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/slice/tofubread
	name = "tofubread slice"
	desc = "A slice of delicious tofubread."
	icon_state = "tofubreadslice"
	filling_color = "#f7ffe0"
	bitesize = 2
	center_of_mass = "x=16;y=13"
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/tofubread

/obj/item/reagent_containers/food/snacks/slice/tofubread/filled
	filled = TRUE

/obj/item/reagent_containers/food/snacks/sliceable/carrotcake
	name = "carrot cake"
	desc = "A favorite desert of a certain wascally wabbit. Not a lie."
	icon_state = "carrotcake"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/carrotcake
	slices_num = 5
	filling_color = "#ffd675"
	center_of_mass = "x=16;y=10"
	nutriment_desc = list("carrot" = 15)
	nutriment_amt = 15
	bitesize = 2

/obj/item/reagent_containers/food/snacks/slice/carrotcake
	name = "carrot cake slice"
	desc = "Carrotty slice of carrot cake, carrots are good for your eyes! Also not a lie."
	icon_state = "carrotcake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#ffd675"
	bitesize = 2
	center_of_mass = "x=16;y=14"
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/carrotcake

/obj/item/reagent_containers/food/snacks/slice/carrotcake/filled
	filled = TRUE

/obj/item/reagent_containers/food/snacks/sliceable/braincake
	name = "brain cake"
	desc = "A squishy cake-thing."
	icon_state = "braincake"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/braincake
	slices_num = 5
	filling_color = "#e6aedb"
	center_of_mass = "x=16;y=10"
	nutriment_desc = list("slime" = 5)
	nutriment_amt = 5
	bitesize = 2
/obj/item/reagent_containers/food/snacks/sliceable/braincake/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 25)
	reagents.add_reagent(/datum/reagent/alkysine, 10)

/obj/item/reagent_containers/food/snacks/slice/braincake
	name = "brain cake slice"
	desc = "Lemme tell you something about prions. THEY'RE DELICIOUS."
	icon_state = "braincakeslice"
	trash = /obj/item/trash/plate
	filling_color = "#e6aedb"
	bitesize = 2
	center_of_mass = "x=16;y=12"
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/braincake

/obj/item/reagent_containers/food/snacks/slice/braincake/filled
	filled = TRUE

/obj/item/reagent_containers/food/snacks/sliceable/cheesecake
	name = "cheese cake"
	desc = "DANGEROUSLY cheesy."
	icon_state = "cheesecake"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/cheesecake
	slices_num = 5
	filling_color = "#faf7af"
	center_of_mass = "x=16;y=10"
	nutriment_desc = list("cheese" = 5)
	nutriment_amt = 5
	bitesize = 2

/obj/item/reagent_containers/food/snacks/slice/cheesecake
	name = "cheese cake slice"
	desc = "Slice of pure cheestisfaction."
	icon_state = "cheesecake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#faf7af"
	bitesize = 2
	center_of_mass = "x=16;y=14"
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/cheesecake

/obj/item/reagent_containers/food/snacks/slice/cheesecake/filled
	filled = TRUE

/obj/item/reagent_containers/food/snacks/sliceable/ntella_cheesecake
	name = "NTella cheesecake"
	desc = "An elaborate layered cheesecake made with chocolate hazelnut spread. You gain calories just by looking at it for too long."
	icon_state = "NTellacheesecake"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/ntella_cheesecake
	slices_num = 5
	filling_color = "#331c03"
	center_of_mass = "x=16;y=10"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/slice/ntella_cheesecake
	name = "NTella cheesecake slice"
	desc = "A slice of cake marrying the chocolate taste of NTella with the creamy smoothness of cheesecake, all on a cookie crumble base."
	icon_state = "NTellacheesecake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#331c03"
	bitesize = 2
	center_of_mass = "x=16;y=14"
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/ntella_cheesecake

/obj/item/reagent_containers/food/snacks/slice/ntella_cheesecake/filled
	filled = TRUE

/obj/item/reagent_containers/food/snacks/sliceable/plaincake
	name = "vanilla cake"
	desc = "A plain cake, not a lie."
	icon_state = "plaincake"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/plaincake
	slices_num = 5
	filling_color = "#f7edd5"
	center_of_mass = "x=16;y=10"

/obj/item/reagent_containers/food/snacks/slice/plaincake
	name = "vanilla cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon_state = "plaincake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#f7edd5"
	bitesize = 2
	center_of_mass = "x=16;y=14"
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/plaincake

/obj/item/reagent_containers/food/snacks/slice/plaincake/filled
	filled = TRUE

/obj/item/reagent_containers/food/snacks/sliceable/orangecake
	name = "orange cake"
	desc = "A cake with added orange."
	icon_state = "orangecake"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/orangecake
	slices_num = 5
	filling_color = "#fada8e"
	center_of_mass = "x=16;y=10"
	nutriment_desc = list("orange" = 10)
	nutriment_amt = 10

/obj/item/reagent_containers/food/snacks/slice/orangecake
	name = "orange cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon_state = "orangecake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#fada8e"
	bitesize = 2
	center_of_mass = "x=16;y=14"
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/orangecake

/obj/item/reagent_containers/food/snacks/slice/orangecake/filled
	filled = TRUE

/obj/item/reagent_containers/food/snacks/sliceable/limecake
	name = "lime cake"
	desc = "A cake with added lime."
	icon_state = "limecake"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/limecake
	slices_num = 5
	filling_color = "#cbfa8e"
	center_of_mass = "x=16;y=10"
	nutriment_desc = list("lime" = 10)
	nutriment_amt = 10

/obj/item/reagent_containers/food/snacks/slice/limecake
	name = "lime cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon_state = "limecake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#cbfa8e"
	bitesize = 2
	center_of_mass = "x=16;y=14"
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/limecake

/obj/item/reagent_containers/food/snacks/slice/limecake/filled
	filled = TRUE

/obj/item/reagent_containers/food/snacks/sliceable/lemoncake
	name = "lemon cake"
	desc = "A cake with added lemon."
	icon_state = "lemoncake"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/lemoncake
	slices_num = 5
	filling_color = "#fafa8e"
	center_of_mass = "x=16;y=10"
	nutriment_desc = list("lemon" = 10)
	nutriment_amt = 10

/obj/item/reagent_containers/food/snacks/slice/lemoncake
	name = "lemon cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon_state = "lemoncake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#fafa8e"
	bitesize = 2
	center_of_mass = "x=16;y=14"
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/lemoncake

/obj/item/reagent_containers/food/snacks/slice/lemoncake/filled
	filled = TRUE

/obj/item/reagent_containers/food/snacks/sliceable/chocolatecake
	name = "chocolate cake"
	desc = "A cake with added chocolate."
	icon_state = "chocolatecake"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/chocolatecake
	slices_num = 5
	filling_color = "#805930"
	center_of_mass = "x=16;y=10"
	nutriment_desc = list("chocolate" = 5)
	nutriment_amt = 5

/obj/item/reagent_containers/food/snacks/slice/chocolatecake
	name = "chocolate cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon_state = "chocolatecake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#805930"
	bitesize = 2
	center_of_mass = "x=16;y=14"
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/chocolatecake

/obj/item/reagent_containers/food/snacks/slice/chocolatecake/filled
	filled = TRUE


/obj/item/reagent_containers/food/snacks/sliceable/birthdaycake
	name = "birthday cake"
	desc = "Happy birthday!"
	icon_state = "birthdaycake"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/birthdaycake
	slices_num = 5
	filling_color = "#ffd6d6"
	center_of_mass = "x=16;y=10"
	bitesize = 3

/obj/item/reagent_containers/food/snacks/slice/birthdaycake
	name = "birthday cake slice"
	desc = "A slice of your birthday."
	icon_state = "birthdaycakeslice"
	trash = /obj/item/trash/plate
	filling_color = "#ffd6d6"
	bitesize = 2
	center_of_mass = "x=16;y=14"
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/birthdaycake

/obj/item/reagent_containers/food/snacks/slice/birthdaycake/filled
	filled = TRUE

/obj/item/reagent_containers/food/snacks/sliceable/bread
	name = "bread"
	desc = "Some plain old Earthen bread."
	icon_state = "bread"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/bread
	slices_num = 5
	filling_color = "#ffe396"
	center_of_mass = "x=16;y=9"
	nutriment_desc = list("bread" = 6)
	nutriment_amt = 6
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sliceable/bread/on_reagent_change()
	. = ..()
	if (!reagents.has_reagent(/datum/reagent/nutriment/protein))
		name = "soy bread"
	else
		name = initial(name)

/obj/item/reagent_containers/food/snacks/slice/bread
	name = "bread slice"
	desc = "A slice of home."
	icon_state = "breadslice"
	filling_color = "#d27332"
	bitesize = 2
	center_of_mass = "x=16;y=4"
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/bread

/obj/item/reagent_containers/food/snacks/slice/bread/on_reagent_change()
	. = ..()
	if (!reagents.has_reagent(/datum/reagent/nutriment/protein))
		name = "soy bread slice"
	else
		name = initial(name)

/obj/item/reagent_containers/food/snacks/slice/bread/filled
	filled = TRUE


/obj/item/reagent_containers/food/snacks/sliceable/creamcheesebread
	name = "cream cheese bread"
	desc = "Yum yum yum!"
	icon_state = "creamcheesebread"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/creamcheesebread
	slices_num = 5
	filling_color = "#fff896"
	center_of_mass = "x=16;y=9"
	nutriment_desc = list("bread" = 3, "cream" = 2)
	nutriment_amt = 5
	bitesize = 2

/obj/item/reagent_containers/food/snacks/slice/creamcheesebread
	name = "cream cheese bread slice"
	desc = "A slice of yum!"
	icon_state = "creamcheesebreadslice"
	filling_color = "#fff896"
	bitesize = 2
	center_of_mass = "x=16;y=13"
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/creamcheesebread

/obj/item/reagent_containers/food/snacks/slice/creamcheesebread/filled
	filled = TRUE

/obj/item/reagent_containers/food/snacks/watermelonslice
	name = "watermelon slice"
	desc = "A slice of watery goodness."
	icon_state = "watermelonslice"
	filling_color = "#ff3867"
	bitesize = 2
	center_of_mass = "x=16;y=10"

/obj/item/reagent_containers/food/snacks/sliceable/applecake
	name = "apple cake"
	desc = "A cake centred with apples."
	icon_state = "applecake"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/applecake
	slices_num = 5
	filling_color = "#ebf5b8"
	center_of_mass = "x=16;y=10"
	nutriment_desc = list("apple" = 10)
	nutriment_amt = 10

/obj/item/reagent_containers/food/snacks/slice/applecake
	name = "apple cake slice"
	desc = "A slice of heavenly cake."
	icon_state = "applecakeslice"
	trash = /obj/item/trash/plate
	filling_color = "#ebf5b8"
	bitesize = 2
	center_of_mass = "x=16;y=14"
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/applecake

/obj/item/reagent_containers/food/snacks/slice/applecake/filled
	filled = TRUE

/obj/item/reagent_containers/food/snacks/sliceable/pumpkinpie
	name = "pumpkin pie"
	desc = "A delicious treat for the autumn months."
	icon_state = "pumpkinpie"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/pumpkinpie
	slices_num = 5
	filling_color = "#f5b951"
	center_of_mass = "x=16;y=10"
	nutriment_desc = list("pie" = 5, "pumpkin" = 5)
	nutriment_amt = 10

/obj/item/reagent_containers/food/snacks/slice/pumpkinpie
	name = "pumpkin pie slice"
	desc = "A slice of pumpkin pie, with whipped cream on top. Perfection."
	icon_state = "pumpkinpieslice"
	trash = /obj/item/trash/plate
	filling_color = "#f5b951"
	bitesize = 2
	center_of_mass = "x=16;y=12"
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/pumpkinpie

/obj/item/reagent_containers/food/snacks/slice/pumpkinpie/filled
	filled = TRUE

/obj/item/reagent_containers/food/snacks/cracker
	name = "cracker"
	desc = "It's a salted cracker."
	icon_state = "cracker"
	filling_color = "#f5deb8"
	center_of_mass = "x=17;y=6"
	nutriment_desc = list("cracker" = 1)
	w_class = ITEM_SIZE_TINY
	volume = 10
	nutriment_amt = 1

/////////////////////////////////////////////////PIZZA////////////////////////////////////////

/obj/item/reagent_containers/food/snacks/sliceable/pizza
	slices_num = 6
	filling_color = "#baa14c"

/obj/item/reagent_containers/food/snacks/sliceable/pizza/margherita
	name = "margherita"
	desc = "The golden standard of pizzas."
	icon_state = "pizzamargherita"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/margherita
	slices_num = 6
	center_of_mass = "x=16;y=11"
	nutriment_desc = list("pizza crust" = 5, "tomato" = 10, "cheese" = 10)
	nutriment_amt = 25
	bitesize = 2
/obj/item/reagent_containers/food/snacks/sliceable/pizza/margherita/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 5)
	reagents.add_reagent(/datum/reagent/drink/juice/tomato, 3)

/obj/item/reagent_containers/food/snacks/slice/margherita
	name = "margherita slice"
	desc = "A slice of the classic pizza."
	icon_state = "pizzamargheritaslice"
	filling_color = "#baa14c"
	bitesize = 2
	center_of_mass = "x=18;y=13"
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/pizza/margherita

/obj/item/reagent_containers/food/snacks/slice/margherita/filled
	filled = TRUE

/obj/item/reagent_containers/food/snacks/sliceable/pizza/meatpizza
	name = "meatpizza"
	desc = "A pizza with meat topping."
	icon_state = "meatpizza"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/meatpizza
	slices_num = 6
	center_of_mass = "x=16;y=11"
	nutriment_desc = list("pizza crust" = 3, "tomato" = 3, "cheese" = 4)
	nutriment_amt = 10
	bitesize = 2
/obj/item/reagent_containers/food/snacks/sliceable/pizza/meatpizza/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 19)
	reagents.add_reagent(/datum/reagent/drink/juice/tomato, 3)

/obj/item/reagent_containers/food/snacks/slice/meatpizza
	name = "meatpizza slice"
	desc = "A slice of a meaty pizza."
	icon_state = "meatpizzaslice"
	filling_color = "#baa14c"
	bitesize = 2
	center_of_mass = "x=18;y=13"
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/pizza/meatpizza

/obj/item/reagent_containers/food/snacks/slice/meatpizza/filled
	filled = TRUE

/obj/item/reagent_containers/food/snacks/sliceable/pizza/mushroompizza
	name = "mushroompizza"
	desc = "Very special pizza."
	icon_state = "mushroompizza"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/mushroompizza
	slices_num = 6
	center_of_mass = "x=16;y=11"
	nutriment_desc = list("pizza crust" = 5, "tomato" = 10, "cheese" = 5, "mushroom" = 10)
	nutriment_amt = 30
	bitesize = 2

/obj/item/reagent_containers/food/snacks/slice/mushroompizza
	name = "mushroompizza slice"
	desc = "Maybe it is the last slice of pizza in your life."
	icon_state = "mushroompizzaslice"
	filling_color = "#baa14c"
	bitesize = 2
	center_of_mass = "x=18;y=13"
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/pizza/mushroompizza

/obj/item/reagent_containers/food/snacks/slice/mushroompizza/filled
	filled = TRUE

/obj/item/reagent_containers/food/snacks/sliceable/pizza/vegetablepizza
	name = "vegetable pizza"
	desc = "No one of Tomato Sapiens were harmed during making this pizza."
	icon_state = "vegetablepizza"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/vegetablepizza
	slices_num = 6
	center_of_mass = "x=16;y=11"
	nutriment_desc = list("pizza crust" = 2, "tomato" = 4, "cheese" = 5, "eggplant" = 6, "carrot" = 3, "corn" = 5)
	nutriment_amt = 25
	bitesize = 2
/obj/item/reagent_containers/food/snacks/sliceable/pizza/vegetablepizza/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/drink/juice/tomato, 3)
	reagents.add_reagent(/datum/reagent/imidazoline, 3)

/obj/item/reagent_containers/food/snacks/slice/vegetablepizza
	name = "vegetable pizza slice"
	desc = "A slice of the most green pizza of all pizzas not containing green ingredients."
	icon_state = "vegetablepizzaslice"
	filling_color = "#baa14c"
	bitesize = 2
	center_of_mass = "x=18;y=13"
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/pizza/vegetablepizza

/obj/item/reagent_containers/food/snacks/slice/vegetablepizza/filled
	filled = TRUE


/obj/item/reagent_containers/food/snacks/sliceable/pizza/fruitpizza
	name = "fruit pizza"
	desc = "Cream and mixed fruit on a pizza crust. Is it even legal?"
	icon_state = "fruitpizza"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/fruitpizza
	slices_num = 6
	center_of_mass = "x=16;y=11"
	nutriment_desc = list("pizza crust" = 5)
	nutriment_amt = 5
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sliceable/pizza/fruitpizza/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/drink/juice/pineapple, 3)
	reagents.add_reagent(/datum/reagent/drink/juice/banana, 3)
	reagents.add_reagent(/datum/reagent/drink/juice/berry, 3)

/obj/item/reagent_containers/food/snacks/slice/fruitpizza
	name = "fruit pizza slice"
	desc = "A slice of cream, fruit, and crust. How strange."
	icon_state = "fruitpizzaslice"
	filling_color = "#baa14c"
	bitesize = 2
	center_of_mass = "x=18;y=13"
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/pizza/fruitpizza


/obj/item/reagent_containers/food/snacks/slice/fruitpizza/filled
	filled = TRUE


/obj/item/pizzabox
	name = "pizza box"
	desc = "A box suited for pizzas."
	icon = 'icons/obj/food/food_storage.dmi'
	icon_state = "pizzabox1"

	var/open = 0 // Is the box open?
	var/ismessy = 0 // Fancy mess on the lid
	var/obj/item/reagent_containers/food/snacks/sliceable/pizza // content pizza
	var/list/boxes = list()// If the boxes are stacked, they come here
	var/boxtag = ""

/obj/item/pizzabox/on_update_icon()

	ClearOverlays()

	// Set appropriate description
	if(open && pizza)
		desc = "A box suited for pizzas. It appears to have a [pizza.name] inside."
	else if(length(boxes) > 0)
		desc = "A pile of boxes suited for pizzas. There appears to be [length(boxes) + 1] boxes in the pile."

		var/obj/item/pizzabox/topbox = boxes[length(boxes)]
		var/toptag = topbox.boxtag
		if(toptag != "")
			desc = "[desc] The box on top has a tag, it reads: '[toptag]'."
	else
		desc = "A box suited for pizzas."

		if(boxtag != "")
			desc = "[desc] The box has a tag, it reads: '[boxtag]'."

	// Icon states and overlays
	if(open)
		if(ismessy)
			icon_state = "pizzabox_messy"
		else
			icon_state = "pizzabox_open"

		if(pizza)
			var/image/pizzaimg = image(pizza.icon, icon_state = pizza.icon_state)
			if (istype(pizza, /obj/item/reagent_containers/food/snacks/sliceable/variable/pizza))
				var/image/filling = image("food_custom.dmi", icon_state = "pizza_filling")
				filling.appearance_flags = DEFAULT_APPEARANCE_FLAGS | RESET_COLOR
				filling.color = pizza.filling_color
				pizzaimg.AddOverlays(filling)
			pizzaimg.pixel_y = -3
			AddOverlays(pizzaimg)

		return
	else
		// Stupid code because byondcode sucks
		var/doimgtag = 0
		if(length(boxes) > 0)
			var/obj/item/pizzabox/topbox = boxes[length(boxes)]
			if(topbox.boxtag != "")
				doimgtag = 1
		else
			if(boxtag != "")
				doimgtag = 1

		if(doimgtag)
			var/image/tagimg = image("food.dmi", icon_state = "pizzabox_tag")
			tagimg.pixel_y = length(boxes) * 3
			AddOverlays(tagimg)

	icon_state = "pizzabox[length(boxes)+1]"

/obj/item/pizzabox/attack_hand(mob/user as mob)

	if(open && pizza)
		user.put_in_hands(pizza)

		to_chat(user, SPAN_WARNING("You take \the [pizza] out of \the [src]."))
		src.pizza = null
		update_icon()
		return

	if(length(boxes) > 0)
		if(user.get_inactive_hand() != src)
			..()
			return

		var/obj/item/pizzabox/box = boxes[length(boxes)]
		boxes -= box

		user.put_in_hands(box)
		to_chat(user, SPAN_WARNING("You remove the topmost [src] from your hand."))
		box.update_icon()
		update_icon()
		return
	..()

/obj/item/pizzabox/attack_self(mob/user as mob)

	if(length(boxes) > 0)
		return

	open = !open

	if(open && pizza)
		ismessy = 1

	update_icon()

/obj/item/pizzabox/use_tool(obj/item/I, mob/living/user, list/click_params)
	if(istype(I, /obj/item/pizzabox))
		var/obj/item/pizzabox/box = I

		if(!box.open && !open)
			// make a list of all boxes to be added
			var/list/boxestoadd = list()
			boxestoadd += box
			for(var/obj/item/pizzabox/i in box.boxes)
				boxestoadd += i

			if((length(boxes)+1) + length(boxestoadd) <= 5)
				if(!user.unEquip(box, src))
					FEEDBACK_UNEQUIP_FAILURE(user, box)
					return TRUE
				box.boxes = list()// clear the box boxes so we don't have boxes inside boxes. - Xzibit
				boxes.Add( boxestoadd )
				box.update_icon()
				update_icon()

				to_chat(user, SPAN_WARNING("You put \the [box] ontop of \the [src]!"))
			else
				to_chat(user, SPAN_WARNING("The stack is too high!"))
		else
			to_chat(user, SPAN_WARNING("Close \the [box] first!"))
		return TRUE

	if (istype(I, /obj/item/reagent_containers/food/snacks/sliceable/pizza) || istype(I, /obj/item/reagent_containers/food/snacks/sliceable/variable/pizza))
		if (open)
			if (!pizza)
				if(!user.unEquip(I, src))
					FEEDBACK_UNEQUIP_FAILURE(user, I)
					return TRUE
				pizza = I
				update_icon()
				to_chat(user, SPAN_WARNING("You put \the [I] in \the [src]!"))
			else
				to_chat(user, SPAN_WARNING("There is already \a [pizza] in \the [src]!"))
		else
			to_chat(user, SPAN_WARNING("You try to push \the [I] through the lid but it doesn't work!"))
		return TRUE

	if (istype(I, /obj/item/pen))

		if (open)
			USE_FEEDBACK_FAILURE("You need to close \the [src].")
			return TRUE

		var/t = sanitize(input("Enter what you want to add to the tag:", "Write", null, null) as text, 30)

		var/obj/item/pizzabox/boxtotagto = src
		if( length(boxes) > 0 )
			boxtotagto = boxes[length(boxes)]

		boxtotagto.boxtag = copytext("[boxtotagto.boxtag][t]", 1, 30)

		update_icon()
		return TRUE

	return ..()

/obj/item/pizzabox/margherita/Initialize()
	. = ..()
	pizza = new /obj/item/reagent_containers/food/snacks/sliceable/pizza/margherita(src)
	boxtag = "Margherita Deluxe"
	queue_icon_update()

/obj/item/pizzabox/vegetable/Initialize()
	. = ..()
	pizza = new /obj/item/reagent_containers/food/snacks/sliceable/pizza/vegetablepizza(src)
	boxtag = "Gourmet Vegatable"
	queue_icon_update()

/obj/item/pizzabox/mushroom/Initialize()
	. = ..()
	pizza = new /obj/item/reagent_containers/food/snacks/sliceable/pizza/mushroompizza(src)
	boxtag = "Mushroom Special"
	queue_icon_update()

/obj/item/pizzabox/meat/Initialize()
	. = ..()
	pizza = new /obj/item/reagent_containers/food/snacks/sliceable/pizza/meatpizza(src)
	boxtag = "Meatlover's Supreme"
	queue_icon_update()

/obj/item/pizzabox/fruit/Initialize()
	. = ..()
	pizza = new /obj/item/reagent_containers/food/snacks/sliceable/pizza/fruitpizza(src)
	boxtag = "Fruit Fanatic"
	queue_icon_update()

/obj/item/reagent_containers/food/snacks/dionaroast
	name = "roast diona"
	desc = "It's like an enormous, leathery carrot. With an eye."
	icon_state = "dionaroast"
	trash = /obj/item/trash/plate
	filling_color = "#75754b"
	center_of_mass = "x=16;y=7"
	nutriment_desc = list("a chorus of flavor" = 6)
	nutriment_amt = 6
	bitesize = 2
/obj/item/reagent_containers/food/snacks/dionaroast/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/radium, 2)

///////////////////////////////////////////
// new old food stuff from bs12
///////////////////////////////////////////

/obj/item/reagent_containers/food/snacks/dough
	name = "dough"
	desc = "A piece of dough."
	icon = 'icons/obj/food/food_ingredients.dmi'
	icon_state = "dough"
	filling_color = "#d6bca4"
	bitesize = 2
	center_of_mass = "x=16;y=13"
	nutriment_desc = list("dough" = 3)
	nutriment_amt = 3
	var/vegan = FALSE

/obj/item/reagent_containers/food/snacks/dough/Initialize()
	.=..()
	if (vegan)
		reagents.add_reagent(/datum/reagent/nutriment/softtofu, 1)
	else
		reagents.add_reagent(/datum/reagent/nutriment/protein, 1)

// Dough + rolling pin = flat dough
/obj/item/reagent_containers/food/snacks/dough/use_tool(obj/item/W, mob/living/user, list/click_params)
	if(istype(W,/obj/item/material/rollingpin))
		new /obj/item/reagent_containers/food/snacks/sliceable/flatdough(src, vegan)
		to_chat(user, SPAN_NOTICE("You flatten the dough."))
		qdel(src)
		return TRUE
	return ..()

/obj/item/reagent_containers/food/snacks/dough/vegan
	name = "Soy Dough"
	vegan = TRUE

// slicable into 3x doughslices
/obj/item/reagent_containers/food/snacks/sliceable/flatdough
	name = "flat dough"
	desc = "A flattened dough."
	icon = 'icons/obj/food/food_ingredients.dmi'
	icon_state = "flat dough"
	filling_color = "#d6bca4"
	slice_path = /obj/item/reagent_containers/food/snacks/doughslice
	slices_num = 3
	center_of_mass = "x=16;y=16"
	nutriment_desc = list("dough" = 3)
	nutriment_amt = 3

/obj/item/reagent_containers/food/snacks/sliceable/flatdough/Initialize(mapload, vegan)
	.=..()
	if (vegan)
		name = "flat soy dough"
		reagents.add_reagent(/datum/reagent/nutriment/softtofu, 1)
	else
		reagents.add_reagent(/datum/reagent/nutriment/protein, 1)

/obj/item/reagent_containers/food/snacks/doughslice
	name = "dough slice"
	desc = "A building block of an impressive dish."
	icon = 'icons/obj/food/food_ingredients.dmi'
	icon_state = "doughslice"
	filling_color = "#d6bca4"
	slice_path = /obj/item/reagent_containers/food/snacks/spagetti
	slices_num = 1
	bitesize = 2
	center_of_mass = "x=17;y=19"
	nutriment_desc = list("dough" = 1)
	nutriment_amt = 1

/obj/item/reagent_containers/food/snacks/doughslice/on_reagent_change()
	. = ..()
	if (!reagents.has_reagent(/datum/reagent/nutriment/protein))
		name = "soy dough slice"
	else
		name = initial(name)

/obj/item/reagent_containers/food/snacks/bun
	name = "bun"
	desc = "A base for any self-respecting burger."
	icon = 'icons/obj/food/food_ingredients.dmi'
	icon_state = "bun"
	filling_color = "#b8824c"
	bitesize = 2
	center_of_mass = "x=16;y=12"
	nutriment_desc = list("bun" = 3)
	nutriment_amt = 3

/obj/item/reagent_containers/food/snacks/bun/on_reagent_change()
	. = ..()
	if (!reagents.has_reagent(/datum/reagent/nutriment/protein))
		name = "soy bun"
	else
		name = initial(name)

/obj/item/reagent_containers/food/snacks/customburger
	name = "custom burger"
	desc = "A tasty burger."
	icon = 'icons/obj/food/food_custom.dmi'
	icon_state = "customburger"
	filling_color = "#b8824c"
	center_of_mass = "x=16;y=12"
	nutriment_desc = list("bun" = 2)
	nutriment_amt = 3
	bitesize = 2

///Bunch of recipes that can be done outside a microwave; contains code to transfer over reagents to avoid empty food items as this is usually handled by microwave code.
///Transfers over meat reagents only not bun; as bun nutriment reagents as created when the burger is initialized.
/obj/item/reagent_containers/food/snacks/bun/use_tool(obj/item/reagent_containers/ingredient as obj, mob/user as mob)
	if (!istype(ingredient))
		return ..()
	var/obj/item/reagent_containers/food/snacks/created

	if (istype(ingredient,/obj/item/reagent_containers/food/snacks/meatball) || istype(ingredient,/obj/item/reagent_containers/food/snacks/cutlet))
		created = new /obj/item/reagent_containers/food/snacks/meatburger(src)
		ingredient.reagents.trans_to_obj(created, ingredient.reagents.total_volume)
		to_chat(user, SPAN_NOTICE("You make a burger."))
		qdel(ingredient)
		qdel(src)

	else if (istype(ingredient,/obj/item/reagent_containers/food/snacks/sausage))
		created = new /obj/item/reagent_containers/food/snacks/hotdog(src)
		ingredient.reagents.trans_to_obj(created, ingredient.reagents.total_volume)
		to_chat(user, SPAN_NOTICE("You make a hotdog."))
		qdel(ingredient)
		qdel(src)

	else if (istype(ingredient,/obj/item/reagent_containers/food/snacks/bun))
		new /obj/item/reagent_containers/food/snacks/bunbun(src)
		to_chat(user, SPAN_NOTICE("You make a bun bun."))
		qdel(ingredient)
		qdel(src)

	else if (istype(ingredient, /obj/item/reagent_containers/food/snacks))
		var/obj/item/reagent_containers/food/snacks/custom_ingredient = ingredient
		var/obj/item/reagent_containers/food/snacks/customburger/custom_burger = new(src)
		custom_burger.SetName("[custom_ingredient.name]-burger")
		custom_burger.filling_color = custom_ingredient.filling_color
		var/image/custom_image = image(custom_burger.icon, "customburger_filling")
		custom_image.color = custom_ingredient.filling_color
		custom_burger.AddOverlays(custom_image)
		custom_ingredient.reagents.trans_to_obj(custom_burger, custom_ingredient.reagents.total_volume)
		to_chat(user, SPAN_NOTICE("You make \a [custom_burger]."))
		qdel(custom_ingredient)
		qdel(src)

	return ..()

/obj/item/reagent_containers/food/snacks/meatburger/use_tool(obj/item/reagent_containers/food/snacks/cheesewedge/ingredient as obj, mob/user as mob)
	if (istype(ingredient))
		var/created = new /obj/item/reagent_containers/food/snacks/cheeseburger(src)
		ingredient.reagents.trans_to_obj(created, ingredient.reagents.total_volume)
		reagents.trans_to_obj(created, reagents.total_volume)
		to_chat(user, SPAN_NOTICE("You make a cheeseburger."))
		qdel(ingredient)
		qdel(src)
	return ..()

/obj/item/reagent_containers/food/snacks/human/burger/use_tool(obj/item/reagent_containers/food/snacks/cheesewedge/ingredient as obj, mob/user as mob)
	if (istype(ingredient))
		var/created = new /obj/item/reagent_containers/food/snacks/cheeseburger(src)
		ingredient.reagents.trans_to_obj(created, ingredient.reagents.total_volume)
		reagents.trans_to_obj(created, reagents.total_volume)
		to_chat(user, SPAN_NOTICE("You make a cheeseburger."))
		qdel(ingredient)
		qdel(src)
	return ..()

/obj/item/reagent_containers/food/snacks/boiledspagetti/use_tool(obj/item/reagent_containers/food/snacks/meatball/ingredient as obj, mob/user as mob)
	if (istype(ingredient))
		var/created = new /obj/item/reagent_containers/food/snacks/meatballspagetti(src)
		ingredient.reagents.trans_to_obj(created, ingredient.reagents.total_volume)
		reagents.trans_to_obj(created, reagents.total_volume)
		to_chat(user, SPAN_NOTICE("You add some meatballs to the spaghetti."))
		qdel(ingredient)
		qdel(src)
	return ..()

/obj/item/reagent_containers/food/snacks/meatballspagetti/use_tool(obj/item/reagent_containers/food/snacks/meatball/ingredient as obj, mob/user as mob)
	if (istype(ingredient))
		var/created = new /obj/item/reagent_containers/food/snacks/spesslaw(src)
		ingredient.reagents.trans_to_obj(created, ingredient.reagents.total_volume)
		reagents.trans_to_obj(created, reagents.total_volume)
		to_chat(user, SPAN_NOTICE("You add some more meatballs to the spaghetti."))
		qdel(ingredient)
		qdel(src)
	return ..()

/obj/item/reagent_containers/food/snacks/bunbun
	name = "bun bun"
	desc = "A small bread monkey fashioned from two burger buns."
	icon_state = "bunbun"
	filling_color = "#b8824c"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=8)
	nutriment_desc = list("bun" = 6)
	nutriment_amt = 6

/obj/item/reagent_containers/food/snacks/taco
	name = "taco"
	desc = "Take a bite!"
	icon_state = "taco"
	filling_color = "#d63c3c"
	bitesize = 3
	center_of_mass = "x=21;y=12"
	nutriment_desc = list("taco shell" = 2)
	nutriment_amt = 2

/obj/item/reagent_containers/food/snacks/rawcutlet
	name = "raw cutlet"
	desc = "A thin piece of raw meat."
	icon = 'icons/obj/food/food_ingredients.dmi'
	filling_color = "#fb8258"
	icon_state = "rawcutlet"
	filling_color = "#fb8258"
	slice_path = /obj/item/reagent_containers/food/snacks/rawbacon
	slices_num = 2
	bitesize = 1
	center_of_mass = "x=17;y=20"
	sushi_overlay = "meat"

/obj/item/reagent_containers/food/snacks/rawcutlet/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 1)

/obj/item/reagent_containers/food/snacks/cutlet
	name = "cutlet"
	desc = "A tasty meat slice."
	icon = 'icons/obj/food/food_ingredients.dmi'
	icon_state = "cutlet"
	filling_color = "#d75608"
	bitesize = 2
	center_of_mass = "x=17;y=20"
	sushi_overlay = "meat"

/obj/item/reagent_containers/food/snacks/cutlet/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 3)

/obj/item/reagent_containers/food/snacks/rawbacon
	name = "raw bacon"
	desc = "A raw, fatty strip of meat."
	icon_state = "rawbacon"
	filling_color = "#ffa7a3"
	bitesize = 1
	center_of_mass = "x=16;y=15"

/obj/item/reagent_containers/food/snacks/bacon
	name = "bacon"
	desc = "A delicious, crispy strip of meat."
	icon_state = "bacon"
	filling_color = "#cb5d27"
	bitesize = 2
	center_of_mass = "x=16;y=15"

/obj/item/reagent_containers/food/snacks/bacon/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 2)

/obj/item/reagent_containers/food/snacks/rawmeatball
	name = "raw meatball"
	desc = "A raw meatball."
	icon = 'icons/obj/food/food_ingredients.dmi'
	icon_state = "rawmeatball"
	filling_color = "#ce3711"
	bitesize = 2
	center_of_mass = "x=16;y=15"

/obj/item/reagent_containers/food/snacks/rawmeatball/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 2)

/obj/item/reagent_containers/food/snacks/hotdog
	name = "hotdog"
	desc = "Unrelated to dogs, maybe."
	icon_state = "hotdog"
	filling_color = "#ca5d16"
	bitesize = 2
	nutriment_amt = 3
	nutriment_desc = list("bun" = 2)
	center_of_mass = "x=16;y=17"

/obj/item/reagent_containers/food/snacks/classichotdog
	name = "classic hotdog"
	desc = "Going literal."
	icon_state = "hotcorgi"
	filling_color = "#ca5d16"
	bitesize = 6
	nutriment_amt = 3
	nutriment_desc = list("bun" = 2)
	center_of_mass = "x=16;y=17"

/obj/item/reagent_containers/food/snacks/classichotdog/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 16)

/obj/item/reagent_containers/food/snacks/flatbread
	name = "flatbread"
	desc = "Bland but filling."
	icon = 'icons/obj/food/food_ingredients.dmi'
	icon_state = "flatbread"
	filling_color = "#c17f3e"
	bitesize = 2
	center_of_mass = "x=16;y=16"
	nutriment_desc = list("bread" = 3)
	nutriment_amt = 3

/obj/item/reagent_containers/food/snacks/rawsticks
	name = "raw potato sticks"
	desc = "Raw fries, not very tasty."
	icon = 'icons/obj/food/food_ingredients.dmi'
	icon_state = "rawsticks"
	filling_color = "#e4bf7e"
	bitesize = 2
	center_of_mass = "x=16;y=12"
	nutriment_desc = list("raw potato" = 3)
	nutriment_amt = 3

/obj/item/reagent_containers/food/snacks/rawsticks/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drink/juice/potato, 3)

/obj/item/reagent_containers/food/snacks/grown/potato/use_tool(obj/item/material/knife/tool, mob/living/user, list/click_params)
	if (istype(tool))
		new /obj/item/reagent_containers/food/snacks/rawsticks(src)
		to_chat(user, SPAN_NOTICE("You cut the potato."))
		qdel(src)
		return TRUE
	else
		return ..()

//Canned Foods - crack open, eat.

/obj/item/reagent_containers/food/snacks/canned
	name = "void can"
	icon = 'icons/obj/food/food_canned.dmi'
	atom_flags = 0
	var/sealed = TRUE

/obj/item/reagent_containers/food/snacks/canned/Initialize()
	. = ..()
	if(!sealed)
		unseal()

/obj/item/reagent_containers/food/snacks/canned/examine(mob/user)
	. = ..()
	to_chat(user, "It is [sealed ? "" : "un"]sealed.")

/obj/item/reagent_containers/food/snacks/canned/proc/unseal()
	atom_flags |= ATOM_FLAG_OPEN_CONTAINER
	sealed = FALSE
	update_icon()

/obj/item/reagent_containers/food/snacks/canned/attack_self(mob/user)
	if(sealed)
		playsound(loc,'sound/effects/canopen.ogg', rand(10,50), 1)
		to_chat(user, SPAN_NOTICE("You unseal \the [src] with a crack of metal."))
		unseal()

/obj/item/reagent_containers/food/snacks/canned/on_update_icon()
	if(!sealed)
		icon_state = "[initial(icon_state)]-open"

//Just a short line of Canned Consumables, great for treasure in faraway abandoned outposts

/obj/item/reagent_containers/food/snacks/canned/beef
	name = "quadrangled beefium"
	icon_state = "beef"
	desc = "Proteins carefully cloned from extinct stock of holstein in the meat foundries of Mars."
	trash = /obj/item/trash/beef
	filling_color = "#663300"
	center_of_mass = "x=15;y=9"
	nutriment_desc = list("beef" = 1)
	bitesize = 3
/obj/item/reagent_containers/food/snacks/canned/beef/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 12)

/obj/item/reagent_containers/food/snacks/canned/beans
	name = "baked beans"
	icon_state = "beans"
	desc = "Luna Colony beans. Carefully synthethized from soy."
	trash = /obj/item/trash/beans
	filling_color = "#ff6633"
	center_of_mass = "x=15;y=9"
	nutriment_desc = list("beans" = 1)
	nutriment_amt = 12
	bitesize = 3

/obj/item/reagent_containers/food/snacks/canned/tomato
	name = "tomato soup"
	icon_state = "tomato"
	desc = "Plain old unseasoned tomato soup. This can predates the formation of the SCG."
	trash = /obj/item/trash/tomato
	filling_color = "#ae0000"
	center_of_mass = "x=15;y=9"
	nutriment_desc = list("tomato" = 1)
	bitesize = 3
	eat_sound = 'sound/items/drink.ogg'

/obj/item/reagent_containers/food/snacks/canned/tomato/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/drink/juice/tomato, 12)


/obj/item/reagent_containers/food/snacks/canned/tomato/feed_sound(mob/user)
	playsound(user.loc, 'sound/items/drink.ogg', rand(10, 50), 1)

/obj/item/reagent_containers/food/snacks/canned/spinach
	name = "spinach"
	icon_state = "spinach"
	desc = "Wup-Az! Brand canned spinach. Notably has less iron in it than a watermelon."
	trash = /obj/item/trash/spinach
	filling_color = "#003300"
	center_of_mass = "x=15;y=9"
	nutriment_desc = list("soggy" = 1, "vegetable" = 1)
	bitesize = 20


/obj/item/reagent_containers/food/snacks/canned/spinach/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment, 5)
	reagents.add_reagent(/datum/reagent/adrenaline, 5)
	reagents.add_reagent(/datum/reagent/hyperzine, 5)
	reagents.add_reagent(/datum/reagent/iron, 5)


/obj/item/reagent_containers/food/snacks/canned/berries
	name = "berries"
	icon_state = "berries"
	desc = "Berries preserved in syrup. Good enough for ancient Egypt."
	trash = /obj/item/trash/berries
	filling_color = "#801a39"
	center_of_mass = "x=15;y=9"
	nutriment_desc = list("soggy" = 1, "vegetable" = 1)
	bitesize = 20


/obj/item/reagent_containers/food/snacks/canned/berries/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment, 3)
	reagents.add_reagent(/datum/reagent/sugar, 5)
	reagents.add_reagent(/datum/reagent/drink/juice/berry, 5)


//Vending Machine Foods should go here.

/obj/item/reagent_containers/food/snacks/canned/caviar
	name = "caviar"
	icon_state = "fisheggs"
	desc = "Terran caviar, or space carp eggs. Carefully faked using alginate, artificial flavoring and salt. Skrell approved!"
	trash = /obj/item/trash/fishegg
	filling_color = "#000000"
	center_of_mass = "x=15;y=9"
	nutriment_desc = list("fish" = 1, "salt" = 1)
	nutriment_amt = 6
	bitesize = 1

/obj/item/reagent_containers/food/snacks/canned/caviar/true
	name = "caviar"
	icon_state = "carpeggs"
	desc = "Terran caviar, or space carp eggs. Banned by the Sol Food Health Administration for exceeding the legally set amount of carpotoxins in foodstuffs."
	trash = /obj/item/trash/carpegg
	filling_color = "#330066"
	center_of_mass = "x=15;y=9"
	nutriment_desc = list("fish" = 1, "salt" = 1, "numbing sensation" = 1)
	nutriment_amt = 6
	bitesize = 1
/obj/item/reagent_containers/food/snacks/caviar/true/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 4)
	reagents.add_reagent(/datum/reagent/toxin/carpotoxin, 1)

/obj/item/reagent_containers/food/snacks/sosjerky
	name = "beef jerky"
	icon_state = "sosjerky"
	desc = "Beef jerky made from the finest space cows."
	trash = /obj/item/trash/sosjerky
	filling_color = "#631212"
	center_of_mass = "x=15;y=9"
	bitesize = 2
/obj/item/reagent_containers/food/snacks/sosjerky/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 4)

/obj/item/reagent_containers/food/snacks/no_raisin
	name = "raisins"
	icon_state = "4no_raisins"
	desc = "Best raisins in the universe. Not sure why."
	trash = /obj/item/trash/raisins
	filling_color = "#343834"
	center_of_mass = "x=15;y=4"
	nutriment_desc = list("raisins" = 6)
	nutriment_amt = 6

/obj/item/reagent_containers/food/snacks/spacetwinkie
	name = "space eclair"
	icon_state = "space_twinkie"
	desc = "Guaranteed to survive longer then you will."
	filling_color = "#ffe591"
	center_of_mass = "x=15;y=11"
	bitesize = 2
/obj/item/reagent_containers/food/snacks/spacetwinkie/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/sugar, 4)


/obj/item/reagent_containers/food/snacks/cheesiehonkers
	name = "cheesie honkers"
	icon_state = "cheesie_honkers"
	desc = "Bite sized cheesie snacks that will honk all over your mouth."
	trash = /obj/item/trash/cheesie
	filling_color = "#ffa305"
	center_of_mass = "x=15;y=9"
	nutriment_desc = list("cheese" = 5, "chips" = 2)
	nutriment_amt = 4
	bitesize = 2

/obj/item/reagent_containers/food/snacks/syndicake
	name = "syndi-cakes"
	icon_state = "syndi_cakes"
	desc = "An extremely moist snack cake that tastes just as good after being nuked."
	filling_color = "#ff5d05"
	center_of_mass = "x=16;y=10"
	nutriment_desc = list("sweetness" = 3, "cake" = 1)
	nutriment_amt = 4
	trash = /obj/item/trash/syndi_cakes
	bitesize = 3
/obj/item/reagent_containers/food/snacks/syndicake/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/drink/doctor_delight, 5)

//terran delights

/obj/item/reagent_containers/food/snacks/pistachios
	name = "pistachios"
	icon_state = "pistachios"
	desc = "Pistachios. There is absolutely nothing remarkable about these."
	trash = /obj/item/trash/pistachios
	filling_color = "#825d26"
	center_of_mass = "x=15;y=9"
	bitesize = 0.5
/obj/item/reagent_containers/food/snacks/pistachios/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/nutriment/almondmeal, 3)

/obj/item/reagent_containers/food/snacks/semki
	name = "semki"
	icon_state = "semki"
	desc = "Sunflower seeds. A favorite among both birds and gopniks."
	trash = /obj/item/trash/semki
	filling_color = "#68645d"
	center_of_mass = "x=15;y=9"
	nutriment_desc = list("sunflower seeds" = 1)
	nutriment_amt = 6
	bitesize = 0.5

/obj/item/reagent_containers/food/snacks/squid
	name = "calamari crisps"
	icon_state = "squid"
	desc = "Space squid tentacles, Carefully removed (from the squid) then dried into strips of delicious rubbery goodness!"
	trash = /obj/item/trash/squid
	filling_color = "#c0a9d7"
	center_of_mass = "x=15;y=9"
	nutriment_desc = list("fish" = 1, "salt" = 1)
	nutriment_amt = 2
	bitesize = 1
/obj/item/reagent_containers/food/snacks/squid/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 4)

/obj/item/reagent_containers/food/snacks/croutons
	name = "suhariki"
	icon_state = "croutons"
	desc = "Fried bread cubes. Popular in Terran territories."
	trash = /obj/item/trash/croutons
	filling_color = "#c6b17f"
	center_of_mass = "x=15;y=9"
	nutriment_desc = list("bread" = 1, "salt" = 1)
	nutriment_amt = 3
	bitesize = 1

/obj/item/reagent_containers/food/snacks/salo
	name = "salo"
	icon_state = "salo"
	desc = "Pig fat. Salted. Just as good as it sounds."
	trash = /obj/item/trash/salo
	filling_color = "#e0bcbc"
	center_of_mass = "x=15;y=9"
	nutriment_desc = list("fat" = 1, "salt" = 1)
	nutriment_amt = 2
	bitesize = 2
/obj/item/reagent_containers/food/snacks/salo/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 8)

/obj/item/reagent_containers/food/snacks/driedfish
	name = "vobla"
	icon_state = "driedfish"
	desc = "Dried salted beer snack fish."
	trash = /obj/item/trash/driedfish
	filling_color = "#c8a5bb"
	center_of_mass = "x=15;y=9"
	nutriment_desc = list("fish" = 1, "salt" = 1)
	nutriment_amt = 2
	bitesize = 1
/obj/item/reagent_containers/food/snacks/driedfish/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 4)

/obj/item/reagent_containers/food/snacks/liquidfood
	name = "liquid-food MRE"
	desc = "A prepackaged grey slurry for all of the essential nutrients a soldier requires to survive. No expiration date is visible..."
	icon_state = "liquidfood"
	trash = /obj/item/trash/liquidfood
	filling_color = "#a8a8a8"
	center_of_mass = "x=16;y=15"
	nutriment_desc = list("chalk" = 6)
	nutriment_amt = 20
	bitesize = 4
/obj/item/reagent_containers/food/snacks/liquidfood/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/iron, 3)

/obj/item/reagent_containers/food/snacks/meatcube
	name = "cubed meat"
	desc = "Fried, salted lean meat compressed into a cube. Not very appetizing."
	icon_state = "meatcube"
	filling_color = "#7a3d11"
	center_of_mass = "x=16;y=16"
	bitesize = 3
/obj/item/reagent_containers/food/snacks/meatcube/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 15)

/obj/item/reagent_containers/food/snacks/tastybread
	name = "bread tube"
	desc = "Bread in a tube. Chewy... and surprisingly tasty."
	icon_state = "tastybread"
	trash = /obj/item/trash/tastybread
	filling_color = "#a66829"
	center_of_mass = "x=17;y=16"
	nutriment_desc = list("bread" = 2, "sweetness" = 3)
	nutriment_amt = 6
	bitesize = 2

/obj/item/reagent_containers/food/snacks/skrellsnacks
	name = "skrellsnax"
	desc = "Cured fungus shipped all the way from Jargon 4, almost like jerky! Almost."
	icon_state = "skrellsnacks"
	filling_color = "#a66829"
	center_of_mass = "x=15;y=12"
	nutriment_desc = list("mushroom" = 5, "salt" = 5)
	nutriment_amt = 10
	bitesize = 3

/obj/item/reagent_containers/food/snacks/candy
	name = "candy"
	desc = "Nougat, love it or hate it."
	icon_state = "candy"
	trash = /obj/item/trash/candy
	filling_color = "#7d5f46"
	center_of_mass = "x=15;y=15"
	nutriment_amt = 1
	nutriment_desc = list("candy" = 1)
	bitesize = 2
/obj/item/reagent_containers/food/snacks/candy/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/sugar, 3)

/obj/item/reagent_containers/food/snacks/candy/donor
	name = "donor candy"
	desc = "A little treat for blood donors."
	trash = /obj/item/trash/candy
	nutriment_desc = list("candy" = 10)
	bitesize = 5
/obj/item/reagent_containers/food/snacks/candy/donor/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/nutriment, 10)
	reagents.add_reagent(/datum/reagent/sugar, 3)

/obj/item/reagent_containers/food/snacks/proteinbar
	name = "protein bar"
	desc = "SwoleMAX brand protein bars, guaranteed to get you feeling perfectly overconfident."
	icon_state = "proteinbar"
	trash = /obj/item/trash/proteinbar
	bitesize = 6
	atom_flags = ATOM_FLAG_OPEN_CONTAINER | ATOM_FLAG_NO_REACT

/obj/item/reagent_containers/food/snacks/proteinbar/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/nutriment, 9)
	reagents.add_reagent(/datum/reagent/nutriment/protein, 4)
	var/flavor = pick(GLOB.proteinbar_flavors)
	var/flavor_type = GLOB.proteinbar_flavors[flavor]
	var/count = length(flavor_type)
	if (count)
		for (var/type in flavor_type)
			reagents.add_reagent(type, round(4 / count, 0.1))
	else
		reagents.add_reagent(flavor_type, 4)
	name = "[flavor] [name]"

/obj/item/reagent_containers/food/snacks/candy_corn
	name = "candy corn"
	desc = "It's a handful of candy corn. Cannot be stored in a detective's hat, alas."
	icon_state = "candy_corn"
	filling_color = "#fffcb0"
	center_of_mass = "x=14;y=10"
	nutriment_amt = 4
	nutriment_desc = list("candy corn" = 4)
	bitesize = 2
/obj/item/reagent_containers/food/snacks/candy_corn/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/nutriment, 4)
	reagents.add_reagent(/datum/reagent/sugar, 2)

/obj/item/reagent_containers/food/snacks/chips
	name = "chips"
	desc = "Commander Riker's What-The-Crisps."
	icon_state = "chips"
	trash = /obj/item/trash/chips
	filling_color = "#e8c31e"
	center_of_mass = "x=15;y=15"
	nutriment_amt = 3
	nutriment_desc = list("salt" = 1, "chips" = 2)
	bitesize = 1

/obj/item/reagent_containers/food/snacks/cookie
	name = "cookie"
	desc = "COOKIE!!!"
	icon_state = "cookie"
	filling_color = "#dbc94f"
	center_of_mass = "x=17;y=18"
	w_class = ITEM_SIZE_TINY
	volume = 20
	bitesize = 1

/obj/item/reagent_containers/food/snacks/chocolatebar
	name = "chocolate bar"
	desc = "Such sweet, fattening food."
	icon_state = "chocolatebar"
	filling_color = "#7d5f46"
	center_of_mass = "x=15;y=15"
	bitesize = 2
/obj/item/reagent_containers/food/snacks/chocolatebar/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/sugar, 5)
	reagents.add_reagent(/datum/reagent/nutriment/coco, 5)

/obj/item/reagent_containers/food/snacks/chocolateegg
	name = "chocolate egg"
	desc = "Such sweet, fattening food."
	icon_state = "chocolateegg"
	filling_color = "#7d5f46"
	center_of_mass = "x=16;y=13"
	nutriment_amt = 3
	nutriment_desc = list("chocolate" = 3)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/donut
	name = "donut"
	desc = "Goes great with Robust Coffee."
	icon_state = "donut"
	filling_color = "#b87b12"
	var/overlay_state = "box-donut1"
	center_of_mass = "x=13;y=16"
	nutriment_desc = list("sweetness", "donut")

/obj/item/reagent_containers/food/snacks/donut/on_reagent_change()
	. = ..()
	if (icon_state == initial(icon_state) && reagents.has_reagent(/datum/reagent/nutriment/sprinkles, 3))
		icon_state = "[initial(icon_state)]2"
		filling_color = "#ff7fc1"
		SetName("frosted [initial(name)]")

/obj/item/reagent_containers/food/snacks/donut/normal
	name = "donut"
	desc = "Goes great with Robust Coffee."
	icon_state = "donut"
	center_of_mass = "x=19;y=16"
	nutriment_amt = 3
	bitesize = 3

/obj/item/reagent_containers/food/snacks/donut/chaos
	name = "chaos donut"
	desc = "Like life, it never quite tastes the same."
	icon_state = "donut_chaos"
	overlay_state = "box-donut_chaos"
	filling_color = "#b87b12"
	nutriment_amt = 2
	bitesize = 10

/obj/item/reagent_containers/food/snacks/donut/chaos/on_reagent_change()
	. = ..()
	var/generating
	if (generating)
		return

	if (reagents.has_reagent(/datum/reagent/capsaicin, 5))
		generating = TRUE
		reagents.remove_reagent(/datum/reagent/capsaicin, 5)
		reagents.add_reagent(pick(list(
			/datum/reagent/drink/juice/tomato,
			/datum/reagent/ethanol/thirteenloko,
			/datum/reagent/drugs/hextro,
			/datum/reagent/kelotane,
			/datum/reagent/hyperzine,
			/datum/reagent/drink/doctor_delight,
			/datum/reagent/leporazine/hot,
			/datum/reagent/toxin/pyrotoxin,
			/datum/reagent/toxin/poisonberryjuice
		)), 5)
		visible_message(SPAN_INFO("\The [src] seems to be emitting more heat."))
		generating = FALSE

	if (reagents.has_reagent(/datum/reagent/frostoil, 5))
		generating = TRUE
		reagents.remove_reagent(/datum/reagent/frostoil, 5)
		reagents.add_reagent(pick(list(
			/datum/reagent/drink/juice/berry,
			/datum/reagent/helium,
			/datum/reagent/space_cleaner,
			/datum/reagent/peridaxon,
			/datum/reagent/dexalinp,
			/datum/reagent/tricordrazine,
			/datum/reagent/leporazine/cold,
			/datum/reagent/toxin/cryotoxin,
			/datum/reagent/vecuronium_bromide
		)), 5)
		visible_message(SPAN_INFO("\The [src] seems to be cooling the environment around it."))
		generating = FALSE

/obj/item/reagent_containers/food/snacks/donut/jelly
	name = "jelly donut"
	desc = "You jelly?"
	icon_state = "jdonut"
	filling_color = "#b87b12"
	center_of_mass = "x=16;y=11"
	nutriment_amt = 3
	bitesize = 5

///Need to manually add some taste to snacks part of the random snack rotation; since reagents are usually transfered while cooking.
/obj/item/reagent_containers/food/snacks/donut/jelly/Initialize(mapload)
	.=..()
	if (mapload)
		reagents.add_reagent(/datum/reagent/drink/juice/berry, 5)

/obj/item/reagent_containers/food/snacks/donut/slimejelly
	name = "jelly donut"
	desc = "You jelly?"
	icon_state = "jdonut"
	filling_color = "#b87b12"
	center_of_mass = "x=16;y=11"
	nutriment_amt = 3
	bitesize = 5

/obj/item/reagent_containers/food/snacks/donut/cherryjelly
	name = "jelly donut"
	desc = "You jelly?"
	icon_state = "jdonut"
	filling_color = "#b87b12"
	center_of_mass = "x=16;y=11"
	nutriment_amt = 3
	bitesize = 5

///Need to manually add some taste to snacks part of the random snack rotation; since reagents usually are transfered while cooking.
/obj/item/reagent_containers/food/snacks/donut/cherryjelly/Initialize(mapload)
	. = ..()
	if (mapload)
		reagents.add_reagent(/datum/reagent/nutriment/cherryjelly, 5)

/obj/item/reagent_containers/food/snacks/clam_chowder
	name = "clam chowder"
	desc = "A delicious creamy chowder made with clam and potatoes."
	icon_state = "clam-chowder"
	filling_color = "#f6db93"
	trash = /obj/item/trash/snack_bowl
	nutriment_desc = list("potato" = 5)
	nutriment_amt = 5
	bitesize = 5
	eat_sound = 'sound/items/drink.ogg'

/obj/item/reagent_containers/food/snacks/bisque
	name = "bisque"
	desc = "A creamy soup garnished with lumps of crab meat. Bon appétit!"
	icon_state = "bisque"
	filling_color = "#ffa156"
	trash = /obj/item/trash/snack_bowl
	nutriment_desc = list("crab" = 5)
	nutriment_amt = 5
	bitesize = 5
	eat_sound = 'sound/items/drink.ogg'

/obj/item/reagent_containers/food/snacks/stuffed_clam
	name = "stuffed clam"
	desc = "A clam minced with breadcrumbs and baked in the shell."
	icon_state = "stuffed-clam"
	filling_color = "#e69720"
	trash = /obj/item/shell/clam
	bitesize = 2

/obj/item/reagent_containers/food/snacks/steamed_mussels
	name = "steamed mussels"
	desc = "A bowl of mussels steamed in a white wine broth. How opulent."
	icon_state = "steamed-mussels"
	filling_color = "#f6a600"
	trash = /obj/item/trash/snack_bowl
	nutriment_desc = list("delicate broth" = 3, "mussels" = 3)
	nutriment_amt = 6
	bitesize = 4

/obj/item/reagent_containers/food/snacks/oysters_rockefeller
	name = "oysters rockefeller"
	desc = "A plate of oysters baked with a decadent sauce of rich herbs, bread crumbs, and a garnish of bacon bits."
	icon_state = "oysters-rockefeller"
	filling_color = "#e69720"
	trash = /obj/item/trash/plate
	nutriment_desc = list("baked oyster" = 5)
	nutriment_amt = 5
	bitesize = 3


/obj/item/reagent_containers/food/snacks/crab_cakes
	name = "crab cakes"
	desc = "Fried crab cakes, topped with a dollop of tartar sauce."
	icon_state = "crab-cakes"
	filling_color = "#e69720"
	trash = /obj/item/trash/usedplatter
	nutriment_desc = list("fried crab" = 5)
	nutriment_amt = 5
	bitesize = 3

/obj/item/reagent_containers/food/snacks/crab_rangoon
	name = "crab rangoon"
	desc = "A creamy deep-fried wonton filled with crab meat and cream cheese."
	icon_state = "crab-rangoon"
	filling_color = "#ffb79e"
	nutriment_desc = list("crab meat" = 5)
	nutriment_amt = 5
	bitesize = 5


/obj/item/reagent_containers/food/snacks/crab_dinner
	name = "crab dinner"
	desc = "A large crab, boiled and served with a lemon wedge. Mind the pincers."
	icon_state = "crab-dinner"
	filling_color = "#ffb79e"
	trash = /obj/item/trash/usedplatter
	nutriment_desc = list("tender crab meat" = 5)
	nutriment_amt = 5
	bitesize = 4

/obj/item/reagent_containers/food/snacks/shrimp_cocktail
	name = "shrimp cocktail"
	desc = "Shrimp served in a glass with cocktail sauce."
	icon_state = "shrimp-cocktail"
	filling_color = "#ffb79e"
	trash = /obj/item/reagent_containers/food/drinks/glass2/cocktail
	nutriment_desc = list("shrimp" = 5)
	nutriment_amt = 5
	bitesize = 4

/obj/item/reagent_containers/food/snacks/shrimp_tempura
	name = "shrimp tempura"
	desc = "A large shrimp deep-fried in a coat of light, fluffy batter."
	icon_state = "shrimp-tempura"
	filling_color = "#ffd553"
	nutriment_desc = list("fried shrimp" = 3)
	nutriment_amt = 3
	bitesize = 3
	sushi_overlay = "tempura"


/obj/item/reagent_containers/food/snacks/seafood_paella
	name = "seafood paella"
	desc = "A dish of rice and mixed seafood, sauted in a shallow pan with various herbs and spices. "
	icon_state = "seafood-paella"
	filling_color = "#f9ad00"
	trash = /obj/item/trash/snack_bowl
	nutriment_desc = list("seafood" = 3, "saffron" = 3)
	nutriment_amt = 6
	bitesize = 6

/obj/item/reagent_containers/food/snacks/mashedpotato
	name = "mashed potato"
	desc = "Pillowy mounds of mashed potato."
	icon_state = "mashedpotato"
	filling_color = "#eddd00"
	trash = /obj/item/trash/plate
	center_of_mass = list("x"=16, "y"=11)
	nutriment_amt = 6
	nutriment_desc = list("mashed potatoes" = 6)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sliceable/roast_chicken
	name = "roast chicken"
	desc = "Roasted and stuffed chicken surrounded by potatoes, all ready for the carving! Dibs on the drumsticks!"
	icon_state = "roast_chicken"
	filling_color = "#9b5e2c"
	slice_path = /obj/item/reagent_containers/food/snacks/roast_chicken_slice
	slices_num = 6
	trash = /obj/item/trash/plate
	nutriment_amt = 12
	nutriment_desc = list("chicken" = 6, "potatoes" = 3, "stuffing" = 3)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/sliceable/roast_chicken/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/soporific, 3)


/obj/item/reagent_containers/food/snacks/roast_chicken_slice
	name = "roast chicken slice"
	desc = "A slice of juicy roasted chicken with potatoes. Get ready to loosen your belt!"
	icon_state = "roast_chicken_slice"
	filling_color = "#9b5e2c"
	trash = /obj/item/trash/plate


/obj/item/reagent_containers/food/snacks/sliceable/tofurkey
	name = "tofurkey"
	desc = "A fake turkey made from tofu."
	icon_state = "tofurkey"
	filling_color = "#fffee0"
	slice_path = /obj/item/reagent_containers/food/snacks/tofurkey_slice
	slices_num = 6
	nutriment_amt = 12
	nutriment_desc = list("turkey" = 3, "tofu" = 5, "stuffing" = 4)
	bitesize = 3


/obj/item/reagent_containers/food/snacks/tofurkey_slice
	name = "tofurkey slice"
	desc = "A slice of fake turkey made from tofu. Tofu-licious!"
	icon_state = "tofurkey_slice"
	filling_color = "#fffee0"
	trash = /obj/item/trash/plate


/obj/item/reagent_containers/food/snacks/figgypudding
	name = "figgy pudding"
	icon_state = "pudding"
	filling_color = "#4e3d3a"
	desc = "Now bring us some figgy pudding, now bring us some figgy pudding... wait a minute, there's not actually any figs in this."
	trash = /obj/item/trash/plate
	nutriment_amt = 10
	nutriment_desc = list("fruit cake" = 5, "raisins" = 5)
	bitesize = 3


/obj/item/reagent_containers/food/snacks/sliceable/chocolateroulade
	name = "chocolate roulade"
	desc = "Chocolate cake with a twist."
	icon_state = "chocolateroulade"
	filling_color = "#573a2f"
	trash = /obj/item/trash/plate
	center_of_mass = list("x"=16, "y"=12)
	slice_path = /obj/item/reagent_containers/food/snacks/chocolaterouladeslice
	slices_num = 5
	nutriment_amt = 10
	nutriment_desc = list("spongey cake" = 10)


/obj/item/reagent_containers/food/snacks/chocolaterouladeslice
	name = "slice of chocolate roulade"
	desc = "A slice of chocolate cake with a twist!"
	icon_state = "chocolaterouladeslice"
	filling_color = "#573a2f"
	trash = /obj/item/trash/plate
	bitesize = 3
	center_of_mass = list("x"=16, "y"=12)


/obj/item/reagent_containers/food/snacks/gumbo
	name = "gumbo"
	desc = "A thick, savory dish of stewed meat, rice, and seafood, with some extra oomf!"
	icon_state = "gumbo"
	filling_color = "#921f10"
	trash = /obj/item/trash/snack_bowl
	nutriment_amt = 15
	nutriment_desc = list("shrimp" = 7, "thick soup" = 8)
	bitesize = 4
	eat_sound = 'sound/items/drink.ogg'


/obj/item/reagent_containers/food/snacks/macandcheese
	name = "mac and cheese"
	desc = "Cheesy, simple, messy fun."
	icon_state = "macandcheese"
	filling_color = "#f1c022"
	trash = /obj/item/trash/snack_bowl/blue
	nutriment_amt = 9
	nutriment_desc = list("cheese" = 5, "pasta" = 4)


/obj/item/reagent_containers/food/snacks/macandcheese/bacon
	name = "bacon mac and cheese"
	icon_state = "baconmacandcheese"


/obj/item/reagent_containers/food/snacks/rugelach
	name = "rugelach"
	desc = "A flaky, bite-sized pastry with an sugary-sweet spiral filling. This one's filled with cinnamon."
	icon_state = "rugelach"
	filling_color = "#ffb85d"
	nutriment_amt = 3
	nutriment_desc = list("flaky pastry" = 3)
	w_class = ITEM_SIZE_TINY
	volume = 20
	bitesize = 3

/obj/item/reagent_containers/food/snacks/rugelach_berry
	name = "raspberry rugelach"
	desc = "A flaky, bite-sized pastry with an sugary-sweet spiral filling. This one's filled with raspberry jam."
	icon_state = "rugelach_berry"
	filling_color = "#ffb85d"
	nutriment_amt = 3
	nutriment_desc = list("flaky pastry" = 3)
	w_class = ITEM_SIZE_TINY
	volume = 20
	bitesize = 3

/obj/item/reagent_containers/food/snacks/frouka
	name = "frouka"
	icon_state = "frouka"
	desc = "A classic Martian staple - this hearty bowl of hard-boiled eggs, fried and served with a spiced mustard paste and potatoes is sure to get you through those cold Martian nights. Happy Founding Day!"
	trash = /obj/item/trash/snack_bowl/blue
	filling_color = "#e0a117"
	nutriment_amt = 12
	nutriment_desc = list("eggs" = 6, "mustard" = 6)
	bitesize = 5

/obj/item/reagent_containers/food/snacks/custard
	name = "custard"
	desc = "A lovely dessert that can also be used to make other, much less lazy desserts."
	icon_state = "custard"
	filling_color = "#ebedc2"
	trash = /obj/item/trash/ramiken
	nutriment_amt = 5
	nutriment_desc = list("custard" = 5)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/custard/use_tool(obj/item/attacking_item, mob/user, params)
	. = ..()
	if(attacking_item.IsWelder())
		var/obj/item/weldingtool/welder = attacking_item
		if(welder.isOn())
			new /obj/item/reagent_containers/food/snacks/creme_brulee(src)
			to_chat(user, "You apply the flame to the sugary custard, caramelizing it.")
			playsound(get_turf(src), 'sound/effects/flare.ogg', 100, 1)
			qdel(src)


/obj/item/reagent_containers/food/snacks/creme_brulee
	name = "creme brulee"
	desc = "You know what would makes a nice, sweet dessert better? A BLOWTORCH!"
	icon_state = "brulee"
	filling_color = "#e9c35b"
	trash = /obj/item/trash/ramiken
	filling_color = "#e9c35b"
	nutriment_amt = 5
	nutriment_desc = list("custard" = 5)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/creme_brulee/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/sugar, 2)
	reagents.add_reagent(/datum/reagent/nutriment/protein/egg, 1)
	reagents.add_reagent(/datum/reagent/drink/syrup_caramel, 5)


//unathi food

/obj/item/reagent_containers/food/snacks/chilied_eggs
	name = "chilied eggs"
	desc = "Three deviled eggs floating in a bowl of spiced meat. A popular lunchtime meal on Moghes."
	icon_state = "chilied-eggs"
	filling_color = "#e00000"
	trash = /obj/item/trash/snack_bowl
	bitesize = 6

/obj/item/reagent_containers/food/snacks/hatchling_surprise
	name = "hatchling surprise"
	desc = "A poached egg on top of several fried strips of meat, favoured by Unathi young and old alike. The real surprise is if you can feed it to your hatchling without losing a finger or two."
	icon_state = "hatchling-surprise"
	filling_color = "#ae654b"
	trash = /obj/item/trash/snack_bowl
	bitesize = 5

/obj/item/reagent_containers/food/snacks/red_sun_special
	name = "red sun special"
	desc = "A single piece of sausage sitting on melted cheese curds. A cheap dish for Unathi working in human space."
	icon_state = "red-sun-special"
	filling_color = "#ffed50"
	trash = /obj/item/trash/snack_bowl
	bitesize = 4

/obj/item/reagent_containers/food/snacks/sea_delight
	name = "\improper Rah'Zakeh delight"
	desc = "Three raw eggs floating in a sea of eye-watering gukhe broth. A mostly-authentic replication of a Yeosa delicacy."
	icon_state = "sea-delight"
	filling_color = "#e00000"
	trash = /obj/item/trash/snack_bowl
	nutriment_amt = 12
	nutriment_desc = list("bitter gukhe" = 12)
	bitesize = 5


/obj/item/reagent_containers/food/snacks/stok_skewers
	name = "stok skewers"
	desc = "Two hearty skewers of seared meat, glazed in a tangy spice. A popular Mumbak street food - despite the name, it can be made with just about any meat."
	icon_state = "stok-skewers"
	filling_color = "#c14c13"
	nutriment_amt = 6
	nutriment_desc = list("bitter gukhe" = 6)
	bitesize = 5

/obj/item/reagent_containers/food/snacks/gukhe_fish
	name = "cured gukhe platter"
	desc = "A fish cutlet cured in a bitter gukhe rub, served with a tangy dipping sauce and a garnish of seaweed. A staple of Yeosa'Unathi cooking."
	icon_state = "gukhe-fish"
	filling_color = "#ee6927"
	nutriment_amt = 6
	nutriment_desc = list("tangy fish", "bitter gukhe")
	bitesize = 5
	trash = /obj/item/trash/usedplatter

/obj/item/reagent_containers/food/snacks/aghrassh_cake
	name = "aghrassh cake"
	desc = "A dense, calorie-packed puck of aghrassh paste, spices, and ground meat, usually eaten by desert-going Unathi. This one has an egg cracked over it to make it a bit more palatable."
	icon_state = "aghrassh-cake"
	filling_color = "#ac5020"
	nutriment_amt = 10
	nutriment_desc = list("aghrassh nuts", "mealy paste")
	bitesize = 5

//Sol Vendor

/obj/item/reagent_containers/food/snacks/lunacake
	name = "luna cake"
	icon_state = "lunacake_wrapped"
	desc = "Now with 20% less lawsuit enabling rhegolith!"
	trash = /obj/item/trash/cakewrap
	filling_color = "#ffffff"
	center_of_mass = "x=15;y=9"
	nutriment_desc = list("sweet" = 4, "vanilla" = 1)
	nutriment_amt = 5
	bitesize = 2

/obj/item/reagent_containers/food/snacks/lunacake/mochicake
	name = "mochi cake"
	icon_state = "mochicake_wrapped"
	desc = "Konnichiwa! Many go lucky rice cakes in future!"
	trash = /obj/item/trash/mochicakewrap
	nutriment_desc = list("sweet" = 4, "rice" = 1)

/obj/item/reagent_containers/food/snacks/lunacake/mooncake
	name = "dark side luna cake"
	icon_state = "mooncake_wrapped"
	desc = "Explore the dark side! May contain trace amounts of reconstituted cocoa."
	trash = /obj/item/trash/mooncakewrap
	filling_color = "#000000"
	nutriment_desc = list("sweet" = 4, "chocolate" = 1)


/obj/item/reagent_containers/food/snacks/triton
	name = "tide gobs"
	icon_state = "tidegobs"
	desc = "Contains over 9000% of your daily recommended intake of salt."
	trash = /obj/item/trash/tidegobs
	filling_color = "#2556b0"
	center_of_mass = "x=15;y=9"
	nutriment_desc = list("salt" = 4, "seagull?" = 1)
	nutriment_amt = 5
	bitesize = 2

/obj/item/reagent_containers/food/snacks/saturn
	name = "saturn-os"
	icon_state = "saturno"
	desc = "A day ration of salt, styrofoam and possibly sawdust."
	trash = /obj/item/trash/saturno
	filling_color = "#dca319"
	center_of_mass = "x=15;y=9"
	nutriment_desc = list("salt" = 4, "wood?" = 1)
	nutriment_amt = 3
	bitesize = 2

/obj/item/reagent_containers/food/snacks/saturn/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/nutriment/groundpeanuts, 3)


/obj/item/reagent_containers/food/snacks/jupiter
	name = "jove gello"
	icon_state = "jupiter"
	desc = "By Joove! It's some kind of gel."
	trash = /obj/item/trash/jupiter
	filling_color = "#dc1919"
	center_of_mass = "x=15;y=9"
	nutriment_desc = list("sweet" = 4, "vanilla?" = 1)
	nutriment_amt = 5
	bitesize = 2

/obj/item/reagent_containers/food/snacks/pluto
	name = "plutonian rods"
	icon_state = "pluto"
	desc = "Baseless tasteless nutrithick rods to get you through the day. Now even less rash inducing!"
	trash = /obj/item/trash/pluto
	filling_color = "#ffffff"
	center_of_mass = "x=15;y=9"
	nutriment_desc = list("chalk" = 4, "sad?" = 1)
	nutriment_amt = 5
	bitesize = 2

/obj/item/reagent_containers/food/snacks/mars
	name = "frouka"
	icon_state = "mars"
	desc = "Celebrate founding day with a steaming self-heated bowl of sweet eggs and taters!"
	trash = /obj/item/trash/mars
	filling_color = "#d2c63f"
	center_of_mass = "x=15;y=9"
	nutriment_desc = list("eggs" = 4, "potato" = 4, "mustard" = 2)
	nutriment_amt = 8
	bitesize = 2

/obj/item/reagent_containers/food/snacks/venus
	name = "venusian hot cakes"
	icon_state = "venus"
	desc = "Hot takes on hot cakes, a timeless classic now finally fit for human consumption!"
	trash = /obj/item/trash/venus
	filling_color = "#d2c63f"
	center_of_mass = "x=15;y=9"
	nutriment_desc = list("heat" = 4, "burning!" = 1)
	nutriment_amt = 5
	bitesize = 2
/obj/item/reagent_containers/food/snacks/venus/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/capsaicin, 5)

/obj/item/reagent_containers/food/snacks/oort
	name = "oort cloud rocks"
	icon_state = "oort"
	desc = "Pop rocks themed on the most important industrial sector in Sol, new formula guarantees fewer shrapnel induced oral injury."
	trash = /obj/item/trash/oort
	filling_color = "#3f7dd2"
	center_of_mass = "x=15;y=9"
	nutriment_desc = list("fizz" = 4, "sweet?" = 1)
	nutriment_amt = 5
	bitesize = 2
/obj/item/reagent_containers/food/snacks/oort/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/frostoil, 5)

//weebo vend! So japanese it hurts

/obj/item/reagent_containers/food/snacks/ricecake
	name = "rice cake"
	icon_state = "ricecake"
	desc = "Ancient earth snack food made from balled up rice."
	nutriment_desc = list("rice" = 4, "sweet?" = 1)
	nutriment_amt = 5
	bitesize = 2

/obj/item/reagent_containers/food/snacks/pokey
	name = "pokeys"
	icon_state = "pokeys"
	desc = "A bundle of chocolate coated bisquit sticks."
	nutriment_desc = list("chocolate" = 4, "bisquit" = 1)
	nutriment_amt = 5
	bitesize = 2

/obj/item/reagent_containers/food/snacks/weebonuts
	name = "red alert nuts"
	icon_state = "weebonuts"
	trash = /obj/item/trash/weebonuts
	desc = "A bag of Red Alert! brand spicy nuts. Goes well with your beer!"
	nutriment_desc = list("spicy!" = 1)
	nutriment_amt = 2
	bitesize = 2
/obj/item/reagent_containers/food/snacks/weebonuts/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/capsaicin, 1)
	reagents.add_reagent(/datum/reagent/nutriment/groundpeanuts, 4)

/obj/item/reagent_containers/food/snacks/chocobanana
	name = "choco banang"
	icon_state = "chocobanana"
	trash = /obj/item/trash/stick
	desc = "A chocolate and sprinkles coated banana. On a stick."
	nutriment_desc = list("chocolate" = 4, "wax?" = 1)
	nutriment_amt = 5
	bitesize = 2
/obj/item/reagent_containers/food/snacks/chocobanana/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/nutriment/sprinkles, 10)

/obj/item/reagent_containers/food/snacks/dango
	name = "dango"
	icon_state = "dango"
	trash = /obj/item/trash/stick
	desc = "Food dyed rice dumplings on a stick."
	nutriment_desc = list("rice" = 4, "topping?" = 1)
	nutriment_amt = 5
	bitesize = 2

//inedible old vendor food

/obj/item/reagent_containers/food/snacks/old
	name = "master old-food"
	desc = "They're all inedible and potentially dangerous items."
	center_of_mass = "x=15;y=12"
	nutriment_desc = list("rot" = 5, "mold" = 5)
	nutriment_amt = 10
	bitesize = 3
	filling_color = "#336b42"
/obj/item/reagent_containers/food/snacks/old/Initialize()
	.=..()
	reagents.add_reagent(pick(list(
				/datum/reagent/fuel,
				/datum/reagent/toxin/amatoxin,
				/datum/reagent/toxin/carpotoxin,
				/datum/reagent/toxin/zombiepowder,
				/datum/reagent/drugs/cryptobiolin,
				/datum/reagent/drugs/psilocybin)), 5)


/obj/item/reagent_containers/food/snacks/old/pizza
	name = "pizza"
	desc = "It's so stale you could probably cut something with the cheese."
	icon_state = "ancient_pizza"

/obj/item/reagent_containers/food/snacks/old/burger
	name = "giga burger"
	desc = "At some point in time this probably looked delicious."
	icon_state = "ancient_burger"

/obj/item/reagent_containers/food/snacks/old/hamburger
	name = "horse burger"
	desc = "Even if you were hungry enough to eat a horse, it'd be a bad idea to eat this."
	icon_state = "ancient_hburger"

/obj/item/reagent_containers/food/snacks/old/fries
	name = "space fries"
	desc = "The salt appears to have preserved these, still stale and gross."
	icon_state = "ancient_fries"

/obj/item/reagent_containers/food/snacks/old/hotdog
	name = "space dog"
	desc = "This one is probably only marginally less safe to eat than when it was first created.."
	icon_state = "ancient_hotdog"

/obj/item/reagent_containers/food/snacks/old/taco
	name = "taco"
	desc = "Interestingly, the shell has gone soft and the contents have gone stale."
	icon_state = "ancient_taco"

/obj/item/reagent_containers/food/snacks/sliceable/unscottiloaf
	name = "loaf of unscotti"
	desc = "A loaf of unscotti, ready to be sliced into the iconic biscotti shape."
	icon_state = "unscottiloaf"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/unscotti
	slices_num = 4
	filling_color = "#ffe396"
	center_of_mass = "x=16;y=9"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/slice/unscotti
	name = "unscotti"
	desc = "An Italian cookie made with almonds. Typically baked again to make biscotti."
	icon_state = "unscotti"
	filling_color = "#d27332"
	bitesize = 4
	center_of_mass = "x=16;y=4"
	w_class = ITEM_SIZE_TINY
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/unscottiloaf
	volume = 15

/obj/item/reagent_containers/food/snacks/slice/unscotti/filled
	filled = TRUE

/obj/item/reagent_containers/food/snacks/biscotti
	name = "biscotti"
	desc = "A twice baked Italian cookie usually served before breakfast, after dinner, or with coffee. This one has almonds."
	icon_state = "biscotti"
	filling_color = "#dbc94f"
	center_of_mass = "x=17;y=18"
	nutriment_amt = 4
	nutriment_desc = list("crumbly cookie" = 4)
	w_class = ITEM_SIZE_TINY
	bitesize = 3
	volume = 15
