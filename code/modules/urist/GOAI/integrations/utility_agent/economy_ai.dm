/*
// Adds logic for handling trade stuff.
*/

# ifdef SHOW_GOAI_WIP_WARNINGS
#warn Restore the nulls for default procs here:
# endif
//#define DEFAULT_BUY_ITEM_PROC null
//#define DEFAULT_SELL_ITEM_PROC null

#define DEFAULT_BUY_ITEM_PROC  GLOBAL_PROC_REF(utility_best_trade_item_selector_personality_generic)
#define DEFAULT_SELL_ITEM_PROC GLOBAL_PROC_REF(utility_best_trade_item_selector_personality_generic)

#define APPROX_SQRT_TWO 1.41421

// Constants for conversions:
// scaling of the sin(arctan()) so it goes to 1 where we want:
#define ECONOMY_MONEY_TO_UTILS_MAGIC_NUMBER APPROX_SQRT_TWO

// Personality trait: how much liquidity does this AI want to maintain?
// This is not a *hard* limit, but spending above this will be heavily penalized
// and getting back up above the threshold again will be valued highly.
#define PERSONALITY_KEY_MONEY_RESERVE_GOAL "desired_cash_reserves"

/*
// UTILITY DELTA INTEGRATION
// This is a bit of tricky math. We want the AI to favour satisfying its needs,
// with priority to boosting low needs to survival levels over maximizing the high ones.
//
// The formulas were derived by specifying a function of how the Utility drops off with supply and
// calculating the indefinite integral of the raw function (and defining it as the _NEED_DELTA_UTILITY_INTEGRATION_POINT... macro)
//
// To calculate how much Utility we gain from going low-to-high, we calculate the definite integral between the start and end amounts.
// Practically speaking this is a simple difference between the value of the INTEGRATION_POINT macros at start and end.
//
// The quadratic formula below is well-behaved, but not necessarily the only viable function. It's cheap though!
*/
#define _NEED_DELTA_UTILITY_INTEGRATION_POINT_QUADRATIC(CD) ((3 * (CD) - (CD ** 2)) / 2)
#define INTEGRATE_NEED_DELTA_UTILITY_QUADRATIC(Pre, Post) ((_NEED_DELTA_UTILITY_INTEGRATION_POINT_QUADRATIC(Post) - _NEED_DELTA_UTILITY_INTEGRATION_POINT_QUADRATIC(Pre)))

// This is a family of curves developed later - it's even cheaper.
// Z is a smoothing constant that makes the curve less convex the higher it gets (at 0, it's a flat line at U=1)
#define INTEGRATE_NEED_DELTA_UTILITY_SMOOTHING(Pre, Post, Z) ((Z+1) * (Post - Pre) / (Post + Pre + Z))

// Reverse of INTEGRATE_NEED_DELTA_UTILITY_SMOOTHING - returns (Post - Pre) from that formula given Utils (output of the formula), and Post/Z as input earlier
#define REVERSE_INTEGRATE_NEED_DELTA_UTILITY_SMOOTHING_TO_DELTA(Utils, Post, Z) ((Utils * (2 * Post + Z)) / (Utils + Z + 1))

// Reverse of INTEGRATE_NEED_DELTA_UTILITY_SMOOTHING - returns pure Pre from that formula given Utils (output of the formula), and Post/Z as input earlier
#define REVERSE_INTEGRATE_NEED_DELTA_UTILITY_SMOOTHING_TO_AMOUNT(Utils, Post, Z) (Post - REVERSE_INTEGRATE_NEED_DELTA_UTILITY_SMOOTHING_TO_DELTA(Utils, Post, Z))

// Empirically a fairly sensible value, values getting the hell away from zero at all quite highly
// but remains reasonably enthusiastic about big jumps later on.
#define DELTA_UTILITY_SMOOTHING_DEFAULT_FACTOR 0.05


/datum/utility_ai
	/*
	// For flexibility, GetBestPurchaseCommodityForNeed()/GetBestSaleCommodityForNeed()
	// will be handled by call()-ing an arbitrary function proc specified on the object.
	// We'll pass the need_key, any class-bound kwargs lists, and the reference to the calling brain.
	//
	// That lets us avoid an unholy mess of inheritance hierarchies just for the sake of overriding these
	// and thereby creating some cursed graph of partial overrides.
	//
	// The procs are also unbound functions, so they should be easy to test,
	// especially if the logic does not depend on the calling brain's state.
	*/
	var/best_purchase_for_need_proc = DEFAULT_BUY_ITEM_PROC
	var/list/best_purchase_for_need_proc_args = null

	var/best_sale_for_need_proc = DEFAULT_SELL_ITEM_PROC
	var/list/best_sale_for_need_proc_args = null


