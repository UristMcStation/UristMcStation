/*
// Most if not all factions will trade resources with allies, neutrals, or even less-hated enemies.
*/

// Magic expression for randomizing how much Need we want to get from a deal
// Macro'd just to avoid maintaining the same expression in multiple places.
#define RANDOMIZED_NEED_DELTA (rand(4, 12) * (NEED_MAXIMUM / 40))

// Magic expression for randomizing how much we want to *profit* from a deal
// Macro'd just to avoid maintaining the same expression in multiple places.
#define RANDOMIZED_PROFITABILITY_FACTOR (rand(NEED_MAXIMUM / 100, NEED_MAXIMUM / 20) / NEED_MAXIMUM)


/datum/utility_ai/proc/AcceptTradeOffer(var/datum/ActionTracker/tracker, var/input)
	if(isnull(tracker))
		return

	if(tracker.IsStopped())
		return

	var/datum/trade_offer/offer = input

	if(!istype(offer))
		GOAI_LOG_ERROR("AcceptTradeOffer ([src]): Invalid offer type for offer object [NULL_TO_TEXT(offer)]!")
		tracker.SetFailed()
		return

	var/ai_pawn = src.GetPawn()  // usually a faction, though COULD be a mob too

	if(isnull(ai_pawn))
		GOAI_LOG_ERROR("AcceptTradeOffer ([src]): Does not have a pawn ([NULL_TO_TEXT(ai_pawn)]).")
		tracker.SetFailed()
		return

	var/datum/trade_contract/contract = offer.ToContract(ai_pawn)
	GOAI_BRAIN_ADD_CONTRACT(src.brain, contract)

	TRADE_DEBUG_LOG("ACCEPTED a deal for [offer.commodity_key] * [offer.commodity_amount]u @ [offer.cash_value]$")

	var/unit_price = (abs(offer.cash_value) / abs(offer.commodity_amount))
	SET_PRICE_POINT(offer.commodity_key, unit_price)

	tracker.SetDone()
	return


