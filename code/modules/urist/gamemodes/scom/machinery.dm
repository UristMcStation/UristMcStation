/obj/machinery/door/airlock/multi_tile/marine
	name = "Airlock"
	icon = 'icons/urist/structures&machinery/Door2x1marine.dmi'
	assembly_type = /obj/structure/door_assembly/multi_tile

//blatent copypasta of autolathe. soooooorry, but autolathe is very not object oriented, and I don't feel like rewriting it to be.

/obj/machinery/scom/scomscience //i'll come back to clean up this later, promise
	name = "\improper autolathe"
	desc = "It produces items using metal and glass."
	icon_state = "autolathe"
	density = 1
	anchored = 1
	var/list/machine_recipes

	var/scomtechlvl = 0
	var/scommoney = 0

	var/show_category = "All"

	var/panel_open = 0
//	var/hacked = 0
//	var/disabled = 0
//	var/shocked = 0
	var/busy = 0

/obj/machinery/scom/scomscience/proc/update_recipe_list()
	if(!machine_recipes)
		machine_recipes = scomscience_recipes

/obj/machinery/scom/scomscience/interact(mob/user as mob)

	update_recipe_list()

	var/dat = "<center><h1>Autolathe Control Panel</h1><hr/>"

	dat += "<table width = '100%'>"
//	var/material_top = "<tr>"
//	var/material_bottom = "<tr>"

//	for(var/material in stored_material)
//		material_top += "<td width = '25%' align = center><b>[material]</b></td>"
//		material_bottom += "<td width = '25%' align = center>[stored_material[material]]<b>/[storage_capacity[material]]</b></td>"

	dat += "Money - [scommoney]</tr> Tech Level - [scomtechlvl]</tr></table><hr>"
	dat += "<h2>Printable Designs</h2><h3>Showing: <a href='?src=\ref[src];change_category=1'>[show_category]</a>.</h3></center><table width = '100%'>"

	var/index = 0
	for(var/datum/scomscience/recipe/R in machine_recipes)
		index++
		if(R.hidden && R.scomtechlvl > scomtechlvl || (show_category != "All" && show_category != R.category))
			continue
//		if(scomtechlvl == R.scomtechlvl)
		var/can_make = 1
		var/material_string = ""
		var/multiplier_string = ""
//		var/max_sheets
		var/comma
		if(!R.resources)
			material_string = "No resources required.</td>"
		else
			//Make sure it's buildable and list required resources.
			for(var/scommoney in R.resources)
				if(!isnull(scommoney) && scommoney < R.resources[scommoney])
					can_make = 0
				if(!comma)
					comma = 1

				if(R.scomtechlvl <= scomtechlvl)
					R.hidden = 0
					can_make = 0
				else
					material_string += ", "
				material_string += "[R.resources] dollars CUNT"
		multiplier_string = "<a href='?src=\ref[src];make=[index]'>\</a>"
		dat += "<tr><td width = 180>[R.hidden ? "<font color = 'red'>*</font>" : ""]<b>[can_make ? "<a href='?src=\ref[src];make=[index];multiplier=1'>" : ""][R.name][can_make ? "</a>" : ""]</b>[R.hidden ? "<font color = 'red'>*</font>" : ""][multiplier_string]</td><td align = right>[material_string]</tr>"

	dat += "</table><hr>"

	user << browse(dat, "window=autolathe")
	onclose(user, "autolathe")

