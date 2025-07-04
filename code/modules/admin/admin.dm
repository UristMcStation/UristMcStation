
var/global/BSACooldown = 0
var/global/floorIsLava = 0


////////////////////////////////
/proc/message_admins(msg)
	msg = SPAN_CLASS("log_message", "[SPAN_CLASS("prefix", "ADMIN LOG:")] [SPAN_CLASS("message", msg)]")
	log_adminwarn(msg)
	for(var/client/C as anything in GLOB.admins)
		if(R_ADMIN & C.holder.rights)
			to_chat(C, msg)
/proc/message_staff(msg)
	msg = SPAN_CLASS("log_message", "[SPAN_CLASS("prefix", "STAFF LOG:")] [SPAN_CLASS("message", msg)]")
	log_adminwarn(msg)
	for(var/client/C as anything in GLOB.admins)
		if(C && C.holder && (R_INVESTIGATE & C.holder.rights))
			to_chat(C, msg)
/proc/msg_admin_attack(text) //Toggleable Attack Messages
	log_attack(text)
	var/rendered = SPAN_CLASS("log_message", "[SPAN_CLASS("prefix", "ATTACK:")] [SPAN_CLASS("message", text)]")
	for(var/client/C as anything in GLOB.admins)
		if(check_rights(R_INVESTIGATE|R_MENTOR, 0, C))
			if(C.get_preference_value(/datum/client_preference/staff/show_attack_logs) == GLOB.PREF_SHOW)
				var/msg = rendered
				to_chat(C, msg)
/proc/admin_notice(message, rights)
	for(var/mob/M in SSmobs.mob_list)
		if(check_rights(rights, 0, M))
			to_chat(M, message)
///////////////////////////////////////////////////////////////////////////////////////////////Panels

