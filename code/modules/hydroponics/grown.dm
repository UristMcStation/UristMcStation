//Grown foods.
/obj/item/reagent_containers/food/snacks/grown
	name = "fruit"
	icon = 'icons/obj/flora/hydroponics_products.dmi'
	icon_state = "blank"
	randpixel = 5
	desc = "Nutritious! Probably."
	slot_flags = SLOT_HOLSTER

	var/plantname
	var/datum/seed/seed
	var/potency = -1

/obj/item/reagent_containers/food/snacks/grown/New(newloc,planttype)
	if(planttype)
		plantname = planttype
	..()
	fill_reagents()

/obj/item/reagent_containers/food/snacks/grown/Initialize()
	. = ..()
	if(!SSplants)
		log_error(SPAN_DANGER("Plant controller does not exist and [src] requires it. Aborting."))
		return INITIALIZE_HINT_QDEL

	seed = SSplants.seeds[plantname]

	if(!seed)
		return INITIALIZE_HINT_QDEL

	SetName("[seed.seed_name]")
	trash = seed.get_trash_type()
	if(!dried_type)
		dried_type = type

	update_icon()


/obj/item/reagent_containers/food/snacks/grown/proc/fill_reagents()
	if(!seed)
		return

	if(!seed.chems)
		return

	potency = seed.get_trait(TRAIT_POTENCY)
	if(!reagents)
		create_reagents(volume)
	reagents.clear_reagents()
	// Fill the object up with the appropriate reagents.
	for(var/rid in seed.chems)
		var/list/reagent_data = seed.chems[rid]
		if(reagent_data && !islist(reagent_data))
			log_debug(append_admin_tools("A fill_reagents list was created as a non-list. Seed: [seed] ([seed.type]). Reagent: [rid] = [seed.chems[rid]].", location = get_turf(src)))
			reagent_data = list(reagent_data)

		if(reagent_data && length(reagent_data))
			var/rtotal = reagent_data[1]
			var/list/data = list()
			if(length(reagent_data) > 1 && potency > 0)
				rtotal += round(potency/reagent_data[2])
			if(rid == /datum/reagent/nutriment)
				data[seed.seed_name] = max(1,rtotal)
			reagents.add_reagent(rid,max(1,rtotal),data)
	update_desc()
	if(reagents.total_volume > 0)
		bitesize = 1+round(reagents.total_volume / 2, 1)

