/obj/machinery/vending
	abstract_type = /obj/machinery/vending
	name = "\improper Vendomat"
	desc = "A generic vending machine."
	icon = 'icons/obj/machines/vending.dmi'
	icon_state = "generic"
	layer = BELOW_OBJ_LAYER
	anchored = TRUE
	density = TRUE
	obj_flags = OBJ_FLAG_ANCHORABLE | OBJ_FLAG_ROTATABLE
	clicksound = "button"
	clickvol = 40
	base_type = /obj/machinery/vending/generic //NB: Ugly hack. Allows products to be added to vendors that don't specify a correct base type.
	construct_state = /singleton/machine_construction/default/panel_closed
	uncreated_component_parts = null
	machine_name = "vending machine"
	machine_desc = "Holds an internal stock of items that can be dispensed on-demand or when a charged ID card is swiped, depending on the brand."
	idle_power_usage = 10
	wires = /datum/wires/vending
	health_max = 100

	/// The machine's wires, but typed.
	var/datum/wires/vending/vendor_wires

	/// icon_state to flick() when vending
	var/icon_vend

	/// Total number of overlays that can be randomly picked from when an item is being vended.
	var/max_overlays = 1

	/// icon_state to flick() when refusing to vend
	var/icon_deny

	/// Power to one-off spend on successfully vending.
	var/vend_power_usage = 150

	var/active = TRUE //No sales pitches if off!
	var/vend_ready = TRUE //Are we ready to vend?? Is it time??

	/// A field associated with vending machines from the below flags.
	var/vendor_flags = VENDOR_CATEGORY_NORMAL

	var/const/VENDOR_CATEGORY_NORMAL = FLAG_01
	var/const/VENDOR_CATEGORY_HIDDEN = FLAG_02
	var/const/VENDOR_CATEGORY_COIN = FLAG_03
	var/const/VENDOR_CATEGORY_ANTAG = FLAG_04

	var/datum/stored_items/vending_products/currently_vending // What we're requesting payment for right now
	var/status_message = "" // Status screen messages like "insufficient funds", displayed in NanoUI
	var/status_error = 0 // Set to 1 if status_message is an error
	var/list/prices = list() // Prices for each product as (/item/path = price). Unlisted items are free.

	/// Stock for each product as (/item/path = count). Set to '0' if you want the vendor to randomly spawn between 1 and 10 items.
	var/list/products	= list()

	///Probability of each rare product of spawning in, max amount increases with large value. Need to have value of '0' associated with it in product list for this to work.
	var/list/rare_products = list()

	/// Stock for products hidden by the contraband wire as (/item/path = count)
	var/list/contraband	= list()

	/// Stock for products hidden by coin insertion as (/item/path = count)
	var/list/premium = list()

	/// Stock for antag items unlocked by challenge coin purchased from uplink. Each coin costs 10 TCs; value in vendor should be 10 at baseline with rare chance going up to 30.
	var/list/antag = list()

	///Minimum number of possible non-rare product that can be randomly spawned. This can be set by vending machine not item. Minimum rare product is set as 1 by default.
	var/minrandom = 1

	///Maximum number of possible non-rare products that can be randomly spawned. This can be set by vending machine not item. Maximum rare product depends on rarity.
	var/maxrandom = 10

	///Maximum number of randomly generated antag items. Default of 1 so it is usually only 0 or 1. This var is used as exceptions when large amounts of ammo needs to be randomly spawned.
	var/antagrandom = 1

	var/list/product_records = list()
	var/product_slogans = "" //String of slogans spoken out loud, separated by semicolons
	var/antag_slogans = ""
	var/product_ads = "" //String of small ad messages in the vending screen
	var/colored_entries = TRUE
	var/list/ads_list = list()
	var/list/slogan_list = list()
	var/shut_up = TRUE //Stop spouting those godawful pitches!
	var/vend_reply //Thank you for shopping!
	var/last_reply = 0
	var/last_slogan = 0 //When did we last pitch?
	var/slogan_delay = 2 MINUTES //How long until we can pitch again?
	var/seconds_electrified = 0 //Shock customers like an airlock.
	var/shoot_inventory = FALSE //Fire items at customers! We're broken!
	var/shooting_chance = 2 //The chance that items are being shot per tick
	var/scan_id = TRUE
	var/obj/item/material/coin/coin
	var/light_power_on = 0.2
	var/light_range_on = 2


