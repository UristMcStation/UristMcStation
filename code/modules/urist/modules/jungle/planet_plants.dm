//*********************//
// Generic undergrowth //
//*********************//

/obj/structure/bush //time to rewrite this shit
	name = "foliage"
	desc = "Pretty thick scrub, it'll take something sharp and a lot of determination to clear away."
	icon = 'icons/urist/jungle/plants.dmi'
	icon_state = "bushnew1" //FUCKED UP THE ICON STATE, EVERYTHING IS MUSHROOMS
	density = TRUE
	anchored = TRUE
	layer = 3.2
	var/indestructable = 0
	var/stump = 0
	atom_flags = ATOM_FLAG_CLIMBABLE

/obj/structure/bush/Initialize()
	. = ..()

	if(indestructable)
		icon_state = "thickbush[rand(1,2)]"

	else
		if(prob(20))
			name = "thick foliage"
			opacity = 1
			desc = "Very thick scrub that blocks your vision. It'll take something sharp and a lot of determination to clear away"
			icon_state = "thickbush[rand(1,2)]"

		else
			icon_state = "bushnew[rand(1,4)]"


/obj/structure/bush/Bumped(M as mob)
	if (istype(M, /mob/living/simple_animal))
		var/mob/living/simple_animal/A = M
		A.loc = get_turf(src)
	else if (istype(M, /mob/living/carbon/human/monkey))
		var/mob/living/carbon/human/monkey/A = M
		A.loc = get_turf(src)

/obj/structure/bush/CanPass(atom/movable/mover, turf/target)
	if(istype(mover,/obj/item/projectile))
		return 1

	else ..()

/obj/structure/bush/use_tool(obj/item/I, mob/living/user, list/click_params)
	//hatchets can clear away undergrowth
	if(istype(I, /obj/item/material/hatchet) || istype(I, /obj/item/material/sword/machete) || istype(I, /obj/item/carpentry/axe))
		if(indestructable)
			//this bush marks the edge of the map, you can't destroy it
			to_chat(user, "<span class='warning'> You flail away at the undergrowth, but it's too thick here.</span>")
			return TRUE

		if(stump)
			to_chat(user, "<span class='notice'> You clear away the stump.</span>")
			qdel(src)
			return TRUE

		else if(!stump)
			user.visible_message("<span class='danger'>[user] begins clearing away [src].</span>","<span class='danger'>You begin clearing away [src].</span>")
			if (do_after(user, rand(15,30), src))
				to_chat(user, "<span class='notice'> You clear away [src].</span>")
//					var/obj/item/stack/material/wood/W = new(src.loc) //was fun for testing, but no longer.
//					W.amount = rand(3,15)
				if(prob(25))
//						icon_state = "stump[rand(1,2)]" //time to resprite stumps.
					name = "cleared foliage"
					desc = "There used to be dense undergrowth here."
					density = FALSE
					opacity = 0 //so we don't get any opaque stumps from thick bushes
					stump = 1
					pixel_x = rand(-6,6)
					pixel_y = rand(-6,6)
					icon_state = "[icon_state]-stump"
					return TRUE
				else
					qdel_self()
					return TRUE

	return ..()

/obj/structure/bush/do_climb(mob/living/user)
	if (!can_climb(user))
		return

	if(indestructable)
		return

	usr.visible_message("<span class='warning'>\The [user] starts making their way through the bush!</span>")
	climbers |= user

	if(!do_after(user,(issmall(user) ? 10 : 25), src))
		climbers -= user
		return

	if (!can_climb(user, post_climb_check=1))
		climbers -= user
		return

	usr.forceMove(get_turf(src))

	if (get_turf(user) == get_turf(src))
		usr.visible_message("<span class='warning'>\The [user] slowly makes their way through the bush!</span>")
	climbers -= user


//*******************************//
// Strange, fruit-bearing plants //
//*******************************//

/obj/item/reagent_containers/food/snacks/grown/jungle_fruit
	name = "jungle fruit"
	desc = "It smells weird and looks off."
	icon_state = "orange"
//	potency = 1

/obj/item/reagent_containers/food/snacks/grown/jungle_fruit/New()
	seed = SSplants.create_random_seed() //it could be anything!
	plantname = seed.name
	..()