/datum/utility_ai/proc/CreateSellOfferForNeed(var/datum/ActionTracker/tracker, var/input)
	if(isnull(tracker))
		return

	var/need_key = input
	if(!need_key)
		return

	var/datum/brain/ai_brain = src.brain

	if(!istype(ai_brain))
		GOAI_LOG_ERROR("CreateSellOfferForNeed: object [ai_brain] is not a brain!")
		tracker.SetFailed()
		return

	// How high our 'sacrificed' need is rn
	var/curr_need = ai_brain.GetNeed(need_key, null)

	if(isnull(curr_need))
		GOAI_LOG_ERROR("CreateSellOfferForNeed: need_key [need_key] value is null!")
		tracker.SetFailed()
		return

	// What are we willing to sell to sacrifice that need
	var/commodity = src.GetBestSaleCommodityForNeed(need_key)

	if(isnull(commodity))
		GOAI_LOG_ERROR("ERROR: CreateSellOfferForNeed: [src.name] Commodity for [need_key] is null ([commodity])")
		tracker.SetFailed()
		return

	/*
	// Shipping cost
	// This isn't just simulationism - having it stops AIs from making tiny-volume, low-value trades.
	// The cost scales with log-volume, to represent 'weight classes' of carriers having associated cost.
	var/raw_shipment_volume_class = FLOOR(log(10, (max(2, abs(raw_trade_amount)) - 1)))
	var/shipment_volume_class = 1 + raw_shipment_volume_class

	// Roughly, a carrier charges 20$ per 10u shipments, 200$ for 100u, and so on.
	var/shipping_cost = -4 * (10 ** shipment_volume_class)
	*/
	var/shipping_cost = 0

	// This is part of the 'floor' for minimum volumes, effectively minimum local money-velocity.
	// We will calibrate our trade volumes so that at least this much money *changes hands*.
	// This prevents the AI from making a ton of junk trades that are both low-volume and low-value.
	// TODO: This should likely be a Personality factor.
	var/effort_cost = 100

	// How much money we got
	var/curr_wealth = ai_brain.GetNeed(NEED_WEALTH, 0)

	// How much money needs to change hands for us to even bother trading, converted to Utils
	var/min_trade_utility = GetMoneyDesirability((effort_cost + shipping_cost), (curr_wealth - shipping_cost))

	// ...converted into what it would be as a need delta
	var/min_viable_need_delta = GetUtilityAsNeedDelta(min_trade_utility, need_key, curr_need)
	GOAI_LOG_DEBUG("CreateSellOfferForNeed: [src.name] - min_trade_utility is [min_trade_utility], min_viable_need_delta is [min_viable_need_delta], curr_need is [curr_need]")

	var/need_safety_margin = 15

	if((min_viable_need_delta + need_safety_margin) >= curr_need)
		// Can't afford it without putting ourselves in danger!
		GOAI_LOG_DEBUG("CreateSellOfferForNeed: Cannot safely offer [need_key] - Need is [curr_need], min delta is [min_viable_need_delta] + margin [need_safety_margin]")
		tracker.SetFailed()
		return

	// we'll need this in a couple of places, so caching it here
	var/double_safety_margin = 2 * need_safety_margin

	// How much of our Need-satisfaction we're willing to sacrifice
	var/safe_sacrifice_span = (curr_need < double_safety_margin) ? (curr_need / 2) : (curr_need - double_safety_margin)

	var/rand_delta = rand() * safe_sacrifice_span

	// We know both values are safe; pick a random one in between, but no less than the minimum viable
	var/need_delta_total = -max(min_viable_need_delta, rand_delta)

	// If we can sell more than minimum, go for it
	GOAI_LOG_DEBUG("CreateSellOfferForNeed: [src.name] - need_delta_total is [need_delta_total], rand factor is [rand_delta], min factor is [min_viable_need_delta], curr_need is [curr_need]")

	if(need_delta_total > 0)
		// Would put us in danger (or some code went rogue), abort!
		tracker.SetFailed()
		return

	// ...converted into units of the Commodity
	var/raw_trade_amount = src.GetCommodityAmountForNeedDelta(commodity, need_key, need_delta_total)  // should usually return a negative value!

	if(isnull(raw_trade_amount))
		GOAI_LOG_ERROR("ERROR: CreateSellOfferForNeed: [src.name] Commodity raw_trade_amount for [need_key] is [NULL_TO_TEXT(raw_trade_amount)]")
		tracker.SetFailed()
		return

	// How much Utility we lose from the trade if we didn't get paid
	var/tradeoff_utility_loss = src.GetCommodityDesirability(commodity, raw_trade_amount, shipping_cost)

	// Same, but (estimated) loss for abstract market
	MARKET_UTILITIES_TABLE_LAZY_INIT(TRUE)
	var/market_utility_loss = src.GetCommodityDesirability(commodity, raw_trade_amount, shipping_cost, null, GOAI_LIBBED_GLOB_ATTR(reference_market_utilities))

	// We take the higher of the two Utility losses, so that
	// if we in particular care less about a good but know it's good, we value it higher,
	// and if we care MORE we're willing to overpay to get it ASAP.
	var/resolved_utility_loss = max(market_utility_loss, tradeoff_utility_loss)

	//var/resolved_utility_loss = tradeoff_utility_loss

	// How much profit we want to take on top of a Utility-fair trade
	var/profitability_factor = RANDOMIZED_PROFITABILITY_FACTOR

	// How much do we want to play with (i.e. excluding a reserve)
	var/safe_wealth = (curr_wealth * (1 - profitability_factor))

	// Just totalling the factors for auditability
	var/total_pricing_utility = resolved_utility_loss - profitability_factor

	// How much we want for this deal
	var/raw_asking_price = src.GetMoneyForNeedUtility(total_pricing_utility, safe_wealth)

	if(isnull(raw_asking_price))
		GOAI_LOG_ERROR("ERROR: CreateSellOfferForNeed: [src.name] Commodity raw_asking_price for [total_pricing_utility] is [NULL_TO_TEXT(raw_asking_price)]")
		tracker.SetFailed()
		return

	// How long do we want to keep this open
	// Generally, this should be lower if we are desperate (because we are offering deals that are quite bad for us).
	// This is const'd right now, but might have some randomness or w/e, plus we can audit it better in a variable.
	var/expiry_time = EXPIRY_TIME_SLOW

	// NOTE: The source on the contract will be the Pawn, so Faction datum for faction AIs or a mob for mob AIs.
	//       This separates concerns - other AIs only care about how much they like the mob/faction and don't have
	//         to know whether they are dealing with an NPC, a PC, or a completely abstract entity.
	var/source_entity = src.pawn

	// We need to flip the signs to represent the values on the receiver side
	// (e.g. if we are selling 5u == -5u for us, the receiver is GETTING +5u)
	var/trade_amount = -raw_trade_amount

	var/abs_asking_price = CEIL(max(1, abs(raw_asking_price)))
	var/asking_price = abs_asking_price

	// Check last trade value and adjust asking price if needed
	PRICEPOINTS_TABLE_LAZY_INIT(TRUE)
	var/raw_last_trade_price = GET_PRICE_POINT(commodity)

	if(!isnull(raw_last_trade_price))
		var/abs_last_trade_price = abs(raw_last_trade_price) * raw_trade_amount
		var/price_delta = (abs_last_trade_price - abs_asking_price)

		if(price_delta > 0)
			// If the market can tolerate a higher price than we'd naively guess, adjust the price up.
			// Note the naive value is a hard minimum, we will NOT accept a deal below this value ever.
			// We'll smooth the difference; this is randomized but guaranteed to be between 30% and 90% of the delta
			var/market_smoothing_factor = 0.3 + (0.6 * rand())
			var/market_smoothing_amt = (market_smoothing_factor * price_delta)
			asking_price = (abs_asking_price + market_smoothing_amt)

	// reapply the correct sign to the absolute value
	asking_price = asking_price * (raw_asking_price < 0 ? -1 : 1)

	var/datum/trade_offer/sell_offer = new(source_entity, commodity, trade_amount, asking_price, world.time + expiry_time)
	REGISTER_OFFER_TO_MARKETPLACE(sell_offer)
	GOAI_BRAIN_ADD_OFFER(ai_brain, sell_offer.id)

	tracker.SetDone()

	TRADE_DEBUG_LOG("CreateSellOfferForNeed: [src.name] created new Sell offer for [commodity] @ [trade_amount]u | [asking_price]$")
	return sell_offer