/obj/item/reagent_containers/food/snacks/grown/proc/update_desc()

	if(!seed)
		return
	if(!SSplants)
		sleep(250) // ugly hack, should mean roundstart plants are fine.
	if(!SSplants)
		log_error(SPAN_DANGER("Plant controller does not exist and [src] requires it. Aborting."))
		qdel(src)
		return

	if(SSplants.product_descs["[seed.uid]"])
		desc = SSplants.product_descs["[seed.uid]"]
	else
		var/list/descriptors = list()
		if(reagents.has_reagent(/datum/reagent/sugar) || reagents.has_reagent(/datum/reagent/nutriment/cherryjelly) || reagents.has_reagent(/datum/reagent/nutriment/honey) || reagents.has_reagent(/datum/reagent/drink/juice/berry))
			descriptors |= "sweet"
		if(reagents.has_reagent(/datum/reagent/dylovene))
			descriptors |= "astringent"
		if(reagents.has_reagent(/datum/reagent/frostoil))
			descriptors |= "numbing"
		if(reagents.has_reagent(/datum/reagent/nutriment))
			descriptors |= "nutritious"
		if(reagents.has_reagent(/datum/reagent/capsaicin/condensed) || reagents.has_reagent(/datum/reagent/capsaicin))
			descriptors |= "spicy"
		if(reagents.has_reagent(/datum/reagent/nutriment/coco))
			descriptors |= "bitter"
		if(reagents.has_reagent(/datum/reagent/drink/juice/orange) || reagents.has_reagent(/datum/reagent/drink/juice/lemon) || reagents.has_reagent(/datum/reagent/drink/juice/lime))
			descriptors |= "sweet-sour"
		if(reagents.has_reagent(/datum/reagent/radium) || reagents.has_reagent(/datum/reagent/uranium))
			descriptors |= "radioactive"
		if(reagents.has_reagent(/datum/reagent/toxin/amatoxin) || reagents.has_reagent(/datum/reagent/toxin))
			descriptors |= "poisonous"
		if(reagents.has_reagent(/datum/reagent/drugs/psilocybin) || reagents.has_reagent(/datum/reagent/drugs/hextro))
			descriptors |= "hallucinogenic"
		if(reagents.has_reagent(/datum/reagent/bicaridine))
			descriptors |= "medicinal"
		if(reagents.has_reagent(/datum/reagent/gold))
			descriptors |= "shiny"
		if(reagents.has_reagent(/datum/reagent/acid/polyacid) || reagents.has_reagent(/datum/reagent/acid) || reagents.has_reagent(/datum/reagent/acid/hydrochloric))
			descriptors |= "acidic"
		if(seed.get_trait(TRAIT_JUICY))
			descriptors |= "juicy"
		if(seed.get_trait(TRAIT_STINGS))
			descriptors |= "stinging"
		if(seed.get_trait(TRAIT_TELEPORTING))
			descriptors |= "glowing"
		if(seed.get_trait(TRAIT_EXPLOSIVE))
			descriptors |= "bulbous"
		if(reagents.has_reagent(/datum/reagent/lube))
			descriptors |= "slippery"

		var/descriptor_num = rand(2,4)
		var/descriptor_count = descriptor_num
		desc = "A"
		while(length(descriptors) && descriptor_num > 0)
			var/chosen = pick(descriptors)
			descriptors -= chosen
			desc += "[(descriptor_count>1 && descriptor_count!=descriptor_num) ? "," : "" ] [chosen]"
			descriptor_num--
		if(seed.seed_noun == SEED_NOUN_SPORES)
			desc += " mushroom"
		else
			desc += " fruit"
		SSplants.product_descs["[seed.uid]"] = desc
	desc += ". Delicious! Probably."

/obj/item/reagent_containers/food/snacks/grown/on_update_icon()
	if(!seed)
		return
	ClearOverlays()
	icon_state = "[seed.get_trait(TRAIT_PRODUCT_ICON)]-product"
	color = seed.get_trait(TRAIT_PRODUCT_COLOUR)
	if("[seed.get_trait(TRAIT_PRODUCT_ICON)]-leaf" in icon_states('icons/obj/flora/hydroponics_products.dmi'))
		var/image/fruit_leaves = image('icons/obj/flora/hydroponics_products.dmi',"[seed.get_trait(TRAIT_PRODUCT_ICON)]-leaf")
		fruit_leaves.color = seed.get_trait(TRAIT_PLANT_COLOUR)
		AddOverlays(fruit_leaves)

/obj/item/reagent_containers/food/snacks/grown/Crossed(mob/living/M)
	if(seed && seed.get_trait(TRAIT_JUICY) == 2)
		if(istype(M))

			if(M.buckled)
				return

			if(istype(M,/mob/living/carbon/human))
				var/mob/living/carbon/human/H = M
				if(H.shoes && H.shoes.item_flags & ITEM_FLAG_NOSLIP)
					return

			M.stop_pulling()
			to_chat(M, SPAN_NOTICE("You slipped on the [name]!"))
			playsound(src.loc, 'sound/misc/slip.ogg', 50, 1, -3)
			M.Stun(8)
			M.Weaken(5)
			seed.thrown_at(src,M)
			qdel(src)

/obj/item/reagent_containers/food/snacks/grown/throw_impact(atom/hit_atom)
	if(seed) seed.thrown_at(src,hit_atom)
	..()