/*		dat += "<table width = '100%'>"
		var/material_top = "<tr>"
		var/material_bottom = "<tr>"

		for(var/material in stored_material)
			material_top += "<td width = '25%' align = center><b>[material]</b></td>"
			material_bottom += "<td width = '25%' align = center>[stored_material[material]]<b>/[storage_capacity[material]]</b></td>"

		dat += "[material_top]</tr>[material_bottom]</tr></table><hr>"
		dat += "<h2>Printable Designs</h2><h3>Showing: <a href='?src=\ref[src];change_category=1'>[show_category]</a>.</h3></center><table width = '100%'>"

		var/index = 0
		for(var/datum/autolathe/recipe/R in machine_recipes)
			index++
			if(R.hidden && !hacked || (show_category != "All" && show_category != R.category))
				continue
			var/can_make = 1
			var/material_string = ""
			var/multiplier_string = ""
			var/max_sheets
			var/comma
			if(!R.resources || !R.resources.len)
				material_string = "No resources required.</td>"
			else
				//Make sure it's buildable and list requires resources.
				for(var/material in R.resources)
					var/sheets = round(stored_material[material]/R.resources[material])
					if(isnull(max_sheets) || max_sheets > sheets)
						max_sheets = sheets
					if(!isnull(stored_material[material]) && stored_material[material] < R.resources[material])
						can_make = 0
					if(!comma)
						comma = 1
					else
						material_string += ", "
					material_string += "[R.resources[material]] [material]"
				material_string += ".<br></td>"
				//Build list of multipliers for sheets.
				if(R.is_stack)
					if(max_sheets && max_sheets > 0)
						multiplier_string  += "<br>"
						for(var/i = 5;i<max_sheets;i*=2) //5,10,20,40...
							multiplier_string  += "<a href='?src=\ref[src];make=[index];multiplier=[i]'>\[x[i]\]</a>"
						multiplier_string += "<a href='?src=\ref[src];make=[index];multiplier=[max_sheets]'>\[x[max_sheets]\]</a>"

			dat += "<tr><td width = 180>[R.hidden ? "<font color = 'red'>*</font>" : ""]<b>[can_make ? "<a href='?src=\ref[src];make=[index];multiplier=1'>" : ""][R.name][can_make ? "</a>" : ""]</b>[R.hidden ? "<font color = 'red'>*</font>" : ""][multiplier_string]</td><td align = right>[material_string]</tr>"

		dat += "</table><hr>"*/

/obj/machinery/scom/scomscience/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if (busy)
		user << "<span class='notice'>\The [src] is busy. Please wait for completion of previous operation.</span>"
		return

	if(O.scomtechlvl <= scomtechlvl)
	//	user << "<span class='notice'>You can't get any more knowledge from this. Try selling it.</span>"
		scommoney = (scommoney + O.scommoney)
		return

	if(O.scomtechlvl >= scomtechlvl)
		scomtechlvl = O.scomtechlvl

	flick("autolathe_o",src) // Plays metal insertion animation. Work out a good way to work out a fitting animation. ~Z

	user.drop_item(O)
	del(O)

	updateUsrDialog()
	return

/obj/machinery/scom/scomscience/attack_hand(mob/user as mob)
	user.set_machine(src)
	interact(user)

/obj/machinery/scom/scomscience/Topic(href, href_list)

	if(..())
		return

	usr.set_machine(src)
//	add_fingerprint(usr)

	if(busy)
		usr << "<span class='notice'>The autolathe is busy. Please wait for completion of previous operation.</span>"
		return

	if(href_list["change_category"])

		var/choice = input("Which category do you wish to display?") as null|anything in scomscience_categories+"All"
		if(!choice) return
		show_category = choice

	if(href_list["make"] && machine_recipes)

		var/index = text2num(href_list["make"])
		var/multiplier = text2num(href_list["multiplier"])
		var/datum/scomscience/recipe/making

		if(index > 0 && index <= machine_recipes.len)
			making = machine_recipes[index]

		//Exploit detection, not sure if necessary after rewrite.
		if(!making || multiplier < 0 || multiplier > 100)
			var/turf/exploit_loc = get_turf(usr)
			message_admins("[key_name_admin(usr)] tried to exploit an autolathe to duplicate an item! ([exploit_loc ? "<a href='?_src_=holder;adminplayerobservecoodjump=1;X=[exploit_loc.x];Y=[exploit_loc.y];Z=[exploit_loc.z]'>JMP</a>" : "null"])", 0)
			log_admin("EXPLOIT : [key_name(usr)] tried to exploit an autolathe to duplicate an item!")
			return

		busy = 1

		//Check if we still have the materials.
//		for(var/material in making.resources)
//			if(!isnull(stored_material[material]))
//				if(stored_material[material] < (making.resources[material]*multiplier))
//					return

		if(making.scomtechlvl > scomtechlvl)
			usr << "<span class='notice'>You don't have the tech level for that!</span>"
			busy = 0
			return

		if(making.resources > scommoney)
			usr << "<span class='notice'>You don't have the money for that!</span>"
			busy = 0
			return

		if(scommoney >= making.resources)
			scommoney = scommoney - making.resources


		//Consume materials.
//		for(var/material in making.resources)
//			if(!isnull(stored_material[material]))
//				stored_material[material] = max(0,stored_material[material]-(making.resources[material]*multiplier))

		//Fancy autolathe animation.
		flick("autolathe_n",src)

		sleep(50)

		busy = 0

		//Sanity check.
		if(!making || !src) return

		//Create the desired item.
		new making.path(get_step(loc, get_dir(src,usr)))

	updateUsrDialog()