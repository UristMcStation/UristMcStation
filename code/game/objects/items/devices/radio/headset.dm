/obj/item/device/radio/headset
	name = "radio headset"
	desc = "An updated, modular intercom that fits over the head. Takes encryption keys."
	icon = 'icons/obj/headsets.dmi'
	var/radio_desc = ""
	icon_state = "headset"
	item_state = "headset"
	matter = list(MATERIAL_ALUMINIUM = 75)
	subspace_transmission = TRUE
	canhear_range = 0 // can't hear headsets from very far away
	on = TRUE
	slot_flags = SLOT_EARS
	cell = null
	power_usage = 0
	var/translate_binary = FALSE
	var/translate_hive = 0
	var/list/encryption_keys = list()
	var/max_keys = 2

	//left for backward compatability
	var/ks1type = /obj/item/device/encryptionkey
	var/ks2type = null

	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/species/unathi/onmob_ears_unathi.dmi',
		SPECIES_RESOMI = 'icons/mob/species/resomi/ears.dmi',
		)

/obj/item/device/radio/headset/Initialize()
	. = ..()
	internal_channels.Cut()
	for(var/T in encryption_keys)
		if(ispath(T))
			encryption_keys = new T(src)
	if(ks1type)
		encryption_keys += new ks1type(src)
	if(ks2type)
		encryption_keys += new ks2type(src)
	recalculateChannels(1)

/obj/item/device/radio/headset/Destroy()
	QDEL_NULL_LIST(encryption_keys)
	return ..()

/obj/item/device/radio/headset/list_channels(mob/user)
	return list_secure_channels()

/obj/item/device/radio/headset/examine(mob/user, distance)
	. = ..()
	if(distance > 1 || !radio_desc)
		return

	to_chat(user, radio_desc)

/obj/item/device/radio/headset/handle_message_mode(mob/living/M as mob, message, channel)
	if (channel == "special")
		if (translate_binary)
			var/datum/language/binary = all_languages[LANGUAGE_ROBOT_GLOBAL]
			binary.broadcast(M, message)
		if (translate_hive)
			var/datum/language/hivemind = all_languages[LANGUAGE_XENOPHAGE_GLOBAL]
			hivemind.broadcast(M, message)
		return null

	return ..()

/obj/item/device/radio/headset/receive_range(freq, level, aiOverride = 0)
	if (aiOverride)
		return ..(freq, level)
	if(ishuman(src.loc))
		var/mob/living/carbon/human/H = src.loc
		if(H.l_ear == src || H.r_ear == src)
			return ..(freq, level)
	return -1

/obj/item/device/radio/headset/map_preset
	var/preset_name
	var/encryption_key = /obj/item/device/encryptionkey
	var/use_common = FALSE

/obj/item/device/radio/headset/map_preset/Initialize()
	if (preset_name)
		var/name_lower = lowertext(preset_name)
		name = "[name_lower] radio headset"
		ks1type = encryption_key
		default_frequency = assign_away_freq(preset_name)
		if (use_common)
			frequency = PUB_FREQ
		else
			frequency = default_frequency
	. = ..()

/obj/item/device/radio/headset/syndicate
	origin_tech = list(TECH_ESOTERIC = 3)
	syndie = 1
	ks1type = /obj/item/device/encryptionkey/syndicate

/obj/item/device/radio/headset/syndicate/alt
	icon_state = "syndie_headset"
	item_state = "syndie_headset"

/obj/item/device/radio/headset/syndicate/Initialize()
	. = ..()
	set_frequency(SYND_FREQ)

/obj/item/device/radio/headset/raider
	origin_tech = list(TECH_ESOTERIC = 2)
	syndie = 1
	ks1type = /obj/item/device/encryptionkey/raider

/obj/item/device/radio/headset/raider/Initialize()
	. = ..()
	set_frequency(RAID_FREQ)

/obj/item/device/radio/headset/vox_raider
	ks1type = /obj/item/device/encryptionkey/vox_raider

/obj/item/device/radio/headset/vox_raider/Initialize()
	. = ..()
	set_frequency(V_RAID_FREQ)

/obj/item/device/radio/headset/binary
	origin_tech = list(TECH_ESOTERIC = 3)
	ks1type = /obj/item/device/encryptionkey/binary

/obj/item/device/radio/headset/headset_sec
	name = "security radio headset"
	desc = "This is used by your elite security force."
	icon_state = "sec_headset"
	item_state = "headset"
	ks1type = /obj/item/device/encryptionkey/headset_sec

/obj/item/device/radio/headset/headset_sec/alt
	name = "security bowman headset"
	icon_state = "sec_headset_alt"
	item_state = "sec_headset_alt"

/obj/item/device/radio/headset/headset_eng
	name = "engineering radio headset"
	desc = "When the engineers wish to chat like girls."
	icon_state = "eng_headset"
	item_state = "headset"
	ks1type = /obj/item/device/encryptionkey/headset_eng

/obj/item/device/radio/headset/headset_eng/alt
	name = "engineering bowman headset"
	icon_state = "eng_headset_alt"
	item_state = "eng_headset_alt"