/obj/structure/jungle_plant
	icon = 'icons/jungle.dmi'
	icon_state = "plant1"
	desc = "A strange jungle plant. Looks like some of that fruit might be edible."
	anchored = TRUE
	var/fruits_left
	var/fruit_type
	var/icon/fruit_overlay
//	var/plant_strength = 1
	var/fruit_r
	var/fruit_g
	var/fruit_b


/obj/structure/jungle_plant/Initialize()
	. = ..()
	pixel_x = rand(-6,6)
	pixel_y = rand(-6,6)
	fruit_type = rand(1,7)
	fruits_left = rand(1,5)
	queue_icon_update()

//	plant_strength = rand(20,200)

/obj/structure/jungle_plant/on_update_icon()
	. = ..()
	if(fruit_type && !fruit_overlay)
		icon_state = "plant[fruit_type]"
		fruit_overlay = icon('icons/jungle.dmi',"fruit[fruits_left]")
		fruit_r = 255 - fruit_type * 36
		fruit_g = rand(1,255)
		fruit_b = fruit_type * 36
		fruit_overlay.Blend(rgb(fruit_r, fruit_g, fruit_b), ICON_ADD)
		AddOverlays(fruit_overlay)

/obj/structure/jungle_plant/attack_hand(mob/user as mob)
	if(fruits_left > 0)
		fruits_left--
		to_chat(user, "<span class='notice'> You pick a fruit off [src].</span>")

		var/obj/item/reagent_containers/food/snacks/grown/jungle_fruit/J = new (src.loc)
		J.attack_hand(user)

		CutOverlays(fruit_overlay)
		fruit_overlay = icon('icons/jungle.dmi',"fruit[fruits_left]")
		fruit_overlay.Blend(rgb(fruit_r, fruit_g, fruit_b), ICON_ADD)
		AddOverlays(fruit_overlay)
	else
		to_chat(user, "<span class='warning'> There are no fruit left on [src].</span>")

/obj/structure/jungle_plant/use_tool(obj/item/I, mob/living/user, list/click_params)
	//hatchets can clear away undergrowth
	if(istype(I, /obj/item/material/hatchet) || istype(I, /obj/item/material/sword/machete) || istype(I, /obj/item/carpentry/axe))


		user.visible_message("<span class='danger'>[user] begins clearing away [src].</span>","<span class='danger'>You begin clearing away [src].</span>")
		spawn(rand(15,30))
			if(get_dist(user,src) < 2)
				to_chat(user, "<span class='notice'> You clear away [src].</span>")
				new/obj/item/reagent_containers/food/snacks/grown/jungle_fruit(src.loc)
				new/obj/item/reagent_containers/food/snacks/grown/jungle_fruit(src.loc)
				qdel_self()
		return TRUE

	return ..()

//reeds

/obj/structure/flora/reeds
	name = "reeds"
	desc = "A bunch of reeds. This plant typically grows in wet areas."
	icon = 'icons/obj/flora/ausflora.dmi'
	icon_state = "reedbush_1"
	anchored = TRUE

/obj/structure/flora/reeds/Initialize()
	icon_state = "reedbush_[rand(1,4)]"
	. = ..()

/obj/structure/flora/reeds/use_tool(obj/item/I, mob/living/user, list/click_params)
	if(istype(I, /obj/item/material/hatchet) || istype(I, /obj/item/material/sword/machete) || istype(I, /obj/item/carpentry/axe))
		user.visible_message("<span class='danger'>[user] begins clearing away [src].</span>","<span class='danger'>You begin clearing away [src].</span>")
		spawn(rand(5,10))
			if(get_dist(user,src) < 2)
				to_chat(user, "<span class='notice'> You clear away [src].</span>")
				qdel_self()
		return TRUE

	else
		return ..()

//arid

/obj/structure/flora/grass/arid
	name = "dry grass"
	icon = 'icons/urist/jungle/miscflora.dmi'
	desc = "Some dry, virtually dead grass."
	icon_state = "tall_grass_1"

/obj/structure/flora/grass/arid/Initialize()
	. = ..()
	icon_state = "tall_grass_[rand(1,8)]"