/datum/admins/proc/show_player_panel(mob/M in SSmobs.mob_list)
	set category = null
	set name = "Show Player Panel"
	set desc="Edit player (respawn, ban, heal, etc)"

	if(!M)
		to_chat(usr, "You seem to be selecting a mob that doesn't exist anymore.")
		return
	if (!istype(src,/datum/admins))
		src = usr.client.holder
	if (!istype(src,/datum/admins))
		to_chat(usr, "Error: you are not an admin!")
		return

	var/body = "<html><head><title>Options for [M.key]</title></head>"
	body += "<body>Options panel for <b>[M]</b>"
	var/last_ckey = LAST_CKEY(M)
	if(M.client)
		body += " played by <b>[M.client]</b> "
		body += "\[<A href='byond://?src=\ref[src];editrights=show'>[M.client.holder ? M.client.holder.rank : "Player"]</A>\]"
	else if(last_ckey)
		body += " (last occupied by ckey <b>[last_ckey]</b>)"

	if(istype(M, /mob/new_player))
		body += " <B>Hasn't Entered Game</B> "
	else
		body += " \[<A href='byond://?src=\ref[src];revive=\ref[M]'>Heal</A>\] "

	var/mob/living/exosuit/E = M
	if(istype(E) && E.pilots)
		body += "<br><b>Exosuit pilots:</b><br>"
		for(var/mob/living/pilot in E.pilots)
			body += "[pilot] "
			body += " \[<A href='byond://?src=\ref[src];pilot=\ref[pilot]'>link</a>\]<br>"

	var/inactivity_time = M.client ? time_to_readable(M.client.inactivity) : null

	var/logout_time = null
	if (!isnull(M.logout_time))
		logout_time = time_to_readable(world.time - M.logout_time)

	body += {"
		<br><br>\[
		<a href='byond://?_src_=vars;Vars=\ref[M]'>VV</a> -
		<a href='byond://?src=\ref[src];traitor=\ref[M]'>TP</a> -
		<a href='byond://?src=\ref[usr];priv_msg=\ref[M]'>PM</a> -
		<a href='byond://?src=\ref[src];narrateto=\ref[M]'>DN</a> -
		[admin_jump_link(M, src)]\] <br>
		<b>Mob type:</b> [M.type]<br>
		<b>Inactivity time:</b> [inactivity_time ? "[inactivity_time]" : "Logged out"]<br/>
		<b>Logout time:</b> [logout_time ? "[logout_time] ago" : "N/A"]<br/><br/>
		<A href='byond://?src=\ref[src];paralyze=\ref[M]'>PARALYZE</A> |
		<A href='byond://?src=\ref[src];boot2=\ref[M]'>Kick</A> |
		<A href='byond://?_src_=holder;warn=[last_ckey]'>Warn</A> |
		<A href='byond://?src=\ref[src];newban=\ref[M];last_key=[last_ckey]'>Ban</A> |
		<A href='byond://?src=\ref[src];jobban2=\ref[M]'>Jobban</A> |
		<A href='byond://?src=\ref[src];notes=show;mob=\ref[M]'>Notes</A> |
		<A HREF='byond://?src=\ref[src];connections=\ref[M]'>Check Connections</A> |
		<A HREF='byond://?src=\ref[src];bans=\ref[M]'>Check Bans</A> |
	"}
	if (M.ckey)
		body += {"<a target="_blank" href="https://www.byond.com/members/[M.ckey]">View Byond Account</a> | "}

	if (!istype(M, /mob/new_player) && !istype(M, /mob/observer))
		body += "<A HREF='byond://?src=\ref[src];cryo=\ref[M]'>Cryo Character</A> | "
		body += "<A HREF='byond://?src=\ref[src];equip_loadout=\ref[M]'>Equip Loadout</A> | "

	if(M.client)
		body += "<A HREF='byond://?src=\ref[src];sendtoprison=\ref[M]'>Prison</A> | "
		body += "<A HREF='byond://?src=\ref[src];reloadsave=\ref[M]'>Reload Save</A> | "
		body += "<A HREF='byond://?src=\ref[src];reloadchar=\ref[M]'>Reload Character</A> | "
		var/muted = M.client.prefs.muted
		body += {"<br><b>Mute: </b>
			\[<A href='byond://?src=\ref[src];mute=\ref[M];mute_type=[MUTE_IC]'><span style='font-color: [(muted & MUTE_IC)?"red":"blue"]'>IC</span></a> |
			<A href='byond://?src=\ref[src];mute=\ref[M];mute_type=[MUTE_OOC]'><span style='font-color: [(muted & MUTE_OOC)?"red":"blue"]'>OOC</span></a> |
			<A href='byond://?src=\ref[src];mute=\ref[M];mute_type=[MUTE_AOOC]'><span style='font-color: [(muted & MUTE_AOOC)?"red":"blue"]'>AOOC</span></a> |
			<A href='byond://?src=\ref[src];mute=\ref[M];mute_type=[MUTE_PRAY]'><span style='font-color: [(muted & MUTE_PRAY)?"red":"blue"]'>PRAY</span></a> |
			<A href='byond://?src=\ref[src];mute=\ref[M];mute_type=[MUTE_ADMINHELP]'><span style='font-color: [(muted & MUTE_ADMINHELP)?"red":"blue"]'>ADMINHELP</span></a> |
			<A href='byond://?src=\ref[src];mute=\ref[M];mute_type=[MUTE_DEADCHAT]'><span style='font-color: [(muted & MUTE_DEADCHAT)?"red":"blue"]'>DEADCHAT</span></a>\]
			(<A href='byond://?src=\ref[src];mute=\ref[M];mute_type=[MUTE_ALL]'><span style='font-color: [(muted & MUTE_ALL)?"red":"blue"]'>toggle all</span></a>)
		"}
		body += "<br><br><b>Staff Warning:</b> [M.client.staffwarn ? M.client.staffwarn : "No"]<br>"
		if (!M.client.staffwarn)
			body += "<A href='byond://?src=\ref[src];setstaffwarn=\ref[M]'>Set StaffWarn</A>"
		else
			body += "<A href='byond://?src=\ref[src];removestaffwarn=\ref[M]'>Remove StaffWarn</A>"

	body += {"<br><br>
		<A href='byond://?src=\ref[src];jumpto=\ref[M]'><b>Jump to</b></A> |
		<A href='byond://?src=\ref[src];getmob=\ref[M]'>Get</A>
		<br><br>
		[check_rights(R_ADMIN|R_MOD,0) ? "<A href='byond://?src=\ref[src];traitor=\ref[M]'>Traitor panel</A> | " : "" ]
		[check_rights(R_INVESTIGATE,0) ? "<A href='byond://?src=\ref[src];skillpanel=\ref[M]'>Skill panel</A>" : "" ]
	"}

	if(M.mind)
		body += "<br><br>"
		body += "<b>Goals:</b>"
		body += "<br>"
		body += "[jointext(M.mind.summarize_goals(FALSE, TRUE, src), "<br>")]"
		body += "<br>"
		body += "<a href='byond://?src=\ref[M.mind];add_goal=1'>Add Random Goal</a>"

	body += "<br><br>"
	body += "<b>Psionics:</b><br/>"
	if(isliving(M))
		var/mob/living/psyker = M
		if(psyker.psi)
			body += "<a href='byond://?src=\ref[psyker.psi];remove_psionics=1'>Remove psionics.</a><br/><br/>"
			body += "<a href='byond://?src=\ref[psyker.psi];trigger_psi_latencies=1'>Trigger latencies.</a><br/>"
		body += "<table width = '100%'>"
		for(var/faculty in list(PSI_COERCION, PSI_PSYCHOKINESIS, PSI_REDACTION, PSI_ENERGISTICS))
			var/singleton/psionic_faculty/faculty_singleton = SSpsi.get_faculty(faculty)
			var/faculty_rank = psyker.psi ? psyker.psi.get_rank(faculty) : 0
			body += "<tr><td><b>[faculty_singleton.name]</b></td>"
			for(var/i = 1 to LAZYLEN(GLOB.psychic_ranks_to_strings))
				var/psi_title = GLOB.psychic_ranks_to_strings[i]
				if(i == faculty_rank)
					psi_title = "<b>[psi_title]</b>"
				body += "<td><a href='byond://?src=\ref[psyker.mind];set_psi_faculty_rank=[i];set_psi_faculty=[faculty]'>[psi_title]</a></td>"
			body += "</tr>"
		body += "</table>"

	if (M.client)
		if(!istype(M, /mob/new_player))
			body += "<br><br>"
			body += "<b>Transformation:</b>"
			body += "<br>"

			//Monkey
			if(issmall(M))
				body += "<B>Monkeyized</B> | "
			else
				body += "<A href='byond://?src=\ref[src];monkeyone=\ref[M]'>Monkeyize</A> | "

			//Corgi
			if(iscorgi(M))
				body += "<B>Corgized</B> | "
			else
				body += "<A href='byond://?src=\ref[src];corgione=\ref[M]'>Corgize</A> | "

			//AI / Cyborg
			if(isAI(M))
				body += "<B>Is an AI</B> "
			else if(ishuman(M))
				body += {"<A href='byond://?src=\ref[src];makeai=\ref[M]'>Make AI</A> |
					<A href='byond://?src=\ref[src];makerobot=\ref[M]'>Make Robot</A> |
					<A href='byond://?src=\ref[src];makealien=\ref[M]'>Make Alien</A> |
					<A href='byond://?src=\ref[src];makeslime=\ref[M]'>Make Slime</A> |
					<A href='byond://?src=\ref[src];makezombie=\ref[M]'>Make Zombie</A> |
				"}

			//Simple Animals
			if(isanimal(M))
				body += "<A href='byond://?src=\ref[src];makeanimal=\ref[M]'>Re-Animalize</A> | "
			else
				body += "<A href='byond://?src=\ref[src];makeanimal=\ref[M]'>Animalize</A> | "

			// DNA2 - Admin Hax
			if(M.dna && iscarbon(M))
				body += "<br><br>"
				body += "<b>DNA Blocks:</b><br><table border='0'><tr><th>&nbsp;</th><th>1</th><th>2</th><th>3</th><th>4</th><th>5</th>"
				var/bname
				for(var/block=1;block<=DNA_SE_LENGTH;block++)
					if(((block-1)%5)==0)
						body += "</tr><tr><th>[block-1]</th>"
					bname = assigned_blocks[block]
					body += "<td>"
					if(bname)
						var/bstate=M.dna.GetSEState(block)
						var/bcolor="[(bstate)?"#006600":"#ff0000"]"
						body += "<A href='byond://?src=\ref[src];togmutate=\ref[M];block=[block]' style='color:[bcolor];'>[bname]</A><sub>[block]</sub>"
					else
						body += "[block]"
					body+="</td>"
				body += "</tr></table>"

			body += {"<br><br>
				<b>Rudimentary transformation:</b>[FONT_NORMAL("<br>These transformations only create a new mob type and copy stuff over. They do not take into account MMIs and similar mob-specific things. The buttons in 'Transformations' are preferred, when possible.")]<br>
				<A href='byond://?src=\ref[src];simplemake=observer;mob=\ref[M]'>Observer</A> |
				\[ Xenos: <A href='byond://?src=\ref[src];simplemake=larva;mob=\ref[M]'>Larva</A>
				<A href='byond://?src=\ref[src];simplemake=human;species=Xenophage Drone;mob=\ref[M]'>Drone</A>
				<A href='byond://?src=\ref[src];simplemake=human;species=Xenophage Hunter;mob=\ref[M]'>Hunter</A>
				<A href='byond://?src=\ref[src];simplemake=human;species=Xenophage Sentinel;mob=\ref[M]'>Sentinel</A>
				<A href='byond://?src=\ref[src];simplemake=human;species=Xenophage Queen;mob=\ref[M]'>Queen</A> \] |
				\[ Crew: <A href='byond://?src=\ref[src];simplemake=human;mob=\ref[M]'>Human</A>
				<A href='byond://?src=\ref[src];simplemake=human;species=Unathi;mob=\ref[M]'>Unathi</A>
				<A href='byond://?src=\ref[src];simplemake=human;species=Skrell;mob=\ref[M]'>Skrell</A>
				<A href='byond://?src=\ref[src];simplemake=human;species=Vox;mob=\ref[M]'>Vox</A> \] | \[
				<A href='byond://?src=\ref[src];simplemake=nymph;mob=\ref[M]'>Nymph</A>
				<A href='byond://?src=\ref[src];simplemake=human;species='Diona';mob=\ref[M]'>Diona</A> \] |
				\[ slime: <A href='byond://?src=\ref[src];simplemake=slime;mob=\ref[M]'>Baby</A>,
				<A href='byond://?src=\ref[src];simplemake=adultslime;mob=\ref[M]'>Adult</A> \]
				<A href='byond://?src=\ref[src];simplemake=monkey;mob=\ref[M]'>Monkey</A> |
				<A href='byond://?src=\ref[src];simplemake=robot;mob=\ref[M]'>Cyborg</A> |
				<A href='byond://?src=\ref[src];simplemake=cat;mob=\ref[M]'>Cat</A> |
				<A href='byond://?src=\ref[src];simplemake=runtime;mob=\ref[M]'>Runtime</A> |
				<A href='byond://?src=\ref[src];simplemake=corgi;mob=\ref[M]'>Corgi</A> |
				<A href='byond://?src=\ref[src];simplemake=ian;mob=\ref[M]'>Ian</A> |
				<A href='byond://?src=\ref[src];simplemake=crab;mob=\ref[M]'>Crab</A> |
				<A href='byond://?src=\ref[src];simplemake=coffee;mob=\ref[M]'>Coffee</A> |
				\[ Construct: <A href='byond://?src=\ref[src];simplemake=constructarmoured;mob=\ref[M]'>Armoured</A> ,
				<A href='byond://?src=\ref[src];simplemake=constructbuilder;mob=\ref[M]'>Builder</A> ,
				<A href='byond://?src=\ref[src];simplemake=constructwraith;mob=\ref[M]'>Wraith</A> \]
				<A href='byond://?src=\ref[src];simplemake=shade;mob=\ref[M]'>Shade</A>
				<br>
			"}
	body += {"<br><br>
			<b>Other actions:</b>
			<br>
			<A href='byond://?src=\ref[src];forcespeech=\ref[M]'>Forcesay</A> |
			<a href='byond://?src=\ref[src];cloneother=\ref[M]'>Clone Other</a>
			"}
	if (M.client)
		body += {" |
			<A href='byond://?src=\ref[src];tdome1=\ref[M]'>Thunderdome 1</A> |
			<A href='byond://?src=\ref[src];tdome2=\ref[M]'>Thunderdome 2</A> |
			<A href='byond://?src=\ref[src];tdomeadmin=\ref[M]'>Thunderdome Admin</A> |
			<A href='byond://?src=\ref[src];tdomeobserve=\ref[M]'>Thunderdome Observer</A> |
		"}
	// language toggles
	body += "<br><br><b>Languages:</b><br>"
	var/f = 1
	for(var/k in all_languages)
		var/datum/language/L = all_languages[k]
		if(!(L.flags & INNATE))
			if(!f) body += " | "
			else f = 0
			if(L in M.languages)
				body += "<a href='byond://?src=\ref[src];toglang=\ref[M];lang=[html_encode(k)]' style='color:#006600'>[k]</a>"
			else
				body += "<a href='byond://?src=\ref[src];toglang=\ref[M];lang=[html_encode(k)]' style='color:#ff0000'>[k]</a>"

	body += {"<br>
		</body></html>
	"}

	show_browser(usr, body, "window=adminplayeropts;size=550x515")


/datum/player_info/var/author // admin who authored the information
/datum/player_info/var/rank //rank of admin who made the notes
/datum/player_info/var/content // text content of the information
/datum/player_info/var/timestamp // Because this is bloody annoying
/// Round ID of the note
/datum/player_info/var/game_id

#define PLAYER_NOTES_ENTRIES_PER_PAGE 50
/datum/admins/proc/PlayerNotes()
	set category = "Admin"
	set name = "Player Notes"
	if (!istype(src,/datum/admins))
		src = usr.client.holder
	if (!istype(src,/datum/admins))
		to_chat(usr, "Error: you are not an admin!")
		return
	PlayerNotesPage()

/datum/admins/proc/PlayerNotesPage(filter_term)
	var/list/dat = list()
	dat += "<B>Player notes</B><HR>"
	var/savefile/S=new("data/player_notes.sav")
	var/list/note_keys
	from_save(S, note_keys)

	if(filter_term)
		for(var/t in note_keys)
			if(findtext(lowertext(t), lowertext(filter_term)))
				continue
			note_keys -= t

	dat += "<center><b>Search term:</b> <a href='byond://?src=\ref[src];notes=set_filter'>[filter_term ? filter_term : "-----"]</a></center><hr>"

	if(!note_keys)
		dat += "No notes found."
	else
		dat += "<table>"
		note_keys = sortList(note_keys)
		for(var/t in note_keys)
			dat += "<tr><td><a href='byond://?src=\ref[src];notes=show;ckey=[t]'>[t]</a></td></tr>"
		dat += "</table><br>"

	var/datum/browser/popup = new(usr, "player_notes", "Player Notes", 400, 400)
	popup.set_content(jointext(dat, null))
	popup.open()


/datum/admins/proc/player_has_info(key)
	var/target = ckey(key)
	var/savefile/info = new("data/player_saves/[copytext_char(target, 1, 2)]/[target]/info.sav")
	var/list/infos
	from_save(info, infos)
	if (!length(infos))
		return FALSE
	return TRUE


/proc/html_page(title, list/body, list/head)
	return {"\
		<!doctype html>
		<html lang="en">\
		<head>\
			<meta charset="UTF-8">\
			<meta name="viewport" content="width=device-width,initial-scale=1">\
			<link rel="icon" href="data:,">\
			[head ? (islist(head) ? jointext(head, null) : head) : ""]\
			<title>[title]</title>\
		</head>\
		<body>[body ? (islist(body) ? jointext(body, null) : body) : ""]</body>\
		</html>\
	"}


/proc/html_page_common(title, list/body, list/head)
	var/list/prefix = list(
		{"<link rel="stylesheet" href="common.css">"},
		"<style>html, body { padding: 8px; font-family: Verdana, Geneva, sans-serif; }</style>"
	)
	return html_page(title, body, head ? prefix + head : prefix)


/datum/admins/proc/show_player_info(target as text)
	set category = "Admin"
	set name = "Show Player Info"
	if (!target)
		return
	if (!istext(target))
		return
	target = ckey(target)
	var/client/user = resolve_client(usr)
	if (!check_rights(R_INVESTIGATE, TRUE, user))
		return
	var/datum/admins/handler = user.holder
	var/client/subject
	for (var/client/client as anything in GLOB.clients)
		if (client.ckey == target)
			subject = client
			break
	var/list/body = list()
	body += {"\
		<div style="text-align: center;">\
			<b>Player Age</b>: [subject ? subject.player_age : "Not Connected"]\
			<hr>\
			<a href="byond://?src=\ref[handler];add_player_info=[target]">Add Comment</a>\
		</div>\
		<hr>\
	"}
	var/list/infos
	var/savefile = new /savefile ("data/player_saves/[copytext_char(target, 1, 2)]/[target]/info.sav")
	from_save(savefile, infos)
	if (!infos)
		body += {"<div style="text-align: center; font-style: italic;">No comments saved.</div>"}
	for (var/i = length(infos) to 1 step -1)
		var/datum/player_info/comment = infos[i]
		var/remove_button = ""
		if (comment.author == user.key || check_rights(R_HOST, FALSE, user))
			remove_button = {"<a href="byond://?src=\ref[handler];remove_player_info=[target];remove_index=[i]">Remove</a>"}
		body += {"\
			<div style="text-align: right; margin-bottom: 8px;">\
				<div style="text-align: left; border: 1px dashed #808080; padding: 2px;">[comment.content]</div>\
				<div style="text-align: right;">\
					<b>[comment.author || "(not recorded)"]</b>, \
					<b>[comment.rank || "(not recorded)"]</b>, \
					on <b>[comment.timestamp || "(not recorded)"]</b>\
					[comment.game_id ? "<br>Round ID: <b>[comment.game_id]</b>" : null]\
				</div>\
				[remove_button]\
			</div>\
		"}
	send_rsc(user, 'html/browser/common.css', "common.css")
	show_browser(user, html_page_common("Player Info: [target]", body), "window=showplayernotes;size=480x480;")


/datum/admins/proc/access_news_network() //MARKER
	set category = "Fun"
	set name = "Access Newscaster Network"
	set desc = "Allows you to view, add and edit news feeds."

	if (!istype(src,/datum/admins))
		src = usr.client.holder
	if (!istype(src,/datum/admins))
		to_chat(usr, "Error: you are not an admin!")
		return

	var/datum/feed_network/torch_network = news_network[1] //temp change until the UI can be updated to support switching networks.

	var/dat
	dat = text("<HEAD><TITLE>Admin Newscaster</TITLE></HEAD><H3>Admin Newscaster Unit</H3>")

	switch(admincaster_screen)
		if(0)
			dat += {"Welcome to the admin newscaster.<BR> Here you can add, edit and censor every newspiece on the network.
				<BR>Feed channels and stories entered through here will be uneditable and handled as official news by the rest of the units.
				<BR>Note that this panel allows full freedom over the news network, there are no constrictions except the few basic ones. Don't break things!
			"}
			if(torch_network.wanted_issue)
				dat+= "<HR><A href='byond://?src=\ref[src];ac_view_wanted=1'>Read Wanted Issue</A>"

			dat+= {"<HR><BR><A href='byond://?src=\ref[src];ac_create_channel=1'>Create Feed Channel</A>
				<BR><A href='byond://?src=\ref[src];ac_view=1'>View Feed Channels</A>
				<BR><A href='byond://?src=\ref[src];ac_create_feed_story=1'>Submit new Feed story</A>
				<BR><BR><A href='byond://?src=\ref[usr];mach_close=newscaster_main'>Exit</A>
			"}

			var/wanted_already = 0
			if(torch_network.wanted_issue)
				wanted_already = 1

			dat+={"<HR><B>Feed Security functions:</B><BR>
				<BR><A href='byond://?src=\ref[src];ac_menu_wanted=1'>[(wanted_already) ? ("Manage") : ("Publish")] \"Wanted\" Issue</A>
				<BR><A href='byond://?src=\ref[src];ac_menu_censor_story=1'>Censor Feed Stories</A>
				<BR><A href='byond://?src=\ref[src];ac_menu_censor_channel=1'>Mark Feed Channel with [GLOB.using_map.company_name] D-Notice (disables and locks the channel.</A>
				<BR><HR><A href='byond://?src=\ref[src];ac_set_signature=1'>The newscaster recognises you as:<BR> [SPAN_COLOR("green", src.admincaster_signature)]</A>
			"}
		if(1)
			dat+= "Feed Channels<HR>"
			if( !length(torch_network.network_channels) )
				dat+="<I>No active channels found...</I>"
			else
				for(var/datum/feed_channel/CHANNEL in torch_network.network_channels)
					if(CHANNEL.is_admin_channel)
						dat+="<B><span style='background-color: LightGreen'><A href='byond://?src=\ref[src];ac_show_channel=\ref[CHANNEL]'>[CHANNEL.channel_name]</A></span></B><BR>"
					else
						dat+="<B><A href='byond://?src=\ref[src];ac_show_channel=\ref[CHANNEL]'>[CHANNEL.channel_name]</A> [(CHANNEL.censored) ? (SPAN_COLOR("red", "***")) : null ]<BR></B>"
			dat+={"<BR><HR><A href='byond://?src=\ref[src];ac_refresh=1'>Refresh</A>
				<BR><A href='byond://?src=\ref[src];ac_setScreen=[0]'>Back</A>
			"}

		if(2)
			dat+={"
				Creating new Feed Channel...
				<HR><B><A href='byond://?src=\ref[src];ac_set_channel_name=1'>Channel Name</A>:</B> [src.admincaster_feed_channel.channel_name]<BR>
				<B><A href='byond://?src=\ref[src];ac_set_signature=1'>Channel Author</A>:</B> [SPAN_COLOR("green", src.admincaster_signature)]<BR>
				<B><A href='byond://?src=\ref[src];ac_set_channel_lock=1'>Will Accept Public Feeds</A>:</B> [(src.admincaster_feed_channel.locked) ? ("NO") : ("YES")]<BR><BR>
				<BR><A href='byond://?src=\ref[src];ac_submit_new_channel=1'>Submit</A><BR><BR><A href='byond://?src=\ref[src];ac_setScreen=[0]'>Cancel</A><BR>
			"}
		if(3)
			dat+={"
				Creating new Feed Message...
				<HR><B><A href='byond://?src=\ref[src];ac_set_channel_receiving=1'>Receiving Channel</A>:</B> [src.admincaster_feed_channel.channel_name]<BR>" //MARK
				<B>Message Author:</B> [SPAN_COLOR("green", src.admincaster_signature)]<BR>
				<B><A href='byond://?src=\ref[src];ac_set_new_message=1'>Message Body</A>:</B> [src.admincaster_feed_message.body] <BR>
				<BR><A href='byond://?src=\ref[src];ac_submit_new_message=1'>Submit</A><BR><BR><A href='byond://?src=\ref[src];ac_setScreen=[0]'>Cancel</A><BR>
			"}
		if(4)
			dat+={"
					Feed story successfully submitted to [src.admincaster_feed_channel.channel_name].<BR><BR>
					<BR><A href='byond://?src=\ref[src];ac_setScreen=[0]'>Return</A><BR>
				"}
		if(5)
			dat+={"
				Feed Channel [src.admincaster_feed_channel.channel_name] created successfully.<BR><BR>
				<BR><A href='byond://?src=\ref[src];ac_setScreen=[0]'>Return</A><BR>
			"}
		if(6)
			dat+="<B>[SPAN_COLOR("maroon", "ERROR: Could not submit Feed story to Network.</B>")]<HR><BR>"
			if(src.admincaster_feed_channel.channel_name=="")
				dat+="[SPAN_COLOR("maroon", "Invalid receiving channel name.")]<BR>"
			if(src.admincaster_feed_message.body == "" || src.admincaster_feed_message.body == "\[REDACTED\]")
				dat+="[SPAN_COLOR("maroon", "Invalid message body.")]<BR>"
			dat+="<BR><A href='byond://?src=\ref[src];ac_setScreen=[3]'>Return</A><BR>"
		if(7)
			dat+="<B>[SPAN_COLOR("maroon", "ERROR: Could not submit Feed Channel to Network.</B>")]<HR><BR>"
			if(src.admincaster_feed_channel.channel_name =="" || src.admincaster_feed_channel.channel_name == "\[REDACTED\]")
				dat+="[SPAN_COLOR("maroon", "Invalid channel name.")]<BR>"
			var/check = 0
			for(var/datum/feed_channel/FC in torch_network.network_channels)
				if(FC.channel_name == src.admincaster_feed_channel.channel_name)
					check = 1
					break
			if(check)
				dat+="[SPAN_COLOR("maroon", "Channel name already in use.")]<BR>"
			dat+="<BR><A href='byond://?src=\ref[src];ac_setScreen=[2]'>Return</A><BR>"
		if(9)
			dat+="<B>[src.admincaster_feed_channel.channel_name]: </B>[FONT_SMALL("\[created by: [SPAN_COLOR("maroon", src.admincaster_feed_channel.author)]\]")]<HR>"
			if(src.admincaster_feed_channel.censored)
				dat+={"
					[SPAN_COLOR("red", "<B>ATTENTION: </B>")]This channel has been deemed as threatening to the welfare of the [station_name()], and marked with a [GLOB.using_map.company_name] D-Notice.<BR>
					No further feed story additions are allowed while the D-Notice is in effect.<BR><BR>
				"}
			else
				if( !length(admincaster_feed_channel.messages) )
					dat+="<I>No feed messages found in channel...</I><BR>"
				else
					var/i = 0
					for(var/datum/feed_message/MESSAGE in src.admincaster_feed_channel.messages)
						i++
						dat+="-[MESSAGE.body] <BR>"
						if(MESSAGE.img)
							send_rsc(usr, MESSAGE.img, "tmp_photo[i].png")
							dat+="<img src='tmp_photo[i].png' width = '180'><BR><BR>"
						dat+="[FONT_SMALL("\[Story by [SPAN_COLOR("maroon", MESSAGE.author)]\]")]<BR>"
			dat+={"
				<BR><HR><A href='byond://?src=\ref[src];ac_refresh=1'>Refresh</A>
				<BR><A href='byond://?src=\ref[src];ac_setScreen=[1]'>Back</A>
			"}
		if(10)
			dat+={"
				<B>[GLOB.using_map.company_name] Feed Censorship Tool</B><BR>
				<span style='font-size: 10px'>NOTE: Due to the nature of news Feeds, total deletion of a Feed Story is not possible.<BR>
				Keep in mind that users attempting to view a censored feed will instead see the \[REDACTED\] tag above it.</span>
				<HR>Select Feed channel to get Stories from:<BR>
			"}
			if(!length(torch_network.network_channels))
				dat+="<I>No feed channels found active...</I><BR>"
			else
				for(var/datum/feed_channel/CHANNEL in torch_network.network_channels)
					dat+="<A href='byond://?src=\ref[src];ac_pick_censor_channel=\ref[CHANNEL]'>[CHANNEL.channel_name]</A> [(CHANNEL.censored) ? (SPAN_COLOR("red", "***")) : null ]<BR>"
			dat+="<BR><A href='byond://?src=\ref[src];ac_setScreen=[0]'>Cancel</A>"
		if(11)
			dat+={"
				<B>[GLOB.using_map.company_name] D-Notice Handler</B><HR>
				<span style='font-size: 10px'>A D-Notice is to be bestowed upon the channel if the handling Authority deems it as harmful for the [station_name()]'s
				morale, integrity or disciplinary behaviour. A D-Notice will render a channel unable to be updated by anyone, without deleting any feed
				stories it might contain at the time. You can lift a D-Notice if you have the required access at any time.</span><HR>
			"}
			if(!length(torch_network.network_channels))
				dat+="<I>No feed channels found active...</I><BR>"
			else
				for(var/datum/feed_channel/CHANNEL in torch_network.network_channels)
					dat+="<A href='byond://?src=\ref[src];ac_pick_d_notice=\ref[CHANNEL]'>[CHANNEL.channel_name]</A> [(CHANNEL.censored) ? (SPAN_COLOR("red", "***")) : null ]<BR>"

			dat+="<BR><A href='byond://?src=\ref[src];ac_setScreen=[0]'>Back</A>"
		if(12)
			dat+={"
				<B>[src.admincaster_feed_channel.channel_name]: </B>[FONT_SMALL("\[ created by: [SPAN_COLOR("maroon", src.admincaster_feed_channel.author)] \]")]<BR>
				[FONT_NORMAL("<A href='byond://?src=\ref[src];ac_censor_channel_author=\ref[src.admincaster_feed_channel]'>[(src.admincaster_feed_channel.author=="\[REDACTED\]") ? ("Undo Author censorship") : ("Censor channel Author")]</A>")]<HR>
			"}
			if( !length(admincaster_feed_channel.messages) )
				dat+="<I>No feed messages found in channel...</I><BR>"
			else
				for(var/datum/feed_message/MESSAGE in src.admincaster_feed_channel.messages)
					dat+={"
						-[MESSAGE.body] <BR>[FONT_SMALL("\[Story by [SPAN_COLOR("maroon", MESSAGE.author)]\]")]<BR>
						[FONT_NORMAL("<A href='byond://?src=\ref[src];ac_censor_channel_story_body=\ref[MESSAGE]'>[(MESSAGE.body == "\[REDACTED\]") ? ("Undo story censorship") : ("Censor story")]</A>  -  <A href='byond://?src=\ref[src];ac_censor_channel_story_author=\ref[MESSAGE]'>[(MESSAGE.author == "\[REDACTED\]") ? ("Undo Author Censorship") : ("Censor message Author")]</A>")]<BR>
					"}
			dat+="<BR><A href='byond://?src=\ref[src];ac_setScreen=[10]'>Back</A>"
		if(13)
			dat+={"
				<B>[src.admincaster_feed_channel.channel_name]: </B>[FONT_SMALL("\[ created by: [SPAN_COLOR("maroon", src.admincaster_feed_channel.author)] \]")]<BR>
				Channel messages listed below. If you deem them dangerous to the [station_name()], you can <A href='byond://?src=\ref[src];ac_toggle_d_notice=\ref[src.admincaster_feed_channel]'>Bestow a D-Notice upon the channel</A>.<HR>
			"}
			if(src.admincaster_feed_channel.censored)
				dat+={"
					[SPAN_COLOR("red", "<B>ATTENTION: </B>")]This channel has been deemed as threatening to the welfare of the [station_name()], and marked with a [GLOB.using_map.company_name] D-Notice.<BR>
					No further feed story additions are allowed while the D-Notice is in effect.<BR><BR>
				"}
			else
				if( !length(admincaster_feed_channel.messages) )
					dat+="<I>No feed messages found in channel...</I><BR>"
				else
					for(var/datum/feed_message/MESSAGE in src.admincaster_feed_channel.messages)
						dat+="-[MESSAGE.body] <BR>[FONT_SMALL("\[Story by [SPAN_COLOR("maroon", MESSAGE.author)]\]")]<BR>"

			dat+="<BR><A href='byond://?src=\ref[src];ac_setScreen=[11]'>Back</A>"
		if(14)
			dat+="<B>Wanted Issue Handler:</B>"
			var/wanted_already = 0
			var/end_param = 1
			if(torch_network.wanted_issue)
				wanted_already = 1
				end_param = 2
			if(wanted_already)
				dat+="[FONT_NORMAL("<BR><I>A wanted issue is already in Feed Circulation. You can edit or cancel it below.")]</I>"
			dat+={"
				<HR>
				<A href='byond://?src=\ref[src];ac_set_wanted_name=1'>Criminal Name</A>: [src.admincaster_feed_message.author] <BR>
				<A href='byond://?src=\ref[src];ac_set_wanted_desc=1'>Description</A>: [src.admincaster_feed_message.body] <BR>
			"}
			if(wanted_already)
				dat+="<B>Wanted Issue created by:</B>[SPAN_COLOR("green", " [torch_network.wanted_issue.backup_author]")]<BR>"
			else
				dat+="<B>Wanted Issue will be created under prosecutor:</B>[SPAN_COLOR("green", " [src.admincaster_signature]")]<BR>"
			dat+="<BR><A href='byond://?src=\ref[src];ac_submit_wanted=[end_param]'>[(wanted_already) ? ("Edit Issue") : ("Submit")]</A>"
			if(wanted_already)
				dat+="<BR><A href='byond://?src=\ref[src];ac_cancel_wanted=1'>Take down Issue</A>"
			dat+="<BR><A href='byond://?src=\ref[src];ac_setScreen=[0]'>Cancel</A>"
		if(15)
			dat+={"
				[SPAN_COLOR("green", "Wanted issue for [src.admincaster_feed_message.author] is now in Network Circulation.")]<BR><BR>
				<BR><A href='byond://?src=\ref[src];ac_setScreen=[0]'>Return</A><BR>
			"}
		if(16)
			dat+="<B>[SPAN_COLOR("maroon", "ERROR: Wanted Issue rejected by Network.</B>")]<HR><BR>"
			if(src.admincaster_feed_message.author =="" || src.admincaster_feed_message.author == "\[REDACTED\]")
				dat+="[SPAN_COLOR("maroon", "Invalid name for person wanted.")]<BR>"
			if(src.admincaster_feed_message.body == "" || src.admincaster_feed_message.body == "\[REDACTED\]")
				dat+="[SPAN_COLOR("maroon", "Invalid description.")]<BR>"
			dat+="<BR><A href='byond://?src=\ref[src];ac_setScreen=[0]'>Return</A><BR>"
		if(17)
			dat+={"
				<B>Wanted Issue successfully deleted from Circulation</B><BR>
				<BR><A href='byond://?src=\ref[src];ac_setScreen=[0]'>Return</A><BR>
			"}
		if(18)
			dat+={"
				[SPAN_COLOR("maroon", "<B>-- STATIONWIDE WANTED ISSUE --</B>")]<BR>[FONT_NORMAL("\[Submitted by: [SPAN_COLOR("green", torch_network.wanted_issue.backup_author)]\]")]<HR>
				<B>Criminal</B>: [torch_network.wanted_issue.author]<BR>
				<B>Description</B>: [torch_network.wanted_issue.body]<BR>
				<B>Photo:</B>:
			"}
			if(torch_network.wanted_issue.img)
				send_rsc(usr, torch_network.wanted_issue.img, "tmp_photow.png")
				dat+="<BR><img src='tmp_photow.png' width = '180'>"
			else
				dat+="None"
			dat+="<BR><A href='byond://?src=\ref[src];ac_setScreen=[0]'>Back</A><BR>"
		if(19)
			dat+={"
				[SPAN_COLOR("green", "Wanted issue for [src.admincaster_feed_message.author] successfully edited.")]<BR><BR>
				<BR><A href='byond://?src=\ref[src];ac_setScreen=[0]'>Return</A><BR>
			"}
		else
			dat+="I'm sorry to break your immersion. This shit's bugged. Report this bug to Agouri, polyxenitopalidou@gmail.com"

//	log_debug("Channelname: [src.admincaster_feed_channel.channel_name] [src.admincaster_feed_channel.author]")
//	log_debug("Msg: [src.admincaster_feed_message.author] [src.admincaster_feed_message.body]")

	show_browser(usr, dat, "window=admincaster_main;size=400x600")
	onclose(usr, "admincaster_main")



/datum/admins/proc/Jobbans()
	if(!check_rights(R_BAN))	return

	var/dat = "<B>Job Bans!</B><HR><table>"
	for(var/t in jobban_keylist)
		var/r = t
		if( findtext(r,"##") )
			r = copytext( r, 1, findtext(r,"##") )//removes the description
		dat += text("<tr><td>[t] (<A href='byond://?src=\ref[src];removejobban=[r]'>unban</A>)</td></tr>")
	dat += "</table>"
	show_browser(usr, dat, "window=ban;size=400x400")

/datum/admins/proc/Game()
	if(!check_rights(0))	return

	var/dat = {"
		<center><B>Game Panel</B></center><hr>\n
		<A href='byond://?src=\ref[src];c_mode=1'>Change Game Mode</A><br>
		"}
	if(SSticker.master_mode == "secret")
		dat += "<A href='byond://?src=\ref[src];f_secret=1'>(Force Secret Mode)</A><br>"

	dat += {"
		<BR>
		<A href='byond://?src=\ref[src];create_object=1'>Create Object</A><br>
		<A href='byond://?src=\ref[src];create_turf=1'>Create Turf</A><br>
		<A href='byond://?src=\ref[src];create_mob=1'>Create Mob</A><br>
		<br><A href='byond://?src=\ref[src];vsc=airflow'>Edit Airflow Settings</A><br>
		<A href='byond://?src=\ref[src];vsc=phoron'>Edit Phoron Settings</A><br>
		<A href='byond://?src=\ref[src];vsc=default'>Choose a default ZAS setting</A><br>
		"}

	show_browser(usr, dat, "window=admin2;size=210x280")
	return

/datum/admins/proc/Secrets(datum/admin_secret_category/active_category = null)
	if(!check_rights(0))	return

	// Print the header with category selection buttons.
	var/dat = "<B>The first rule of adminbuse is: you don't talk about the adminbuse.</B><HR>"
	for(var/datum/admin_secret_category/category in admin_secrets.categories)
		if(!category.can_view(usr))
			continue
		if(active_category == category)
			dat += SPAN_CLASS("linkOn", category.name)
		else
			dat += "<A href='byond://?src=\ref[src];admin_secrets_panel=\ref[category]'>[category.name]</A> "
	dat += "<HR>"

	// If a category is selected, print its description and then options
	if(istype(active_category) && active_category.can_view(usr))
		if(active_category.desc)
			dat += "<I>[active_category.desc]</I><BR>"
		for(var/datum/admin_secret_item/item in active_category.items)
			if(!item.can_view(usr))
				continue
			dat += "<A href='byond://?src=\ref[src];admin_secrets=\ref[item]'>[item.name()]</A><BR>"
		dat += "<BR>"

	var/datum/browser/popup = new(usr, "secrets", "Secrets", 550, 500)
	popup.set_content(dat)
	popup.open()
	return

/////////////////////////////////////////////////////////////////////////////////////////////////admins2.dm merge
//i.e. buttons/verbs


/datum/admins/proc/restart()
	set category = "Server"
	set name = "Restart"
	set desc="Restarts the world"
	if (!usr.client.holder)
		return
	var/confirm = alert("Restart the game world?", "Restart", "Yes", "Cancel")
	if(confirm == "Cancel")
		return
	if(confirm == "Yes")
		to_world("[SPAN_DANGER("Restarting world!")] [SPAN_NOTICE("Initiated by [usr.key]!")]")
		log_admin("[key_name(usr)] initiated a reboot.")

		sleep(50)
		world.Reboot()


/datum/admins/proc/announce()
	set category = "Special Verbs"
	set name = "Announce"
	set desc="Announce your desires to the world"
	if(!check_rights(0))	return

	var/message = input("Global message to send:", "Admin Announce", null, null) as message
	message = sanitize(message, 500, extra = 0)
	if(message)
		message = replacetext(message, "\n", "<br>") // required since we're putting it in a <p> tag
		to_world("[SPAN_NOTICE("<b>[usr.key] Announces:</b><p style='text-indent: 50px'>[message]</p>")]")
		log_admin("Announce: [key_name(usr)] : [message]")


GLOBAL_VAR_AS(skip_allow_lists, FALSE)

/datum/admins/proc/toggle_allowlists()
	set category = "Server"
	set name = "Toggle Allow Lists"
	if(!check_rights(R_ADMIN))
		return
	GLOB.skip_allow_lists = !GLOB.skip_allow_lists
	var/outcome = GLOB.skip_allow_lists ? "disabled" : "enabled"
	log_and_message_admins("[outcome] allow lists.")


/datum/admins/proc/toggleooc()
	set category = "Server"
	set desc="Globally Toggles OOC"
	set name="Toggle OOC"

	if(!check_rights(R_ADMIN))
		return

	config.ooc_allowed = !(config.ooc_allowed)
	if (config.ooc_allowed)
		to_world("<B>The OOC channel has been globally enabled!</B>")
	else
		to_world("<B>The OOC channel has been globally disabled!</B>")
	log_and_message_admins("toggled OOC.")

/datum/admins/proc/toggleaooc()
	set category = "Server"
	set desc="Globally Toggles AOOC"
	set name="Toggle AOOC"

	if(!check_rights(R_ADMIN))
		return

	config.aooc_allowed = !(config.aooc_allowed)
	if (config.aooc_allowed)
		communicate_broadcast(/singleton/communication_channel/aooc, "The AOOC channel has been globally enabled!", TRUE)
	else
		communicate_broadcast(/singleton/communication_channel/aooc, "The AOOC channel has been globally disabled!", TRUE)
	log_and_message_admins("toggled AOOC.")

/datum/admins/proc/togglelooc()
	set category = "Server"
	set desc="Globally Toggles LOOC"
	set name="Toggle LOOC"

	if(!check_rights(R_ADMIN))
		return

	config.looc_allowed = !(config.looc_allowed)
	if (config.looc_allowed)
		to_world("<B>The LOOC channel has been globally enabled!</B>")
	else
		to_world("<B>The LOOC channel has been globally disabled!</B>")
	log_and_message_admins("toggled LOOC.")


/datum/admins/proc/toggledsay()
	set category = "Server"
	set desc="Globally Toggles DSAY"
	set name="Toggle DSAY"

	if(!check_rights(R_ADMIN))
		return

	config.dsay_allowed = !(config.dsay_allowed)
	if (config.dsay_allowed)
		to_world("<B>Deadchat has been globally enabled!</B>")
	else
		to_world("<B>Deadchat has been globally disabled!</B>")
	log_and_message_admins("toggled deadchat.")

/datum/admins/proc/toggleoocdead()
	set category = "Server"
	set desc="Toggle Dead OOC."
	set name="Toggle Dead OOC"

	if(!check_rights(R_ADMIN))
		return

	config.dooc_allowed = !( config.dooc_allowed )
	log_admin("[key_name(usr)] toggled Dead OOC.")
	message_admins("[key_name_admin(usr)] toggled Dead OOC.", 1)

/datum/admins/proc/togglehubvisibility()
	set category = "Server"
	set desc="Globally Toggles Hub Visibility"
	set name="Toggle Hub Visibility"

	if(!check_rights(R_ADMIN))
		return

	world.update_hub_visibility()
	var/long_message = "Updated hub visibility. The server is now [config.hub_visible ? "visible" : "invisible"]."
	if (config.hub_visible && !world.reachable)
		message_admins("WARNING: The server will not show up on the hub because byond is detecting that a firewall is blocking incoming connections.")

	send_to_admin_discord(EXCOM_MSG_AHELP, "[key_name(src, highlight_special_characters = FALSE)]" + long_message)
	log_and_message_admins(long_message)

/datum/admins/proc/toggletraitorscaling()
	set category = "Server"
	set desc="Toggle traitor scaling"
	set name="Toggle Traitor Scaling"
	config.traitor_scaling = !config.traitor_scaling
	log_admin("[key_name(usr)] toggled Traitor Scaling to [config.traitor_scaling].")
	message_admins("[key_name_admin(usr)] toggled Traitor Scaling [config.traitor_scaling ? "on" : "off"].", 1)

/datum/admins/proc/startnow()
	set category = "Server"
	set desc="Start the round RIGHT NOW"
	set name="Start Now"
	if(GAME_STATE < RUNLEVEL_LOBBY)
		to_chat(usr, FONT_LARGE(SPAN_DANGER("Unable to start the game as it is not yet set up.")))
		SSticker.start_ASAP = !SSticker.start_ASAP
		if(SSticker.start_ASAP)
			to_chat(usr, FONT_LARGE(SPAN_WARNING("The game will begin as soon as possible.")))
			log_and_message_admins("will begin the game as soon as possible.")
		else
			to_chat(usr, FONT_LARGE(SPAN_WARNING("The game will begin as normal.")))
			log_and_message_admins("will begin the game as normal.")
		return 0
	SSticker.start_ASAP = TRUE
	if(SSticker.start_now())
		log_and_message_admins("has started the game.")
		return 1
	else
		to_chat(usr, SPAN_CLASS("bigwarning", "Error: Start Now: Game has already started."))
		return 0

/datum/admins/proc/endnow()
	set category = "Server"
	set desc = "End the round immediately."
	set name = "End Round"

	var/check = alert("This will immediately end the current round. Are you sure?", "End Game", "Yes", "No") == "Yes"

	if (!check)
		return

	if (GAME_STATE > RUNLEVEL_LOBBY)
		SSticker.forced_end = TRUE
		log_and_message_admins("has ended the round.")
	else
		to_chat(usr, FONT_LARGE(SPAN_WARNING("You cannot end the round before it's begun!")))

/datum/admins/proc/toggleenter()
	set category = "Server"
	set desc="People can't enter"
	set name="Toggle Entering"
	config.enter_allowed = !(config.enter_allowed)
	if (!(config.enter_allowed))
		to_world("<B>New players may no longer enter the game.</B>")
	else
		to_world("<B>New players may now enter the game.</B>")
	log_and_message_admins("toggled new player game entering.")
	world.update_status()

/datum/admins/proc/toggleaban()
	set category = "Server"
	set desc="Respawn basically"
	set name="Toggle Respawn"
	config.abandon_allowed = !(config.abandon_allowed)
	if(config.abandon_allowed)
		to_world("<B>You may now respawn.</B>")
	else
		to_world("<B>You may no longer respawn :(</B>")
	log_and_message_admins("toggled respawn to [config.abandon_allowed ? "On" : "Off"].")
	world.update_status()

/datum/admins/proc/toggle_aliens()
	set category = "Server"
	set desc="Toggle alien mobs"
	set name="Toggle Aliens"
	if(!check_rights(R_ADMIN))
		return

	config.aliens_allowed = !config.aliens_allowed
	log_admin("[key_name(usr)] toggled Aliens to [config.aliens_allowed].")
	message_admins("[key_name_admin(usr)] toggled Aliens [config.aliens_allowed ? "on" : "off"].", 1)

/datum/admins/proc/toggle_alien_eggs()
	set category = "Server"
	set desc="Toggle xenomorph egg laying"
	set name="Toggle Alien Eggs"

	if(!check_rights(R_ADMIN))
		return
	config.alien_eggs_allowed = !config.alien_eggs_allowed
	log_admin("[key_name(usr)] toggled Alien Egg Laying to [config.alien_eggs_allowed].")
	message_admins("[key_name_admin(usr)] toggled Alien Egg Laying [config.alien_eggs_allowed ? "on" : "off"].", 1)


/datum/admins/proc/delay()
	set category = "Server"
	set desc="Delay the game start/end"
	set name="Delay"

	if(!check_rights(R_SERVER))	return
	if (GAME_STATE > RUNLEVEL_LOBBY)
		SSticker.delay_end = !SSticker.delay_end
		log_and_message_admins("[SSticker.delay_end ? "delayed the round end" : "has made the round end normally"].")
		return //alert("Round end delayed", null, null, null, null, null)
	SSticker.round_progressing = !SSticker.round_progressing
	if (!SSticker.round_progressing)
		to_world("<b>The game start has been delayed.</b>")
		log_admin("[key_name(usr)] delayed the game.")
	else
		to_world("<b>The game will start soon.</b>")
		log_admin("[key_name(usr)] removed the delay.")

/datum/admins/proc/adjump()
	set category = "Server"
	set desc="Toggle admin jumping"
	set name="Toggle Jump"
	config.allow_admin_jump = !(config.allow_admin_jump)
	log_and_message_admins("Toggled admin jumping to [config.allow_admin_jump].")

/datum/admins/proc/adspawn()
	set category = "Server"
	set desc="Toggle admin spawning"
	set name="Toggle Spawn"
	config.allow_admin_spawning = !(config.allow_admin_spawning)
	log_and_message_admins("toggled admin item spawning to [config.allow_admin_spawning].")

/datum/admins/proc/adrev()
	set category = "Server"
	set desc="Toggle admin revives"
	set name="Toggle Revive"
	config.allow_admin_rev = !(config.allow_admin_rev)
	log_and_message_admins("toggled reviving to [config.allow_admin_rev].")

/datum/admins/proc/immreboot()
	set category = "Server"
	set desc="Reboots the server post haste"
	set name="Immediate Reboot"
	if(!usr.client.holder)	return
	if( alert("Reboot server?",,"Yes","No") == "No")
		return
	to_world("[SPAN_DANGER("Rebooting world!")] [SPAN_NOTICE("Initiated by [usr.key]!")]")
	log_admin("[key_name(usr)] initiated an immediate reboot.")

	world.Reboot()

/datum/admins/proc/unprison(mob/M in SSmobs.mob_list)
	set category = "Admin"
	set name = "Unprison"
	if (isAdminLevel(M.z))
		if (config.allow_admin_jump)
			M.forceMove(pick(GLOB.latejoin))
			message_admins("[key_name_admin(usr)] has unprisoned [key_name_admin(M)]", 1)
			log_admin("[key_name(usr)] has unprisoned [key_name(M)]")
		else
			alert("Admin jumping disabled")
	else
		alert("[M.name] is not prisoned.")

////////////////////////////////////////////////////////////////////////////////////////////////ADMIN HELPER PROCS

/proc/is_special_character(character) // returns 1 for special characters and 2 for heroes of gamemode
	if(!SSticker.mode)
		return 0
	var/datum/mind/M
	if (ismob(character))
		var/mob/C = character
		M = C.mind
	else if(istype(character, /datum/mind))
		M = character

	if(M)
		if(SSticker.mode.antag_templates && length(SSticker.mode.antag_templates))
			for(var/datum/antagonist/antag in SSticker.mode.antag_templates)
				if(antag.is_antagonist(M))
					return 2
		if(M.special_role)
			return 1

	if(isrobot(character))
		var/mob/living/silicon/robot/R = character
		if(R.emagged)
			return 1

	return 0

/datum/admins/proc/mass_debug_closet_icons()

	set name = "Mass Debug Closet Icons"
	set desc = "Spawn every possible custom closet. Do not do this on live."
	set category = "Debug"

	if(!check_rights(R_SPAWN))
		return

	if((input(usr, "Are you sure you want to spawn all these closets?", "So Many Closets") as null|anything in list("No", "Yes")) == "Yes")
		log_admin("[key_name(usr)] mass-spawned closets (icon debug), if this is a live server you should yell at them.")
		var/x = 0
		var/y = 0
		for(var/check_appearance in typesof(/singleton/closet_appearance))
			x++
			if(x > 10)
				x = 0
				y++
			var/turf/T = locate(usr.x+x, usr.y+y, usr.z)
			if(T)
				new /obj/structure/closet/debug(T, check_appearance)

/datum/admins/proc/spawn_fruit(seedtype in SSplants.seeds)
	set category = "Debug"
	set desc = "Spawn the product of a seed."
	set name = "Spawn Fruit"

	if(!check_rights(R_SPAWN))	return

	if(!seedtype || !SSplants.seeds[seedtype])
		return
	var/datum/seed/S = SSplants.seeds[seedtype]
	S.harvest(usr,0,0,1)
	log_admin("[key_name(usr)] spawned [seedtype] fruit at ([usr.x],[usr.y],[usr.z])")

/datum/admins/proc/spawn_custom_item()
	set category = "Debug"
	set desc = "Spawn a custom item."
	set name = "Spawn Custom Item"

	if(!check_rights(R_SPAWN))	return

	var/owner = input("Select a ckey.", "Spawn Custom Item") as null|anything in SScustomitems.custom_items_by_ckey
	if(!owner|| !SScustomitems.custom_items_by_ckey[owner])
		return

	var/list/possible_items = list()
	for(var/datum/custom_item/item in SScustomitems.custom_items_by_ckey[owner])
		possible_items[item.item_name] = item
	var/item_to_spawn = input("Select an item to spawn.", "Spawn Custom Item") as null|anything in possible_items
	if(item_to_spawn && possible_items[item_to_spawn])
		var/datum/custom_item/item_datum = possible_items[item_to_spawn]
		item_datum.spawn_item(get_turf(usr))

/datum/admins/proc/check_custom_items()

	set category = "Debug"
	set desc = "Check the custom item list."
	set name = "Check Custom Items"

	if(!check_rights(R_SPAWN))	return

	if(!SScustomitems.custom_items_by_ckey)
		to_chat(usr, "Custom item list is null.")
		return

	if(!length(SScustomitems.custom_items_by_ckey))
		to_chat(usr, "Custom item list not populated.")
		return

	for(var/assoc_key in SScustomitems.custom_items_by_ckey)
		to_chat(usr, "[assoc_key] has:")
		var/list/current_items = SScustomitems.custom_items_by_ckey[assoc_key]
		for(var/datum/custom_item/item in current_items)
			to_chat(usr, "- name: [item.item_name] icon: [item.item_icon_state] path: [item.item_path] desc: [item.item_desc]")

/datum/admins/proc/spawn_plant(seedtype in SSplants.seeds)
	set category = "Debug"
	set desc = "Spawn a spreading plant effect."
	set name = "Spawn Plant"

	if(!check_rights(R_SPAWN))	return

	if(!seedtype || !SSplants.seeds[seedtype])
		return
	new /obj/vine(get_turf(usr), SSplants.seeds[seedtype])
	log_admin("[key_name(usr)] spawned [seedtype] vines at ([usr.x],[usr.y],[usr.z])")

/datum/admins/proc/spawn_atom(object as text)
	set category = "Debug"
	set desc = "(atom path) Spawn an atom"
	set name = "Spawn"

	if(!check_rights(R_SPAWN))	return

	var/list/types = typesof(/atom)
	var/list/matches = new()

	for(var/path in types)
		if(findtext("[path]", object))
			matches += path

	if(length(matches)==0)
		return

	var/chosen
	if(length(matches)==1)
		chosen = matches[1]
	else
		chosen = input("Select an atom type", "Spawn Atom", matches[1]) as null|anything in matches
		if(!chosen)
			return

	if(ispath(chosen,/turf))
		var/turf/T = get_turf(usr.loc)
		T.ChangeTurf(chosen)
	else
		new chosen(usr.loc)

	log_and_message_admins("spawned [chosen] at ([usr.x],[usr.y],[usr.z])")

/datum/admins/proc/spawn_artifact(effect in subtypesof(/datum/artifact_effect))
	set category = "Debug"
	set desc = "(atom path) Spawn an artifact with a specified effect."
	set name = "Spawn Artifact"

	if (!check_rights(R_SPAWN))
		return

	var/obj/machinery/artifact/A
	var/datum/artifact_trigger/primary_trigger

	var/datum/artifact_effect/secondary_effect
	var/datum/artifact_trigger/secondary_trigger

	var/damage_type

	if (ispath(effect))
		primary_trigger = input(usr, "Choose a trigger", "Choose a trigger") as null | anything in subtypesof(/datum/artifact_trigger)

		if (!ispath(primary_trigger))
			return

		var/choice = alert(usr, "Secondary effect?", "Secondary effect", "Yes", "No") == "Yes"

		if (choice)
			secondary_effect = input(usr, "Choose an effect", "Choose effect") as null | anything in subtypesof(/datum/artifact_effect)

			if (!ispath(secondary_effect))
				return

			secondary_trigger = input(usr, "Choose a trigger", "Choose a trigger") as null | anything in subtypesof(/datum/artifact_trigger)

			if (!ispath(secondary_trigger))
				return

		var/damage_types = list("Sharp" = DAMAGE_FLAG_SHARP, "Bullet" = DAMAGE_FLAG_BULLET, "Edge" = DAMAGE_FLAG_EDGE, "Laser" = DAMAGE_FLAG_LASER)
		choice = input(usr, "Choose a damage effect", "Choose Damage Effect") as null | anything in damage_types | "Invincible"

		if (!choice)
			return

		if (choice != "Invincible")
			damage_type = damage_types[choice]


		A = new(usr.loc)
		A.my_effect = new effect(A)
		A.my_effect.trigger = new primary_trigger(A.my_effect)
		A.damage_type = damage_type
		A.set_damage_description(damage_type)

		if (secondary_effect)
			A.secondary_effect = new secondary_effect
			A.secondary_effect.trigger = new secondary_trigger
		else
			QDEL_NULL(A.secondary_effect)

		log_and_message_admins("spawned an artifact with effects [A.my_effect][A.secondary_effect ? ", [A.secondary_effect]" : ""].")

/datum/admins/proc/show_traitor_panel(mob/M in SSmobs.mob_list)
	set category = "Admin"
	set desc = "Edit mobs's memory and role"
	set name = "Show Traitor Panel"

	if(!istype(M))
		to_chat(usr, "This can only be used on instances of type /mob")
		return
	if(!M.mind)
		to_chat(usr, "This mob has no mind!")
		return

	M.mind.edit_memory()

/datum/admins/proc/show_game_mode()
	set category = "Admin"
	set desc = "Show the current round configuration."
	set name = "Show Game Mode"

	if(!SSticker.mode)
		alert("Not before roundstart!", "Alert")
		return

	var/out = "[FONT_LARGE("<b>Current mode: [SSticker.mode.name] (<a href='byond://?src=\ref[SSticker.mode];debug_antag=self'>[SSticker.mode.config_tag]</a>)</b>")]<br/>"
	out += "<hr>"

	if(SSticker.mode.ert_disabled)
		out += "<b>Emergency Response Teams:</b> <a href='byond://?src=\ref[SSticker.mode];toggle=ert'>disabled</a>"
	else
		out += "<b>Emergency Response Teams:</b> <a href='byond://?src=\ref[SSticker.mode];toggle=ert'>enabled</a>"
	out += "<br/>"

	if(SSticker.mode.deny_respawn)
		out += "<b>Respawning:</b> <a href='byond://?src=\ref[SSticker.mode];toggle=respawn'>disallowed</a>"
	else
		out += "<b>Respawning:</b> <a href='byond://?src=\ref[SSticker.mode];toggle=respawn'>allowed</a>"
	out += "<br/>"

	out += "<b>Shuttle delay multiplier:</b> <a href='byond://?src=\ref[SSticker.mode];set=shuttle_delay'>[SSticker.mode.shuttle_delay]</a><br/>"

	if(SSticker.mode.auto_recall_shuttle)
		out += "<b>Shuttle auto-recall:</b> <a href='byond://?src=\ref[SSticker.mode];toggle=shuttle_recall'>enabled</a>"
	else
		out += "<b>Shuttle auto-recall:</b> <a href='byond://?src=\ref[SSticker.mode];toggle=shuttle_recall'>disabled</a>"
	out += "<br/><br/>"

	if(SSticker.mode.event_delay_mod_moderate)
		out += "<b>Moderate event time modifier:</b> <a href='byond://?src=\ref[SSticker.mode];set=event_modifier_moderate'>[SSticker.mode.event_delay_mod_moderate]</a><br/>"
	else
		out += "<b>Moderate event time modifier:</b> <a href='byond://?src=\ref[SSticker.mode];set=event_modifier_moderate'>unset</a><br/>"

	if(SSticker.mode.event_delay_mod_major)
		out += "<b>Major event time modifier:</b> <a href='byond://?src=\ref[SSticker.mode];set=event_modifier_severe'>[SSticker.mode.event_delay_mod_major]</a><br/>"
	else
		out += "<b>Major event time modifier:</b> <a href='byond://?src=\ref[SSticker.mode];set=event_modifier_severe'>unset</a><br/>"

	out += "<hr>"

	if(SSticker.mode.antag_tags && length(SSticker.mode.antag_tags))
		out += "<b>Core antag templates:</b></br>"
		for(var/antag_tag in SSticker.mode.antag_tags)
			out += "<a href='byond://?src=\ref[SSticker.mode];debug_antag=[antag_tag]'>[antag_tag]</a>.</br>"

	if(SSticker.mode.round_autoantag)
		out += "<b>Autotraitor <a href='byond://?src=\ref[SSticker.mode];toggle=autotraitor'>enabled</a></b>."
		if(SSticker.mode.antag_scaling_coeff > 0)
			out += " (scaling with <a href='byond://?src=\ref[SSticker.mode];set=antag_scaling'>[SSticker.mode.antag_scaling_coeff]</a>)"
		else
			out += " (not currently scaling, <a href='byond://?src=\ref[SSticker.mode];set=antag_scaling'>set a coefficient</a>)"
		out += "<br/>"
	else
		out += "<b>Autotraitor <a href='byond://?src=\ref[SSticker.mode];toggle=autotraitor'>disabled</a></b>.<br/>"

	out += "<b>All antag ids:</b>"
	if(SSticker.mode.antag_templates && length(SSticker.mode.antag_templates))
		for(var/datum/antagonist/antag in SSticker.mode.antag_templates)
			antag.update_current_antag_max(SSticker.mode)
			out += " <a href='byond://?src=\ref[SSticker.mode];debug_antag=[antag.id]'>[antag.id]</a>"
			out += " ([antag.get_antag_count()]/[antag.cur_max]) "
			out += " <a href='byond://?src=\ref[SSticker.mode];remove_antag_type=[antag.id]'>\[-\]</a><br/>"
	else
		out += " None."
	out += " <a href='byond://?src=\ref[SSticker.mode];add_antag_type=1'>\[+\]</a><br/>"

	show_browser(usr, out, "window=edit_mode[src]")


/datum/admins/proc/toggletintedweldhelmets()
	set category = "Debug"
	set desc="Reduces view range when wearing welding helmets"
	set name="Toggle tinted welding helmets."
	config.welder_vision = !( config.welder_vision )
	if (config.welder_vision)
		to_world("<B>Reduced welder vision has been enabled!</B>")
	else
		to_world("<B>Reduced welder vision has been disabled!</B>")
	log_and_message_admins("toggled welder vision.")

/datum/admins/proc/toggleguests()
	set category = "Server"
	set desc="Guests can't enter"
	set name="Toggle guests"
	config.guests_allowed = !(config.guests_allowed)
	if (!(config.guests_allowed))
		to_world("<B>Guests may no longer enter the game.</B>")
	else
		to_world("<B>Guests may now enter the game.</B>")
	log_admin("[key_name(usr)] toggled guests game entering [config.guests_allowed?"":"dis"]allowed.")
	log_and_message_admins("toggled guests game entering [config.guests_allowed?"":"dis"]allowed.")

/datum/admins/proc/output_ai_laws()
	var/ai_number = 0
	for(var/mob/living/silicon/S in SSmobs.mob_list)
		ai_number++
		if(isAI(S))
			to_chat(usr, "<b>AI [key_name(S, usr)]'s laws:</b>")
		else if(isrobot(S))
			var/mob/living/silicon/robot/R = S
			to_chat(usr, "<b>CYBORG [key_name(S, usr)] [R.connected_ai?"(Slaved to: [R.connected_ai])":"(Independant)"]: laws:</b>")
		else if (ispAI(S))
			to_chat(usr, "<b>pAI [key_name(S, usr)]'s laws:</b>")
		else
			to_chat(usr, "<b>SOMETHING SILICON [key_name(S, usr)]'s laws:</b>")

		if (isnull(S.laws))
			to_chat(usr, "[key_name(S, usr)]'s laws are null?? Contact a coder.")
		else
			S.laws.show_laws(usr)
	if(!ai_number)
		to_chat(usr, "<b>No AIs located</b>")//Just so you know the thing is actually working and not just ignoring you.

/datum/admins/proc/show_skills(mob/M)
	set category = null
	set name = "Skill Panel"

	if (!istype(src,/datum/admins))
		src = usr.client.holder
	if (!istype(src,/datum/admins))
		to_chat(usr, "Error: you are not an admin!")
		return

	if(!M)
		M = input("Select mob.", "Select mob.") as null|mob in GLOB.player_list
	if(!istype(M))
		return
	var/datum/nano_module/skill_ui/NM = /datum/nano_module/skill_ui
	if(isadmin(usr))
		NM = /datum/nano_module/skill_ui/admin //They get the fancy version that lets you change skills and debug stuff.
	NM = new NM(usr, override = M.skillset)
	NM.ui_interact(usr)

/client/proc/update_mob_sprite(mob/living/carbon/human/H as mob)
	set category = "Admin"
	set name = "Update Mob Sprite"
	set desc = "Should fix any mob sprite update errors."

	if (!holder)
		to_chat(src, "Only administrators may use this command.")
		return

	if(istype(H))
		H.regenerate_icons()

/proc/get_options_bar(whom, detail = 2, name = 0, link = 1, highlight_special = 1, datum/ticket/ticket = null)
	if(!whom)
		return "<b>(*null*)</b>"
	var/mob/M
	var/client/C
	if(istype(whom, /client))
		C = whom
		M = C.mob
	else if(ismob(whom))
		M = whom
		C = M.client
	else
		return "<b>(*not a mob*)</b>"
	switch(detail)
		if(0)
			return "<b>[key_name(C, link, name, highlight_special, ticket)]</b>"

		if(1)	//Private Messages
			return "<b>[key_name(C, link, name, highlight_special, ticket)](<A HREF='byond://?_src_=holder;adminmoreinfo=\ref[M]'>?</A>)</b>"

		if(2)	//Admins
			var/ref_mob = "\ref[M]"
			return "<b>[key_name(C, link, name, highlight_special, ticket)](<A HREF='byond://?_src_=holder;adminmoreinfo=[ref_mob]'>?</A>) (<A HREF='byond://?_src_=holder;adminplayeropts=[ref_mob]'>PP</A>) (<A HREF='byond://?_src_=vars;Vars=[ref_mob]'>VV</A>) (<A HREF='byond://?_src_=holder;narrateto=[ref_mob]'>DN</A>) ([admin_jump_link(M)]) (<A HREF='byond://?_src_=holder;check_antagonist=1'>CA</A>)</b>"

		if(3)	//Devs
			var/ref_mob = "\ref[M]"
			return "<b>[key_name(C, link, name, highlight_special, ticket)](<A HREF='byond://?_src_=vars;Vars=[ref_mob]'>VV</A>)([admin_jump_link(M)])</b>"

/proc/ishost(client/C)
	return check_rights(R_HOST, 0, C)

//Prevents SDQL2 commands from changing admin permissions
/datum/admins/SDQL_update(var_name, new_value)
	return 0

//
//
//ALL DONE
//*********************************************************************************************************
//

//Returns 1 to let the dragdrop code know we are trapping this event
//Returns 0 if we don't plan to trap the event
/datum/admins/proc/cmd_ghost_drag(mob/observer/ghost/frommob, mob/living/tomob)
	if(!istype(frommob))
		return //Extra sanity check to make sure only observers are shoved into things

	//Same as assume-direct-control perm requirements.
	if (!check_rights(R_VAREDIT,0) || !check_rights(R_ADMIN|R_DEBUG,0))
		return 0
	if (!frommob.ckey)
		return 0
	var/question = ""
	if (tomob.ckey)
		question = "This mob already has a user ([tomob.key]) in control of it! "
	question += "Are you sure you want to place [frommob.name]([frommob.key]) in control of [tomob.name]?"
	var/ask = alert(question, "Place ghost in control of mob?", "Yes", "No")
	if (ask != "Yes")
		return 1
	if (!frommob || !tomob) //make sure the mobs don't go away while we waited for a response
		return 1
	if(tomob.client) //No need to ghostize if there is no client
		tomob.ghostize(0)
	message_admins(SPAN_CLASS("adminnotice", "[key_name_admin(usr)] has put [frommob.ckey] in control of [tomob.name]."))
	log_admin("[key_name(usr)] stuffed [frommob.ckey] into [tomob.name].")
	tomob.ckey = frommob.ckey
	tomob.teleop = null
	qdel(frommob)
	return 1

/datum/admins/proc/force_antag_latespawn()
	set category = "Admin"
	set name = "Force Template Spawn"
	set desc = "Force an antagonist template to spawn."

	if (!istype(src,/datum/admins))
		src = usr.client.holder
	if (!istype(src,/datum/admins))
		to_chat(usr, "Error: you are not an admin!")
		return

	if(GAME_STATE < RUNLEVEL_GAME)
		to_chat(usr, "Mode has not started.")
		return

	var/list/all_antag_types = GLOB.all_antag_types_
	var/antag_type = input("Choose a template.","Force Latespawn") as null|anything in all_antag_types
	if(!antag_type || !all_antag_types[antag_type])
		to_chat(usr, "Aborting.")
		return

	var/datum/antagonist/antag = all_antag_types[antag_type]
	message_admins("[key_name(usr)] attempting to force latespawn with template [antag.id].")
	antag.attempt_auto_spawn()

/datum/admins/proc/force_mode_latespawn()
	set category = "Admin"
	set name = "Force Mode Spawn"
	set desc = "Force autotraitor to proc."

	if (!istype(src,/datum/admins))
		src = usr.client.holder
	if (!istype(src,/datum/admins) || !check_rights(R_ADMIN))
		to_chat(usr, "Error: you are not an admin!")
		return

	if(GAME_STATE < RUNLEVEL_GAME)
		to_chat(usr, "Mode has not started.")
		return

	log_and_message_admins("attempting to force mode autospawn.")
	SSticker.mode.process_autoantag()

/datum/admins/proc/paralyze_mob(mob/living/H as mob in GLOB.player_list)
	set category = null
	set name = "Toggle Paralyze"
	set desc = "Toggles paralyze state, which stuns, blinds and mutes the victim."

	var/msg

	if(!isliving(H))
		return

	if(check_rights(R_INVESTIGATE))
		if (!H.admin_paralyzed)
			H.paralysis = 8000
			H.admin_paralyzed = TRUE
			msg = "has paralyzed [key_name(H)]."
			H.visible_message(SPAN_DEBUG("OOC: \The [H] has been paralyzed by a staff member. Please hold all interactions with them until staff have finished with them."))
			to_chat(H, SPAN_DEBUG("OOC: You have been paralyzed by a staff member. Please refer to your currently open admin help ticket or, if you don't have one, admin help for assistance."))
		else
			H.paralysis = 0
			H.admin_paralyzed = FALSE
			msg = "has unparalyzed [key_name(H)]."
			H.visible_message(SPAN_DEBUG("OOC: \The [H] has been released from paralysis by staff. You may resume interactions with them."))
			to_chat(H, SPAN_DEBUG("OOC: You have been released from paralysis by staff and can return to your game."))
		log_and_message_staff(msg)


/datum/admins/proc/sendFax()
	set category = "Special Verbs"
	set name = "Send Fax"
	set desc = "Sends a fax to this machine"

	// Admin status checks
	if (!istype(src,/datum/admins))
		src = usr.client.holder
	if (!istype(src,/datum/admins))
		to_chat(usr, "Error: you are not an admin!")
		return

	// Origin
	var/list/option_list = GLOB.admin_departments.Copy() + GLOB.alldepartments.Copy() + "(Custom)" + "(Cancel)"
	var/replyorigin = input(owner, "Please specify who the fax is coming from. Choose '(Custom)' to enter a custom department or '(Cancel) to cancel.", "Fax Origin") as null|anything in option_list
	if (!replyorigin || replyorigin == "(Cancel)")
		return
	if (replyorigin == "(Custom)")
		replyorigin = input(owner, "Please specify who the fax is coming from.", "Fax Machine Department Tag") as text|null
		if (!replyorigin)
			return
	if (replyorigin == "Unknown" || replyorigin == "(Custom)" || replyorigin == "(Cancel)")
		to_chat(owner, SPAN_WARNING("Invalid origin selected."))
		return

	// Destination
	var/department = input("Choose a destination fax", "Fax Target") as null|anything in GLOB.alldepartments

	// Generate the fax
	var/obj/item/paper/admin/P = new /obj/item/paper/admin( null ) //hopefully the null loc won't cause trouble for us
	faxreply = P
	P.admindatum = src
	P.origin = replyorigin
	P.department = department
	P.destinations = get_fax_machines_by_department(department)
	P.adminbrowse()


/client/proc/check_fax_history()
	set category = "Special Verbs"
	set name = "Check Fax History"
	set desc = "Look up the faxes sent this round."

	var/data = "<center><b>Fax History:</b></center><br>"

	if(GLOB.adminfaxes)
		for(var/obj/item/item in GLOB.adminfaxes)
			data += "[item.name] - <a href='byond://?_src_=holder;AdminFaxView=\ref[item]'>view message</a><br>"
	else
		data += "<center>No faxes yet.</center>"
	show_browser(usr, "<HTML><HEAD><TITLE>Fax History</TITLE></HEAD><BODY>[data]</BODY></HTML>", "window=FaxHistory;size=450x400")

/datum/admins/var/obj/item/paper/admin/faxreply // var to hold fax replies in

/datum/admins/proc/faxCallback(obj/item/paper/admin/P)
	var/customname = input(src.owner, "Pick a title for the report", "Title") as text|null

	P.SetName("[customname]")

	var/shouldStamp = 1
	if(!P.sender) // admin initiated
		switch(alert("Would you like the fax stamped?",, "Yes", "No"))
			if("No")
				shouldStamp = 0

	if(shouldStamp)
		P.stamps += "<hr><i>This paper has been stamped by the [P.origin] Quantum Relay.</i>"

		var/image/stampoverlay = image('icons/obj/bureaucracy.dmi')
		var/x
		var/y
		x = rand(-2, 0)
		y = rand(-1, 2)
		P.offset_x += x
		P.offset_y += y
		stampoverlay.pixel_x = x
		stampoverlay.pixel_y = y

		if(!P.ico)
			P.ico = new
		P.ico += "paper_stamp-boss"
		stampoverlay.icon_state = "paper_stamp-boss"

		if(!P.stamped)
			P.stamped = new
		P.stamped += /obj/item/stamp/boss
		P.AddOverlays(stampoverlay)

	var/obj/item/rcvdcopy
	var/obj/machinery/photocopier/faxmachine/destination = P.destinations[1]
	rcvdcopy = destination.copy(P, FALSE)
	rcvdcopy.forceMove(null) //hopefully this shouldn't cause trouble
	GLOB.adminfaxes += rcvdcopy
	var/success = send_fax_loop(P, destination.department, P.origin)

	if (success)
		to_chat(src.owner, SPAN_NOTICE("Message reply to transmitted successfully."))
		if(P.sender) // sent as a reply
			log_admin("[key_name(src.owner)] replied to a fax message from [key_name(P.sender)]")
			for(var/client/C as anything in GLOB.admins)
				if((R_INVESTIGATE) & C.holder.rights)
					to_chat(C, SPAN_CLASS("log_message", "[SPAN_CLASS("prefix", "FAX LOG:")][key_name_admin(src.owner)] replied to a fax message from [key_name_admin(P.sender)] (<a href='byond://?_src_=holder;AdminFaxView=\ref[rcvdcopy]'>VIEW</a>)"))
		else
			log_admin("[key_name(src.owner)] has sent a fax message to [destination.department]")
			for(var/client/C as anything in GLOB.admins)
				if((R_INVESTIGATE) & C.holder.rights)
					to_chat(C, SPAN_CLASS("log_message", "[SPAN_CLASS("prefix", "FAX LOG:")][key_name_admin(src.owner)] has sent a fax message to [destination.department] (<a href='byond://?_src_=holder;AdminFaxView=\ref[rcvdcopy]'>VIEW</a>)"))
	else
		to_chat(src.owner, SPAN_WARNING("Message reply failed."))

	spawn(100)
		qdel(P)
		faxreply = null
	return


/datum/admins/proc/SetRoundLength()
	set category = "Server"
	set name = "Set Round Length"
	set desc = "Set how long before the initial continue vote occurs (in minutes)."
	if (GAME_STATE > RUNLEVEL_GAME)
		to_chat(usr, SPAN_WARNING("The game is already ending!"))
		return
	var/current = round(round_duration_in_ticks / 600, 0.1)
	var/response = input(usr, "Time in minutes before the continue vote will occur, or 0 to set to default.\nCurrent time: [current]m") as null | num
	current = round(round_duration_in_ticks / 600, 0.1)
	if (!isnum(response))
		return
	if (!response)
		log_and_message_admins("set the time to first continue vote to default.")
		config.vote_autotransfer_initial = initial(config.vote_autotransfer_initial)
	else if (response > current)
		log_and_message_admins("set time to first continue vote to [response] minutes.")
		config.vote_autotransfer_initial = response
		SSroundend.vote_check = (round_duration_in_ticks / 600) + response
	else
		to_chat(usr, SPAN_WARNING("You cannot set a continue vote time in the past."))

/datum/admins/proc/SetMaximumRoundLength()
	set category = "Server"
	set name = "Set Maximum Round Length"
	set desc = "Set the maximum length of a round in minutes."
	if (GAME_STATE > RUNLEVEL_GAME)
		to_chat(usr, SPAN_WARNING("The game is already ending!"))
		return
	var/current = round(round_duration_in_ticks / 600, 0.1)
	var/response = input(usr, "Time in minutes when the round will end, or 0 to disable.\nCurrent time: [current]m") as null | num
	if (!isnum(response))
		return
	if (!response)
		log_and_message_admins("disabled max round length.")
		config.maximum_round_length = response
	else if (response > current)
		log_and_message_admins("set max round length to [response] minutes.")
		config.maximum_round_length = response
	else
		to_chat(usr, SPAN_WARNING("You cannot set a max round length in the past."))


/datum/admins/proc/ToggleContinueVote()
	set category = "Server"
	set name = "Toggle Continue Vote"
	set desc = "Toggle the continue vote on/off. Toggling off will cause round-end to occur when the next continue vote time would be."
	if (GAME_STATE > RUNLEVEL_GAME)
		to_chat(usr, SPAN_WARNING("The game is already ending!"))
		return
	SSroundend.vote_check = !SSroundend.vote_check
	if (SSroundend.vote_check)
		var/interval = config.vote_autotransfer_interval
		if (!interval)
			to_chat(usr, SPAN_WARNING("Continue votes not configured."))
			SSroundend.vote_check = 0
			return
		SSroundend.vote_check = (round_duration_in_ticks / 600) + interval
	log_and_message_admins("toggled continue votes [SSroundend.vote_check ? "ON" : "OFF"]")


/datum/admins/proc/togglemoderequirementchecks()
	set category = "Server"
	set desc = "Toggle the gamemode requirement checks on/off. Toggling off will allow any gamemode to start regardless of readied players."
	set name = "Toggle Gamemode Requirement Checks"

	if (GAME_STATE > RUNLEVEL_LOBBY)
		to_chat(usr, SPAN_WARNING("You cannot change the gamemode requirement checks after the game has started!"))
		return

	SSticker.skip_requirement_checks = !SSticker.skip_requirement_checks
	log_and_message_admins("toggled the gamemode requirement checks [SSticker.skip_requirement_checks ? "OFF" : "ON"]")


/datum/admins/proc/EnableDevtools()
	set category = "Debug"
	set name = "Enable Devtools"
	set desc = "Self-enable chromium devtools on browser panes."
	if (!check_rights(R_DEBUG))
		return
	winset(usr, "", "browser-options=devtools")