/obj/item/reagent_containers/food/snacks/grown/use_tool(obj/item/W, mob/living/user, list/click_params)
	if(seed)
		if(isCoil(W))
			var/obj/item/stack/cable_coil/C = W
			if(seed.get_trait(TRAIT_PRODUCT_ICON) in list("flower2","flower3","flower4","flower5","flower6"))
				if(!C.can_use(1))
					USE_FEEDBACK_STACK_NOT_ENOUGH(C, 1, "to make a pin out of \the [src.name].")
					return TRUE
				C.use(1)
				to_chat(user, SPAN_NOTICE("You add some wire to the [src.name] and make a pin."))
				var/obj/item/clothing/head/hairflower/pin = new /obj/item/clothing/head/hairflower(get_turf(src))
				pin.name = "[src.name] pin"
				pin.icon = 'icons/obj/flora/hydroponics_products.dmi'
				pin.icon_state = "[seed.get_trait(TRAIT_PRODUCT_ICON)]-product"
				if("[seed.get_trait(TRAIT_PRODUCT_ICON)]-leaf" in icon_states('icons/obj/flora/hydroponics_products.dmi'))
					var/image/fruit_leaves = image('icons/obj/flora/hydroponics_products.dmi',"[seed.get_trait(TRAIT_PRODUCT_ICON)]-leaf")
					fruit_leaves.color = seed.get_trait(TRAIT_PLANT_COLOUR)
					pin.AddOverlays(fruit_leaves)
				pin.item_state = "hairflower"
				pin.color = src.color
				qdel(src)
				return TRUE
			else if(seed.get_trait(TRAIT_PRODUCES_POWER))
				if(!C.can_use(5))
					USE_FEEDBACK_STACK_NOT_ENOUGH(C, 5, "to wire \the [src.name].")
					return TRUE
				to_chat(user, SPAN_NOTICE("You add some cable to the [src.name] and slide it inside the battery casing."))
				var/obj/item/cell/potato/pocell = new /obj/item/cell/potato(get_turf(src))
				pocell.maxcharge = src.potency * 10
				pocell.charge = pocell.maxcharge
				qdel(src)
				return TRUE
		else if(W.sharp)
			if(seed.kitchen_tag == "pumpkin") // Ugggh these checks are awful.
				user.show_message(SPAN_NOTICE("You carve a face into [src]!"), 1)
				new /obj/item/clothing/head/pumpkinhead (user.loc)
				qdel(src)
				return TRUE
			else if(seed.chems)
				if(isHatchet(W))
					if(!isnull(seed.chems[/datum/reagent/woodpulp]))
						user.visible_message(SPAN_NOTICE("\The [user] makes planks out of \the [src]."))
						new /obj/item/stack/material/wood(user.loc)
						qdel(src)
					else if(!isnull(seed.chems[/datum/reagent/bamboo]))
						user.visible_message(SPAN_NOTICE("\The [user] makes planks out of \the [src]."))
						new /obj/item/stack/material/wood/bamboo(user.loc)
						qdel(src)
					else if(!isnull(seed.chems[/datum/reagent/resinpulp]))
						user.visible_message(SPAN_NOTICE("\The [user] makes resin slabs out of \the [src]."))
						new /obj/item/stack/material/wood/vox(user.loc)
						qdel(src)
					return TRUE
				else if(!isnull(seed.chems[/datum/reagent/drink/juice/potato]))
					to_chat(user, "You slice \the [src] into sticks.")
					new /obj/item/reagent_containers/food/snacks/rawsticks(get_turf(src))
					qdel(src)
					return TRUE
				else if(!isnull(seed.chems[/datum/reagent/drink/juice/carrot]))
					to_chat(user, "You slice \the [src] into sticks.")
					new /obj/item/reagent_containers/food/snacks/carrotfries(get_turf(src))
					qdel(src)
					return TRUE
				else if(!isnull(seed.chems[/datum/reagent/drink/milk/soymilk]))
					to_chat(user, "You roughly chop up \the [src].")
					new /obj/item/reagent_containers/food/snacks/soydope(get_turf(src))
					qdel(src)
					return TRUE
				else if(seed.get_trait(TRAIT_FLESH_COLOUR))
					to_chat(user, "You slice up \the [src].")
					var/slices = rand(3,5)
					var/reagents_to_transfer = round(reagents.total_volume/slices)
					for(var/i in 1 to slices)
						var/obj/item/reagent_containers/food/snacks/fruit_slice/F = new(get_turf(src),seed)
						if(reagents_to_transfer) reagents.trans_to_obj(F,reagents_to_transfer)
					qdel(src)
					return TRUE
	return ..()