/obj/machinery/vending/Destroy()
	vendor_wires = null
	currently_vending = null
	QDEL_NULL_LIST(product_records)
	QDEL_NULL(coin)
	return ..()


/obj/machinery/vending/Initialize(mapload, d=0, populate_parts = TRUE)
	. = ..()
	vendor_wires = wires
	if (product_slogans)
		slogan_list += splittext(product_slogans, ";")
		last_slogan = world.time + rand(0, slogan_delay)
	if (product_ads)
		ads_list += splittext(product_ads, ";")
	if (minrandom > maxrandom)
		minrandom = maxrandom
	build_inventory(populate_parts)
	update_icon()

/obj/machinery/vending/examine(mob/user)
	. = ..()
	if (IsShowingAntag())
		to_chat(user, SPAN_WARNING("A secret panel is open, revealing a small compartment that is dimly lit with red lighting."))


/obj/machinery/vending/Process()
	if (inoperable())
		return
	if (!active)
		return
	if (seconds_electrified > 0)
		seconds_electrified--
	if (!shut_up && prob(5) && length(slogan_list) && last_slogan + slogan_delay <= world.time)
		var/slogan = pick(slogan_list)
		speak(slogan)
		last_slogan = world.time
	if (shoot_inventory && prob(shooting_chance))
		throw_item()

/obj/machinery/vending/post_health_change(health_mod, prior_health, damage_type)
	. = ..()
	queue_icon_update()
	if (health_mod < 0 && !health_dead())
		var/initial_damage_percentage = Percent(get_max_health() - prior_health, get_max_health(), 0)
		var/damage_percentage = get_damage_percentage()
		if (damage_percentage >= 25 && initial_damage_percentage < 25 && prob(75))
			shut_up = FALSE
		else if (damage_percentage >= 50 && initial_damage_percentage < 50)
			vendor_wires.RandomCut()
		else if (damage_percentage >= 75 && initial_damage_percentage < 75 && prob(10))
			malfunction()

/obj/machinery/vending/powered()
	return anchored && ..()

/obj/machinery/vending/proc/update_glow()
	var/light_color
	if (IsShowingAntag())
		light_color = COLOR_RED
		light_power_on = 0.4
	if (!is_powered() || MACHINE_IS_BROKEN(src))
		set_light(0)
	else
		set_light(light_range_on, light_power_on, light_color)


/obj/machinery/vending/on_update_icon()
	ClearOverlays()
	update_glow()
	if (MACHINE_IS_BROKEN(src))
		icon_state = "[initial(icon_state)]-broken"
	else if (is_powered())
		icon_state = initial(icon_state)
	else
		spawn(rand(0, 15))
		icon_state = "[initial(icon_state)]-off"
	if (panel_open || IsShowingAntag())
		AddOverlays(image(icon, "[initial(icon_state)]-panel"))
	if ((IsShowingAntag() || get_damage_percentage() >= 50) && is_powered())
		AddOverlays(image(icon, "sparks"))
		AddOverlays(emissive_appearance(icon, "sparks"))
	if (!vend_ready)
		AddOverlays(image(icon, "[initial(icon_state)]-shelf[rand(max_overlays)]"))

/obj/machinery/vending/emag_act(remaining_charges, mob/living/user)
	if (emagged)
		return
	emagged = TRUE
	req_access.Cut()
	if (antag_slogans)
		shut_up = FALSE
		slogan_list.Cut()
		slogan_list += splittext(antag_slogans, ";")
		last_slogan = world.time + rand(0, slogan_delay)
	for (var/datum/stored_items/vending_products/product as anything in product_records)
		product.price = 0
	UpdateShowContraband(TRUE)
	SSnano.update_uis(src)
	to_chat(user, "You short out the product lock on \the [src].")
	return 1


