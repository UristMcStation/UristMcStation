//BS12 Explosive
/obj/item/implant/explosive
	name = "explosive implant"
	desc = "A military grade micro bio-explosive. Highly dangerous."
	icon_state = "implant_evil"
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 2, TECH_ESOTERIC = 3)
	hidden = 1
	var/elevel
	var/phrase
	var/code = 13
	var/frequency = 1443
	var/datum/radio_frequency/radio_connection
	var/warning_message = "Tampering detected. Tampering detected."

/obj/item/implant/explosive/get_data()
	. = {"
	<b>Implant Specifications:</b><BR>
	<b>Name:</b> Robust Corp RX-78 Intimidation Class Implant<BR>
	<b>Life:</b> Activates upon codephrase.<BR>
	<b>Important Notes:</b> Explodes<BR>
	<HR>
	<b>Implant Details:</b><BR>
	<b>Function:</b> Contains a compact, electrically detonated explosive that detonates upon receiving a specially encoded signal or upon host death.<BR>
	<b>Special Features:</b> Explodes<BR>
	<b>Integrity:</b> Implant will occasionally be degraded by the body's immune system and thus will occasionally malfunction."}
	if(!malfunction)
		. += {"
		<HR><B>Explosion yield mode:</B><BR>
		<A href='byond://?src=\ref[src];mode=1'>[elevel ? elevel : "NONE SET"]</A><BR>
		<B>Activation phrase:</B><BR>
		<A href='byond://?src=\ref[src];phrase=1'>[phrase ? phrase : "NONE SET"]</A><BR>
		<B>Frequency:</B><BR>
		<A href='byond://?src=\ref[src];freq=-10'>-</A>
		<A href='byond://?src=\ref[src];freq=-2'>-</A>
		[format_frequency(src.frequency)]
		<A href='byond://?src=\ref[src];freq=2'>+</A>
		<A href='byond://?src=\ref[src];freq=10'>+</A><BR>
		<B>Code:</B><BR>
		<A href='byond://?src=\ref[src];code=-5'>-</A>
		<A href='byond://?src=\ref[src];code=-1'>-</A>
		<A href='byond://?src=\ref[src];code=set'>[src.code]</A>
		<A href='byond://?src=\ref[src];code=1'>+</A>
		<A href='byond://?src=\ref[src];code=5'>+</A><BR>
		<B>Tampering warning message:</B><BR>
		This will be broadcasted on radio if implant is exposed during surgery.<BR>
		<A href='byond://?src=\ref[src];msg=1'>[warning_message ? warning_message : "NONE SET"]</A>
		"}

/obj/item/implant/explosive/Initialize()
	. = ..()
	GLOB.listening_objects += src
	set_frequency(frequency)

/obj/item/implant/explosive/Topic(href, href_list)
	..()
	if (href_list["freq"])
		var/new_frequency = frequency + text2num(href_list["freq"])
		new_frequency = sanitize_frequency(new_frequency, RADIO_LOW_FREQ, RADIO_HIGH_FREQ)
		set_frequency(new_frequency)
		interact(usr)
	if (href_list["code"])
		var/adj = text2num(href_list["code"])
		if(!adj)
			code = input("Set radio activation code","Radio activation") as num
		else
			code += adj
		code = clamp(code,1,100)
		interact(usr)
	if (href_list["mode"])
		var/mod = input("Set explosion mode", "Explosion mode") as null|anything in list("Localized Limb", "Destroy Body", "Full Explosion")
		if(mod)
			elevel = mod
		interact(usr)
	if (href_list["msg"])
		var/msg = input("Set tampering message, or leave blank for no broadcasting.", "Anti-tampering", warning_message) as text|null
		if(msg)
			warning_message = msg
		interact(usr)
	if (href_list["phrase"])
		var/talk = input("Set activation phrase", "Audio activation", phrase) as text|null
		if(talk)
			phrase = sanitize_phrase(talk)
		interact(usr)

/obj/item/implant/explosive/receive_signal(datum/signal/signal)
	if(signal && signal.encryption == code)
		activate()

/obj/item/implant/explosive/proc/set_frequency(new_frequency)
	radio_controller.remove_object(src, frequency)
	frequency = new_frequency
	radio_connection = radio_controller.add_object(src, frequency, RADIO_CHAT)

/obj/item/implant/explosive/hear_talk(mob/M as mob, msg)
	hear(msg)

/obj/item/implant/explosive/hear(msg)
	if(!phrase)
		return
	if(findtext(sanitize_phrase(msg),phrase))
		activate()
		qdel(src)

/obj/item/implant/explosive/exposed()
	if(warning_message)
		GLOB.global_headset.autosay(warning_message, "Anti Tampering System", "Common")

/obj/item/implant/explosive/proc/sanitize_phrase(phrase)
	var/list/replacechars = list("'" = "","\"" = "",">" = "","<" = "","(" = "",")" = "")
	return replace_characters(phrase, replacechars)

/obj/item/implant/explosive/activate()
	if (malfunction)
		return

	var/turf/T = get_turf(src)
	if(T)
		T.hotspot_expose(3500)

	playsound(loc, 'sound/items/countdown.ogg', 75, 1, -3)
	if(ismob(imp_in))
		imp_in.audible_message(SPAN_WARNING("Something beeps inside [imp_in][part ? "'s [part.name]" : ""]!"))
		log_and_message_admins("Explosive implant triggered in [imp_in] ([imp_in.key])", null, imp_in)
	else
		audible_message(SPAN_WARNING("[src] beeps omniously!"))
		log_and_message_admins("Explosive implant triggered in [T.loc]", null, imp_in)

	if(!elevel)
		elevel = "Full Explosion"
	switch(elevel)
		if ("Localized Limb")
			if (part)
				if (istype(part,/obj/item/organ/external/chest) ||	\
					istype(part,/obj/item/organ/external/groin))
					part.take_external_damage(60, used_weapon = "Explosion")
				else
					part.droplimb(0,DROPLIMB_BLUNT)
			explosion(T, 2, EX_ACT_LIGHT)
		if ("Destroy Body")
			explosion(T, 1, EX_ACT_LIGHT)
			if(ismob(imp_in))
				imp_in.gib()
		if ("Full Explosion")
			explosion(T, 4, EX_ACT_HEAVY)
			if(ismob(imp_in))
				imp_in.gib()
	qdel(src)

/obj/item/implant/explosive/implanted(mob/target)
	if(!elevel)
		elevel = alert("What sort of explosion would you prefer?", "Implant Intent", "Localized Limb", "Destroy Body", "Full Explosion")
	if(!phrase)
		phrase = sanitize_phrase(input("Choose activation phrase:") as text)
	if(!phrase)
		return

	var/memo = "Explosive implant in [target] can be activated by saying something containing the phrase ''[phrase]'', <B>say [phrase]</B> to attempt to activate. It can also be triggered with a radio signal on frequency <b>[format_frequency(src.frequency)]</b> with code <b>[code]</b>."
	usr.StoreMemory(memo, /singleton/memory_options/system)
	to_chat(usr, memo)
	return TRUE

/obj/item/implant/explosive/Destroy()
	removed()
	GLOB.listening_objects -= src
	return ..()

/obj/item/implanter/explosive
	name = "implanter (E)"
	imp = /obj/item/implant/explosive

/obj/item/implantcase/explosive
	name = "glass case - 'explosive'"
	imp = /obj/item/implant/explosive