/obj/item/reagent_containers/food/snacks/grown/apply_hit_effect(mob/living/target, mob/living/user, hit_zone)
	. = ..()

	if(seed && seed.get_trait(TRAIT_STINGS))
		if(!reagents || reagents.total_volume <= 0)
			return
		reagents.remove_any(rand(1,3))
		seed.thrown_at(src, target)
		sleep(-1)
		if(!src)
			return
		if(prob(35))
			if(user)
				to_chat(user, SPAN_DANGER("\The [src] has fallen to bits."))
			qdel(src)

/obj/item/reagent_containers/food/snacks/grown/attack_self(mob/user as mob)

	if(!seed)
		return

	if(istype(user.loc,/turf/space))
		return

	if(user.a_intent == I_HURT)
		user.visible_message(SPAN_DANGER("\The [user] squashes \the [src]!"))
		seed.thrown_at(src,user)
		sleep(-1)
		if(src) qdel(src)
		return

	if(seed.kitchen_tag == "grass")
		user.show_message(SPAN_NOTICE("You make a grass tile out of \the [src]!"), 1)
		var/flesh_colour = seed.get_trait(TRAIT_FLESH_COLOUR)
		if(!flesh_colour) flesh_colour = seed.get_trait(TRAIT_PRODUCT_COLOUR)
		for(var/i=0,i<2,i++)
			var/obj/item/stack/tile/grass/G = new (user.loc)
			if(flesh_colour) G.color = flesh_colour
			for (var/obj/item/stack/tile/grass/NG in user.loc)
				if(G==NG)
					continue
				if(NG.amount>=NG.max_amount)
					continue
				NG.use_tool(G, user)
			to_chat(user, "You add the newly-formed grass to the stack. It now contains [G.amount] tiles.")
		qdel(src)
		return

	if(seed.get_trait(TRAIT_SPREAD) > 0)
		to_chat(user, SPAN_NOTICE("You plant the [src.name]."))
		new /obj/machinery/portable_atmospherics/hydroponics/soil/invisible(get_turf(user),src.seed)
		qdel(src)
		return

/obj/item/reagent_containers/food/snacks/grown/pickup(mob/user)
	..()
	if(!seed)
		return
	if(seed.get_trait(TRAIT_STINGS))
		var/mob/living/carbon/human/H = user
		if(istype(H) && H.gloves)
			return
		if(!reagents || reagents.total_volume <= 0)
			return
		reagents.remove_any(rand(1,3)) //Todo, make it actually remove the reagents the seed uses.
		var/affected = pick(BP_R_HAND,BP_L_HAND)
		seed.do_thorns(H,src,affected)
		seed.do_sting(H,src,affected)

// Predefined types for placing on the map.

/obj/item/reagent_containers/food/snacks/grown/mushroom/libertycap
	plantname = "libertycap"

/obj/item/reagent_containers/food/snacks/grown/ambrosiavulgaris
	plantname = "ambrosia"

/obj/item/reagent_containers/food/snacks/fruit_slice
	name = "fruit slice"
	desc = "A slice of some tasty fruit."
	icon = 'icons/obj/flora/hydroponics_misc.dmi'
	icon_state = ""

var/global/list/fruit_icon_cache = list()

/obj/item/reagent_containers/food/snacks/fruit_slice/New(newloc, datum/seed/S)
	..(newloc)
	// Need to go through and make a general image caching controller. Todo.
	if(!istype(S))
		qdel(src)
		return

	name = "[S.seed_name] slice"
	desc = "A slice of \a [S.seed_name]. Tasty, probably."

	var/rind_colour = S.get_trait(TRAIT_PRODUCT_COLOUR)
	var/flesh_colour = S.get_trait(TRAIT_FLESH_COLOUR)
	if(!flesh_colour) flesh_colour = rind_colour
	if(!fruit_icon_cache["rind-[rind_colour]"])
		var/image/I = image(icon,"fruit_rind")
		I.color = rind_colour
		fruit_icon_cache["rind-[rind_colour]"] = I
	AddOverlays(fruit_icon_cache["rind-[rind_colour]"])
	if(!fruit_icon_cache["slice-[rind_colour]"])
		var/image/I = image(icon,"fruit_slice")
		I.color = flesh_colour
		fruit_icon_cache["slice-[rind_colour]"] = I
	AddOverlays(fruit_icon_cache["slice-[rind_colour]"])
