/obj/machinery/computer/combatcomputer
	name = "weapons control computer"
	desc = "the control centre for the ship's weapons systems."
	anchored = 1
	var/shields = 0 //update this with the actual shields
	var/list/linkedweapons = list() //put the weapons in here on their init
	var/shipid = null
	var/target = null

/obj/machinery/computer/combatcomputer/attack_hand(user as mob)
	if(..(user))
		return
	if(!allowed(user))
		to_chat(user, "<span class='warning'>Access Denied.</span>")
		return 1

//	user.set_machine(src)
	interact(user)
//	ui_interact(user)


/*/obj/machinery/computer/combatcomputer/interact(mob/user as mob)
	var/dat = {"
<html>
	<head>
		<title>Combat Control Computer</title>
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
	<h1>Combat Control Computer</h1>
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
	user << browse(dat, "window=merch")
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
			usr << "<span class='warning'> Unable to charge your account.</span>"
		else
			usr << "<span class='notice'> You've successfully purchased the item.  It should be in your hands or on the floor.</span>"
	src.updateUsrDialog()
	return
*/
/obj/machinery/computer/combatcomputer/Topic(href, href_list)
	if(..())
		return

//	user.set_machine(src)

/obj/machinery/computer/combatcomputer/nerva //different def just in case we have multiple ships that do combat. although, i think i might keep the cargo ship noncombat, fluff it as it being too small, slips right by the enemies. i dunno
	name = "ICS Nerva Combat Computer"
	shipid = "nerva"