/obj/machinery/vending/use_tool(obj/item/item, mob/living/user, list/click_params)
	var/obj/item/card/id/id = item.GetIdCard()
	var/static/list/simple_coins = subtypesof(/obj/item/material/coin) - typesof(/obj/item/material/coin/challenge)
	if (currently_vending && vendor_account && !vendor_account.suspended)
		var/paid
		var/handled
		if (id)
			paid = pay_with_card(id, item)
			handled = TRUE
		else if (istype(item, /obj/item/spacecash/ewallet))
			paid = pay_with_ewallet(item)
			handled = TRUE
		else if (istype(item, /obj/item/spacecash/bundle))
			paid = pay_with_cash(item)
			handled = TRUE
		if (paid)
			vend(currently_vending, user)
			return TRUE
		else if (handled)
			SSnano.update_uis(src)
			return TRUE

	if (id || istype(item, /obj/item/spacecash))
		attack_hand(user)
		return TRUE
	if (isMultitool(item) || isWirecutter(item))
		if (panel_open)
			attack_hand(user)
			return TRUE
	if (is_type_in_list(item, simple_coins))
		if (!length(premium))
			to_chat(user, SPAN_WARNING("\The [src] does not accept the [item]."))
			return TRUE
		if (!user.unEquip(item, src))
			return FALSE
		coin = item
		UpdateShowPremium(TRUE)
		to_chat(user, SPAN_NOTICE("You insert \the [item] into \the [src]."))
		SSnano.update_uis(src)
		return TRUE

	if (istype(item, /obj/item/material/coin/challenge/syndie))
		if (!LAZYLEN(antag))
			to_chat(user, SPAN_WARNING("\The [src] does not have a secret compartment installed."))
			return TRUE
		if (IsShowingAntag())
			to_chat(user, SPAN_WARNING("\The [src]'s secret compartment is already unlocked!"))
			return TRUE
		if (!user.unEquip(item, src))
			to_chat(user, SPAN_WARNING("You can't drop \the [item]."))
			return TRUE
		ProcessAntag(item, user)
		return TRUE

	if ((user.a_intent == I_HELP) && attempt_to_stock(item, user))
		return TRUE

	return ..()

///Proc that enables hidden antag items and replaces slogan list with anti-Sol slogans if any.
/obj/machinery/vending/proc/ProcessAntag(obj/item/item, mob/living/user)
	to_chat(user, SPAN_NOTICE("You insert \the [item] into \the [src]."))
	visible_message(SPAN_WARNING("\The [src] hisses as a hidden panel swings open with a loud thud."))
	playsound(loc, 'sound/items/metal_clack.ogg', 50)
	UpdateShowAntag(TRUE)
	req_access.Cut()
	SSnano.update_uis(src)
	update_icon()
	var/obj/item/material/coin/challenge/syndie/antagcoin = item
	if (antag_slogans)
		shut_up = FALSE
		slogan_list.Cut()
		slogan_list += splittext(antag_slogans, ";")
		last_slogan = world.time + rand(0, slogan_delay)
	if (!isnull(antagcoin.string_color))
		if (prob(10))
			user.put_in_hands(item)
			to_chat(user, SPAN_NOTICE("You successfully pull \the [item] out before \the [src] could swallow it."))
			return TRUE
		else
			to_chat(user, SPAN_NOTICE("You weren't able to pull \the [item] out fast enough, \the [src] ate it, string and all."))
			qdel(item)
			return TRUE
	else
		to_chat(user, SPAN_NOTICE("You hear a loud clink as \the [item] is swallowed by \the [src]"))
		qdel(item)
		return TRUE


/obj/machinery/vending/MouseDrop_T(obj/item/item, mob/living/user)
	if (!CanMouseDrop(item, user) || (item.loc != user))
		return
	return attempt_to_stock(item, user)


/obj/machinery/vending/state_transition(singleton/machine_construction/new_state)
	. = ..()
	SSnano.update_uis(src)


/obj/machinery/vending/physical_attack_hand(mob/living/user)
	if (seconds_electrified)
		if (shock(user, 100))
			return TRUE


/obj/machinery/vending/interface_interact(mob/living/user)
	ui_interact(user)
	return TRUE


/obj/machinery/vending/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui, force_open = TRUE)
	user.set_machine(src)
	var/list/data = list()
	if (currently_vending)
		data["mode"] = TRUE
		data["product"] = currently_vending.item_name
		data["price"] = currently_vending.price
		data["message_err"] = FALSE
		data["message"] = status_message
		data["message_err"] = status_error
	else
		data["mode"] = FALSE
		var/list/listed_products = list()
		for (var/key = 1 to length(product_records))
			var/datum/stored_items/vending_products/product = product_records[key]
			if (!(product.category & vendor_flags))
				continue
			listed_products.Add(list(list(
				"key" = key,
				"name" = product.item_name,
				"price" = product.price,
				"color" = product.display_color,
				"amount" = product.get_amount()
			)))
		data["products"] = listed_products
	if (coin)
		data["coin"] = coin.name
	if (panel_open)
		data["panel"] = TRUE
		data["speaker"] = shut_up ? FALSE : TRUE
	else
		data["panel"] = FALSE
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "vending_machine.tmpl", name, 440, 600)
		ui.set_initial_data(data)
		ui.open()


