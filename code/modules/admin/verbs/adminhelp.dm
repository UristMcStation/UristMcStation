
//This is a list of words which are ignored by the parser when comparing message contents for names. MUST BE IN LOWER CASE!
var/global/list/adminhelp_ignored_words = list("unknown","the","a","an","of","monkey","alien","as")

/proc/generate_ahelp_key_words(mob/mob, msg)
	var/list/surnames = list()
	var/list/forenames = list()
	var/list/ckeys = list()

	//explode the input msg into a list
	var/list/msglist = splittext(msg, " ")

	for(var/mob/M in SSmobs.mob_list)
		var/list/indexing = list(M.real_name, M.name)
		if(M.mind)	indexing += M.mind.name

		for(var/string in indexing)
			var/list/L = splittext(string, " ")
			var/surname_found = 0
			//surnames
			for(var/i=length(L), i>=1, i--)
				var/word = ckey(L[i])
				if(word)
					surnames[word] = M
					surname_found = i
					break
			//forenames
			for(var/i=1, i<surname_found, i++)
				var/word = ckey(L[i])
				if(word)
					forenames[word] = M
			//ckeys
			ckeys[M.ckey] = M

	var/ai_found = 0
	msg = ""
	var/list/mobs_found = list()
	for(var/original_word in msglist)
		var/word = ckey(original_word)
		if(word)
			if(!(word in adminhelp_ignored_words))
				if(word == "ai" && !ai_found)
					ai_found = 1
					msg += "<b>[original_word] <A HREF='byond://?_src_=holder;adminchecklaws=\ref[mob]'>(CL)</A></b> "
					continue
				else
					var/mob/found = ckeys[word]
					if(!found)
						found = surnames[word]
						if(!found)
							found = forenames[word]
					if(found)
						if(!(found in mobs_found))
							mobs_found += found
							msg += "<b>[original_word] <A HREF='byond://?_src_=holder;adminmoreinfo=\ref[found]'>(?)</A>"
							if(!ai_found && isAI(found))
								ai_found = 1
								msg += " <A HREF='byond://?_src_=holder;adminchecklaws=\ref[mob]'>(CL)</A>"
							msg += "</b> "
							continue
		msg += "[original_word] "

	return msg

/client/verb/adminhelp(msg as text)
	set category = "Admin"
	set name = "Adminhelp"

	//handle muting and automuting
	if(prefs.muted & MUTE_ADMINHELP)
		to_chat(src, SPAN_COLOR("red", "Error: Admin-PM: You cannot send adminhelps (Muted)."))
		return

	adminhelped = TRUE


	//clean the input msg
	if(!msg)
		return
	msg = sanitize(msg)
	if(!msg)
		return
	var/original_msg = msg


	if(!mob) //this doesn't happen
		return

	//generate keywords lookup
	msg = generate_ahelp_key_words(mob, msg)

	// handle ticket
	var/datum/client_lite/client_lite = client_repository.get_lite_client(src)
	var/datum/ticket/ticket = get_open_ticket_by_client(client_lite)
	if(!ticket)
		ticket = new /datum/ticket(client_lite)
	else if(ticket.status == TICKET_ASSIGNED)
		// manually check that the target client exists here as to not spam the usr for each logged out admin on the ticket
		var/admin_found = 0
		for(var/datum/client_lite/admin in ticket.assigned_admins)
			var/client/admin_client = client_by_ckey(admin.ckey)
			if(admin_client)
				admin_found = 1
				src.cmd_admin_pm(admin_client, original_msg, ticket)
				break
		if(!admin_found)
			to_chat(src, SPAN_WARNING("Error: Private-Message: Client not found. They may have lost connection, so please be patient!"))
		return

	ticket.last_message_time = world.time
	ticket.msgs += new /datum/ticket_msg(src.ckey, null, original_msg)
	update_ticket_panels()


	//Options bar:  mob, details ( admin = 2, dev = 3, character name (0 = just ckey, 1 = ckey and character name), link? (0 no don't make it a link, 1 do so),
	//		highlight special roles (0 = everyone has same looking name, 1 = antags / special roles get a golden name)

	msg = SPAN_NOTICE("<b>[SPAN_COLOR("red", "HELP: ")][get_options_bar(mob, 2, 1, 1, 1, ticket)] (<a href='byond://?_src_=holder;take_ticket=\ref[ticket]'>[(ticket.status == TICKET_OPEN) ? "TAKE" : "JOIN"]</a>) (<a href='byond://?src=\ref[usr];close_ticket=\ref[ticket]'>CLOSE</a>):</b> [msg]")

	var/admin_number_afk = 0

	for(var/client/X as anything in GLOB.admins)
		if((R_ADMIN|R_MOD|R_MENTOR) & X.holder.rights)
			if(X.is_afk())
				admin_number_afk++
			if(X.get_preference_value(/datum/client_preference/staff/play_adminhelp_ping) == GLOB.PREF_HEAR)
				sound_to(X, 'sound/effects/adminhelp.ogg')
			to_chat(X, msg)
	//show it to the person adminhelping too
	to_chat(src, SPAN_CLASS("staff_pm", "PM to-<b>Staff</b> (<a href='byond://?src=\ref[usr];close_ticket=\ref[ticket]'>CLOSE</a>): [original_msg]"))
	var/admin_number_present = length(GLOB.admins) - admin_number_afk
	log_admin("HELP: [key_name(src)]: [original_msg] - heard by [admin_number_present] non-AFK admins.")
	if(admin_number_present <= 0)
		adminmsg2adminirc(src, null, "[html_decode(original_msg)] - !![admin_number_afk ? "All admins AFK ([admin_number_afk])" : "No admins online"]!!")
	else
		adminmsg2adminirc(src, null, "[html_decode(original_msg)]")


	send_to_admin_discord(EXCOM_MSG_AHELP, "HELP: [key_name(src, highlight_special_characters = FALSE)]: [original_msg]")
	return
