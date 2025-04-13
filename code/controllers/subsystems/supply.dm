SUBSYSTEM_DEF(supply)
	name = "Supply"
	wait = 20 SECONDS
	priority = SS_PRIORITY_SUPPLY
	//Initializes at default time
	flags = SS_NO_TICK_CHECK

	//supply points
	var/points = 50
	var/points_per_process = 1
	var/points_per_slip = 2
	var/point_sources = list()
	var/pointstotalsum = 0
	var/pointstotal = 0
	//control
	var/ordernum
	var/list/shoppinglist = list()
	var/list/requestlist = list()
	var/list/donelist = list()
	var/list/master_supply_list = list()
	//shuttle movement
	var/movetime = 1200
	var/datum/shuttle/autodock/ferry/supply/shuttle
	var/list/point_source_descriptions = list(
		"time" = "Base station supply",
		"manifest" = "From exported manifests",
		"crate" = "From exported crates",
		"gep" = "From uploaded good explorer points",
		"anomaly" = "From scanned and categorized anomalies",
		"animal" = "From captured exotic alien fauna",
		"total" = "Total" // If you're adding additional point sources, add it here in a new line. Don't forget to put a comma after the old last line.
	)
	//virus dishes uniqueness
	var/list/sold_virus_strains = list()

	//Price changes
	var/price_modifier = 0.04	//% price goes down from each sale of a material to the supply station: 4% decrease in value for each item sold
	var/sold_items = list()	//Items sold to the supply station	//TODO: Generate an inventory of trade_item datums for the station and simulate supply/demand proper

/datum/controller/subsystem/supply/Initialize(start_uptime)
	ordernum = rand(1,9000)

	if(GLOB.using_map.using_new_cargo) //here we do setup for the new cargo system
		points_per_process = 0


		point_source_descriptions = list(
			"time" = "Base station supply",
			"manifest" = "From exported manifests",
			"crate" = "From exported crates",
			"gep" = "From uploaded good explorer points",
			"trade" = "From trading items",
			"total" = "Total" // If you're adding additional point sources, add it here in a new line. Don't forget to put a comma after the old last line.
		)

	//Build master supply list
	var/singleton/hierarchy/supply_pack/root = GET_SINGLETON(/singleton/hierarchy/supply_pack)
	for (var/singleton/hierarchy/supply_pack/sp in root.children)
		if(sp.is_category())
			for(var/singleton/hierarchy/supply_pack/spc in sp.get_descendents())
				spc.setup()
				master_supply_list += spc

	for (var/material/mat in SSmaterials.materials)
		if(mat.sale_price > 0)
			point_source_descriptions[mat.display_name] = "From exported [mat.display_name]"

// Just add points over time.
/datum/controller/subsystem/supply/fire()
	add_points_from_source(points_per_process, "time")

//	if(GLOB.using_map.using_new_cargo)
//		points = station_account.money

/datum/controller/subsystem/supply/UpdateStat(time)
	if (PreventUpdateStat(time))
		return ..()
	..("Points: [points]")


//Supply-related helper procs.

/datum/controller/subsystem/supply/proc/add_points_from_source(amount, source)
	points += amount
	point_sources[source] += amount
	point_sources["total"] += amount

	if(GLOB.using_map.using_new_cargo)
		if(amount)
			station_account.deposit(amount, "Trading Revenue", "[GLOB.using_map.trading_faction.name] Automated Trading System")
			var/repamount = GLOB.using_map.new_cargo_inflation * GLOB.using_map.new_cargo_inflation
			if(amount >= repamount)
				SSfactions.update_reputation(GLOB.using_map.trading_faction, 2)
		if(station_account) //this is to avoid a roundstart runtime
			points = station_account.money

	//To stop things being sent to centcomm which should not be sent to centcomm. Recursively checks for these types.