/obj/machinery/vending/OnTopic(mob/user, href_list, datum/topic_state/state)
	if (href_list["remove_coin"] && !istype(usr, /mob/living/silicon))
		if (!coin)
			to_chat(user, "There is no coin in this machine.")
			return TOPIC_HANDLED
		coin.dropInto(loc)
		if (!user.get_active_hand())
			user.put_in_hands(coin)
		to_chat(user, SPAN_NOTICE("You remove \the [coin] from \the [src]"))
		coin = null
		UpdateShowPremium(FALSE)
		return TOPIC_HANDLED
	if (href_list["vend"] && vend_ready && !currently_vending)
		var/key = text2num(href_list["vend"])
		if (!is_valid_index(key, product_records))
			return TOPIC_REFRESH
		var/datum/stored_items/vending_products/product = product_records[key]
		if (!istype(product))
			return TOPIC_REFRESH
		if (!(product.category & vendor_flags))
			return TOPIC_REFRESH
		if (product.price <= 0)
			vend(product, user)
		else if (istype(user, /mob/living/silicon))
			to_chat(user, SPAN_WARNING("Artificial unit recognized. Purchase canceled."))
		else
			currently_vending = product
			if (!vendor_account || vendor_account.suspended)
				status_message = "This machine is currently unable to process payments due to problems with the associated account."
				status_error = TRUE
			else
				status_message = "Please swipe a card or insert cash to pay for the item."
				status_error = FALSE
		return TOPIC_REFRESH
	if (href_list["cancelpurchase"])
		currently_vending = null
		return TOPIC_REFRESH
	if (href_list["togglevoice"] && panel_open)
		shut_up = !shut_up
		return TOPIC_HANDLED


/obj/machinery/vending/get_req_access()
	if(!scan_id)
		return list()
	return ..()


/obj/machinery/vending/dismantle()
	var/obj/structure/vending_refill/dump = new (loc)
	dump.SetName("[dump.name] ([name])")
	dump.expected_type = base_type || type
	for (var/datum/stored_items/vending_products/product in product_records)
		product.migrate(dump)
	dump.product_records = product_records
	product_records = null
	return ..()


/obj/machinery/vending/proc/attempt_to_stock(obj/item/item, mob/living/user)
	for (var/datum/stored_items/vending_products/product in product_records)
		if (item.type == product.item_path)
			stock(item, product, user)
			return TRUE


/obj/machinery/vending/proc/pay_with_cash(obj/item/spacecash/bundle/cash)
	if (currently_vending.price > cash.worth)
		to_chat(usr, "[icon2html(cash, usr)] [SPAN_WARNING("That is not enough money.")]")
		return FALSE
	visible_message(SPAN_INFO("\The [usr] inserts some cash into \the [src]."))
	cash.worth -= currently_vending.price
	if (cash.worth <= 0)
		qdel(cash)
	else
		cash.update_icon()
	credit_purchase("(cash)")
	return TRUE


/obj/machinery/vending/proc/pay_with_ewallet(obj/item/spacecash/ewallet/ewallet)
	visible_message(SPAN_INFO("\The [usr] swipes \the [ewallet] through \the [src]."))
	if (currently_vending.price > ewallet.worth)
		status_message = "Insufficient funds on chargecard."
		status_error = TRUE
		return FALSE
	ewallet.worth -= currently_vending.price
	credit_purchase("[ewallet.owner_name] (chargecard)")
	return TRUE