/datum/utility_ai/proc/CreateBuyOfferForNeed(var/datum/ActionTracker/tracker, var/input)
	if(isnull(tracker))
		return

	var/need_key = input
	if(!need_key)
		return

	var/datum/brain/ai_brain = src.brain

	if(!istype(ai_brain))
		GOAI_LOG_ERROR("CreateBuyOfferForNeed: object [ai_brain] is not a brain!")
		tracker.SetFailed()
		return

	// How high our 'acquired' need is rn
	var/curr_need = ai_brain.GetNeed(need_key, null)

	if(isnull(curr_need))
		GOAI_LOG_ERROR("CreateBuyOfferForNeed: need_key [need_key] value is null!")
		tracker.SetFailed()
		return

	// How much of our Need-satisfaction we're trying to get
	var/need_delta_total = min(NEED_MAXIMUM - curr_need, RANDOMIZED_NEED_DELTA)

	if(need_delta_total < 0)
		// Would put us in danger (or some code went rogue), abort!
		tracker.SetFailed()
		return

	// This is a bit tricky.
	// We split our buys into a pair of equal-volume offers, 'Fast' and 'Slow'
	//
	// The Fast buy offer is a worse deal for us money-wise, but satisfies our urgent needs.
	// The Slow buy offer is a better deal, but less enticing to sellers.
	//
	// As such, the Fast buy has a short time-to-live - we don't want to float
	//   offers made in desperation if we are no longer desperate, and we expect
	//   the offer to either clear quickly or get withdrawn by us quickly.
	//
	// Conversely the Slow buy has a long TTL, because it's a trade we can stand by.
	//   Either we find someone distressed willing to take it immediately and get a good deal,
	//   or we can wait until someone does is happy with out terms later.
	//
	// This way, we ensure both our urgent needs are attended to, but also get good
	//   'stretch goal' deals out there to take advantage of distressed sellers.
	var/half_need_delta = need_delta_total / 2

	// How much money we got
	var/curr_wealth = (max(0, ai_brain.GetNeed(NEED_WEALTH, 0)) * 0.75)

	// How much profit we want to take on top of a Utility-fair trade
	var/profitability_factor = RANDOMIZED_PROFITABILITY_FACTOR

	// How much do we want to play with (i.e. excluding a reserve)
	var/safe_wealth = (curr_wealth * (1 - profitability_factor))

	var/need_price = src.GetMoneyForNeedUtility(half_need_delta - profitability_factor, safe_wealth)

	if((need_price <= 0) || (need_price >= PLUS_INF))
		// Invalid deal, we shouldn't have gotten here
		tracker.SetFailed()
		return

	// Find the best Thing we can buy to satisfy this need
	var/commodity = src.GetBestPurchaseCommodityForNeed(need_key)

	if(isnull(commodity))
		GOAI_LOG_ERROR("ERROR: CreateBuyOfferForNeed: [src.name] Commodity for [need_key] is [NULL_TO_TEXT(commodity)]")
		tracker.SetFailed()
		return

	var/frac_need = ((NEED_MAXIMUM - curr_need) / NEED_MAXIMUM) * 50
	var/do_fast_offer = prob(frac_need)

	// How much we offer for this deal; if null - not doing this bid
	var/bid_price_fast = null
	var/bid_price_slow = null

	// Check last trade value and adjust asking price if needed
	PRICEPOINTS_TABLE_LAZY_INIT(TRUE)
	var/raw_last_trade_unit_price = GET_PRICE_POINT(commodity)
	var/abs_last_trade_unit_price = null

	var/raw_fast_trade_amount

	if(do_fast_offer)
		// Find HOW MUCH of said Thing we ideally want to buy
		raw_fast_trade_amount = src.GetCommodityAmountForNeedDelta(commodity, need_key, half_need_delta)  // should usually return a positive value!

		if(GOAI_LIBBED_GLOB_ATTR(assetneeds_assets_totals_table))
			var/market_size_for_commodity = GOAI_LIBBED_GLOB_ATTR(assetneeds_assets_totals_table)[commodity]
			if(market_size_for_commodity)
				// we'll limit buys to 75% of the market to leave some headroom
				var/safe_market_trade_amount = round(market_size_for_commodity * 0.75)
				raw_fast_trade_amount = min(raw_fast_trade_amount, safe_market_trade_amount)

		// clamp to money we actually HAVE
		bid_price_fast = min(need_price, safe_wealth)

		if(!isnull(raw_last_trade_unit_price))
			abs_last_trade_unit_price = abs(raw_last_trade_unit_price)

		if(!isnull(abs_last_trade_unit_price))
			var/abs_last_trade_total_price = abs_last_trade_unit_price * raw_fast_trade_amount
			var/abs_bid_price_fast = CEIL(max(1, abs(bid_price_fast)))
			var/price_delta_fast = (abs_bid_price_fast - abs_last_trade_total_price)

			if(price_delta_fast > 0)
				// If the market can tolerate a lower price than we'd naively guess, adjust the price down.
				// Note the naive value is a hard maximum, we will NOT accept a deal above this value, ever.
				// We'll smooth the difference; this is randomized but guaranteed to be between 60% and 90% of the delta
				var/market_smoothing_factor = 0.6 + (0.3 * rand())
				var/market_smoothing_amt = (market_smoothing_factor * price_delta_fast)
				bid_price_fast = (abs_bid_price_fast - market_smoothing_amt)

	var/remaining_cash = safe_wealth

	if(bid_price_fast)
		remaining_cash = (curr_wealth - bid_price_fast)

	if(remaining_cash > 0)
		bid_price_slow = min(remaining_cash, src.GetMoneyForNeedUtility(half_need_delta - profitability_factor, remaining_cash))

	var/source_entity = src.pawn

	if(!isnull(bid_price_fast))
		var/fast_trade_amount = -raw_fast_trade_amount
		var/expiry_time_fast = EXPIRY_TIME_FAST
		var/datum/trade_offer/buy_offer_fast = new(source_entity, commodity, fast_trade_amount, bid_price_fast, world.time + expiry_time_fast)
		REGISTER_OFFER_TO_MARKETPLACE(buy_offer_fast)
		GOAI_BRAIN_ADD_OFFER(ai_brain, buy_offer_fast.id)
		TRADE_DEBUG_LOG("CreateBuyOfferForNeed: [src.name] created new fast Buy offer for [commodity] @ [fast_trade_amount]u | [bid_price_fast]$ @Time:[world.time]")

	if(!isnull(bid_price_slow))
		// all the same steps, except assume the fast trade has been 'applied' and extend the timeout
		var/raw_slow_trade_amount = src.GetCommodityAmountForNeedDelta(commodity, need_key, curr_need + half_need_delta)  // should usually return a positive value!

		if(GOAI_LIBBED_GLOB_ATTR(assetneeds_assets_totals_table))
			// TODO: if the market size is WAY too small for us to bother, just... don't
			var/market_size_for_commodity = GOAI_LIBBED_GLOB_ATTR(assetneeds_assets_totals_table)[commodity]
			if(market_size_for_commodity)
				// we'll limit buys to 75% of the market to leave some headroom
				var/safe_market_trade_amount = round(market_size_for_commodity * 0.75)
				raw_slow_trade_amount = min(raw_slow_trade_amount, safe_market_trade_amount)

		if(!isnull(abs_last_trade_unit_price))
			var/abs_bid_price_slow = CEIL(max(1, abs(bid_price_slow)))
			var/abs_last_trade_total_price_slow = abs_last_trade_unit_price * raw_slow_trade_amount
			var/price_delta_slow = (abs_bid_price_slow - abs_last_trade_total_price_slow)

			if(price_delta_slow > 0)
				// Same as for fast, just re-do it
				var/market_smoothing_factor = 0.3 + (0.6 * rand())
				var/market_smoothing_amt = (market_smoothing_factor * price_delta_slow)
				bid_price_slow = (abs_bid_price_slow - market_smoothing_amt)

		var/slow_trade_amount = -raw_slow_trade_amount
		var/expiry_time_slow = EXPIRY_TIME_SLOW
		var/datum/trade_offer/buy_offer_slow = new(source_entity, commodity, slow_trade_amount, bid_price_slow, world.time + expiry_time_slow)
		REGISTER_OFFER_TO_MARKETPLACE(buy_offer_slow)
		GOAI_BRAIN_ADD_OFFER(ai_brain, buy_offer_slow.id)
		TRADE_DEBUG_LOG("CreateBuyOfferForNeed: [src.name] created new slow Buy offer for [commodity] @ [slow_trade_amount]u | [bid_price_slow]$ @Time:[world.time]")

	tracker.SetDone()

	return