/datum/controller/subsystem/supply/proc/forbidden_atoms_check(atom/A)
	if (istype(A, /mob/living))
		var/mob/living/mob = A
		if (istype(mob, /mob/living/simple_animal/hostile/human) || mob.mind)
			return TRUE
	if (istype(A, /obj/item/disk/nuclear))
		return TRUE
	if (istype(A, /obj/machinery/nuclearbomb))
		return TRUE
	if (istype(A, /obj/machinery/tele_beacon))
		return TRUE
	if(istype(A,/obj/machinery/power/supermatter))
		return 1

	for(var/i=1, i<=length(A.contents), i++)
		var/atom/B = A.contents[i]
		if(.(B))
			return TRUE

/datum/controller/subsystem/supply/proc/sell()
	var/list/material_count = list()
	var/list/to_sell = list()
	var/list/crates = list()
	//var/atom/A = atom

	for(var/area/subarea in shuttle.shuttle_area)
		for(var/atom/movable/AM in subarea)
			if(AM.anchored)
				continue

			if(GLOB.using_map.using_new_cargo) //this allows for contracts that call for obj/structures
				for(var/datum/contract/cargo/CC in GLOB.using_map.contracts)
					if(AM.type in CC.wanted_types)
						CC.Complete(1)
						qdel(AM)
						break

				if(QDELETED(AM))	//Our atom was qdel'd/used in a contract-- move onto the next atom to free up the reference for GC
					continue

			if(istype(AM, /obj/structure/closet/crate))
				var/obj/structure/closet/crate/CR = AM
				crates[CR] = subarea	//Store the crate to be handled later, as we'll have object refrences we'll need for the contents inside it
				var/find_slip = 1

				for(var/atom/A in CR)
					if(GLOB.using_map.using_new_cargo)
						for(var/datum/contract/cargo/CC in GLOB.using_map.contracts) //just in case someone shoved it in a crate
							if(A.type in CC.wanted_types)
								CC.Complete(1)
								qdel(A)
								break

						if(QDELETED(A))
							continue

					//Calculate sales for each material
					if(istype(A, /obj/item/stack/material))
						var/obj/item/stack/material/S = A
						var/amount = S.get_amount()
						if(S.material.sale_price > 0)
							material_count[S.material.display_name] += find_item_value(S, amount)
						if(S.reinf_material?.sale_price > 0)
							material_count[S.reinf_material.display_name] += find_item_value(S, amount, TRUE)
						qdel(S)
						continue

					// Sell manifests
					if(find_slip && istype(A,/obj/item/paper/manifest))
						var/obj/item/paper/manifest/slip = A
						if(!slip.is_copy && slip.stamped && length(slip.stamped)) //Any stamp works.
							add_points_from_source(points_per_slip, "manifest")
							find_slip = 0
						continue

					// Sell materials
					if(istype(A, /obj/item/stack/material))
						var/obj/item/stack/material/P = A
						if(P.material && P.material.sale_price > 0)
							material_count[P.material.display_name] += P.get_amount() * P.material.sale_price * P.matter_multiplier
						if(P.reinf_material && P.reinf_material.sale_price > 0)
							material_count[P.reinf_material.display_name] += P.get_amount() * P.reinf_material.sale_price * P.matter_multiplier * 0.5
						continue

					// Must sell ore detector disks in crates
					if(istype(A, /obj/item/disk/survey))
						var/obj/item/disk/survey/D = A
						add_points_from_source(round(D.Value() * 0.05), "gep")
						qdel(D)
						continue

					// Sell artefacts (in anomaly cages)
					if (istype(AM, /obj/machinery/anomaly_container))
						var/obj/machinery/anomaly_container/AC = AM
						var/points_per_anomaly = 10
						callHook("sell_anomalycage", list(AC, subarea))
						if (AC.contained)
							var/obj/machinery/artifact/C = AC.contained
							var/list/my_effects = list()
							if (C.my_effect)
								var/datum/artifact_effect/eone = C.my_effect
								my_effects += eone
							if (C.secondary_effect)
								var/datum/artifact_effect/etwo = C.secondary_effect
								my_effects += etwo
							//Different effects and trigger combos give different rewards

							if (AC.attached_paper) //Needs to have a scan sheet of the anomaly to the container.
								if (istype(AC.attached_paper, /obj/item/paper/anomaly_scan))
									var/obj/item/paper/anomaly_scan/P = AC.attached_paper
									if (!P.is_copy)
										for (var/datum/artifact_effect/E in my_effects)
											switch (E.effect_type)
												if (EFFECT_UNKNOWN, EFFECT_PSIONIC)
													points_per_anomaly += 10
												if (EFFECT_ENERGY, EFFECT_ELECTRO)
													points_per_anomaly += 20
												if (EFFECT_ORGANIC, EFFECT_SYNTH)
													points_per_anomaly += 30
												if (EFFECT_BLUESPACE, EFFECT_PARTICLE)
													points_per_anomaly += 40
												else
													points_per_anomaly += 10
													//In case there's ever a broken artifact, it's still worth SOMETHING
											switch (E.trigger.trigger_type)
												if (TRIGGER_SIMPLE)
													points_per_anomaly += 5
												if (TRIGGER_COMPLEX)
													points_per_anomaly += 10
												else
													points_per_anomaly += 2

										add_points_from_source(points_per_anomaly, "anomaly")
										continue

					//Only for animals in stasis cages.
					if (istype(AM, /obj/machinery/stasis_cage))
						var/obj/machinery/stasis_cage/SC = AM
						var/points_per_animal = 10
						callHook("sell_animal", list(SC, subarea))
						if (SC.contained)
							var/mob/living/simple_animal/CA = SC.contained
							if (istype(CA, /mob/living/simple_animal/hostile/human))
								continue
							if (istype(CA, /mob/living/simple_animal/hostile))
								points_per_animal *= 2
							if (istype(CA, /mob/living/simple_animal/hostile/retaliate/beast))
								points_per_animal *= 2
							if (CA.stat != DEAD) //Alive gives more.
								points_per_animal *= 2

							qdel(SC.contained)
							add_points_from_source(points_per_animal, "animal")

					//Sell anything else that isn't unique or needs special handling
					if(GLOB.using_map.using_new_cargo)
						if(A.type in to_sell)
							to_sell[A.type]["count"]++
							qdel(A)	//We already have an object reference to use for values, duplicate items are safe to qdel
						else
							to_sell[A.type] = list("obj" = A, "count" = 1)

			else
				qdel(AM)

	var/payout = 0

	//Sell all items in bulk and qdel them
	for(var/atom_type in to_sell)
		var/obj/O = to_sell[atom_type]["obj"]
		var/amount = to_sell[atom_type]["count"]
		payout += make_trade(O, amount)
		to_sell[atom_type]["obj"] = null
		qdel(O)

	//Sell all materials in bulk
	for(var/material in material_count)
		add_points_from_source(material_count[material], material)

	//Finally sell all crates in bulk and qdel them, calling the sell_crate hook
	for(var/obj/structure/closet/crate/CR in crates)
		callHook("sell_crate", list(CR, crates[CR]))
		add_points_from_source(CR.points_per_crate, "crate")
		crates -= CR
		qdel(CR)

	//Pay our lovely people what they earned
	add_points_from_source(payout, "trade")