/obj/machinery/vending/proc/pay_with_card(obj/item/card/id/id, obj/item/item)
	if (id == item || isnull(item))
		visible_message(SPAN_INFO("\The [usr] swipes \the [id] through \the [src]."))
	else
		visible_message(SPAN_INFO("\The [usr] swipes \the [item] through \the [src]."))
	var/datum/money_account/customer_account = get_account(id.associated_account_number)
	if (!customer_account)
		status_message = "Error: Unable to access account. Please contact technical support if problem persists."
		status_error = TRUE
		return FALSE
	if (customer_account.suspended)
		status_message = "Unable to access account: account suspended."
		status_error = TRUE
		return FALSE
	if (customer_account.security_level)
		var/response = input("Enter pin code", "Vendor transaction") as null | num
		if (isnull(response) || !Adjacent(usr) || usr.incapacitated())
			status_message = "User cancelled transaction."
			status_error = FALSE
			return FALSE
		customer_account = attempt_account_access(id.associated_account_number, response, 2)
		if (!customer_account)
			status_message = "Unable to access account: incorrect credentials."
			status_error = TRUE
			return FALSE
	if (currently_vending.price > customer_account.money)
		status_message = "Insufficient funds in account."
		status_error = TRUE
		return FALSE
	customer_account.transfer(vendor_account, currently_vending.price, "Purchase of [currently_vending.item_name]")
	return TRUE


/obj/machinery/vending/proc/credit_purchase(target)
	vendor_account.deposit(currently_vending.price, "Purchase of [currently_vending.item_name]", target)


/obj/machinery/vending/proc/vend(datum/stored_items/vending_products/product, mob/user)
	if (scan_id && !emagged && !allowed(user))
		to_chat(user, SPAN_WARNING("Access denied."))
		flick(icon_deny, src)
		return
	vend_ready = FALSE
	status_message = "Vending..."
	status_error = FALSE
	SSnano.update_uis(src)
	update_icon()
	if (product.category & VENDOR_CATEGORY_COIN)
		if(!coin)
			to_chat(user, SPAN_NOTICE("You need to insert a coin to get this item."))
			return
		if(!isnull(coin.string_color))
			if(prob(50))
				to_chat(user, SPAN_NOTICE("You successfully pull the coin out before \the [src] could swallow it."))
			else
				to_chat(user, SPAN_NOTICE("You weren't able to pull the coin out fast enough, the machine ate it, string and all."))
				qdel(coin)
				coin = null
				UpdateShowPremium(FALSE)
		else
			qdel(coin)
			coin = null
			UpdateShowPremium(FALSE)
	if (vend_reply && (last_reply + 20 SECONDS) <= world.time)
		spawn(0)
			speak(vend_reply)
			last_reply = world.time
	use_power_oneoff(vend_power_usage)
	if (icon_vend)
		flick(icon_vend, src)
	spawn(1 SECOND)
		product.get_product(get_turf(src))
		visible_message("\The [src] clunks as it vends \the [product.item_name].")
		playsound(src, 'sound/machines/vending_machine.ogg', 25, 1)
		if (prob(1))
			sleep(3)
			if (product.get_product(get_turf(src)))
				visible_message(SPAN_NOTICE("\The [src] clunks as it vends an additional [product.item_name]."))
		status_message = ""
		status_error = FALSE
		vend_ready = TRUE
		update_icon()
		currently_vending = null
		SSnano.update_uis(src)


/obj/machinery/vending/proc/stock(obj/item/item, datum/stored_items/vending_products/stored, mob/living/user)
	if (!user.unEquip(item))
		return
	if (stored.add_product(item))
		to_chat(user, SPAN_NOTICE("You insert \the [item] into \the [src]."))
		SSnano.update_uis(src)
		return TRUE
	SSnano.update_uis(src)


/obj/machinery/vending/proc/speak(message)
	if (!is_powered())
		return
	if (!message)
		return
	audible_message(SPAN_CLASS("game say", "[SPAN_CLASS("name", "\The [src]")] beeps, \"[message]\""))
	return


/obj/machinery/vending/proc/malfunction()
	for (var/datum/stored_items/vending_products/product in shuffle(product_records))
		if (product.category == VENDOR_CATEGORY_ANTAG)
			continue
		while (product.get_amount() > 0)
			product.get_product(loc)
		break
	set_broken(TRUE)


/obj/machinery/vending/proc/throw_item()
	var/mob/living/target = locate() in view(7, src)
	if (!target)
		return FALSE
	var/obj/item/throw_item
	for (var/datum/stored_items/vending_products/product in shuffle(product_records))
		if (product.category == VENDOR_CATEGORY_ANTAG)
			continue
		throw_item = product.get_product(loc)
		if (throw_item)
			break
	if (!throw_item)
		return FALSE
	spawn(0)
		throw_item.throw_at(target, rand(1,2), 3)
	visible_message(SPAN_WARNING("\The [src] launches \a [throw_item] at \the [target]!"))
	return TRUE


