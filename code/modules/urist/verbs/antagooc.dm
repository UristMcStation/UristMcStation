var/global/normal_aooc_color = "#FF3333" //Screw british speling of color. COLOR is correct. Like math. MATH is correct. MATHS is stoopid

/client/verb/aooc(msg as text)
	set name = "AOOC"
	set category = "OOC"
	//set hidden = 1

	if(!is_special_character(usr.client.mob) && !(usr.client && usr.client.holder && !is_mentor(usr.client))) //Preventing non-antags from using it
		usr << "<span clas='warning'>You are not an Antagonist.</span>"
		return

	/*if(say_disabled)
		usr << "<span clas='warning'>Speech is currently admin-disabled.</span>"
		return*/

	if(!mob)	return //No turf can talk
	if(IsGuestKey(key))
		src << "Guests may not use AOOC."
		return

	msg = trim(copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)) //No in-chat HTML for you user!
	if(!msg)	return

	if(!is_preference_enabled(/datum/client_preference/show_ooc))
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
		/*if(handle_spam_prevention(msg,MUTE_OOC))
			return*/
		if(findtext(msg, "byond://"))
			src << "<B>Advertising other servers is not allowed.</B>"
			log_admin("[key_name(src)] has attempted to advertise in AntagOOC: [msg]")
			message_admins("[key_name_admin(src)] has attempted to advertise in AntagOOC: [msg]")
			return

	log_ooc("[mob.name]/[key]/AOOC : [msg]")

	for(var/client/C in clients)
		if(is_preference_enabled(/datum/client_preference/show_ooc))
			var/display_name = src.key
			if(holder)
				if(holder.fakekey)
					if(C.holder)
						display_name = "[holder.fakekey]/([src.key])"
					else
						display_name = holder.fakekey
			if(is_special_character(C.mob) || (C && C.holder && !is_mentor(C))) //Allows both admuns and antags to hear AOOC
				C << "<font color='[normal_aooc_color]'><span class='ooc'>" + create_text_tag("aooc", "AOOC:", C) + " <EM>[display_name]:</EM> <span class='message'>[msg]</span></span></font>"