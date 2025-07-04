//Adminpaper - it's like paper, but more adminny!
/obj/item/paper/admin
	name = "administrative paper"
	desc = "If you see this, something has gone horribly wrong."
	var/datum/admins/admindatum = null

	var/interactions = null
	var/isCrayon = 0
	var/origin = null
	var/mob/sender = null
	/// List (`/obj/machinery/photocopier/faxmachine`). List of fax machines matching the paper's target department.
	var/list/destinations = list()
	/// String. The paper's target department.
	var/department = null

	var/header = null
	var/headerOn = TRUE

	var/footer = null
	var/footerOn = FALSE

	var/logo_list = list("sollogo.png","eclogo.png","fleetlogo.png","exologo.png","ntlogo.png","daislogo.png","xynlogo.png","terralogo.png", "sfplogo.png", "falogo.png", "zhlogo.png","bluentlogo.png","nervalogo.png")
	var/logo = ""

	var/unformatedText = ""

/obj/item/paper/admin/Initialize()
	. = ..()
	generateInteractions()


/obj/item/paper/admin/proc/generateInteractions()
	//clear first
	interactions = null

	//Snapshot is crazy and likes putting each topic hyperlink on a seperate line from any other tags so it's nice and clean.
	interactions += "<HR><center><span style='font-size: 10px'>The fax will transmit everything above this line</span><br>"
	interactions += "<A href='byond://?src=\ref[src];confirm=1'>Send fax</A> "
	interactions += "<A href='byond://?src=\ref[src];penmode=1'>Pen mode: [isCrayon ? "Crayon" : "Pen"]</A> "
	interactions += "<A href='byond://?src=\ref[src];cancel=1'>Cancel fax</A> "
	interactions += "<BR>"
	interactions += "<A href='byond://?src=\ref[src];changelogo=1'>Change logo</A> "
	interactions += "<A href='byond://?src=\ref[src];changelanguage=1'>Change language ([language])</A> "
	interactions += "<A href='byond://?src=\ref[src];toggleheader=1'>Toggle Header</A> "
	interactions += "<A href='byond://?src=\ref[src];togglefooter=1'>Toggle Footer</A> "
	interactions += "<A href='byond://?src=\ref[src];clear=1'>Clear page</A> "
	interactions += "</center>"

/obj/item/paper/admin/proc/generateHeader()
	var/originhash = md5("[origin]")
	var/challengehash = copytext(md5("[game_id]"),1,10) // changed to a hash of the game ID so it's more consistant but changes every round.
	var/text = null
	//TODO change logo based on who you're contacting.
	text = "<center><img src = [logo]></br>"
	text += "<b>[origin] Quantum Uplink Signed Message</b><br>"
	text += "<span style='font-size: 10px'>Encryption key: [originhash]<br>"
	text += "Challenge: [challengehash]<br></span></center><hr>"

	header = text

/obj/item/paper/admin/proc/generateFooter()
	var/text = null

	text = "<hr><span style='font-size: 10px'>"
	text += "This transmission is intended only for the addressee and may contain confidential information. Any unauthorized disclosure is strictly prohibited. <br><br>"
	text += "If this transmission is recieved in error, please notify both the sender and the office of [GLOB.using_map.boss_name] Internal Affairs immediately so that corrective action may be taken."
	text += "Failure to comply is a breach of regulation and may be prosecuted to the fullest extent of the law, where applicable."
	text += "</span>"

	footer = text


/obj/item/paper/admin/proc/adminbrowse()
	updateinfolinks()
	generateHeader()
	generateFooter()
	updateDisplay()

/obj/item/paper/admin/proc/updateDisplay()
	show_browser(usr, "<HTML><HEAD><TITLE>[name]</TITLE></HEAD><BODY>[headerOn ? header : ""][info_links][stamps][footerOn ? footer : ""][interactions]</BODY></HTML>", "window=[name];can_close=0")



/obj/item/paper/admin/Topic(href, href_list)
	if(href_list["write"])
		var/id = href_list["write"]

		var/t =  sanitize(input("Enter what you want to write:", "Write", unformatedText, null) as message, MAX_PAPER_MESSAGE_LEN, extra = 0)

		if(!t)
			return

		var/last_fields_value = fields

		unformatedText = t

		//t = html_encode(t)
		t = replacetext(t, "\n", "<BR>")
		t = parsepencode(t, null, null, isCrayon, null, TRUE) // Encode everything from pencode to html


		if(fields > 50)//large amount of fields creates a heavy load on the server, see updateinfolinks() and addtofield()
			to_chat(usr, SPAN_WARNING("Too many fields. Sorry, you can't do this."))
			fields = last_fields_value
			return

		if(id!="end")
			addtofield(text2num(id), t) // He wants to edit a field, let him.
		else
			info = t // set the file to the new text
			updateinfolinks()

		//manualy set freespace
		free_space = MAX_PAPER_MESSAGE_LEN - length(strip_html_properly(t))

		updateDisplay()

		update_icon()
		return

	if(href_list["confirm"])
		switch(alert("Are you sure you want to send the fax as is?",, "Yes", "No"))
			if("Yes")
				if(headerOn)
					info = header + info
				if(footerOn)
					info += footer
				updateinfolinks()
				close_browser(usr, "window=[name]")
				admindatum.faxCallback(src)
		return

	if(href_list["penmode"])
		isCrayon = !isCrayon
		generateInteractions()
		updateDisplay()
		return

	if(href_list["cancel"])
		close_browser(usr, "window=[name]")
		qdel(src)
		return

	if(href_list["clear"])
		clearpaper()
		updateDisplay()
		return

	if(href_list["toggleheader"])
		headerOn = !headerOn
		updateDisplay()
		return

	if(href_list["togglefooter"])
		footerOn = !footerOn
		updateDisplay()
		return

	if(href_list["changelogo"])
		logo = input(usr, "What logo?", "Choose a logo", "") as null|anything in (logo_list)
		generateHeader()
		updateDisplay()
		return

	if (href_list["changelanguage"])
		choose_language(usr, TRUE)
		generateInteractions()
		updateDisplay()
		return