/datum/controller/subsystem/supply/proc/get_clear_turfs()
	var/list/clear_turfs = list()

	for(var/area/subarea in shuttle.shuttle_area)
		for(var/turf/T in subarea)
			if(T.density)
				continue
			var/occupied = 0
			for(var/atom/A in T.contents)
				if(!A.simulated)
					continue
				occupied = 1
				break
			if(!occupied)
				clear_turfs += T

	return clear_turfs

//Buyin
/datum/controller/subsystem/supply/proc/buy()
	if(!length(shoppinglist))
		return

	var/list/clear_turfs = get_clear_turfs()

	for(var/S in shoppinglist)
		if(!length(clear_turfs))
			break
		var/turf/pickedloc = pick_n_take(clear_turfs)
		shoppinglist -= S
		donelist += S

		var/datum/supply_order/SO = S
		var/singleton/hierarchy/supply_pack/SP = SO.object

		var/obj/A = new SP.containertype(pickedloc)
		A.SetName("[SP.containername][SO.comment ? " ([SO.comment])":"" ]")
		//supply manifest generation begin

		var/obj/item/paper/manifest/slip
		if(!SP.contraband)
			var/info = list()
			info +="<h3>[GLOB.using_map.boss_name] Shipping Manifest</h3><hr><br>"
			info +="Order #[SO.ordernum]<br>"
			info +="Destination: [GLOB.using_map.station_name]<br>"
			info +="[length(shoppinglist)] PACKAGES IN THIS SHIPMENT<br>"
			info +="CONTENTS:<br><ul>"

			slip = new /obj/item/paper/manifest(A, jointext(info, null))
			slip.is_copy = FALSE

		//spawn the stuff, finish generating the manifest while you're at it
		if(SP.access)
			if(!islist(SP.access))
				A.req_access = list(SP.access)
			else if(islist(SP.access))
				var/list/L = SP.access // access var is a plain var, we need a list
				A.req_access = L.Copy()

		var/list/spawned = SP.spawn_contents(A)
		if(slip)
			for(var/atom/content in spawned)
				slip.info += "<li>[content.name]</li>" //add the item to the manifest
			slip.info += "</ul><br>CHECK CONTENTS AND STAMP BELOW THE LINE TO CONFIRM RECEIPT OF GOODS<hr>"

