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
		"virology_antibodies" = "From uploaded antibody data",
		"virology_dishes" = "From exported virus dishes",
		"gep" = "From uploaded good explorer points",
		"total" = "Total" // If you're adding additional point sources, add it here in a new line. Don't forget to put a comma after the old last line.
	)
	//virus dishes uniqueness
	var/list/sold_virus_strains = list()

	//Price changes
	var/price_modifier = 0.04	//% price goes down from each sale of a material to the supply station: 4% decrease in value for each item sold
	var/sold_items = list()	//Items sold to the supply station	//TODO: Generate an inventory of trade_item datums for the station and simulate supply/demand proper

/datum/controller/subsystem/supply/Initialize()
	. = ..()
	ordernum = rand(1,9000)

	if(GLOB.using_map.using_new_cargo) //here we do setup for the new cargo system
		points_per_process = 0


		point_source_descriptions = list(
			"time" = "Base station supply",
			"manifest" = "From exported manifests",
			"crate" = "From exported crates",
			"virology" = "From uploaded antibody data",
			"gep" = "From uploaded good explorer points",
			"trade" = "From trading items",
			"total" = "Total" // If you're adding additional point sources, add it here in a new line. Don't forget to put a comma after the old last line.
		)

	//Build master supply list
	var/decl/hierarchy/supply_pack/root = decls_repository.get_decl(/decl/hierarchy/supply_pack)
	for(var/decl/hierarchy/supply_pack/sp in root.children)
		if(sp.is_category())
			for(var/decl/hierarchy/supply_pack/spc in sp.get_descendents())
				spc.setup()
				master_supply_list += spc

	for(var/material/mat in SSmaterials.materials)
		if(mat.sale_price > 0)
			point_source_descriptions[mat.display_name] = "From exported [mat.display_name]"

// Just add points over time.
/datum/controller/subsystem/supply/fire()
	add_points_from_source(points_per_process, "time")

//	if(GLOB.using_map.using_new_cargo)
//		points = station_account.money

/datum/controller/subsystem/supply/stat_entry()
	..("Points: [points]")

//Supply-related helper procs.

/datum/controller/subsystem/supply/proc/add_points_from_source(amount, source)
	points += amount
	point_sources[source] += amount
	point_sources["total"] += amount

	if(GLOB.using_map.using_new_cargo)
		if(amount)
			var/datum/transaction/T = new("[GLOB.using_map.station_name]", "Trading Revenue", amount, "[GLOB.using_map.trading_faction.name] Automated Trading System")
			station_account.do_transaction(T)
			var/repamount = GLOB.using_map.new_cargo_inflation * GLOB.using_map.new_cargo_inflation
			if(amount >= repamount)
				SSfactions.update_reputation(GLOB.using_map.trading_faction, 2)
		if(station_account) //this is to avoid a roundstart runtime
			points = station_account.money

	//To stop things being sent to centcomm which should not be sent to centcomm. Recursively checks for these types.
/datum/controller/subsystem/supply/proc/forbidden_atoms_check(atom/A)
	if(istype(A,/mob/living))
		return 1
	if(istype(A,/obj/item/weapon/disk/nuclear))
		return 1
	if(istype(A,/obj/machinery/nuclearbomb))
		return 1
	if(istype(A,/obj/item/device/radio/beacon))
		return 1
	if(istype(A,/obj/machinery/power/supermatter))
		return 1

	for(var/i=1, i<=A.contents.len, i++)
		var/atom/B = A.contents[i]
		if(.(B))
			return 1

/datum/controller/subsystem/supply/proc/sell()
	var/list/material_count = list()
	var/list/to_sell = list()
	var/list/crates = list()

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

			if(istype(AM, /obj/structure/closet/crate/))
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
					if(find_slip && istype(A,/obj/item/weapon/paper/manifest))
						var/obj/item/weapon/paper/manifest/slip = A
						if(!slip.is_copy && slip.stamped && slip.stamped.len) //Any stamp works.
							add_points_from_source(points_per_slip, "manifest")
							find_slip = 0
						continue

					// Must sell ore detector disks in crates
					if(istype(A, /obj/item/weapon/disk/survey))
						var/obj/item/weapon/disk/survey/D = A
						add_points_from_source(round(D.Value() * 0.005), "gep")
						qdel(D)
						continue

					// Sell virus dishes.
					if(istype(A, /obj/item/weapon/virusdish))
						//Obviously the dish must be unique and never sold before.
						var/obj/item/weapon/virusdish/dish = A
						if(dish.analysed && istype(dish.virus2) && dish.virus2.uniqueID)
							if(!(dish.virus2.uniqueID in sold_virus_strains))
								add_points_from_source(5, "virology_dishes")
								sold_virus_strains += dish.virus2.uniqueID
						qdel(dish)
						continue

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

//Buyin
/datum/controller/subsystem/supply/proc/buy()
	if(!shoppinglist.len)
		return
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
	for(var/S in shoppinglist)
		if(!clear_turfs.len)
			break
		var/turf/pickedloc = pick_n_take(clear_turfs)
		shoppinglist -= S
		donelist += S

		var/datum/supply_order/SO = S
		var/decl/hierarchy/supply_pack/SP = SO.object

		var/obj/A = new SP.containertype(pickedloc)
		A.SetName("[SP.containername][SO.comment ? " ([SO.comment])":"" ]")
		//supply manifest generation begin

		var/obj/item/weapon/paper/manifest/slip
		if(!SP.contraband)
			var/info = list()
			info +="<h3>[command_name()] Shipping Manifest</h3><hr><br>"
			info +="Order #[SO.ordernum]<br>"
			info +="Destination: [GLOB.using_map.station_name]<br>"
			info +="[shoppinglist.len] PACKAGES IN THIS SHIPMENT<br>"
			info +="CONTENTS:<br><ul>"

			slip = new /obj/item/weapon/paper/manifest(A, JOINTEXT(info))
			slip.is_copy = 0

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

/datum/supply_order
	var/ordernum
	var/decl/hierarchy/supply_pack/object = null
	var/orderedby = null
	var/comment = null
	var/reason = null
	var/orderedrank = null //used for supply console printing

/datum/controller/subsystem/supply/proc/make_trade(var/obj/object, var/count = 1)
	. = find_item_value(object, count)
	if(.)
		sold_items[object.type] += count
	return .

/datum/controller/subsystem/supply/proc/find_item_value(var/obj/object, var/count = 1, var/use_reinf_material = FALSE) //here we get the value of the items being traded
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

/datum/controller/subsystem/supply/proc/calculate_multiple_sales(var/value, var/count, var/sell_modifier = 1)
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