/obj/item/device/radio/headset/headset_rob
	name = "robotics radio headset"
	desc = "Made specifically for the roboticists who cannot decide between departments."
	icon_state = "rob_headset"
	item_state = "headset"
	ks1type = /obj/item/device/encryptionkey/headset_rob

/obj/item/device/radio/headset/headset_med
	name = "medical radio headset"
	desc = "A headset for the trained staff of the medbay."
	icon_state = "med_headset"
	item_state = "headset"
	ks1type = /obj/item/device/encryptionkey/headset_med

/obj/item/device/radio/headset/headset_med/alt
	name = "medical bowman headset"
	icon_state = "med_headset_alt"
	item_state = "med_headset_alt"

/obj/item/device/radio/headset/headset_sci
	name = "science radio headset"
	desc = "A sciency headset. Like usual."
	icon_state = "com_headset"
	item_state = "headset"
	ks1type = /obj/item/device/encryptionkey/headset_sci

/obj/item/device/radio/headset/headset_medsci
	name = "medical research radio headset"
	desc = "A headset that is a result of the mating between medical and science."
	icon_state = "med_headset"
	item_state = "headset"
	ks1type = /obj/item/device/encryptionkey/headset_medsci

/obj/item/device/radio/headset/headset_com
	name = "command radio headset"
	desc = "A headset with a commanding channel."
	icon_state = "com_headset"
	item_state = "headset"
	ks1type = /obj/item/device/encryptionkey/headset_com

/obj/item/device/radio/headset/headset_com/alt
	name = "command bowman headset"
	desc = "A headset with a commanding channel."
	icon_state = "com_headset_alt"
	item_state = "com_headset_alt"
	ks1type = /obj/item/device/encryptionkey/headset_com
	max_keys = 3

/obj/item/device/radio/headset/merchant
	name = "merchant headset"
	desc = "A headset utilizing the universal hailing frequency."
	frequency = HAIL_FREQ
	ks1type = /obj/item/device/encryptionkey/merchant

/obj/item/device/radio/headset/heads/captain
	name = "captain's headset"
	desc = "The headset of the boss."
	icon_state = "com_headset"
	item_state = "headset"
	ks1type = /obj/item/device/encryptionkey/heads/captain

/obj/item/device/radio/headset/heads/captain/alt
	name = "captain's bowman headset"
	icon_state = "com_headset_alt"
	item_state = "com_headset_alt"
	max_keys = 3

/obj/item/device/radio/headset/heads/ai_integrated //No need to care about icons, it should be hidden inside the AI anyway.
	name = "\improper AI subspace transceiver"
	desc = "Integrated AI radio transceiver."
	icon = 'icons/obj/robot_component.dmi'
	icon_state = "radio"
	item_state = "headset"
	ks1type = /obj/item/device/encryptionkey/heads/ai_integrated
	var/myAi = null    // Atlantis: Reference back to the AI which has this radio.
	var/disabledAi = 0 // Atlantis: Used to manually disable AI's integrated radio via inteliCard menu.

/obj/item/device/radio/headset/heads/ai_integrated/Destroy()
	myAi = null
	. = ..()

/obj/item/device/radio/headset/heads/ai_integrated/receive_range(freq, level)
	if (disabledAi)
		return -1 //Transciever Disabled.
	return ..(freq, level, 1)

/obj/item/device/radio/headset/heads/rd
	name = "chief science officer's headset"
	desc = "Headset of the researching God."
	icon_state = "com_headset"
	item_state = "headset"
	ks1type = /obj/item/device/encryptionkey/heads/rd

/obj/item/device/radio/headset/heads/hos
	name = "head of security's headset"
	desc = "The headset of the man who protects your worthless lives."
	icon_state = "com_headset"
	item_state = "headset"
	ks1type = /obj/item/device/encryptionkey/heads/hos

/obj/item/device/radio/headset/heads/ce
	name = "chief engineer's headset"
	desc = "The headset of the guy who is in charge of morons."
	icon_state = "com_headset"
	item_state = "headset"
	ks1type = /obj/item/device/encryptionkey/heads/ce

/obj/item/device/radio/headset/heads/ce/alt
	name = "chief engineer's bowman headset"
	icon_state = "com_headset_alt"
	item_state = "com_headset_alt"

/obj/item/device/radio/headset/heads/cmo
	name = "chief medical officer's headset"
	desc = "The headset of the highly trained medical chief."
	icon_state = "com_headset"
	item_state = "headset"
	ks1type = /obj/item/device/encryptionkey/heads/cmo

/obj/item/device/radio/headset/heads/cmo/alt
	name = "chief medical officer's bowman headset"
	icon_state = "com_headset_alt"
	item_state = "com_headset_alt"

/obj/item/device/radio/headset/heads/hop
	name = "head of personnel's headset"
	desc = "The headset of the guy who will one day be captain."
	icon_state = "com_headset"
	item_state = "headset"
	ks1type = /obj/item/device/encryptionkey/heads/hop