// Adds any given item to the supply shuttle
/datum/controller/subsystem/supply/proc/addAtom(atom/movable/A)
	var/list/clear_turfs = get_clear_turfs()
	if(!length(clear_turfs))
		return FALSE

	var/turf/pickedloc = pick(clear_turfs)

	A.forceMove(pickedloc)

	return TRUE

/datum/supply_order
	var/ordernum
	var/timestamp
	var/singleton/hierarchy/supply_pack/object = null
	var/orderedby = null
	var/comment = null
	var/reason = null
	var/orderedrank = null //used for supply console printing

/datum/controller/subsystem/supply/proc/make_trade(obj/object, count = 1)
	. = find_item_value(object, count)
	if(.)
		sold_items[object.type] += count
	return .

/datum/controller/subsystem/supply/proc/find_item_value(obj/object, count = 1, use_reinf_material = FALSE) //here we get the value of the items being traded
	if(!object)
		return 0

	var/sell_modifier = 1

	if(istype(object, /obj/item/stack/material))	//Materials aren't effected by reduced value/compounded prices. Apply any needed modifiers and sell as-is
		var/obj/item/stack/material/M = object
		sell_modifier = GLOB.using_map.using_new_cargo ? (GLOB.using_map.new_cargo_inflation * 0.25) : M.matter_multiplier
		if(use_reinf_material)
			return round(round(count * 0.5) * M.reinf_material.sale_price * sell_modifier)
		return round(count * M.material.sale_price * sell_modifier)

	if(GLOB.using_map.trading_faction?.reputation > 50)
		sell_modifier = (((GLOB.using_map.trading_faction.reputation - 50) / 100) / 2) + 1	//0.5% ~ 25% bonus

	//try and find it via the global controller
	var/datum/trade_item/T = SStrade_controller.trade_items_by_type[object.type]
	var/amount_sold = sold_items[object.type]
	var/sell_value

	if(T)
		if(!T.sellable)
			return 0
		sell_value = T.value
	else
		sell_value = get_value(object)	//Legacy fallback

	if(amount_sold)
		sell_value = sell_value*(1 - src.price_modifier)**amount_sold	//A = P(1 + r/n)^nt		--Current price, factoring multiple previous compounded sales
	return calculate_multiple_sales(sell_value, count, sell_modifier)

/datum/controller/subsystem/supply/proc/calculate_multiple_sales(value, count, sell_modifier = 1)
	if(!value || !count)
		return 0
	var/newPrice = value * sell_modifier
	var/total_value = newPrice	//Price changes AFTER an obj is sold. Let's skip the first trade then.
	count--
	while(count)
		newPrice = newPrice * (1-src.price_modifier)	//Calculate what the new price would be with the devalue of selling individually
		total_value += newPrice
		count--
	return round(total_value)
