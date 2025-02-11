// Thanks to Burger from Burgerstation for the foundation for this
//further thanks to Nebula, where I ported this to Urist from
var/global/list/floating_chat_colors = list()

/atom/movable
	var/list/stored_chat_text

/atom/movable/proc/animate_chat(message, datum/language/language, small, list/show_to, list/whisper_to, duration)
	set waitfor = FALSE

/*	// Get rid of any URL schemes that might cause BYOND to automatically wrap something in an anchor tag
	var/static/regex/url_scheme = new(@"[A-Za-z][A-Za-z0-9+-\.]*:\/\/", "g")
	message = replacetext(message, url_scheme, "")

	var/static/regex/html_metachars = new(@"&[A-Za-z]{1,7};", "g")
	message = replacetext(message, html_metachars, "")
*/
	var/style	//additional style params for the message
	var/fontsize = 6
	if(small)
		fontsize = 5
	var/limit = 90
	if(copytext(message, length(message) - 1) in list("!!","?!"))
		fontsize = 8
		limit = 30
		style += "font-weight: bold;"

	if(length(message) > limit)
		message = "[copytext(message, 1, limit)]..."

	if(!floating_chat_colors[name])
		floating_chat_colors[name] = get_random_colour(0,160,230)
	style += "color: [floating_chat_colors[name]];"

	if(length(whisper_to))
		show_to -= whisper_to
		var/image/whisper = generate_floating_text(src, stars(message), style, fontsize, duration, whisper_to)
		for(var/client/C in whisper_to)
			if(!C.mob.is_deaf() && C.get_preference_value(/datum/client_preference/floating_messages) == GLOB.PREF_SHOW)
				C.images += whisper

	// create 2 messages, one that appears if you know the language, and one that appears when you don't know the language
	var/image/understood = generate_floating_text(src, capitalize(message), style, fontsize, duration, show_to)
	var/image/gibberish = generate_floating_text(src, language ? language.scramble(message) : stars(message), style, fontsize, duration, show_to)

	for(var/client/C in show_to)
		if(!C.mob.is_deaf() && C.get_preference_value(/datum/client_preference/floating_messages) == GLOB.PREF_SHOW)
			if(C.mob.say_understands(src, language))
				C.images += understood
			else
				C.images += gibberish

/proc/generate_floating_text(atom/movable/holder, message, style, size, duration, show_to)
	var/image/I = image(null, holder)
	I.plane = HUD_PLANE
	I.layer = HUD_ABOVE_ITEM_LAYER
	I.alpha = 0
	I.maptext_width = 92
	I.maptext_height = 64
	I.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA
	I.plane = EFFECTS_ABOVE_LIGHTING_PLANE
	I.pixel_x = -round(I.maptext_width/2) + 16

	style = "font-family: 'Small Fonts'; -dm-text-outline: 1 black; font-size: [size]px; [style]"
	I.maptext = "<center><span style=\"[style]\">[message]</span></center>"
	animate(I, 1, alpha = 255, pixel_y = 24)

	for(var/image/old in holder.stored_chat_text)
		animate(old, 2, pixel_y = old.pixel_y + 8)
	LAZYADD(holder.stored_chat_text, I)

	addtimer(new Callback(GLOBAL_PROC, .proc/remove_floating_text, holder, I), duration)
	addtimer(new Callback(GLOBAL_PROC, .proc/remove_images_from_clients, I, show_to), duration + 2)

	return I

/proc/remove_floating_text(atom/movable/holder, image/I)
	animate(I, 2, pixel_y = I.pixel_y + 10, alpha = 0)
	LAZYREMOVE(holder.stored_chat_text, I)