/obj/machinery/vending/proc/build_inventory(populate_parts)
	var/list/all_products = list(
		list(products, VENDOR_CATEGORY_NORMAL),
		list(contraband, VENDOR_CATEGORY_HIDDEN),
		list(premium, VENDOR_CATEGORY_COIN),
		list(antag, VENDOR_CATEGORY_ANTAG)
	)
	for (var/list/current_list in all_products)
		var/category = current_list[2]
		for (var/entry in current_list[1])
			var/datum/stored_items/vending_products/product = new/datum/stored_items/vending_products(src, entry)
			product.price = (entry in prices) ? prices[entry] : 0
			product.rarity = (entry in rare_products) ? rare_products[entry] : 100
			product.category = category
			if (populate_parts)
				product.amount = current_list[1][entry]
				if (!product.amount && product.rarity < 100 && product.category != VENDOR_CATEGORY_ANTAG)
					product.amount = prob(product.rarity) * rand(1,ceil(product.rarity/10))
				if (!product.amount && product.category == VENDOR_CATEGORY_ANTAG)
					product.amount = prob(product.rarity) * ceil(rand(1,antagrandom)) //Either 0 or 1 of a rare antag product, for balance purposes. Exception if antagrandom is redefined from default of 1.
				if (!product.amount && product.rarity == 100)
					product.amount = rand(minrandom,maxrandom)
			if (colored_entries)
				if (product.category == VENDOR_CATEGORY_NORMAL && product.rarity < 100)
					product.display_color = COLOR_GOLD
				if (product.category == VENDOR_CATEGORY_HIDDEN)
					product.display_color = COLOR_DARK_ORANGE
				if (product.category == VENDOR_CATEGORY_COIN)
					product.display_color = COLOR_LIME
				if (product.category == VENDOR_CATEGORY_ANTAG)
					product.display_color = COLOR_RED
			product_records.Add(product)


/obj/machinery/vending/proc/IsShowingProducts()
	return HAS_FLAGS(vendor_flags, VENDOR_CATEGORY_NORMAL)


/// Update whether the vendor should show the normal products category, flipping if null.
/obj/machinery/vending/proc/UpdateShowProducts(show)
	if (isnull(show))
		FLIP_FLAGS(vendor_flags, VENDOR_CATEGORY_NORMAL)
	else if (show)
		SET_FLAGS(vendor_flags, VENDOR_CATEGORY_NORMAL)
	else
		CLEAR_FLAGS(vendor_flags, VENDOR_CATEGORY_NORMAL)


/obj/machinery/vending/proc/IsShowingContraband()
	return HAS_FLAGS(vendor_flags, VENDOR_CATEGORY_HIDDEN)


/// Update whether the vendor should show the contraband category, flipping if null.
/obj/machinery/vending/proc/UpdateShowContraband(show)
	if (isnull(show))
		FLIP_FLAGS(vendor_flags, VENDOR_CATEGORY_HIDDEN)
	else if (show)
		SET_FLAGS(vendor_flags, VENDOR_CATEGORY_HIDDEN)
	else
		CLEAR_FLAGS(vendor_flags, VENDOR_CATEGORY_HIDDEN)


/obj/machinery/vending/proc/IsShowingPremium()
	return HAS_FLAGS(vendor_flags, VENDOR_CATEGORY_COIN)


/// Update whether the vendor should show the premium category, flipping if null.
/obj/machinery/vending/proc/UpdateShowPremium(show)
	if (isnull(show))
		FLIP_FLAGS(vendor_flags, VENDOR_CATEGORY_COIN)
	else if (show)
		SET_FLAGS(vendor_flags, VENDOR_CATEGORY_COIN)
	else
		CLEAR_FLAGS(vendor_flags, VENDOR_CATEGORY_COIN)

/obj/machinery/vending/proc/IsShowingAntag()
	return HAS_FLAGS(vendor_flags, VENDOR_CATEGORY_ANTAG)


/// Update whether the vendor should show the antag category, flipping if null.
/obj/machinery/vending/proc/UpdateShowAntag(show)
	if (isnull(show))
		FLIP_FLAGS(vendor_flags, VENDOR_CATEGORY_ANTAG)
	else if (show)
		SET_FLAGS(vendor_flags, VENDOR_CATEGORY_ANTAG)
	else
		CLEAR_FLAGS(vendor_flags, VENDOR_CATEGORY_ANTAG)