/obj/item/device/radio/headset/headset_service
	name = "service radio headset"
	desc = "Headset used by the service staff, tasked with keeping everyone full, happy and clean."
	icon_state = "srv_headset"
	item_state = "headset"
	ks1type = /obj/item/device/encryptionkey/headset_service

/obj/item/device/radio/headset/foundation
	name = "\improper Foundation radio headset"
	desc = "The headeset of the occult cavalry."
	icon_state = "com_headset"
	item_state = "headset"
	ks1type = /obj/item/device/encryptionkey/ert

/obj/item/device/radio/headset/foundation
	name = "\improper Foundation radio headset"
	desc = "The headeset of the occult cavalry."
	icon_state = "com_headset"
	item_state = "headset"
	ks1type = /obj/item/device/encryptionkey/ert

/obj/item/device/radio/headset/ia
	name = "internal affair's headset"
	desc = "The headset of your worst enemy."
	icon_state = "com_headset"
	item_state = "headset"
	ks1type = /obj/item/device/encryptionkey/heads/hos

/obj/item/device/radio/headset/headset_mining
	name = "mining radio headset"
	desc = "Headset used by dwarves. It has an inbuilt subspace antenna for better reception."
	icon_state = "mine_headset"
	item_state = "headset"
	ks1type = /obj/item/device/encryptionkey/headset_mining

/obj/item/device/radio/headset/headset_mining/alt
	name = "mining bowman radio headset"
	icon_state = "mine_headset_alt"
	item_state = "mine_headset_alt"
	max_keys = 3

/obj/item/device/radio/headset/headset_cargo
	name = "supply radio headset"
	desc = "A headset used by the box-pushers."
	icon_state = "cargo_headset"
	item_state = "headset"
	ks1type = /obj/item/device/encryptionkey/headset_cargo

/obj/item/device/radio/headset/headset_cargo/alt
	name = "supply bowman headset"
	icon_state = "cargo_headset_alt"
	item_state = "cargo_headset_alt"
	max_keys = 3

/obj/item/device/radio/headset/entertainment
	name = "actor's radio headset"
	desc = "specially made to make you sound less cheesy."
	icon_state = "com_headset"
	item_state = "headset"
	ks1type = /obj/item/device/encryptionkey/entertainment

/obj/item/device/radio/headset/specops
	name = "special operations radio headset"
	desc = "The headset of the spooks."
	icon_state = "cent_headset"
	item_state = "headset"
	ks1type = /obj/item/device/encryptionkey/specops


/obj/item/device/radio/headset/use_tool(obj/item/tool, mob/user, list/click_params)
	// Encryption Key - Install key
	if (istype(tool, /obj/item/device/encryptionkey))
		if (length(encryption_keys) >= max_keys)
			USE_FEEDBACK_FAILURE("\The [src] can't hold any more encryption keys.")
			return TRUE
		if (!user.unEquip(tool, src))
			FEEDBACK_UNEQUIP_FAILURE(user, tool)
			return TRUE
		encryption_keys += tool
		recalculateChannels(TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] inserts \a [tool] into \a [src]."),
			SPAN_NOTICE("You insert \the [tool] into \the [src]."),
			range = 2
		)
		return TRUE

	// Screwdriver - Remove encryption keys
	if (isScrewdriver(tool))
		if (!length(encryption_keys))
			USE_FEEDBACK_FAILURE("\The [src] has no encryption keys to remove.")
			return TRUE
		for (var/channel_name in channels)
			radio_controller.remove_object(src, radiochannels[channel_name])
			secure_radio_connections[channel_name] = null
		for (var/obj/key as anything in encryption_keys)
			key.dropInto(get_turf(user))
		encryption_keys.Cut()
		recalculateChannels(TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] pops \a [src]'s encryption keys out with \a [tool]."),
			SPAN_NOTICE("You pop \the [src]'s encryption keys out with \the [tool]."),
			range = 2
		)
		return TRUE

	return ..()


/obj/item/device/radio/headset/MouseDrop(obj/over_object)
	var/mob/M = usr
	if((!istype(over_object, /obj/screen)) && (src in M) && CanUseTopic(M))
		return attack_self(M)
	return

/obj/item/device/radio/headset/recalculateChannels(setDescription = 0)
	src.channels = list()
	src.translate_binary = 0
	src.translate_hive = 0
	src.syndie = 0
	for(var/obj/ekey in encryption_keys)
		import_key_data(ekey)
	for (var/ch_name in channels)
		if(!radio_controller)
			src.SetName("broken radio headset")
			return
		secure_radio_connections[ch_name] = radio_controller.add_object(src, radiochannels[ch_name],  RADIO_CHAT)

	if(setDescription)
		radio_desc = get_channels_as_string()

/obj/item/device/radio/headset/proc/import_key_data(obj/item/device/encryptionkey/key)
	if(!key)
		return
	for(var/ch_name in key.channels)
		if(ch_name in src.channels)
			continue
		src.channels[ch_name] = key.channels[ch_name]
	if(key.translate_binary)
		src.translate_binary = 1
	if(key.translate_hive)
		src.translate_hive = 1
	if(key.syndie)
		src.syndie = 1