/datum/utility_ai/proc/GetNeedDesirability(var/need, var/amount)
	// for now, we'll assume the Needs are given as percentages
	var/desirability = (amount / 100)
	desirability = clamp(desirability, 0, 1)
	return desirability


/datum/utility_ai/proc/GetNeedDeltaUtility(var/need, var/amt_pre, var/amt_post)
	/*
	// Calculates how much we value increasing the amount of Commodity from x1 to x2.
	//
	// For example, if we're at 50% Food and a Burger item increases our Food by 10%,
	//  what is our (subjective) value of the burger in utils?
	//
	// This value generally depends both on the quality of the item AND our current Need levels.
	//
	// If we're already 100% full, the Burger is worthless to us as a food item.
	// If we are at 0%, we will take anything we can get, but we still value the
	//  Burger at 10% as higher than a Candy at 1% all the rest being equal.
	//
	// As an API contract, if amt_pre >= amt_post, Utility should always be <= 0.
	*/

	// How happy we are with how much we've had
	var/pre_desirability = src.GetNeedDesirability(need, amt_pre)

	// How happy we are to be at the new amount
	var/post_desirability = src.GetNeedDesirability(need, amt_post)

	// How happy we are with the CHANGE.
	//
	// This is NOT NECESSARILY a simple difference,
	//  because the underlying function *is generally not linear*.
	//
	// In turn, this is because we care more about dealing with critically low needs;
	//  we'd rather stave off starvation by 5% than raise our comfort from 90% to 95%
	//
	// Instead, we calculate a simple definite integral with pre/post amounts as limits.
	//
	// All this is mentioned primarily for the benefit of maintainers playing with the curves.
	// If the math scares you, don't worry - the actual formula used will likely be very simple.

	// Potential TODO: replace the const convexity factor with a personality-derived value?
	var/smoothing_factor = DELTA_UTILITY_SMOOTHING_DEFAULT_FACTOR
	var/result = INTEGRATE_NEED_DELTA_UTILITY_SMOOTHING(pre_desirability, post_desirability, smoothing_factor)
	TRADE_DEBUG_LOG("GetNeedDeltaUtility: Need [need] [amt_pre]->[amt_post] ([pre_desirability] -> [post_desirability]): desirability [result]")

	return result


/datum/utility_ai/proc/GetUtilityAsNeedDelta(var/util_delta, var/need, var/curr_amt)
	/*
	// Inverse of GetNeedDeltaUtility()
	// Returns how much a given change in Utils corresponds to a change in Need%
	//
	*/

	// Potential TODO: replace the const convexity factor with a personality-derived value?
	var/smoothing_factor = DELTA_UTILITY_SMOOTHING_DEFAULT_FACTOR
	var/delta = REVERSE_INTEGRATE_NEED_DELTA_UTILITY_SMOOTHING_TO_DELTA(util_delta, curr_amt, smoothing_factor)
	TRADE_DEBUG_LOG("GetUtilityAsNeedDelta: Desirability [util_delta] corresponds to: Need [need] [delta]")

	return delta


