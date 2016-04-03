//*********************//
// Generic undergrowth //
//*********************//

/obj/structure/bush //time to rewrite this shit
	name = "foliage"
	desc = "Pretty thick scrub, it'll take something sharp and a lot of determination to clear away."
	icon = 'icons/urist/jungle/plants.dmi'
	icon_state = "bushnew1" //FUCKED UP THE ICON STATE, EVERYTHING IS MUSHROOMS
	density = 1
	anchored = 1
	layer = 3.2
	var/indestructable = 0
	var/stump = 0

/obj/structure/bush/New()

	icon_state = "bushnew[rand(1,4)]"

	if(prob(20))
		name = "thick foliage"
		opacity = 1
		desc = "Very thick scrub that blocks your vision. It'll take something sharp and a lot of determination to clear away"
		icon_state = "thickbush[rand(1,2)]"

	if(indestructable)
		icon_state = "thickbush[rand(1,2)]"

/obj/structure/bush/Bumped(M as mob)
	if (istype(M, /mob/living/simple_animal))
		var/mob/living/simple_animal/A = M
		A.loc = get_turf(src)
	else if (istype(M, /mob/living/carbon/human/monkey))
		var/mob/living/carbon/human/monkey/A = M
		A.loc = get_turf(src)

/obj/structure/bush/attackby(var/obj/I as obj, var/mob/user as mob)
	//hatchets can clear away undergrowth
	if(istype(I, /obj/item/weapon/material/hatchet) || istype(I, /obj/item/weapon/machete) || istype(I, /obj/item/weapon/carpentry/axe))
		if(indestructable)
			//this bush marks the edge of the map, you can't destroy it
			user << "\red You flail away at the undergrowth, but it's too thick here."
			return

		if(stump)
			user << "\blue You clear away the stump."
			qdel(src)

		else if(!stump)
			user.visible_message("\red <b>[user] begins clearing away [src].</b>","\red <b>You begin clearing away [src].</b>")
			spawn(rand(15,30))
				if(get_dist(user,src) < 2)
					user << "\blue You clear away [src]."
//					var/obj/item/stack/material/wood/W = new(src.loc) //was fun for testing, but no longer.
//					W.amount = rand(3,15)
					if(prob(50))
//						icon_state = "stump[rand(1,2)]" //time to resprite stumps.
						name = "cleared foliage"
						desc = "There used to be dense undergrowth here."
						density = 0
						opacity = 0 //so we don't get any opaque stumps from thick bushes
						stump = 1
						pixel_x = rand(-6,6)
						pixel_y = rand(-6,6)
						icon_state = "[icon_state]-stump"

					else
						qdel(src)

//*******************************//
// Strange, fruit-bearing plants //
//*******************************//

var/list/fruit_icon_states = list("badrecipe","kudzupod","reishi","lime","grapes","boiledrorocore","chocolateegg")
var/list/reagent_effects = list("toxin","anti_toxin","stoxin","space_drugs","mindbreaker","zombiepowder","impedrezene")
var/jungle_plants_init = 0

/proc/init_jungle_plants()
	jungle_plants_init = 1
	fruit_icon_states = shuffle(fruit_icon_states)
	reagent_effects = shuffle(reagent_effects)

/obj/item/weapon/reagent_containers/food/snacks/grown/jungle_fruit
	name = "jungle fruit"
	desc = "It smells weird and looks off."
	icon = 'icons/jungle.dmi'
	icon_state = "orange"
//	potency = 1

/obj/item/weapon/reagent_containers/food/snacks/grown/jungle_fruit/New()
	seed = plant_controller.create_random_seed() //it could be anything!
	plantname = seed.name
	..()

/obj/structure/jungle_plant
	icon = 'icons/jungle.dmi'
	icon_state = "plant1"
	desc = "Looks like some of that fruit might be edible."
	var/fruits_left = 3
	var/fruit_type = -1
	var/icon/fruit_overlay
//	var/plant_strength = 1
	var/fruit_r
	var/fruit_g
	var/fruit_b


/obj/structure/jungle_plant/New()
	if(!jungle_plants_init)
		init_jungle_plants()

	fruit_type = rand(1,7)
	icon_state = "plant[fruit_type]"
	fruits_left = rand(1,5)
	fruit_overlay = icon('icons/jungle.dmi',"fruit[fruits_left]")
	fruit_r = 255 - fruit_type * 36
	fruit_g = rand(1,255)
	fruit_b = fruit_type * 36
	fruit_overlay.Blend(rgb(fruit_r, fruit_g, fruit_b), ICON_ADD)
	overlays += fruit_overlay
//	plant_strength = rand(20,200)

/obj/structure/jungle_plant/attack_hand(var/mob/user as mob)
	if(fruits_left > 0)
		fruits_left--
		user << "\blue You pick a fruit off [src]."

		var/obj/item/weapon/reagent_containers/food/snacks/grown/jungle_fruit/J = new (src.loc)
//		J.potency = plant_strength
//		J.icon_state = fruit_icon_states[fruit_type]
//		J.reagents.add_reagent(reagent_effects[fruit_type], 1+round((plant_strength / 20), 1))
//		J.bitesize = 1+round(J.reagents.total_volume / 2, 1)
		J.attack_hand(user)

		overlays -= fruit_overlay
		fruit_overlay = icon('icons/jungle.dmi',"fruit[fruits_left]")
		fruit_overlay.Blend(rgb(fruit_r, fruit_g, fruit_b), ICON_ADD)
		overlays += fruit_overlay
	else
		user << "\red There are no fruit left on [src]."

/obj/structure/jungle_plant/attackby(var/obj/I as obj, var/mob/user as mob)
	//hatchets can clear away undergrowth
	if(istype(I, /obj/item/weapon/material/hatchet) || istype(I, /obj/item/weapon/machete) || istype(I, /obj/item/weapon/carpentry/axe))


		user.visible_message("\red <b>[user] begins clearing away [src].</b>","\red <b>You begin clearing away [src].</b>")
		spawn(rand(15,30))
			if(get_dist(user,src) < 2)
				user << "\blue You clear away [src]."
				new/obj/item/weapon/reagent_containers/food/snacks/grown/jungle_fruit(src.loc)
				new/obj/item/weapon/reagent_containers/food/snacks/grown/jungle_fruit(src.loc)
				qdel(src)
//reeds

/obj/structure/flora/reeds
	name = "reeds"
	desc = "A bunch of reeds. This plant typically grows in wet areas."
	icon = 'icons/obj/flora/ausflora.dmi'
	icon_state = "reedbush_1"

/obj/structure/flora/reeds/New()
	if(prob(25))
		icon_state = "reedbush_1"
	if(prob(25))
		icon_state = "reedbush_2"
	if(prob(25))
		icon_state = "reedbush_3"
	if(prob(25))
		icon_state = "reedbush_4"