/datum/utility_ai/proc/ContractDispatchInstant(var/datum/ActionTracker/tracker, var/input)
	/* ATTEMPTS to fulfil the terms of a Contract on our part.
	// If we are buying, send the cash; if we are selling, send the goods, etc.
	// (there are weird cases where we send BOTH or NEITHER).
	*/

	if(isnull(tracker))
		return

	if(tracker.IsStopped())
		return

	var/datum/trade_contract/contract = input

	if(!istype(contract))
		GOAI_LOG_ERROR("ContractDispatchInstant ([src]): Invalid offer type for contract object [NULL_TO_TEXT(contract)]!")
		tracker.SetFailed()
		return

	if(!(contract.is_open))
		GOAI_LOG_DEBUG("ContractDispatchInstant ([src]): Contract [contract] is closed (expired or already fulfilled)!")
		tracker.SetFailed()
		return

	var/datum/ai_pawn = src.GetPawn()  // usually a faction, though COULD be a mob too

	if(!istype(ai_pawn))
		GOAI_LOG_ERROR("ContractDispatchInstant ([src]): Does not have a valid pawn ([NULL_TO_TEXT(ai_pawn)]).")
		tracker.SetFailed()
		return

	var/creator_is_seller = contract.commodity_amount > 0
	var/creator_is_payer = contract.cash_value < 0

	var/datum/creator_datum = contract.creator
	var/datum/contractor_datum = contract.receiver

	var/trade_volume = abs(contract.commodity_amount)
	var/cash_volume = abs(contract.cash_value)

	var/datum/goods_sender = (creator_is_seller ? contractor_datum : creator_datum)
	var/datum/money_sender = (creator_is_payer ? creator_datum : contractor_datum)

	var/we_send_goods = (goods_sender == ai_pawn)
	var/we_send_money = (money_sender == ai_pawn)

	ASSETS_TABLE_LAZY_INIT(TRUE)
	CREATE_ASSETS_TRACKER_IF_NEEDED((ai_pawn.global_id || ai_pawn.InitializeGlobalId()))

	if(we_send_goods)
		if(contract.EscrowPut(ai_pawn, contract.commodity_key, trade_volume))
			contract.lifecycle_state |= GOAI_CONTRACT_LIFECYCLE_GOODS_DELIVERED
		else
			tracker.SetFailed()
			GOAI_LOG_ERROR("FAILED to send goods for order [contract.commodity_key] * [contract.commodity_amount]u @ [contract.cash_value]$")
			return

	if(we_send_money)
		if(contract.EscrowPut(ai_pawn, NEED_WEALTH, cash_volume))
			contract.lifecycle_state |= GOAI_CONTRACT_LIFECYCLE_PAID
		else
			tracker.SetFailed()
			GOAI_LOG_ERROR("FAILED to send payment for order [contract.commodity_key] * [contract.commodity_amount]u @ [contract.cash_value]$")
			return

	contract.Signoff(ai_pawn)

	var/completed = FALSE

	if(contract.CheckFulfilled())
		if(GOAI_CONTRACT_IS_COMPLETED(contract.lifecycle_state, contract.progressed_state))
			completed = contract.Complete()

	if(completed)
		GOAI_LOG_DEBUG("COMPLETED a contract for [contract.commodity_key] * [contract.commodity_amount]u @ [contract.cash_value]$")
	else
		GOAI_LOG_DEBUG("FULFILLED an order for [contract.commodity_key] * [contract.commodity_amount]u @ [contract.cash_value]$")

	tracker.SetDone()
	return