/datum/utility_ai/proc/GetCommodityDesirability(var/commodity, var/amount, var/cash_value = 0, var/list/curr_need_level_overrides = null, var/list/need_weights_override = null)
	// Returns the Desirability of a Commodity
	//
	// Desirability of a Commodity is an aggregate of the integrated Desirability
	// of all Needs that we care about after the effect of the Commodity is applied.
	//
	// Practically speaking, what this means is:
	//   - we grab all Needs we care about
	//   - we check the deltas from the commodity
	//   - we calculate the Utility of (curr + delta) for each Need by integrating
	//   - we do a weighted average of this value as our true Utility/Desirability
	//
	// Args:
	// - commodity: The key of the traded item (corresponds to CommodityDB key)
	//
	// - amount: How much we're buying (selling if negative). Scales the needs' deltas.
	//
	// - cash_value: How much money we're getting for the whole deal (i.e. not per unit).
	//               This is the equivalent of 'amount' above for a Cash quasi-commodity.
	//               This CAN be NEGATIVE, *independent* of the sign of 'amount' arg!
	//               Negative cash_value AND negative amount means we're paying someone to take our junk.
	//
	// - curr_need_level_overrides: By default, we consider our AI's CURRENT Needs for the calculations.
	//                              If you want to consider a different set of starting Needs, this assoc should
	//                              contain the Need keys and their initial values to use instead of the current.
	//
	//                              NOTE: any *missing* Need keys in the list WILL STILL BE READ FROM THE *CURRENT* VALUES.
	//
	// - need_weights_override: By default (on null), we consider our AI's Need Weights for the calculations.
	//                          If you want to look at a different set of Weights, pass them here.

	if(!amount)
		// broken or fairly pointless call, no value in trading nothing
		return null

	if(!istype(src.brain))
		return null

	/* STEP 1: Figure out what Needs we even care about */
	var/list/need_weights = need_weights_override // assoc[str, float]
	if(isnull(need_weights))
		need_weights = src.brain.GetNeedWeights()

	if(!need_weights)
		return 0 // vendor trash

	// How much this Commodity will shift the Needs we care about
	var/list/needs_commodity_deltas = list()

	var/list/need_values = GetCommodityNeedAllValuesAbstract(commodity)
	if(!need_values)
		return 0 // vendor trash

	// Account for the money side
	// We do it first, so we can insert the WEALTH need instead of upserting
	if(NEED_WEALTH in need_weights)
		needs_commodity_deltas[NEED_WEALTH] = cash_value

	/* STEP 2: Get deltas of all relevant Needs */
	for(var/need_key in need_weights)
		var/need_weight = need_weights[need_key]

		if(!need_weight)
			// skip zeros for speed
			// and nulls for validity
			continue

		var/raw_commodity_need_amt = need_values[need_key] || 0

		if(!raw_commodity_need_amt)
			// no point adding zeros to things
			continue

		// scale by trade volume
		var/commodity_need_amt = raw_commodity_need_amt * amount

		var/curr_stored_need = needs_commodity_deltas[need_key]
		if(isnull(curr_stored_need))
			// We only store deltas here, it's more efficient than fetching
			// the current values twice (for this and later for integration)
			curr_stored_need = 0

		needs_commodity_deltas[need_key] = curr_stored_need + commodity_need_amt

	/* STEP 3: Calculate the Utility of each applied delta */
	var/total = 0
	var/denom = 0

	for(var/posthoc_need_key in needs_commodity_deltas)
		// aggregate results
		var/need_weight = need_weights[posthoc_need_key]

		if(!need_weight)
			// skip zeros for speed
			// and nulls for validity
			continue

		// we may want to simulate certain needs as being different than they are RIGHT NOW for forecasting purposes:
		var/override_amt = curr_need_level_overrides?[posthoc_need_key]

		// starting point:
		var/curr_need_amt = DEFAULT_IF_NULL(DEFAULT_IF_NULL(override_amt, src.brain?.GetNeed(posthoc_need_key, null)), 0)

		// deltas:
		var/raw_post_need_amt = needs_commodity_deltas[posthoc_need_key]

		if(abs(raw_post_need_amt ) < 0.01)
			// ignore tiny amounts that would throw off the weights
			continue

		// actually apply the deltas to the current amount:
		var/true_post_need_amt = curr_need_amt + raw_post_need_amt

		if(true_post_need_amt < 0)
			// If any deal would take us below zero on any need, it's trash.
			TRADE_DEBUG_LOG("GetCommodityDesirability: Need [posthoc_need_key] [curr_need_amt]->[true_post_need_amt]: below zero, desirability -1")
			return -1

		// aggregate:
		var/desirability = 0

		if(posthoc_need_key == NEED_WEALTH)
			// special case; this need is 'open-ended', any increase is positive-valued
			// and the Utility is determined by a formula on the delta alone rather than an integration
			desirability = src.GetMoneyDesirability(raw_post_need_amt)
		else
			desirability = src.GetNeedDeltaUtility(posthoc_need_key, curr_need_amt, true_post_need_amt)

		// weight sum is the denominator in a weighted average later
		denom += need_weight

		// future numerator; we need to scale the values by weights or things would get silly
		total += (desirability * need_weight)

		TRADE_DEBUG_LOG("GetCommodityDesirability: Need [posthoc_need_key] [curr_need_amt]->[true_post_need_amt]: desirability [desirability] | total [total] / denominator [denom]")

	/* STEP 4: weighted average to get final value */
	if(!denom)
		// no division by zero!
		return 0

	var/commodity_desirability = total / denom

	/* STEP 5: PROFIT!!! */
	return commodity_desirability


