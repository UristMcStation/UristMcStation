/obj/item/spacecash
	name = "0 thalers"
	desc = "It's worth 0 thalers."
	gender = PLURAL
	icon = 'icons/obj/money.dmi'
	icon_state = "spacecash1"
	opacity = 0
	density = FALSE
	anchored = FALSE
	force = 1.0
	throwforce = 1.0
	throw_speed = 1
	throw_range = 2
	w_class = ITEM_SIZE_TINY
	var/access = list()
	access = access_crate_cash
	var/worth = 0
	var/static/denominations = list(1000,500,200,100,50,20,10,1)

/obj/item/spacecash/use_tool(obj/item/W, mob/living/user, list/click_params)
	if(istype(W, /obj/item/spacecash))
		if (istype(W, /obj/item/spacecash/ewallet))
			return ..()

		var/obj/item/spacecash/bundle/bundle
		if(!istype(W, /obj/item/spacecash/bundle))
			var/obj/item/spacecash/cash = W
			bundle = new (loc)
			bundle.worth += cash.worth
			qdel(cash)
		else //is bundle
			bundle = W
		bundle.worth += worth
		bundle.update_icon()
		if(istype(user, /mob/living/carbon/human))
			var/mob/living/carbon/human/h_user = user
			h_user.drop_from_inventory(bundle)
			h_user.put_in_hands(bundle)
		to_chat(user, SPAN_NOTICE("You add [worth] [GLOB.using_map.local_currency_name] worth of money to the bundles.<br>It holds [bundle.worth] [GLOB.using_map.local_currency_name] now."))
		qdel(src)
		return TRUE

	if (istype(W, /obj/item/gun/launcher/money))
		var/obj/item/gun/launcher/money/L = W
		L.absorb_cash(src, user)
		return TRUE

	return ..()

/obj/item/spacecash/proc/getMoneyImages()
	if(icon_state)
		return list(icon_state)

/obj/item/spacecash/bundle
	name = "pile of thalers"
	icon_state = "spacecash1"
	desc = "They are worth 0 Thalers."
	worth = 0
	var/mapped = FALSE

/obj/item/spacecash/bundle/Initialize()
	. = ..()
	update_icon()

/obj/item/spacecash/bundle/getMoneyImages()
	if(icon_state)
		return list(icon_state)
	. = list()
	var/sum = src.worth
	var/num = 0
	for(var/i in denominations)
		while(sum >= i && num < 50)
			sum -= i
			num++
			. += "spacecash[i]"
	if(num == 0) // Less than one thaler, let's just make it look like 1 for ease
		. += "spacecash1"

/obj/item/spacecash/bundle/on_update_icon()
	ClearOverlays()
	var/list/images = src.getMoneyImages()

	for(var/A in images)
		var/image/banknote = image('icons/obj/money.dmi', A)
		banknote.SetTransform(
			rotation = pick(-45, -27.5, 0, 0, 0, 0, 0, 0, 0, 27.5, 45),
			offset_x = rand(-6, 6),
			offset_y = rand(-4, 8)
		)
		AddOverlays(banknote)

	src.desc = "They are worth [worth] [GLOB.using_map.local_currency_name]."
	if(worth in denominations)
		src.SetName("[worth] [GLOB.using_map.local_currency_name]")
	else
		src.SetName("pile of [worth] [GLOB.using_map.local_currency_name]")

/obj/item/spacecash/bundle/attack_hand(mob/user as mob)
	if (user.get_inactive_hand() == src)
		var/amount = input(usr, "How many credits do you want to take out? (0 to [src.worth])", "Take Money", 20) as num
		var/result = split_off(amount, usr)
		if(result)
			usr.put_in_hands(result)
		else
			return 0
	..()

/obj/item/spacecash/bundle/proc/split_off(amount, mob/user)
	amount = round(clamp(amount, 0, src.worth))
	if(amount==0) return 0

	src.worth -= amount
	src.update_icon()
	if(!worth)
		user.drop_from_inventory(src)
	if(amount in list(1000,500,200,100,50,20,1))
		var/cashtype = text2path("/obj/item/spacecash/bundle/c[amount]")
		var/obj/cash = new cashtype (user.loc)
		. = cash
	else
		var/obj/item/spacecash/bundle/bundle = new (user.loc)
		bundle.worth = amount
		bundle.update_icon()
		. = bundle
	if(!worth)
		qdel(src)

/obj/item/spacecash/bundle/c1
	name = "1 Thaler"
	icon_state = "spacecash1"
	desc = "It's worth 1 credit."
	worth = 1

/obj/item/spacecash/bundle/c10
	name = "10 Thaler"
	icon_state = "spacecash10"
	desc = "It's worth 10 Thalers."
	worth = 10

/obj/item/spacecash/bundle/c20
	name = "20 Thaler"
	icon_state = "spacecash20"
	desc = "It's worth 20 Thalers."
	worth = 20

/obj/item/spacecash/bundle/c50
	name = "50 Thaler"
	icon_state = "spacecash50"
	desc = "It's worth 50 Thalers."
	worth = 50

/obj/item/spacecash/bundle/c100
	name = "100 Thaler"
	icon_state = "spacecash100"
	desc = "It's worth 100 Thalers."
	worth = 100

/obj/item/spacecash/bundle/c200
	name = "200 Thaler"
	icon_state = "spacecash200"
	desc = "It's worth 200 Thalers."
	worth = 200

/obj/item/spacecash/bundle/c500
	name = "500 Thaler"
	icon_state = "spacecash500"
	desc = "It's worth 500 Thalers."
	worth = 500

/obj/item/spacecash/bundle/c1000
	name = "1000 Thaler"
	icon_state = "spacecash1000"
	desc = "It's worth 1000 Thalers."
	worth = 1000

/proc/spawn_money(sum, spawnloc, mob/living/carbon/human/human_user as mob)
	if(sum in list(1000,500,200,100,50,20,10,1))
		var/cash_type = text2path("/obj/item/spacecash/bundle/c[sum]")
		var/obj/cash = new cash_type (spawnloc)
		if(ishuman(human_user) && !human_user.get_active_hand())
			human_user.put_in_hands(cash)
	else
		var/obj/item/spacecash/bundle/bundle = new (spawnloc)
		bundle.worth = sum
		bundle.update_icon()
		if (ishuman(human_user) && !human_user.get_active_hand())
			human_user.put_in_hands(bundle)
	return

/obj/item/spacecash/ewallet
	name = "Charge card"
	icon_state = "efundcard"
	desc = "A card that holds an amount of money."
	var/owner_name = "" //So the ATM can set it so the EFTPOS can put a valid name on transactions.

/obj/item/spacecash/ewallet/examine(mob/user, distance)
	. = ..(user)
	if (distance > 2 && user != loc) return
	to_chat(user, SPAN_NOTICE("Charge card's owner: [src.owner_name]. [GLOB.using_map.local_currency_name] remaining: [src.worth]."))
