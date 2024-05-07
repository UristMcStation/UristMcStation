/*****************************
 * /vg/station In-Game Store *
 *****************************

By Nexypoo

The idea is to give people who do their jobs a reward.

Ideally, these items should be cosmetic in nature to avoid fucking up round balance.
People joining the round get between $100 and $500. //it's higher on Urist// Keep this in mind.

Money should not persist between rounds, although a "bank" system to voluntarily store
money between rounds might be cool.  It'd need to be a bit volatile:  perhaps completing
job objectives = good stock market, shitty job objective completion = shitty economy.

Goal for now is to get the store itself working, however.
*/

var/global/datum/store/centcomm_store=new

/datum/store
	var/list/datum/storeitem/items=list()
	var/list/datum/storeorder/orders=list()

	var/obj/machinery/computer/account_database/linked_db

/datum/store/New()
	for(var/itempath in typesof(/datum/storeitem) - /datum/storeitem)
		items += new itempath()

/datum/store/proc/charge(datum/mind/mind,var/amount,var/datum/storeitem/item)
	if(!mind.initial_account)
		//testing("No initial_account")
		return 0
	if(mind.initial_account.money < amount)
		//testing("Not enough cash")
		return 0
	mind.initial_account.money -= amount
	var/datum/transaction/T = new()
	T.target = "Nanotrasen Merchandising"
	T.purpose = "Purchase of [item.name]"
	T.amount = -amount
	T.date = stationdate2text()
	T.time = stationtime2text()
	T.source = "\[CLASSIFIED\] Terminal #[rand(111,333)]"
	mind.initial_account.transaction_log.Add(T)
	return 1

/datum/store/proc/reconnect_database()
	for(var/obj/machinery/computer/account_database/DB in SSmachines.machinery)
		if(DB.z == 1)
			linked_db = DB
			break

/datum/store/proc/PlaceOrder(mob/living/usr, var/itemID)
	// Get our item, first.
	var/datum/storeitem/item = items[itemID]
	if(!item)
		return 0
	// Try to deduct funds.
	if(!charge(usr.mind,item.cost,item))
		return 0
	// Give them the item.
	item.deliver(usr)
	return 1

//sanity break

/obj/machinery/computer/merch
	name = "Merchandise Computer"
	icon_screen = "comm_logs"
	light_color = "#00b000"
	// circuit = /obj/item/stock_parts/circuitboard/merch

/obj/item/stock_parts/circuitboard/merch
	name = "\improper Merchandise Computer Circuitboard"
	build_path = /obj/machinery/computer/merch

/obj/machinery/computer/merch/New()
	..()

/obj/machinery/computer/merch/attack_ai(mob/user as mob)
	if(!ai_can_interact(user))
		return
	src.add_hiddenprint(user)
	return attack_hand(user)

/obj/machinery/computer/merch/attack_hand(mob/user as mob)
	user.set_machine(src)
	add_fingerprint(user)

	if(stat & (inoperable()))
		return

	var/balance=0
	if(user.mind)
		if(user.mind.initial_account)
			balance = user.mind.initial_account.money

	var/dat = {"
<html>
	<head>
		<title>Nanotrasen Merchandise</title>
		<style type="text/css">
* {
	font-family:sans-serif;
	font-size:x-small;
}
html {
	background:#333;
	color:#999;
}

a {
	color:#cfcfcf;
	text-decoration:none;
	font-weight:bold;
}

a:hover {
	color:#ffffff;
}
tr {
	background:#303030;
	border-radius:6px;
	margin-bottom:0.5em;
	border-bottom:1px solid black;
}
tr:nth-child(even) {
	background:#3f3f3f;
}

td.cost {
	font-size:20pt;
	font-weight:bold;
}

td.cost.affordable {
	background:green;
}

td.cost.toomuch {
	background:maroon;
}


		</style>
	</head>
	<body>
	<p style="float:right"><a href='byond://?src=\ref[src];refresh=1'>Refresh</a> | <b>Balance:</b> $[balance]</p>
	<h1>Nanotrasen Merchandise</h1>
	<p>
		<b>Doing your job and not getting any recognition at work?</b>  Well, welcome to the
		merch shop!  Here, you can buy cool things in exchange for money.
	</p>
	<p>Work hard. Get cash. Acquire bragging rights.</p>
	<h2>In Stock:</h2>
	<table cellspacing="4" cellpadding="0">
		<thead>
			<th>#</th>
			<th>Name/Description</th>
			<th>Price</th>
		</thead>
		<tbody>
	"}
	for(var/datum/storeitem/item in centcomm_store.items)
		var/cost_class="affordable"
		if(item.cost>balance)
			cost_class="toomuch"
		var/itemID=centcomm_store.items.Find(item)
		dat += {"
			<tr>
				<th>
					[itemID]
				</th>
				<td>
					<p><b>[item.name]</b></p>
					<p>[item.desc]</p>
				</td>
				<td class="cost [cost_class]">
					<a href="byond://?src=\ref[src];buy=[itemID]">$[item.cost]</a>
				</td>
			</tr>
		"}
	dat += {"
		</tbody>
	</table>
	</body>
</html>"}
	show_browser(user, dat, "window=merch")
	onclose(user, "merch")
	return

/obj/machinery/computer/merch/Topic(href, href_list)
	if(..())
		return

	//testing(href)

	src.add_fingerprint(usr)

	if (href_list["buy"])
		var/itemID = text2num(href_list["buy"])
		var/datum/storeitem/item = centcomm_store.items[itemID]
		var/sure = alert(usr,"Are you sure you wish to purchase [item.name] for $[item.cost]?","You sure?","Yes","No") in list("Yes","No")
		if(sure=="No")
			updateUsrDialog()
			return
		if(!centcomm_store.PlaceOrder(usr,itemID))
			to_chat(usr, "<span class='warning'> Unable to charge your account.</span>")
		else
			to_chat(usr, "<span class='notice'> You've successfully purchased the item.  It should be in your hands or on the floor.</span>")
	src.updateUsrDialog()
	return

/*/obj/machinery/computer/merch/on_update_icon()

	if(stat & BROKEN)
		icon_state = "comm_logs0"
	else
		if(stat & MACHINE_STAT_NOPOWER)
			src.icon_state = "comm_logs"
			stat |= MACHINE_STAT_NOPOWER
		else
			icon_state = initial(icon_state)
			stat &= ~MACHINE_STAT_NOPOWER*/