/datum/utility_ai/proc/GetMoneyDesirability(var/amount, var/curr_wealth = null)
	/*
	// Returns how much we would value a CHANGE in the amount of money we have
	// (i.e. the marginal utility of money integrated over the proposed delta).
	*/

	var/wealth = DEFAULT_IF_NULL(DEFAULT_IF_NULL(curr_wealth, src.brain?.GetNeed(NEED_WEALTH, null)), 0)

	// Personality factor (PF) makes us loss-averse
	// The higher the factor (up to 1), the more loss-averse we are:
	//
	// - PF @1.00, we do not accept *ANY* losses, we hoard cash and have a swimming pool of gold coins.
	// - PF @0.75, we need to gain 20% to offset a loss of 5%
	// - PF @0.50, we need to gain 10% to offset a loss of 5% (a 10% gain has 50% Utility of a 10% loss)
	// - PF @0.00, the curve is symmetric - gaining 10% and losing 10% change the Utility by the same amount.
	//
	// Practically, instead of mucking about with it, we calculate it from desired cash reserves.
	// We calculate PF so that the AI will STRONGLY prefer to maintain a certain cash reserve and avoid spending it,
	// but it's also not a completely hard cutoff - we can dip into it for emergencies.
	var/personality_factor = 1

	if(amount < 0)
		var/raw_reserves_desired = src.brain?.personality?[PERSONALITY_KEY_MONEY_RESERVE_GOAL]

		if(isnull(raw_reserves_desired))
			// default; TODO constify this
			raw_reserves_desired = 1000

		// Numerical safety against bad inputs
		var/reserves_desired = min(raw_reserves_desired, 1)

		var/power_value = -log(2, (max(reserves_desired, wealth) / reserves_desired))

		// Negatives override the Personality factor
		personality_factor = 1 - (2 ** power_value)

	var/numerator = amount / (wealth + 1)
	var/denom = personality_factor

	// This is a fairly arbitrary constant picked to rescale results to a nicer range.
	// Specifically, it was designed so that:
	// A) amount == +current => +1 (...ish)
	// B) amount == -current => -1 (...ish)
	// C) the left and right limits of the value are manageable (they converge to this exact value)
	var/magic_num = ECONOMY_MONEY_TO_UTILS_MAGIC_NUMBER

	// TODO: This should be more sophisticated and track how much reserves we have vs. how much we want.
	var/raw_fraction = (numerator / denom)

	// Q: Why the hell is arctan() and sin() here?
	// A1: arctan() is a nice sigmoidal function that is quite cheap (it's often a table lookup),
	//     which happens to be the kind of shape we need for diminishing returns.
	var/as_arctan = arctan(raw_fraction)

	// A2: ...but BYOND's arctan() returns degrees, not radians; the sin() deals with that.
	var/money_preference = sin(as_arctan) * magic_num

	return money_preference


/datum/utility_ai/proc/GetMoneyForNeedUtility(var/utility, var/curr_wealth = null)
	/* This is effectively an inverse of GetMoneyDesirability(Amt).
	//
	// GetMoneyDesirability(Amt) takes in Amt$ and returns U Utils for that gain/loss of money.
	// GetMoneyForNeedUtility(U) takes in the U Utils and returns the corresponding Amt$.
	//
	// The two procs constitute a near-isomorphism between Utility and Money, i.e.:
	// 1) GetMoneyDesirability(GetMoneyForNeedUtility(x)) == x
	// 2) GetMoneyForNeedUtility(GetMoneyDesirability(y)) == y
	//
	// This can be used to find the Minimum Acceptable Commodity Price (MACP) for trading any Commodity.
	//
	// MACP(C, A) = GetMoneyForNeedUtility(GetCommodityDesirability(C, A, 0))
	//
	// The return value can be used as input for TradeOffer cash_amount directly raw,
	// as it is expressed from the point of view of the counterparty taking the deal.
	*/
	var/wealth = DEFAULT_IF_NULL(DEFAULT_IF_NULL(curr_wealth, src.brain?.GetNeed(NEED_WEALTH, null)), 0)

	// We scale UP by this in GetMoneyDesirability(), so need to scale DOWN here.
	var/downscaled_utils = utility / ECONOMY_MONEY_TO_UTILS_MAGIC_NUMBER

	var/personality_factor = 1

	if(utility < 0)
		var/raw_reserves_desired = src.brain?.personality?[PERSONALITY_KEY_MONEY_RESERVE_GOAL]

		if(isnull(raw_reserves_desired))
			// default; TODO constify this
			raw_reserves_desired = 1000

		// Numerical safety against bad inputs
		var/reserves_desired = min(raw_reserves_desired, 1)

		var/power_value = -log(2, (max(reserves_desired, wealth) / reserves_desired))

		// Negatives override the Personality factor
		personality_factor = 1 - (2 ** power_value)

	var/basis = downscaled_utils * personality_factor

	// We'll shortly apply arcsin() on this.
	// arcsin() goes crazy at +/- 1 because that's the limit of its domain.
	// We'll return an appropriate infinity beyond this point.
	//
	// That return value should be interpreted as 'take all my money' for buying
	// and 'more than you could possibly ever offer' for selling.

	if(basis <= -1)
		// discard this offer
		return PLUS_INF

	if(basis >= 1)
		// desperation, will buy at any price
		return wealth

	var/as_angle = arcsin(basis)
	var/angle_to_tan = tan(as_angle)

	var/breakeven_money_value = angle_to_tan * wealth

	// This is the break-even price, expressed as cash_amt for the *COUNTERPARTY*
	// (i.e. the SELLER if we are BUYING, or the BUYER if we are SELLING).
	//
	// This means this deal is fair but unprofitable to us.
	// If you want to ensure profit, there's a couple of different ways of doing this.
	// They all boil down to padding out the values at input or output,
	// either additively or multiplicatively.
	//
	// However, the approach I would recommend is ADDING a certain amount to the INPUT Utility.
	// For example, instead of $$$ = GetMoneyForNeedUtility(x), do $$$ = GetMoneyForNeedUtility(x + 0.1).
	//
	// This has a bunch of benefits, but the biggest one IMO is interpretability - this is
	// the cost, in Utils, of bothering with the trade and associated information assymetries.
	// As such, the padding value can be either RNG'd or estimated by AI in sane ways.
	GOAI_LOG_DEBUG("[src.name] | GetMoneyForNeedUtility: breakeven_money_value for Utility [utility] and current wealth [wealth] is: [breakeven_money_value] on basis [basis]/angle [as_angle]")
	return breakeven_money_value