/datum/utility_ai/proc/FulfillContractInstantBilateral(var/datum/ActionTracker/tracker, var/input)
	/*
	// Forces both parties of the trade to fulfill their obligations, sign-off and complete the contract (if possible).
	//
	// If any side cannot fulfill their end of the deal, they will do the best they can right now (i.e. transfer what they've got).
	// If that happens and the contract cannot be completed, it will simply be postponed to the next check (no success, no failure).
	//
	// Uses instant transfer of commodities and money (low simulation LOD).
	*/

	if(isnull(tracker))
		return

	if(tracker.IsStopped())
		return

	var/datum/trade_contract/contract = input

	if(!istype(contract))
		GOAI_LOG_ERROR("FulfillContractInstantBilateral ([src]): Invalid offer type for contract object [NULL_TO_TEXT(contract)]!")
		tracker.SetFailed()
		return

	if(!(contract.is_open))
		GOAI_LOG_ERROR("FulfillContractInstantBilateral ([src]): Contract [contract] is closed (expired or already fulfilled)!")
		tracker.SetFailed()
		return

	var/ai_pawn = src.GetPawn()  // usually a faction, though COULD be a mob too

	if(isnull(ai_pawn))
		GOAI_LOG_ERROR("FulfillContractInstantBilateral ([src]): Does not have a pawn ([NULL_TO_TEXT(ai_pawn)]).")
		tracker.SetFailed()
		return

	//var/first_attempt_time = tracker.BBSetDefault("First-Attempt-Time", world.time)

	var/creator_is_seller = contract.commodity_amount > 0
	var/creator_is_payer = contract.cash_value > 0

	var/datum/creator_datum = contract.creator
	var/datum/contractor_datum = contract.receiver

	var/datum/goods_sender = (creator_is_seller ? creator_datum : contractor_datum)
	var/datum/money_sender = (creator_is_payer ? creator_datum : contractor_datum)

	ASSETS_TABLE_LAZY_INIT(TRUE)
	CREATE_ASSETS_TRACKER_IF_NEEDED((creator_datum.global_id || creator_datum.InitializeGlobalId()))
	CREATE_ASSETS_TRACKER_IF_NEEDED((contractor_datum.global_id || contractor_datum.InitializeGlobalId()))

	// Supplier delivers, if they can
	var/goods_needed = contract.EscrowGetNeededAmt(contract.commodity_key)
	var/delivered = ((!goods_needed) || contract.EscrowPut(goods_sender, contract.commodity_key, goods_needed))

	// Payer pays, if they can
	var/cash_needed = contract.EscrowGetNeededAmt(NEED_WEALTH)
	var/paid = ((!cash_needed) || contract.EscrowPut(money_sender, NEED_WEALTH, cash_needed))

	if(delivered && paid)
		// Sign off
		contract.Signoff(contract.creator)
		contract.Signoff(contract.receiver)

		// Mark everything as delivered (instantly)
		contract.lifecycle_state |= GOAI_CONTRACT_LIFECYCLE_GOODS_DELIVERED
		contract.lifecycle_state |= GOAI_CONTRACT_LIFECYCLE_PAID

		// Should be completeable at this point
		var/completed = contract.Complete()

		if(completed)
			tracker.SetDone()
			TRADE_DEBUG_LOG("FULFILLED a contract for [contract.commodity_key] * [contract.commodity_amount]u @ [contract.cash_value]$")
		else
			tracker.SetFailed()
			TRADE_DEBUG_LOG("FAILED a contract for [contract.commodity_key] * [contract.commodity_amount]u @ [contract.cash_value]$")

	else
		TRADE_DEBUG_LOG_IF(!paid, "Payer [money_sender] could not pay for contract [contract].")
		TRADE_DEBUG_LOG_IF(!delivered, "Supplier [goods_sender] could not provide goods for contract [contract].")

		var/failures = tracker.BBSetDefault("CouldNotDeliver", 1)
		tracker.BBSet("CouldNotDeliver", failures + 1)

		/*
		var/first_failed = tracker.BBSetDefault("FirstFailureTime", world.time)
		var/last_failed = tracker.BBGet("LastFailureTime", world.time)
		tracker.BBSet("LastFailureTime", world.time)
		*/

		if(failures >= 2)
			tracker.SetFailed()
			GOAI_LOG_DEBUG("Contract [contract] could not be fulfilled after max tries - cancelling.")
			contract.Expire()
			return

		if(failures > 1)
			tracker.SetFailed()
			GOAI_LOG_DEBUG("Contract [contract] could not be fulfilled right now.")
			return


	return
