var/global/normal_aooc_colour = "#FF0000"

/client/verb/aooc(msg as text)
	set name = "AOOC"
	set category = "OOC"

	if(!is_special_character(usr.client.mob) && !(usr.client && usr.client.holder && !is_mentor(usr.client)))
		usr << "<span clas='warning'>You are not an Antagonist.</span>"
		return

	if(say_disabled)
		usr << "<span clas='warning'>Speech is currently admin-disabled.</span>"
		return

	if(!mob)	return
	if(IsGuestKey(key))
		src << "Guests may not use AOOC."
		return

	msg = trim(copytext(sanitize(msg), 1, MAX_MESSAGE_LEN))
	if(!msg)	return

	if(!(prefs.toggles & CHAT_OOC))
		src << "<span clas='warning'>You have OOC muted.</span>"
		return

	if(!holder)
		if(!config.ooc_allowed)
			src << "<span clas='warning'>OOC is globally muted</span>"
			return
		if(!config.dooc_allowed && (mob.stat == DEAD))
			usr << "<span clas='warning'>OOC for dead mobs has been turned off.</span>"
			return
		if(prefs.muted & MUTE_OOC)
			src << "<span clas='warning'>You cannot use OOC (muted).</span>"
			return
		if(handle_spam_prevention(msg,MUTE_OOC))
			return
		if(findtext(msg, "byond://"))
			src << "<B>Advertising other servers is not allowed.</B>"
			log_admin("[key_name(src)] has attempted to advertise in AntagOOC: [msg]")
			message_admins("[key_name_admin(src)] has attempted to advertise in AntagOOC: [msg]")
			return

	log_ooc("[mob.name]/[key]/AOOC : [msg]")

/*
	var/display_colour = normal_ooc_colour
	if(holder && !holder.fakekey)
		display_colour = "#FF3333"	//light red
		usr << "LIGHT RED"
		if(holder.rights & R_MOD && !(holder.rights & R_ADMIN))
			display_colour = "#990000"	//dark red
			usr << "DARK RED"
		if(holder.rights & R_DEBUG && !(holder.rights & R_ADMIN))
			display_colour = "#FF8080"	//pank
			usr << "PANK"
		else if(holder.rights & R_ADMIN)
			if(config.allow_admin_ooccolor)
				display_colour = src.prefs.ooccolor
			else
				display_colour = "#FF9900"	//orange
				usr << "ORANG"
*/


	for(var/client/C in clients)
		if(C.prefs.toggles & CHAT_OOC)
			var/display_name = src.key
			if(holder)
				if(holder.fakekey)
					if(C.holder)
						display_name = "[holder.fakekey]/([src.key])"
					else
						display_name = holder.fakekey
			if(is_special_character(C.mob) || (C && C.holder && !is_mentor(C))) //Allows both admuns and antags to hear AOOC
				C << "<font color='#FF3333'><span class='ooc'><span class='prefix'>AOOC:</span> <EM>[display_name]:</EM> <span class='message'>[msg]</span></span></font>"