/datum/utility_ai/proc/GetCommodityAmountForNeedDelta(var/commodity, var/need_key, var/delta, var/need_per_unit_override = null)
	/* Pre-flight checks */

	if(!commodity)
		TRADE_DEBUG_LOG("GetCommodityAmountForNeedDelta: Commodity [NULL_TO_TEXT(commodity)] is null.")
		return null

	if(!need_key)
		TRADE_DEBUG_LOG("GetCommodityAmountForNeedDelta: need_key [NULL_TO_TEXT(need_key)] is null.")
		return null

	if(!delta)
		// compressing null-handling and zero-handling
		// null returns null, because invalid
		// zero returns zero, because we don't need any Commodity to satisfy that
		TRADE_DEBUG_LOG("GetCommodityAmountForNeedDelta: Commodity [commodity] has no nonzero need values for delta [NULL_TO_TEXT(delta)].")
		return delta

	// fetch how much this commodity satisfies the target need
	// need_per_unit_override param can be used to inject precomputed value to speed this up
	var/need_per_unit = DEFAULT_IF_NULL(need_per_unit_override, GetCommodityNeedValueAbstract(commodity, need_key))

	if(!need_per_unit)
		// something's gone wrong
		TRADE_DEBUG_LOG("GetCommodityAmountForNeedDelta: Commodity [commodity] has no nonzero need values.")
		return null

	/* Core logic */

	if((delta > 0) && (need_per_unit >= delta))
		// simple case, early return to save compute
		return 1

	if((delta < 0) && (need_per_unit <= delta))
		// same for negatives; math reminder: (-100) < (-1)!
		return 1

	// numerically safe, we know need_per_unit != 0 from earlier
	var/raw_unit_count = (delta / need_per_unit)

	// convert the float amount into an integer
	// we'll 'rectify' the value for ceiling to make math easier
	var/ceiled_count = CEIL(abs(raw_unit_count))

	// readd the original sign to the ceiled absolute value
	var/unit_count = (raw_unit_count < 0) ? (-ceiled_count) : ceiled_count

	return unit_count


/datum/utility_ai/proc/GetBestPurchaseCommodityForNeed(var/need_key)
	if(src.best_purchase_for_need_proc)
		var/value = call(src.best_purchase_for_need_proc)(need_key, src.best_purchase_for_need_proc_args, src)
		return value

	else
		TRADE_DEBUG_LOG("ERROR: GetBestPurchaseCommodityForNeed for [src] has no dynamic proc declared! @ L[__LINE__] in [__FILE__]")

	return .


/datum/utility_ai/proc/GetBestSaleCommodityForNeed(var/need_key)
	if(src.best_sale_for_need_proc)
		var/value = call(src.best_sale_for_need_proc)(need_key, src.best_sale_for_need_proc_args, src)
		return value

	else
		TRADE_DEBUG_LOG("ERROR: GetBestSaleCommodityForNeed for [src] has no dynamic proc declared!")

	return .

